import 'package:app_tcc/modules/home/submodules/schedules.dart/schedules_bloc.dart';
import 'package:app_tcc/modules/home/submodules/schedules.dart/schedules_state.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter_bloc/flutter_bloc.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  final SchedulesBloc _schedulesBloc = inject();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _schedulesBloc,
        builder: (context, SchedulesState state) {
          if (state.schedules == null) return Container();
          return ExpansionTile(
            initiallyExpanded: false,
            title: Text(Strings.schedules),
            children: children(state),
          );
        });
  }

  List<Widget> children(SchedulesState state) {
    final times = state.selectedSchedule.times;
    return <Widget>[
      _buildPageHeader(state),
      if (times.isEmpty)
        ListTile(
          title: Text(Strings.noSchedule),
        )
      else
        for (final t in times)
          ListTile(
            title: Text(Strings.hourMinute(t.time)),
            subtitle: Text(t.subject.name),
          ),
    ];
  }

  Widget _buildPageHeader(SchedulesState state) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _schedulesBloc.dispatchShowPreviousEvent,
          ),
          Expanded(
            child: Center(
              child: Text(
                Strings.weekDay(state.selectedSchedule.weekDay).toUpperCase(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _schedulesBloc.dispatchShowNextEvent,
          ),
        ],
      ),
    );
  }
}
