
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/pages/login.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/firebase_options.dart';
import 'package:vibration_sensor/provider/prvdr_cuaca.dart';
import 'package:vibration_sensor/servis/notif.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp;
  await FirebaseMessagingService.initialize();(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 






  runApp(const Bumi());
}




class Bumi extends StatelessWidget {
  const Bumi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Provider Autentikasi
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
