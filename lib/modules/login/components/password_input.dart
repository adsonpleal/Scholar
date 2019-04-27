import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/action.dart';
import 'package:flutter/material.dart';

import '../login_signup_state.dart';

class PasswordInput extends StatelessWidget {
  final String Function(String) validator;
  final Action<String> onSaved;
  final FormMode formMode;

  const PasswordInput({Key key, this.validator, this.onSaved, this.formMode}) : super(key: key);

  @override
  build(BuildContext context) => Visibility(
      visible: formMode != FormMode.resetPassword,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
              hintText: Strings.password,
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: validator,
          onSaved: onSaved,
        ),
      ));
}
