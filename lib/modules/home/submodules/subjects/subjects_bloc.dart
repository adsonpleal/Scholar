import 'dart:async';

import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_builder/annotations.dart';

import 'subjects_state.dart';

part 'subjects_bloc.g.dart';

@BuildBloc(SubjectsState)
class SubjectsBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Subject>> _subjectsSubscription;

  SubjectsBloc() {
    _initStream();
  }

  @override
  SubjectsState get initialState => SubjectsState.initial();

  Stream<SubjectsState> _mapSubjectsChangedToState(
    List<Subject> subjects,
  ) async* {
    yield currentState.rebuild((b) => b..subjects.replace(subjects));
  }

  Stream<SubjectsState> _mapAddAbsenceToState(Subject subject) async* {
    yield* _changeAbsenceValue(subject, 1);
  }

  Stream<SubjectsState> _mapRemoveAbsenceToState(Subject subject) async* {
    yield* _changeAbsenceValue(subject, -1);
  }

  Stream<SubjectsState> _changeAbsenceValue(Subject subject, int value) async* {
    final newSubject =
        subject.rebuild((b) => b..absenceCount = subject.absenceCount + value);
    if (newSubject.isValid) {
      _userData.saveSubject(newSubject);
    }
  }

  void _initStream() {
    _subjectsSubscription = _userData.subjectsStream?.listen(
      dispatchSubjectsChangedEvent,
    );
  }

  @override
  void dispose() {
    _subjectsSubscription?.cancel();
    super.dispose();
  }
}
