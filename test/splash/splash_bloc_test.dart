import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements FirebaseUser {}

void main() {
  final Container container = Container();
  SplashBloc splashBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    container.registerFactory((c) => SplashBloc());
    container.registerSingleton((c) => authRepository);
    splashBloc = inject();
  });

  tearDown(() {
    container.clear();
  });
  test('initial state is correct', () {
    expect(splashBloc.initialState, SplashState.initial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      splashBloc.state,
      emitsInOrder([]),
    );
    splashBloc.dispose();
  });

  group('checkAuthentication', () {
    test('emits [login] for invalid token', () {
      final expectedResponse = [SplashState.initial(), SplashState.login()];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(null));
      expectLater(
        splashBloc.state,
        emitsInOrder(expectedResponse),
      );
      splashBloc.checkAuthentication();
    });

    test('emits [main] for valid token', () {
      final expectedResponse = [SplashState.initial(), SplashState.main()];
      when(authRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(MockUser()));
      expectLater(
        splashBloc.state,
        emitsInOrder(expectedResponse),
      );
      splashBloc.checkAuthentication();
    });
  });
  
}
