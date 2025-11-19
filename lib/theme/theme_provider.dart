import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_app/theme/theme.dart';

class MyTheme extends ChangeNotifier {
  final Box _themeSeleted;
  bool _isDark;

  MyTheme(this._themeSeleted)
    : _isDark = _themeSeleted.get("isDarkMode", defaultValue: false);

  bool get isDark => _isDark;
  ThemeData get themeData => _isDark ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    _themeSeleted.put("isDarkMode", _isDark);
    notifyListeners();
  }
}
