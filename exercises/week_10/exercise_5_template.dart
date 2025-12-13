// Exercise 5: Complete Responsive App with Theming (Advanced)
// Create a full responsive app with dark mode, adaptive layouts, and custom theme

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // TODO: Create _isDarkMode variable

  // TODO: Create light and dark ThemeData objects with custom colors

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Responsive App',
      // TODO: Set theme and darkTheme
      // TODO: Set themeMode based on _isDarkMode
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
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
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive App'),
        actions: [
          // TODO: Add theme toggle button
        ],
      ),
      drawer: !isDesktop ? Drawer(child: _buildNavigation(context)) : null,
      body: Row(
        children: [
          // TODO: Add permanent navigation for desktop

          // TODO: Add main content area with responsive grid
          // Show 1, 2, or 3 columns based on width
        ],
      ),
    );
  }

  // TODO: Create _buildNavigation method

  // TODO: Create _buildMainContent method with responsive grid

  // TODO: Create _buildFeatureCard method
}
