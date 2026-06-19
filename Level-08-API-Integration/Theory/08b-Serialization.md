# Serialization: Converting Data Between Formats

## The Big Idea In One Sentence

> Serialize = object to text (to send); deserialize = text to object (to receive), and the trick for nested data is to call `fromJson`/`toJson` on the inner pieces too.

Learn what serialization actually means and how to use it in Dart/Flutter!

---

## What is Serialization?

**Serialization** = Converting an object into a format that can be stored or transmitted.

**Deserialization** = Converting that format back into an object.

```
SERIALIZATION EXPLAINED:

Your Dart Object          Serialized Format           Where It Goes
(lives in memory)         (text/bytes)                (storage/network)

     User                     JSON String                 API Server
  ┌─────────┐              ┌─────────────┐              ┌─────────┐
  │ id: 1   │   ──────►    │ {"id": 1,   │   ──────►   │ Backend │
  │ name:   │  serialize   │  "name":    │    send     │ Server  │
  │ "John"  │              │  "John"}    │             │         │
  └─────────┘              └─────────────┘             └─────────┘


     User                     JSON String                 API Server
  ┌─────────┐              ┌─────────────┐              ┌─────────┐
  │ id: 1   │   ◄──────    │ {"id": 1,   │   ◄──────   │ Backend │
  │ name:   │ deserialize  │  "name":    │   receive   │ Server  │
  │ "John"  │              │  "John"}    │             │         │
  └─────────┘              └─────────────┘             └─────────┘


WHY DO WE NEED THIS?

Your Dart app and the API server speak different languages:
- Dart uses: Objects, classes, typed variables
- APIs use: JSON (text), sometimes XML or binary

Serialization is the TRANSLATOR between them!
```

---

## Real-World Analogy

```
SHIPPING A CHAIR (Physical World):

You have a chair ──► You disassemble it ──► Ship flat box ──► Reassemble chair
   (object)           (serialize)           (transmit)        (deserialize)


SENDING DATA (Digital World):

You have User ──► Convert to JSON ──► Send over internet ──► Convert back to User
  (object)        (serialize)          (transmit)            (deserialize)


Why not just send the object directly?
- Networks only understand text/bytes, not Dart objects
- Different systems (Python backend, JavaScript frontend) all understand JSON
- JSON is human-readable and easy to debug
```

---

## Types of Serialization in Flutter

```
COMMON SERIALIZATION FORMATS:

1. JSON (JavaScript Object Notation) - Most common for APIs
   {"name": "John", "age": 25}
   Pros: Human-readable, universal, easy to debug
   Cons: Larger size, slower parsing

2. Binary/Protocol Buffers - For high-performance apps
   [binary data that humans can't read]
   Pros: Small size, fast parsing
   Cons: Not human-readable, harder to debug

3. XML - Older format, still used by some APIs
   <user><name>John</name><age>25</age></user>
   Pros: Very structured, supports schemas
   Cons: Verbose, larger than JSON


FOR FLUTTER APPS: We almost always use JSON serialization
because that's what 99% of REST APIs use.
```

---

## JSON Serialization in Dart

### The Manual Way (What You've Learned)

```dart
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // SERIALIZATION: Object -> JSON Map -> JSON String
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // DESERIALIZATION: JSON String -> JSON Map -> Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// COMPLETE SERIALIZATION FLOW:
void main() {
  // 1. Create object
  final user = User(id: 1, name: 'John', email: 'john@example.com');

  // 2. SERIALIZE: Object -> JSON String
  final jsonString = jsonEncode(user.toJson());
  print(jsonString);
  // Output: {"id":1,"name":"John","email":"john@example.com"}

  // 3. DESERIALIZE: JSON String -> Object
  final jsonMap = jsonDecode(jsonString);
  final userBack = User.fromJson(jsonMap);
  print(userBack.name);  // Output: John
}
```

### The Flow Visualized

```
SERIALIZATION FLOW (Sending to API):

User Object                Map<String, dynamic>           String
┌─────────────┐            ┌─────────────────┐           ┌──────────────────┐
│ User(       │            │ {               │           │ '{"id":1,        │
│   id: 1,    │  .toJson() │   "id": 1,      │ jsonEncode│   "name":"John", │
│   name:     │ ─────────► │   "name":"John",│ ─────────►│   "email":"..."}'│
│   "John"    │            │   "email":"..." │           │                  │
│ )           │            │ }               │           │ (Ready to send!) │
└─────────────┘            └─────────────────┘           └──────────────────┘


DESERIALIZATION FLOW (Receiving from API):

String                     Map<String, dynamic>           User Object
┌──────────────────┐       ┌─────────────────┐           ┌─────────────┐
│ '{"id":1,        │       │ {               │           │ User(       │
│   "name":"John", │jsonDecode│   "id": 1,   │ .fromJson │   id: 1,    │
│   "email":"..."}'│ ─────────►│   "name":"John",│─────────►│   name:     │
│                  │       │   "email":"..." │           │   "John"    │
│ (From API)       │       │ }               │           │ )           │
└──────────────────┘       └─────────────────┘           └─────────────┘
```

