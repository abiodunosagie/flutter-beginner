/// Example 01: Simple GET Request
///
/// This example demonstrates the most basic API call - fetching data with GET.
/// We'll fetch users from JSONPlaceholder, a free fake API for testing.
///
/// Run this file: dart run Example01-SimpleGET.dart

import 'dart:convert';
import 'dart:io';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Making a basic GET request
// 2. Parsing JSON response
// 3. Handling success and error cases
// 4. Using async/await
//
// ═══════════════════════════════════════════════════════════════════════════

/// Fetches all users from the API
///
/// Visual representation:
/// ```
/// ┌─────────────┐     GET /users      ┌─────────────┐
/// │  Our App    │ ─────────────────→  │   Server    │
/// │             │                     │             │
/// │             │ ←───────────────── │             │
/// └─────────────┘   [User1, User2]    └─────────────┘
/// ```
Future<List<dynamic>> fetchUsers() async {
  // Create an HTTP client
  final client = HttpClient();

  try {
    // 1. Create the request
    final request = await client.getUrl(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    // 2. Send the request and get response
    final response = await request.close();

    // 3. Check if successful (status code 200)
    if (response.statusCode == 200) {
      // 4. Read the response body
      final responseBody = await response.transform(utf8.decoder).join();

      // 5. Parse JSON string to Dart List
      final List<dynamic> users = json.decode(responseBody);

      return users;
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}

/// Fetches a single user by ID
Future<Map<String, dynamic>> fetchUser(int id) async {
  final client = HttpClient();

  try {
    final request = await client.getUrl(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );

    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}

/// Main function to demonstrate the API calls
void main() async {
  print('═' * 60);
  print('EXAMPLE 01: Simple GET Request');
  print('═' * 60);
  print('');

  // ─────────────────────────────────────────────────────────────
  // Example 1: Fetch all users
  // ─────────────────────────────────────────────────────────────
  print('📡 Fetching all users...');
  print('');

  try {
    final users = await fetchUsers();

    print('✅ Successfully fetched ${users.length} users:');
    print('');

    // Print first 3 users
    for (var i = 0; i < 3 && i < users.length; i++) {
      final user = users[i];
      print('  User ${i + 1}:');
      print('    Name: ${user['name']}');
      print('    Email: ${user['email']}');
      print('    City: ${user['address']['city']}');
      print('');
    }

    print('  ... and ${users.length - 3} more users');
  } catch (e) {
    print('❌ Error: $e');
  }

  print('');
  print('─' * 60);
  print('');

  // ─────────────────────────────────────────────────────────────
  // Example 2: Fetch single user
  // ─────────────────────────────────────────────────────────────
  print('📡 Fetching user #1...');
  print('');

  try {
    final user = await fetchUser(1);

    print('✅ User details:');
    print('');
    print('  ID: ${user['id']}');
    print('  Name: ${user['name']}');
    print('  Username: ${user['username']}');
    print('  Email: ${user['email']}');
    print('  Phone: ${user['phone']}');
    print('  Website: ${user['website']}');
    print('');
    print('  Address:');
    print('    Street: ${user['address']['street']}');
    print('    City: ${user['address']['city']}');
    print('    Zipcode: ${user['address']['zipcode']}');
    print('');
    print('  Company:');
    print('    Name: ${user['company']['name']}');
  } catch (e) {
    print('❌ Error: $e');
  }

  print('');
  print('─' * 60);
  print('');

  // ─────────────────────────────────────────────────────────────
  // Example 3: Handle not found error
  // ─────────────────────────────────────────────────────────────
  print('📡 Fetching user #999 (doesn\'t exist)...');
  print('');

  try {
    final user = await fetchUser(999);
    print('User: ${user['name']}');
  } catch (e) {
    print('⚠️ Expected error: $e');
  }

  print('');
  print('═' * 60);
  print('END OF EXAMPLE');
  print('═' * 60);
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Use async/await for API calls (they take time!)
//
// 2. Always check the status code:
//    - 200 = Success
//    - 404 = Not Found
//    - 500 = Server Error
//
// 3. Parse JSON with json.decode():
//    - String → Map/List
//
// 4. Handle errors with try/catch:
//    - Network errors
//    - Invalid data
//    - Server errors
//
// 5. Access nested JSON data with chained brackets:
//    user['address']['city']
//
// ═══════════════════════════════════════════════════════════════════════════
