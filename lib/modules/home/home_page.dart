import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/home/components/restaurant_menu.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/menu_item.dart';
import 'components/subject_item.dart';
import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  static Widget instantiate() => HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _homeBloc = inject();
  final _scrollController = ScrollController();

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
                    onPressed: _homeBloc.showInfoAlert,
                  )
                ],
              ),
              body: ListView(
                controller: _scrollController,
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(Strings.absenceControl),
                    children: _buildSubjects(state.subjects),
                  ),
                  ExpansionTile(
                    initiallyExpanded: false,
                    onExpansionChanged: _onRestaurantExpansionChanged,
                    title: Text(Strings.menu),
                    children: [
                      RestaurantMenu(
                        restaurant: state.restaurant,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));

  Future<void> _onRestaurantExpansionChanged(expanded) async {
    if (expanded) {
      await Future.delayed(Duration(milliseconds: 300));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      // _scrollController.
    }
  }

  List<Widget> _buildSubjects(BuiltList<Subject> subjects) {
    if (subjects == null) return [];
    return subjects
        .map((subject) => SubjectItem(
              onAdd: () => _homeBloc.addAbsence(subject),
              onRemove: () => _homeBloc.removeAbsence(subject),
              subject: subject,
            ))
        .toList();
  }
}
