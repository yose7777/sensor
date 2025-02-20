// import 'package:firebase_messaging/firebase_messaging.dart';

// class FCMService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     // Minta izin dari pengguna
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('✅ Notifikasi diizinkan');
//     } else {
//       print('❌ Notifikasi ditolak');
//     }

//     // Ambil Token FCM
//     String? token = await _firebaseMessaging.getToken();
//     print("🎯 Token FCM: $token");
//   }
// }
