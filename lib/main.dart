import 'package:app_tcc/modules/root/root_page.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: Strings.appName,
      routes: {'/': (context) => RootPage()},
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ));
}
