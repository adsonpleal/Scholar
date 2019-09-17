import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/time.dart';

class ScheduleTime {
  final Time time;
  final Subject subject;

  ScheduleTime({this.time, this.subject});

  int get minutes => time.hour * 60 + time.minute;

  Time get timeBeforeTenMinutes {
    final oldTime = time;
    var hour = oldTime.hour;
    var minute = oldTime.minute - 10;
    if (minute < 0) {
      hour -= 1;
      minute += 60;
    }
    return Time(hour, minute);
  }
}
