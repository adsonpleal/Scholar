import 'package:app_tcc/models/event.dart';
import 'package:flutter/widgets.dart';

const login = "/login";
const main = "/main";
const home = "/home";
const profile = "/profile";
const agenda = "/agenda";
const connectUfsc = "/connectUfsc";
const newEvent = "/newEvent";
const eventDetails = "/eventDetails";
const root = "/";

void Function() toNewEvent(context, EventType type) => () {
      Navigator.pushNamed(
        context,
        newEvent,
        arguments: type,
      );
    };

void Function() toEventDetails(context, Event event) => () {
      Navigator.pushNamed(
        context,
        eventDetails,
        arguments: event,
      );
    };

void pop(BuildContext context) {
  Navigator.of(context).pop();
}
