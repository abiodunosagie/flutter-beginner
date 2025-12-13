# HTTP Methods

Learn the different ways to interact with APIs: GET, POST, PUT, DELETE, and more!

---

## The Big Picture

### Think of it Like This

HTTP methods are like different ACTIONS you can take:

```
┌─────────────────────────────────────────────────────────────┐
│               HTTP METHODS = ACTIONS                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Library Analogy:                                           │
│  ─────────────────                                          │
│  GET    = "Show me book #5"       (Read)                    │
│  POST   = "Add this new book"     (Create)                  │
│  PUT    = "Replace book #5"       (Update all)              │
│  PATCH  = "Fix typo in book #5"   (Update part)             │
│  DELETE = "Remove book #5"        (Delete)                  │
│                                                             │
│  Database Analogy:                                          │
│  ─────────────────                                          │
│  GET    = SELECT                                            │
│  POST   = INSERT                                            │
│  PUT    = UPDATE (full)                                     │
│  PATCH  = UPDATE (partial)                                  │
│  DELETE = DELETE                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## GET - Retrieve Data

### Purpose
Get/read data from the server. **Does NOT modify anything.**

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                         GET                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📱 App                            🖥️ Server                │
│    │                                  │                     │
│    │  GET /users                      │                     │
│    │ ─────────────────────────────────>                     │
│    │  "Give me all users"             │                     │
│    │                                  │                     │
│    │          [User 1, User 2, ...]   │                     │
│    │ <─────────────────────────────────                     │
│    │                                  │                     │
│                                                             │
│  GET /users/5                                               │
│  "Give me user #5 specifically"                             │
│                                                             │
│  GET /users?role=admin                                      │
│  "Give me users that are admins"                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### In Dart

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Get all users
Future<List<dynamic>> getAllUsers() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load users');
  }
}

// Get one user
Future<Map<String, dynamic>> getUser(int id) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users/$id'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user');
  }
}

// Get with query parameters
Future<List<dynamic>> getAdminUsers() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users?role=admin&active=true'),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load admin users');
  }
}
```

### Key Points
- No request body (data goes in URL/query params)
- Safe operation (doesn't change anything)
- Can be cached
- Can be bookmarked

---

## POST - Create Data

### Purpose
Create NEW data on the server.

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                        POST                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📱 App                            🖥️ Server                │
│    │                                  │                     │
│    │  POST /users                     │                     │
│    │  {name: "John", email: "..."}    │                     │
│    │ ─────────────────────────────────>                     │
│    │  "Create this new user"          │                     │
│    │                                  │                     │
│    │    {id: 5, name: "John", ...}    │                     │
│    │ <─────────────────────────────────                     │
│    │    "Here's the created user      │                     │
│    │     with new ID!"                │                     │
│                                                             │
│  Status Code: 201 Created                                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### In Dart

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> createUser(String name, String email) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/users'),
    headers: {
      'Content-Type': 'application/json',  // Tell server we're sending JSON
    },
    body: json.encode({
      'name': name,
      'email': email,
    }),
  );

  if (response.statusCode == 201) {  // 201 = Created
    return json.decode(response.body);
  } else {
    throw Exception('Failed to create user');
  }
}

