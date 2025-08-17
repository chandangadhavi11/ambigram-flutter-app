import 'package:flutter/material.dart';

/// Provider for managing settings-related state
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'en';

  /// The current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether notifications are enabled
  bool get notificationsEnabled => _notificationsEnabled;

  /// The selected language code
  String get selectedLanguage => _selectedLanguage;

  /// Sets the theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Toggles the dark mode
  void toggleDarkMode() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// Sets whether notifications are enabled
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  /// Sets the selected language
  void setLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }

  /// Loads settings from local storage
  Future<void> loadSettings() async {
    // TODO: Load settings from SharedPreferences
    notifyListeners();
  }

  /// Saves settings to local storage
  Future<void> saveSettings() async {
    // TODO: Save settings to SharedPreferences
  }
}
