import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final Function(String) validator;
  final Function(String) onSaved;

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
