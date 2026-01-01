# Riverpod Pro Patterns: Production-Ready Code

Now let's learn the tools and patterns that professional Flutter developers use with Riverpod!

---

## What You'll Learn

This lesson covers:
1. **AutoDispose** - Memory management (when to clean up providers)
2. **Freezed Package** - Immutable state classes with less boilerplate
3. **Riverpod Generator** - Code generation for cleaner providers
4. **Custom Lints** - Catch mistakes before they happen

---

## Part 1: AutoDispose Deep Dive

### What Is AutoDispose?

By default, Riverpod keeps providers alive **forever**. This means:
- Data stays in memory even when you leave a screen
- Good for caching, but can waste memory

`autoDispose` tells Riverpod: "Clean this up when no one is watching."

### The Problem Without AutoDispose

```dart
// Without autoDispose - stays in memory FOREVER
final userDetailProvider = FutureProvider<UserDetail>((ref) async {
  return await fetchUserDetail();  // Fetched once, never cleaned up!
});
```

**What happens:**
```
Screen A loads → fetches user detail → stores in memory
User goes to Screen B
User goes to Screen C
...
Memory still holds user detail from Screen A!
```

### The Solution: AutoDispose

```dart
// With autoDispose - cleans up when not watched
final userDetailProvider = FutureProvider.autoDispose<UserDetail>((ref) async {
  return await fetchUserDetail();
});
```

**What happens now:**
```
Screen A loads → fetches user detail → stores in memory
User leaves Screen A
No one watching → provider disposed → memory freed!
```

### When to Use vs Not Use AutoDispose

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   ✅ USE autoDispose when:                                  │
│   ─────────────────────────                                 │
│   • Screen-specific data (user profile page)                │
│   • Search results (changes every search)                   │
│   • Form data (specific to one form)                        │
│   • WebSocket connections (close when done)                 │
│   • Paginated lists (refresh on return)                     │
│                                                             │
│   ❌ DON'T use autoDispose when:                            │
│   ─────────────────────────────                             │
│   • User authentication (need it everywhere)                │
│   • App settings (theme, language)                          │
│   • Shopping cart (persists across screens)                 │
│   • Data shared by many screens                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Real Examples

```dart
// ✅ Good: Search results - different every time
final searchResultsProvider = FutureProvider.autoDispose
    .family<List<Product>, String>((ref, query) async {
  return await searchProducts(query);
});

// ✅ Good: Post detail - specific to one post
final postDetailProvider = FutureProvider.autoDispose
    .family<Post, String>((ref, postId) async {
  return await fetchPost(postId);
});

// ❌ Don't use autoDispose: Current user - needed everywhere
final currentUserProvider = FutureProvider<User>((ref) async {
  return await getCurrentUser();
});

// ❌ Don't use autoDispose: Cart - persists across app
final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});
```

### Keeping AutoDispose Alive Temporarily

Sometimes you want autoDispose but also want to keep data for a bit (like caching):

```dart
final productProvider = FutureProvider.autoDispose<Product>((ref) async {
  // Method 1: Keep alive until manually closed
  final link = ref.keepAlive();

  // Close after 30 seconds (then can be disposed)
  Timer(Duration(seconds: 30), () {
    link.close();
  });

  return await fetchProduct();
});
```

**Another pattern - Cache with timeout:**

```dart
final cachedDataProvider = FutureProvider.autoDispose<Data>((ref) async {
  // Keep alive for 5 minutes after last listener
  final link = ref.keepAlive();

  ref.onDispose(() {
    print('Provider disposed - memory freed!');
  });

  // Cancel keepAlive after 5 minutes
  final timer = Timer(Duration(minutes: 5), link.close);

  // Cancel timer if provider is disposed early
  ref.onDispose(timer.cancel);

  return await fetchData();
});
```

### Combining AutoDispose with Family

```dart
// autoDispose + family = most common pattern
final userProvider = FutureProvider.autoDispose.family<User, String>(
  (ref, userId) async {
    return await fetchUser(userId);
  },
);

// Usage
class UserScreen extends ConsumerWidget {
  final String userId;

  const UserScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Each userId gets its own provider instance
    // Cleaned up when this screen is closed
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
      data: (user) => Text('Hello, ${user.name}'),
    );
  }
}
```

---

## Part 2: Freezed Package

### What Is Freezed?

