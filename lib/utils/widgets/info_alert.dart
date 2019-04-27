import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter/material.dart';

class InfoAlert extends StatelessWidget {
  final Widget child;
  final String title;
  final String content;
  final Widget widgetContent;
  final bool shouldShow;

  const InfoAlert({this.title, this.content, this.shouldShow, this.child, this.widgetContent});

  @override
  Widget build(BuildContext context) {
    if (shouldShow == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(title),
                  content: widgetContent ?? Text(content),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(Strings.ok),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          ));
    }
    return child;
  }
}
