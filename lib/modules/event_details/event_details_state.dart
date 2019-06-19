library agenda_state;

import 'package:app_tcc/models/single_event.dart';
import 'package:built_value/built_value.dart';

part 'event_details_state.g.dart';

abstract class EventDetailsState
    implements Built<EventDetailsState, EventDetailsStateBuilder> {
  bool get loading;
  @nullable
  SingleEvent<bool> get dismiss;

  EventDetailsState._();

  factory EventDetailsState([Function(EventDetailsStateBuilder b) updates]) =
      _$EventDetailsState;

  factory EventDetailsState.initial() =>
      EventDetailsState((b) => b..loading = false);

  EventDetailsState startLoading() => rebuild((b) => b..loading = true);
  EventDetailsState stopLoading() => rebuild((b) => b..loading = false);
}
