// Exercise 1: Hello Flutter App (Beginner)
// Create a simple Flutter app that displays a welcome message

import 'package:flutter/material.dart';

void main() {
  // TODO: Call runApp() with MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter',
      home: Scaffold(
        appBar: AppBar(
          // TODO: Add a title "Welcome to Flutter"
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Add a Text widget with "Hello, Flutter!" (font size 32)

              // TODO: Add a SizedBox with height 20

              // TODO: Add a Text widget with your name (font size 20)
            ],
          ),
        ),
      ),
    );
  }
}
