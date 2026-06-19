# Controllers Deep Dive

## The Big Idea In One Sentence

> A controller holds a feature's state (the list, isLoading, error) and the actions that change it, calling `notifyListeners()` so the UI rebuilds, which keeps your widgets small and your logic testable.

Learn what controllers are, why we need them, and how to build them properly.

---

## What is a Controller?

A **Controller** is a class that manages the STATE of a feature. It sits between your UI (widgets) and your data (repository).

```
WITHOUT CONTROLLER:
Everything mixed in the widget

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUsers() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(...);
      final json = jsonDecode(response.body);
      setState(() {
        users = json.map((j) => User.fromJson(j)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  // ... 200 more lines of widget code
}

PROBLEMS:
- Widget is HUGE (state + logic + UI)
- Can't reuse logic in other screens
- Hard to test (need to test whole widget)
- Hard to understand


WITH CONTROLLER:
State management separated

// Controller handles state
class UsersController extends ChangeNotifier {
  List<User> users = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUsers() async { ... }
}

// Widget is clean
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersController>(
      builder: (context, controller, _) {
        if (controller.isLoading) return LoadingWidget();
        return UsersList(users: controller.users);
      },
    );
  }
}

BENEFITS:
- Widget is small (just UI)
- Logic is reusable
- Easy to test controller separately
- Easy to understand
```

---

## Controller Responsibilities

```
WHAT A CONTROLLER DOES:
───────────────────────

1. HOLDS STATE
   - The current list of items
   - Loading status (true/false)
   - Error messages
   - Selected item
   - Search query
   - Pagination info

2. PROVIDES ACTIONS
   - loadData()
   - addItem()
   - deleteItem()
   - search()
   - refresh()

3. NOTIFIES UI OF CHANGES
   - Calls notifyListeners() when state changes
   - UI rebuilds automatically


WHAT A CONTROLLER DOES NOT DO:
──────────────────────────────

1. NOT HTTP REQUESTS
   - Uses repository for that

2. NOT UI BUILDING
   - No Widget, Card, Text, etc.

3. NOT NAVIGATION
   - UI handles navigation

4. NOT DATA PARSING
   - Repository handles that
```

---

## Basic Controller Structure

```dart
import 'package:flutter/foundation.dart';

class UsersController extends ChangeNotifier {
  // DEPENDENCY - injected through constructor
  final UserRepository repository;

  UsersController({required this.repository});

  // STATE - private variables
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  // GETTERS - read-only access to state
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isEmpty => _users.isEmpty && !_isLoading && !hasError;

  // ACTIONS - methods that change state

  /// Load all users
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();  // Tell UI: "I'm loading"

    try {
      _users = await repository.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();  // Tell UI: "I'm done"
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

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

---

## Why Private Variables + Getters?

```dart
// BAD: Public variables
class UsersController extends ChangeNotifier {
  List<User> users = [];  // Anyone can modify directly!
  bool isLoading = false;
}

// Problem: Widget can do this
controller.users.clear();  // Modifies without notifyListeners!
controller.isLoading = true;  // No notification!


// GOOD: Private variables + getters
class UsersController extends ChangeNotifier {
  List<User> _users = [];  // Private
  bool _isLoading = false;  // Private

  List<User> get users => _users;  // Read-only access
  bool get isLoading => _isLoading;  // Read-only access

  // Only this method can modify users
  void addUser(User user) {
    _users.add(user);
    notifyListeners();  // Always notifies!
  }
}

// Widget can only read, not modify directly
print(controller.users);  // OK - reading
controller.users.clear();  // Still modifies the list, but...
// Better: return unmodifiable list
List<User> get users => List.unmodifiable(_users);
```

---

## Controller Patterns

### Pattern 1: Search Controller

```dart
class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});

  List<User> _allUsers = [];      // All users from API
  List<User> _filteredUsers = []; // After search filter
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allUsers = await repository.getUsers();
      _applySearch();  // Apply current search
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
      _filteredUsers = _allUsers.where((user) {
        final q = _searchQuery.toLowerCase();
        return user.name.toLowerCase().contains(q) ||
               user.email.toLowerCase().contains(q);
      }).toList();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredUsers = _allUsers;
    notifyListeners();
  }
}
```

### Pattern 2: Pagination Controller

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
  static const int _pageSize = 20;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;

  /// Initial load
  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    _page = 1;
    _hasMore = true;
    notifyListeners();

    try {
      _posts = await repository.getPosts(page: _page, limit: _pageSize);
      _hasMore = _posts.length >= _pageSize;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _page++;
      final newPosts = await repository.getPosts(page: _page, limit: _pageSize);
      _posts.addAll(newPosts);
      _hasMore = newPosts.length >= _pageSize;
    } catch (e) {
      _error = e.toString();
      _page--;  // Revert page on error
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Pull to refresh
  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;

    try {
      _posts = await repository.getPosts(page: _page, limit: _pageSize);
      _hasMore = _posts.length >= _pageSize;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
}
```

