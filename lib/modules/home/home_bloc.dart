import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/base/base_bloc.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';

import 'home_state.dart';

enum _HomeEvent {
  restaurantChanged,
  subjectChanged,
  showInfo,
  addAbsence,
  removeAbsence,
  showPreviousMenuEntry,
  showNextMenuEntry,
  toggleDinner,
}

class HomeBloc extends BaseBloc<_HomeEvent, HomeState> {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Subject>> _subjectsSubscription;
  StreamSubscription<Restaurant> _restaurantSubscription;

  HomeBloc() {
    _initSubjectsStream();
  }

  @override
  HomeState get initialState => HomeState.initial();

  @override
  Stream<HomeState> mapToState(_HomeEvent event, payload) async* {
    switch (event) {
      case _HomeEvent.subjectChanged:
        yield currentState.rebuild((b) => b..subjects.replace(payload));
        break;
      case _HomeEvent.showInfo:
        yield* _showInfoToEvent();
        break;
      case _HomeEvent.addAbsence:
        yield* _changeAbsenceValue(payload, 1);
        break;
      case _HomeEvent.removeAbsence:
        yield* _changeAbsenceValue(payload, -1);
        break;
      case _HomeEvent.restaurantChanged:
        yield currentState.rebuild((b) => b
          ..restaurant.replace(payload)
          ..selectedEntryIndex = 0
          ..showDinner = false);
        break;
      case _HomeEvent.showNextMenuEntry:
        yield currentState.rebuild((b) => b..selectedEntryIndex += 1);
        break;
      case _HomeEvent.showPreviousMenuEntry:
        yield currentState.rebuild((b) => b..selectedEntryIndex -= 1);
        break;
      case _HomeEvent.toggleDinner:
        yield currentState.rebuild((b) => b..showDinner = !b.showDinner);
        break;
    }
  }

  Stream<HomeState> _showInfoToEvent() async* {
    yield currentState.rebuild((b) => b..showInfoAlert = SingleEvent(true));
  }

  Stream<HomeState> _changeAbsenceValue(Subject subject, int value) async* {
    final newSubject =
        subject.rebuild((b) => b..absenceCount = subject.absenceCount + value);
    if (newSubject.isValid) {
      _userData.saveSubject(newSubject);
    }
  }

  void _initSubjectsStream() {
    _subjectsSubscription = _userData.subjectsStream?.listen(
      (s) => dispatchEvent(_HomeEvent.subjectChanged, payload: s),
    );
    _restaurantSubscription = _userData.restaurantStream?.listen(
      (r) => dispatchEvent(_HomeEvent.restaurantChanged, payload: r),
    );
  }

  void addAbsence(Subject subject) => dispatchEvent(
        _HomeEvent.addAbsence,
        payload: subject,
      );

  void removeAbsence(Subject subject) => dispatchEvent(
        _HomeEvent.removeAbsence,
        payload: subject,
      );

  void showInfoAlert() => dispatchEvent(_HomeEvent.showInfo);

  @override
  void dispose() {
    _subjectsSubscription?.cancel();
    _restaurantSubscription?.cancel();
    super.dispose();
  }

  void showNextMenuEntry() {
    dispatchEvent(_HomeEvent.showNextMenuEntry);
  }

  void showPreviousMenuEntry() {
    dispatchEvent(_HomeEvent.showPreviousMenuEntry);
  }

  void toggleDinner() {
    dispatchEvent(_HomeEvent.toggleDinner);
  }
}
