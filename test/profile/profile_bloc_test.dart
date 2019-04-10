import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  final Container container = Container();
  ProfileBloc profilepBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    container.registerFactory((c) => ProfileBloc());
    container.registerSingleton((c) => authRepository);
    profilepBloc = inject();
  });

  tearDown(() {
    container.clear();
  });

  test('initial state is correct', () {
    expect(profilepBloc.initialState, ProfileState.initial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      profilepBloc.state,
      emitsInOrder([]),
    );
    profilepBloc.dispose();
  });

  test('logout emits [initial, login]', () {
    final expectedResponse = [
      ProfileState.initial(),
      ProfileState.login(),
    ];
    expectLater(
      profilepBloc.state,
      emitsInOrder(expectedResponse),
    );
    profilepBloc.logOut();
  });
}