---

## Why Two Steps? (toJson + jsonEncode)

```dart
// You might wonder: Why not just have one method that returns a String?

// ANSWER: Flexibility!

// Step 1: toJson() returns a Map
// - Can be used with different encoders
// - Can be modified before encoding
// - Can be nested in other objects

// Step 2: jsonEncode() converts Map to String
// - Standard Dart function
// - Handles all the formatting
// - Works with any Map/List

// Example of flexibility:
final user = User(id: 1, name: 'John', email: 'john@example.com');

// Use for API
final jsonString = jsonEncode(user.toJson());

// Use for logging (pretty print)
final prettyJson = JsonEncoder.withIndent('  ').convert(user.toJson());

// Use as part of a larger object
final wrapper = {
  'user': user.toJson(),
  'timestamp': DateTime.now().toIso8601String(),
};
final wrapperString = jsonEncode(wrapper);
```

---

## Common Serialization Challenges

### Challenge 1: Different Field Names (API vs Dart)

```dart
// API sends: {"user_name": "John", "created_at": "2024-01-01"}
// Dart wants: userName, createdAt (camelCase)

class User {
  final String userName;
  final DateTime createdAt;

  User({required this.userName, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Map snake_case to camelCase
      userName: json['user_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Map camelCase back to snake_case
      'user_name': userName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

### Challenge 2: Type Conversions

```dart
class Product {
  final int id;
  final double price;
  final bool inStock;
  final DateTime createdAt;
  final List<String> tags;

  Product({
    required this.id,
    required this.price,
    required this.inStock,
    required this.createdAt,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // int - usually comes correctly
      id: json['id'],

      // double - API might send int OR double
      price: (json['price'] as num).toDouble(),

      // bool - might come as bool, int (0/1), or string ("true"/"false")
      inStock: _parseBool(json['in_stock']),

      // DateTime - comes as string, need to parse
      createdAt: DateTime.parse(json['created_at']),

      // List<String> - comes as List<dynamic>
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'in_stock': inStock,
      'created_at': createdAt.toIso8601String(),
      'tags': tags,
    };
  }
}
```

### Challenge 3: Nested Objects

```dart
// API sends:
// {
//   "id": 1,
//   "name": "John",
//   "address": {
//     "street": "123 Main St",
//     "city": "NYC"
//   }
// }

class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {'street': street, 'city': city};
}

class User {
  final int id;
  final String name;
  final Address address;

  User({required this.id, required this.name, required this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      // DESERIALIZE nested object
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // SERIALIZE nested object
      'address': address.toJson(),
    };
  }
}
```

### Challenge 4: Lists of Objects

```dart
// API sends:
// {
//   "id": 1,
//   "name": "John",
//   "posts": [
//     {"id": 1, "title": "Hello"},
//     {"id": 2, "title": "World"}
//   ]
// }

