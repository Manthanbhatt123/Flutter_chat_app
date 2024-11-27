import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_password_manager/api/api.dart';
import 'package:flutter_password_manager/screen/home_screen.dart';
import 'login_screen.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
   await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,

    );
    runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.green,
          selectionColor: Colors.green,
          selectionHandleColor: Colors.green
        ),
        appBarTheme:  const AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 5,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
            bottomRight: Radius.circular(7)
          ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white)
        ),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white70,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: Colors.green, // Border color when the field is focused
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: Colors.grey, // Border color when the field is not focused
              width: 1.0,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const SplashScreen(title: 'Chat App'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if(APIs.auth.currentUser!=null){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/chat_logo.jpg",
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Chat App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
