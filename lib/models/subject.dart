library subject;

import 'package:app_tcc/models/subject_time.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'subject.g.dart';

const _weekCount = 18;
const _absenceFactor = 4;

abstract class Subject implements Built<Subject, SubjectBuilder> {
  @BuiltValueField(serialize: false)
  @nullable
  String get documentID;

  String get code;

  String get name;

  String get classGroup;

  int get weeklyClassCount;

  int get absenceCount;

  BuiltList<SubjectTime> get times;

  int get maxAbsence => (_weekCount * weeklyClassCount) ~/ _absenceFactor;

  bool get isValid => !absenceCount.isNegative && absenceCount <= maxAbsence;

  Subject._();

  factory Subject([Function(SubjectBuilder b) updates]) = _$Subject;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Subject.serializer, this);
  }

  static Subject fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Subject.serializer, json);
  }

  static fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Subject.fromJson(json)).toList();
  }

  static Serializer<Subject> get serializer => _$subjectSerializer;
}
