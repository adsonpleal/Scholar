library event;

import 'package:app_tcc/models/subject.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'event.g.dart';

abstract class Event implements Built<Event, EventBuilder> {
  DateTime get date;
  Subject get subject;
  String get description;
  EventType get type;
  bool get fromNotification;

  Event._();

  factory Event([Function(EventBuilder b) updates]) => _$Event((b) => b
    ..fromNotification = false
    ..update(updates));

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Event.serializer, this);
  }

  static Event fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Event.serializer, json);
  }

  static Serializer<Event> get serializer => _$eventSerializer;
}

class EventType extends EnumClass {
  static const EventType test = _$test;
  static const EventType homework = _$homework;

  const EventType._(String name) : super(name);

  static BuiltSet<EventType> get values => _$values;

  static EventType valueOf(String name) => _$valueOf(name);

  static Serializer<EventType> get serializer => _$eventTypeSerializer;
}
