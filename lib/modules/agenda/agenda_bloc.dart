import 'dart:async';

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/modules/base/bloc_event.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

import 'agenda_state.dart';

enum _AgendaEventType {
  acceptNotification,
  rejectNotification,
  eventsChanged,
  notificationsChanged,
}

class _AgendaEvent extends BlocEvent<_AgendaEventType> {
  _AgendaEvent({type, payload}) : super(type, payload);
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
  Stream<AgendaState> mapEventToState(_AgendaEvent event) async* {
    switch (event.type) {
      case _AgendaEventType.acceptNotification:
        yield* _acceptNotificationToState(event.payload);
        break;
      case _AgendaEventType.rejectNotification:
        yield* _rejectNotificationToState(event.payload);
        break;
      case _AgendaEventType.eventsChanged:
        yield* _eventsChangedToState(event.payload);
        break;
      case _AgendaEventType.notificationsChanged:
        yield* _notificationsChangedToState(event.payload);
        break;
    }
  }

  Stream<AgendaState> _acceptNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.startLoading();
    await _userData.removeNotification(notification);
    await _userData.createEvent(
      notification.event.rebuild((b) => b..fromNotification = true),
    );
    yield currentState.stopLoading();
  }

  Stream<AgendaState> _rejectNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.startLoading();
    await _userData.removeNotification(notification);
    yield currentState.stopLoading();
  }

  Stream<AgendaState> _eventsChangedToState(List<Event> events) async* {
    yield currentState.rebuild((b) => b..events.replace(events));
  }

  Stream<AgendaState> _notificationsChangedToState(
      List<EventNotification> notifications) async* {
    yield currentState.rebuild((b) => b..notifications.replace(notifications));
  }

  void onAcceptNotification(EventNotification notification) {
    dispatch(_AgendaEvent(
      type: _AgendaEventType.acceptNotification,
      payload: notification,
    ));
  }

  void onIgnoreNotification(EventNotification notification) {
    dispatch(_AgendaEvent(
      type: _AgendaEventType.rejectNotification,
      payload: notification,
    ));
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }

  void _startStreams() {
    _eventsSubscription = _userData.eventsStream.listen(
      (events) => dispatch(_AgendaEvent(
            type: _AgendaEventType.eventsChanged,
            payload: events,
          )),
    );
    _notificationsSubscription = _userData.notificationsStream.listen(
      (notifications) => dispatch(_AgendaEvent(
            type: _AgendaEventType.notificationsChanged,
            payload: notifications,
          )),
    );
  }
}
