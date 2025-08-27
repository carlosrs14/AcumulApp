import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _keyColor = 'primaryColor';
  static const _keyMode = 'themeMode';

  ThemeData _lightTheme;
  ThemeData _darkTheme;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(Color initialColor, ThemeMode initialMode)
    : _lightTheme = ThemeData(
        primaryColor: initialColor,
        fontFamily: "Roboto",
        colorScheme: ColorScheme.light(
          primary: initialColor,
          onPrimary: getContrastingTextColor(initialColor),
          secondary: initialColor.withOpacity(0.8),
        ),
        useMaterial3: false,
      ),
      _darkTheme = ThemeData(
        primaryColor: initialColor,
        fontFamily: "Roboto",
        colorScheme: ColorScheme.dark(
          primary: initialColor,
          onPrimary: getContrastingTextColor(initialColor),
          secondary: initialColor.withOpacity(0.8),
        ),
        useMaterial3: false,
      ),
      _themeMode = initialMode;

  // === Getters ===
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeMode get themeMode => _themeMode;

  // === Helpers ===
  static Color getContrastingTextColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  // === Cambiar color principal ===
  void setPrimaryColor(Color color, ThemeMode currentMode) async {
    if (color.computeLuminance() > 0.9 && currentMode == ThemeMode.light) {
      color = const Color.fromARGB(255, 143, 143, 143);
    }
    _lightTheme = ThemeData(
      primaryColor: color,
      fontFamily: "Roboto",
      colorScheme: ColorScheme.light(
        primary: color,
        onPrimary: getContrastingTextColor(color),
        secondary: color.withOpacity(0.8),
      ),
      useMaterial3: false,
    );

    _darkTheme = ThemeData(
      primaryColor: color,
      fontFamily: "Roboto",
      colorScheme: ColorScheme.dark(
        primary: color,
        onPrimary: getContrastingTextColor(color),
        secondary: color.withOpacity(0.8),
      ),
      useMaterial3: false,
    );

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyColor, color.value);
  }

  // === Cambiar modo claro/oscuro/sistema ===
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyMode, mode.toString());
  }

  // === Cargar color guardado ===
  static Future<Color> getSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final intColor = prefs.getInt(_keyColor);
    return intColor != null ? Color(intColor) : Colors.deepPurple;
  }

  // === Cargar modo guardado ===
  static Future<ThemeMode> getSavedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_keyMode);
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
