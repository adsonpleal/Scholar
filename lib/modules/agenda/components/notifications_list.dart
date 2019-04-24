import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';

import 'notification_item.dart';

class NotificationsList extends StatelessWidget {
  final List<EventNotification> notifications;

  const NotificationsList({
    Key key,
    @required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: notifications.length > 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
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
          Container(
            height: 140,
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  NotificationItem(
                    notification: notifications[index],
                  ),
              itemCount: notifications.length,
            ),
          ),
        ],
      ),
    );
  }
}
