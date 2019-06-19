import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;

import 'event_details_bloc.dart';
import 'event_details_state.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventDetailsBloc _eventDetailsBloc = inject();
  Event _event;

  @override
  Widget build(BuildContext context) {
    _event = ModalRoute.of(context).settings.arguments;
    return BlocBuilder(
      bloc: _eventDetailsBloc,
      builder: (context, EventDetailsState state) => RoutingWrapper(
            pop: state.dismiss?.value,
            child: LoadingWrapper(
              isLoading: state.loading,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(Strings.eventType(_event.type)),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      tooltip: Strings.removeEvent,
                      onPressed: _confirmationDialog,
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.short_text),
                        title: Text(_event.description),
                      ),
                      ListTile(
                        leading: const Icon(Icons.class_),
                        title: Text(_event.subject.name),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(Strings.fullDateAndTime(_event.date)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void Function() get _confirmationDialog => () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(Strings.removeEventQuestion),
                content: Text(Strings.removeEventDescription),
                actions: <Widget>[
                  FlatButton(
                    child: Text(Strings.cancel),
                    onPressed: Navigator.of(context).pop,
                  ),
                  FlatButton(
                    child: Text(Strings.confirm),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _eventDetailsBloc
                          .dispatchDeleteEventEvent(_event.documentId);
                    },
                  ),
                ],
              ),
        );
      };
}
