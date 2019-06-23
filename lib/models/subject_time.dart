library subject_time;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'serializers.dart';

part 'subject_time.g.dart';

abstract class SubjectTime implements Built<SubjectTime, SubjectTimeBuilder> {
  String get weekDay;

  String get startTime;

  String get center;

  String get room;

  SubjectTime._();

  Time get time {
    final splitIndex = startTime.length - 2;
    final hour = int.parse(startTime.substring(0, splitIndex));
    final minute = int.parse(startTime.substring(splitIndex));
    return Time(hour, minute);
  }

  Day get dayOfTheWeek => Day(int.parse(weekDay));

  int get minutes => time.hour * 60 + time.minute;

  factory SubjectTime([Function(SubjectTimeBuilder b) updates]) = _$SubjectTime;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SubjectTime.serializer, this);
  }

  static SubjectTime fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SubjectTime.serializer, json);
  }

  static Serializer<SubjectTime> get serializer => _$subjectTimeSerializer;
}
