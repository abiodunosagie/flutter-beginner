# Data Models

Learn how to create type-safe Dart classes from JSON data!

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

## Using Data Models with API Calls

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
```

---

## Handling Nullable Fields

```dart
// JSON might have optional fields:
// {
//   "id": 1,
//   "name": "John",
//   "email": "john@example.com",
//   "phone": null,              // Could be null
//   "website": "john.com"       // Might be missing entirely
// }

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;     // Nullable - can be null
  final String? website;   // Nullable - might not exist

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,            // Optional parameter
    this.website,          // Optional parameter
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],        // null if missing
      website: json['website'],    // null if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,      // Only include if not null
      if (website != null) 'website': website,
    };
  }
}
```

---

## Handling Nested Objects

```dart
// JSON with nested objects:
// {
//   "id": 1,
//   "name": "John",
//   "email": "john@example.com",
//   "address": {
//     "street": "123 Main St",
//     "city": "New York",
//     "zipcode": "10001"
//   }
// }

// First, create the nested class
class Address {
  final String street;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zipcode': zipcode,
    };
  }
}

// Then use it in the main class
class User {
  final int id;
  final String name;
  final String email;
  final Address address;  // Nested object

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // Parse nested object
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toJson(),  // Convert nested object
    };
  }
}

// Usage:
print(user.address.city);  // "New York"
```

### Visual: Nested Objects

```
┌─────────────────────────────────────────────────────────────┐
│                    NESTED OBJECTS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JSON:                           Classes:                   │
│  ─────                           ────────                   │
│  {                               User                       │
│    "id": 1,                      ├── id: int                │
│    "name": "John",               ├── name: String           │
│    "address": {      ──────────→ └── address: Address       │
│      "street": "...",                   ├── street: String  │
│      "city": "NYC"                      └── city: String    │
│    }                                                        │
│  }                                                          │
│                                                             │
│  ACCESS:                                                    │
│  user.address.city → "NYC"                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Handling Arrays of Objects

```dart
// JSON with array of objects:
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
    return Post(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}

class User {
  final int id;
  final String name;
  final List<Post> posts;  // Array of objects

  User({
    required this.id,
    required this.name,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      // Parse array of objects
      posts: (json['posts'] as List<dynamic>)
          .map((postJson) => Post.fromJson(postJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}

// Usage:
print(user.posts[0].title);  // "Hello"
print(user.posts.length);    // 2
```

---

## Safe Parsing with Default Values

```dart
class User {
  final int id;
  final String name;
  final String email;
  final int age;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Use null-aware operator with default
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',

      // Handle type conversion
      age: _parseAge(json['age']),
      isActive: json['isActive'] ?? json['is_active'] ?? true,
    );
  }

  // Helper for type conversion
  static int _parseAge(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'isActive': isActive,
    };
  }
}
```

---

## Complete Real-World Example

```dart
// Complete User model with all common patterns

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address? address;      // Nullable nested object
  final String? phone;
  final String? website;
  final Company? company;      // Nullable nested object
  final List<String> tags;     // Array of primitives
  final DateTime createdAt;    // Date parsing

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
    this.tags = const [],
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',

      // Nullable nested object
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,

      phone: json['phone'],
      website: json['website'],

      // Nullable nested object
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,

      // Array of strings (or empty list)
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],

      // Parse date string to DateTime
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      if (address != null) 'address': address!.toJson(),
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (company != null) 'company': company!.toJson(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Useful methods
  @override
  String toString() => 'User(id: $id, name: $name)';

  // Copy with modification
  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username,
      email: email ?? this.email,
      address: address,
      phone: phone,
      website: website,
      company: company,
      tags: tags,
      createdAt: createdAt,
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo? geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      suite: json['suite'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      geo: json['geo'] != null ? Geo.fromJson(json['geo']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
    if (geo != null) 'geo': geo!.toJson(),
  };

  String get fullAddress => '$street, $suite, $city $zipcode';
}

class Geo {
  final double lat;
  final double lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lng'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
      bs: json['bs'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'catchPhrase': catchPhrase,
    'bs': bs,
  };
}
```

---

## Using Models in Flutter Widgets

```dart
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
            if (user.address != null)  // Null-safe access
              Text(user.address!.fullAddress),
            if (user.company != null)
              Text('Works at ${user.company!.name}'),
          ],
        ),
      ),
    );
  }
}

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
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
    );
  }
}
```

---

## API Response Wrapper

```dart
// Many APIs wrap data like this:
// {
//   "status": "success",
//   "data": [...],
//   "message": "Users fetched"
// }

class ApiResponse<T> {
  final String status;
  final T data;
  final String? message;

  ApiResponse({
    required this.status,
    required this.data,
    this.message,
  });

  bool get isSuccess => status == 'success';

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'] ?? 'error',
      data: fromJsonT(json['data']),
      message: json['message'],
    );
  }
}

// Usage:
Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('$baseUrl/users'));

  if (response.statusCode == 200) {
    final apiResponse = ApiResponse<List<User>>.fromJson(
      json.decode(response.body),
      (data) => (data as List).map((e) => User.fromJson(e)).toList(),
    );

    if (apiResponse.isSuccess) {
      return apiResponse.data;
    }
    throw Exception(apiResponse.message);
  }
  throw Exception('Failed to load users');
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│               DATA MODELS CHEAT SHEET                        │
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
│      return User(id: json['id'], name: json['name']);       │
│    }                                                        │
│                                                             │
│    Map<String, dynamic> toJson() => {'id': id, 'name': n};  │
│  }                                                          │
│                                                             │
│  NULLABLE FIELDS:                                           │
│  final String? phone;           // In class                 │
│  phone: json['phone'],          // In fromJson              │
│  if (phone != null) 'phone': p  // In toJson                │
│                                                             │
│  NESTED OBJECTS:                                            │
│  address: Address.fromJson(json['address'])                 │
│                                                             │
│  ARRAYS:                                                    │
│  posts: (json['posts'] as List)                             │
│      .map((e) => Post.fromJson(e))                          │
│      .toList()                                              │
│                                                             │
│  SAFE DEFAULTS:                                             │
│  id: json['id'] ?? 0                                        │
│  name: json['name'] ?? 'Unknown'                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Loading States](./07-LoadingStates.md) | [Back to Level 08 README →](../README.md)
