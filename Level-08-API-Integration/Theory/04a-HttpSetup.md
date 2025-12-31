# The http Package - Part 1: Setup and GET Requests

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
│                http PACKAGE - GET REQUESTS                   │
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
│  BASIC GET:                                                 │
│  final response = await http.get(Uri.parse(url));           │
│  if (response.statusCode == 200) {                          │
│    final data = json.decode(response.body);                 │
│  }                                                          │
│                                                             │
│  WITH QUERY PARAMS:                                         │
│  final url = Uri.https('api.com', '/path', {'key': 'val'}); │
│                                                             │
│  RESPONSE PARTS:                                            │
│  • response.statusCode  → HTTP status (200, 404, etc.)      │
│  • response.body        → JSON string                       │
│  • response.headers     → Metadata                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Great! Now you can fetch data from APIs. Next, you'll learn how to send data using POST and other HTTP methods.

---

**Continue to:** [04b-HttpMethods.md](./04b-HttpMethods.md) - Learn POST, PUT, and DELETE requests!

---

[← Previous: Nested JSON](./03c-NestedJSON.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: HTTP Methods](./04b-HttpMethods.md)

---

## Navigation

⬅️ **Previous:** [Nested JSON](03c-NestedJSON.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Http Methods](04b-HttpMethods.md)
