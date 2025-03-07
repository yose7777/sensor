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
        const InitializationSettings(android: androidInitSettings);

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == "DangerScreen") {
          _navigateToDangerScreen();
        }
      },
    );

    // Setup handler untuk pesan dari Firebase  
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

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
  // Default sound (null berarti pakai suara sistem)
  String? soundName;

  if (message.data.containsKey('notifcondition')) {
    String notifCondition = message.data['notifcondition'];

    switch (notifCondition) {
      case "GEMPA RINGAN!!!":
        soundName = "notif"; // Pastikan file notif.mp3 ada di res/raw
        break;
      case "GEMPA SEDANG":
        soundName = "notif"; 
        break;
      case "GEMPA BAHAYA!!!":
        soundName = "notif"; 
        break;
      case "MODIARRRR!!!":
        soundName = "notif"; 
        break;
      default:
        soundName = null; // Gunakan suara default dari sistem HP
    }
  }

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'Penting',
    importance: Importance.high,
    priority: Priority.high,
    sound: soundName != null ? RawResourceAndroidNotificationSound(soundName) : null,
  );

  final NotificationDetails details = NotificationDetails(android: androidDetails);

  await _flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? "🚨 Peringatan!",
    message.notification?.body ?? "Terjadi kondisi bahaya!",
    details,
    payload: message.data['screen'],
  );
}

  static void _navigateToDangerScreen() {
    // Implementasikan navigasi ke DangerScreen
    navigatorKey.currentState?.pushNamed('/danger');
  }
}
