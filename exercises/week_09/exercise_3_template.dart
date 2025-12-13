// Exercise 3: Custom Reusable Widget - Info Card (Intermediate)
// Create a reusable InfoCard widget and use it multiple times

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Widgets',
      home: InfoCardsScreen(),
    );
  }
}

class InfoCardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Cards'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO: Create 4 InfoCard instances with different:
            // - Icons (Icons.person, Icons.email, Icons.phone, Icons.location_on)
            // - Titles
            // - Descriptions
            // - Colors
          ],
        ),
      ),
    );
  }
}

// TODO: Create InfoCard widget class that extends StatelessWidget
// Parameters should include:
// - IconData icon (required)
// - String title (required)
// - String description (required)
// - Color color (optional, default to Colors.blue)
//
// The widget should display a Card with:
// - Row containing icon and text information
// - Proper styling with the provided color
