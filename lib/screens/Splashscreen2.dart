import 'package:chuglimessenger/screens/HomeScreen.dart';
import 'package:chuglimessenger/services/auth.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:flip_panel/flip_panel.dart';
import 'dart:math';
import 'dart:async';

class SplashScreen2 extends StatefulWidget {
  static final screenname = '/splash';
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  final digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  final imageWidth = 320.0;
  final imageHeight = 171.0;
  final toleranceFactor = 0.033;
  final widthFactor = 0.125;
  final heightFactor = 0.5;
  final random =
      Random(); //!all finals are required for image animation please do not touch

  DataBase db = DataBase();
  List names;
  Auth auth = Auth();
  @override
  void initState() {
    super.initState();
    ontonextScreen();
  }

  void ontonextScreen() async {
    
    Future.delayed(
      const Duration(milliseconds: 4500),
      () {
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.screenname,(r)=>false);
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: k_app_backgroundcolor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                0,
                1,
                2,
                3,
                4,
                5,
                6,
                7,
              ]
                  .map((count) => FlipPanel.stream(
                        itemStream: Stream.fromFuture(Future.delayed(
                            Duration(milliseconds: random.nextInt(20) * 100),
                            () => 1)),
                        itemBuilder: (_, value) => value <= 0
                            ? Container(
                                color: k_app_backgroundcolor,
                                width: widthFactor * imageWidth,
                                height: heightFactor * imageHeight,
                              )
                            : ClipRect(
                                child: Align(
                                    alignment: Alignment(
                                        -1.0 +
                                            count * 2 * 0.125 +
                                            count * toleranceFactor,
                                        -1.0),
                                    widthFactor: widthFactor,
                                    heightFactor: heightFactor,
                                    child: Image.asset(
                                      'images/mainLogo.png',
                                      width: imageWidth,
                                      height: imageHeight,
                                    ))),
                        initValue: 0,
                        spacing: 0.0,
                        direction: FlipDirection.up,
                      ))
                  .toList(),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                0,
                1,
                2,
                3,
                4,
                5,
                6,
                7,
              ]
                  .map((count) => FlipPanel.stream(
                        itemStream: Stream.fromFuture(Future.delayed(
                            Duration(milliseconds: random.nextInt(20) * 100),
                            () => 1)),
                        itemBuilder: (_, value) => value <= 0
                            ? Container(
                                color: k_app_backgroundcolor,
                                width: widthFactor * imageWidth,
                                height: heightFactor * imageHeight,
                              )
                            : ClipRect(
                                child: Align(
                                    alignment: Alignment(
                                        -1.0 +
                                            count * 2 * 0.125 +
                                            count * toleranceFactor,
                                        1.0),
                                    widthFactor: widthFactor,
                                    heightFactor: heightFactor,
                                    child: Image.asset(
                                      'images/mainLogo.png',
                                      width: imageWidth,
                                      height: imageHeight,
                                    ))),
                        initValue: 0,
                        spacing: 0.0,
                        direction: FlipDirection.down,
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
