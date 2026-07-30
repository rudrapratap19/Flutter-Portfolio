import 'package:flutter/material.dart';

enum AppThemeMode { dark, light, cmd }

class ThemeNotifier extends ValueNotifier<AppThemeMode> {
  ThemeNotifier._() : super(AppThemeMode.light);

  static final ThemeNotifier instance = ThemeNotifier._();

  bool get isDarkMode => value == AppThemeMode.dark;
  bool get isLightMode => value == AppThemeMode.light;
  bool get isCmdMode => value == AppThemeMode.cmd;

  /// Compatibility getter for ThemeMode
  ThemeMode get materialThemeMode {
    switch (value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
      case AppThemeMode.cmd:
        return ThemeMode.dark;
    }
  }

  void toggleTheme() {
    if (value == AppThemeMode.dark) {
      value = AppThemeMode.light;
    } else if (value == AppThemeMode.light) {
      value = AppThemeMode.cmd;
    } else {
      value = AppThemeMode.dark;
    }
  }

  void setTheme(AppThemeMode mode) {
    value = mode;
  }
}
