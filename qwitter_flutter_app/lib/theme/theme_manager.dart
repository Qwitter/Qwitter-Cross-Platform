import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _theme_mode = ThemeMode.light;

  get themeMode => _theme_mode;

  toggleTheme(bool isDark) {
    _theme_mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
