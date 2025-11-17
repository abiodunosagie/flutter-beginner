// Exercise 4: Social Media Profile (Intermediate-Advanced)
// Create a social media profile page with stats and action buttons

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: Create profile header section
            // - Container with height 200, gradient background (purple to blue)
            // - CircleAvatar with radius 50 (use Icons.person or network image)
            // - Name text below avatar

            // TODO: Create stats row with 3 columns
            // - Posts: 120
            // - Followers: 1.2K
            // - Following: 850
            // Use _buildStatColumn method

            // TODO: Create bio section
            // - Container with padding
            // - Bio text

            // TODO: Create action buttons row
            // - Follow button (ElevatedButton)
            // - Message button (OutlinedButton)

            // TODO: Create "Recent Posts" section with 3 ListTiles
          ],
        ),
      ),
    );
  }

  // TODO: Create _buildStatColumn method
  // Parameters: String label, String count
  // Returns Column with count and label
}
