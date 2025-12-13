// Exercise 2: Personal Card with Icon (Beginner-Intermediate)
// Create a personal card with profile icon, name, and contact info

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Card',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Create a Container with circular shape (100x100)
              // Use BoxDecoration with shape: BoxShape.circle
              // Add an Icon (Icons.person) as child

              // TODO: Add SizedBox with height 20

              // TODO: Add Text with your name (fontSize: 28, fontWeight: bold)

              // TODO: Add SizedBox with height 10

              // TODO: Add Text with job title (fontSize: 18, color: grey)

              // TODO: Add SizedBox with height 20

              // TODO: Create a Row with email and phone info
              // Use Icons.email and Icons.phone with corresponding text
            ],
          ),
        ),
      ),
    );
  }
}
