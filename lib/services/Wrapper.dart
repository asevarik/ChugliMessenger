import 'dart:io';

import 'package:chuglimessenger/screens/Splashscreen2.dart';
import 'package:chuglimessenger/screens/Welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  static final screenname = '/Wrapper';
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

 @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    //return either ChatScreen or Login/Signup
    if (user == null) {
      return WelcomeScreen();
    } else {
      return SplashScreen2();
    }
  }
}
