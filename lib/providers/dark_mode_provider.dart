import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider with ChangeNotifier {
  bool isDark = false;

  switchMode() {
    isDark = !isDark;
    storeMode();
  }

  storeMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isDark", isDark);
    getMode();
  }

  getMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isDark = pref.getBool("isDark") ?? false;
    notifyListeners();
  }
}
