import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'agenda_bloc.dart';
import 'agenda_state.dart';
import 'components/add_event_dial.dart';
import 'components/notifications_list.dart';
import 'components/sliver_event_list.dart';

class AgendaPage extends StatefulWidget {
  static Widget instantiate() => AgendaPage();

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final AgendaBloc _agendaBloc = inject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.agenda),
      ),
      body: BlocBuilder(
        bloc: _agendaBloc,
        builder: (context, AgendaState state) => Column(
              children: <Widget>[
                NotificationsList(
                  notifications: state.notifications,
                  onAccept: _agendaBloc.onAcceptNotification,
                  onIgnore: _agendaBloc.onIgnoreNotification,
                ),
                SliverEventsList(events: state.events),
              ],
            ),
      ),
      floatingActionButton: AddEventDial(),
    );
  }

  @override
  void dispose() {
    _agendaBloc.dispose();
    super.dispose();
  }
}
