// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_methods_page.dart';
import 'verify_email.dart';

class AuthEmailPage extends StatefulWidget {
  const AuthEmailPage({Key? key}) : super(key: key);

  @override
  State<AuthEmailPage> createState() => _AuthEmailPageState();
}

enum AuthMode { signIn, signUp }

class _AuthEmailPageState extends State<AuthEmailPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  Map<String, String> userData = {
    'email': '',
    'password': '',
  };
  AuthMode authMode = AuthMode.signIn;

  final passwordController = TextEditingController();

  UserCredential? credential;
  bool isExist = false;

  GlobalKey<NavigatorState>? navigatorkey;

  void changeAuthMode() {
    if (authMode == AuthMode.signIn) {
      setState(() {
        authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        authMode = AuthMode.signIn;
      });
    }
  }

  GlobalKey<ScaffoldMessengerState> scaffoldKeyEmail =
      GlobalKey<ScaffoldMessengerState>();
  UserCredential? userCredential;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      scaffoldMessengerKey: scaffoldKeyEmail,
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
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AuthMethodsPage(),
              ));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text('Email Auth'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      authMode == AuthMode.signUp
                          ? 'SIGN UP TO OUR COMMUNITY'
                          : 'SIGN IN TO YOUR ACCOUNT',
                      style: const TextStyle(
                        fontSize: 25,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: 1,
                      maxLength: 40,
                      autovalidateMode: AutovalidateMode.always,
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 4,
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                        suffixText: '@gmail.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || value.contains('@gmail.com')) {
                          return 'Invalid Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        userData['email'] = '$newValue@gmail.com';
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 4,
                        ),
                        prefixIcon: const Icon(Icons.password),
                        helperText: authMode == AuthMode.signUp
                            ? 'Password must be at least 8 characters long'
                            : null,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return 'Invalid Password';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        userData['password'] = newValue!;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (authMode == AuthMode.signUp)
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            gapPadding: 4,
                          ),
                          prefixIcon: const Icon(Icons.password),
                        ),
                        validator: (value) {
                          if (value == passwordController.text) {
                            return null;
                          } else {
                            return 'Password don\'t match ';
                          }
                        },
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        String snackBarContent = '';
                        bool isValid = formKey.currentState!.validate();
                        if (isValid) {
                          formKey.currentState!.save();
                          if (authMode == AuthMode.signUp) {
                            try {
                              credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: userData['email']!,
                                password: userData['password']!,
                              );
                              Future.delayed(
                                const Duration(seconds: 3),
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationPage(),
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() => snackBarContent = e.code);
                            } catch (e) {
                              setState(() => snackBarContent = e.toString());
                            }
                          } else {
                            try {
                              credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: userData['email']!,
                                password: userData['password']!,
                              );
                              Future.delayed(
                                const Duration(seconds: 3),
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationPage(),
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() => snackBarContent = e.toString());
                            } catch (e) {
                              setState(() => snackBarContent = e.toString());
                            }
                          }

                          snackBarContent.length > 1
                              ? scaffoldKeyEmail.currentState!.showSnackBar(
                                  mySnackBarFunction(snackBarContent))
                              : showDialog(
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
                          return;
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                      ),
                      child: Text(
                        authMode == AuthMode.signIn ? 'Sign In' : 'Sign Up',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: changeAuthMode,
                          child: Text(
                            authMode == AuthMode.signIn ? 'Sign Up' : 'Sign In',
                            style: const TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Text(
                          'Instead',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
}
