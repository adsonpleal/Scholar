import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/action.dart' as action;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_signup_state.dart';

class EmailInput extends StatelessWidget {
  final String Function(String) validator;
  final void Function() onFieldSubmitted;
  final action.Action<String> onSaved;
  final FormMode formMode;
  final FocusNode focusNode;

  const EmailInput({
    Key key,
    @required this.validator,
    @required this.onSaved,
    this.formMode,
    this.onFieldSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: TextFormField(
          focusNode: focusNode,
          textInputAction: formMode == FormMode.resetPassword
              ? null
              : TextInputAction.next,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: Strings.email,
              icon: Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: validator,
          onSaved: onSaved,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        ),
      );
}
