import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject_time.g.dart';

@JsonSerializable(nullable: false)
class SubjectTime extends Equatable {
  final String weekDay;
  final String startTime;
  final int count;
  final String center;
  final String room;

  SubjectTime({
    this.weekDay,
    this.startTime,
    this.count,
    this.center,
    this.room,
  }) : super([
          weekDay,
          startTime,
          count,
          center,
          room,
        ]);

  factory SubjectTime.fromJson(Map<String, dynamic> json) =>
      _$SubjectTimeFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectTimeToJson(this);
}
