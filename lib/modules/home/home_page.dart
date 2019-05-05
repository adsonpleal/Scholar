import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/restaurant_menu.dart';
import 'components/schedules.dart';
import 'components/subjects.dart';
import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  static Widget instantiate() => HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _homeBloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _homeBloc,
      builder: (context, HomeState state) => InfoAlert(
            shouldShow: state.showInfoAlert?.value,
            title: Strings.information,
            content: Strings.infoAlertContent,
            child: Scaffold(
              appBar: AppBar(
                title: Text(Strings.home),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
                    tooltip: Strings.information,
                    onPressed: _homeBloc.dispatchShowInfoEvent,
                  )
                ],
              ),
              body: LoadingWrapper(
                isLoading: state.isLoading,
                child: ListView(
                  children: <Widget>[
                    Subjects(
                      subjects: state.subjects,
                      onAdd: _homeBloc.dispatchAddAbsenceEvent,
                      onRemove: _homeBloc.dispatchRemoveAbsenceEvent,
                    ),
                    Schedules(
                      schedule: state.selectedSchedule,
                    ),
                    RestaurantMenu(
                      onNext: _homeBloc.dispatchShowNextMenuEntryEvent,
                      onPrevious: _homeBloc.dispatchShowPreviousMenuEntryEvent,
                      toggleDinner: _homeBloc.dispatchToggleDinnerEvent,
                      state: state,
                    ),
                  ],
                ),
              ),
            ),
          ));
}
