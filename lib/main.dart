import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration_sensor/firebase_options.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/pages/kelap-kelip.dart';
import 'package:vibration_sensor/pages/login.dart';
import 'package:vibration_sensor/provider/messaging.dart';
import 'package:vibration_sensor/provider/prvdr_cuaca.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/servis/notif.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi notifikasi lokal
  LocalNotificationService.initialize(navigatorKey);

  // Inisialisasi Firebase Cloud Messaging (FCM)
  FirebaseMessagingService.setupFCM();

  // Setup handler untuk notifikasi di background & terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

// Handler untuk notifikasi di background & terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _handleNotificationNavigation(message);
}

// Fungsi untuk menangani navigasi berdasarkan data notifikasi dari Node.js
void _handleNotificationNavigation(RemoteMessage message) {
  if (message.data.containsKey('screen')) {
    String screen = message.data['screen'] ?? 'HomeScreen';

    if (navigatorKey.currentState != null) {
      String? currentRoute = ModalRoute.of(navigatorKey.currentContext!)?.settings.name;

      if (screen == "DangerScreen" && currentRoute != '/danger') {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/danger', (route) => false);
      } else if (screen == "HomeScreen" && currentRoute != '/home') {
        navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  void _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Minta izin notifikasi (khusus iOS)
    await messaging.requestPermission();

    // Konfigurasi FCM untuk menangani berbagai kondisi notifikasi
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService.showNotification(message);
      }
      _handleNotificationNavigation(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message);
    });

    // Tangani notifikasi saat aplikasi dibuka dari kondisi terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Future.delayed(Duration.zero, () => _handleNotificationNavigation(message));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: authProvider.user != null ? '/home' : '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomePage(),
              '/danger': (context) => DangerScreen(),
            },
          );
        },
      ),
    );
  }
}
