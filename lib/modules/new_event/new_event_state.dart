import 'package:app_tcc/models/subject.dart';
import 'package:built_value/built_value.dart';

part 'new_event_state.g.dart';

abstract class NewEventState implements Built<NewEventState, NewEventStateBuilder> {
  @nullable
  List<Subject> get subjects;

  bool get created;

  bool get loading;

  NewEventState._();

  factory NewEventState([Function(NewEventStateBuilder b) updates]) = _$NewEventState;

  factory NewEventState.initial() => NewEventState((b) => b
    ..created = false
    ..loading = false);
}
