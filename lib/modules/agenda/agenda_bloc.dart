import 'dart:async';

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_builder/annotations.dart';

import 'agenda_state.dart';

part 'agenda_bloc.g.dart';

@BuildBloc(AgendaState)
class AgendaBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  StreamSubscription<List<Event>> _eventsSubscription;
  StreamSubscription<List<EventNotification>> _notificationsSubscription;

  AgendaBloc() {
    _startStreams();
  }

  @override
  AgendaState get initialState => AgendaState.initial();

  Stream<AgendaState> _mapAcceptNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.startLoading();
    await _userData.removeNotification(notification);
    await _userData.createEvent(
      notification.event.rebuild((b) => b..fromNotification = true),
    );
    yield currentState.stopLoading();
  }

  Stream<AgendaState> _mapRejectNotificationToState(
    EventNotification notification,
  ) async* {
    yield currentState.startLoading();
    await _userData.removeNotification(notification);
    yield currentState.stopLoading();
  }

  Stream<AgendaState> _mapEventsChangedToState(List<Event> events) async* {
    yield currentState.rebuild((b) => b..events.replace(events));
  }

  Stream<AgendaState> _mapNotificationsChangedToState(
      List<EventNotification> notifications) async* {
    yield currentState.rebuild((b) => b..notifications.replace(notifications));
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }

  void _startStreams() {
    _eventsSubscription = _userData.eventsStream.listen(
      dispatchEventsChangedEvent,
    );
    _notificationsSubscription = _userData.notificationsStream.listen(
      dispatchNotificationsChangedEvent,
    );
  }
}
