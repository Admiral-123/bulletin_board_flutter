import 'dart:async';

import 'package:bulletin_board/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bulletin',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class SplashScr extends StatefulWidget {
  const SplashScr({super.key});

  @override
  State<SplashScr> createState() => SplashScrState();
}

class SplashScrState extends State<SplashScr> {
  static const String keyLogin = "Login";

  @override
  void initState() {
    super.initState();

    whereToGo();
  }

  void whereToGo() async {
    var pref = await SharedPreferences.getInstance();
    bool? isLoggedIn = await pref.getBool(keyLogin);

    Timer(Duration(seconds: 2), () {
      if (isLoggedIn!) {
        if (isLoggedIn == true) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: 60,
            height: 60,
            child: Image.asset(
              "assets/bulletinapp.png",
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
