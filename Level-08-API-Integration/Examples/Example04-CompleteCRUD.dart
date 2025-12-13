/// Example 04: Complete CRUD Operations
///
/// This example demonstrates all four CRUD operations:
/// Create (POST), Read (GET), Update (PUT/PATCH), Delete (DELETE)
///
/// To run: flutter run -t lib/main.dart (after copying to a Flutter project)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Complete CRUD operations
// 2. API service class pattern
// 3. Data model with fromJson/toJson
// 4. List management with state
// 5. Dialog forms for create/edit
//
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODEL
// ═══════════════════════════════════════════════════════════════════════════
//
// Visual:
// ┌─────────────────────────────────────────────────────────────┐
// │  Post Model                                                 │
// ├─────────────────────────────────────────────────────────────┤
// │  id: int                                                    │
// │  title: String                                              │
// │  body: String                                               │
// │  userId: int                                                │
// └─────────────────────────────────────────────────────────────┘

class Post {
  final int? id;
  final String title;
  final String body;
  final int userId;

  Post({
    this.id,
    required this.title,
    required this.body,
    this.userId = 1,
  });

  /// Create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 1,
    );
  }

  /// Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  /// Create a copy with modifications
  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// API SERVICE
// ═══════════════════════════════════════════════════════════════════════════
//
// CRUD Operations:
// ┌────────────────────────────────────────────────────────────────────────┐
// │  CREATE → POST /posts         → Returns created post with ID          │
// │  READ   → GET /posts          → Returns list of posts                 │
// │  UPDATE → PUT /posts/:id      → Returns updated post                  │
// │  DELETE → DELETE /posts/:id   → Returns empty (204) or success (200)  │
// └────────────────────────────────────────────────────────────────────────┘

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// CREATE - POST /posts
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create post: ${response.statusCode}');
  }

  /// READ - GET /posts
  Future<List<Post>> getPosts({int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts?_limit=$limit'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    }
    throw Exception('Failed to load posts: ${response.statusCode}');
  }

  /// READ - GET /posts/:id
  Future<Post> getPost(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load post: ${response.statusCode}');
  }

  /// UPDATE - PUT /posts/:id
  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update post: ${response.statusCode}');
  }

  /// DELETE - DELETE /posts/:id
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete post: ${response.statusCode}');
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// POSTS SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _service = PostService();

  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  /// Load posts from API
  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final posts = await _service.getPosts(limit: 10);
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Show dialog to create new post
  Future<void> _showCreateDialog() async {
    final result = await showDialog<Post>(
      context: context,
      builder: (context) => PostFormDialog(title: 'Create Post'),
    );

    if (result != null) {
      try {
        final createdPost = await _service.createPost(result);
        setState(() {
          _posts.insert(0, createdPost);
        });
        _showSnackBar('Post created!', Colors.green);
      } catch (e) {
        _showSnackBar('Error creating post: $e', Colors.red);
      }
    }
  }

  /// Show dialog to edit post
  Future<void> _showEditDialog(Post post) async {
    final result = await showDialog<Post>(
      context: context,
      builder: (context) => PostFormDialog(title: 'Edit Post', post: post),
    );

    if (result != null) {
      try {
        final updatedPost = await _service.updatePost(result);
        setState(() {
          final index = _posts.indexWhere((p) => p.id == updatedPost.id);
          if (index != -1) {
            _posts[index] = updatedPost;
          }
        });
        _showSnackBar('Post updated!', Colors.blue);
      } catch (e) {
        _showSnackBar('Error updating post: $e', Colors.red);
      }
    }
  }

  /// Delete post with confirmation
  Future<void> _deletePost(Post post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deletePost(post.id!);
        setState(() {
          _posts.removeWhere((p) => p.id == post.id);
        });
        _showSnackBar('Post deleted!', Colors.orange);
      } catch (e) {
        _showSnackBar('Error deleting post: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (CRUD Demo)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadPosts, child: const Text('Retry')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return PostCard(
            post: post,
            onEdit: () => _showEditDialog(post),
            onDelete: () => _deletePost(post),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// POST CARD WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text('${post.id}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// POST FORM DIALOG
// ═══════════════════════════════════════════════════════════════════════════

class PostFormDialog extends StatefulWidget {
  final String title;
  final Post? post;

  const PostFormDialog({super.key, required this.title, this.post});

  @override
  State<PostFormDialog> createState() => _PostFormDialogState();
}

class _PostFormDialogState extends State<PostFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: widget.post?.id,
        title: _titleController.text,
        body: _bodyController.text,
        userId: widget.post?.userId ?? 1,
      );
      Navigator.pop(context, post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// CRUD OPERATIONS:
// • CREATE → POST   → Status 201 → Returns created resource
// • READ   → GET    → Status 200 → Returns resource(s)
// • UPDATE → PUT    → Status 200 → Returns updated resource
// • DELETE → DELETE → Status 200/204 → May return empty
//
// PATTERNS USED:
// • Service class for API calls (separation of concerns)
// • Data model with fromJson/toJson (type safety)
// • Local state updates after API success (optimistic UI)
// • Confirmation dialogs for destructive actions
// • Pull-to-refresh for list reloading
//
// ═══════════════════════════════════════════════════════════════════════════