### Pattern 3: Selection Controller

```dart
class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});

  List<User> _users = [];
  Set<int> _selectedIds = {};  // IDs of selected users
  bool _isLoading = false;
  bool _isSelectionMode = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selectedIds.length;
  bool get hasSelection => _selectedIds.isNotEmpty;

  bool isSelected(int userId) => _selectedIds.contains(userId);

  List<User> get selectedUsers =>
      _users.where((u) => _selectedIds.contains(u.id)).toList();

  void toggleSelection(int userId) {
    if (_selectedIds.contains(userId)) {
      _selectedIds.remove(userId);
    } else {
      _selectedIds.add(userId);
    }

    // Exit selection mode if nothing selected
    if (_selectedIds.isEmpty) {
      _isSelectionMode = false;
    }

    notifyListeners();
  }

  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    _selectedIds.clear();
    notifyListeners();
  }

  void selectAll() {
    _selectedIds = _users.map((u) => u.id).toSet();
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    for (final id in _selectedIds) {
      await repository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
    }
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }
}
```

### Pattern 4: Form Controller

```dart
class CreateUserController extends ChangeNotifier {
  final UserRepository repository;

  CreateUserController({required this.repository});

  String _name = '';
  String _email = '';
  bool _isSubmitting = false;
  String? _error;
  String? _nameError;
  String? _emailError;

  String get name => _name;
  String get email => _email;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  String? get nameError => _nameError;
  String? get emailError => _emailError;

  bool get isValid =>
      _name.isNotEmpty &&
      _email.isNotEmpty &&
      _nameError == null &&
      _emailError == null;

  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _validateEmail();
    notifyListeners();
  }

  void _validateName() {
    if (_name.isEmpty) {
      _nameError = 'Name is required';
    } else if (_name.length < 2) {
      _nameError = 'Name must be at least 2 characters';
    } else {
      _nameError = null;
    }
  }

  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = 'Email is required';
    } else if (!_email.contains('@')) {
      _emailError = 'Invalid email format';
    } else {
      _emailError = null;
    }
  }

  Future<User?> submit() async {
    _validateName();
    _validateEmail();
    notifyListeners();

    if (!isValid) return null;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final user = User(id: 0, name: _name, email: _email);
      final created = await repository.createUser(user);
      _isSubmitting = false;
      notifyListeners();
      return created;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _name = '';
    _email = '';
    _error = null;
    _nameError = null;
    _emailError = null;
    _isSubmitting = false;
    notifyListeners();
  }
}
```

---

## Using Controllers with Provider

```dart
// Setup in main.dart or app.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersController(repository: sl.userRepository)
            ..loadUsers(),  // Load immediately
        ),
        ChangeNotifierProvider(
          create: (_) => PostsController(repository: sl.postRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// In widget - read controller
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError) {
          return ErrorWidget(
            message: controller.error!,
            onRetry: controller.loadUsers,
          );
        }

        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return UserCard(user: user);
          },
        );
      },
    );
  }
}

// In widget - call actions
IconButton(
  icon: const Icon(Icons.refresh),
  onPressed: () {
    context.read<UsersController>().loadUsers();
  },
)
```

---

## Using Controllers with Riverpod

```dart
// Define provider
final usersControllerProvider = ChangeNotifierProvider<UsersController>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UsersController(repository: repository)..loadUsers();
});

// In widget
class UsersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(usersControllerProvider);

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
        return UserCard(user: user);
      },
    );
  }
}

// Call actions
ref.read(usersControllerProvider).loadUsers();
```

---

## Testing Controllers

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsersController', () {
    late UsersController controller;
    late MockUserRepository mockRepo;

    setUp(() {
      mockRepo = MockUserRepository();
      controller = UsersController(repository: mockRepo);
    });

    test('initial state is correct', () {
      expect(controller.users, isEmpty);
      expect(controller.isLoading, false);
      expect(controller.error, null);
    });

    test('loadUsers sets loading state', () async {
      // Start loading
      final future = controller.loadUsers();

      // Should be loading
      expect(controller.isLoading, true);

      // Wait for completion
      await future;

      // Should not be loading anymore
      expect(controller.isLoading, false);
    });

    test('loadUsers populates users on success', () async {
      await controller.loadUsers();

      expect(controller.users.length, 2);
      expect(controller.users[0].name, 'Test User 1');
      expect(controller.error, null);
    });

    test('loadUsers sets error on failure', () async {
      mockRepo.shouldFail = true;

      await controller.loadUsers();

      expect(controller.users, isEmpty);
      expect(controller.error, isNotNull);
    });

    test('addUser adds to list', () async {
      await controller.loadUsers();
      final initialCount = controller.users.length;

      final newUser = User(id: 0, name: 'New', email: 'new@test.com');
      await controller.addUser(newUser);

      expect(controller.users.length, initialCount + 1);
    });

    test('deleteUser removes from list', () async {
      await controller.loadUsers();
      final userId = controller.users.first.id;

      await controller.deleteUser(userId);

      expect(controller.users.any((u) => u.id == userId), false);
    });
  });
}

