// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseStore extends StatefulWidget {
  const FireBaseStore({super.key});

  @override
  State<FireBaseStore> createState() => _FireBaseStoreState();
}

class _FireBaseStoreState extends State<FireBaseStore> {
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

  getAge() {
    FirebaseFirestore.instance
        .collection('users')
        .where('age', isEqualTo: 27)
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data()['username']);
      }
    });
  }

  getLang() {
    FirebaseFirestore.instance
        .collection('users')
        .where('lang', arrayContainsAny: ['ar', 'en'])
        .get()
        .then((value) {
          for (var element in value.docs) {
            print(element.data()['username']);
            print('==========');
          }
        });
  }

  getUsernameAge() {
    FirebaseFirestore.instance
        .collection('users')
        .where('age', isGreaterThan: 25)
        .where('lang', arrayContainsAny: ['fr', 'en'])
        .get()
        .then(
          (value) {
            for (var element in value.docs) {
              print(element.data()['username']);
              print(element.data()['age']);
              print('==========');
            }
          },
        );
  }

  getDataOrderByStartAt() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .startAt([27])
        .get()
        .then(
          (value) {
            for (var element in value.docs) {
              print(element.data()['username']);
              print('==========');
            }
          },
        );
  }

  getDataOrderByEndBefore() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .startAfter([26])
        .get()
        .then(
          (value) {
            for (var element in value.docs) {
              print(element.data()['username']);
              print('==========');
            }
          },
        );
  }

  getDataOrderByStartAfter() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .startAfter([27])
        .get()
        .then(
          (value) {
            for (var element in value.docs) {
              print(element.data()['username']);
              print('==========');
            }
          },
        );
  }

  getDataOrderBy() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('username', descending: true)
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          print(element.data()['username']);
          print('==========');
        }
      },
    );
  }

  getDataOrderByLimitToLast() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('age')
        .limitToLast(2)
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          print(element.data()['username']);
          print(element.data()['age']);
          print('==========');
        }
      },
    );
  }

  getDataLimit() {
    FirebaseFirestore.instance.collection('users').limit(2).get().then(
      (value) {
        for (var element in value.docs) {
          print(element.data()['username']);
          print('==========');
        }
      },
    );
  }

  getDataOrderByEndAt() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('age', descending: false)
        .endAt([27])
        .get()
        .then(
          (value) {
            for (var element in value.docs) {
              print(element.data()['username']);
              print('==========');
            }
          },
        );
  }

  //Real Time Firebase
  getDataRealTime() {
    FirebaseFirestore.instance.collection('users').snapshots().listen(
      (event) {
        for (var element in event.docs) {
          print('username :${element.data()['username']}');
          print('email :${element.data()['email']}');
          print('age :${element.data()['age']}');
          print('==========');
        }
      },
    );
  }

// add data
// add with autoId
  addUser() {
    FirebaseFirestore.instance.collection('users').add(
      {
        'username': 'nouh',
        'age': 11,
        'email': 'nouh@email.com',
        'phone': 418927
      },
    );
  }

  // add with specific id
  setUser() {
    FirebaseFirestore.instance.collection('users').doc('12346667').set(
      {
        'username': 'nouh',
        'age': 11,
        'email': 'nouh@email.com',
        'phone': 418927
      },
    );
  }

  // update user
  updateUser() {
    FirebaseFirestore.instance.collection('users').doc('12346667').update(
      {
        'username': 'abdelbasset',
        'age': 12,
        'email': 'abdelbasset@email.com',
        'phone': 41832427
      },
    );
  }

  // update user with set => recreate the user
  updateUserwithSet() {
    FirebaseFirestore.instance.collection('users').doc('12346667').set(
      {
        'username': 'younes',
        'age': 22,
        'email': 'younes@email.com',
        'phone': 41832427
      },
    );
  }
  // update user with set =>don't recreate the user, just update, and if the user doesnt exit it create it, update -> give us error

  updateUserwithSetOptions() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('12346667')
        .set({'age': 25}, SetOptions(merge: true));
  }

