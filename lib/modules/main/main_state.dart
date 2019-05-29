library login_sign_up_state;

import 'package:app_tcc/models/settings.dart';
import 'package:built_value/built_value.dart';

part 'main_state.g.dart';

abstract class MainState implements Built<MainState, MainStateBuilder> {
  @nullable
  Settings get settings;

  MainState._();

  factory MainState([Function(MainStateBuilder b) updates]) = _$MainState;

  factory MainState.initial() => MainState();
}
