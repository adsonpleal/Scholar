import 'dart:async';

import 'package:app_tcc/models/schedule.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

import 'schedules_state.dart';

part 'schedules_bloc.g.dart';

@GenerateBloc(SchedulesState)
class SchedulesBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Schedule>> _schedulesSubscription;

  SchedulesBloc() {
    _initStream();
  }

  @override
  SchedulesState get initialState {
    final selectedScheduleIndex = DateTime.now().weekday % 7;
    return SchedulesState(
        (b) => b..selectedScheduleIndex = selectedScheduleIndex);
  }

  Stream<SchedulesState> _mapSchedulesChangedToState(
    List<Schedule> schedules,
  ) async* {
    yield currentState.rebuild((b) => b..schedules.replace(schedules));
  }

  Stream<SchedulesState> _mapShowNextToState() async* {
    var selectedIndex = currentState.selectedScheduleIndex + 1;
    if (selectedIndex == currentState.schedules.length) {
      selectedIndex = 0;
    }
    yield currentState.rebuild((b) => b..selectedScheduleIndex = selectedIndex);
  }

  Stream<SchedulesState> _mapShowPreviousToState() async* {
    var selectedIndex = currentState.selectedScheduleIndex - 1;
    if (selectedIndex < 0) {
      selectedIndex += currentState.schedules.length;
    }
    yield currentState.rebuild((b) => b..selectedScheduleIndex = selectedIndex);
  }

  void _initStream() {
    _schedulesSubscription = _userData.schedulesStream?.listen(
      dispatchSchedulesChangedEvent,
    );
  }

  @override
  void dispose() {
    _schedulesSubscription?.cancel();
    super.dispose();
  }
}
