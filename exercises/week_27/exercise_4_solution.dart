/// Week 27, Exercise 4: Social Posts with Firestore + Auth
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: AuthWrapper(),
    );
  }
}

class Post {
  final String? id;
  final String authorId;
  final String authorName;
  final String content;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;

  Post({
    this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    this.likes = 0,
    this.likedBy = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Unknown',
      content: data['content'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  bool isLikedBy(String userId) => likedBy.contains(userId);
}

class PostsService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mock data for demo
  final List<Post> _mockPosts = [
    Post(
      id: '1',
      authorId: 'user1',
      authorName: 'John Doe',
      content: 'Hello Flutter community! Loving Firestore!',
      likes: 5,
      likedBy: ['user2', 'user3'],
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      id: '2',
      authorId: 'user2',
      authorName: 'Jane Smith',
      content: 'Just deployed my first Flutter app to production!',
      likes: 12,
      likedBy: ['user1', 'user3', 'user4'],
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
  ];

  Future<void> createPost(String userId, String userName, String content) async {
    // await _db.collection('posts').add(Post(
    //   authorId: userId,
    //   authorName: userName,
    //   content: content,
    // ).toMap());

    await Future.delayed(Duration(milliseconds: 500));
    _mockPosts.insert(
      0,
      Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: userId,
        authorName: userName,
        content: content,
      ),
    );
  }

  Stream<List<Post>> watchPosts() {
    // return _db
    //     .collection('posts')
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => Post.fromMap(doc.id, doc.data())).toList());

    return Stream.periodic(Duration(milliseconds: 100), (_) => List<Post>.from(_mockPosts));
  }

  Future<void> toggleLike(String postId, String userId) async {
    final index = _mockPosts.indexWhere((p) => p.id == postId);
    if (index < 0) return;

    final post = _mockPosts[index];
    final isLiked = post.isLikedBy(userId);

    final updatedLikedBy = List<String>.from(post.likedBy);
    if (isLiked) {
      updatedLikedBy.remove(userId);
    } else {
      updatedLikedBy.add(userId);
    }

    // await _db.collection('posts').doc(postId).update({
    //   'likes': FieldValue.increment(isLiked ? -1 : 1),
    //   'likedBy': isLiked ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId]),
    // });

    await Future.delayed(Duration(milliseconds: 200));
    _mockPosts[index] = Post(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      content: post.content,
      likes: updatedLikedBy.length,
      likedBy: updatedLikedBy,
      createdAt: post.createdAt,
    );
  }

  Future<void> deletePost(String postId, String userId) async {
    // Verify user is author
    // final doc = await _db.collection('posts').doc(postId).get();
    // if (doc.data()?['authorId'] != userId) {
    //   throw 'You can only delete your own posts';
    // }
    // await _db.collection('posts').doc(postId).delete();

    await Future.delayed(Duration(milliseconds: 300));
    _mockPosts.removeWhere((p) => p.id == postId);
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Scaffold(body: Center(child: CircularProgressIndicator()));
    //     }
    //     if (snapshot.hasData) {
    //       return PostsScreen();
    //     }
    //     return LoginScreen();
    //   },
    // );

    // For demo, go directly to posts
    return PostsScreen();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 80, color: Colors.purple),
            SizedBox(height: 24),
            Text(
              'Social Posts',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PostsScreen()),
                );
              },
              child: Text('Sign In (Demo)'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  final String currentUserId = 'user1'; // Demo user
  final String currentUserName = 'John Doe';

  @override
  Widget build(BuildContext context) {
    final postsService = PostsService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Social Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: postsService.watchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No posts yet', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Be the first to post!'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                currentUserId: currentUserId,
                onLike: () => postsService.toggleLike(post.id!, currentUserId),
                onDelete: () => _deletePost(context, postsService, post),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context, postsService),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, PostsService service) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Post'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'What\'s on your mind?',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await service.createPost(
                  currentUserId,
                  currentUserName,
                  controller.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  void _deletePost(BuildContext context, PostsService service, Post post) {
    if (post.authorId != currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only delete your own posts')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await service.deletePost(post.id!, currentUserId);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback onDelete;

  const PostCard({
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.isLikedBy(currentUserId);
    final isAuthor = post.authorId == currentUserId;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.authorName[0]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatTime(post.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isAuthor)
                  IconButton(
                    icon: Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
                    color: Colors.grey,
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(post.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text('${post.likes}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
