import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {Key key, @required this.isLogin, @required this.onPressed})
      : super(key: key);

  final bool isLogin;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLogin
          ? Text(Strings.createAnAccount,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : Text('Have an account? Sign in',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: onPressed,
    );
  }
}
