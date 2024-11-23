import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_user.dart';

class APIs {
  //For User authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

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

  //for creating user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: auth.currentUser!.photoURL ?? '',
        name: auth.currentUser!.displayName?? "",
        about: "Hello Developer",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: auth.currentUser!.uid,
        pushToken: '',
        email: auth.currentUser!.email.toString());
    
    // log(auth.currentUser!.toString());
    return await firestore
            .collection('users')
            .doc(auth.currentUser!.uid).set(chatUser.toJson());
  }
}
