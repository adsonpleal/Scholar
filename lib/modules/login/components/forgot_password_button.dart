import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final FormMode formMode;
  final Function() onPressed;

  const ForgotPasswordButton({Key key, this.formMode, this.onPressed})
      : super(key: key);

  get text {
    if (formMode == FormMode.resetPassword) {
      return Strings.backToLogin;
    }
    return Strings.forgotPassword;
  }

  @override
  Widget build(BuildContext context) => FlatButton(
        child: Text(text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: onPressed,
      );
}
