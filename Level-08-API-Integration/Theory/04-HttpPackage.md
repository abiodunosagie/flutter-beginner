# The http Package

Learn how to make real API calls in Flutter with the http package!

---

## What is the http Package?

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│              THE http PACKAGE = YOUR MESSENGER               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Imagine you want to order pizza:                           │
│                                                             │
│  WITHOUT http package:                                      │
│  You → Walk to pizza shop → Wait → Walk back with pizza     │
│  (Manual, complicated, time-consuming!)                     │
│                                                             │
│  WITH http package:                                         │
│  You → Call pizza shop → They deliver to you                │
│  (Easy, the package handles all the hard work!)             │
│                                                             │
│  ┌─────────────┐    http.get()    ┌─────────────┐          │
│  │ Your App    │ ───────────────→ │   API       │          │
│  │             │ ←─────────────── │   Server    │          │
│  └─────────────┘    Response      └─────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Setup

### Step 1: Add to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0  # Add this line
```

### Step 2: Run flutter pub get

```bash
flutter pub get
```

### Step 3: Import in your Dart file

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';  // For JSON parsing
```

### Why `as http`?

```
┌─────────────────────────────────────────────────────────────┐
│                    WHY "as http"?                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  import 'package:http/http.dart' as http;                   │
│                                         ↑                   │
│                                    This is a prefix         │
│                                                             │
│  Now you use:                                               │
│  • http.get()     instead of just get()                     │
│  • http.post()    instead of just post()                    │
│  • http.Response  instead of just Response                  │
│                                                             │
│  WHY? It avoids conflicts with other functions named        │
│  "get" or "post" in your code or other packages!            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Making a GET Request

### Basic GET Request

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchUsers() async {
  // 1. Create the URL
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  // 2. Make the request
  final response = await http.get(url);

  // 3. Check if successful
  if (response.statusCode == 200) {
    // 4. Parse the JSON
    final List<dynamic> users = json.decode(response.body);

    // 5. Use the data
    for (var user in users) {
      print('Name: ${user['name']}');
    }
  } else {
    print('Failed to load users: ${response.statusCode}');
  }
}
```

### Visual: GET Request Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    GET REQUEST FLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  YOUR CODE                                                  │
│      │                                                      │
│      │ 1. http.get(url)                                     │
│      ▼                                                      │
│  ┌─────────────────────┐                                    │
│  │   Request sent      │ ──────────────────────────→        │
│  │   to server         │                            │       │
│  └─────────────────────┘                            │       │
│                                                     │       │
│                                                     ▼       │
│                                             ┌──────────────┐│
│                                             │    SERVER    ││
│                                             │ Processes    ││
│                                             │  request     ││
│                                             └──────────────┘│
│                                                     │       │
│  ┌─────────────────────┐                            │       │
│  │   Response received │ ←──────────────────────────        │
│  │   (statusCode,body) │                                    │
│  └─────────────────────┘                                    │
│      │                                                      │
│      │ 2. Check statusCode == 200                           │
│      │ 3. json.decode(response.body)                        │
│      ▼                                                      │
│  YOUR DATA IS READY!                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Understanding the Response

```dart
Future<void> explainResponse() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
  final response = await http.get(url);

  // The response object contains:
  print('Status Code: ${response.statusCode}');  // 200, 404, 500, etc.
  print('Headers: ${response.headers}');          // Server metadata
  print('Body: ${response.body}');                // The actual data (String)
  print('Body bytes: ${response.bodyBytes}');     // Raw bytes

  // Body is a STRING - you need to parse it!
  final data = json.decode(response.body);  // Now it's a Map
}
```

### Visual: Response Anatomy

```
┌─────────────────────────────────────────────────────────────┐
│                    RESPONSE ANATOMY                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  http.Response                                              │
│  ├── statusCode: int     (200 = OK, 404 = Not Found, etc.) │
│  ├── headers: Map        (Content-Type, Date, etc.)        │
│  ├── body: String        (The JSON data as text)           │
│  └── bodyBytes: Uint8List (Raw binary data)                │
│                                                             │
│  EXAMPLE:                                                   │
│  ┌─────────────────────────────────────────────────┐       │
│  │ statusCode: 200                                  │       │
│  │ headers: {'content-type': 'application/json'}   │       │
│  │ body: '{"id":1,"name":"John"}'                   │       │
│  └─────────────────────────────────────────────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## GET with Query Parameters

```dart
// Instead of building URL string manually:
// https://api.example.com/users?page=1&limit=10

