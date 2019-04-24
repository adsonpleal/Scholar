import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'agenda_bloc.dart';

part 'agenda_module.g.dart';

abstract class AgendaInjector {
  @Register.factory(AgendaBloc)
  void configure();
}

class AgendaModule extends Module {
  @override
  void setup() {
    var injector = _$AgendaInjector();
    injector.configure();
  }
}
