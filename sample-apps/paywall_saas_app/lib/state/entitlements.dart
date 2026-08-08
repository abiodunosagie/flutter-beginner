import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Free vs Pro. Replace purchaseMock with RevenueCat (Level 22 / App 18).
class Entitlements extends ChangeNotifier {
  static const freeNoteLimit = 3;
  static const _key = 'is_pro_v1';

  bool isPro = false;
  bool loaded = false;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    isPro = prefs.getBool(_key) ?? false;
    loaded = true;
    notifyListeners();
  }

  Future<void> purchaseMockMonthly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    isPro = true;
    notifyListeners();
  }

  Future<void> restoreMock() async {
    await load();
  }

  Future<void> clearForDemo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    isPro = false;
    notifyListeners();
  }

  bool canAddNote(int currentCount) => isPro || currentCount < freeNoteLimit;
}
