import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/ufsc/ufsc_service.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';
// ignore: uri_does_not_exist
import 'dart:js' as js;

import 'profile_state.dart';

part 'profile_bloc.g.dart';

@GenerateBloc(ProfileState)
class ProfileBloc extends _$Bloc {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final UfscService _ufscService = inject();
  final RestaurantsRepository _restaurantsRepository = inject();
  StreamSubscription<Settings> _settingsSubscription;
  StreamSubscription<List<Restaurant>> _restaurantsSubscription;
  StreamSubscription<bool> _loadingUfscSubscription;
  StreamSubscription<bool> _checkingUfscSubscription;

  ProfileBloc() {
    _trackUserData();
    _trackRestaurants();
    _trackUfscLoading();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  Stream<ProfileState> _mapToggleNotificationsToState() async* {
    final settings = currentState.settings;
    final newNotificationsState = !settings.allowNotifications;
    _userData.saveSettings(
      settings.rebuild((b) => b..allowNotifications = newNotificationsState),
    );
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
    yield ProfileState.login();
    _auth.signOut();
  }

  Future launchAuthorization() async {
    await _userData.clearConnection();
    _loadingUfscSubscription = _ufscService.launchAuthorization().listen(
          dispatchLoadingChangedEvent,
        );
  }

  void launchContactEmail() {
    js.context.callMethod("open", ["mailto:contato.scholar@gmail.com"]);
  }

  @override
  dispose() {
    _restaurantsSubscription?.cancel();
    _settingsSubscription?.cancel();
    _loadingUfscSubscription?.cancel();
    _checkingUfscSubscription?.cancel();
    super.dispose();
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

  void _trackUfscLoading() {
    _checkingUfscSubscription = _ufscService.checkAuthentication().listen(
          dispatchLoadingChangedEvent,
        );
  }

  void onRestaurantChanged(Restaurant value) {
    _userData.saveSettings(
      currentState.settings.rebuild((b) => b..restaurantId = value.documentID),
    );
  }
}
