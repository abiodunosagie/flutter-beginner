/// Exercise 1: SharedPreferences - User Settings Manager
///
/// Level: Beginner
///
/// Create a UserSettingsManager that persists user preferences using SharedPreferences.
/// Manage theme, language, notifications, and font size settings.

import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsManager {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLanguage = 'language';
  static const String _keyNotifications = 'notifications';
  static const String _keyFontSize = 'font_size';

  SharedPreferences? _prefs;

  // TODO: Initialize SharedPreferences
  Future<void> init() async {
    throw UnimplementedError();
  }

  // TODO: Dark mode getter/setter
  bool get isDarkMode => throw UnimplementedError();
  Future<void> setDarkMode(bool value) async => throw UnimplementedError();

  // TODO: Language getter/setter
  String get language => throw UnimplementedError();
  Future<void> setLanguage(String value) async => throw UnimplementedError();

  // TODO: Notifications getter/setter
  bool get notificationsEnabled => throw UnimplementedError();
  Future<void> setNotifications(bool value) async => throw UnimplementedError();

  // TODO: Font size getter/setter
  double get fontSize => throw UnimplementedError();
  Future<void> setFontSize(double value) async => throw UnimplementedError();

  // TODO: Clear all settings
  Future<void> clearAll() async => throw UnimplementedError();
}

void main() async {
  final settings = UserSettingsManager();
  await settings.init();

  await settings.setDarkMode(true);
  print('Dark mode: ${settings.isDarkMode}');
}
