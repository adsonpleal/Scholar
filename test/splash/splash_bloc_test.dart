import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.dart';

void main() {
  final Container container = Container();
  SplashBloc splashBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    container.registerSingleton((c) => authRepository);
    splashBloc = SplashBloc();
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
      when(authRepository.currentUser).thenAnswer((_) => Future.value(null));
      expectLater(
        splashBloc.state,
        emitsInOrder(expectedResponse),
      );
      splashBloc.checkAuthentication();
    });

    test('emits [main] for valid token', () {
      final expectedResponse = [SplashState.initial(), SplashState.main()];
      when(authRepository.currentUser)
          .thenAnswer((_) => Future.value(MockUser()));
      expectLater(
        splashBloc.state,
        emitsInOrder(expectedResponse),
      );
      splashBloc.checkAuthentication();
    });
  });
}
