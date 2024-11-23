import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_password_manager/models/chat_user.dart';
import 'package:flutter_password_manager/screen/splash_screen.dart';
import 'package:flutter_password_manager/widget/chat_user_card.dart';

import '../api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
        title: const Text(
          "Chat App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 11.0, right: 11.0),
        child: FloatingActionButton(
          onPressed: () {
            APIs.auth.signOut();
          },
          backgroundColor: Colors.green,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
              }

              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: mq.height * .02),
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                      user: list[index],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    "Welcome to Chat App!",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
