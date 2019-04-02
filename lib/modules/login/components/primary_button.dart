import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key key, @required this.isLogin, @required this.onPressed})
      : super(key: key);

  final bool isLogin;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(

          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: isLogin
              ? Text(Strings.login,
                  style: TextStyle(fontSize: 20.0, color: Colors.white))
              : Text(Strings.createAccount,
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: onPressed,
        ),
      ));
}
