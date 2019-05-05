import 'package:app_tcc/models/subject.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ScheduleTime {
  final Time time;
  final Subject subject;

  ScheduleTime({this.time, this.subject});
}
