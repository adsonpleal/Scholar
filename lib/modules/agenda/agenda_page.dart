import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
      ),
      body: Center(
        child: Text("AGENDA"),
      ),
    );
  }
}
