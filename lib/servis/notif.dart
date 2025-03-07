import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          handleNotificationNavigationPayload(response.payload!, navigatorKey);
        }
      },
    );
  }

  static void showNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'Pemberitahuan Penting',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      // sound: RawResourceAndroidNotificationSound('notif'),
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "Peringatan!",
      message.notification?.body ?? "Ada kondisi bahaya!",
      generalNotificationDetails,
      payload: message.data['screen'],
    );
  }

  static void handleNotificationNavigationPayload(String? payload, GlobalKey<NavigatorState> navigatorKey) {
    if (payload == null) return;
    String? currentRoute = ModalRoute.of(navigatorKey.currentContext!)?.settings.name;

    if (payload == "HomeScreen" && currentRoute != '/home') {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }
}
