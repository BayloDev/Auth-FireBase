// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFireStoreTest extends StatefulWidget {
  const GetFireStoreTest({super.key});

  @override
  State<GetFireStoreTest> createState() => _GetFireStoreTestState();
}

class _GetFireStoreTestState extends State<GetFireStoreTest> {
  late QuerySnapshot<Map<String, dynamic>> users;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> usersDocs;
  getData() async {
    users = await FirebaseFirestore.instance.collection('users').get();
    usersDocs = users.docs;

    for (var element in usersDocs) {
      print(element.data());
      print("==================");
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushReplacement(MaterialPageRoute(
          //       builder: (context) => const AuthMethodsPage(),
          //     ));
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back_ios,
          //     color: Colors.white,
          //   ),
          // ),
          title: const Text('Email Auth'),
          backgroundColor: Colors.orange,
        ),
        body: Container());
  }
}
