import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _key = 'primaryColor';
  ThemeData _lightTheme;
  ThemeData _darkTheme;

  static Color getContrastingTextColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  ThemeProvider(Color initialColor)
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
      );

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;

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
    prefs.setInt(_key, color.value);
  }

  static Future<Color> getSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final intColor = prefs.getInt(_key);
    return intColor != null ? Color(intColor) : Colors.deepPurple;
  }
}
