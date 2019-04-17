import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'home_bloc.dart';

part 'home_module.g.dart';

abstract class HomeInjector {
  @Register.factory(HomeBloc)
  void configure();
}

class HomeModule extends Module {
  @override
  void setup() {
    var injector = _$HomeInjector();
    injector.configure();
  }
}
