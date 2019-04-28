import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'new_event_bloc.dart';

part 'new_event_module.g.dart';

abstract class NewEventInjector {
  @Register.factory(NewEventBloc)
  void configure();
}

class NewEventModule extends Module {
  @override
  void setup() {
    var injector = _$NewEventInjector();
    injector.configure();
  }
}
