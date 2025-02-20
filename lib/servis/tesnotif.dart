import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi
  Future<void> initialize() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload == 'whatsapp_call') {
          await _openWhatsApp();
        }
      },
    );
  }

  // Menampilkan notifikasi dengan aksi "Call WhatsApp"
  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'whatsapp_channel', // ID Channel
      'WhatsApp Notifications',
      channelDescription: 'Channel untuk notifikasi WhatsApp',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Panggilan WhatsApp',
      'Tekan untuk menelepon lewat WhatsApp!',
      platformChannelSpecifics,
      payload: 'whatsapp_call', // Payload digunakan untuk menangani klik
    );
  }

  // Membuka WhatsApp dengan nomor tertentu
  Future<void> _openWhatsApp() async {
    const phoneNumber = '+1234567890'; // Ganti dengan nomor WhatsApp yang valid
    final url = 'https://wa.me/$phoneNumber';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }
}
