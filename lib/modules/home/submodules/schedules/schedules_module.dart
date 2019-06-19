import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'schedules_bloc.dart';

part 'schedules_module.g.dart';

abstract class SchedulesInjector {
  @Register.factory(SchedulesBloc)
  void configure();
}

class SchedulesModule extends Module {
  @override
  void setup() {
    var injector = _$SchedulesInjector();
    injector.configure();
  }
}
