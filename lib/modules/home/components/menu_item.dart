import 'package:app_tcc/models/menu_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuItem extends StatelessWidget {
  final MenuEntry menuEntry;
  final bool showNext;
  final bool showPrevious;
  final void Function() onNext;
  final void Function() onPrevious;

  const MenuItem({
    Key key,
    this.menuEntry,
    this.showNext,
    this.showPrevious,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IgnorePointer(
                ignoring: !showPrevious,
                child: new Opacity(
                  opacity: showPrevious ? 1 : 0,
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
                        DateFormat.EEEE().format(menuEntry.date).toUpperCase()),
                    Text(DateFormat.yMd().format(menuEntry.date).toUpperCase()),
                  ],
                ),
              ),
              IgnorePointer(
                ignoring: !showNext,
                child: new Opacity(
                  opacity: showNext ? 1 : 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: onNext,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 16),
            itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(menuEntry.plates[index]),
                ),
            itemCount: menuEntry.plates.length,
          ),
        ),
      ],
    );
  }
}
