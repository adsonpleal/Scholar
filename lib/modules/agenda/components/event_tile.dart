import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter/material.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;

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
        child: InkWell(
          onTap: Routes.toEventDetails(context, event),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.eventTitle(event.subject.name, event.type),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    Strings.eventStart(event),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
