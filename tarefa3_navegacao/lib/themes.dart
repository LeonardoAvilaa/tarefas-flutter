import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// tema claro
final lighttheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 204, 204, 204),
);

// tema escuro
final darktheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 42, 42, 42),
);

// gerenciador de temas
class ThemeManager extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('themeMode');
    if (index != null) {
      _mode = ThemeMode.values[index];
      notifyListeners();
    }
  }

  // alterna entre os temas
  void toggleTheme() async {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _mode.index);
  }
}
