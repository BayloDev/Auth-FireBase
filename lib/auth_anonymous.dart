import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_methods_page.dart';
import 'home_page.dart';

class AuthAnonymous extends StatefulWidget {
  const AuthAnonymous({super.key});

  @override
  State<AuthAnonymous> createState() => _AuthAnonymousState();
}

class _AuthAnonymousState extends State<AuthAnonymous> {
  GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  SnackBar mySnackBarFunction(String snackBarContent) {
    return SnackBar(
      content: Text(
        snackBarContent,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      elevation: 5,
      backgroundColor: Colors.deepOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      duration: const Duration(seconds: 6),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
    );
  }

  Timer? timer;
  bool showSnack = false;

  bool isEmailVerified = false;
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  UserCredential? userCredentialEmail;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AuthMethodsPage(),
              ),
            ),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text('Anonymous'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              String snackBarContent = 'Signed Successfuly';
              try {
                userCredentialEmail =
                    await FirebaseAuth.instance.signInAnonymously();
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "operation-not-allowed":
                    setState(() => snackBarContent =
                        "Anonymous auth hasn't been enabled for this project.");
                    break;
                  default:
                    setState(() => snackBarContent = "Unknown error.");
                }
              } catch (e) {
                setState(() => snackBarContent = "Unknown error");
              }
              scaffoldKey.currentState
                  ?.showSnackBar(mySnackBarFunction(snackBarContent));
              Timer.periodic(
                const Duration(seconds: 2),
                (timer) async {
                  setState(() {
                    showSnack = !showSnack;
                  });
                  if (showSnack) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrange,
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    );
                  } else {
                    timer.cancel();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
