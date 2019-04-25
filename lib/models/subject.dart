import 'package:app_tcc/models/subject_time.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

const _weekCount = 18;
const _absenceFactor = 4;

@JsonSerializable(nullable: false)
class Subject extends Equatable {
  @JsonKey(ignore: true)
  String documentID;
  final String code;
  final String name;
  final String classGroup;
  final int weeklyClassCount;
  @JsonKey(nullable: true, defaultValue: 0)
  final int absenceCount;
  @JsonKey(toJson: _timesToJson, fromJson: _timesFromJson)
  final List<SubjectTime> times;

  Subject({
    this.code,
    this.name,
    this.classGroup,
    this.times,
    this.weeklyClassCount,
    this.absenceCount,
    this.documentID,
  }) : super([
          code,
          name,
          classGroup,
          times,
          weeklyClassCount,
          absenceCount,
          documentID,
        ]);

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  static fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Subject.fromJson(json)).toList();

  static List<Map<String, dynamic>> _timesToJson(List<SubjectTime> times) =>
      times.map((t) => t.toJson()).toList();

  static List<SubjectTime> _timesFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SubjectTime.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  int get maxAbsence => (_weekCount * weeklyClassCount) ~/ _absenceFactor;

  bool get isValid => !absenceCount.isNegative && absenceCount <= maxAbsence;

  Subject changeValues({
    code,
    name,
    classGroup,
    weeklyClassCount,
    absenceCount,
    times,
  }) =>
      Subject(
        code: code ?? this.code,
        name: name ?? this.name,
        classGroup: classGroup ?? this.classGroup,
        weeklyClassCount: weeklyClassCount ?? this.weeklyClassCount,
        absenceCount: absenceCount ?? this.absenceCount,
        times: times ?? this.times,
        documentID: this.documentID,
      );
}
