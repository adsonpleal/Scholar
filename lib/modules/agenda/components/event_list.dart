import 'package:app_tcc/models/event.dart';
import 'package:flutter/material.dart';

import 'event_tile.dart';

class EventList extends StatelessWidget {
  const EventList({
    Key key,
    @required this.events,
  }) : super(key: key);

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: EdgeInsets.only(left: 65.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => EventTile(

                    event: events[index],
                  ),
              childCount: events.length),
        ));
  }
}
