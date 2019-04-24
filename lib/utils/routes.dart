import 'package:flutter/cupertino.dart';

class Routes {
  static const login = "/login";
  static const main = "/main";
  static const home = "/home";
  static const profile = "/profile";
  static const agenda = "/home";
  static const connectUfsc = "/connectUfsc";
  static const root = "/";


  static toConnectUfsc(context) => () {
        Navigator.pushNamed(context, connectUfsc);
      };
}
