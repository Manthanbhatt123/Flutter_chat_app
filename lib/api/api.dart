import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_user.dart';

class APIs {
  //For User authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  static User get myUser => auth.currentUser!;

  static late ChatUser me;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for checking user existence
  static Future<bool> userExist() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> selfInfo() async {
    await firestore
        .collection('users')
        .doc(myUser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log("MyData from FireStore \n ${user.data()}");
      } else {
        createUser("user");
      }
    });
  }

  //for creating user
  static Future<void> createUser(String name) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: myUser.photoURL ?? '',
        name: myUser.displayName ?? name,
        about: "Hello Developer",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: myUser.uid,
        pushToken: '',
        email: myUser.email.toString());

    // log(myUser.toString());
    return await firestore
        .collection('users')
        .doc(myUser.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: myUser.uid)
        .snapshots();
  }

  //for checking user existence
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'name': me.name,
        'about':me.about
      },
    );
  }
}
