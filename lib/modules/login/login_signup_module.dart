import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:kiwi/kiwi.dart';

part 'login_signup_module.g.dart';

abstract class LoginSignUpInjector {
  @Register.factory(LoginSignUpBloc)
  void configure();
}

class LoginSignUpModule extends Module {
  @override
  void setup() {
    var injector = _$LoginSignUpInjector();
    injector.configure();
  }
}
