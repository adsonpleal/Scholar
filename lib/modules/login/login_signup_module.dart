import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:kiwi/kiwi.dart';

part 'login_signup_module.g.dart';

abstract class LoginSignUInjector {
  @Register.factory(LoginSignUpBloc)
  void configure();
}

class LoginSignUModule extends Module {
  @override
  void setup() {
    var injector = _$LoginSignUInjector();
    injector.configure();
  }
}
