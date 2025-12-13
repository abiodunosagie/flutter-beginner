// Week 12, Exercise 1: Theme Persistence with SharedPreferences
// Difficulty: Beginner
//
// Instructions:
// 1. Add shared_preferences dependency
// 2. Create a ThemeNotifier extending StateNotifier<ThemeMode>
// 3. Implement _loadTheme() to load saved theme from SharedPreferences
// 4. Implement toggleTheme() to switch theme and save to SharedPreferences
// 5. Create a provider for ThemeNotifier
// 6. Build UI that shows current theme and allows toggling
//
// Learning objectives:
// - Using SharedPreferences
// - Persisting app state
// - Loading state on app start
// - Theme management
//
// TODO: Import necessary packages
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // TODO: Wrap with ProviderScope
  runApp(MyApp());
}

// TODO: Create ThemeNotifier extending StateNotifier<ThemeMode>
class ThemeNotifier extends StateNotifier<ThemeMode> {
  // Initialize with ThemeMode.light
  // TODO: Call _loadTheme() in constructor

  // TODO: Implement _loadTheme()
  Future<void> _loadTheme() async {
    // Load 'isDarkMode' from SharedPreferences
    // Update state based on saved value
  }

  // TODO: Implement toggleTheme()
  Future<void> toggleTheme() async {
    // Toggle between light and dark
    // Save to SharedPreferences
  }
}

// TODO: Create provider
// final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(...);

// TODO: Convert MyApp to ConsumerWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch themeProvider
    // TODO: Use themeMode in MaterialApp

    return MaterialApp(
      title: 'Theme Persistence',
      // TODO: Set themeMode, theme, and darkTheme
      home: HomeScreen(),
    );
  }
}

// TODO: Convert to ConsumerWidget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch themeProvider
    // TODO: Display current theme
    // TODO: Add button to toggle theme

    return Scaffold(
      appBar: AppBar(title: Text('Theme Persistence')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add theme icon
            // TODO: Add theme text
            // TODO: Add toggle button
          ],
        ),
      ),
    );
  }
}
