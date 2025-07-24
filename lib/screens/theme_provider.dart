import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _key = 'primaryColor';
  ThemeData _themeData;

  ThemeProvider(Color initialColor)
    : _themeData = ThemeData(
        primaryColor: initialColor,
        colorScheme: ColorScheme.light(
          primary: initialColor,
          onPrimary: Colors.white,
          secondary: initialColor.withOpacity(0.8),
        ),
        useMaterial3: false,
      );

  ThemeData get themeData => _themeData;

  void setPrimaryColor(Color color) async {
    _themeData = ThemeData(
      primaryColor: color,
      colorScheme: ColorScheme.light(
        primary: color,
        onPrimary: Colors.white,
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
