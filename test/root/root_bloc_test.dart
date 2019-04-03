import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements FirebaseUser {}

void main() {
  RootBloc rootBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    rootBloc = RootBloc(authRepository);
  });

  test('initial state is correct', () {
    expect(rootBloc.initialState, RootState.splash);
  });

  test('dispose does not emit new states', () {
    expectLater(
      rootBloc.state,
      emitsInOrder([]),
    );
    rootBloc.dispose();
  });

  group('checkAuthentication', () {
    test('emits [unauthenticated] for invalid token', () {
      final expectedResponse = [RootState.splash, RootState.unauthenticated];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(null));
      expectLater(
        rootBloc.state,
        emitsInOrder(expectedResponse),
      );
      rootBloc.checkAuthentication();
    });

    test('emits [authenticated] for valid token', () {
      final expectedResponse = [RootState.splash, RootState.authenticated];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(MockUser()));
      expectLater(
        rootBloc.state,
        emitsInOrder(expectedResponse),
      );
      rootBloc.checkAuthentication();
    });
  });

  group('logout', () {
    test('emits [unauthenticated]', () {
      final expectedResponse = [RootState.splash, RootState.unauthenticated];
      when(authRepository.signOut())
          .thenAnswer((_) => Future.value());
      expectLater(
        rootBloc.state,
        emitsInOrder(expectedResponse),
      );
      rootBloc.logout();
    });
  });
}
