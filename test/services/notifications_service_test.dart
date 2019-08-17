import 'package:app_tcc/models/schedule.dart';
import 'package:app_tcc/models/schedule_time.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/modules/splash/splash_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mockito/mockito.dart';

import '../utils/mocks.dart';

void main() {
  final Container container = Container();
  NotificationsService notificationsService;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging firebaseMessaging;

  setUp(() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPluginMock();
    firebaseMessaging = FirebaseMessagingMock();
    container.registerSingleton((c) => flutterLocalNotificationsPlugin);
    container.registerSingleton((c) => firebaseMessaging);
    notificationsService = NotificationsService();
  });

  tearDown(() {
    container.clear();
  });

  test('test notification', () {
    final subject1 = Subject((b) => b
      ..code = "code"
      ..name = "name"
      ..classGroup = "classGroup"
      ..weeklyClassCount = 1
      ..absenceCount = 0);
    final subject2 = Subject((b) => b
      ..code = "code2"
      ..name = "name2"
      ..classGroup = "classGroup2"
      ..weeklyClassCount = 2
      ..absenceCount = 0);
    final scheduleTime1 = ScheduleTime(
      time: Time(1, 0, 0),
      subject: subject1,
    );
    final scheduleTime2 = ScheduleTime(
      time: Time(2, 0, 0),
      subject: subject2,
    );
    final schedules = [
      Schedule(Day.Monday)..times = [scheduleTime1, scheduleTime2],
    ];
    notificationsService.addNotifications(schedules);
    verify(flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      any,
      scheduleTime1.subject.name,
      any,
      any,
      any,
    ));
    verify(flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      any,
      scheduleTime2.subject.name,
      any,
      any,
      any,
    ));
  });
}
