import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_signup_state.dart';

class ForgotPasswordButton extends StatelessWidget {
  final FormMode formMode;
  final void Function() onPressed;

  const ForgotPasswordButton({Key key, this.formMode, this.onPressed}) : super(key: key);

  get text {
    if (formMode == FormMode.resetPassword) {
      return Strings.backToLogin;
    }
    return Strings.forgotPassword;
  }

  @override
  Widget build(BuildContext context) => FlatButton(
        child: Text(text, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: onPressed,
      );
}
