# Repository Pattern Deep Dive

The Repository Pattern is one specific piece of architecture. This doc explains ONLY the repository - what it is, why it exists, and how to build one properly.

---

## What is a Repository?

A **Repository** is a class that sits between your app logic and your data source. It hides WHERE the data comes from.

```
WITHOUT REPOSITORY:
Your code knows exactly where data comes from

class UserScreen {
  void loadUsers() {
    // Your screen KNOWS it's calling an API
    // Your screen KNOWS the URL
    // Your screen KNOWS how to parse JSON
    http.get('https://api.example.com/users');
    jsonDecode(response.body);
    User.fromJson(...)
  }
}

Problem: What if you want to:
- Add caching?
- Switch to a different API?
- Use local database instead?
- Add offline support?

You'd have to change EVERY screen that loads users!


WITH REPOSITORY:
Your code doesn't know or care where data comes from

class UserScreen {
  final UserRepository repository;

  void loadUsers() {
    // Just ask for users - don't care HOW
    final users = await repository.getUsers();
  }
}

The repository handles:
- Making HTTP requests
- Parsing JSON
- Caching
- Offline fallback
- Error handling

Your screen just says: "Give me users"
```

---

## The Single Responsibility

```
WHAT THE REPOSITORY IS RESPONSIBLE FOR:
───────────────────────────────────────

1. DATA ACCESS - Get/Save data from sources
2. DATA CONVERSION - Turn raw data into model objects
3. DATA COORDINATION - Combine multiple sources if needed

WHAT THE REPOSITORY IS NOT RESPONSIBLE FOR:
───────────────────────────────────────────

1. NOT UI - Doesn't know about widgets
2. NOT BUSINESS LOGIC - Doesn't make decisions
3. NOT STATE MANAGEMENT - Doesn't track loading/error
4. NOT HTTP DETAILS - Doesn't care about headers, URLs (that's API Client's job)


SIMPLE RULE:
The repository answers the question:
"How do I get/save [this type of data]?"

It does NOT answer:
"What should I show on screen?"
"What happens when the user taps this?"
```

---

## Repository vs API Client

These are two different things that often get confused:

```
API CLIENT                         REPOSITORY
─────────                          ──────────
Makes HTTP requests                Uses API Client
Returns raw JSON                   Returns model objects
Knows about URLs, headers          Knows about your models
One per app (usually)              One per data type
Reusable across repositories       Specific to User, Post, etc.

class ApiClient {                  class UserRepository {
  Future<dynamic> get(endpoint)      final ApiClient api;
  Future<dynamic> post(...)
                                     Future<List<User>> getUsers() {
  // Returns JSON:                     final json = await api.get('/users');
  // {"id": 1, "name": "John"}         return json.map(User.fromJson);
}                                    }
                                     // Returns objects:
                                     // [User(id:1, name:"John")]
                                   }


DATA FLOW:

API Server ──► API Client ──► Repository ──► Your App
   JSON          JSON          Objects        Objects
```

---

## Basic Repository Implementation

### Step 1: Define the Interface (What can the repository do?)

```dart
/// This abstract class defines WHAT operations are available
/// It doesn't say HOW they work - just WHAT you can do
abstract class UserRepository {
  /// Get all users
  Future<List<User>> getUsers();

  /// Get single user by ID
  Future<User> getUser(int id);

  /// Create new user, returns created user with ID
  Future<User> createUser(User user);

  /// Update existing user
  Future<User> updateUser(int id, User user);

  /// Delete user
  Future<void> deleteUser(int id);

  /// Search users by name
  Future<List<User>> searchUsers(String query);
}
```

### Step 2: Implement the Interface (How does it actually work?)

```dart
/// This class implements the interface using an API
class ApiUserRepository implements UserRepository {
  final ApiClient apiClient;

  ApiUserRepository({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    final response = await apiClient.get('/users');
    return (response as List)
        .map((json) => User.fromJson(json))
        .toList();
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

  @override
  Future<List<User>> searchUsers(String query) async {
    final response = await apiClient.get('/users?search=$query');
    return (response as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}
```

