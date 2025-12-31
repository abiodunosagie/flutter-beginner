# Serialization

Learn advanced techniques for handling nullable fields, nested objects, and complex data structures!

---

## Handling Nullable Fields

### Why Nullable Fields Matter

```
┌─────────────────────────────────────────────────────────────┐
│                   NULLABLE FIELDS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Real-world APIs often have:                                │
│  • Optional fields (might not be in JSON)                   │
│  • Null values (explicitly set to null)                     │
│  • Missing data (field doesn't exist)                       │
│                                                             │
│  Example JSON:                                              │
│  {                                                          │
│    "id": 1,                                                 │
│    "name": "John",                                          │
│    "email": "john@example.com",                             │
│    "phone": null,              ← Explicitly null            │
│                                  (no "website" field)       │
│  }                                                          │
│                                                             │
│  If we try to access user.phone or user.website without     │
│  handling nulls, we'll get runtime errors!                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Nullable Fields Implementation

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

// Usage:
final user = User.fromJson(jsonMap);
print(user.phone ?? 'No phone');  // Safe access
if (user.website != null) {
  print('Website: ${user.website}');
}
```

---

## Handling Nested Objects

### Single Nested Object

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

  // Helper getter
  String get fullAddress => '$street, $city $zipcode';
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
print(user.address.fullAddress);  // "123 Main St, New York 10001"
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

### Nullable Nested Objects

```dart
class User {
  final int id;
  final String name;
  final String email;
  final Address? address;  // Nullable nested object

  User({
    required this.id,
    required this.name,
    required this.email,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // Parse only if not null
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

// Safe usage:
if (user.address != null) {
  print(user.address!.city);
}
// OR
print(user.address?.city ?? 'No city');
```

---

## Handling Arrays of Objects

### List of Objects

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

### Empty or Null Arrays

```dart
class User {
  final int id;
  final String name;
  final List<Post> posts;

  User({
    required this.id,
    required this.name,
    this.posts = const [],  // Default to empty list
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      // Handle null or empty array
      posts: json['posts'] != null
          ? (json['posts'] as List<dynamic>)
              .map((e) => Post.fromJson(e))
              .toList()
          : [],  // Default to empty list if null
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
```

---

## Safe Parsing with Default Values

### Type-Safe Parsing

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

      // Handle different field names
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

## The copyWith Pattern

### What is copyWith?

```
┌─────────────────────────────────────────────────────────────┐
│                   COPYWITH PATTERN                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Problem: Objects with final fields are immutable           │
│                                                             │
│  final user = User(id: 1, name: 'John', email: 'j@x.com');  │
│  user.name = 'Jane';  // ERROR! final fields can't change   │
│                                                             │
│  Solution: Create a NEW object with some fields changed     │
│                                                             │
│  final updatedUser = user.copyWith(name: 'Jane');           │
│  // New object with:                                        │
│  // id: 1 (unchanged)                                       │
│  // name: 'Jane' (changed)                                  │
│  // email: 'j@x.com' (unchanged)                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Implementing copyWith

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // copyWith method
  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,          // Use new value or keep current
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// Usage:
final user = User(id: 1, name: 'John', email: 'john@example.com');
final updatedUser = user.copyWith(name: 'Jane');

print(user.name);         // "John" (original unchanged)
print(updatedUser.name);  // "Jane" (new object)
print(updatedUser.id);    // 1 (copied from original)
```

---

## Equality and toString

### Implementing Equality

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Override equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  // Override hashCode (required when overriding ==)
  @override
  int get hashCode => Object.hash(id, name, email);

  // Override toString for debugging
  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

// Usage:
final user1 = User(id: 1, name: 'John', email: 'john@example.com');
final user2 = User(id: 1, name: 'John', email: 'john@example.com');

print(user1 == user2);  // true (same values)
print(user1);           // User(id: 1, name: John, email: john@example.com)
```

---

## Complete Real-World Example

```dart
// Complete User model with all patterns

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name)';
}

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
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'zipcode': zipcode,
  };

  String get fullAddress => '$street, $city $zipcode';
}

class Company {
  final String name;
  final String catchPhrase;

  Company({
    required this.name,
    required this.catchPhrase,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'catchPhrase': catchPhrase,
  };
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              SERIALIZATION CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NULLABLE FIELDS:                                           │
│  final String? phone;           // In class                 │
│  phone: json['phone'],          // In fromJson              │
│  if (phone != null) 'phone': p  // In toJson                │
│                                                             │
│  NESTED OBJECTS:                                            │
│  address: Address.fromJson(json['address'])                 │
│                                                             │
│  NULLABLE NESTED:                                           │
│  address: json['address'] != null                           │
│      ? Address.fromJson(json['address'])                    │
│      : null                                                 │
│                                                             │
│  ARRAYS OF OBJECTS:                                         │
│  posts: (json['posts'] as List)                             │
│      .map((e) => Post.fromJson(e))                          │
│      .toList()                                              │
│                                                             │
│  SAFE DEFAULTS:                                             │
│  id: json['id'] ?? 0                                        │
│  name: json['name'] ?? 'Unknown'                            │
│  tags: json['tags'] != null ? List.from(json['tags']) : []  │
│                                                             │
│  COPYWITH PATTERN:                                          │
│  User copyWith({int? id, String? name}) {                   │
│    return User(id: id ?? this.id, ...);                     │
│  }                                                          │
│                                                             │
│  EQUALITY:                                                  │
│  @override                                                  │
│  bool operator ==(Object other) => ...                      │
│  @override                                                  │
│  int get hashCode => ...                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

---

## Navigation

⬅️ **Previous:** [Model Basics](08a-ModelBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Code Generation](08c-CodeGeneration.md)
