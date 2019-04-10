import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum FormMode { login, signUp, resetPassword }

class LoginSignUpState extends Equatable {
  final bool loading;
  final FormMode formMode;
  final String errorMessage;
  final SingleEvent<String> route;
  final SingleEvent<bool> showResetPasswordDialog;

  LoginSignUpState(
      {this.loading = false,
      this.formMode = FormMode.login,
      this.showResetPasswordDialog,
      this.route,
      this.errorMessage = ""})
      : super([loading, formMode, errorMessage, route]);

  factory LoginSignUpState.initial() => LoginSignUpState();

  LoginSignUpState changeValue(
          {loading, formMode, errorMessage, showResetPasswordDialog, route}) =>
      LoginSignUpState(
          loading: loading ?? this.loading,
          formMode: formMode ?? this.formMode,
          route: route ?? this.route,
          showResetPasswordDialog:
              showResetPasswordDialog ?? this.showResetPasswordDialog,
          errorMessage: errorMessage ?? this.errorMessage);
}

enum _LoginSignUpEvent { submit, toggleForm, toggleResetPassword }

class LoginSignUpBloc extends Bloc<_LoginSignUpEvent, LoginSignUpState> {

  String _email;
  String _password;

  final AuthRepository _auth = inject();

  @override
  LoginSignUpState get initialState => LoginSignUpState.initial();

  @override
  mapEventToState(_LoginSignUpEvent event) async* {
    switch (event) {
      case _LoginSignUpEvent.toggleResetPassword:
        yield* _mapToggleResetToState();
        break;
      case _LoginSignUpEvent.submit:
        yield* _mapSubmitToState();
        break;
      case _LoginSignUpEvent.toggleForm:
        yield* _mapToggleToState();
    }
  }

  Stream<LoginSignUpState> _mapSubmitToState() async* {
    yield currentState.changeValue(loading: true, errorMessage: "");
    try {
      switch (currentState.formMode) {
        case FormMode.signUp:
          await _auth.signUp(_email, _password);
          _auth.sendEmailVerification();
          yield currentState.changeValue(route: SingleEvent(Routes.main));
          break;
        case FormMode.login:
          await _auth.signIn(_email, _password);
          yield currentState.changeValue(route: SingleEvent(Routes.main));
          break;
        case FormMode.resetPassword:
          await _auth.resetPassword(_email);
          yield currentState.changeValue(
              loading: false, showResetPasswordDialog: SingleEvent(true));
          break;
      }
    } catch (e) {
      yield currentState.changeValue(
          loading: false, errorMessage: _errorCodeToMessage(e.code));
    }
  }

  Stream<LoginSignUpState> _mapToggleToState() async* {
    final isLogin = currentState.formMode == FormMode.login;
    final formMode = isLogin ? FormMode.signUp : FormMode.login;
    yield currentState.changeValue(formMode: formMode);
  }

  Stream<LoginSignUpState> _mapToggleResetToState() async* {
    final isReset = currentState.formMode == FormMode.resetPassword;
    final formMode = isReset ? FormMode.login : FormMode.resetPassword;
    yield currentState.changeValue(formMode: formMode);
  }

  String validateEmail(String value) =>
      value.isEmpty ? 'Email can\'t be empty' : null;

  String validatePassword(String value) =>
      value.isEmpty ? 'Password can\'t be empty' : null;

  onEmailSaved(String value) => _email = value;

  onPasswordSaved(String value) => _password = value;

  submit(bool isValid) {
    if (isValid) {
      dispatch(_LoginSignUpEvent.submit);
    }
  }

  toggleFormMode() => dispatch(_LoginSignUpEvent.toggleForm);
  toggleResetPassword() => dispatch(_LoginSignUpEvent.toggleResetPassword);

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
