import 'dart:ui';
import 'package:chuglimessenger/Components/Reusable_Button.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);
  static final screenname = '/';
  @override
  Widget build(BuildContext context) {
    print(GlobalContants.uid);
    return Scaffold(
      backgroundColor: k_app_backgroundcolor,
      body: SafeArea(
          child: Container(
        // color: Colors.yellow,
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(k_ChugliChat,style:ktxt_headingstyle),
              Text(
                ksub_heading_1,
                textAlign:TextAlign.center,
                style: ktxt_headingstyle.copyWith(fontSize: 26,),
              ),
              Image.asset(
                'images/mainLogo.png',
                height: 350,
                width: 350,
                // fit: BoxFit.fill,
              ),
              Text(kwelcomelabel,style:ktxt_headingstyle),
              // SizedBox(
              //   height: 50,
              // ),

              Reusable_Button(
                title: kbtn_lbl_getstarted,
                onpress: () {
                  //go to Login Screen or Register Screen
                  print('go to login screen');
                  Navigator.pushReplacementNamed(context, LoginScreen.screenname);
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
