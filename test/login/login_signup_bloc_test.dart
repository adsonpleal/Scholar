import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_state.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
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
  NotificationsService notificationsService;
  UserDataRepository userDataRepository;
  AuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    notificationsService = MockNotificationsService();
    userDataRepository = MockUserDataRepository();
    container.registerSingleton((c) => userDataRepository);
    container.registerSingleton((c) => authRepository);
    container.registerFactory((c) => notificationsService);
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
      loginSignUpBloc.toggleFormMode();
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
      loginSignUpBloc.toggleFormMode();
      loginSignUpBloc.toggleFormMode();
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
      final passsword = "passsword";
      expect(null, loginSignUpBloc.validatePassword(passsword));
    });
    test('password validator return error if invalid', () {
      final passsword = "";
      expect(Strings.passwordCantBeEmpty, loginSignUpBloc.validatePassword(passsword));
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
      loginSignUpBloc.toggleResetPassword();
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
      loginSignUpBloc.toggleResetPassword();
      loginSignUpBloc.toggleResetPassword();
    });
  });

  group('submit', () {
    test('emits [login, signup, loaging] after submiting from signup', () async {
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
      loginSignUpBloc.toggleFormMode();
      loginSignUpBloc.onEmailSaved(email);
      loginSignUpBloc.onPasswordSaved(password);
      loginSignUpBloc.submit();
      await untilCalled(authRepository.signUp(email, password));
    });

    test('emits [login, loaging] after submiting from login', () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState((b) => b..loading = true)
      ];
      when(authRepository.signIn(any, any)).thenAnswer((_) => Future.value("test"));
      expectLater(
        loginSignUpBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginSignUpBloc.submit();
      await untilCalled(authRepository.signIn(any, any));
    });

    test('emits [login, resetPassword, loaging] after submiting from resetPassword', () async {
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
      loginSignUpBloc.toggleResetPassword();
      loginSignUpBloc.submit();
      await untilCalled(authRepository.resetPassword(any));
    });

    test('emits [login, loaging, error] after submiting with error', () async {
      final expectedResponse = [
        LoginSignUpState.initial(),
        LoginSignUpState((b) => b..loading = true),
        LoginSignUpState((b) => b..errorMessage = Strings.unknownError)
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
