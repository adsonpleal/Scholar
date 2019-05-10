import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

import 'login_signup_state.dart';

part 'login_signup_bloc.g.dart';

@GenerateBloc(LoginSignUpState)
class LoginSignUpBloc extends _$Bloc {
  String _email;
  String _password;

  final AuthRepository _auth = inject();

  @override
  LoginSignUpState get initialState => LoginSignUpState.initial();

  Stream<LoginSignUpState> _mapSubmitToState() async* {
    yield currentState.rebuild((b) => b
      ..loading = true
      ..errorMessage = null);
    try {
      switch (currentState.formMode) {
        case FormMode.signUp:
          await _auth.signUp(_email, _password);
          _auth.sendEmailVerification();
          yield* _logUser();
          break;
        case FormMode.login:
          await _auth.signIn(_email, _password);
          yield* _logUser();
          break;
        case FormMode.resetPassword:
          await _auth.resetPassword(_email);
          yield currentState.rebuild(
            (b) => b
              ..loading = false
              ..showResetPasswordDialog = SingleEvent(true),
          );
          break;
      }
    } catch (e) {
      yield currentState.rebuild((b) => b
        ..loading = false
        ..errorMessage = _errorCodeToMessage(e.code));
    }
  }

  Stream<LoginSignUpState> _logUser() async* {
    yield currentState.rebuild((b) => b..route = SingleEvent(Routes.main));
  }

  Stream<LoginSignUpState> _mapToggleToState() async* {
    final isLogin = currentState.formMode == FormMode.login;
    final formMode = isLogin ? FormMode.signUp : FormMode.login;
    yield currentState.rebuild((b) => b..formMode = formMode);
  }

  Stream<LoginSignUpState> _mapToggleResetToState() async* {
    final isReset = currentState.formMode == FormMode.resetPassword;
    final formMode = isReset ? FormMode.login : FormMode.resetPassword;
    yield currentState.rebuild((b) => b..formMode = formMode);
  }

  String validateEmail(String value) =>
      value.isEmpty ? Strings.emailCantBeEmpty : null;

  String validatePassword(String value) =>
      value.isEmpty ? Strings.passwordCantBeEmpty : null;

  onEmailSaved(String value) => _email = value;

  onPasswordSaved(String value) => _password = value;

  String _errorCodeToMessage(String code) {
    switch (code) {
      case 'ERROR_INVALID_EMAIL':
        return Strings.errorInvalidEmail;
      case 'ERROR_WRONG_PASSWORD':
        return Strings.errorWrongPassword;
      case 'ERROR_USER_NOT_FOUND':
        return Strings.errorUserNotFound;
      case 'ERROR_USER_DISABLED':
        return Strings.errorUserDisabled;
      case 'ERROR_TOO_MANY_REQUESTS':
        return Strings.errorTooManyRequests;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return Strings.errorOperationNotAllowed;
      default:
        return Strings.unknownError;
    }
  }
}
