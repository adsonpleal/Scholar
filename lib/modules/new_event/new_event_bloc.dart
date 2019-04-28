import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/modules/base/bloc_event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

import 'new_event_state.dart';

enum _NewEventEventType {
  start,
  createEvent,
}

class _NewEventEvent extends BlocEvent<_NewEventEventType> {
  _NewEventEvent({type, payload}) : super(type, payload);
}

class NewEventBloc extends Bloc<_NewEventEvent, NewEventState> {
  final UserDataRepository _userData = inject();

  @override
  NewEventState get initialState => NewEventState.initial();

  NewEventBloc() {
    dispatch(_NewEventEvent(
      type: _NewEventEventType.start,
    ));
  }

  @override
  Stream<NewEventState> mapEventToState(_NewEventEvent e) async* {
    switch (e.type) {
      case _NewEventEventType.start:
        yield* _startEventToState();
        break;
      case _NewEventEventType.createEvent:
        yield* _createEventToState(e.payload);
        break;
    }
  }

  Stream<NewEventState> _startEventToState() async* {
    final subjects = await _userData.subjects;
    yield currentState.rebuild((b) => b..subjects = subjects);
  }

  Stream<NewEventState> _createEventToState(Event event) async* {
    yield currentState.rebuild((b) => b..loading = true);
    await _userData.createEvent(event);
    yield currentState.rebuild((b) => b
      ..created = true
      ..loading = false);
  }

  void createEvent(Event event) {
    dispatch(_NewEventEvent(
      type: _NewEventEventType.createEvent,
      payload: event,
    ));
  }
}
