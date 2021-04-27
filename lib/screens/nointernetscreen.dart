import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';

class NoInternetScreen extends StatelessWidget {
  final bool isconnected;
  NoInternetScreen({this.isconnected});
  static final screenname = "NoInternetScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/nointernet.gif'),
            Text(
              "$isconnected No Internet Connection",
              style: ktxt_headingstyle.copyWith(
                color: Colors.black38,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please Check your Internet Connection And Try Connection",
              style: ktxt_headingstyle.copyWith(
                color: Colors.black38,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
