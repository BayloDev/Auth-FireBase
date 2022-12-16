// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getDocument(String docID) {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(docID)
        .get()
        .then((value) {
      print(value.data());
      print("==================");
    });
  }

  getAllUsers() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        print(element.data());
        print("==================");
      }
      return null;
    });
  }

  @override
  void initState() {
    print('bilal\'s note');
    getDocument('iE9N97AuidQH3PGogHZW');
    print('mohamed\'s note');

    getDocument('jC4Ki8eUXvS8Rshxy9r9');
    print('All Users');

    getAllUsers();
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
          title: const Text('Welcome'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(
          child: Text(
            'Welcome To Our App',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