Freezed is a code generator that creates **immutable** data classes with:
- `copyWith` method (create modified copies)
- `==` equality (compare objects)
- `toString` (debug printing)
- JSON serialization (with json_serializable)
- Union types (like sealed classes)

### Why Use Freezed?

**Without Freezed (lots of boilerplate):**

```dart
class User {
  final String id;
  final String name;
  final int age;
  final String? email;

  const User({
    required this.id,
    required this.name,
    required this.age,
    this.email,
  });

  // Need to write copyWith manually
  User copyWith({
    String? id,
    String? name,
    int? age,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }

  // Need to write equality manually
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.age == age &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ age.hashCode ^ email.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, age: $age, email: $email)';

  // JSON serialization...even more code!
}
```

**With Freezed (clean and simple):**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';  // For JSON serialization

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required int age,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**That's it!** Freezed generates all the boilerplate for you.

### Setting Up Freezed

**Step 1: Add dependencies to pubspec.yaml:**

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
```

**Step 2: Run flutter pub get:**

```bash
flutter pub get
```

**Step 3: Create your model:**

```dart
// lib/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required int age,
    @Default('') String email,  // Default value
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Step 4: Generate the code:**

```bash
# Run once
dart run build_runner build

# Or watch for changes (recommended during development)
dart run build_runner watch
```

### Using Freezed Classes

```dart
// Create
final user = User(id: '1', name: 'John', age: 25);

// Copy with changes (immutable update)
final olderUser = user.copyWith(age: 26);
print(user.age);      // 25 (original unchanged)
print(olderUser.age); // 26 (new copy)

// Equality works!
final user1 = User(id: '1', name: 'John', age: 25);
final user2 = User(id: '1', name: 'John', age: 25);
print(user1 == user2); // true!

// JSON serialization
final json = user.toJson();
final fromJson = User.fromJson(json);
```

### Freezed with Riverpod State

**Perfect for immutable state!**

```dart
// State class with Freezed
@freezed
class TodoState with _$TodoState {
  const factory TodoState({
    @Default([]) List<Todo> todos,
    @Default(false) bool isLoading,
    String? error,
  }) = _TodoState;
}

// Todo item with Freezed
@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;
}

// StateNotifier using Freezed state
class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(const TodoState());

  void addTodo(String title) {
    state = state.copyWith(
      todos: [
        ...state.todos,
        Todo(id: DateTime.now().toString(), title: title),
      ],
    );
  }

  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList(),
    );
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final todos = await fetchTodosFromApi();
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

### Freezed Union Types (Sealed Classes)

Great for representing different states:

```dart
@freezed
class AuthState with _$AuthState {
  // Different states for authentication
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// Usage in widget
class AuthWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Pattern matching with .when or .map
    return authState.when(
      initial: () => SplashScreen(),
      loading: () => LoadingScreen(),
      authenticated: (user) => HomeScreen(user: user),
      unauthenticated: () => LoginScreen(),
      error: (message) => ErrorScreen(message: message),
    );
  }
}
```

---

## Part 3: Riverpod Generator

### What Is Riverpod Generator?

Instead of writing providers manually, you write regular functions and the generator creates providers for you!

### Why Use It?

**Without generator (verbose):**

```dart
final userProvider = FutureProvider.autoDispose.family<User, String>(
  (ref, userId) async {
    final repository = ref.watch(userRepositoryProvider);
    return repository.getUser(userId);
  },
);
```

**With generator (clean):**

```dart
@riverpod
Future<User> user(UserRef ref, String userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(userId);
}
// Generates: userProvider automatically!
```

### Setting Up Riverpod Generator

**Step 1: Add dependencies:**

```yaml
dependencies:
  riverpod_annotation: ^2.3.5
  flutter_riverpod: ^2.4.10

dev_dependencies:
  build_runner: ^2.4.8
  riverpod_generator: ^2.4.0
```

**Step 2: Create providers with annotations:**

```dart
// lib/providers/user_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

// Simple provider (no parameters)
@riverpod
String greeting(GreetingRef ref) {
  return 'Hello, World!';
}
// Generates: greetingProvider

// Async provider
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  return await fetchCurrentUser();
}
// Generates: currentUserProvider (FutureProvider)

