import 'package:chuglimessenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;
  bool get isDarkMode {
    if (theme == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return theme == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    theme = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Mytheme {
  static final lighttheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(color: Colors.blueGrey.shade700),
    primaryColor: k_app_backgroundcolor,
  );
  static final darktheme = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(color: k_app_backgroundcolor),
      primaryColor: Colors.white);
}
