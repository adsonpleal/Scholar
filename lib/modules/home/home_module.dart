import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'home_bloc.dart';
import 'submodules/restaurant_menu/restaurant_menu_module.dart';
import 'submodules/schedules.dart/schedules_module.dart';
import 'submodules/subjects/subjects_module.dart';

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
    _setupSubmodules();
  }

  void _setupSubmodules() {
    <Module>[
      RestaurantMenuModule(),
      SubjectsModule(),
      SchedulesModule(),
    ].forEach((module) => module.setup());
  }
}
