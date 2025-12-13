// Week 13, Exercise 5: Error Handling and Null Safety
// Difficulty: Advanced
// Solution

import 'dart:convert';

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class User {
  final int id;
  final String name;
  final String email;
  final int age;
  final String? phone;
  final String? avatar;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.phone,
    this.avatar,
    this.bio,
  }) {
    // Validate on construction
    if (!_isValidEmail(email)) {
      throw ValidationException('Invalid email format: $email');
    }
    if (!_isValidAge(age)) {
      throw ValidationException('Age must be between 13 and 120, got: $age');
    }
  }

  // Email validation
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Age validation
  static bool _isValidAge(int age) {
    return age >= 13 && age <= 120;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Validate required fields exist
    if (!json.containsKey('id')) {
      throw ValidationException('Missing required field: id');
    }
    if (!json.containsKey('name')) {
      throw ValidationException('Missing required field: name');
    }
    if (!json.containsKey('email')) {
      throw ValidationException('Missing required field: email');
    }
    if (!json.containsKey('age')) {
      throw ValidationException('Missing required field: age');
    }

    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (bio != null) 'bio': bio,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, age: $age, '
        'phone: ${phone ?? "N/A"}, avatar: ${avatar != null ? "Yes" : "No"}, '
        'bio: ${bio != null ? "Yes" : "No"})';
  }
}

// Safe parsing function that returns null on error
User? parseUserSafely(String jsonString) {
  try {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return User.fromJson(json);
  } on FormatException catch (e) {
    print('JSON Parse Error: ${e.message}');
    return null;
  } on ValidationException catch (e) {
    print('Validation Error: ${e.message}');
    return null;
  } on TypeError catch (e) {
    print('Type Error: ${e}');
    return null;
  } catch (e) {
    print('Unknown Error: ${e}');
    return null;
  }
}

void main() {
  print('Testing User Model with Error Handling\n');
  print('=' * 60);

  // Test Case 1: Valid complete data
  print('\nTest 1: Valid Complete Data');
  print('-' * 60);
  String validJson = '''
  {
    "id": 1,
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "age": 25,
    "phone": "+1234567890",
    "avatar": "https://example.com/avatar.jpg",
    "bio": "Software developer"
  }
  ''';
  User? user1 = parseUserSafely(validJson);
  if (user1 != null) {
    print('SUCCESS: $user1');
  } else {
    print('FAILED to parse');
  }

  // Test Case 2: Missing optional fields
  print('\nTest 2: Missing Optional Fields');
  print('-' * 60);
  String partialJson = '''
  {
    "id": 2,
    "name": "Bob Smith",
    "email": "bob@example.com",
    "age": 30
  }
  ''';
  User? user2 = parseUserSafely(partialJson);
  if (user2 != null) {
    print('SUCCESS: $user2');
  } else {
    print('FAILED to parse');
  }

  // Test Case 3: Invalid age
  print('\nTest 3: Invalid Age (150)');
  print('-' * 60);
  String invalidAgeJson = '''
  {
    "id": 3,
    "name": "Charlie Brown",
    "email": "charlie@example.com",
    "age": 150
  }
  ''';
  User? user3 = parseUserSafely(invalidAgeJson);
  if (user3 != null) {
    print('SUCCESS: $user3');
  } else {
    print('FAILED to parse (as expected)');
  }

  // Test Case 4: Invalid email
  print('\nTest 4: Invalid Email Format');
  print('-' * 60);
  String invalidEmailJson = '''
  {
    "id": 4,
    "name": "Diana Prince",
    "email": "not-an-email",
    "age": 28
  }
  ''';
  User? user4 = parseUserSafely(invalidEmailJson);
  if (user4 != null) {
    print('SUCCESS: $user4');
  } else {
    print('FAILED to parse (as expected)');
  }

  // Test Case 5: Malformed JSON
  print('\nTest 5: Malformed JSON');
  print('-' * 60);
  String malformedJson = '''
  {
    "id": 5,
    "name": "Eve",
    this is broken
  }
  ''';
  User? user5 = parseUserSafely(malformedJson);
  if (user5 != null) {
    print('SUCCESS: $user5');
  } else {
    print('FAILED to parse (as expected)');
  }

  // Test Case 6: Missing required field
  print('\nTest 6: Missing Required Field (email)');
  print('-' * 60);
  String missingFieldJson = '''
  {
    "id": 6,
    "name": "Frank",
    "age": 25
  }
  ''';
  User? user6 = parseUserSafely(missingFieldJson);
  if (user6 != null) {
    print('SUCCESS: $user6');
  } else {
    print('FAILED to parse (as expected)');
  }

  print('\n' + '=' * 60);
  print('Testing Complete!');
  print('Summary: Valid users should parse, invalid should fail gracefully.');
}
