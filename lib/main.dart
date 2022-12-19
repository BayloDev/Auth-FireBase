// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'auth_methods_page.dart';
import 'cloud_messaging_notification.dart';
import 'firebase_options.dart';

bool? isSinUp;
Future<void> backgroundMessag(RemoteMessage message) async {
  print('========Background Notification');
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundMessag);
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isSinUp = false;
  } else {
    isSinUp = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: isSinUp == false
            ? const AuthMethodsPage()
            : const NotificationPage(),
      ),
    );
  }
}
