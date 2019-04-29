import 'dart:async';

import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

import 'profile_state.dart';

// TODO: refactor event class to extend BlocEvent

class _ProfileEvent {}

class _ProfileLogOutEvent extends _ProfileEvent {}

class _SettingsChangedEvent extends _ProfileEvent {
  final Settings settings;

  _SettingsChangedEvent(this.settings);
}

class _ToggleNotificationsEvent extends _ProfileEvent {}

class _UFSCConnectedEvent extends _ProfileEvent {
  final String code;
  final String state;

  _UFSCConnectedEvent(this.code, this.state);
}

class ProfileBloc extends Bloc<_ProfileEvent, ProfileState> {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final LinkRepository _link = inject();
  final NotificationsService _notifications = inject();
  StreamSubscription<Uri> _linksSubscription;
  StreamSubscription<Settings> _settingsSubscription;

  ProfileBloc() {
    _setupNotifications();
    _initUniLinks();
    _trackUserData();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(_ProfileEvent event) async* {
    if (event is _ProfileLogOutEvent) yield* _logoutToState();
    if (event is _UFSCConnectedEvent) yield* _connectedToState(event);
    if (event is _SettingsChangedEvent) yield* _settingsChangedToState(event);
    if (event is _ToggleNotificationsEvent)
      yield* _toggleNotificationsToState();
  }

  Stream<ProfileState> _connectedToState(_UFSCConnectedEvent event) async* {}

  Stream<ProfileState> _toggleNotificationsToState() async* {
    final settings = currentState.settings;
    final newNotificationsState = !settings.allowNotifications;
    _userData.saveSettings(
      settings.rebuild((b) => b..allowNotifications = newNotificationsState),
    );
    _setupNotifications();
  }

  Stream<ProfileState> _settingsChangedToState(
    _SettingsChangedEvent event,
  ) async* {
    final user = await _userData.currentUser;
    yield currentState.rebuild(
      (b) => b..settings.replace(event.settings)..user.replace(user),
    );
  }

  Stream<ProfileState> _logoutToState() async* {
    await _removeNotifications();
    yield ProfileState.login();
    _auth.signOut();
  }

  @override
  dispose() {
    _linksSubscription?.cancel();
    _settingsSubscription?.cancel();
    _notifications.dispose();
    super.dispose();
  }

  logOut() => dispatch(_ProfileLogOutEvent());

  void toggleNotifications(bool value) => dispatch(_ToggleNotificationsEvent());

  Future<void> _initUniLinks() async {
    _linksSubscription = _link.uriLinksStream.listen((Uri uri) {
      final params = uri.queryParameters;
      final code = params['code'];
      final state = params['state'];
      dispatch(_UFSCConnectedEvent(code, state));
    });
  }

  Future<void> _setupNotifications() async {
    final allowNotifications = (await _userData.settings).allowNotifications;
    if (allowNotifications) {
      final subjects = await _userData.subjects;
      final notificationsToken = await _notifications.token;
      if (subjects != null) _notifications.addNotifications(subjects);
      _userData.updateNotificationsToken(notificationsToken);
    } else {
      await _removeNotifications();
    }
  }

  Future<void> _removeNotifications() async {
    await _userData.updateNotificationsToken(null);
    _notifications.removeAllNotifications();
  }

  Future<void> _trackUserData() async {
    final settingsStream = await _userData.settingsStream;
    _settingsSubscription = settingsStream?.listen((settings) => dispatch(
          _SettingsChangedEvent(settings),
        ));
  }
}
