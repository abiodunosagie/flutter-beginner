# Folder Structure Guide: What Goes Where?

## The Big Idea In One Sentence

> Give every kind of code its own folder/layer (models, services, repositories, controllers, screens, widgets), and let each layer only talk to the one directly below it.

This guide explains exactly what files go in each folder and WHY.

---

## The Problem You're Having

You see folders like:
- `controllers/`
- `widgets/`
- `repositories/`
- `api_client/` or `services/`
- `models/`

And you think: "Where do I put my code? What's the difference?"

Let me explain EACH folder with REAL examples.

---

## Visual Overview

```
lib/
├── models/           # DATA CLASSES - What your data looks like
│   └── user.dart     # class User { id, name, email }
│
├── services/         # NETWORK LAYER - How to talk to the internet
│   └── api_client.dart  # Makes HTTP GET/POST requests
│
├── repositories/     # DATA ACCESS - Where to get data
│   └── user_repository.dart  # Gets users (from API, cache, etc)
│
├── controllers/      # STATE MANAGEMENT - What data to show, loading states
│   └── users_controller.dart  # Tracks list of users, loading, errors
│
├── screens/          # FULL PAGES - What the user sees
│   └── users_screen.dart  # The whole screen with AppBar, body, etc
│
├── widgets/          # REUSABLE UI PIECES - Smaller components
│   └── user_card.dart  # One card showing a user's info
│
└── main.dart         # APP START - Entry point
```

---

## Folder 1: models/

**WHAT GOES HERE:** Data classes that describe the shape of your data.

**NOTHING ELSE:** No HTTP, no business logic, no UI, no state.

```dart
// models/user.dart
// JUST describes what a User looks like

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
    return {'id': id, 'name': name, 'email': email};
  }
}
```

```dart
// models/post.dart

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({...});

  factory Post.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```

```dart
// models/product.dart

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({...});

  factory Product.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- Model has `http.get()` - WRONG
- Model has `setState()` - WRONG
- Model imports Flutter material - WRONG (unless for Color, etc)
- Model calls other classes - Usually WRONG

---

## Folder 2: services/ (or api_client/)

**WHAT GOES HERE:** Code that makes HTTP requests.

**NOTHING ELSE:** No business logic, no UI, no models (except for return types).

```dart
// services/api_client.dart
// JUST makes HTTP requests and returns raw data

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  // Makes a GET request, returns the JSON response
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw ApiException('Failed', response.statusCode);
  }

  // Makes a POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw ApiException('Failed', response.statusCode);
  }

  // Makes a DELETE request
  Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ApiException('Failed', response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- ApiClient has `User.fromJson()` - WRONG (that's repository's job)
- ApiClient has `notifyListeners()` - WRONG (that's controller's job)
- ApiClient imports Flutter widgets - WRONG

---

## Folder 3: repositories/

**WHAT GOES HERE:** Code that gets/saves data and converts it to model objects.

**NOTHING ELSE:** No UI, no state management, no business decisions.

```dart
// repositories/user_repository.dart
// Gets users and returns User OBJECTS (not JSON)

// STEP 1: Define the interface (what can we do?)
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser(User user);
  Future<void> deleteUser(int id);
}

// STEP 2: Implement it (how do we actually do it?)
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    // 1. Call API client to get raw JSON
    final response = await apiClient.get('/users');

    // 2. Convert JSON to User objects
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
  Future<void> deleteUser(int id) async {
    await apiClient.delete('/users/$id');
  }
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- Repository has `setState()` - WRONG
- Repository has `isLoading = true` - WRONG (that's controller's job)
- Repository imports Flutter - WRONG
- Repository decides what to show - WRONG (that's controller's job)

---

## Folder 4: controllers/

**WHAT GOES HERE:** State management - tracks loading, errors, data, and notifies UI.

**NOTHING ELSE:** No HTTP calls directly, no UI widgets, no data parsing.

```dart
// controllers/users_controller.dart
// Manages USER STATE - loading, errors, list of users

import 'package:flutter/foundation.dart';

class UsersController extends ChangeNotifier {
  final UserRepository repository;  // Gets data from repository

  UsersController({required this.repository});

  // STATE (the data we're tracking)
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  // GETTERS (read-only access to state)
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // METHODS (actions that change state)

  /// Load all users from the repository
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();  // Tell UI: "Hey, I'm loading!"

    try {
      _users = await repository.getUsers();  // Get data
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();  // Tell UI: "Hey, I'm done!"
    }
  }

  /// Add a new user
  Future<bool> addUser(User user) async {
    try {
      final newUser = await repository.createUser(user);
      _users.add(newUser);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete a user
  Future<void> deleteUser(int id) async {
    try {
      await repository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- Controller has `http.get()` - WRONG (use repository)
- Controller has `Card()` or `Text()` - WRONG (that's widgets job)
- Controller parses JSON - WRONG (that's repository's job)

---

## Folder 5: screens/

**WHAT GOES HERE:** Full pages/screens that the user sees.

**NOTHING ELSE:** No HTTP calls, no JSON parsing.

```dart
// screens/users_screen.dart
// A FULL PAGE showing users

import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final controller = serviceLocator.usersController;  // Get from DI

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChange);
    controller.loadUsers();
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadUsers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
        return UserCard(user: user);  // Use reusable widget
      },
    );
  }
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- Screen has `http.get()` - WRONG
- Screen has `json.decode()` - WRONG
- Screen has 500+ lines of code - Probably WRONG (split into widgets)

---

## Folder 6: widgets/

**WHAT GOES HERE:** Reusable UI components (pieces of screens).

**NOTHING ELSE:** No HTTP, no state management (except local widget state).

```dart
// widgets/user_card.dart
// A REUSABLE card that shows user info

import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.name[0]),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
```

```dart
// widgets/loading_indicator.dart

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!),
          ],
        ],
      ),
    );
  }
}
```

```dart
// widgets/error_view.dart

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
```

**SIGNS YOU'RE DOING IT WRONG:**
- Widget has `http.get()` - WRONG
- Widget has `notifyListeners()` - WRONG
- Widget manages app-wide state - Probably WRONG

---

## Quick Reference: What Goes Where

```
QUESTION: "I need to..."        ANSWER: Put it in...
─────────────────────────────────────────────────────

