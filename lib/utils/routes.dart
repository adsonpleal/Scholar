import 'package:app_tcc/models/event.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static const login = "/login";
  static const main = "/main";
  static const home = "/home";
  static const profile = "/profile";
  static const agenda = "/agenda";
  static const connectUfsc = "/connectUfsc";
  static const newEvent = "/newEvent";
  static const root = "/";

  static toConnectUfsc(context) => () {
        Navigator.pushNamed(context, connectUfsc);
      };

  static toNewEvent(context, EventType type) => () {
        Navigator.pushNamed(
          context,
          newEvent,
          arguments: type,
        );
      };

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
