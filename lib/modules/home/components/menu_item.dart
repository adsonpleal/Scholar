import 'package:app_tcc/models/menu_entry.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {

  final MenuEntry menuEntry;

  const MenuItem({Key key, this.menuEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement item
    return Text(menuEntry.date.toString());
  }
}
