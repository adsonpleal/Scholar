import 'dart:async';

import 'package:app_tcc/models/schedule.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      inject();
  final FirebaseMessaging _firebaseMessaging = inject();
  final _payloadStreamController = StreamController<String>();

  Stream<String> get payloadStream => _payloadStreamController.stream;

  NotificationsService() {
    var initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future _onSelectNotification(String payload) async {
    _payloadStreamController.add(payload);
  }

  Future<String> get token => _firebaseMessaging.getToken();

  void scheduleWeeklyNotification({
    Time time,
    Day weekDay,
    String title,
    String content,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Strings.generalChannel,
      Strings.generalChannel,
      Strings.generalChannelDescription,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      title,
      content,
      weekDay,
      time,
      platformChannelSpecifics,
    );
  }

  void dispose() {
    _payloadStreamController.close();
  }

  void addNotifications(List<Schedule> schedules) {
    removeAllNotifications();
    schedules.forEach((s) {
      final filteredTimes = [];
      Subject currentSubject;
      s.times.sort((t1, t2) => t1.minutes - t2.minutes);
      s.times.forEach((t) {
        if (t.subject != currentSubject) {
          filteredTimes.add(t);
        }
        currentSubject = t.subject;
      });
      filteredTimes.forEach((t) {
        scheduleWeeklyNotification(
          title: Strings.classNotification,
          content: t.subject.name,
          time: t.timeBeforeTenMinutes,
          weekDay: s.weekDay,
        );
      });
    });
  }

  void removeAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
