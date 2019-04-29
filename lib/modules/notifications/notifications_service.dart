import 'dart:async';

import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _payloadStreamController = StreamController<String>();
  final _firebaseMessaging = FirebaseMessaging();

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

  void addNotifications(List<Subject> subjects) {
    removeAllNotifications();
    subjects.forEach((subject) {
      subject.times.forEach((time) {
        scheduleWeeklyNotification(
          title: Strings.classNotification,
          content: subject.name,
          time: time.timeBeforeTenMinutes,
          weekDay: time.dayOfTheWeek,
        );
      });
    });
  }

  void removeAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
