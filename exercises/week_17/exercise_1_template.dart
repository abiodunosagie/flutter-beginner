/// Week 17, Exercise 1: Basic Flutter Web App with Platform Detection
///
/// BEGINNER LEVEL
///
/// Create a simple Flutter web app that:
/// 1. Detects if running on web or mobile
/// 2. Shows different UI based on platform
/// 3. Displays a centered welcome message
/// 4. Has a button that prints to console
/// 5. Uses different padding for web vs mobile
///
/// Learning objectives:
/// - Use kIsWeb to detect platform
/// - Understand basic web setup
/// - Create platform-adaptive UI

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyWebApp());
}

class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web Exercise 1'),
      ),
      body: Center(
        child: Container(
          // TODO: Add platform-specific padding
          // Use EdgeInsets.all() with kIsWeb check
          // Web: 32px, Mobile: 16px

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Add platform detection text
              // Show "Running on Web" or "Running on Mobile"

              SizedBox(height: 24),

              // TODO: Add welcome message
              // Title: "Welcome to Flutter Web!"
              // fontSize: 32, fontWeight: bold

              SizedBox(height: 16),

              // TODO: Add description text
              // "This app adapts to different platforms"
              // fontSize: 18, color: grey

              SizedBox(height: 32),

              // TODO: Add button that prints platform to console
              // Use ElevatedButton with onPressed
              // Print "Button clicked on [platform]"
            ],
          ),
        ),
      ),
    );
  }
}
