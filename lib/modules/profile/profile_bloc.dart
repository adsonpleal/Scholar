import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/base/base_bloc.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';

import 'profile_state.dart';

enum _ProfileEvent {
  logOut,
  settingsChanged,
  restaurantsChanged,
  toggleNotifications,
}

class ProfileBloc extends BaseBloc<_ProfileEvent, ProfileState> {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final NotificationsService _notifications = inject();
  final RestaurantsRepository _restaurantsRepository = inject();
  StreamSubscription<Settings> _settingsSubscription;
  StreamSubscription<List<Restaurant>> _restaurantsSubscription;

  ProfileBloc() {
    _setupNotifications();
    _trackUserData();
    _trackRestaurants();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapToState(_ProfileEvent event, payload) async* {
    switch (event) {
      case _ProfileEvent.logOut:
        yield* _logoutToState();
        break;
      case _ProfileEvent.settingsChanged:
        yield* _settingsChangedToState(payload);
        break;
      case _ProfileEvent.toggleNotifications:
        yield* _toggleNotificationsToState();
        break;
      case _ProfileEvent.restaurantsChanged:
        yield* _restaurantsChangedToState(payload);
        break;
    }
  }

  Stream<ProfileState> _toggleNotificationsToState() async* {
    final settings = currentState.settings;
    final newNotificationsState = !settings.allowNotifications;
    _userData.saveSettings(
      settings.rebuild((b) => b..allowNotifications = newNotificationsState),
    );
    _setupNotifications();
  }

  Stream<ProfileState> _settingsChangedToState(Settings settings) async* {
    final user = await _userData.currentUser;
    yield currentState.rebuild(
      (b) => b..settings.replace(settings)..user.replace(user),
    );
  }

  Stream<ProfileState> _restaurantsChangedToState(
    List<Restaurant> restaurants,
  ) async* {
    yield currentState.rebuild((b) => b..restaurants = restaurants);
  }

  Stream<ProfileState> _logoutToState() async* {
    await _removeNotifications();
    yield ProfileState.login();
    _auth.signOut();
  }

  @override
  dispose() {
    _restaurantsSubscription?.cancel();
    _settingsSubscription?.cancel();
    _notifications.dispose();
    super.dispose();
  }

  void logOut() => dispatchEvent(type: _ProfileEvent.logOut);

  void toggleNotifications(bool value) {
    dispatchEvent(type: _ProfileEvent.toggleNotifications);
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

  void _trackUserData() {
    _settingsSubscription = _userData.settingsStream?.listen(
      (settings) => dispatchEvent(
            type: _ProfileEvent.settingsChanged,
            payload: settings,
          ),
    );
  }

  void _trackRestaurants() {
    _restaurantsSubscription = _restaurantsRepository.restaurantsStream?.listen(
      (restaurants) => dispatchEvent(
            type: _ProfileEvent.restaurantsChanged,
            payload: restaurants,
          ),
    );
  }

  void onRestaurantChanged(Restaurant value) {
    _userData.saveSettings(
      currentState.settings.rebuild((b) => b..restaurantId = value.documentID),
    );
  }
}
