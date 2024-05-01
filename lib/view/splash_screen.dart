import 'dart:async';
import 'package:chat/view/homepage.dart';
import 'package:chat/view/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var cu = FirebaseAuth.instance.currentUser;
    Timer(
      Duration(seconds: 3),
      () {
        cu != null ? Get.off(HomePage()) : Get.off(LoginPage());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          width: MediaQuery.sizeOf(context).width * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/chat_appicon.png"),
            ),
          ),
        ),
      ),
    );
  }
}
