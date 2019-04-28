library serializers;

import 'package:app_tcc/utils/serializers/timestamp_serializer_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'event.dart';
import 'event_notification.dart';
import 'settings.dart';
import 'subject.dart';
import 'subject_time.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  Settings,
  Subject,
  SubjectTime,
  Event,
  EventNotification,
  EventType,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(TimestampSerializerPlugin()))
    .build();
