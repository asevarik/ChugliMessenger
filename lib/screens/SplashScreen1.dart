import 'package:chuglimessenger/services/auth.dart';
import 'package:flutter/material.dart';

class SplashScreen1 extends StatelessWidget {
  static final screenname = '/Splashscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('text')),
      body: Center(
        child: FlatButton(
          child: Text('signout'),
          onPressed: () async {
            Auth _auth = Auth();
            await _auth.Signout();
          },
        ),
      ),
    );
  }
}
