library event_notification;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'event.dart';
import 'serializers.dart';

part 'event_notification.g.dart';

abstract class EventNotification implements Built<EventNotification, EventNotificationBuilder> {
  @BuiltValueField(serialize: false)
  @nullable
  String get documentID;

  Event get event;

  EventNotification._();

  factory EventNotification([Function(EventNotificationBuilder b) updates]) = _$EventNotification;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(EventNotification.serializer, this);
  }

  static EventNotification fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(EventNotification.serializer, json);
  }

  static Serializer<EventNotification> get serializer => _$eventNotificationSerializer;
}
