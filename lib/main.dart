import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration_sensor/firebase_options.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/pages/login.dart';
import 'package:vibration_sensor/provider/messaging.dart';
import 'package:vibration_sensor/provider/prvdr_cuaca.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/servis/notif.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
   // Inisialisasi notifikasi lokal
  LocalNotificationService.initialize();

  // Inisialisasi FCM
  FirebaseMessagingService.setupFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            debugShowCheckedModeBanner: false,
            initialRoute: authProvider.user != null ? '/home' : '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomePage(),
            },
          );
        },
      ),
    );
  }
}