// Provider with parameters (family)
@riverpod
Future<User> user(UserRef ref, String userId) async {
  return await fetchUser(userId);
}
// Generates: userProvider (FutureProvider.family)
```

**Step 3: Generate:**

```bash
dart run build_runner watch
```

### Generator Patterns

**1. Simple Value Provider:**

```dart
@riverpod
int counter(CounterRef ref) {
  return 0;
}
// Same as: final counterProvider = Provider<int>((ref) => 0);
```

**2. Async Provider (API calls):**

```dart
@riverpod
Future<List<Product>> products(ProductsRef ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getProducts();
}
```

**3. Provider with Parameters:**

```dart
@riverpod
Future<Product> productById(ProductByIdRef ref, int id) async {
  final api = ref.watch(apiServiceProvider);
  return api.getProduct(id);
}

// Usage: ref.watch(productByIdProvider(123))
```

**4. Class-Based Notifier (for mutable state):**

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;  // Initial value

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// Usage:
// ref.watch(counterProvider) - get value
// ref.read(counterProvider.notifier).increment() - call method
```

**5. Async Notifier:**

```dart
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    return await fetchTodos();
  }

  Future<void> addTodo(String title) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await saveTodo(title);
      return await fetchTodos();
    });
  }
}
```

### AutoDispose with Generator

```dart
// keepAlive: false means autoDispose (default for most providers)
@Riverpod(keepAlive: false)
Future<User> userDetail(UserDetailRef ref, String id) async {
  return await fetchUserDetail(id);
}

// keepAlive: true means NO autoDispose (stays in memory)
@Riverpod(keepAlive: true)
Future<User> currentUser(CurrentUserRef ref) async {
  return await getCurrentUser();
}
```

---

## Part 4: Custom Lints

### What Are Custom Lints?

Lints are rules that catch mistakes in your code. Riverpod has its own lint package that catches common Riverpod mistakes!

### Setting Up riverpod_lint

**Step 1: Add to pubspec.yaml:**

```yaml
dev_dependencies:
  riverpod_lint: ^2.3.10
  custom_lint: ^0.6.4
```

**Step 2: Create analysis_options.yaml** (if not exists):

```yaml
analyzer:
  plugins:
    - custom_lint
```

**Step 3: Restart your IDE**

### What Riverpod Lint Catches

**1. Using ref.watch in callbacks (BAD):**

```dart
// ❌ WRONG - lint will warn you!
ElevatedButton(
  onPressed: () {
    final count = ref.watch(counterProvider);  // DON'T watch in callbacks!
    print(count);
  },
  child: Text('Print'),
)

// ✅ CORRECT
ElevatedButton(
  onPressed: () {
    final count = ref.read(counterProvider);  // Use read in callbacks
    print(count);
  },
  child: Text('Print'),
)
```

**2. Missing ProviderScope:**

```dart
// ❌ WRONG - lint warns you!
void main() {
  runApp(MyApp());  // Missing ProviderScope!
}

// ✅ CORRECT
void main() {
  runApp(ProviderScope(child: MyApp()));
}
```

**3. Provider naming conventions:**

```dart
// ❌ WRONG - should end with "Provider"
final counter = StateProvider<int>((ref) => 0);

// ✅ CORRECT
final counterProvider = StateProvider<int>((ref) => 0);
```

**4. Unused providers:**

```dart
// Lint warns if you define a provider but never use it
final unusedProvider = Provider((ref) => 'unused');  // Warning!
```

### Custom Lint Rules You Can Enable

In `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Require all providers to use autoDispose (optional)
    - riverpod_final_provider

    # Warn about stateful widgets that could be ConsumerWidget
    - stateless_ref

    # Ensure provider dependencies are correct
    - provider_dependencies
```

---

## Complete Example: Todo App with All Patterns

