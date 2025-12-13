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
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        children: [
          SocialPost(
            authorName: 'Alice Johnson',
            timeAgo: '2h',
            content: 'Just finished building my first Flutter app! 🚀',
            likes: 42,
            comments: 8,
            shares: 3,
          ),
          SocialPost(
            authorName: 'Bob Smith',
            timeAgo: '5h',
            content: 'Learning Dart is so much fun! Loving the community.',
            likes: 28,
            comments: 5,
            shares: 1,
          ),
          SocialPost(
            authorName: 'Carol White',
            timeAgo: '1d',
            content: 'Check out this amazing sunset! 🌅',
            likes: 156,
            comments: 23,
            shares: 12,
          ),
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final String authorName;
  final String timeAgo;

  const PostHeader({
    Key? key,
    required this.authorName,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Text(
            authorName[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '$timeAgo ago',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}

class PostContent extends StatelessWidget {
  final String content;

  const PostContent({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
    );
  }
}

class PostActions extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;

  const PostActions({
    Key? key,
    required this.likes,
    required this.comments,
    required this.shares,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.favorite_border,
          label: '$likes',
          onPressed: () {},
        ),
        _ActionButton(
          icon: Icons.comment_outlined,
          label: '$comments',
          onPressed: () {},
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: '$shares',
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
      ),
    );
  }
}

class SocialPost extends StatelessWidget {
  final String authorName;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;

  const SocialPost({
    Key? key,
    required this.authorName,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              authorName: authorName,
              timeAgo: timeAgo,
            ),
            SizedBox(height: 12),
            PostContent(content: content),
            SizedBox(height: 12),
            Divider(),
            PostActions(
              likes: likes,
              comments: comments,
              shares: shares,
            ),
          ],
        ),
      ),
    );
  }
}
