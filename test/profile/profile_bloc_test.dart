import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/profile/profile_state.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.dart';

void main() {
  final Container container = Container();
  ProfileBloc profileBloc;
  AuthRepository authRepository;
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
    firestore = MockFirestore();
    container.registerFactory((c) => notificationsService);
    container.registerSingleton((c) => authRepository);
    container.registerSingleton((c) => userDataRepository);
    container.registerSingleton((c) => firestore);
    container.registerSingleton((c) => linkRepository);
    profileBloc = ProfileBloc();
  });

  tearDown(() {
    container.clear();
  });

  test('initial state is correct', () {
    expect(profileBloc.initialState, ProfileState.initial());
  });

  test('dispose does not emit new states', () async {
    expectLater(
      profileBloc.state,
      emitsInOrder([]),
    );
    await Future.delayed(Duration(microseconds: 500));
    profileBloc.dispose();
  });

  test('logout emits [initial, loading, login]', () {
    final expectedResponse = [
      ProfileState.initial(),
      ProfileState.login(),
    ];
    expectLater(
      profileBloc.state,
      emitsInOrder(expectedResponse),
    );
    profileBloc.logOut();
  });
}
