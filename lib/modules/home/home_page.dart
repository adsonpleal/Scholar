import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/home/components/restaurant_menu.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/subject_item.dart';
import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  static Widget instantiate() => HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _homeBloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _homeBloc,
      builder: (context, HomeState state) => InfoAlert(
            shouldShow: state.showInfoAlert?.value,
            title: Strings.information,
            content: Strings.infoAlertContent,
            child: Scaffold(
              appBar: AppBar(
                title: Text(Strings.home),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                    tooltip: Strings.information,
                    onPressed: _homeBloc.showInfoAlert,
                  )
                ],
              ),
              body: ListView(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(Strings.absenceControl),
                    children: _buildSubjects(state.subjects),
                  ),
                  RestaurantMenu(
                    onNext: _homeBloc.showNextMenuEntry,
                    onPrevious: _homeBloc.showPreviousMenuEntry,
                    toggleDinner: _homeBloc.toggleDinner,
                    state: state,
                  ),
                ],
              ),
            ),
          ));

  List<Widget> _buildSubjects(BuiltList<Subject> subjects) {
    if (subjects == null) return [];
    return subjects
        .map((subject) => SubjectItem(
              onAdd: () => _homeBloc.addAbsence(subject),
              onRemove: () => _homeBloc.removeAbsence(subject),
              subject: subject,
            ))
        .toList();
  }
}