---

## Why Use an Abstract Class?

```
THE POWER OF INTERFACES:
────────────────────────

You can have MULTIPLE implementations of the same interface:

                    UserRepository
                    (abstract class)
                          │
         ┌────────────────┼────────────────┐
         │                │                │
         ▼                ▼                ▼
  ApiUserRepository  CacheUserRepo   MockUserRepository
  (calls real API)   (uses cache)    (fake data for tests)


Your app code only knows about UserRepository:

class MyScreen {
  final UserRepository repo;  // Could be ANY implementation!

  void load() {
    repo.getUsers();  // Works with any implementation
  }
}


WHY THIS IS POWERFUL:

1. TESTING
   In tests, use MockUserRepository
   - No real API calls
   - Fast tests
   - Predictable results

2. DEVELOPMENT
   API not ready? Use MockUserRepository
   - Frontend can work without backend
   - Use fake data during development

3. CACHING
   Use CacheUserRepository
   - Check cache first
   - Fall back to API
   - Same interface!

4. OFFLINE MODE
   Use LocalUserRepository
   - Read from SQLite
   - No internet needed
   - Same interface!
```

---

## Different Repository Implementations

### 1. API Repository (Most Common)

```dart
class ApiUserRepository implements UserRepository {
  final ApiClient apiClient;

  ApiUserRepository({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    final response = await apiClient.get('/users');
    return (response as List).map((j) => User.fromJson(j)).toList();
  }

  // ... other methods
}
```

### 2. Mock Repository (For Testing)

```dart
class MockUserRepository implements UserRepository {
  final List<User> _fakeUsers = [
    User(id: 1, name: 'Test User 1', email: 'test1@test.com'),
    User(id: 2, name: 'Test User 2', email: 'test2@test.com'),
  ];

  @override
  Future<List<User>> getUsers() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    return _fakeUsers;
  }

  @override
  Future<User> getUser(int id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _fakeUsers.firstWhere((u) => u.id == id);
  }

  @override
  Future<User> createUser(User user) async {
    await Future.delayed(Duration(milliseconds: 100));
    final newUser = User(
      id: _fakeUsers.length + 1,
      name: user.name,
      email: user.email,
    );
    _fakeUsers.add(newUser);
    return newUser;
  }

  @override
  Future<User> updateUser(int id, User user) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _fakeUsers.indexWhere((u) => u.id == id);
    _fakeUsers[index] = user;
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _fakeUsers.removeWhere((u) => u.id == id);
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(Duration(milliseconds: 100));
    return _fakeUsers
        .where((u) => u.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
```

### 3. Cached Repository (API + Local Cache)

```dart
class CachedUserRepository implements UserRepository {
  final ApiClient apiClient;
  final LocalStorage localStorage;

  // In-memory cache
  List<User>? _cachedUsers;
  DateTime? _cacheTime;

  CachedUserRepository({
    required this.apiClient,
    required this.localStorage,
  });

  @override
  Future<List<User>> getUsers() async {
    // Return cache if fresh (less than 5 minutes old)
    if (_cachedUsers != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age.inMinutes < 5) {
        return _cachedUsers!;
      }
    }

    try {
      // Fetch from API
      final response = await apiClient.get('/users');
      final users = (response as List)
          .map((j) => User.fromJson(j))
          .toList();

      // Update cache
      _cachedUsers = users;
      _cacheTime = DateTime.now();

      // Also save to local storage for offline
      await localStorage.saveUsers(users);

      return users;
    } catch (e) {
      // If API fails, try local storage
      final localUsers = await localStorage.getUsers();
      if (localUsers.isNotEmpty) {
        return localUsers;
      }
      rethrow;  // No cache, no local data - throw error
    }
  }

  // Clear cache when data changes
  @override
  Future<User> createUser(User user) async {
    final response = await apiClient.post('/users', user.toJson());
    _cachedUsers = null;  // Invalidate cache
    return User.fromJson(response);
  }

  // ... other methods
}
```

---

## Repository Error Handling

