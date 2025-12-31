# Repository Pattern

Learn how to organize API code using the Repository Pattern for clean, testable architecture!

---

## The Simple Explanation

So far you've learned individual pieces:
- How to make HTTP requests
- How to parse JSON
- How to create data models
- How to handle errors

Now let's learn how to **organize** all these pieces properly - like building a house with a solid foundation instead of just stacking bricks randomly.

```
WITHOUT ARCHITECTURE (Spaghetti Code):
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   Widget                                                     │
│   ┌──────────────────────────────────────────────────────┐  │
│   │  http.get(...)                                        │  │
│   │  json.decode(...)                                     │  │
│   │  User.fromJson(...)                                   │  │
│   │  setState(...)                                        │  │
│   │  error handling...                                    │  │
│   │  loading state...                                     │  │
│   │  ALL MIXED TOGETHER!                                  │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                              │
│   Problems:                                                  │
│   ❌ Hard to test (can't mock HTTP)                         │
│   ❌ Hard to reuse (copy-paste everywhere)                  │
│   ❌ Hard to maintain (change API = change many files)      │
│   ❌ Hard to understand (too much in one place)             │
│                                                              │
└─────────────────────────────────────────────────────────────┘

WITH ARCHITECTURE (Clean Code):
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   Widget ─────► Controller ─────► Repository ─────► API     │
│                                                              │
│   Each layer has ONE job:                                   │
│   • Widget: Show data, handle user taps                     │
│   • Controller: Manage state (loading, error, data)         │
│   • Repository: Fetch and convert data                      │
│   • API Client: Make HTTP requests                          │
│                                                              │
│   Benefits:                                                  │
│   ✅ Easy to test (mock any layer)                          │
│   ✅ Easy to reuse (same repository for different screens)  │
│   ✅ Easy to maintain (change API = change one file)        │
│   ✅ Easy to understand (each layer is small and focused)   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The Restaurant Analogy

Think of your app like a restaurant:

```
┌─────────────────────────────────────────────────────────────┐
│                   RESTAURANT = YOUR APP                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   CUSTOMER          = User (taps buttons, sees data)        │
│   WAITER (Widget)   = Takes order, delivers food            │
│   CHEF (Controller) = Prepares the dish, manages kitchen    │
│   SUPPLIER (Repo)   = Gets ingredients from farms           │
│   FARM (API)        = Source of raw ingredients             │
│                                                              │
│                                                              │
│   Customer: "I want pizza!"                                 │
│        │                                                     │
│        ▼                                                     │
│   Waiter: Takes order, shows menu                           │
│        │                                                     │
│        ▼                                                     │
│   Chef: "I need tomatoes and cheese"                        │
│        │                                                     │
│        ▼                                                     │
│   Supplier: Gets ingredients from farm                      │
│        │                                                     │
│        ▼                                                     │
│   Farm: Provides tomatoes and cheese                        │
│        │                                                     │
│        ▼                                                     │
│   (Ingredients flow back up)                                │
│        │                                                     │
│        ▼                                                     │
│   Customer: Gets pizza!                                     │
│                                                              │
│                                                              │
│   THE WAITER NEVER GOES TO THE FARM DIRECTLY!               │
│   Each person only talks to the next person in line.        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Layer 1: Data Model

Your data model defines what your data looks like.

```dart
/// User model - represents a user in your app
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Convert JSON from API → User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  /// Convert User object → JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

**Rule:** Models only know about themselves. They don't know about HTTP, widgets, or anything else.

---

## Layer 2: API Client

The API Client makes raw HTTP requests. It doesn't know about your business logic - it just sends requests and returns responses.

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Handles all HTTP communication
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  /// Make a GET request
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Request failed',
        response.statusCode,
      );
    }
  }

  /// Make a POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Request failed',
        response.statusCode,
      );
    }
  }

  /// Make a DELETE request
  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException(
        'Delete failed',
        response.statusCode,
      );
    }
  }

  /// Make a PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Update failed',
        response.statusCode,
      );
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
```

**Rule:** The API Client only knows about HTTP. It doesn't know about Users, Posts, or any business objects.

---

## Layer 3: Repository

The Repository is the bridge between your app and the data source. It:
- Uses the API Client to fetch raw data
- Converts JSON into your model objects
- Provides a clean interface for your app

### Abstract Repository (Interface)

```dart
/// Defines what operations are available for Users
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser(User user);
  Future<User> updateUser(int id, User user);
  Future<void> deleteUser(int id);
}
```

### Implementation

```dart
/// Implementation that uses the API
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    // 1. Fetch raw data from API
    final response = await apiClient.get('/users');

    // 2. Convert JSON list to User objects
    final List<dynamic> jsonList = response as List<dynamic>;
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  @override
  Future<User> getUser(int id) async {
    final response = await apiClient.get('/users/$id');
    return User.fromJson(response);
  }

  @override
  Future<User> createUser(User user) async {
    final response = await apiClient.post('/users', user.toJson());
    return User.fromJson(response);
  }

  @override
  Future<User> updateUser(int id, User user) async {
    final response = await apiClient.put('/users/$id', user.toJson());
    return User.fromJson(response);
  }

  @override
  Future<void> deleteUser(int id) async {
    await apiClient.delete('/users/$id');
  }
}
```

