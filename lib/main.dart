import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_firebase_project/home_page.dart';
import 'package:flutter/material.dart';

import 'auth_methods_page.dart';
import 'firebase_options.dart';

bool? isSinUp;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        body: isSinUp == false ? const AuthMethodsPage() : const HomePage(),
      ),
    );
  }
}
