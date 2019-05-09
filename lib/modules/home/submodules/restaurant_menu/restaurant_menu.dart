import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'restaurant_menu_bloc.dart';
import 'restaurant_menu_state.dart';

class RestaurantMenu extends StatefulWidget {
  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  final RestaurantMenuBloc _restaurantMenuBloc = inject();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _restaurantMenuBloc,
        builder: (context, RestaurantMenuState state) {
          if (!state.isValid) return Container();
          return ExpansionTile(
              initiallyExpanded: false,
              title: Text(Strings.menu),
              children: <Widget>[
                _buildPageHeader(state),
                if (state.hasDinner)
                  CheckboxListTile(
                    title: Text(Strings.showDinner),
                    value: state.showDinner,
                    onChanged: (_) =>
                        _restaurantMenuBloc.dispatchToggleDinnerEvent(),
                  ),
                for (final plate in state.menuEntry.plates)
                  ListTile(
                    leading: const Icon(Icons.restaurant_menu),
                    title: Text(plate),
                  )
              ]);
        });
  }

  Widget _buildPageHeader(RestaurantMenuState state) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IgnorePointer(
            ignoring: !state.showPrevious,
            child: new Opacity(
              opacity: state.showPrevious ? 1 : 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed:
                    _restaurantMenuBloc.dispatchShowPreviousMenuEntryEvent,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(DateFormat.EEEE()
                    .format(state.menuEntry.date)
                    .toUpperCase()),
                Text(DateFormat.yMd()
                    .format(state.menuEntry.date)
                    .toUpperCase()),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: !state.showNext,
            child: new Opacity(
              opacity: state.showNext ? 1 : 0,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _restaurantMenuBloc.dispatchShowNextMenuEntryEvent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _restaurantMenuBloc.dispose();
    super.dispose();
  }
}
