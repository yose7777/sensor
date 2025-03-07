import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification_service.dart';

// Handler untuk menangani notifikasi saat aplikasi berjalan di background atau terminated
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Message: ${message.notification?.title}");
  NotificationService.showNotification(message);
}

class BackgroundService {
  static void initialize() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
