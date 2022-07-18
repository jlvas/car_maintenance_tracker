

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();


  static Future<void> showNotification({int id = 0, String? title, String ? body, String? payload})async{
    return _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload
    );
  }

  static Future _notificationDetails()async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false})async{
    final iOS = IOSInitializationSettings();
    final android = AndroidInitializationSettings('@drawable/mipmap-hdpi/ic_launcher.png');
    final settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }
}