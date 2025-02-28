import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vibration_sensor/servis/notif.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> setupFCM(GlobalKey<NavigatorState> navigatorKey) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notifikasi diizinkan');

      // Ambil token FCM
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveTokenToDatabase(token);
        print('🔥 Token FCM: $token');
      }
void saveTokenToDatabase(String token) async {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final snapshot = await dbRef.child('user_tokens').orderByValue().equalTo(token).get();

  if (!snapshot.exists) {
    await dbRef.child('user_tokens').push().set({"token": token});
    print('✅ Token berhasil disimpan ke Firebase');
  } else {
    print('⚠️ Token sudah ada di database');
  }
}

      // Listener untuk notifikasi masuk saat aplikasi berjalan
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Notifikasi diterima: ${message.notification?.title}");
        LocalNotificationService.showNotification(message);
      });

      // Listener jika aplikasi dibuka dari notifikasi
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("🔗 Notifikasi diklik: ${message.notification?.title}");
        _handleNotificationNavigation(message, navigatorKey);
      });

      // Menangani notifikasi ketika aplikasi dalam keadaan terminated
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          Future.delayed(Duration.zero, () => _handleNotificationNavigation(message, navigatorKey));
        }
      });
    } else {
      print('❌ Izin notifikasi ditolak');
    }
  }

  static void _handleNotificationNavigation(RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) {
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'] ?? 'HomeScreen';
      if (screen == "DangerScreen") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/danger', (route) => false);
      } else if (screen == "HomeScreen") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }

  static Future<void> _saveTokenToDatabase(String token) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child('user_tokens').push().set({"token": token});
    print('✅ Token berhasil disimpan ke Firebase');
  }
}

// Handler untuk notifikasi di background
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Notifikasi diterima di background: ${message.notification?.title}");
}
