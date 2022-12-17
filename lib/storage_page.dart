// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  late File file;
  ImagePicker imagePicker = ImagePicker();
  uploadImage() async {
    XFile? imagePicked =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (imagePicked != null) {
      file = File(imagePicked.path);
      String nameImage = basename(imagePicked.path);
      int random = Random().nextInt(1000000);
      // start upload
      // Reference refStorage = FirebaseStorage.instance.ref('images/$nameImage');
      //or second method
      nameImage = '$random$nameImage';
      Reference refStorage =
          FirebaseStorage.instance.ref('images').child(nameImage);

      await refStorage.putFile(file);
      String urlImage = await refStorage.getDownloadURL();
      // final upload
      print('=================');
      print('URL: $urlImage');
    } else {
      print('please choose image');
    }
  }

  getImagesAndFoldersName() async {
    var refImage = await FirebaseStorage.instance
        .ref()
        .list(const ListOptions(maxResults: 10));
    print('========== Images===========');
    for (var element in refImage.items) {
      print('===========');
      print(element.name);
      print(element.fullPath);
    }
    print('========== Folders===========');
    for (var element in refImage.prefixes) {
      print(element.fullPath);
    }
  }

  @override
  void initState() {
    getImagesAndFoldersName();
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
          title: const Text('Storage Page'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  uploadImage();
                },
                child: const Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getImagesAndFoldersName();
                },
                child: const Text(
                  'Get Image',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
