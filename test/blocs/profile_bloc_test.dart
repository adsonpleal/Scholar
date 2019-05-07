import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/profile/profile_state.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.dart';

void main() {
  final Container container = Container();
  AuthRepository authRepository;
  RestaurantsRepository restaurantsRepository;
  UserDataRepository userDataRepository;
  LinkRepository linkRepository;
  NotificationsService notificationsService;
  Firestore firestore;

  void _stubAllowNotifications({bool value = false}) {
    final settings = Settings((b) => b..allowNotifications = value);
    when(userDataRepository.settings).thenAnswer((_) => Future.value(settings));
  }

  setUp(() {
    userDataRepository = MockUserDataRepository();
    _stubAllowNotifications();
    authRepository = MockAuthRepository();
    linkRepository = MockLinkRepository();
    notificationsService = MockNotificationsService();
    restaurantsRepository = MockRestaurantsRepository();
    firestore = MockFirestore();
    container.registerFactory((c) => notificationsService);
    container.registerSingleton((c) => authRepository);
    container.registerSingleton((c) => userDataRepository);
    container.registerSingleton((c) => firestore);
    container.registerSingleton((c) => restaurantsRepository);
    container.registerSingleton((c) => linkRepository);
  });

  tearDown(() {
    container.clear();
  });

  test('initial state is correct', () {
    final profileBloc = ProfileBloc();
    expect(profileBloc.initialState, ProfileState.initial());
  });

  test('dispose does not emit new states', () async {
    final profileBloc = ProfileBloc();
    expectLater(
      profileBloc.state,
      emitsInOrder([]),
    );
    await Future.delayed(Duration(microseconds: 500));
    profileBloc.dispose();
  });

  test('logout emits [initial, loading, login]', () {
    final profileBloc = ProfileBloc();

    final expectedResponse = [
      ProfileState.initial(),
      ProfileState.login(),
    ];
    expectLater(
      profileBloc.state,
      emitsInOrder(expectedResponse),
    );
    profileBloc.dispatchLogoutEvent();
  });

  group('toggle notifications', () {
    Future<void> testToggle(bool initialAllowNotifications) async {
      final settingsStreamController = StreamController<Settings>();
      final settings =
          Settings((b) => b..allowNotifications = initialAllowNotifications);
      settingsStreamController.add(settings);
      when(userDataRepository.settingsStream)
          .thenAnswer((_) => settingsStreamController.stream);
      when(userDataRepository.settings)
          .thenAnswer((_) => Future.value(settings));
      when(userDataRepository.subjects).thenAnswer((_) => Future.value([]));
      when(userDataRepository.currentUser)
          .thenAnswer((_) => Future.value(User((b) => b..email = '')));
      when(userDataRepository.saveSettings(any)).thenAnswer((_) {
        settingsStreamController.add(settings.rebuild(
            (b) => b..allowNotifications = !initialAllowNotifications));
      });
      final user = await userDataRepository.currentUser;
      final firstState = ProfileState.initial();
      final secondState = firstState
          .rebuild((b) => b..user.replace(user)..settings.replace(settings));
      final thirdState = secondState.rebuild((b) => b
        ..settings.replace(
          settings.rebuild(
              (b) => b..allowNotifications = !initialAllowNotifications),
        ));
      final expectedResponse = [
        secondState,
        thirdState,
      ];
      final profileBloc = ProfileBloc();
      await profileBloc.state.firstWhere((s) => s == secondState);

      profileBloc.dispatchToggleNotificationsEvent();
      await expectLater(
        profileBloc.state,
        emitsInOrder(expectedResponse),
      );
      settingsStreamController.close();
    }

    test('toggle from true calls addNotifications and updateNotificationsToken',
        () async {
      await testToggle(true);
      verify(notificationsService.addNotifications(any)).called(2);
      verify(userDataRepository.updateNotificationsToken(any)).called(2);
    });
  });

  test('onRestaurantChanged should call _userData.saveSettings', () async {
    final settings = Settings((b) => b..allowNotifications = false);
    when(userDataRepository.settingsStream)
        .thenAnswer((_) => Stream.fromIterable([settings]));
    when(userDataRepository.currentUser)
        .thenAnswer((_) => Future.value(User((b) => b..email = '')));
    final profileBloc = ProfileBloc();
    await profileBloc.state.firstWhere((s) => s.settings == settings);
    final restaurant = Restaurant((b) => b
      ..documentID = 'documentID'
      ..name = 'name'
      ..menu.replace([]));
    profileBloc.onRestaurantChanged(restaurant);
    verify(userDataRepository.saveSettings(
      settings.rebuild((b) => b..restaurantId = restaurant.documentID),
    )).called(1);
  });

  test('_trackRestaurants should emit new state', () async {
    final List<Restaurant> restaurants = [];
    when(restaurantsRepository.restaurantsStream)
        .thenAnswer((_) => Stream.fromIterable([restaurants]));
    final profileBloc = ProfileBloc();
    final expectedResponse = [
      ProfileState.initial(),
      ProfileState.initial().rebuild((b) => b.restaurants = restaurants),
    ];
    await expectLater(
      profileBloc.state,
      emitsInOrder(expectedResponse),
    );
  });
}
