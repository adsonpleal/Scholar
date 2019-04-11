import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

import '../utils/mocks.dart';

void main() {
  final Container container = Container();
  ProfileBloc profilepBloc;
  AuthRepository authRepository;
  UserDataRepository userDataRepository;
  Firestore firestore;

  setUp(() {
    authRepository = MockAuthRepository();
    userDataRepository = MockUserDataRepository();
    firestore = MockFirestore();
    container.registerSingleton((c) => authRepository);
    container.registerSingleton((c) => userDataRepository);
    container.registerSingleton((c) => firestore);
    profilepBloc = ProfileBloc();
  });

  tearDown(() {
    container.clear();
  });

  test('initial state is correct', () {
    expect(profilepBloc.initialState, ProfileState.initial());
  });
  
  test('logout emits [initial, loading, login]', () {
    final expectedResponse = [
      ProfileState.initial(),
      ProfileState.initial().changeValue(loading: true),
      ProfileState.login(),
    ];
    expectLater(
      profilepBloc.state,
      emitsInOrder(expectedResponse),
    );
    profilepBloc.logOut();
  });
}
