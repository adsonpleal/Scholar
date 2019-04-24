import 'dart:async';

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<Subject> subjects;
  final SingleEvent<bool> showInfoAlert;

  HomeState({this.subjects, this.showInfoAlert})
      : super([subjects, showInfoAlert]);

  factory HomeState.initial() => HomeState();

  HomeState changeValues({subjects, showInfoAlert}) => HomeState(
        subjects: subjects ?? this.subjects,
        showInfoAlert: showInfoAlert ?? this.showInfoAlert,
      );
}

class _HomeEvent {}

class _SubjectChangedEvent extends _HomeEvent {
  final List<Subject> subjects;
  _SubjectChangedEvent(this.subjects);
}

class _ShowInfoEvent extends _HomeEvent {}

class _AddAbsenceEvent extends _HomeEvent {
  final Subject subject;

  _AddAbsenceEvent(this.subject);
}

class _RemoveAbsenceEvent extends _HomeEvent {
  final Subject subject;

  _RemoveAbsenceEvent(this.subject);
}

class HomeBloc extends Bloc<_HomeEvent, HomeState> {
  final UserDataRepository _userData = inject();
  StreamSubscription _subjectsSub;
  HomeBloc() {
    _initSubjectsStream();
  }

  @override
  HomeState get initialState => HomeState.initial();

  @override
  Stream<HomeState> mapEventToState(_HomeEvent event) async* {
    if (event is _SubjectChangedEvent)
      yield currentState.changeValues(subjects: event.subjects);
    if (event is _ShowInfoEvent) yield* _showInfoToEvent();
    if (event is _AddAbsenceEvent) yield* _changeAbsenceValue(event.subject, 1);
    if (event is _RemoveAbsenceEvent)
      yield* _changeAbsenceValue(event.subject, -1);
  }

  Stream<HomeState> _showInfoToEvent() async* {
    yield currentState.changeValues(showInfoAlert: SingleEvent(true));
  }

  Stream<HomeState> _changeAbsenceValue(Subject subject, int value) async* {
    final subjects = List<Subject>.from(currentState.subjects);
    final newSubject = subject.changeValues(
      absenceCount: subject.absenceCount + value,
    );
    if (newSubject.isValid) {
      _userData.saveSubjects(subjects
        ..[subjects.indexWhere((s) => s.code == subject.code)] = newSubject);
    }
  }

  void _initSubjectsStream() async {
    final subjectsStream = await _userData.subjectsStream;
    _subjectsSub = await subjectsStream
        ?.forEach((subjects) => dispatch(_SubjectChangedEvent(subjects)));
  }

  void addAbsence(Subject subject) => dispatch(_AddAbsenceEvent(subject));
  void removeAbsence(Subject subject) => dispatch(_RemoveAbsenceEvent(subject));
  void showInfoAlert() => dispatch(_ShowInfoEvent());

  @override
  void dispose() {
    _subjectsSub?.cancel();
    super.dispose();
  }
}