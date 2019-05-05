import 'package:app_tcc/models/schedule_time.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Schedule {
  final Day weekDay;
  List<ScheduleTime> times = [];

  Schedule(this.weekDay);
}
