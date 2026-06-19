# Model Basics

## The Big Idea In One Sentence

> A model is a Dart class for your data with a `fromJson` (build the object from a Map) and a `toJson` (turn it back into a Map), so you get safe `user.name` instead of risky `user['name']`.

Learn how to create type-safe Dart classes from JSON data!

> **You already know this.** You learned classes and constructors in Level 4, and JSON in this level (03a-03c). A model just combines them. `fromJson` is a factory constructor that reads the Map you got from `json.decode`.

---

## Why Data Models?

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│                WHY USE DATA MODELS?                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WITHOUT Data Models (using Map):                           │
│  ────────────────────────────────                           │
│  Map<String, dynamic> user = json.decode(response);         │
│  String name = user['name'];       // Could be null!        │
│  String name = user['neme'];       // Typo - no error! 😱   │
│  int age = user['age'];            // What if it's String?  │
│                                                             │
│  Problems:                                                  │
│  ✗ No autocomplete                                          │
│  ✗ Typos not caught                                         │
│  ✗ Type errors at runtime                                   │
│  ✗ No documentation                                         │
│                                                             │
│  WITH Data Models (using Class):                            │
│  ───────────────────────────────                            │
│  User user = User.fromJson(json.decode(response));          │
│  String name = user.name;          // Always String!        │
│  String name = user.neme;          // Compile ERROR! ✓      │
│  int age = user.age;               // Type guaranteed!      │
│                                                             │
│  Benefits:                                                  │
│  ✓ Full autocomplete                                        │
│  ✓ Compile-time type checking                               │
│  ✓ Self-documenting code                                    │
│  ✓ IDE support                                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Data Model

### From JSON to Class

```dart
// JSON from API:
// {
//   "id": 1,
//   "name": "John Doe",
//   "email": "john@example.com"
// }

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert JSON Map to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert User object to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

### Visual: JSON to Model Flow

```
┌─────────────────────────────────────────────────────────────┐
│                JSON ↔ MODEL CONVERSION                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JSON String                     Dart Object                │
│  ───────────                     ───────────                │
│  '{"id": 1,                      User(                      │
│    "name": "John",       ────→     id: 1,                   │
│    "email": "j@x.com"}'            name: "John",            │
│                         fromJson   email: "j@x.com",        │
│                                  )                          │
│                                                             │
│  User(                                                      │
│    id: 1,                        '{"id": 1,                 │
│    name: "John",         ────→     "name": "John",          │
│    email: "j@x.com",     toJson    "email": "j@x.com"}'     │
│  )                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Understanding fromJson Factory Constructor

### What is a Factory Constructor?

```
┌─────────────────────────────────────────────────────────────┐
│              FACTORY CONSTRUCTOR EXPLAINED                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Regular Constructor:                                       │
│  User({required this.id, required this.name})               │
│  → Creates new instance directly                            │
│                                                             │
│  Factory Constructor:                                       │
│  factory User.fromJson(Map<String, dynamic> json) {...}     │
│  → Can run custom logic before creating instance            │
│  → Can return cached instances                              │
│  → Perfect for parsing!                                     │
│                                                             │
│  WHY FACTORY?                                               │
│  • Parse JSON fields before creating object                 │
│  • Handle null values                                       │
│  • Validate data                                            │
│  • Create objects from different sources                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Step-by-Step: Creating fromJson

```dart
// Step 1: Start with JSON
// {
//   "id": 1,
//   "name": "John Doe",
//   "age": 25
// }

// Step 2: Define class with fields
class User {
  final int id;
  final String name;
  final int age;

  // Step 3: Constructor
  User({
    required this.id,
    required this.name,
    required this.age,
  });

  // Step 4: Factory fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    // Extract each field from JSON Map
    return User(
      id: json['id'],       // Get 'id' from Map
      name: json['name'],   // Get 'name' from Map
      age: json['age'],     // Get 'age' from Map
    );
  }
}

// Usage:
final jsonMap = {'id': 1, 'name': 'John Doe', 'age': 25};
final user = User.fromJson(jsonMap);
print(user.name);  // "John Doe"
```

---

## Using Data Models with API Calls

### Fetch Single Object

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Fetch single user
Future<User> fetchUser(int id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
  );

  if (response.statusCode == 200) {
    // Parse JSON and convert to User object
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  }
  throw Exception('Failed to load user');
}

// Usage:
void main() async {
  final user = await fetchUser(1);
  print(user.name);  // Type-safe access!
}
```

### Fetch List of Objects

```dart
// Fetch list of users
Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    // Parse JSON array and convert to List<User>
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  }
  throw Exception('Failed to load users');
}

// Usage:
void main() async {
  final users = await fetchUsers();
  for (var user in users) {
    print(user.name);  // Each user is type-safe!
  }
}
```

### Visual: List Parsing Flow

```
┌─────────────────────────────────────────────────────────────┐
│                 PARSING JSON ARRAY                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JSON Array String:                                         │
│  '[{"id":1,"name":"John"},{"id":2,"name":"Jane"}]'          │
│                ↓                                            │
│         jsonDecode()                                        │
│                ↓                                            │
│  List<dynamic>:                                             │
│  [                                                          │
│    {"id": 1, "name": "John"},                               │
│    {"id": 2, "name": "Jane"}                                │
│  ]                                                          │
│                ↓                                            │
│         .map((json) => User.fromJson(json))                 │
│                ↓                                            │
│  Iterable<User>:                                            │
│  (User(id:1, name:"John"), User(id:2, name:"Jane"))         │
│                ↓                                            │
│         .toList()                                           │
│                ↓                                            │
│  List<User>:                                                │
│  [User(id:1, name:"John"), User(id:2, name:"Jane")]         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Sending Data to API

### POST Request with Model

```dart
// Create new user
Future<User> createUser(User user) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user.toJson()),  // Convert to JSON
  );

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to create user');
}

