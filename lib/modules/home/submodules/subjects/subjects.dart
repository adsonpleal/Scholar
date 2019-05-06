import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/home/submodules/subjects/subjects_bloc.dart';
import 'package:app_tcc/modules/home/submodules/subjects/subjects_state.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'subject_item.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final SubjectsBloc _subjectsBloc = inject();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _subjectsBloc,
        builder: (context, SubjectsState state) {
          if (state.subjects == null) return Container();
          return ExpansionTile(
            initiallyExpanded: false,
            title: Text(Strings.absenceControl),
            children: _buildSubjects(state.subjects),
          );
        });
  }

  List<Widget> _buildSubjects(BuiltList<Subject> subjects) => subjects
      .map((subject) => SubjectItem(
            onAdd: () => _subjectsBloc.dispatchAddAbsenceEvent(subject),
            onRemove: () => _subjectsBloc.dispatchRemoveAbsenceEvent(subject),
            subject: subject,
          ))
      .toList();

  @override
  void dispose() {
    _subjectsBloc.dispose();
    super.dispose();
  }
}
