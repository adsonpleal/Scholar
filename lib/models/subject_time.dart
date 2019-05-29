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
    var hour = int.parse(startTime.substring(0, 2));
    var minute = int.parse(startTime.substring(2));
    return Time(hour, minute);
  }

  Time get timeBeforeTenMinutes {
    final oldTime = time;
    var hour = oldTime.hour;
    var minute = oldTime.minute - 10;
    if (minute < 0) {
      hour -= 1;
      minute += 60;
    }
    return Time(hour, minute);
  }

  Day get dayOfTheWeek => Day(int.parse(weekDay) - 1);

  factory SubjectTime([Function(SubjectTimeBuilder b) updates]) = _$SubjectTime;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SubjectTime.serializer, this);
  }

  static SubjectTime fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SubjectTime.serializer, json);
  }

  static Serializer<SubjectTime> get serializer => _$subjectTimeSerializer;
}
