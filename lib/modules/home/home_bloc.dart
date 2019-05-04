import 'dart:async';

import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_builder/annotations.dart';

import 'home_state.dart';

part 'home_bloc.g.dart';

@BuildBloc(HomeState)
class HomeBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Subject>> _subjectsSubscription;
  StreamSubscription<Restaurant> _restaurantSubscription;

  HomeBloc() {
    _initStreams();
  }

  @override
  HomeState get initialState => HomeState.initial();

  Stream<HomeState> _mapRestaurantChangedToState(
    Restaurant restaurant,
  ) async* {
    yield currentState.rebuild((b) => b
      ..restaurant.replace(restaurant)
      ..selectedEntryIndex = 0
      ..showDinner = false);
  }

  Stream<HomeState> _mapToggleDinnerToState() async* {
    yield currentState.rebuild((b) => b..showDinner = !b.showDinner);
  }

  Stream<HomeState> _mapShowNextMenuEntryToState() async* {
    yield currentState.rebuild((b) => b..selectedEntryIndex += 1);
  }

  Stream<HomeState> _mapShowPreviousMenuEntryToState() async* {
    yield currentState.rebuild((b) => b..selectedEntryIndex -= 1);
  }

  Stream<HomeState> _mapSubjectsChangedToState(List<Subject> subjects) async* {
    yield currentState.rebuild((b) => b..subjects.replace(subjects));
  }

  Stream<HomeState> _mapShowInfoToState() async* {
    yield currentState.rebuild((b) => b..showInfoAlert = SingleEvent(true));
  }

  Stream<HomeState> _mapAddAbsenceToState(Subject subject) async* {
    yield* _changeAbsenceValue(subject, 1);
  }

  Stream<HomeState> _mapRemoveAbsenceToState(Subject subject) async* {
    yield* _changeAbsenceValue(subject, -1);
  }

  Stream<HomeState> _changeAbsenceValue(Subject subject, int value) async* {
    final newSubject =
        subject.rebuild((b) => b..absenceCount = subject.absenceCount + value);
    if (newSubject.isValid) {
      _userData.saveSubject(newSubject);
    }
  }

  void _initStreams() {
    _subjectsSubscription = _userData.subjectsStream?.listen(
      dispatchSubjectsChangedEvent,
    );
    _restaurantSubscription = _userData.restaurantStream?.listen(
      dispatchRestaurantChangedEvent,
    );
  }

  @override
  void dispose() {
    _subjectsSubscription?.cancel();
    _restaurantSubscription?.cancel();
    super.dispose();
  }
}
