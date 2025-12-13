// Week 13, Exercise 4: Nested Models with Lists
// Difficulty: Intermediate-Advanced
// Solution

import 'dart:convert';

class Author {
  final int id;
  final String name;
  final String email;

  Author({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() => 'Author(id: $id, name: $name, email: $email)';
}

class Comment {
  final int id;
  final String author;
  final String text;
  final String timestamp;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'text': text,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() => 'Comment(id: $id, by: $author, text: "$text")';
}

class Post {
  final int id;
  final String title;
  final String content;
  final Author author;
  final List<Comment> comments;
  final int likes;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.comments,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Parse the comments list
    List<Comment> commentsList = (json['comments'] as List)
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();

    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      comments: commentsList,
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author.toJson(),
      'comments': comments.map((c) => c.toJson()).toList(),
      'likes': likes,
    };
  }

  // Helper method: Get comment count
  int get commentCount => comments.length;

  // Helper method: Get all commenters' names
  List<String> get commenterNames => comments.map((c) => c.author).toList();

  // Helper method: Get formatted summary
  String getSummary() {
    return '''
Post: $title
By: ${author.name}
Likes: $likes
Comments: $commentCount
''';
  }

  @override
  String toString() {
    return 'Post(id: $id, title: "$title", author: ${author.name}, comments: $commentCount, likes: $likes)';
  }
}

void main() {
  String jsonString = '''
  {
    "id": 101,
    "title": "Introduction to Flutter",
    "content": "Flutter is Google's UI toolkit...",
    "author": {
      "id": 1,
      "name": "Jane Smith",
      "email": "jane@example.com"
    },
    "comments": [
      {
        "id": 1,
        "author": "Bob Wilson",
        "text": "Great article!",
        "timestamp": "2024-01-15T10:30:00Z"
      },
      {
        "id": 2,
        "author": "Alice Brown",
        "text": "Very helpful, thanks!",
        "timestamp": "2024-01-15T11:45:00Z"
      },
      {
        "id": 3,
        "author": "Charlie Davis",
        "text": "Looking forward to more posts.",
        "timestamp": "2024-01-15T14:20:00Z"
      }
    ],
    "likes": 42
  }
  ''';

  // Parse JSON
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  Post post = Post.fromJson(jsonMap);

  // Display post information
  print('=' * 50);
  print(post.getSummary());
  print('=' * 50);

  print('\nPost Details:');
  print(post);

  print('\nAuthor:');
  print(post.author);

  print('\nComments:');
  for (var comment in post.comments) {
    print('  - ${comment.author}: "${comment.text}"');
  }

  print('\nAll Commenters: ${post.commenterNames.join(", ")}');

  // Convert back to JSON
  print('\n' + '=' * 50);
  print('Converting back to JSON...');
  String jsonOutput = jsonEncode(post.toJson());
  print(jsonOutput);
}
