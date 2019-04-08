import 'package:flutter/cupertino.dart';

class Routes {
  static const login = "/login";
  static const main = "/main";
  static const root = "/";

  static void replace(context, route) {
    if (route != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushReplacementNamed(context, route));
    }
  }
}