// Usage
final newUser = await createUser('John Doe', 'john@example.com');
print('Created user with ID: ${newUser['id']}');
```

### Key Points
- Has request body (the data to create)
- NOT safe (changes server state)
- Creates NEW resource
- Returns the created resource (usually with new ID)

---

## PUT - Replace Data

### Purpose
Replace/update an ENTIRE resource.

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                         PUT                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BEFORE: User #5 = {name: "John", email: "j@x.com", age: 25}│
│                                                             │
│  📱 App                            🖥️ Server                │
│    │                                  │                     │
│    │  PUT /users/5                    │                     │
│    │  {name: "John Updated",          │                     │
│    │   email: "john.new@x.com"}       │                     │
│    │ ─────────────────────────────────>                     │
│    │  "Replace user #5 with this"     │                     │
│    │                                  │                     │
│    │    {id: 5, name: "John Updated", │                     │
│    │     email: "john.new@x.com"}     │                     │
│    │ <─────────────────────────────────                     │
│                                                             │
│  AFTER: User #5 = {name: "John Updated", email: "john.new"} │
│                                                             │
│  ⚠️ Notice: age field is GONE! PUT replaces everything!    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### In Dart

```dart
Future<Map<String, dynamic>> updateUser(int id, String name, String email) async {
  final response = await http.put(
    Uri.parse('https://api.example.com/users/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'name': name,
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to update user');
  }
}
```

### Key Points
- Has request body (the new data)
- Replaces ENTIRE resource
- If you omit a field, it may be removed!
- Use PUT when you want to replace everything

---

## PATCH - Partial Update

### Purpose
Update ONLY specific fields, leave others unchanged.

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                        PATCH                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BEFORE: User #5 = {name: "John", email: "j@x.com", age: 25}│
│                                                             │
│  📱 App                            🖥️ Server                │
│    │                                  │                     │
│    │  PATCH /users/5                  │                     │
│    │  {email: "john.new@x.com"}       │                     │
│    │ ─────────────────────────────────>                     │
│    │  "Just update the email"         │                     │
│    │                                  │                     │
│    │    {id: 5, name: "John",         │                     │
│    │     email: "john.new@x.com",     │                     │
│    │     age: 25}                     │                     │
│    │ <─────────────────────────────────                     │
│                                                             │
│  AFTER: User #5 = {name: "John", email: "john.new", age: 25}│
│                                                             │
│  ✅ Other fields (name, age) are preserved!                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### In Dart

```dart
Future<Map<String, dynamic>> patchUser(int id, Map<String, dynamic> updates) async {
  final response = await http.patch(
    Uri.parse('https://api.example.com/users/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(updates),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to patch user');
  }
}

// Only update email
await patchUser(5, {'email': 'new.email@example.com'});

// Only update age
await patchUser(5, {'age': 26});
```

### Key Points
- Has request body (only fields to update)
- Updates ONLY specified fields
- Other fields remain unchanged
- Use PATCH for partial updates

---

## DELETE - Remove Data

### Purpose
Remove/delete a resource from the server.

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                       DELETE                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📱 App                            🖥️ Server                │
│    │                                  │                     │
│    │  DELETE /users/5                 │                     │
│    │ ─────────────────────────────────>                     │
│    │  "Delete user #5"                │                     │
│    │                                  │                     │
│    │         204 No Content           │                     │
│    │ <─────────────────────────────────                     │
│    │         (Success, nothing        │                     │
│    │          to return)              │                     │
│                                                             │
│  Status Code: 204 No Content (or sometimes 200)             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### In Dart

```dart
Future<void> deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse('https://api.example.com/users/$id'),
  );

  if (response.statusCode == 204 || response.statusCode == 200) {
    print('User deleted successfully');
  } else {
    throw Exception('Failed to delete user');
  }
}
```

### Key Points
- Usually no request body
- Returns 204 No Content (success, nothing to return)
- Or returns 200 with deleted resource
- Permanent action!

---

## PUT vs PATCH - The Difference

```
┌─────────────────────────────────────────────────────────────┐
│                   PUT vs PATCH                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ORIGINAL DATA:                                             │
│  {                                                          │
│    "id": 1,                                                 │
│    "name": "John",                                          │
│    "email": "john@test.com",                                │
│    "age": 25,                                               │
│    "city": "NYC"                                            │
│  }                                                          │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  PUT /users/1                        PATCH /users/1         │
│  { "name": "John Updated" }          { "name": "J Updated" }│
│                                                             │
│  RESULT:                             RESULT:                │
│  {                                   {                      │
│    "id": 1,                            "id": 1,             │
│    "name": "John Updated"              "name": "J Updated", │
│  }                                     "email": "j@t.com",  │
│                                        "age": 25,           │
│  ⚠️ email, age, city GONE!            "city": "NYC"        │
│                                      }                      │
│                                      ✅ Other fields kept!  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete CRUD Example

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApi {
  static const baseUrl = 'https://api.example.com';

  // CREATE (POST)
  static Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to create user');
  }

  // READ (GET)
  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load users');
  }

  static Future<Map<String, dynamic>> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load user');
  }

  // UPDATE (PUT - full) or (PATCH - partial)
  static Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to update user');
  }

  static Future<Map<String, dynamic>> patchUser(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to patch user');
  }

  // DELETE
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               HTTP METHODS CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  METHOD  │ ACTION      │ BODY  │ SAFE  │ STATUS            │
│  ────────────────────────────────────────────────────────  │
│  GET     │ Read        │ No    │ Yes   │ 200 OK            │
│  POST    │ Create      │ Yes   │ No    │ 201 Created       │
│  PUT     │ Replace All │ Yes   │ No    │ 200 OK            │
│  PATCH   │ Update Part │ Yes   │ No    │ 200 OK            │
│  DELETE  │ Remove      │ No    │ No    │ 204 No Content    │
│                                                             │
│  SAFE = Doesn't change data                                 │
│  BODY = Sends data in request body                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← What is an API](./01-WhatIsAnAPI.md) | [Next: JSON Basics →](./03-JSONBasics.md)
