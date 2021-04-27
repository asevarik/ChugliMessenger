import 'package:chuglimessenger/Components/ThemeProvider.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/screens/ChatMssgScreen.dart';
import 'package:chuglimessenger/screens/ForgotPassScreen.dart';
import 'package:chuglimessenger/screens/SearchScreen.dart';
import 'package:chuglimessenger/screens/SplashScreen1.dart';
import 'package:chuglimessenger/screens/nointernetscreen.dart';
import 'package:chuglimessenger/services/Wrapper.dart';
import 'package:chuglimessenger/services/auth.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chuglimessenger/screens/HomeScreen.dart';
import 'package:chuglimessenger/screens/LoginScreen.dart';
import 'package:chuglimessenger/screens/RegisterScreen.dart';
import 'package:chuglimessenger/screens/Welcomescreen.dart';
import 'package:chuglimessenger/screens/Splashscreen2.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChugliApp());
}

class ChugliApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _ChugliAppState createState() => _ChugliAppState();
}

class _ChugliAppState extends State<ChugliApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

//

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      //*App is in the background
      DataBase().updateUserpresence(GlobalContants.uid, false);
    }
    if (state == AppLifecycleState.detached) {
      //*App is Closed
      DataBase().updateUserpresence(GlobalContants.uid, false);
    }
    if (state == AppLifecycleState.resumed) {
      //*User is Resumed
      DataBase().updateUserpresence(GlobalContants.uid, true);
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return StreamProvider<FirebaseUser>.value(
          //listens to th
          value: Auth().user,
          child: MaterialApp(
            title: 'Chugli App',
            themeMode: themeProvider.theme,
            theme: Mytheme.lighttheme,
            darkTheme: Mytheme.darktheme,
            routes: {
              WelcomeScreen.screenname: (context) => WelcomeScreen(),
              HomeScreen.screenname: (context) => HomeScreen(),
              LoginScreen.screenname: (context) => LoginScreen(),
              RegisterScreen.screenname: (context) => RegisterScreen(),
              SplashScreen2.screenname: (context) => SplashScreen2(),
              SplashScreen1.screenname: (context) => SplashScreen1(),
              Wrapper.screenname: (context) => Wrapper(),
              ForgotPassScreen.screenname: (context) => ForgotPassScreen(),
              SearchScreen.screenname: (context) => SearchScreen(),
              ChatMssgScreen.screenname: (context) => ChatMssgScreen(),
              NoInternetScreen.screenname: (context) => NoInternetScreen(),
              //!Some Major Changes Required in the Backend so it Is Skipped
              // ProfileScreen.screenname: (context) => ProfileScreen(),
            },
            //!make initial route to Wrapper.screename
            initialRoute: Wrapper.screenname,
          ),
        );
      });
}
