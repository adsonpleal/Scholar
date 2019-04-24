import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/subject_item.dart';
import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  static instantiate() => HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

//TODO: Refactor this class
class _HomePageState extends State<HomePage> {
  final HomeBloc _homebloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _homebloc,
      builder: (context, HomeState state) => InfoAlert(
            shouldShow: state.showInfoAlert?.value,
            title: "Informações",
            content:
                "Controle de faltas:\n - Cada falta é um período, caso você tenha duas aulas no mesmo dia adicione duas faltas.",
            child: Scaffold(
              appBar: AppBar(
                title: Text(Strings.home),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                    tooltip: 'Informações',
                    onPressed: _homebloc.showInfoAlert,
                  )
                ],
              ),
              body: ListView(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text("Controle de faltas"),
                    children: state.subjects
                            ?.map((subject) => SubjectItem(
                                  onAdd: () => _homebloc.addAbsence(subject),
                                  onRemove: () =>
                                      _homebloc.removeAbsence(subject),
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
