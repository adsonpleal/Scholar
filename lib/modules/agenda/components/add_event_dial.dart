import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AddEventDial extends StatelessWidget {
  const AddEventDial({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: Strings.addEvent,
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.list),
          backgroundColor: Colors.red,
          label: Strings.test,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: Routes.toNewEvent(context, EventType.test),
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment),
          backgroundColor: Colors.green,
          label: Strings.homework,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: Routes.toNewEvent(context, EventType.homework),
        ),
      ],
    );
  }
}
