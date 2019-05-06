library home_state;

import 'package:app_tcc/models/single_event.dart';
import 'package:built_value/built_value.dart';

part 'home_state.g.dart';

abstract class HomeState implements Built<HomeState, HomeStateBuilder> {
  @nullable
  SingleEvent<bool> get showInfoAlert;
  bool get isLoading;

  HomeState._();

  factory HomeState([Function(HomeStateBuilder b) updates]) = _$HomeState;

  factory HomeState.initial() => HomeState((b) => b..isLoading = true);
}
