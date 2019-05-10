import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';
import 'package:rxdart/rxdart.dart';

import 'new_event_state.dart';

part 'new_event_bloc.g.dart';

@GenerateBloc(NewEventState)
class NewEventBloc extends _$Bloc {
  final UserDataRepository _userData = inject();

  @override
  NewEventState get initialState => NewEventState.initial();

  NewEventBloc() {
    dispatchStartEvent();
  }

  @override
  Stream<_$Event> transform(Stream<_$Event> events) {
    final eventsObservable = events as Observable<_$Event>;
    return eventsObservable.debounce(Duration(milliseconds: 200));
  }

  Stream<NewEventState> _mapStartToState() async* {
    final subjects = await _userData.subjects;
    yield currentState.rebuild((b) => b..subjects = subjects);
  }

  Stream<NewEventState> _mapCreateEventToState(Event event) async* {
    yield currentState.rebuild((b) => b..loading = true);
    await _userData.createEvent(event);
    yield currentState.rebuild((b) => b
      ..created = SingleEvent(true)
      ..loading = false);
  }
}
