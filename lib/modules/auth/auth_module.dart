import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

part 'auth_module.g.dart';

abstract class AuthInjector {
  @Register.singleton(AuthRepository)
  void configure();
}

class AuthModule extends Module {
  @override
  void setup() {
    var injector = _$AuthInjector();
    injector.configure();
  }
}
