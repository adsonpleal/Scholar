import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:kiwi/kiwi.dart';

part 'splash_module.g.dart';

abstract class SplashInjector {
  @Register.factory(SplashBloc)
  void configure();
}

class SplashModule extends Module {
  @override
  void setup() {
    var injector = _$SplashInjector();
    injector.configure();
  }
}
