import 'package:app_tcc/models/event.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import 'agenda_header.dart';
import 'event_list.dart';

class SliverEventsList extends StatelessWidget {
  final List<Event> events;

  const SliverEventsList({
    Key key,
    @required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = groupBy(
      events,
      (Event e) => DateFormat.MMMd().format(e.date),
    );

    List<Widget> slivers = group.keys.map(
      (key) {
        final events = group[key];
        final date = events[0].date;
        final weekDay = DateFormat.E().format(date).toUpperCase();
        final formatedDate = DateFormat.MMMd().format(date);
        return SliverStickyHeader(
          overlapsContent: true,
          header: AgendaHeader(
            weekDay: weekDay,
            formatedDate: formatedDate,
          ),
          sliver: EventList(events: events),
        );
      },
    ).toList();
    // Adds a bottom padding
    slivers.add(SliverStickyHeader(
      header: Container(
        height: 100,
      ),
    ));
    return Flexible(
      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}
