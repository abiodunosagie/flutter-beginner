# Service Layer

## The Big Idea In One Sentence

> This lesson wires all the layers together: a controller pulls data from the repository and a service locator hands each layer its dependencies, so the whole chain (UI → controller → repository → API client) just works.

Learn how to manage state and integrate your repository with the UI using controllers and dependency injection!

---

## Layer 4: Controller (State Management)

The Controller manages your app's state. It:
- Calls the Repository to get data
- Tracks loading and error states
- Notifies the UI when things change

### Basic Controller with ChangeNotifier

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

  /// Refresh users
  Future<void> refresh() async {
    await loadUsers();
  }
}
```

---

## Dependency Injection

Now we need to **wire everything together**. This is called **Dependency Injection** - we "inject" each layer's dependencies from the outside.

### Simple Service Locator

```dart
/// Simple service locator (Dependency Injection container)
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Store our instances
  ApiClient? _apiClient;
  UserRepository? _userRepository;
  PostRepository? _postRepository;
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

  /// Get Post Repository (depends on API Client)
  PostRepository get postRepository {
    _postRepository ??= PostRepositoryImpl(
      apiClient: apiClient,
    );
    return _postRepository!;
  }

  /// Get Users Controller (depends on Repository)
  UsersController get usersController {
    _usersController ??= UsersController(
      repository: userRepository,  // ← Inject the dependency!
    );
    return _usersController!;
  }

  /// Reset for testing
  void reset() {
    _apiClient = null;
    _userRepository = null;
    _postRepository = null;
    _usersController = null;
  }
}

// Global access
final sl = ServiceLocator();
```

---

## Using Controller in Widgets

### Basic Usage

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${controller.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadUsers,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => controller.deleteUser(user.id),
          ),
        );
      },
    );
  }
}
```

---

## Using with Provider

### Setup Provider

Add to `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.1.0
```

### Provider Integration

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl.usersController..loadUsers(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UsersScreen(),
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Consumer<UsersController>(
        builder: (context, controller, child) {
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UsersController>().refresh();
        },
        child: const Icon(Icons.refresh),
      ),
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

## Advanced Controller Patterns

### Controller with Search

```dart
class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});

  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allUsers = await repository.getUsers();
      _applySearch();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}
```

### Controller with Pagination

```dart
class PostsController extends ChangeNotifier {
  final PostRepository repository;

  PostsController({required this.repository});

  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _page = 1;
  bool _hasMore = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasMore => _hasMore;

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    _page = 1;
    notifyListeners();

    try {
      _posts = await repository.getPosts();
      _hasMore = _posts.length >= 10;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _page++;
      final newPosts = await repository.getPosts(); // Add pagination params
      _posts.addAll(newPosts);
      _hasMore = newPosts.length >= 10;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
```

---

## Folder Structure

```
lib/
├── models/
│   ├── user.dart              # User model
│   └── post.dart              # Post model
│
├── services/
│   └── api_client.dart        # HTTP requests
│
├── repositories/
│   ├── user_repository.dart   # User data access
│   └── post_repository.dart   # Post data access
│
├── controllers/
│   ├── users_controller.dart  # User state management
│   └── posts_controller.dart  # Post state management
│
├── screens/
│   ├── users_screen.dart      # Users UI
│   └── posts_screen.dart      # Posts UI
│
├── injection.dart             # Service locator
│
└── main.dart                  # App entry point
```

---

## Testing Controllers

```dart
import 'package:test/test.dart';

void main() {
  group('UsersController', () {
    late UsersController controller;
    late MockUserRepository mockRepo;

    setUp(() {
      mockRepo = MockUserRepository();
      controller = UsersController(repository: mockRepo);
    });

    test('should load users successfully', () async {
      // Act
      await controller.loadUsers();

      // Assert
      expect(controller.users.length, 1);
      expect(controller.users[0].name, 'Test User');
      expect(controller.isLoading, false);
      expect(controller.hasError, false);
    });

    test('should handle errors', () async {
      // Arrange
      mockRepo.shouldFail = true;

      // Act
      await controller.loadUsers();

      // Assert
      expect(controller.users.isEmpty, true);
      expect(controller.isLoading, false);
      expect(controller.hasError, true);
    });

    test('should add user', () async {
      // Arrange
      final newUser = User(id: 0, name: 'New', email: 'new@test.com');

      // Act
      final success = await controller.addUser(newUser);

      // Assert
      expect(success, true);
      expect(controller.users.length, 1);
    });
  });
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                SERVICE LAYER SUMMARY                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   CONTROLLER (State Management):                             │
│   • Uses Repository to fetch data                            │
│   • Tracks loading, error, and data states                   │
│   • Extends ChangeNotifier                                   │
│   • Calls notifyListeners() to update UI                     │
│                                                              │
│   DEPENDENCY INJECTION:                                      │
│   • ServiceLocator pattern                                   │
│   • Creates and manages instances                            │
│   • Injects dependencies through constructors                │
│   • Makes testing possible                                   │
│                                                              │
│   INTEGRATION WITH UI:                                       │
│   • Direct: addListener() / removeListener()                 │
│   • Provider: ChangeNotifierProvider + Consumer              │
│   • Riverpod: StateNotifierProvider                          │
│                                                              │
│   ADVANCED PATTERNS:                                         │
│   • Search and filtering                                     │
│   • Pagination                                               │
│   • Caching                                                  │
│   • Offline support                                          │
│                                                              │
│   KEY BENEFITS:                                              │
│   ✓ Separation of concerns                                   │
│   ✓ Easy to test                                             │
│   ✓ Reusable across screens                                  │
│   ✓ Clean architecture                                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In the full flow, who does the controller ask for data, and who does the repository ask?

<details>
<summary>Answer</summary>
The controller asks the repository; the repository asks the API client. Each layer only talks to the one below it.
</details>

**Q2.** What does a service locator (DI container) do?

<details>
<summary>Answer</summary>
It creates each layer once and injects its dependencies (API client into repository, repository into controller), so you do not build them by hand everywhere.
</details>

**Q3.** Why does injecting the repository into the controller make testing easy?

<details>
<summary>Answer</summary>
You can inject a mock repository in tests, so the controller runs with fake data and no real network.
</details>

---

## Assignment

### Problem 1: Trace the flow

The user taps "Load". List the four layers the call passes through, in order, to fetch users.

### Problem 2: Wire it up

Using the service locator pattern, write the getter for `userRepository` that injects the `apiClient`.

### Problem 3: Why inject?

A controller does `final repo = UserRepositoryImpl(apiClient: ApiClient(...));` inside itself. Why is injecting the repository from outside better?

---

## Assignment Answers

### Problem 1: Trace the flow

Widget/Screen → Controller → Repository → API Client (which calls the server). The data then flows back up the same chain.

### Problem 2: Wire it up

```dart
UserRepository get userRepository {
  _userRepository ??= UserRepositoryImpl(apiClient: apiClient);
  return _userRepository!;
}
```

### Problem 3: Why inject?

If the controller builds its own repository, you can never swap it (for tests or a different data source). Injecting it lets you pass a mock in tests and a real one in the app, with the same controller code.

---

## Navigation

⬅️ **Previous:** [Widgets Deep Dive](09e-WidgetsDeepDive.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Dependency Injection](09g-DependencyInjection.md)
