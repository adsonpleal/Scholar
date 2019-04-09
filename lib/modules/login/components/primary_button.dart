import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final FormMode formMode;

  const PrimaryButton({Key key, this.onPressed, this.formMode})
      : super(key: key);

  get text {
    switch (formMode) {
      case FormMode.login:
        return Strings.login;
      case FormMode.signUp:
        return Strings.createAccount;
      case FormMode.resetPassword:
        return Strings.resetPassword;
    }
  }

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
          child:
              Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: onPressed,
        ),
      ));
}