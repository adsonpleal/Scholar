import 'dart:async';

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

import 'agenda_state.dart';

class _AgendaEvent {}

class _AcceptNotificationEvent extends _AgendaEvent {
  final EventNotification notification;

  _AcceptNotificationEvent(this.notification);
}

class _EventsChangedEvent extends _AgendaEvent {
  final List<Event> events;

  _EventsChangedEvent(this.events);
}

class _NotificationsChangedEvent extends _AgendaEvent {
  final List<EventNotification> notifications;

  _NotificationsChangedEvent(this.notifications);
}

class _RejectNotificationEvent extends _AgendaEvent {
  final EventNotification notification;

  _RejectNotificationEvent(this.notification);
}

class AgendaBloc extends Bloc<_AgendaEvent, AgendaState> {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Event>> _eventsSubscription;
  StreamSubscription<List<EventNotification>> _notificationsSubscription;

  AgendaBloc() {
    _startStreams();
  }

  @override
  AgendaState get initialState => AgendaState.initial();

  @override
  Stream<AgendaState> mapEventToState(_AgendaEvent e) async* {
    if (e is _EventsChangedEvent) yield* _eventsChangedToState(e.events);
    if (e is _NotificationsChangedEvent) yield* _notificationsChangedToState(e.notifications);
    if (e is _AcceptNotificationEvent) yield* _acceptNotificationToState(e.notification);
    if (e is _RejectNotificationEvent) yield* _rejectNotificationToState(e.notification);
  }

  Stream<AgendaState> _acceptNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.rebuild((b) => b
      ..notifications.remove(notification)
      ..events.add(notification.event));
  }

  Stream<AgendaState> _rejectNotificationToState(EventNotification notification) async* {
    yield currentState.rebuild((b) => b..notifications.remove(notification));
  }

  Stream<AgendaState> _eventsChangedToState(List<Event> events) async* {
    yield currentState.rebuild((b) => b..events.replace(events));
  }

  Stream<AgendaState> _notificationsChangedToState(List<EventNotification> notifications) async* {
    yield currentState.rebuild((b) => b..notifications.replace(notifications));
  }

  void onAcceptNotification(EventNotification notification) {
    dispatch(_AcceptNotificationEvent(notification));
  }

  void onIgnoreNotification(EventNotification notification) {
    dispatch(_RejectNotificationEvent(notification));
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startStreams() async {
    final eventsStream = await _userData.eventsStream;
    final notificationsStream = await _userData.notificationsStream;
    _eventsSubscription = eventsStream.listen((e) => dispatch(_EventsChangedEvent(e)));
    _notificationsSubscription = notificationsStream.listen((e) => dispatch(
          _NotificationsChangedEvent(e),
        ));
  }
}
