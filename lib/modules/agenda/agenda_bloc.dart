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

  AgendaState changeValues({
    List<Event> events,
    List<EventNotification> notifications,
  }) =>
      AgendaState(
        events: events ?? this.events,
        notifications: notifications ?? this.notifications,
      );
}

class _AgendaEvent {}

class _StartEvent extends _AgendaEvent {}

class _AcceptNotificationEvent extends _AgendaEvent {
  final EventNotification notification;
  _AcceptNotificationEvent(this.notification);
}

class _RejectNotificationEvent extends _AgendaEvent {
  final EventNotification notification;
  _RejectNotificationEvent(this.notification);
}

class AgendaBloc extends Bloc<_AgendaEvent, AgendaState> {
  AgendaBloc() {
    dispatch(_StartEvent());
  }

  @override
  AgendaState get initialState => AgendaState.initial();

  @override
  Stream<AgendaState> mapEventToState(_AgendaEvent event) async* {
    if (event is _StartEvent) yield* _startToState();
    if (event is _AcceptNotificationEvent)
      yield* _acceptNotificationToState(event.notification);
    if (event is _RejectNotificationEvent)
      yield* _rejectNotificationToState(event.notification);
  }

  Stream<AgendaState> _rejectNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.changeValues(
      notifications: List<EventNotification>.from(currentState.notifications)
        ..remove(notification),
      events: List<Event>.from(currentState.events)..add(notification.event),
    );
  }

  Stream<AgendaState> _acceptNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.changeValues(
      notifications: List<EventNotification>.from(
        currentState.notifications,
      )..remove(notification),
    );
  }

  Stream<AgendaState> _startToState() async* {
    // TODO: FETCH REAL DATA!
    final events = [
      Event(
        subjectCode: "11111",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 1)),
      ),
      Event(
        subjectCode: "222222",
        type: EventType.test,
        date: DateTime.now().add(Duration(days: 1)),
      ),
      Event(
        subjectCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 1)),
      ),
      Event(
        subjectCode: "44444 ",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 2)),
      ),
      Event(
        subjectCode: "11111",
        type: EventType.test,
        date: DateTime.now().add(Duration(days: 2)),
      ),
      Event(
        subjectCode: "222222",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 3)),
      ),
      Event(
        subjectCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 3)),
      ),
      Event(
        subjectCode: "44444 ",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 4)),
      ),
      Event(
        subjectCode: "11111",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 5)),
      ),
      Event(
        subjectCode: "222222",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 6)),
      ),
      Event(
        subjectCode: "33333",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 7)),
      ),
      Event(
        subjectCode: "44444",
        type: EventType.homework,
        date: DateTime.now().add(Duration(days: 7)),
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
    dispatch(_AcceptNotificationEvent(notification));
  }

  void onIgnoreNotification(EventNotification notification) {
    dispatch(_RejectNotificationEvent(notification));
  }
}