// catch error, then
  updateWithCatchError() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('123466435667')
        .update({'age': 40})
        .then((value) => print('Update success'))
        .catchError(
          (error) {
            print('error: ======== $error');
          },
        );
  }

  deleteUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('1234664433567667')
        .delete()
        .then((value) => print('Delete success'))
        .catchError(
      (error) {
        print('error: ======== $error');
      },
    );
  }

  // nested collection
  nestedCollectionAddress() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('DCfMbMxgkFK4xqR4wnjb')
        .collection('address')
        .add(
          {
            'contry': 'alg',
            'wilaya': 'ain defla',
            'city': 'teberkanine',
          },
        )
        .then((value) =>
            print('Collection address and document added successfuly'))
        .catchError(
          (error) {
            print('error: ======== $error');
          },
        );
  }

  // transaction : used to verify if the data has been change successfuly for all doctument , expemle when you change your name on fb
  DocumentReference docUserTrans = FirebaseFirestore.instance
      .collection('users')
      .doc('DCfMbMxgkFK4xqR4wnjb');

  transaction() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docSnap = await transaction.get(docUserTrans);
      if (docSnap.exists) {
        transaction.update(docUserTrans, {'phone': 32969823});
        print('update success');
      } else {
        print('user doesn\'t exist');
      }
    });
  }

  // batch write : lets us to execute multiple write operations as a single batch any combination of set , update, or delete operations, all excute succseccfully or all failed
  DocumentReference docUserBatch1 = FirebaseFirestore.instance
      .collection('users')
      .doc('tQModEEMuAbaO02XpUe5');
  DocumentReference docUserBatch2 =
      FirebaseFirestore.instance.collection('users').doc('12346667');

  batchWrite() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.delete(docUserBatch2);
    batch.update(docUserBatch1, {'username': 'sofiane'});
    batch.commit();
    print('batch succsess');
  }

  // get users
  List users = [];
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  getData() async {
    QuerySnapshot querySnapshot = await usersRef.get();
    for (var element in querySnapshot.docs) {
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() => users.add(element.data())),
      );
    }
  }

  @override
  void initState() {
    getData();
    //batchWrite();
    //transaction();
    //nestedCollectionAddress();
    //deleteUser();
    //updateWithCatchError();
    //updateUserwithSet();
    //updateUser();
    //setUser();
    //addUser();
    //getDataRealTime();
    //getDataOrderByEndBefore();
    //getDataOrderByStartAfter();
    //getDataOrderByEndAt();
    //getDataOrderByStartAt();
    //getDataOrderByLimitToLast();
    //getDataLimit();
    //getDataOrderBy();
    //getUsernameAge();
    //getLang();
    //getAge();
    //getDocument('iE9N97AuidQH3PGogHZW');
    //getDocument('jC4Ki8eUXvS8Rshxy9r9');
    //getAllUsers();
    super.initState();
  }

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

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
        //first method to display data in UI with list
        // body: Center(
        //   child: (users.isEmpty)
        //       ? Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             CircularProgressIndicator(),
        //             SizedBox(height: 20),
        //             Text(
        //               'Please Wait',
        //               style: TextStyle(
        //                 color: Colors.black54,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             )
        //           ],
        //         )
        //       : ListView.builder(
        //           itemCount: users.length,
        //           itemBuilder: (context, index) => ListTile(
        //             title: Text('username: ${users[index]['username']}'),
        //             subtitle: Text('phone: ${users[index]['phone']}'),
        //           ),
        //         ),
        // ),

        //second method to display data in UI with FutureBuilder we dont need to initState !!
        // body: Center(
        //   child: FutureBuilder(
        //       future: usersRef.get(),
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return ListView.builder(
        //             itemCount: snapshot.data!.docs.length,
        //             itemBuilder: (context, index) => ListTile(
        //               title: Text(
        //                 'username: ${snapshot.data!.docs[index]['username']}',
        //               ),
        //               subtitle: Text(
        //                 'phone: ${snapshot.data!.docs[index]['email']}',
        //               ),
        //             ),
        //           );
        //         }
        //         if (snapshot.hasError) {
        //           print('Error');
        //         }
        //         return Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const [
        //             CircularProgressIndicator(),
        //             SizedBox(height: 20),
        //             Text(
        //               'Please Wait',
        //               style: TextStyle(
        //                 color: Colors.black54,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             )
        //           ],
        //         );
        //       }),
        // ),

        //third method to display data in UI with streamBuilder for real time

        body: Center(
          child: StreamBuilder(
            stream: notes.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      'title: ${snapshot.data!.docs[index]['title']}',
                    ),
                    subtitle: Text(
                      'title: ${snapshot.data!.docs[index]['body']}',
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {}
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Please Wait',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
