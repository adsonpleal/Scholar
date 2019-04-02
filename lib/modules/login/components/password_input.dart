import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;

  const PasswordInput(
      {Key key, @required this.validator, @required this.onSaved})
      : super(key: key);

  @override
  build(BuildContext context) => Padding(
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
  );
}
