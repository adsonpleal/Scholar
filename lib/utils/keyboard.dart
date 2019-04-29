import 'package:flutter/widgets.dart';

void dismissKeyboard(BuildContext context, {Function onDismissed}) {
  final node = FocusNode();
  node.addListener(() {
    if (node.hasFocus) {
      node.dispose();
      if (onDismissed != null) {
        Future.delayed(const Duration(milliseconds: 100), onDismissed);
      }
    }
  });
  FocusScope.of(context).requestFocus(node);  
}
