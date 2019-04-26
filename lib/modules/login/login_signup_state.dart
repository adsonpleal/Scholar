library login_sign_up_state;

import 'package:app_tcc/models/single_event.dart';
import 'package:built_value/built_value.dart';

part 'login_signup_state.g.dart';

enum FormMode {
  login,
  signUp,
  resetPassword,
}

abstract class LoginSignUpState implements Built<LoginSignUpState, LoginSignUpStateBuilder> {
  bool get loading;

  FormMode get formMode;

  @nullable
  String get errorMessage;

  @nullable
  SingleEvent<String> get route;

  @nullable
  SingleEvent<bool> get showResetPasswordDialog;

  LoginSignUpState._();

  factory LoginSignUpState([updates(LoginSignUpStateBuilder b)]) => _$LoginSignUpState((b) => b
    ..formMode = FormMode.login
    ..loading = false
    ..update(updates));

  factory LoginSignUpState.initial() => LoginSignUpState();
}
