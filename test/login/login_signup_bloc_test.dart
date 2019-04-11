import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.dart';

class CustomException implements Exception {
  final String code;
  CustomException(this.code);
}

void main() {
  final Container container = Container();
  LoginSignUpBloc loginSignUpBloc;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    container.registerSingleton((c) => authRepository);
    loginSignUpBloc = LoginSignUpBloc();
  });

  tearDown(() {
    container.clear();
  });

  test('initial state is correct', () {
    expect(loginSignUpBloc.initialState, LoginSignUpState.initial());
  });

  test('dispose does not emit new states', () {
    expectLater(
      loginSignUpBloc.state,
      emitsInOrder([]),
    );
    loginSignUpBloc.dispose();
  });

  group('toggleForm', () {
    test('emits [login, signup] after one toggle', () {
      final expectedResponse = [
        LoginSignUpState(formMode: FormMode.login),
        LoginSignUpState(formMode: FormMode.signUp)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.toggleFormMode();
    });

    test('emits [login, signup, login] after two toggles', () {
      final expectedResponse = [
        LoginSignUpState(formMode: FormMode.login),
        LoginSignUpState(formMode: FormMode.signUp),
        LoginSignUpState(formMode: FormMode.login)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.toggleFormMode();
      loginSignUpBloc.toggleFormMode();
    });
  });

  group('submit', () {
    test('emits [login, signup, loaging] after submiting from signup',
        () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState(formMode: FormMode.signUp),
        LoginSignUpState(formMode: FormMode.signUp, loading: true)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.toggleFormMode();
      loginSignUpBloc.submit();
      await untilCalled(authRepository.signUp(any, any));
    });

    test('emits [login, loaging] after submiting from login', () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState(loading: true)
      ];
      when(authRepository.signIn(any, any))
          .thenAnswer((_) => Future.value("test"));
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.submit();
      await untilCalled(authRepository.signIn(any, any));
    });

    test('emits [login, loaging, error] after submiting with error', () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState(loading: true),
        LoginSignUpState(errorMessage: Strings.unknownError)
      ];
      when(authRepository.signIn(any, any))
          .thenAnswer((_) => Future.error(CustomException("test")));
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.submit();
    });
  });
}
