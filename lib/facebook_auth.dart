// ignore_for_file: nullable_type_in_catch_clause

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_project/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'auth_methods_page.dart';

class AuthWithFacebook extends StatefulWidget {
  const AuthWithFacebook({super.key});

  @override
  State<AuthWithFacebook> createState() => _AuthWithFacebookState();
}

class _AuthWithFacebookState extends State<AuthWithFacebook> {
  Future<UserCredential> signInWithFacebookPhone() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithFacebookWeb() async {
    // Create a new provider
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
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
  final GlobalKey<ScaffoldMessengerState> scaffoldKeyFacebook =
      GlobalKey<ScaffoldMessengerState>();
  bool showSnack = false;

  bool isFacebookVerified = false;
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  var error = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKeyFacebook,
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
          title: const Text('Facebook Account'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: (((defaultTargetPlatform ==
                            TargetPlatform.android) ||
                        (defaultTargetPlatform == TargetPlatform.iOS))
                    ? () async {
                        var snackBarFacebookContent = 'Sign In Successfully';

                        try {
                          UserCredential userCredentialFacebookPhone =
                              await signInWithFacebookPhone();
                          isFacebookVerified =
                              userCredentialFacebookPhone.user!.emailVerified;
                        } catch (e) {
                          snackBarFacebookContent = e.toString();
                        }
                        scaffoldKeyFacebook.currentState!.showSnackBar(
                          mySnackBarFunction(snackBarFacebookContent),
                        );
                        isFacebookVerified
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
                            var snackBarFacebookContent =
                                'Sign In Successfully';
                            try {
                              UserCredential userCredentialFacebookWeb =
                                  await signInWithFacebookWeb();
                              isFacebookVerified =
                                  userCredentialFacebookWeb.user!.emailVerified;
                            } catch (e) {
                              snackBarFacebookContent = e.toString();
                            }
                            scaffoldKeyFacebook.currentState!.showSnackBar(
                              mySnackBarFunction(snackBarFacebookContent),
                            );

                            setState(() {
                              error = snackBarFacebookContent;
                            });
                            isFacebookVerified
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
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : null;
                          }
                        : () {
                            scaffoldKeyFacebook.currentState!.showSnackBar(
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
              SelectableText(error)
            ],
          ),
        ),
      ),
    );
  }
}
