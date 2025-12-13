// Week 12, Exercise 2: User Settings with SharedPreferences and Riverpod
// Difficulty: Beginner-Intermediate
// Solution

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// SettingsState class
class SettingsState {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final String language;

  const SettingsState({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.language = 'en',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'language': language,
    };
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      language: json['language'] ?? 'en',
    );
  }
}

// SettingsNotifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notif = prefs.getBool('notifications') ?? true;
    final sound = prefs.getBool('sound') ?? true;
    final lang = prefs.getString('language') ?? 'en';

    state = SettingsState(
      notificationsEnabled: notif,
      soundEnabled: sound,
      language: lang,
    );
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: newValue);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', newValue);
  }

  Future<void> toggleSound() async {
    final newValue = !state.soundEnabled;
    state = state.copyWith(soundEnabled: newValue);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', newValue);
  }

  Future<void> changeLanguage(String language) async {
    state = state.copyWith(language: language);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Settings',
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  final Map<String, String> languages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.all(8),
            child: SwitchListTile(
              title: Text('Notifications'),
              subtitle: Text(
                settings.notificationsEnabled ? 'Enabled' : 'Disabled',
              ),
              secondary: Icon(
                settings.notificationsEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
              ),
              value: settings.notificationsEnabled,
              onChanged: (_) {
                ref.read(settingsProvider.notifier).toggleNotifications();
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: SwitchListTile(
              title: Text('Sound'),
              subtitle: Text(
                settings.soundEnabled ? 'Enabled' : 'Disabled',
              ),
              secondary: Icon(
                settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
              ),
              value: settings.soundEnabled,
              onChanged: (_) {
                ref.read(settingsProvider.notifier).toggleSound();
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text(languages[settings.language] ?? 'Unknown'),
              trailing: DropdownButton<String>(
                value: settings.language,
                items: languages.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).changeLanguage(value);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Settings are automatically saved and persist across app restarts!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
