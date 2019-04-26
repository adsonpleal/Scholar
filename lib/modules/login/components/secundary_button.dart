import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_signup_state.dart';

class SecondaryButton extends StatelessWidget {
  final FormMode formMode;
  final Function() onPressed;

  const SecondaryButton({Key key, this.formMode, this.onPressed}) : super(key: key);

  get text {
    if (formMode == FormMode.login) {
      return Strings.createAnAccount;
    }
    return Strings.haveAnAccount;
  }

  @override
  Widget build(BuildContext context) => Visibility(
      visible: formMode != FormMode.resetPassword,
      child: FlatButton(
        child: Text(text, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: onPressed,
      ));
}
