// Exercise 1: Stack and Positioned - Profile Card with Badge (Beginner)
// Create a profile card with an image and a badge overlay using Stack

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile with Badge'),
        ),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                // TODO: Add a Container with CircleAvatar or colored circle as background

                // TODO: Add Positioned widget in top-right corner (top: 0, right: 0)
                // with a small badge (Container with green color, 40x40, circular)
                // showing a checkmark icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