class Post {
  final int id;
  final String title;

  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class User {
  final int id;
  final String name;
  final List<Post> posts;

  User({required this.id, required this.name, required this.posts});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      // DESERIALIZE list of objects
      posts: (json['posts'] as List)
          .map((postJson) => Post.fromJson(postJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // SERIALIZE list of objects
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}
```

---

## Serialization Methods Compared

```
METHOD 1: MANUAL (What we've been doing)
─────────────────────────────────────────
Write fromJson/toJson yourself

Pros:
- Full control
- No dependencies
- Works everywhere

Cons:
- Tedious for large models
- Easy to make typos
- Must update when model changes


METHOD 2: CODE GENERATION (json_serializable)
─────────────────────────────────────────────
Package generates fromJson/toJson for you

Pros:
- Less code to write
- No typos
- Auto-updates when model changes

Cons:
- Build step required
- More setup
- Slower compile time

(Covered in 08c-CodeGeneration.md)


METHOD 3: FREEZED PACKAGE
─────────────────────────
Generates everything: fromJson, toJson, copyWith, equality

Pros:
- All features included
- Immutable by default
- Great for state management

Cons:
- Even more setup
- Larger generated code
- Learning curve

(An advanced package you can explore later once manual models feel easy.)


WHICH TO USE?

Small project (1-5 models)     → Manual
Medium project (5-20 models)   → json_serializable
Large project (20+ models)     → Freezed
```

---

## Using Serialization with APIs

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl = 'https://api.example.com';

  // GET - Deserialize response
  Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      // DESERIALIZE: String -> Map -> User
      final jsonMap = jsonDecode(response.body);
      return User.fromJson(jsonMap);
    }
    throw Exception('Failed to load user');
  }

  // GET LIST - Deserialize list
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      // DESERIALIZE: String -> List<Map> -> List<User>
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }

  // POST - Serialize request, Deserialize response
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      // SERIALIZE: User -> Map -> String
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      // DESERIALIZE response
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create user');
  }

  // PUT - Serialize request
  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      // SERIALIZE: User -> Map -> String
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update user');
  }
}
```

---

## Quick Reference

```
SERIALIZATION CHEAT SHEET:
─────────────────────────────

TERMS:
- Serialize = Object to String (for sending)
- Deserialize = String to Object (for receiving)

DART FUNCTIONS:
- jsonEncode(map) = Map -> String
- jsonDecode(string) = String -> Map

YOUR METHODS:
- toJson() = Object -> Map (you write this)
- fromJson() = Map -> Object (you write this)

FULL SERIALIZE:
jsonEncode(user.toJson())
       │         │
       │         └── Your method: User -> Map
       └── Dart function: Map -> String

FULL DESERIALIZE:
User.fromJson(jsonDecode(response.body))
       │              │
       │              └── Dart function: String -> Map
       └── Your method: Map -> User

COMMON CONVERSIONS:
- num -> double: (json['price'] as num).toDouble()
- String -> DateTime: DateTime.parse(json['date'])
- DateTime -> String: date.toIso8601String()
- List<dynamic> -> List<T>: List<T>.from(json['items'])
- null safety: json['field'] ?? defaultValue
```

---

## Summary

```
WHAT YOU LEARNED:
─────────────────

1. WHAT IS SERIALIZATION
   Converting objects to text/bytes for storage or transmission

2. WHY WE NEED IT
   Networks don't understand Dart objects, they understand JSON strings

3. THE TWO DIRECTIONS
   Serialize (send): Object -> toJson() -> jsonEncode() -> String
   Deserialize (receive): String -> jsonDecode() -> fromJson() -> Object

4. COMMON CHALLENGES
   - Different field names (snake_case vs camelCase)
   - Type conversions (num to double, string to DateTime)
   - Nested objects (call fromJson/toJson on nested classes)
   - Lists of objects (map over the list)

5. METHODS
   - Manual: Full control, more work
   - json_serializable: Less work, build step required
   - Freezed: Everything included, most setup
```

---

## Quick Quiz

**Q1.** Define serialize and deserialize in one line each.

<details>
<summary>Answer</summary>
Serialize = turn an object into text/JSON to send. Deserialize = turn received text/JSON back into an object.
</details>

**Q2.** A `User` has an `Address` field. How do you deserialize the nested address?

<details>
<summary>Answer</summary>
Call `Address.fromJson(json['address'])` inside `User.fromJson`.
</details>

**Q3.** A `User` has a `List<Post> posts`. How do you serialize it in `toJson`?

<details>
<summary>Answer</summary>
`'posts': posts.map((p) => p.toJson()).toList()`.
</details>

---

## Assignment

### Problem 1: Match the direction

For each, is it serialize or deserialize?
1. `jsonEncode(user.toJson())`
2. `User.fromJson(jsonDecode(body))`

### Problem 2: Nested deserialize

A `User` JSON has `"address": {"city": "Lagos"}`. Write the line inside `User.fromJson` that builds the `Address`.

### Problem 3: List serialize

Write the `toJson` entry that turns `List<Post> posts` into JSON.

---

## Assignment Answers

### Problem 1: Match the direction

1. **Serialize** (object going out to text).
2. **Deserialize** (text coming in to an object).

### Problem 2: Nested deserialize

```dart
address: Address.fromJson(json['address']),
```

### Problem 3: List serialize

```dart
'posts': posts.map((post) => post.toJson()).toList(),
```

---

## Navigation

Previous: [Model Basics](08a-ModelBasics.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Code Generation](08c-CodeGeneration.md)