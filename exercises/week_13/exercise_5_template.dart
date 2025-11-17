// Week 13, Exercise 5: Error Handling and Null Safety
// Difficulty: Advanced
//
// Task:
// Create a robust User model that handles:
// 1. Nullable fields (phone, avatar, bio can be null)
// 2. Missing fields (provide defaults)
// 3. Invalid data types (handle gracefully)
// 4. Malformed JSON (catch exceptions)
// 5. Validate email format
// 6. Validate age range (must be 13-120)
// 7. Create a parseUserSafely() function that returns null on error
//
// This represents production-level JSON parsing

import 'dart:convert';

void main() {
  // Test Case 1: Valid complete data
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

  // Test Case 2: Missing optional fields
  String partialJson = '''
  {
    "id": 2,
    "name": "Bob Smith",
    "email": "bob@example.com",
    "age": 30
  }
  ''';

  // Test Case 3: Invalid age
  String invalidAgeJson = '''
  {
    "id": 3,
    "name": "Charlie Brown",
    "email": "charlie@example.com",
    "age": 150
  }
  ''';

  // Test Case 4: Invalid email
  String invalidEmailJson = '''
  {
    "id": 4,
    "name": "Diana Prince",
    "email": "not-an-email",
    "age": 28
  }
  ''';

  // Test Case 5: Malformed JSON
  String malformedJson = '''
  {
    "id": 5,
    "name": "Eve",
    this is broken
  }
  ''';

  // TODO: Create User class with validation
  // TODO: Implement fromJson with error handling
  // TODO: Add email validation method
  // TODO: Add age validation method
  // TODO: Create parseUserSafely function
  // TODO: Test all cases and print results

  // Your code here:
}

// TODO: Create User class and helper functions here
