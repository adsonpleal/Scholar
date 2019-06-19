import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'event_details_bloc.dart';

part 'event_details_module.g.dart';

abstract class EventDetailsInjector {
  @Register.factory(EventDetailsBloc)
  void configure();
}

class EventDetailsModule extends Module {
  @override
  void setup() {
    var injector = _$EventDetailsInjector();
    injector.configure();
  }
}
