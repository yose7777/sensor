import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static void showNotification(RemoteMessage message) {
    var androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'Pemberitahuan Penting',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      generalNotificationDetails,
    );
  }
}
