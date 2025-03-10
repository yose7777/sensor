import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:vibration_sensor/main.dart';

class NotifikasiService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void init() {
    // Inisialisasi setting notifikasi lokal
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == "DangerScreen") {
          _navigateToDangerScreen();
        }
      },
    );

    // 🔹 Tangani notifikasi jika aplikasi dalam keadaan terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && message.data['screen'] == "DangerScreen") {
        _navigateToDangerScreen();
      }
    });

    // 🔹 Tangani notifikasi saat aplikasi berjalan di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // 🔹 Tangani notifikasi saat pengguna mengetuk notifikasi di background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'];
      if (screen == "DangerScreen") {
        _navigateToDangerScreen();
      }
    }

    _showNotification(message);
  }

  static void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Penting',
      importance: Importance.high,
      priority: Priority.high,
      // sound: RawResourceAndroidNotificationSound('notif'),
    );
   
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "🚨 Peringatan!",
      message.notification?.body ?? "Terjadi kondisi bahaya!",
      details,
      payload: message.data['screen'],
    );
  }

  static void _navigateToDangerScreen() {
    debugPrint("🔴 Navigasi ke DangerScreen");
    navigatorKey.currentState?.pushNamed('/danger');
  }
}
