import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'subjects_bloc.dart';

part 'subjects_module.g.dart';

abstract class SubjectsInjector {
  @Register.factory(SubjectsBloc)
  void configure();
}

class SubjectsModule extends Module {
  @override
  void setup() {
    var injector = _$SubjectsInjector();
    injector.configure();
  }
}
