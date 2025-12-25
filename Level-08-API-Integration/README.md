# Level 08: API Integration

Learn how to fetch data from the internet and display it in your Flutter app!

---

## What You'll Learn

```
┌─────────────────────────────────────────────────────────────┐
│                    API INTEGRATION                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   📱 Your App                        🌐 Internet            │
│   ┌─────────┐     REQUEST           ┌─────────┐            │
│   │         │ ─────────────────────>│  API    │            │
│   │ Flutter │   "Give me users"     │ Server  │            │
│   │   App   │                       │         │            │
│   │         │<───────────────────── │         │            │
│   └─────────┘     RESPONSE          └─────────┘            │
│                   [user data]                               │
│                                                             │
│   Like ordering food:                                       │
│   You (app) → Order (request) → Kitchen (server)           │
│   Kitchen → Food (response) → You                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Topics Covered

### Theory Files
| File | Topic | What You'll Learn |
|------|-------|-------------------|
| 01 | What is an API | Understanding REST APIs and HTTP |
| 02 | HTTP Methods | GET, POST, PUT, DELETE explained |
| 03 | JSON Basics | Parse and create JSON data |
| 04 | The http Package | Making HTTP requests in Flutter |
| 05 | Dio Package | Advanced HTTP client with interceptors |
| 06 | Error Handling | Handle network errors gracefully |
| 07 | Loading States | Show loading indicators properly |
| 08 | Data Models | Create Dart classes from JSON |
| 09 | API Architecture | Repository Pattern, DI & Clean Architecture |

### Examples
| File | Description |
|------|-------------|
| Example01 | Simple GET request |
| Example02 | Fetch and display list |
| Example03 | POST request (create data) |
| Example04 | Complete CRUD operations |
| Example05 | Dio with interceptors |
| Example06 | Error handling patterns |
| Example07 | Real-World API App (Complete Architecture) |

### Exercises
Practice fetching real data from public APIs!

---

## Understanding APIs - The Simple Way

### What is an API?

```
API = Application Programming Interface

Think of it like a waiter at a restaurant:

┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  YOU (Customer)         WAITER (API)        KITCHEN (Server)│
│      📱                    🤵                    👨‍🍳          │
│       │                     │                     │         │
│       │ "I want pizza"      │                     │         │
│       │ ───────────────────>│                     │         │
│       │                     │  "Table 5 wants     │         │
│       │                     │   pizza"            │         │
│       │                     │ ───────────────────>│         │
│       │                     │                     │         │
│       │                     │      [Makes pizza]  │         │
│       │                     │<─────────────────── │         │
│       │     [Pizza! 🍕]     │                     │         │
│       │<─────────────────── │                     │         │
│       │                     │                     │         │
│                                                             │
│  You don't go into the kitchen!                             │
│  You talk to the waiter (API) who talks to the kitchen.     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## HTTP Methods (The Menu)

```
┌─────────────────────────────────────────────────────────────┐
│                    HTTP METHODS                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GET     │  "Show me..."      │  Read data                  │
│          │  GET /users        │  Get all users              │
│          │  GET /users/5      │  Get user #5                │
│                                                             │
│  POST    │  "Create this..."  │  Create new data            │
│          │  POST /users       │  Create new user            │
│          │  + body: {name}    │                             │
│                                                             │
│  PUT     │  "Update this..."  │  Replace entire record      │
│          │  PUT /users/5      │  Update user #5             │
│          │  + body: {new data}│                             │
│                                                             │
│  PATCH   │  "Change this..."  │  Update part of record      │
│          │  PATCH /users/5    │  Update some fields         │
│          │  + body: {name}    │                             │
│                                                             │
│  DELETE  │  "Remove this..."  │  Delete data                │
│          │  DELETE /users/5   │  Delete user #5             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON - The Language of APIs

```
JSON = JavaScript Object Notation

It's just a way to write data that both humans and computers can read!

DART MAP                          JSON STRING
─────────────────────────────────────────────────────
Map<String, dynamic> user = {     {
  'name': 'John',                   "name": "John",
  'age': 25,                        "age": 25,
  'email': 'john@test.com'          "email": "john@test.com"
};                                }

DART LIST                         JSON ARRAY
─────────────────────────────────────────────────────
List<String> colors = [           [
  'red',                            "red",
  'green',                          "green",
  'blue'                            "blue"
];                                ]
```

---

## Package Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0         # Simple HTTP client
  dio: ^5.4.0          # Advanced HTTP client
```

---

## Quick Reference

### Simple GET Request

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<User>> fetchUsers() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
```

### POST Request

```dart
Future<User> createUser(String name, String email) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/users'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'email': email,
    }),
  );

  if (response.statusCode == 201) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create user');
  }
}
```

### Data Model

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

---

## Common Patterns

### FutureBuilder for Async Data

```dart
FutureBuilder<List<User>>(
  future: fetchUsers(),
  builder: (context, snapshot) {
    // Loading state
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    // Error state
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    // Success state
    final users = snapshot.data!;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(users[index].name));
      },
    );
  },
)
```

---

## Learning Path

```
START HERE
    │
    ▼
┌─────────────────────┐
│ 01-WhatIsAnAPI      │  ← Understand the basics
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 02-HTTPMethods      │  ← Learn GET, POST, etc.
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 03-JSONBasics       │  ← Parse and create JSON
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 04-HttpPackage      │  ← Make real requests!
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 05-DioPackage       │  ← Advanced features
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 06-ErrorHandling    │  ← Handle failures
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 07-LoadingStates    │  ← Great UX
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 08-DataModels       │  ← Type-safe code
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ 09-APIArchitecture  │  ← Repository, DI & Clean Code
└─────────────────────┘
    │
    ▼
  EXAMPLES & EXERCISES
```

---

## Public APIs for Practice

| API | URL | What it provides |
|-----|-----|------------------|
| JSONPlaceholder | jsonplaceholder.typicode.com | Fake users, posts, comments |
| REST Countries | restcountries.com | Country data |
| OpenWeather | openweathermap.org | Weather data (needs API key) |
| PokeAPI | pokeapi.co | Pokemon data |
| GitHub | api.github.com | User and repo data |

---

## Time Estimate

| Section | Estimated Time |
|---------|---------------|
| Theory (9 files) | 4-5 hours |
| Examples (7 files) | 3-4 hours |
| Exercises | 3-4 hours |
| **Total** | **10-13 hours** |

---

## Prerequisites

Before starting this level:
- [x] Dart basics (Level 01-04)
- [x] Flutter widgets (Level 05)
- [x] State management (Level 06)
- [x] Async/await understanding

---

[← Level 07: Navigation](../Level-07-Navigation/README.md) | [Level 09: Local Storage →](../Level-09-Local-Storage/README.md)
