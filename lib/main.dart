import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration_sensor/firebase_options.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/pages/kelap-kelip.dart';
import 'package:vibration_sensor/pages/login.dart';
import 'package:vibration_sensor/provider/messaging.dart';
import 'package:vibration_sensor/provider/prvdr_cuaca.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/servis/notif.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  handleNotificationNavigation(message);
}

// Fungsi untuk menangani navigasi berdasarkan data notifikasi
void handleNotificationNavigation(RemoteMessage message) {
  if (message.data.containsKey('screen')) {
    String screen = message.data['screen'] ?? 'HomeScreen';

    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) =>
          screen == "DangerScreen" ? DangerScreen() : HomePage(),
    ));
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
    setupFCM();
  }

  void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Minta izin notifikasi (khusus iOS)
    await messaging.requestPermission();

    // Konfigurasi FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService.showNotification(message);
      }
      handleNotificationNavigation(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationNavigation(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleNotificationNavigation(message);
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
            navigatorKey: navigatorKey, // Tambahkan navigatorKey
            debugShowCheckedModeBanner: false,
            initialRoute: authProvider.user != null ? '/home' : '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomePage(),
              '/danger': (context) => DangerScreen(), // Tambahkan ini
            },
          );
        },
      ),
    );
  }
}
