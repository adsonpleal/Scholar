import 'package:app_tcc/models/schedule.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'schedules_state.g.dart';

abstract class SchedulesState
    implements Built<SchedulesState, SchedulesStateBuilder> {
  @nullable
  BuiltList<Schedule> get schedules;
  int get selectedScheduleIndex;

  SchedulesState._();

  Schedule get selectedSchedule => schedules[selectedScheduleIndex];

  factory SchedulesState([Function(SchedulesStateBuilder b) updates]) =
      _$SchedulesState;

}
