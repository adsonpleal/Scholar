import 'package:app_tcc/models/schedule.dart';
import 'package:flutter/material.dart';

// TODO: finish this component
class Schedules extends StatelessWidget {
  final Schedule schedule;

  const Schedules({
    Key key,
    this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations.of(context).narrowWeekdays;
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text('Horários'),
      children: children,
    );
  }

  List<Widget> get children {
    final items = <Widget>[Text('TODO Header')];
    if (schedule.times.isEmpty) {
      items.add(Text('TODO placeholder'));
    } else {
      items.addAll(schedule.times.map((t) => ListTile(
            title: Text('${t.time.hour}:${t.time.minute}'),
            subtitle: Text('${t.subject.name}'),
          )));
    }
    return items;
  }
  
}
