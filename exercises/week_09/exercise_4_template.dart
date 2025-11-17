// Exercise 4: Widget Composition - Social Media Post (Intermediate-Advanced)
// Build a complex social media post widget using composition

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Feed',
      home: SocialFeedScreen(),
    );
  }
}

class SocialFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Feed'),
      ),
      body: ListView(
        children: [
          // TODO: Create 2-3 SocialPost widgets with different data
        ],
      ),
    );
  }
}

// TODO: Create PostHeader widget (StatelessWidget)
// Parameters: String authorName, String timeAgo, String avatarUrl (optional)
// Display: Avatar, author name, timestamp, and more menu icon

// TODO: Create PostContent widget (StatelessWidget)
// Parameters: String content, String? imageUrl (optional)
// Display: Text content and optional image

// TODO: Create PostActions widget (StatelessWidget)
// Parameters: int likes, int comments, int shares
// Display: Row with like, comment, and share buttons with counts

// TODO: Create SocialPost widget that composes all above widgets
// Parameters: All necessary data (authorName, content, likes, etc.)
// Uses: PostHeader, PostContent, PostActions in a Card