```dart
// ─────────────────────────────────────
// models/todo.dart - Using Freezed
// ─────────────────────────────────────

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool completed,
    DateTime? createdAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

@freezed
class TodoFilter with _$TodoFilter {
  const factory TodoFilter.all() = _All;
  const factory TodoFilter.completed() = _Completed;
  const factory TodoFilter.pending() = _Pending;
}

// ─────────────────────────────────────
// providers/todo_provider.dart - Using Generator
// ─────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_provider.g.dart';

// Filter state
@riverpod
class Filter extends _$Filter {
  @override
  TodoFilter build() => const TodoFilter.all();

  void setFilter(TodoFilter filter) => state = filter;
}

// Todo list with async operations
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    // Fetch initial todos
    return await _fetchTodos();
  }

  Future<List<Todo>> _fetchTodos() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return [];
  }

  Future<void> add(String title) async {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
      createdAt: DateTime.now(),
    );

    // Optimistic update
    state = AsyncValue.data([
      ...state.value ?? [],
      newTodo,
    ]);

    // Save to server (in real app)
    // await _saveTodo(newTodo);
  }

  void toggle(String id) {
    state = state.whenData((todos) {
      return todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList();
    });
  }

  void remove(String id) {
    state = state.whenData((todos) {
      return todos.where((t) => t.id != id).toList();
    });
  }
}

// Filtered todos (computed)
@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final filter = ref.watch(filterProvider);
  final todosAsync = ref.watch(todoListProvider);

  return todosAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (todos) {
      return filter.when(
        all: () => todos,
        completed: () => todos.where((t) => t.completed).toList(),
        pending: () => todos.where((t) => !t.completed).toList(),
      );
    },
  );
}

// Stats (computed)
@riverpod
({int total, int completed, int pending}) todoStats(TodoStatsRef ref) {
  final todosAsync = ref.watch(todoListProvider);

  return todosAsync.when(
    loading: () => (total: 0, completed: 0, pending: 0),
    error: (_, __) => (total: 0, completed: 0, pending: 0),
    data: (todos) => (
      total: todos.length,
      completed: todos.where((t) => t.completed).length,
      pending: todos.where((t) => !t.completed).length,
    ),
  );
}

// ─────────────────────────────────────
// screens/todo_screen.dart
// ─────────────────────────────────────

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    final filteredTodos = ref.watch(filteredTodosProvider);
    final stats = ref.watch(todoStatsProvider);
    final currentFilter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Pro Todos')),
      body: Column(
        children: [
          // Stats
          _StatsBar(stats: stats),

          // Filter chips
          _FilterChips(
            current: currentFilter,
            onChanged: (f) => ref.read(filterProvider.notifier).setFilter(f),
          ),

          // List
          Expanded(
            child: todosAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
              data: (_) => filteredTodos.isEmpty
                  ? Center(child: Text('No todos'))
                  : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (_, i) => _TodoTile(
                        todo: filteredTodos[i],
                        onToggle: () => ref
                            .read(todoListProvider.notifier)
                            .toggle(filteredTodos[i].id),
                        onDelete: () => ref
                            .read(todoListProvider.notifier)
                            .remove(filteredTodos[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(todoListProvider.notifier).add(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **autoDispose** | Clean up providers when not used | Screen-specific data, search results |
| **keepAlive** | Keep autoDispose alive temporarily | Caching with timeout |
| **Freezed** | Generate immutable data classes | All your models and state classes |
| **riverpod_generator** | Generate providers from functions | All new providers (cleaner code) |
| **riverpod_lint** | Catch common mistakes | Always enable in your project! |

---

## Quick Reference

### Package Setup

```yaml
dependencies:
  flutter_riverpod: ^2.4.10
  riverpod_annotation: ^2.3.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.8
  riverpod_generator: ^2.4.0
  riverpod_lint: ^2.3.10
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  custom_lint: ^0.6.4
```

### Build Commands

```bash
# Generate once
dart run build_runner build

# Watch for changes (recommended)
dart run build_runner watch

# Delete old generated files first (if issues)
dart run build_runner build --delete-conflicting-outputs
```

---

## Quick Quiz

**Q1:** When should you NOT use autoDispose?

<details>
<summary>Answer</summary>

Don't use autoDispose for:
- User authentication state (needed everywhere)
- App-wide settings (theme, language)
- Shopping cart (persists across screens)
- Any data that should be cached across the app

</details>

**Q2:** What does Freezed give you that you'd have to write manually otherwise?

<details>
<summary>Answer</summary>

Freezed generates:
- `copyWith` method
- `==` equality operator
- `hashCode`
- `toString`
- JSON serialization (with json_serializable)
- Union types / sealed classes

</details>

**Q3:** What's the difference between `@riverpod` and `@Riverpod(keepAlive: true)`?

<details>
<summary>Answer</summary>

- `@riverpod` - Uses autoDispose by default (cleaned up when not watched)
- `@Riverpod(keepAlive: true)` - Provider stays alive forever (no autoDispose)

</details>

---

**These pro patterns are what separate beginner Riverpod code from production-ready code!**

---

**Continue to:** `06-BlocBasics.md`
