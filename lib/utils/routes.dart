import 'package:app_tcc/models/event.dart';
import 'package:flutter/widgets.dart';

const login = "/login";
const main = "/main";
const home = "/home";
const profile = "/profile";
const agenda = "/agenda";
const connectUfsc = "/connectUfsc";
const newEvent = "/newEvent";
const root = "/";

void Function() toNewEvent(context, EventType type) => () {
      Navigator.pushNamed(
        context,
        newEvent,
        arguments: type,
      );
    };

void pop(BuildContext context) {
  Navigator.of(context).pop();
}
