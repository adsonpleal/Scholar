import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum FormMode { login, signUp }

class LoginSignUpState extends Equatable {
  final bool loading;
  final FormMode formMode;
  final String errorMessage;

  LoginSignUpState(
      {this.loading = false,
      this.formMode = FormMode.login,
      this.errorMessage = ""})
      : super([loading, formMode, errorMessage]);

  factory LoginSignUpState.initial() => LoginSignUpState();

  LoginSignUpState changeValue({loading, formMode, errorMessage}) =>
      LoginSignUpState(
          loading: loading ?? this.loading,
          formMode: formMode ?? this.formMode,
          errorMessage: errorMessage ?? this.errorMessage);
}

enum _LoginSignUpEvent { submit, toggleForm }

class LoginSignUpBloc extends Bloc<_LoginSignUpEvent, LoginSignUpState> {
  LoginSignUpBloc(this._auth, this._rootBloc);

  String _email;
  String _password;

  final AuthRepository _auth;
  final RootBloc _rootBloc;

  @override
  LoginSignUpState get initialState => LoginSignUpState.initial();

  @override
  mapEventToState(_LoginSignUpEvent event) async* {
    switch (event) {
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
      if (currentState.formMode == FormMode.signUp) {
        await _auth.signUp(_email, _password);
        _auth.sendEmailVerification();
      } else {
        await _auth.signIn(_email, _password);
      }
      _rootBloc.checkAuthentication();
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
