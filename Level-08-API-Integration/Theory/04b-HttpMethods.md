# The http Package - Part 2: POST, PUT, DELETE

## The Big Idea In One Sentence

> To send data you `json.encode` your Map into the `body`, add a `Content-Type: application/json` header, and call `http.post`/`put`/`patch`/`delete`.

Learn how to create, update, and delete data using HTTP methods!

---

## Making a POST Request

### Think of it Like This

POST is like filling out a form and submitting it:

```
┌─────────────────────────────────────────────────────────────┐
│                    POST REQUEST                              │
├─────────────────────────────────────────────────────────────┤
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

### POST Example

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

---

## Making PUT Requests

### PUT = Replace Entire Resource

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

---

## Making PATCH Requests

### PATCH = Update Only Some Fields

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

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│             http PACKAGE - ALL HTTP METHODS                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GET - Fetch data:                                          │
│  await http.get(Uri.parse(url));                            │
│                                                             │
│  POST - Create data:                                        │
│  await http.post(                                           │
│    Uri.parse(url),                                          │
│    headers: {'Content-Type': 'application/json'},           │
│    body: json.encode(data),                                 │
│  );                                                         │
│                                                             │
│  PUT - Replace data:                                        │
│  await http.put(url, headers: {...}, body: json.encode(d)); │
│                                                             │
│  PATCH - Update partial:                                    │
│  await http.patch(url, headers: {...}, body: json.encode); │
│                                                             │
│  DELETE - Remove data:                                      │
│  await http.delete(Uri.parse(url));                         │
│                                                             │
│  REMEMBER:                                                  │
│  • Check response.statusCode                                │
│  • Use json.encode() for sending data                       │
│  • Use json.decode() for receiving data                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Perfect! Now you can perform all CRUD operations. Next, learn about headers and authentication!

---

## Quick Quiz

**Q1.** When sending data with POST, what two things do you add besides the URL?

<details>
<summary>Answer</summary>
A `headers` map with `'Content-Type': 'application/json'`, and a `body` set to `json.encode(yourData)`.
</details>

**Q2.** What status code says a POST successfully created something?

<details>
<summary>Answer</summary>
`201` (Created).
</details>

**Q3.** Which method removes a resource and usually needs no body?

<details>
<summary>Answer</summary>
`http.delete`.
</details>

---

## Assignment

### Problem 1: Send a POST

Write an `http.post` to `url` that sends `{'name': 'Sam'}` as JSON with the right header.

### Problem 2: Pick the check

After a POST to create a user, which status code do you check for success?

### Problem 3: Encode vs decode

In a POST, do you `json.encode` or `json.decode` the data you put in the `body`? Why?

---

## Assignment Answers

### Problem 1: Send a POST

```dart
final response = await http.post(
  url,
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'name': 'Sam'}),
);
```

### Problem 2: Pick the check

`201` (Created). (A successful GET/PUT/PATCH is usually `200`; a created resource is `201`.)

### Problem 3: Encode vs decode

You `json.encode` it. The body must be a JSON string going out to the server, so you encode your Dart Map into JSON. (You `json.decode` the response coming back.)

---

**Continue to:** [04c-HttpAdvanced.md](./04c-HttpAdvanced.md) - Master headers and authentication!

---

[← Previous: Http Setup](./04a-HttpSetup.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: Http Advanced](./04c-HttpAdvanced.md)

---

## Navigation

⬅️ **Previous:** [Http Setup](04a-HttpSetup.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Http Advanced](04c-HttpAdvanced.md)
