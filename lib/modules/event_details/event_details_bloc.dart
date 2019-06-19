import 'dart:async';

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_code_generator/annotations.dart';

import 'event_details_state.dart';

part 'event_details_bloc.g.dart';

@GenerateBloc(EventDetailsState)
class EventDetailsBloc extends _$Bloc {
  final UserDataRepository _userData = inject();

  @override
  EventDetailsState get initialState => EventDetailsState.initial();

  Stream<EventDetailsState> _mapDeleteEventToState(String documentId) async* {
    yield currentState.startLoading();
    await _userData.deleteEvent(documentId);
    yield currentState.stopLoading();
    yield currentState.rebuild((b) => b..dismiss = SingleEvent(true));
  }
}
