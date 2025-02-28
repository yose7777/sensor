import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(GlobalKey<NavigatorState> navigatorKey) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!, navigatorKey);
        }
      },
    );
  }

  static void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Pemberitahuan Penting',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      message.notification?.title ?? "Peringatan!",
      message.notification?.body ?? "Ada kondisi bahaya!",
      notificationDetails,
      payload: message.data['screen'], // ✅ Pastikan payload dikirim
    );
  }

  static void _handleNotificationClick(String payload, GlobalKey<NavigatorState> navigatorKey) {
    if (navigatorKey.currentState != null) {
      if (payload == "DangerScreen") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/danger', (route) => false);
      } else if (payload == "HomeScreen") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }
}
