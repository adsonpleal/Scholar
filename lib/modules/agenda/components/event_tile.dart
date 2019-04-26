import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Strings.eventTitle(event.subjectCode, event.type),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                Strings.eventStart(event),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