Define what a User looks like   → models/user.dart

Make an HTTP request            → services/api_client.dart

Get list of users from API      → repositories/user_repository.dart

Track loading state             → controllers/users_controller.dart

Show a full page with AppBar    → screens/users_screen.dart

Create a reusable card widget   → widgets/user_card.dart

Start the app                   → main.dart

Wire dependencies together      → injection.dart (or main.dart)
```

---

## Example: Adding a "Posts" Feature

Let's say you want to add Posts to your app. Here's what files you create:

```
lib/
├── models/
│   └── post.dart           # NEW: class Post { id, title, body }
│
├── services/
│   └── api_client.dart     # EXISTING (reuse it)
│
├── repositories/
│   └── post_repository.dart  # NEW: getsPosts(), createPost()
│
├── controllers/
│   └── posts_controller.dart # NEW: tracks posts list, loading
│
├── screens/
│   └── posts_screen.dart   # NEW: full page showing posts
│
├── widgets/
│   └── post_card.dart      # NEW: card showing one post
│
└── injection.dart          # UPDATE: add PostRepository, PostsController
```

---

## Common Mistakes

```
MISTAKE: HTTP calls in widgets
─────────────────────────────
// WRONG
class UsersScreen extends StatelessWidget {
  Future<void> loadUsers() async {
    final response = await http.get(...);  // NO!
  }
}

// RIGHT
class UsersScreen extends StatelessWidget {
  final controller = sl.usersController;  // Use controller

  void loadUsers() {
    controller.loadUsers();  // Controller handles HTTP
  }
}


MISTAKE: JSON parsing in controllers
───────────────────────────────────
// WRONG
class UsersController {
  Future<void> loadUsers() async {
    final response = await http.get('/users');
    final json = jsonDecode(response.body);  // NO!
    _users = json.map((j) => User.fromJson(j));  // NO!
  }
}

// RIGHT
class UsersController {
  Future<void> loadUsers() async {
    _users = await repository.getUsers();  // Repository handles parsing
  }
}


MISTAKE: Business logic in repositories
──────────────────────────────────────
// WRONG
class UserRepository {
  Future<User> createUser(User user) async {
    if (user.age < 18) {  // Business logic - NO!
      throw Exception('Too young');
    }
    return await apiClient.post('/users', user.toJson());
  }
}

// RIGHT
// Put business logic in controller or service
class UsersController {
  Future<bool> createUser(User user) async {
    if (user.age < 18) {  // Business logic in controller
      _error = 'Too young';
      notifyListeners();
      return false;
    }
    await repository.createUser(user);
    return true;
  }
}
```

---

## Summary

```
FOLDER          CONTAINS                   KNOWS ABOUT
──────          ────────                   ───────────
models/         Data classes               Nothing (pure data)
services/       HTTP requests              URLs, headers
repositories/   Data access                ApiClient, Models
controllers/    State management           Repository, notifyListeners
screens/        Full pages                 Controller, Widgets
widgets/        UI components              Models (for display)
```

**GOLDEN RULE:** Each layer only talks to the layer directly below it.

```
screens/widgets ──► controllers ──► repositories ──► services/api_client
     (UI)           (State)         (Data)           (Network)
```

---

## Quick Quiz

**Q1.** Which folder holds the code that actually makes HTTP requests?

<details>
<summary>Answer</summary>
`services/` (the API client).
</details>

**Q2.** Where does JSON get turned into `User` objects?

<details>
<summary>Answer</summary>
In `repositories/`. The repository calls the service for raw data and converts it to model objects.
</details>

**Q3.** What is the golden rule of the layers?

<details>
<summary>Answer</summary>
Each layer only talks to the layer directly below it: UI → controllers → repositories → services.
</details>

---

## Assignment

### Problem 1: Place the code

Which folder does each belong in?
1. `class User { ... fromJson ... }`
2. A `Card` widget that shows one user.
3. Code that tracks `isLoading` and calls `notifyListeners()`.

### Problem 2: Spot the violation

A `UsersScreen` (in `screens/`) calls `http.get(...)` directly. Which rule does this break, and what should it call instead?

### Problem 3: Add a feature

To add a "Posts" feature, name the six files (one per layer) you would create.

---

## Assignment Answers

### Problem 1: Place the code

1. `models/` (pure data class).
2. `widgets/` (reusable UI piece).
3. `controllers/` (state management).

### Problem 2: Spot the violation

It breaks the layering rule: a screen should not make HTTP calls. It should call a **controller**, which uses a repository, which uses the service.

### Problem 3: Add a feature

`models/post.dart`, `repositories/post_repository.dart`, `controllers/posts_controller.dart`, `screens/posts_screen.dart`, `widgets/post_card.dart`, and reuse/update the existing `services/api_client.dart` (plus wiring in `injection.dart`).

---

## Navigation

Previous: [Code Generation](08c-CodeGeneration.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Api Client Deep Dive](09b-ApiClientDeepDive.md)
