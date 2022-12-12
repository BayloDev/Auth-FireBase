import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_project/home_page.dart';
import 'package:flutter/material.dart';

import 'auth_email.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  bool isVerified = false;
  Timer? timerEmail;
  bool isResent = false;

  GlobalKey<ScaffoldMessengerState> scaffoldKeyEmailVer =
      GlobalKey<ScaffoldMessengerState>();

  SnackBar snackBarEmailVer(String snackBarContent) {
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

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timerEmail = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(
      () => isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified,
    );

    if (isEmailVerified) {
      scaffoldKeyEmailVer.currentState!.showSnackBar(
        snackBarEmailVer('Your account has been created successfully'),
      );

      Future.delayed(
        const Duration(seconds: 5),
        () {
          setState(() {
            isVerified = isEmailVerified;
          });
        },
      );
      timerEmail?.cancel();
    }
  }

  @override
  void dispose() {
    timerEmail?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => isResent = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => isResent = true);
    } catch (e) {
      scaffoldKeyEmailVer.currentState!
          .showSnackBar(snackBarEmailVer(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? const HomePage()
        : MaterialApp(
            scaffoldMessengerKey: scaffoldKeyEmailVer,
            theme: ThemeData(
              primarySwatch: Colors.orange,
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Verify Email'),
                backgroundColor: Colors.orange,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A verification email has been sent to your email',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: isResent ? sendVerificationEmail : null,
                      icon: const Icon(
                        Icons.email,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Resent Email',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          isResent ? Colors.deepOrange : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const AuthEmailPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.cancel_presentation_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
  }
}
