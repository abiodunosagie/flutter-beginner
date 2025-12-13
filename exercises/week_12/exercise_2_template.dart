// Week 12, Exercise 2: User Settings with SharedPreferences and Riverpod
// Difficulty: Beginner-Intermediate
//
// Instructions:
// 1. Create SettingsState class with: notificationsEnabled, soundEnabled, language
// 2. Add toJson() and fromJson() methods for serialization
// 3. Create SettingsNotifier extending StateNotifier<SettingsState>
// 4. Implement load, toggleNotifications, toggleSound, changeLanguage methods
// 5. Save to SharedPreferences after each change
// 6. Build UI with switches and language selector
//
// Learning objectives:
// - Persisting complex state
// - Serialization/deserialization
// - Multiple settings management
// - Saving on every change
//
// TODO: Import necessary packages

void main() {
  // TODO: Wrap with ProviderScope
  runApp(MyApp());
}

// TODO: Create SettingsState class
class SettingsState {
  // Fields: notificationsEnabled, soundEnabled, language
  // TODO: Add constructor with default values
  // TODO: Add copyWith method
  // TODO: Add toJson method
  // TODO: Add fromJson factory method
}

// TODO: Create SettingsNotifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  // Initialize with default SettingsState
  // TODO: Call _loadSettings() in constructor

  // TODO: Implement _loadSettings()
  // TODO: Implement toggleNotifications()
  // TODO: Implement toggleSound()
  // TODO: Implement changeLanguage(String language)
}

// TODO: Create provider
// final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(...);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Settings',
      home: SettingsScreen(),
    );
  }
}

// TODO: Convert to ConsumerWidget
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch settingsProvider
    // TODO: Build UI with:
    // - Notifications switch
    // - Sound switch
    // - Language selector (en, es, fr)

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // TODO: Add settings tiles
        ],
      ),
    );
  }
}
