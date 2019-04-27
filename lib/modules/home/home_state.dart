library home_state;

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'home_state.g.dart';

abstract class HomeState implements Built<HomeState, HomeStateBuilder> {
  @nullable
  BuiltList<Subject> get subjects;

  @nullable
  SingleEvent<bool> get showInfoAlert;

  HomeState._();

  factory HomeState([Function(HomeStateBuilder b) updates]) = _$HomeState;

  factory HomeState.initial() => HomeState();
}

