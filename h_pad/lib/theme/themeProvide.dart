import 'package:flutter/material.dart';

class ThemeProvide with ChangeNotifier {
  int _themeIndex;

  int get value => _themeIndex;

  ThemeProvide();

  void setTheme(int index) async {
    print('$index>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    _themeIndex = index;
    notifyListeners();
  }
}
