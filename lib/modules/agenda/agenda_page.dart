import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';

import 'components/add_event_dial.dart';
import 'components/notifications_list.dart';
import 'components/sliver_event_list.dart';


// TODO: ADD REAL DATA FROM SERVER
class AgendaPage extends StatelessWidget {
  static instantiate() => AgendaPage();

  final events = [
    Event(
      createdAt: DateTime.now(),
      eventCode: "11111",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "222222",
      type: EventType.test,
      date: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "33333",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "44444 ",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 2)),
      endTime: DateTime.now().add(Duration(days: 2)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "11111",
      type: EventType.test,
      date: DateTime.now().add(Duration(days: 2)),
      endTime: DateTime.now().add(Duration(days: 2)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "222222",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 3)),
      endTime: DateTime.now().add(Duration(days: 3)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "33333",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 3)),
      endTime: DateTime.now().add(Duration(days: 3)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "44444 ",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 4)),
      endTime: DateTime.now().add(Duration(days: 4)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "11111",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 5)),
      endTime: DateTime.now().add(Duration(days: 5)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "222222",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 6)),
      endTime: DateTime.now().add(Duration(days: 6)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "33333",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 7)),
      endTime: DateTime.now().add(Duration(days: 7)).add(Duration(hours: 1)),
    ),
    Event(
      createdAt: DateTime.now(),
      eventCode: "44444",
      type: EventType.homework,
      date: DateTime.now().add(Duration(days: 7)),
      endTime: DateTime.now().add(Duration(days: 7)).add(Duration(hours: 1)),
    ),
  ];

  List<EventNotification> get notifications => events
      .map(
        (e) => EventNotification(
              createdAt: DateTime.now(),
              event: e,
            ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.agenda),
      ),
      body: Column(
        children: <Widget>[
          NotificationsList(notifications: notifications),
          SliverEventsList(events: events),
        ],
      ),
      floatingActionButton: AddEventDial(),
    );
  }
}
