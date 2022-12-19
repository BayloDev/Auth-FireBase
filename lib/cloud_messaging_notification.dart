// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:html';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_firebase_project/auth_email.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseMessaging fbm = FirebaseMessaging.instance;
// it used when the app is termited
  getInitialMessageTerminateNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print('========getInitialMessage Notification');
      print(message.notification!.body);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NotificationPage()));
    }
  }

//when we click on the background notification
  void onMessageOpenAppNotification(message) {
    print('========onMessageOpenedApp Notification');
    print(message.notification!.body);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

//get the token
  FutureOr<void> getTokenFunction(token) {
    print('========Token===========');
    print(token);
  }

  //it used when the app is opend
  void onMessageNotification(message) {
    if (message.notification != null) {
      // we can navigate to anothor page

      print('============Notification onMessage=============');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AuthEmailPage(),
        ),
      );
      Flushbar(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(4),
        title: '${message.notification!.title}',
        messageText: Text(
          '${message.notification!.body}',
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
  }

  // permissions for ios
  requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    requestPermissions();
    getInitialMessageTerminateNotification();
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenAppNotification);

    fbm.getToken().then(getTokenFunction);
    FirebaseMessaging.onMessage.listen(onMessageNotification);
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
