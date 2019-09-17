import 'package:app_tcc/models/schedule_time.dart';
import 'day.dart';

class Schedule {
  final Day weekDay;
  List<ScheduleTime> times = [];

  Schedule(this.weekDay);
}
