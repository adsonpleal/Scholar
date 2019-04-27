import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final String Function(String) validator;
  final Action<String> onSaved;

  const EmailInput({Key key, @required this.validator, @required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: TextFormField(
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
        ),
      );
}