// Usage:
void main() async {
  final newUser = User(
    id: 0,
    name: 'Alice',
    email: 'alice@example.com',
  );

  final createdUser = await createUser(newUser);
  print('Created user with ID: ${createdUser.id}');
}
```

### PUT/PATCH Request

```dart
// Update existing user
Future<User> updateUser(int id, User user) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to update user');
}

// Partial update
Future<User> patchUser(int id, Map<String, dynamic> updates) async {
  final response = await http.patch(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updates),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to patch user');
}
```

---

## Handling Different Data Types

### Common Data Type Conversions

```dart
class Product {
  final int id;
  final String name;
  final double price;
  final bool inStock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.inStock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // int
      id: json['id'],

      // String
      name: json['name'],

      // double (handle int too)
      price: (json['price'] as num).toDouble(),

      // bool
      inStock: json['inStock'] ?? json['in_stock'] ?? false,

      // DateTime from ISO string
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'inStock': inStock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

### Visual: Data Type Mapping

```
┌─────────────────────────────────────────────────────────────┐
│              JSON ↔ DART TYPE MAPPING                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JSON TYPE        │  DART TYPE      │  PARSING              │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  number (1, 2)    │  int            │  json['field']        │
│                                                             │
│  number (1.5)     │  double         │  json['field']        │
│                                                             │
│  string           │  String         │  json['field']        │
│                                                             │
│  true/false       │  bool           │  json['field']        │
│                                                             │
│  "2024-01-01"     │  DateTime       │  DateTime.parse(...)  │
│                                                             │
│  [1, 2, 3]        │  List<int>      │  List<int>.from(...)  │
│                                                             │
│  ["a", "b"]       │  List<String>   │  List<String>.from()  │
│                                                             │
│  {...}            │  CustomClass    │  Class.fromJson(...)  │
│                                                             │
│  null             │  Type?          │  json['field']        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Using Models in Flutter Widgets

### Basic Usage

```dart
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,  // Type-safe!
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(user.email),  // Autocomplete works!
          ],
        ),
      ),
    );
  }
}
```

### With FutureBuilder

```dart
class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),  // Returns List<User>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!;  // Type-safe List<User>

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(user: users[index]);
            },
          );
        },
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               MODEL BASICS CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC MODEL STRUCTURE:                                     │
│  ───────────────────────                                    │
│  class User {                                               │
│    final int id;                                            │
│    final String name;                                       │
│                                                             │
│    User({required this.id, required this.name});            │
│                                                             │
│    factory User.fromJson(Map<String, dynamic> json) {       │
│      return User(                                           │
│        id: json['id'],                                      │
│        name: json['name'],                                  │
│      );                                                     │
│    }                                                        │
│                                                             │
│    Map<String, dynamic> toJson() {                          │
│      return {'id': id, 'name': name};                       │
│    }                                                        │
│  }                                                          │
│                                                             │
│  PARSING SINGLE OBJECT:                                     │
│  final user = User.fromJson(jsonDecode(response.body));     │
│                                                             │
│  PARSING LIST:                                              │
│  final users = (jsonDecode(response.body) as List)          │
│      .map((json) => User.fromJson(json))                    │
│      .toList();                                             │
│                                                             │
│  SENDING DATA:                                              │
│  body: jsonEncode(user.toJson())                            │
│                                                             │
│  BENEFITS:                                                  │
│  ✓ Type safety                                              │
│  ✓ Autocomplete                                             │
│  ✓ Compile-time errors                                      │
│  ✓ Self-documenting                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does `fromJson` do?

<details>
<summary>Answer</summary>
It builds a Dart object from a `Map<String, dynamic>` (the result of `json.decode`).
</details>

**Q2.** What does `toJson` do?

<details>
<summary>Answer</summary>
It turns the object back into a `Map` so you can `json.encode` and send it to the server.
</details>

**Q3.** Why is `user.name` safer than `user['name']`?

<details>
<summary>Answer</summary>
`user.name` is type-checked at compile time and autocompletes. A typo like `user.nme` fails to compile, while `user['nme']` silently returns null.
</details>

---

## Assignment

A JSON looks like `{"id": 3, "title": "Pen", "price": 1.5}`.

### Problem 1: Write the class

Write a `Product` class with `int id`, `String title`, `double price`, a constructor, and `fromJson`.

### Problem 2: Parse a list

Given `List<dynamic> jsonList`, write the one line that turns it into a `List<Product>`.

### Problem 3: Send it back

Write the `toJson` for `Product`.

---

## Assignment Answers

### Problem 1: Write the class

```dart
class Product {
  final int id;
  final String title;
  final double price;

  Product({required this.id, required this.title, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
```

(`(json['price'] as num).toDouble()` safely handles a price that arrives as `1` or `1.5`.)

### Problem 2: Parse a list

```dart
final products = jsonList.map((j) => Product.fromJson(j)).toList();
```

### Problem 3: Send it back

```dart
Map<String, dynamic> toJson() => {
  'id': id,
  'title': title,
  'price': price,
};
```

---

## Navigation

⬅️ **Previous:** [State Patterns](07c-StatePatterns.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Serialization](08b-Serialization.md)
