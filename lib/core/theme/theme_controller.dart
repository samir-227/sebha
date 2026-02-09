import 'package:flutter/material.dart';

/// بسيط للتحكم في وضع الثيم (فاتح/داكن) من داخل التطبيق.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get themeMode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void toggleTheme() {
    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
    } else {
      _mode = ThemeMode.dark;
    }
    notifyListeners();
  }
}

