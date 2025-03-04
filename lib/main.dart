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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  LocalNotificationService.initialize(navigatorKey);

  FirebaseMessagingService.setupFCM();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📢 Notifikasi diterima di background: ${message.notification?.title}");
  LocalNotificationService.showNotification(message);
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

    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Notifikasi di foreground: ${message.notification?.title}");
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

  void handleNotificationNavigation(RemoteMessage message) {
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'] ?? 'HomeScreen';

      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) =>
            screen == "DangerScreen" ? DangerScreen() : HomePage(),
      ));
    }
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