// Mock repository for testing
class MockUserRepository implements UserRepository {
  bool shouldFail = false;

  @override
  Future<List<User>> getUsers() async {
    if (shouldFail) throw Exception('Failed');
    return [
      User(id: 1, name: 'Test User 1', email: 'test1@test.com'),
      User(id: 2, name: 'Test User 2', email: 'test2@test.com'),
    ];
  }

  @override
  Future<User> createUser(User user) async {
    if (shouldFail) throw Exception('Failed');
    return User(id: 99, name: user.name, email: user.email);
  }

  @override
  Future<void> deleteUser(int id) async {
    if (shouldFail) throw Exception('Failed');
  }

  // ... other methods
}
```

---

## Common Mistakes

```
MISTAKE 1: HTTP calls in controller
───────────────────────────────────
// WRONG
class UsersController {
  Future<void> loadUsers() async {
    final response = await http.get(...);  // NO!
  }
}

// RIGHT
class UsersController {
  final UserRepository repository;

  Future<void> loadUsers() async {
    _users = await repository.getUsers();  // Use repository
  }
}


MISTAKE 2: Building widgets in controller
─────────────────────────────────────────
// WRONG
class UsersController {
  Widget buildUserCard(User user) {  // NO!
    return Card(child: Text(user.name));
  }
}

// RIGHT
// Controllers don't know about widgets
// Widget handles UI, controller handles state


MISTAKE 3: Forgetting notifyListeners
────────────────────────────────────
// WRONG
class UsersController extends ChangeNotifier {
  void addUser(User user) {
    _users.add(user);
    // Forgot notifyListeners! UI won't update
  }
}

// RIGHT
class UsersController extends ChangeNotifier {
  void addUser(User user) {
    _users.add(user);
    notifyListeners();  // UI will update
  }
}


MISTAKE 4: Public mutable state
───────────────────────────────
// WRONG
class UsersController extends ChangeNotifier {
  List<User> users = [];  // Anyone can modify!
}

// RIGHT
class UsersController extends ChangeNotifier {
  List<User> _users = [];
  List<User> get users => List.unmodifiable(_users);
}
```

---

## Summary

```
CONTROLLER SUMMARY:
───────────────────

WHAT IT IS:
A class that manages state for a feature

WHAT IT DOES:
- Holds state (users, loading, error)
- Provides actions (load, add, delete)
- Notifies UI when state changes

STRUCTURE:
class MyController extends ChangeNotifier {
  // Dependency
  final MyRepository repository;

  // Private state
  List<Item> _items = [];
  bool _isLoading = false;

  // Public getters
  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  // Actions
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await repository.getItems();
    _isLoading = false;
    notifyListeners();
  }
}

COMMON PATTERNS:
- Search/Filter controller
- Pagination controller
- Selection controller
- Form controller

KEY RULES:
- Use repository for data access
- Keep state private, expose via getters
- Always call notifyListeners() after changes
- Don't build widgets in controllers
```

---

## Quick Quiz

**Q1.** What does a controller call so the UI rebuilds after state changes?

<details>
<summary>Answer</summary>
`notifyListeners()` (it extends `ChangeNotifier`).
</details>

**Q2.** Why keep state in private fields (`_users`) with public getters?

<details>
<summary>Answer</summary>
So nothing outside can change the state without going through a method that also calls `notifyListeners()`. Outsiders can read, not secretly mutate.
</details>

**Q3.** How does a controller fetch data without making HTTP calls itself?

<details>
<summary>Answer</summary>
It calls a repository (e.g. `repository.getUsers()`). The repository handles the network and parsing.
</details>

---

## Assignment

### Problem 1: The load action

Write a `loadUsers()` that sets loading true + notifies, fetches from `repository`, stores the result, then sets loading false + notifies (use try/finally).

### Problem 2: Find the bug

```dart
void addUser(User user) {
  _users.add(user);
}
```
The list grows but the screen never updates. What is missing?

### Problem 3: Why testable?

Why is a controller easier to test than the same logic stuffed inside a widget?

---

## Assignment Answers

### Problem 1: The load action

```dart
Future<void> loadUsers() async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  try {
    _users = await repository.getUsers();
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### Problem 2: Find the bug

It is missing `notifyListeners();` after `_users.add(user)`. Without it, the UI never hears about the change.

### Problem 3: Why testable?

A controller is plain Dart with a fake repository, so you can call its methods and check its state in a unit test, with no widgets, no `pumpWidget`, and no real network.

---

## Navigation

Previous: [Repository Pattern](09c-RepositoryPattern.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Widgets Deep Dive](09e-WidgetsDeepDive.md)
