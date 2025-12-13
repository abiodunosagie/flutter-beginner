/// Exercise 1 Solution: SharedPreferences - User Settings Manager

import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsManager {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLanguage = 'language';
  static const String _keyNotifications = 'notifications';
  static const String _keyFontSize = 'font_size';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDarkMode => _prefs?.getBool(_keyDarkMode) ?? false;
  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_keyDarkMode, value);
  }

  String get language => _prefs?.getString(_keyLanguage) ?? 'en';
  Future<void> setLanguage(String value) async {
    await _prefs?.setString(_keyLanguage, value);
  }

  bool get notificationsEnabled => _prefs?.getBool(_keyNotifications) ?? true;
  Future<void> setNotifications(bool value) async {
    await _prefs?.setBool(_keyNotifications, value);
  }

  double get fontSize => _prefs?.getDouble(_keyFontSize) ?? 16.0;
  Future<void> setFontSize(double value) async {
    await _prefs?.setDouble(_keyFontSize, value);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  Map<String, dynamic> getAllSettings() {
    return {
      'darkMode': isDarkMode,
      'language': language,
      'notifications': notificationsEnabled,
      'fontSize': fontSize,
    };
  }
}

void main() async {
  final settings = UserSettingsManager();
  await settings.init();

  print('=== Initial Settings ===');
  print(settings.getAllSettings());

  print('\n=== Updating Settings ===');
  await settings.setDarkMode(true);
  await settings.setLanguage('es');
  await settings.setFontSize(18.0);
  await settings.setNotifications(false);

  print('Updated: ${settings.getAllSettings()}');
}
