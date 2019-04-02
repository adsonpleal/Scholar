import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key key, @required this.errorMessage}) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage.length > 0 && errorMessage != null) {
      return Center(
          child: Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      ));
    } else {
      return Container();
    }
  }
}
