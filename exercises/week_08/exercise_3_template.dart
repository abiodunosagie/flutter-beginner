// Exercise 3: Text Input with Live Preview (Intermediate)
// Create an app where user types and sees the text displayed with customization

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Input Demo',
      home: TextInputScreen(),
    );
  }
}

class TextInputScreen extends StatefulWidget {
  @override
  _TextInputScreenState createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  // TODO: Create _text variable to store input

  // TODO: Create _fontSize variable with default value 24.0

  // TODO: Create _isBold variable with default value false

  // TODO: Create method _updateText that takes a String and updates _text

  // TODO: Create method _toggleBold that toggles _isBold

  // TODO: Create method _increaseFontSize that increases _fontSize by 2

  // TODO: Create method _decreaseFontSize that decreases _fontSize by 2 (minimum 10)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Input Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // TODO: Add TextField with decoration
            // onChanged should call _updateText

            // TODO: Add SizedBox height 30

            // TODO: Add preview text showing _text with current styling

            // TODO: Add SizedBox height 30

            // TODO: Add control buttons Row:
            // - "A-" button (decrease font)
            // - "A+" button (increase font)
            // - "B" button (toggle bold)
          ],
        ),
      ),
    );
  }
}