```dart
/// Custom exceptions for repository errors
class RepositoryException implements Exception {
  final String message;
  final dynamic originalError;

  RepositoryException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

class UserNotFoundException extends RepositoryException {
  final int userId;
  UserNotFoundException(this.userId) : super('User $userId not found');
}

class NetworkException extends RepositoryException {
  NetworkException(String message) : super(message);
}

/// Repository with proper error handling
class ApiUserRepository implements UserRepository {
  final ApiClient apiClient;

  ApiUserRepository({required this.apiClient});

  @override
  Future<User> getUser(int id) async {
    try {
      final response = await apiClient.get('/users/$id');
      return User.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        throw UserNotFoundException(id);
      }
      throw NetworkException('Failed to load user: ${e.message}');
    } catch (e) {
      throw RepositoryException('Unexpected error', e);
    }
  }

  // ... other methods with similar error handling
}
```

---

## Using Repository in Your App

```dart
// In your screen or controller
class UsersScreen extends StatefulWidget {
  final UserRepository repository;  // Injected from outside!

  const UsersScreen({required this.repository, super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await widget.repository.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
```

---

## Common Mistakes to Avoid

```
MISTAKE 1: Putting UI logic in repository
─────────────────────────────────────────
BAD:
class UserRepository {
  Future<Widget> getUserCard(int id) async {  // WRONG!
    final user = await getUser(id);
    return Card(child: Text(user.name));
  }
}

GOOD:
class UserRepository {
  Future<User> getUser(int id) async {
    // Just return data, let UI handle display
  }
}


MISTAKE 2: Putting business logic in repository
───────────────────────────────────────────────
BAD:
class OrderRepository {
  Future<void> processOrder(Order order) async {
    if (order.total > 100) {
      await applyDiscount(order);  // Business logic!
    }
    await saveOrder(order);
  }
}

GOOD:
// Business logic belongs in a service or use case class
class OrderService {
  final OrderRepository repository;

  Future<void> processOrder(Order order) async {
    if (order.total > 100) {
      order = order.withDiscount(0.1);
    }
    await repository.createOrder(order);
  }
}


MISTAKE 3: Making repository a God class
────────────────────────────────────────
BAD:
class DataRepository {
  Future<List<User>> getUsers() async { ... }
  Future<List<Post>> getPosts() async { ... }
  Future<List<Comment>> getComments() async { ... }
  Future<Settings> getSettings() async { ... }
  // 50 more methods...
}

GOOD:
class UserRepository { ... }
class PostRepository { ... }
class CommentRepository { ... }
class SettingsRepository { ... }
// One repository per data type


MISTAKE 4: Exposing API details
───────────────────────────────
BAD:
class UserRepository {
  Future<List<User>> getUsers({
    required String authHeader,  // Leaking API details!
    required String apiVersion,
  }) async { ... }
}

GOOD:
class UserRepository {
  Future<List<User>> getUsers() async {
    // Handle auth/versioning internally
  }
}
```

---

## Summary

```
REPOSITORY PATTERN SUMMARY:
───────────────────────────

WHAT IT IS:
A class that provides data access through a clean interface

WHAT IT DOES:
- Hides data source details
- Converts raw data to model objects
- Can combine multiple data sources

STRUCTURE:
1. Abstract class (interface) - defines WHAT
2. Implementation class - defines HOW

WHY USE IT:
- Testability (use mocks in tests)
- Flexibility (swap implementations)
- Separation (data access vs business logic)
- Maintainability (change once, works everywhere)

COMMON IMPLEMENTATIONS:
- ApiRepository (calls REST API)
- MockRepository (fake data for tests)
- CachedRepository (API + local cache)
- LocalRepository (SQLite/SharedPreferences)

KEY RULES:
- One repository per data type (UserRepo, PostRepo)
- Repository returns MODEL objects, not JSON
- Repository doesn't know about UI
- Use abstract class for swappable implementations
```

---

## Navigation

Previous: [Code Generation](08c-CodeGeneration.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Service Layer](09b-ServiceLayer.md)
