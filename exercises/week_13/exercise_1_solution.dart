// Week 13, Exercise 1: Basic JSON Parsing
// Difficulty: Beginner
// Solution

import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "name": "John Doe",
    "email": "john@example.com",
    "age": 28
  }
  ''';

  // Parse the JSON string
  Map<String, dynamic> user = jsonDecode(jsonString);

  // Extract values
  String name = user['name'];
  String email = user['email'];
  int age = user['age'];

  // Print formatted output
  print('User Information:');
  print('Name: $name');
  print('Email: $email');
  print('Age: $age years old');
}
