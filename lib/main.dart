// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'notification_service.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? _fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       NotificationService.showNotification(message);
//     });
//     _getToken();
//   }

//   Future<void> _getToken() async {
//     String? token = await NotificationService.getToken();
//     setState(() {
//       _fcmToken = token;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("FCM Notification Example")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Listening for notifications..."),
//             SizedBox(height: 20),
//             Text("FCM Token:", style: TextStyle(fontWeight: FontWeight.bold)),
//             SelectableText(_fcmToken ?? "Fetching token..."),
//           ],
//         ),
//       ),
//     );
//   }
// }
