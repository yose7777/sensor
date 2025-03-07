import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration_sensor/firebase_options.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/pages/login.dart';
import 'package:vibration_sensor/provider/messaging.dart';
import 'package:vibration_sensor/provider/prvdr_cuaca.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/servis/notif.dart';
import 'package:provider/provider.dart';

import 'pages/kelap-kelip.dart';
import 'servis/dngr.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  LocalNotificationService.initialize(navigatorKey);
  FirebaseMessagingService.setupFCM();
  NotifikasiService.init();

  // Periksa apakah ada notifikasi saat aplikasi terminated
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null && message.data['screen'] == "DangerScreen") {
      navigatorKey.currentState?.pushNamed('/danger');
    }
  });

  runApp(const MyApp());
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
    FirebaseMessagingService.setupFCM();
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
