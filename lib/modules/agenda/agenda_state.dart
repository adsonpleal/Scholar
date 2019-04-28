library agenda_state;

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'agenda_state.g.dart';

abstract class AgendaState implements Built<AgendaState, AgendaStateBuilder> {
  bool get loading;
  BuiltList<Event> get events;
  BuiltList<EventNotification> get notifications;

  AgendaState._();

  factory AgendaState([Function(AgendaStateBuilder b) updates]) = _$AgendaState;

  factory AgendaState.initial() => AgendaState((b) => b
    ..loading = false
    ..events.replace([])
    ..notifications.replace([]));

  AgendaState startLoading() => rebuild((b) => b..loading = true);
  AgendaState stopLoading() => rebuild((b) => b..loading = false);
}
