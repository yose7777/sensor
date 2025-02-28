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
          _handleNotificationClick(response.payload!, navigatorKey);
        }
      },
    );

    // Handle jika aplikasi dibuka dari notifikasi saat background atau terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(Duration.zero, () {
          _handleNotificationClick(message.data['screen'], navigatorKey);
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data['screen'], navigatorKey);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Jika notifikasi diterima saat aplikasi aktif, tampilkan pop-up
      if (message.notification != null) {
        showNotification(message);
      }
    });
  }

  static void showNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'Pemberitahuan Penting',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true, // Pastikan notifikasi bisa muncul di layar penuh
      category: AndroidNotificationCategory.alarm, // Memastikan Android menganggap ini darurat
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

  static void _handleNotificationClick(String payload, GlobalKey<NavigatorState> navigatorKey) {
    if (navigatorKey.currentState != null) {
      String? currentRoute = ModalRoute.of(navigatorKey.currentContext!)?.settings.name;

      if (payload == "DangerScreen" && currentRoute != '/danger') {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/danger', (route) => false);
      } else if (payload == "HomeScreen" && currentRoute != '/home') {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }
}
