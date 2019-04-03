import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRootBlock extends Mock implements RootBloc {}

class MockUser extends Mock implements FirebaseUser {}

class CustomException implements Exception {
  final String code;
  CustomException(this.code);
}

void main() {
  LoginSignUpBloc loginSignUpBloc;
  MockRootBlock rootBloc;
  AuthRepository authRepository;

  setUp(() {
    rootBloc = MockRootBlock();
    authRepository = MockAuthRepository();
    loginSignUpBloc = LoginSignUpBloc(authRepository, rootBloc);
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
    test('emits [login, signup, loaging] after submiting from signup', () async {
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
      loginSignUpBloc.submit(true);
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
      loginSignUpBloc.submit(true);
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
      loginSignUpBloc.submit(true);
    });

  });
}
