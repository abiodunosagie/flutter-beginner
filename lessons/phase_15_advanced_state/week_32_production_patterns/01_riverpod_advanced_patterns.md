# Riverpod Advanced Patterns: Production-Ready State Management

## What You'll Learn

- Code generation with Riverpod
- AsyncNotifier for async state
- Family modifiers for parameters
- Testing providers
- State persistence
- Best practices for large apps

## Setup

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

dev_dependencies:
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.6
```

## Code Generation (Recommended)

### Why Code Generation?

✅ Type-safe
✅ Less boilerplate
✅ Auto-dispose
✅ Better DX (developer experience)

### Basic Provider with Code Generation

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// Simple value provider
@riverpod
String greeting(GreetingRef ref) {
  return 'Hello, World!';
}

// Async provider (Future)
@riverpod
Future<User> user(UserRef ref, String userId) async {
  return await api.fetchUser(userId);
}

// Stream provider
@riverpod
Stream<List<Message>> messages(MessagesRef ref) {
  return firestore.collection('messages').snapshots().map(...);
}
```

Generate code:
```bash
flutter pub run build_runner watch
# Or one-time:
flutter pub run build_runner build
```

### Stateful Provider (Notifier)

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;  // Initial state

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// Usage
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

## AsyncNotifier for Async State

### Complete Todo Example

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_provider.g.dart';

