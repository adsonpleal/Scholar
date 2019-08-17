import 'package:app_tcc/modules/base/module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kiwi/kiwi.dart';

import 'main_bloc.dart';

part 'main_module.g.dart';

abstract class MainInjector {
  @Register.factory(MainBloc)
  @Register.singleton(FirebaseMessaging)
  void configure();
}

class MainModule extends Module {
  @override
  void setup() {
    var injector = _$MainInjector();
    injector.configure();
  }
}
