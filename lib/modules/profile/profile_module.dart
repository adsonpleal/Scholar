import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:kiwi/kiwi.dart';

part 'profile_module.g.dart';

abstract class ProfileInjector {
  @Register.factory(ProfileBloc)
  void configure();
}

class ProfileModule extends Module {
  @override
  void setup() {
    var injector = _$ProfileInjector();
    injector.configure();
  }
}
