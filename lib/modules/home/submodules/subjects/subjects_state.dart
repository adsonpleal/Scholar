import 'package:app_tcc/models/subject.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'subjects_state.g.dart';

abstract class SubjectsState
    implements Built<SubjectsState, SubjectsStateBuilder> {
  @nullable
  BuiltList<Subject> get subjects;

  SubjectsState._();

  factory SubjectsState([Function(SubjectsStateBuilder b) updates]) =
      _$SubjectsState;

  factory SubjectsState.initial() => SubjectsState();
}
