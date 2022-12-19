// ignore_for_file: avoid_print

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_firebase_project/auth_email.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var fbm = FirebaseMessaging.instance;
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('========onMessageOpenedApp Notification');
      print(message.notification!.body);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        ),
      );
    });

    fbm.getToken().then(
      (token) {
        print('========Token===========');
        print(token);
        print('=========================');
        FirebaseMessaging.onMessage.listen(
          (event) {
            if (event.notification != null) {
              FirebaseAuth.instance.signOut();
              // we can navigate to anothor page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthEmailPage(),
                ),
              );
              Flushbar(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                title: '${event.notification!.title}',
                messageText: Text(
                  '${event.notification!.body}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                backgroundGradient: const LinearGradient(
                  colors: [
                    Colors.deepOrange,
                    Colors.orange,
                  ],
                ),
                borderColor: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                borderWidth: 4,
                duration: const Duration(seconds: 6),
                boxShadows: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(6, 8),
                  ),
                ],
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                forwardAnimationCurve: Curves.linear,
                icon: const Icon(Icons.done_outline, color: Colors.white),
                leftBarIndicatorColor: Colors.red,
                mainButton: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.undo, color: Colors.grey.shade600),
                  label: Text(
                    'Undo',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ).show(context);
            }
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(),
      ),
    );
  }
}
