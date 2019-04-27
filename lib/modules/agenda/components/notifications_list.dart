import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'notification_item.dart';

class NotificationsList extends StatelessWidget {
  final BuiltList<EventNotification> notifications;
  final void Function(EventNotification) onIgnore;
  final void Function(EventNotification) onAccept;

  const NotificationsList({
    Key key,
    @required this.notifications,
    @required this.onIgnore,
    @required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: notifications.length > 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: Text(
                Strings.notifications,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 140,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => NotificationItem(
                      notification: notifications[index],
                      onIgnore: onIgnore,
                      onAccept: onAccept,
                    ),
                itemCount: notifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