---

## Why Use an Abstract Class (Interface)?

```
┌─────────────────────────────────────────────────────────────┐
│             WHY ABSTRACT USERREPOSITORY?                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   In production:                                             │
│   UserRepository repo = UserRepositoryImpl(apiClient);       │
│                                                              │
│   In tests:                                                  │
│   UserRepository repo = MockUserRepository();                │
│                                                              │
│   Your Controller doesn't care which one it gets!            │
│   It just knows: "I can call getUsers() and get users"       │
│                                                              │
│   ┌───────────────────────────────────────────────────────┐ │
│   │                  UserRepository                        │ │
│   │                    (interface)                         │ │
│   │           getUsers(), getUser(), etc.                  │ │
│   └───────────────────────────────────────────────────────┘ │
│                  ▲                 ▲                         │
│                  │                 │                         │
│   ┌──────────────────┐   ┌──────────────────┐               │
│   │ UserRepoImpl     │   │ MockUserRepo     │               │
│   │ (Real API calls) │   │ (Fake data)      │               │
│   └──────────────────┘   └──────────────────┘               │
│                                                              │
│   Same interface, different implementations!                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Testing with Mock Repository

```dart
// In tests, you can mock the repository!
class MockUserRepository implements UserRepository {
  @override
  Future<List<User>> getUsers() async {
    // Return fake data - no real API call!
    return [
      User(id: 1, name: 'Test User', email: 'test@test.com'),
    ];
  }

  @override
  Future<User> getUser(int id) async {
    return User(id: id, name: 'Test User', email: 'test@test.com');
  }

  @override
  Future<User> createUser(User user) async {
    return User(id: 99, name: user.name, email: user.email);
  }

  @override
  Future<User> updateUser(int id, User user) async {
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    // Do nothing - it's fake!
  }
}

// Test example
void main() {
  test('should load users', () async {
    // Use mock repository - no real API calls!
    final repository = MockUserRepository();

    final users = await repository.getUsers();

    expect(users.length, 1);
    expect(users[0].name, 'Test User');
  });
}
```

---

## Complete Repository Example

```dart
/// Post model
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

/// Post repository interface
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<List<Post>> getPostsByUser(int userId);
  Future<Post> getPost(int id);
  Future<Post> createPost(Post post);
  Future<Post> updatePost(int id, Post post);
  Future<void> deletePost(int id);
}

/// Post repository implementation
class PostRepositoryImpl implements PostRepository {
  final ApiClient apiClient;

  PostRepositoryImpl({required this.apiClient});

  @override
  Future<List<Post>> getPosts() async {
    final response = await apiClient.get('/posts');
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  @override
  Future<List<Post>> getPostsByUser(int userId) async {
    final response = await apiClient.get('/posts?userId=$userId');
    return (response as List).map((json) => Post.fromJson(json)).toList();
  }

  @override
  Future<Post> getPost(int id) async {
    final response = await apiClient.get('/posts/$id');
    return Post.fromJson(response);
  }

  @override
  Future<Post> createPost(Post post) async {
    final response = await apiClient.post('/posts', post.toJson());
    return Post.fromJson(response);
  }

  @override
  Future<Post> updatePost(int id, Post post) async {
    final response = await apiClient.put('/posts/$id', post.toJson());
    return Post.fromJson(response);
  }

  @override
  Future<void> deletePost(int id) async {
    await apiClient.delete('/posts/$id');
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              REPOSITORY PATTERN SUMMARY                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   LAYERS (from bottom to top):                               │
│                                                              │
│   1. MODEL - Defines your data structure                     │
│      • fromJson() to convert from API                        │
│      • toJson() to send to API                               │
│                                                              │
│   2. API CLIENT - Makes HTTP requests                        │
│      • get(), post(), put(), delete()                        │
│      • Handles errors                                        │
│      • Returns raw JSON                                      │
│                                                              │
│   3. REPOSITORY - Bridge between app and data                │
│      • Uses API Client                                       │
│      • Converts JSON to Models                               │
│      • Abstract interface + implementation                   │
│      • Provides clean API for app                            │
│                                                              │
│   WHY USE REPOSITORY PATTERN?                                │
│   ✓ Separation of concerns                                   │
│   ✓ Easy to test with mocks                                  │
│   ✓ Reusable across screens                                  │
│   ✓ Easy to switch data sources                              │
│   ✓ Single source of truth for data operations               │
│                                                              │
│   KEY PRINCIPLE:                                             │
│   Each layer has ONE job and only talks to adjacent layers!  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

---

## Navigation

⬅️ **Previous:** [Code Generation](08c-CodeGeneration.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Service Layer](09b-ServiceLayer.md)