Future<void> fetchUsersWithParams() async {
  // Build URL with query parameters (cleaner!)
  final url = Uri.https(
    'jsonplaceholder.typicode.com',  // host
    '/posts',                         // path
    {                                 // query parameters
      'userId': '1',
      '_limit': '5',
    },
  );

  // URL becomes: https://jsonplaceholder.typicode.com/posts?userId=1&_limit=5

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final posts = json.decode(response.body);
    print('Got ${posts.length} posts');
  }
}
```

### Visual: Building URLs

```
┌─────────────────────────────────────────────────────────────┐
│                    BUILDING URLs                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Uri.https('host', '/path', {'key': 'value'})               │
│                                                             │
│  EXAMPLE:                                                   │
│  Uri.https(                                                 │
│    'api.example.com',     ← Host                            │
│    '/users',              ← Path                            │
│    {                      ← Query params                    │
│      'page': '1',                                           │
│      'limit': '10',                                         │
│      'sort': 'name'                                         │
│    }                                                        │
│  )                                                          │
│                                                             │
│  RESULT:                                                    │
│  https://api.example.com/users?page=1&limit=10&sort=name    │
│                                                             │
│  NOTE: Query param values must be Strings!                  │
│        Use '1' not 1                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Making a POST Request

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createUser() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  // Data to send
  final userData = {
    'name': 'John Doe',
    'email': 'john@example.com',
    'username': 'johndoe',
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',  // Tell server we're sending JSON
    },
    body: json.encode(userData),  // Convert Map to JSON string
  );

  if (response.statusCode == 201) {  // 201 = Created
    final newUser = json.decode(response.body);
    print('Created user with ID: ${newUser['id']}');
  } else {
    print('Failed to create user: ${response.statusCode}');
  }
}
```

### Visual: POST Request

```
┌─────────────────────────────────────────────────────────────┐
│                    POST REQUEST                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  http.post(                                                 │
│    url,                                                     │
│    headers: {...},   ← Tell server what we're sending       │
│    body: '...',      ← The data to create                   │
│  )                                                          │
│                                                             │
│  YOUR APP                           SERVER                  │
│  ┌─────────┐                       ┌─────────┐             │
│  │ POST    │  {name: "John"...}    │         │             │
│  │ /users  │ ────────────────────→ │ Creates │             │
│  │         │                       │  user   │             │
│  │         │ ←──────────────────── │         │             │
│  └─────────┘  {id: 11, name:...}   └─────────┘             │
│                                                             │
│  You send: The data to create                               │
│  You get:  The created data (with new ID!)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Making PUT and PATCH Requests

### PUT (Replace entire resource)

```dart
Future<void> updateUser(int userId) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users/$userId');

  final updatedData = {
    'name': 'John Updated',
    'email': 'john.updated@example.com',
    'username': 'johnupdated',
  };

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedData),
  );

  if (response.statusCode == 200) {
    print('User updated successfully');
  }
}
```

### PATCH (Update only some fields)

```dart
Future<void> patchUser(int userId) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users/$userId');

  // Only send the fields you want to update
  final partialUpdate = {
    'email': 'newemail@example.com',  // Only updating email
  };

  final response = await http.patch(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(partialUpdate),
  );

  if (response.statusCode == 200) {
    print('Email updated successfully');
  }
}
```

---

## Making DELETE Requests

```dart
Future<void> deleteUser(int userId) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users/$userId');

  final response = await http.delete(url);

  if (response.statusCode == 200 || response.statusCode == 204) {
    print('User deleted successfully');
  } else {
    print('Failed to delete: ${response.statusCode}');
  }
}
```

---

## Adding Headers

```dart
Future<void> fetchWithHeaders() async {
  final url = Uri.parse('https://api.example.com/protected');

  final response = await http.get(
    url,
    headers: {
      // Authentication
      'Authorization': 'Bearer your-token-here',

      // Content negotiation
      'Accept': 'application/json',

      // Custom headers
      'X-Custom-Header': 'custom-value',

      // API keys (some APIs use this)
      'X-API-Key': 'your-api-key',
    },
  );

  // Process response...
}
```

### Visual: Headers

```
┌─────────────────────────────────────────────────────────────┐
│                    COMMON HEADERS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HEADER              │ PURPOSE                              │
│  ────────────────────────────────────────────────────────── │
│  Content-Type        │ What format you're SENDING           │
│    application/json  │                                      │
│                                                             │
│  Accept              │ What format you WANT back            │
│    application/json  │                                      │
│                                                             │
│  Authorization       │ Prove who you are                    │
│    Bearer <token>    │                                      │
│                                                             │
│  X-API-Key           │ API authentication key               │
│    <your-key>        │                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete CRUD Service Example

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET all users
  Future<List<dynamic>> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load users');
  }

  // GET single user
  Future<Map<String, dynamic>> getUser(int id) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load user');
  }

  // POST create user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to create user');
  }

  // PUT update user
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to update user');
  }

  // DELETE user
  Future<void> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}

// Usage:
void main() async {
  final service = UserService();

  // Get all users
  final users = await service.getUsers();
  print('Got ${users.length} users');

  // Create a user
  final newUser = await service.createUser({
    'name': 'New User',
    'email': 'new@example.com',
  });
  print('Created: ${newUser['id']}');

  // Update a user
  final updated = await service.updateUser(1, {
    'name': 'Updated Name',
  });

  // Delete a user
  await service.deleteUser(1);
}
```

---

## Using http in Flutter Widgets

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load users';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text(user['email']),
        );
      },
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                http PACKAGE CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SETUP:                                                     │
│  dependencies:                                              │
│    http: ^1.2.0                                             │
│                                                             │
│  IMPORT:                                                    │
│  import 'package:http/http.dart' as http;                   │
│  import 'dart:convert';                                     │
│                                                             │
│  GET:                                                       │
│  final response = await http.get(Uri.parse(url));           │
│                                                             │
│  POST:                                                      │
│  final response = await http.post(                          │
│    Uri.parse(url),                                          │
│    headers: {'Content-Type': 'application/json'},           │
│    body: json.encode(data),                                 │
│  );                                                         │
│                                                             │
│  PUT/PATCH/DELETE:                                          │
│  Same pattern as POST                                       │
│                                                             │
│  CHECK STATUS:                                              │
│  if (response.statusCode == 200) { ... }                    │
│                                                             │
│  PARSE BODY:                                                │
│  final data = json.decode(response.body);                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← JSON Basics](./03-JSONBasics.md) | [Next: Dio Package →](./05-DioPackage.md)
