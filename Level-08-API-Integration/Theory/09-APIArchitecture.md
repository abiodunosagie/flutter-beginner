# API Architecture: Putting It All Together

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

```dart
/// Defines what operations are available for Users
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser(User user);
  Future<void> deleteUser(int id);
}

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
  Future<void> deleteUser(int id) async {
    await apiClient.delete('/users/$id');
  }
}
```

### Why Use an Abstract Class (Interface)?

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

## Layer 4: Controller (State Management)

The Controller manages your app's state. It:
- Calls the Repository to get data
- Tracks loading and error states
- Notifies the UI when things change

```dart
import 'package:flutter/foundation.dart';

class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});

  // State
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  // Getters (read-only access)
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Load all users
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();  // Tell UI to rebuild

    try {
      _users = await repository.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();  // Tell UI to rebuild again
    }
  }

  /// Add a new user
  Future<bool> addUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await repository.createUser(user);
      _users.add(newUser);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a user
  Future<bool> deleteUser(int id) async {
    try {
      await repository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
```

---

## Putting It Together: Dependency Injection

Now we need to **wire everything together**. This is called **Dependency Injection** - we "inject" each layer's dependencies from the outside.

```dart
/// Simple service locator (Dependency Injection container)
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Store our instances
  ApiClient? _apiClient;
  UserRepository? _userRepository;
  UsersController? _usersController;

  /// Get API Client
  ApiClient get apiClient {
    _apiClient ??= ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    );
    return _apiClient!;
  }

  /// Get User Repository (depends on API Client)
  UserRepository get userRepository {
    _userRepository ??= UserRepositoryImpl(
      apiClient: apiClient,  // ← Inject the dependency!
    );
    return _userRepository!;
  }

  /// Get Users Controller (depends on Repository)
  UsersController get usersController {
    _usersController ??= UsersController(
      repository: userRepository,  // ← Inject the dependency!
    );
    return _usersController!;
  }
}

// Global access
final sl = ServiceLocator();
```

### Using in Your App

```dart
void main() {
  runApp(const MyApp());
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Get controller from service locator
  final controller = sl.usersController;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChange);
    controller.loadUsers();  // Load data on start
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});  // Rebuild when controller changes
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError) {
      return Center(child: Text('Error: ${controller.error}'));
    }

    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
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

## The Complete Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    COMPLETE DATA FLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   USER TAPS "Load Users"                                     │
│          │                                                   │
│          ▼                                                   │
│   WIDGET: Calls controller.loadUsers()                       │
│          │                                                   │
│          ▼                                                   │
│   CONTROLLER: Sets isLoading = true                          │
│               Calls repository.getUsers()                    │
│          │                                                   │
│          ▼                                                   │
│   REPOSITORY: Calls apiClient.get('/users')                  │
│          │                                                   │
│          ▼                                                   │
│   API CLIENT: Makes HTTP GET request                         │
│               Returns JSON                                   │
│          │                                                   │
│          ▼                                                   │
│   REPOSITORY: Converts JSON → List<User>                     │
│               Returns List<User>                             │
│          │                                                   │
│          ▼                                                   │
│   CONTROLLER: Stores users in _users                         │
│               Sets isLoading = false                         │
│               Calls notifyListeners()                        │
│          │                                                   │
│          ▼                                                   │
│   WIDGET: Rebuilds with new data                             │
│           Shows list of users                                │
│          │                                                   │
│          ▼                                                   │
│   USER SEES: List of users on screen!                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Why This Matters for Testing

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
  Future<void> deleteUser(int id) async {
    // Do nothing - it's fake!
  }
}

// Test the controller with fake data
void main() {
  test('should load users', () async {
    // Use mock repository
    final controller = UsersController(
      repository: MockUserRepository(),
    );

    await controller.loadUsers();

    expect(controller.users.length, 1);
    expect(controller.users[0].name, 'Test User');
    expect(controller.isLoading, false);
    expect(controller.hasError, false);
  });
}
```

---

## Folder Structure

```
lib/
├── models/
│   └── user.dart              # User model
│
├── services/
│   └── api_client.dart        # HTTP requests
│
├── repositories/
│   └── user_repository.dart   # Data access
│
├── controllers/
│   └── users_controller.dart  # State management
│
├── screens/
│   └── users_screen.dart      # UI
│
├── injection.dart             # Service locator
│
└── main.dart                  # App entry point
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                 API ARCHITECTURE SUMMARY                     │
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
│                                                              │
│   3. REPOSITORY - Bridge between app and data                │
│      • Uses API Client                                       │
│      • Converts JSON to Models                               │
│      • Abstract interface + implementation                   │
│                                                              │
│   4. CONTROLLER - Manages state                              │
│      • Uses Repository                                       │
│      • Tracks loading/error/data                             │
│      • Notifies UI of changes                                │
│                                                              │
│   5. WIDGET - Shows data to user                             │
│      • Uses Controller                                       │
│      • Displays loading/error/data                           │
│                                                              │
│   DEPENDENCY INJECTION:                                      │
│   • Wire layers together from outside                        │
│   • Makes testing possible                                   │
│   • Each layer only knows its dependencies                   │
│                                                              │
│   KEY PRINCIPLE:                                             │
│   Each layer has ONE job and only talks to adjacent layers!  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** Why do we use an abstract class for the Repository?

<details>
<summary>Answer</summary>

So we can swap implementations! In production we use `UserRepositoryImpl` that calls the real API. In tests we use `MockUserRepository` that returns fake data. The Controller doesn't care which one it gets - it just knows it can call `getUsers()`.

</details>

**Q2:** What's wrong with putting HTTP calls directly in widgets?

<details>
<summary>Answer</summary>

Many problems:
- Can't test the HTTP logic separately
- Can't reuse the logic in other screens
- Widget becomes huge and hard to understand
- If the API changes, you have to update many files

</details>

**Q3:** What is Dependency Injection?

<details>
<summary>Answer</summary>

Instead of a class creating its own dependencies (like `final repo = UserRepositoryImpl()`), the dependencies are "injected" from outside through the constructor (like `MyClass({required this.repo})`). This makes testing possible because you can inject mock dependencies.

</details>

---

**Next:** Check out `Example07-RealWorldAPIApp.dart` for a complete working example!

---

[← Data Models](./08-DataModels.md) | [Back to Level 08 README →](../README.md)
