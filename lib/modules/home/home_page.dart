import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/subject_item.dart';
import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  static instantiate() => HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _homebloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _homebloc,
      builder: (context, HomeState state) => InfoAlert(
            shouldShow: state.showInfoAlert?.value,
            title: Strings.informations,
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
                    tooltip: Strings.informations,
                    onPressed: _homebloc.showInfoAlert,
                  )
                ],
              ),
              body: ListView(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(Strings.absenceControl),
                    children: state.subjects
                            ?.map((subject) => SubjectItem(
                                  onAdd: () => _homebloc.addAbsence(subject),
                                  onRemove: () => _homebloc.removeAbsence(subject),
                                  subject: subject,
                                ))
                            ?.toList() ??
                        [],
                  )
                ],
              ),
            ),
          ));
}
