import 'package:app_tcc/modules/home/home_state.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class RestaurantMenu extends StatelessWidget {
  final HomeState state;
  final void Function() onNext;
  final void Function() onPrevious;
  final void Function() toggleDinner;

  RestaurantMenu({
    Key key,
    this.state,
    this.onNext,
    this.onPrevious,
    this.toggleDinner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant = state.restaurant;
    if (restaurant == null) return Container();
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(Strings.menu),
      children: <Widget>[
        _buildPageHeader(),
        Visibility(
          visible: state.hasDinner,
          child: CheckboxListTile(
            title: Text(Strings.showDinner),
            value: state.showDinner,
            onChanged: (_) => toggleDinner(),
          ),
        ),
      ]..addAll(state.menuEntry.plates.map((plate) => ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text(plate),
          ))),
    );
  }

  Widget _buildPageHeader() {
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
                onPressed: onPrevious,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                    DateFormat.EEEE().format(state.menuEntry.date).toUpperCase()),
                Text(DateFormat.yMd().format(state.menuEntry.date).toUpperCase()),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: !state.showNext,
            child: new Opacity(
              opacity: state.showNext ? 1 : 0,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
