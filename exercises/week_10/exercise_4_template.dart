// Exercise 4: Adaptive Layout - Mobile vs Desktop (Intermediate-Advanced)
// Create different layouts for mobile and desktop screens

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Layout',
      home: AdaptiveLayoutScreen(),
    );
  }
}

class AdaptiveLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adaptive Layout'),
      ),
      // TODO: Add drawer for mobile (when width < 900)

      body: Row(
        children: [
          // TODO: Add sidebar for desktop (when width >= 900)
          // Use MediaQuery to check screen width
          // Sidebar should be Container with width 250

          // TODO: Add Expanded widget with main content
          // Use LayoutBuilder to show different layouts based on width
        ],
      ),
    );
  }

  // TODO: Create _buildSidebarContent method
  // Returns ListView with navigation items

  // TODO: Create _buildMainContent method
  // Takes maxWidth parameter
  // Returns different layouts for mobile vs desktop
}
