import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/ufsc/ufsc_service.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'profile_state.dart';

part 'profile_bloc.g.dart';

@GenerateBloc(ProfileState)
class ProfileBloc extends _$Bloc {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final UfscService _ufscService = inject();
  final NotificationsService _notifications = inject();
  final RestaurantsRepository _restaurantsRepository = inject();
  StreamSubscription<Settings> _settingsSubscription;
  StreamSubscription<List<Restaurant>> _restaurantsSubscription;
  StreamSubscription<bool> _loadingUfscSubscription;

  ProfileBloc() {
    _setupNotifications();
    _trackUserData();
    _trackRestaurants();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  Stream<ProfileState> _mapToggleNotificationsToState() async* {
    final settings = currentState.settings;
    final newNotificationsState = !settings.allowNotifications;
    _userData.saveSettings(
      settings.rebuild((b) => b..allowNotifications = newNotificationsState),
    );
    _setupNotifications();
  }

  Stream<ProfileState> _mapSettingsChangedToState(Settings settings) async* {
    final user = await _userData.currentUser;
    yield currentState.rebuild(
      (b) => b..settings.replace(settings)..user.replace(user),
    );
  }

  Stream<ProfileState> _mapRestaurantsChangedToState(
    List<Restaurant> restaurants,
  ) async* {
    yield currentState.rebuild((b) => b..restaurants = restaurants);
  }

  Stream<ProfileState> _mapLoadingChangedToState(
    bool loading,
  ) async* {
    yield currentState.rebuild((b) => b..loading = loading);
  }

  Stream<ProfileState> _mapLogoutToState() async* {
    await _removeNotifications();
    yield ProfileState.login();
    _auth.signOut();
  }

  void launchAuthorization() {
    _loadingUfscSubscription = _ufscService.launchAuthorization().listen(
          dispatchLoadingChangedEvent,
        );
  }

  void launchContactEmail() {
    launch("mailto:contato.scholar@gmail.com");
  }

  @override
  dispose() {
    _restaurantsSubscription?.cancel();
    _settingsSubscription?.cancel();
    _loadingUfscSubscription?.cancel();
    _ufscService.dispose();
    _notifications.dispose();
    super.dispose();
  }

  Future<void> _setupNotifications() async {
    final allowNotifications = (await _userData.settings).allowNotifications;
    if (allowNotifications) {
      final schedules = await _userData.schedules;
      final notificationsToken = await _notifications.token;
      if (schedules != null) _notifications.addNotifications(schedules);
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
      dispatchSettingsChangedEvent,
    );
  }

  void _trackRestaurants() {
    _restaurantsSubscription = _restaurantsRepository.restaurantsStream?.listen(
      dispatchRestaurantsChangedEvent,
    );
  }

  void onRestaurantChanged(Restaurant value) {
    _userData.saveSettings(
      currentState.settings.rebuild((b) => b..restaurantId = value.documentID),
    );
  }
}
