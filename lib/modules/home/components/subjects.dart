import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/home/components/subject_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;

class Subjects extends StatelessWidget {
  final BuiltList<Subject> subjects;
  final void Function(Subject) onAdd;
  final void Function(Subject) onRemove;

  const Subjects({
    Key key,
    this.subjects,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subjects == null) return Container();
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(Strings.absenceControl),
      children: _buildSubjects(),
    );
  }

  List<Widget> _buildSubjects() => subjects
      .map((subject) => SubjectItem(
            onAdd: () => onAdd(subject),
            onRemove: () => onRemove(subject),
            subject: subject,
          ))
      .toList();
}
