import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Handler pesan yang diterima saat aplikasi di background/terminated
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    _showNotification(message.notification);
  }

  /// Inisialisasi Firebase Messaging dan local notifications
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Menangani pesan saat aplikasi di background/terminated
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Konfigurasi notifikasi lokal untuk Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print("Notifikasi diklik!");
      },
    );

    // Foreground notification handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message.notification);
      }
    });

    // Notifikasi yang diklik dari background atau terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notifikasi dibuka dari background/terminated!");
    });

    // Ambil token FCM untuk testing
    String? token = await _messaging.getToken();
    print("FCM Token: $token");
  }

  /// Fungsi untuk menampilkan notifikasi dengan flutter_local_notifications
  static Future<void> _showNotification(RemoteNotification? notification) async {
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // ID channel harus sama dengan di AndroidManifest.xml
      'High Importance Notifications',
      channelDescription: 'Digunakan untuk notifikasi penting',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true, // Memastikan notifikasi muncul sebagai pop-up
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }
}
