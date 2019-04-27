library splash_state;

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:built_value/built_value.dart';

part 'splash_state.g.dart';

abstract class SplashState implements Built<SplashState, SplashStateBuilder> {
  @nullable
  SingleEvent<String> get route;

  SplashState._();

  factory SplashState([Function(SplashStateBuilder b) updates]) = _$SplashState;

  factory SplashState.initial() => SplashState();

  factory SplashState.login() => SplashState((b) => b..route = SingleEvent(Routes.login));

  factory SplashState.main() => SplashState((b) => b..route = SingleEvent(Routes.main));
}
