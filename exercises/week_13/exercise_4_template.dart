// Week 13, Exercise 4: Nested Models with Lists
// Difficulty: Intermediate-Advanced
//
// Task:
// Create a blog post system with:
// 1. Author model (id, name, email)
// 2. Comment model (id, author, text, timestamp)
// 3. Post model (id, title, content, author, comments list, likes)
// 4. Parse the nested JSON
// 5. Implement methods to:
//    - Get comment count
//    - Get all commenters' names
//    - Convert entire structure back to JSON
//
// This simulates a real-world API response

import 'dart:convert';

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

  // TODO: Create Author class
  // TODO: Create Comment class
  // TODO: Create Post class with nested models
  // TODO: Implement fromJson() for all classes
  // TODO: Implement toJson() for all classes
  // TODO: Add helper methods to Post class
  // TODO: Parse and display the post with comments

  // Your code here:
}

// TODO: Create classes here
