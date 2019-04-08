import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements FirebaseUser {}

void main() {
  SplashBloc rootBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    rootBloc = SplashBloc(authRepository);
  });

  test('initial state is correct', () {
    expect(rootBloc.initialState, SplashState.initial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      rootBloc.state,
      emitsInOrder([]),
    );
    rootBloc.dispose();
  });

  group('checkAuthentication', () {
    test('emits [login] for invalid token', () {
      final expectedResponse = [SplashState.initial(), SplashState.login()];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(null));
      expectLater(
        rootBloc.state,
        emitsInOrder(expectedResponse),
      );
      rootBloc.checkAuthentication();
    });

    test('emits [main] for valid token', () {
      final expectedResponse = [SplashState.initial(), SplashState.main()];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(MockUser()));
      expectLater(
        rootBloc.state,
        emitsInOrder(expectedResponse),
      );
      rootBloc.checkAuthentication();
    });
  });
  
}
