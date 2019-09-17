import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_state.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
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
  UserDataRepository userDataRepository;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    userDataRepository = MockUserDataRepository();
    container.registerSingleton((c) => userDataRepository);
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
        LoginSignUpState((b) => b..formMode = FormMode.login),
        LoginSignUpState((b) => b..formMode = FormMode.signUp)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchToggleEvent();
    });

    test('emits [login, signup, login] after two toggles', () {
      final expectedResponse = [
        LoginSignUpState((b) => b..formMode = FormMode.login),
        LoginSignUpState((b) => b..formMode = FormMode.signUp),
        LoginSignUpState((b) => b..formMode = FormMode.login)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchToggleEvent();
      loginSignUpBloc.dispatchToggleEvent();
    });
  });

  group('validators', () {
    test('email validator return null if valid', () {
      final email = "valid@email.com";
      expect(null, loginSignUpBloc.validateEmail(email));
    });
    test('email validator return error if invalid', () {
      final email = "";
      expect(Strings.emailCantBeEmpty, loginSignUpBloc.validateEmail(email));
    });
    test('password validator return null if valid', () {
      final password = "password";
      expect(null, loginSignUpBloc.validatePassword(password));
    });
    test('password validator return error if invalid', () {
      final password = "";
      expect(Strings.passwordCantBeEmpty,
          loginSignUpBloc.validatePassword(password));
    });
  });

  group('toggleResetPassword', () {
    test('emits [login, resetPassword] after one toggle', () {
      final expectedResponse = [
        LoginSignUpState((b) => b..formMode = FormMode.login),
        LoginSignUpState((b) => b..formMode = FormMode.resetPassword)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchToggleResetEvent();
    });

    test('emits [login, resetPassword, login] after two toggles', () {
      final expectedResponse = [
        LoginSignUpState((b) => b..formMode = FormMode.login),
        LoginSignUpState((b) => b..formMode = FormMode.resetPassword),
        LoginSignUpState((b) => b..formMode = FormMode.login)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchToggleResetEvent();
      loginSignUpBloc.dispatchToggleResetEvent();
    });
  });

  group('submit', () {
    test('emits [login, signup, loading] after submitting from signup',
        () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState((b) => b..formMode = FormMode.signUp),
        LoginSignUpState((b) => b
          ..formMode = FormMode.signUp
          ..loading = true)
      ];
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      final email = "valid@email.com";
      final password = "password";
      loginSignUpBloc.dispatchToggleEvent();
      loginSignUpBloc.onEmailSaved(email);
      loginSignUpBloc.onPasswordSaved(password);
      loginSignUpBloc.dispatchSubmitEvent();
      await untilCalled(authRepository.signUp(email, password));
    });

    test('emits [login, loading] after submitting from login', () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState((b) => b..loading = true)
      ];
      when(authRepository.signIn(any, any))
          .thenAnswer((_) => Future.value("test"));
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchSubmitEvent();
      await untilCalled(authRepository.signIn(any, any));
    });

    test(
        'emits [login, resetPassword, loading] after submitting from resetPassword',
        () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState((b) => b..formMode = FormMode.resetPassword),
        LoginSignUpState((b) => b
          ..formMode = FormMode.resetPassword
          ..loading = true)
      ];
      when(authRepository.resetPassword(any)).thenAnswer((_) => Future.value());
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.dispatchToggleResetEvent();
      loginSignUpBloc.dispatchSubmitEvent();
      await untilCalled(authRepository.resetPassword(any));
    });
  });

  group('error', () {
    final errors = {
      'ERROR_INVALID_EMAIL': Strings.errorInvalidEmail,
      'ERROR_WRONG_PASSWORD': Strings.errorWrongPassword,
      'ERROR_USER_NOT_FOUND': Strings.errorUserNotFound,
      'ERROR_USER_DISABLED': Strings.errorUserDisabled,
      'ERROR_TOO_MANY_REQUESTS': Strings.errorTooManyRequests,
      'ERROR_OPERATION_NOT_ALLOWED': Strings.errorOperationNotAllowed,
      'UNKNOWN': Strings.unknownError,
    };

    errors.forEach((key, error) {
      test(
        'emits [login, loading, error] after submitting with $error',
        () async {
          final expectedResponse = [
            LoginSignUpState.initial(),
            LoginSignUpState((b) => b..loading = true),
            LoginSignUpState((b) => b..errorMessage = error)
          ];

          when(authRepository.signIn(any, any))
              .thenAnswer((_) => Future.error(CustomException(key)));
          expectLater(
            loginSignUpBloc.state,
            emitsInOrder(expectedResponse),
          );
          loginSignUpBloc.dispatchSubmitEvent();
        },
      );
    });
  });
}
