library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'event.dart';
import 'settings.dart';
import 'subject.dart';
import 'subject_time.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  Settings,
  Subject,
  SubjectTime,
  Event,
  EventType,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
