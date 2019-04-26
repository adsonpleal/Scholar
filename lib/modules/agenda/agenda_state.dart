library agenda_state;

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'agenda_state.g.dart';

abstract class AgendaState implements Built<AgendaState, AgendaStateBuilder> {
  BuiltList<Event> get events;

  BuiltList<EventNotification> get notifications;

  AgendaState._();

  factory AgendaState([updates(AgendaStateBuilder b)]) => _$AgendaState((b) => b
    ..events.replace([])
    ..notifications.replace([])
    ..update(updates));

  factory AgendaState.initial() => AgendaState();
}
