import 'package:app_tcc/modules/login/auth_repository.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum FormMode { login, signUp }

class LoginSignUpState extends Equatable {
  LoginSignUpState([List props = const []]) : super(props);
}

class SplashState extends LoginSignUpState {}

class AuthenticatedState extends LoginSignUpState {}

class UnauthenticatedState extends LoginSignUpState {
  final bool loading;
  final FormMode formMode;
  final String errorMessage;

  UnauthenticatedState(
      {this.loading = false,
      this.formMode = FormMode.login,
      this.errorMessage = ""})
      : super([loading, formMode, errorMessage]);

  UnauthenticatedState changeValue({loading, formMode, errorMessage}) =>
      UnauthenticatedState(
          loading: loading ?? this.loading,
          formMode: formMode ?? this.formMode,
          errorMessage: errorMessage ?? this.errorMessage);
}

enum _LoginSignUpEvent { checkAuthentication, logout, submit, toggleForm }

class LoginSignUpBloc extends Bloc<_LoginSignUpEvent, LoginSignUpState> {
  LoginSignUpBloc(this._auth);

  String _email;
  String _password;

  final AuthRepository _auth;

  @override
  LoginSignUpState get initialState => SplashState();

  @override
  mapEventToState(_LoginSignUpEvent event) async* {
    switch (event) {
      case _LoginSignUpEvent.checkAuthentication:
        yield* _mapCheckAuthToState();
        break;
      case _LoginSignUpEvent.logout:
        yield* _mapLogOutToState();
        break;
      case _LoginSignUpEvent.submit:
        yield* _mapSubmitToState();
        break;
      case _LoginSignUpEvent.toggleForm:
        yield* _mapToggleToState();
    }
  }

  Stream<LoginSignUpState> _mapCheckAuthToState() async* {
    final user = await _auth.getCurrentUser();
    if (user != null) {
      yield AuthenticatedState();
    } else {
      yield UnauthenticatedState();
    }
  }

  Stream<LoginSignUpState> _mapLogOutToState() async* {
    await _auth.signOut();
    yield UnauthenticatedState();
  }

  Stream<LoginSignUpState> _mapSubmitToState() async* {
    final state = (currentState as UnauthenticatedState);
    yield state.changeValue(loading: true, errorMessage: "");
    try {
      if (state.formMode == FormMode.signUp) {
        await _auth.signUp(_email, _password);
        _auth.sendEmailVerification();
      } else {
        await _auth.signIn(_email, _password);
      }
      yield AuthenticatedState();
    } catch (e) {
      yield state.changeValue(
          loading: false, errorMessage: _errorCodeToMessage(e.code));
    }
  }

  Stream<LoginSignUpState> _mapToggleToState() async* {
    final state = (currentState as UnauthenticatedState);
    final isLogin = state.formMode == FormMode.login;
    final formMode = isLogin ? FormMode.signUp : FormMode.login;
    yield state.changeValue(formMode: formMode);
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

  checkAuthentication() => dispatch(_LoginSignUpEvent.checkAuthentication);

  logOut() => dispatch(_LoginSignUpEvent.logout);

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
