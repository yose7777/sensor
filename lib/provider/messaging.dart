import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vibration_sensor/servis/notif.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notifikasi diizinkan');

      String? token = await _firebaseMessaging.getToken();
      print('🔥 Token FCM: $token');
      if (token != null) {
        await _saveTokenToDatabase(token);
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Notifikasi diterima: ${message.notification?.title}");
        LocalNotificationService.showNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("🔗 Notifikasi diklik: ${message.notification?.title}");
      });
    } else {
      print('❌ Izin notifikasi ditolak');
    }
  }

  static Future<void> _saveTokenToDatabase(String token) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child('user_tokens').push().set({"token": token});
    print('✅ Token berhasil disimpan ke Firebase');
  }
}
