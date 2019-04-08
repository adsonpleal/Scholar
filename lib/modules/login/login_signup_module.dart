import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';

class LoginSignUpModule {
  const LoginSignUpModule();
  LoginSignUpBloc get bloc => LoginSignUpBloc(AuthRepository());
}
