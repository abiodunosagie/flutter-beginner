// Exercise 1: My First Flutter App (Beginner)
// TODO: Create a simple Flutter app with Text and Container

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TODO: Add your title'),
        ),
        body: Center(
          child: Container(
            // TODO: Add padding
            // TODO: Add decoration (color, border radius)
            child: Text(
              'TODO: Add your text',
              // TODO: Add text style (fontSize, color, fontWeight)
            ),
          ),
        ),
      ),
    );
  }
}