// Model
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Async state notifier
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    // Initial load from API/database
    return await _fetchTodos();
  }

  Future<List<Todo>> _fetchTodos() async {
    await Future.delayed(Duration(seconds: 1));  // Simulate API
    return [
      Todo(id: '1', title: 'Learn Flutter'),
      Todo(id: '2', title: 'Build App'),
    ];
  }

  Future<void> addTodo(String title) async {
    // Optimistic update
    state = AsyncData([
      ...state.value!,
      Todo(id: DateTime.now().toString(), title: title),
    ]);

    try {
      // API call
      await api.addTodo(title);
    } catch (e) {
      // Revert on error
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> toggleTodo(String id) async {
    state = AsyncData(
      state.value!.map((todo) {
        return todo.id == id
            ? todo.copyWith(isCompleted: !todo.isCompleted)
            : todo;
      }).toList(),
    );

    try {
      await api.toggleTodo(id);
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    state = AsyncData(
      state.value!.where((todo) => todo.id != id).toList(),
    );

    try {
      await api.deleteTodo(id);
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }
}

// UI
class TodoListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Todos')),
      body: todosAsync.when(
        data: (todos) {
          if (todos.isEmpty) {
            return Center(child: Text('No todos yet!'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) {
                    ref.read(todoListProvider.notifier).toggleTodo(todo.id);
                  },
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    ref.read(todoListProvider.notifier).deleteTodo(todo.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
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
      builder: (context) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter todo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(todoListProvider.notifier).addTodo(controller.text);
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

## Family Modifiers (Parameters)

```dart
// Provider that takes parameters
@riverpod
Future<User> user(UserRef ref, String userId) async {
  return await api.fetchUser(userId);
}

// Usage
class UserProfile extends ConsumerWidget {
  final String userId;

  UserProfile({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => Text('Name: ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (e, stack) => Text('Error: $e'),
    );
  }
}
```

## Dependent Providers

```dart
// User provider
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  return await api.getCurrentUser();
}

// Posts provider that depends on user
@riverpod
Future<List<Post>> userPosts(UserPostsRef ref) async {
  // Watch user provider
  final user = await ref.watch(currentUserProvider.future);

  // Fetch posts for this user
  return await api.fetchPosts(user.id);
}

// UI automatically updates when user changes!
```

## Testing Providers

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('Counter increments', () {
    final container = ProviderContainer();

    // Initial state
    expect(container.read(counterProvider), 0);

    // Increment
    container.read(counterProvider.notifier).increment();

    // Check new state
    expect(container.read(counterProvider), 1);

    container.dispose();
  });

  test('TodoList adds todo', () async {
    final container = ProviderContainer();

    // Wait for initial load
    await container.read(todoListProvider.future);

    // Add todo
    await container.read(todoListProvider.notifier).addTodo('Test');

    // Check state
    final todos = container.read(todoListProvider).value!;
    expect(todos.length, 3);
    expect(todos.last.title, 'Test');

    container.dispose();
  });

  test('TodoList with mock', () async {
    final container = ProviderContainer(
      overrides: [
        // Override with mock
        todoListProvider.overrideWith(() => MockTodoList()),
      ],
    );

    // Test with mock...

    container.dispose();
  });
}
```

## State Persistence

```dart
import 'package:shared_preferences/shared_preferences.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsState> build() async {
    // Load from storage
    return await _loadSettings();
  }

  Future<SettingsState> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsState(
      isDarkMode: prefs.getBool('dark_mode') ?? false,
      fontSize: prefs.getDouble('font_size') ?? 16.0,
    );
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    state = AsyncData(state.value!.copyWith(isDarkMode: value));
  }

  Future<void> setFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', value);

    state = AsyncData(state.value!.copyWith(fontSize: value));
  }
}

class SettingsState {
  final bool isDarkMode;
  final double fontSize;

  SettingsState({required this.isDarkMode, required this.fontSize});

  SettingsState copyWith({bool? isDarkMode, double? fontSize}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
```

## Best Practices

### 1. Use Code Generation

✅ Reduces boilerplate
✅ Type-safe
✅ Auto-dispose

### 2. Keep Providers Focused

```dart
// ✅ GOOD: Single responsibility
@riverpod
class UserProfile extends _$UserProfile { ... }

@riverpod
class UserPosts extends _$UserPosts { ... }

// ❌ BAD: Too many responsibilities
@riverpod
class Everything extends _$Everything { ... }
```

### 3. Handle Loading & Error States

```dart
// ✅ Always use .when()
userAsync.when(
  data: (user) => ...,
  loading: () => CircularProgressIndicator(),
  error: (e, stack) => ErrorWidget(e),
)
```

### 4. Use Optimistic Updates

```dart
// Update UI immediately, then sync with server
Future<void> likePost(String postId) async {
  // Optimistic
  state = AsyncData(state.value!.copyWith(likes: likes + 1));

  try {
    await api.likePost(postId);
  } catch (e) {
    // Revert
    ref.invalidateSelf();
  }
}
```

### 5. Organize Providers

```
lib/
  providers/
    auth_provider.dart
    user_provider.dart
    post_provider.dart
    settings_provider.dart
```

## Production App Structure

```
lib/
  models/          # Data models
    user.dart
    post.dart
  providers/       # Riverpod providers
    auth_provider.dart
    user_provider.dart
  services/        # API/database services
    api_service.dart
    db_service.dart
  screens/         # UI screens
    home_screen.dart
    profile_screen.dart
  widgets/         # Reusable widgets
    user_card.dart
  main.dart
```

## Exercises

### Exercise 1: Counter with Persistence (Beginner)
Save counter value to SharedPreferences

### Exercise 2: Shopping Cart (Intermediate)
Cart with add/remove, total calculation

### Exercise 3: Social Feed (Advanced)
Posts with likes, comments, infinite scroll

## What You've Learned

✅ Code generation with Riverpod
✅ AsyncNotifier for async state
✅ Family modifiers for parameters
✅ Testing providers
✅ State persistence
✅ Production patterns
✅ Best practices

## Congratulations!

You've completed the **complete Flutter fundamentals course**!

You now know:
- ✅ Dart fundamentals
- ✅ Flutter widgets and UI
- ✅ State management (Provider, Riverpod, BLoC)
- ✅ API integration
- ✅ Clean Architecture
- ✅ Flutter Web
- ✅ Testing
- ✅ Advanced async
- ✅ Local storage (4 methods!)
- ✅ Animations
- ✅ Navigation (GoRouter)
- ✅ Firebase
- ✅ Platform features
- ✅ App Store deployment
- ✅ Performance optimization
- ✅ Advanced state management

**You're now a production-ready Flutter developer!** 🚀

Go build amazing apps!
