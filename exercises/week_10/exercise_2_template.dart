// Exercise 2: Dark Mode Toggle (Beginner-Intermediate)
// Create an app with light/dark theme toggle

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TODO: Create _isDarkMode variable (bool) initialized to false

  // TODO: Create _toggleTheme method that toggles _isDarkMode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Demo',
      // TODO: Set theme to light theme with custom colors

      // TODO: Set darkTheme to dark theme with custom colors

      // TODO: Set themeMode based on _isDarkMode
      // Use ThemeMode.light or ThemeMode.dark

      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Mode Demo'),
        actions: [
          // TODO: Add IconButton with sun/moon icon
          // Call onToggleTheme when pressed
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add Icon showing current mode (sun or moon, large size)

            // TODO: Add Text showing current mode status

            // TODO: Add Switch to toggle theme
          ],
        ),
      ),
    );
  }
}
