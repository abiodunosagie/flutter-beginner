// Exercise 1: Basic App Theme (Beginner)
// Create an app with a custom theme applied globally

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: ThemeData(
        // TODO: Set primarySwatch to Colors.deepPurple

        // TODO: Set colorScheme with secondary color Colors.amber

        // TODO: Configure appBarTheme with backgroundColor and foregroundColor

        // TODO: Configure elevatedButtonTheme with custom styling
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
        title: Text('Themed App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add Text widget that uses theme.textTheme.headlineMedium

            // TODO: Add SizedBox height 20

            // TODO: Add ElevatedButton (it will use theme automatically)

            // TODO: Add SizedBox height 10

            // TODO: Add OutlinedButton
          ],
        ),
      ),
    );
  }
}
