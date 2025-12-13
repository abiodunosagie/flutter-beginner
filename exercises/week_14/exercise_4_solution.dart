// Week 14, Exercise 4: Full CRUD Operations
// Difficulty: Intermediate-Advanced
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'userId': userId,
      'title': title,
      'body': body,
    };

    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, title: "$title")';
  }
}

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // CREATE - POST
  Future<Post?> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        print('Create failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Create error: $e');
      return null;
    }
  }

  // READ - GET all
  Future<List<Post>> getAllPosts({int? limit}) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();

        if (limit != null && limit < posts.length) {
          return posts.sublist(0, limit);
        }
        return posts;
      } else {
        print('Get all failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get all error: $e');
      return [];
    }
  }

  // READ - GET by ID
  Future<Post?> getPostById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        print('Get by ID failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get by ID error: $e');
      return null;
    }
  }

  // UPDATE - PUT
  Future<Post?> updatePost(Post post) async {
    if (post.id == null) {
      print('Update failed: Post must have an ID');
      return null;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        print('Update failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Update error: $e');
      return null;
    }
  }

  // DELETE - DELETE
  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Delete failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}

void main() async {
  final service = PostService();

  print('Testing Full CRUD Operations');
  print('=' * 70);

  // CREATE
  print('\n1. CREATE - Creating a new post...');
  print('-' * 70);
  Post newPost = Post(
    userId: 1,
    title: 'My Test Post',
    body: 'This is a test post created via HTTP POST request.',
  );
  print('Creating: $newPost');

  Post? createdPost = await service.createPost(newPost);
  if (createdPost != null) {
    print('✓ Created successfully: $createdPost');
  } else {
    print('✗ Failed to create post');
  }

  // READ - Get by ID
  print('\n2. READ - Fetching post by ID...');
  print('-' * 70);
  Post? fetchedPost = await service.getPostById(1);
  if (fetchedPost != null) {
    print('✓ Fetched: $fetchedPost');
    print('  Body: ${fetchedPost.body.substring(0, 50)}...');
  } else {
    print('✗ Failed to fetch post');
  }

  // READ - Get all (limited)
  print('\n3. READ - Fetching first 5 posts...');
  print('-' * 70);
  List<Post> posts = await service.getAllPosts(limit: 5);
  print('✓ Fetched ${posts.length} posts:');
  for (var post in posts) {
    print('  - ${post.id}: ${post.title}');
  }

  // UPDATE
  print('\n4. UPDATE - Updating a post...');
  print('-' * 70);
  Post updatedPost = Post(
    id: 1,
    userId: 1,
    title: 'Updated Title',
    body: 'This post has been updated via HTTP PUT request.',
  );
  print('Updating to: $updatedPost');

  Post? result = await service.updatePost(updatedPost);
  if (result != null) {
    print('✓ Updated successfully: $result');
  } else {
    print('✗ Failed to update post');
  }

  // DELETE
  print('\n5. DELETE - Deleting a post...');
  print('-' * 70);
  bool deleted = await service.deletePost(1);
  if (deleted) {
    print('✓ Post 1 deleted successfully');
  } else {
    print('✗ Failed to delete post');
  }

  print('\n' + '=' * 70);
  print('CRUD Operations Test Complete!');
}
