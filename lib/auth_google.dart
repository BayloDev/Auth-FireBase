import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_project/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_methods_page.dart';

class AuthWithGoogle extends StatefulWidget {
  const AuthWithGoogle({super.key});

  @override
  State<AuthWithGoogle> createState() => _AuthWithGoogleState();
}

class _AuthWithGoogleState extends State<AuthWithGoogle> {
  Future<UserCredential> signInWithGooglePhone() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogleWeb() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

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
  final GlobalKey<ScaffoldMessengerState> scaffoldKeyGoogle =
      GlobalKey<ScaffoldMessengerState>();
  bool showSnack = false;

  bool isEmailVerified = false;
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKeyGoogle,
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
          title: const Text('Google Account'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (((defaultTargetPlatform == TargetPlatform.android) ||
                    (defaultTargetPlatform == TargetPlatform.iOS))
                ? () async {
                    var snackBarGoogleContent = 'Signed Successfuly';

                    try {
                      UserCredential userCredentialGooglePhone =
                          await signInWithGooglePhone();
                      isEmailVerified =
                          userCredentialGooglePhone.user!.emailVerified;
                    } catch (e) {
                      snackBarGoogleContent = e.toString();
                    }
                    scaffoldKeyGoogle.currentState!.showSnackBar(
                      mySnackBarFunction(snackBarGoogleContent),
                    );
                    isEmailVerified
                        ? Timer.periodic(
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
                          )
                        : null;
                  }
                : ((defaultTargetPlatform == TargetPlatform.linux) ||
                        (defaultTargetPlatform == TargetPlatform.windows))
                    ? () async {
                        var snackBarGoogleContent = 'Signed Successfuly';
                        try {
                          UserCredential userCredentialGoogleWeb =
                              await signInWithGoogleWeb();
                          isEmailVerified =
                              userCredentialGoogleWeb.user!.emailVerified;
                        } catch (e) {
                          snackBarGoogleContent = e.toString();
                        }
                        scaffoldKeyGoogle.currentState!.showSnackBar(
                          mySnackBarFunction(snackBarGoogleContent),
                        );
                        isEmailVerified
                            ? Timer.periodic(
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
                              )
                            : null;
                      }
                    : () {
                        scaffoldKeyGoogle.currentState!.showSnackBar(
                            mySnackBarFunction(
                                'Sorry, Your Device Doesn\'t Support this App  '));
                      }),
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
