import 'dart:async';

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class AgendaState extends Equatable {
  final List<Event> events;
  final List<EventNotification> notifications;

  AgendaState({
    this.events,
    this.notifications,
  }) : super([events, notifications]);

  factory AgendaState.initial() => AgendaState();
}

enum _AgendaEvent { start }

class AgendaBloc extends Bloc<_AgendaEvent, AgendaState> {
  AgendaBloc() {
    dispatch(_AgendaEvent.start);
  }

  @override
  AgendaState get initialState => AgendaState.initial();

  @override
  Stream<AgendaState> mapEventToState(_AgendaEvent event) async* {
    if (event == _AgendaEvent.start) yield* _startToState();
  }

  Stream<AgendaState> _startToState() async* {
    // TODO: FETCH REAL DATA!
    final events = [
      Event(
        createdAt: DateTime.now(),
        eventCode: "11111",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "222222",
        type: EventType.test,
        date: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "44444 ",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 2)),
        endTime: DateTime.now().add(Duration(days: 2)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "11111",
        type: EventType.test,
        date: DateTime.now().add(Duration(days: 2)),
        endTime: DateTime.now().add(Duration(days: 2)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "222222",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 3)),
        endTime: DateTime.now().add(Duration(days: 3)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 3)),
        endTime: DateTime.now().add(Duration(days: 3)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "44444 ",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 4)),
        endTime: DateTime.now().add(Duration(days: 4)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "11111",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 5)),
        endTime: DateTime.now().add(Duration(days: 5)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "222222",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 6)),
        endTime: DateTime.now().add(Duration(days: 6)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 7)),
        endTime: DateTime.now().add(Duration(days: 7)).add(Duration(hours: 1)),
      ),
      Event(
        createdAt: DateTime.now(),
        eventCode: "44444",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 7)),
        endTime: DateTime.now().add(Duration(days: 7)).add(Duration(hours: 1)),
      ),
    ];

    final List<EventNotification> notifications = events
        .map(
          (e) => EventNotification(
                createdAt: DateTime.now(),
                event: e,
              ),
        )
        .toList();

    yield AgendaState(
      events: events,
      notifications: notifications,
    );
  }

  void onAcceptNotification(EventNotification notification) {
    // TODO: do stuff
  }

  void onIgnoreNotification(EventNotification notification) {
    // TODO: do stuff
  }
}
