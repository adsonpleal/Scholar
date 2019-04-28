import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

import 'new_event_state.dart';

class _NewEventEvent {}

class _StartEvent extends _NewEventEvent {}

class _CreateEvent extends _NewEventEvent {
  final Event event;

  _CreateEvent(this.event);
}

class NewEventBloc extends Bloc<_NewEventEvent, NewEventState> {
  final UserDataRepository _userData = inject();

  @override
  NewEventState get initialState => NewEventState.initial();

  NewEventBloc() {
    dispatch(_StartEvent());
  }

  @override
  Stream<NewEventState> mapEventToState(_NewEventEvent e) async* {
    if (e is _StartEvent) {
      final subjects = await _userData.subjects;
      yield currentState.rebuild((b) => b..subjects = subjects);
    }
    if (e is _CreateEvent) {
      yield currentState.rebuild((b) => b..loading = true);
      await _userData.createEvent(e.event);
      yield currentState.rebuild((b) => b
        ..created = true
        ..loading = false);
    }
  }

  void createEvent(Event event) {
    dispatch(_CreateEvent(event));
  }
}
