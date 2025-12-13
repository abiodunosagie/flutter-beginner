/// Week 27, Exercise 4: Social Posts with Firestore + Auth
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// Create a social posts app combining Auth and Firestore:
/// 1. Users must be authenticated to create posts
/// 2. Create Post model with author info
/// 3. Implement CREATE - add posts with current user as author
/// 4. Implement READ - fetch posts from all users
/// 5. Implement like/unlike functionality (update likes count)
/// 6. Show author name and photo with each post
/// 7. Only post author can delete their posts
/// 8. Real-time updates for posts and likes
///
/// Learning objectives:
/// - Combine Firebase Auth with Firestore
/// - User-generated content
/// - Access control
/// - Real-time social features

import 'package:flutter/material.dart';
// TODO: Add packages:
// firebase_core, firebase_auth, cloud_firestore

void main() async {
  // TODO: Initialize Firebase
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Posts',
      home: AuthWrapper(),
    );
  }
}

// TODO: Create Post model
// class Post {
//   final String? id;
//   final String authorId;
//   final String authorName;
//   final String content;
//   final int likes;
//   final List<String> likedBy;
//   final DateTime createdAt;
//
//   Post({...});
//
//   Map<String, dynamic> toMap() {}
//   factory Post.fromFirestore(DocumentSnapshot doc) {}
// }

// TODO: Create PostsService
// class PostsService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // CREATE post
//   Future<void> createPost(String userId, String userName, String content) async {}
//
//   // READ posts (all users)
//   Stream<List<Post>> watchPosts() {}
//
//   // LIKE/UNLIKE post
//   Future<void> toggleLike(String postId, String userId) async {}
//
//   // DELETE post (only if author)
//   Future<void> deletePost(String postId, String userId) async {}
// }

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Use StreamBuilder to check auth state
    // If authenticated -> PostsScreen
    // If not -> LoginScreen
    return LoginScreen();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Simple login UI
    // For demo, you can use mock auth
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Sign in and navigate to PostsScreen
          },
          child: Text('Sign In'),
        ),
      ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get current user
    // TODO: Create PostsService instance

    return Scaffold(
      appBar: AppBar(
        title: Text('Social Feed'),
        actions: [
          // TODO: Sign out button
        ],
      ),
      body: StreamBuilder(
        // TODO: Stream posts from PostsService
        stream: null,
        builder: (context, snapshot) {
          // TODO: Handle loading, error, empty states

          // TODO: Display posts in ListView
          // - Show author name and time
          // - Show post content
          // - Show like count and like button
          // - Show delete button (only for post author)

          return Center(child: Text('No posts'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create post dialog
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// TODO: Create PostCard widget to display each post
// - Author info
// - Content
// - Like button with count
// - Delete button (conditional)
// - Timestamp
