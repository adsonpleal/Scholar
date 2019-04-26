//import 'package:equatable/equatable.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:json_annotation/json_annotation.dart';
//
//part 'subject_time.g.dart';
//
//@JsonSerializable(nullable: false)
//class SubjectTime extends Equatable {
//  final String weekDay;
//  final String startTime;
//  final int count;
//  final String center;
//  final String room;
//
//  SubjectTime({
//    this.weekDay,
//    this.startTime,
//    this.count,
//    this.center,
//    this.room,
//  }) : super([
//          weekDay,
//          startTime,
//          count,
//          center,
//          room,
//        ]);
//
//  factory SubjectTime.fromJson(Map<String, dynamic> json) => _$SubjectTimeFromJson(json);
//
//  Map<String, dynamic> toJson() => _$SubjectTimeToJson(this);
//
//  Time get timeBeforeTenMinutes {
//    var hour = int.parse(startTime.substring(0, 2));
//    var minutes = int.parse(startTime.substring(2)) - 10;
//    if (minutes < 0) {
//      hour -= 1;
//      minutes += 60;
//    }
//    return Time(hour, minutes, 0);
//  }
//
//  Day get dayOfTheWeek => Day(int.parse(weekDay));
//}

library subject_time;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'serializers.dart';

part 'subject_time.g.dart';

abstract class SubjectTime implements Built<SubjectTime, SubjectTimeBuilder> {
  String get weekDay;

  String get startTime;

  int get count;

  String get center;

  String get room;

  SubjectTime._();

  Time get timeBeforeTenMinutes {
    var hour = int.parse(startTime.substring(0, 2));
    var minutes = int.parse(startTime.substring(2)) - 10;
    if (minutes < 0) {
      hour -= 1;
      minutes += 60;
    }
    return Time(hour, minutes);
  }

  Day get dayOfTheWeek => Day(int.parse(weekDay));

  factory SubjectTime([updates(SubjectTimeBuilder b)]) = _$SubjectTime;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SubjectTime.serializer, this);
  }

  static SubjectTime fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SubjectTime.serializer, json);
  }

  static Serializer<SubjectTime> get serializer => _$subjectTimeSerializer;
}
