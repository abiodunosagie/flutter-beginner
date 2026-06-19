# Async BLoC: Handling API Calls and Loading States

## The Big Idea In One Sentence

> For data that loads over time, a bloc emits a **loading** state, does the work, then emits either a **loaded** state (with the data) or an **error** state.

Most real apps load data from the internet. A bloc handles that with the same three states you saw with AsyncValue: loading, loaded, error.

> **Async heads-up.** This lesson uses `Future`/`async`/`await` (data that arrives later). You learn those fully in Level 8. For now: an event handler can be `async`, `await` some work, and `emit` a loading state first, then the result. Focus on the loading -> loaded/error flow.

---

## The Three Async States

When loading data, you typically have three states:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   LOADING                                           │
│   ───────                                           │
│   • Waiting for data                                │
│   • Show loading spinner                            │
│   • Pizza is being made...                          │
│                                                     │
│   ERROR                                             │
│   ─────                                             │
│   • Something went wrong                            │
│   • Show error message                              │
│   • Pizza delivery failed!                          │
│                                                     │
│   LOADED                                            │
│   ──────                                            │
│   • Data arrived successfully                       │
│   • Show the data                                   │
│   • Pizza delivered!                                │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Defining Async States

Create different state classes for each situation:

```dart
// Base state
abstract class UserState {}

// Initial state (nothing happened yet)
class UserInitial extends UserState {}

// Loading state (fetching data)
class UserLoading extends UserState {}

// Success state (data loaded)
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

// Error state (something went wrong)
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
```

---

## Async Events

Define events that trigger async operations:

```dart
abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

class RefreshUser extends UserEvent {}
```

---

## Creating Async BLoC

Handle async operations in event handlers:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  // Async event handler
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    // 1. Emit loading state
    emit(UserLoading());

    try {
      // 2. Fetch data (async operation)
      final user = await repository.getUser(event.userId);

      // 3. Emit success state
      emit(UserLoaded(user));
    } catch (e) {
      // 4. Emit error state
      emit(UserError(e.toString()));
    }
  }
}
```

---

## Visual Flow

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   User taps "Load" button                           │
│           │                                         │
│           ▼                                         │
│   LoadUser event sent                               │
│           │                                         │
│           ▼                                         │
│   ┌─────────────┐                                   │
│   │   LOADING   │  emit(UserLoading())              │
│   └──────┬──────┘  Show spinner                     │
│          │                                          │
│          │ Fetch data from API...                   │
│          │                                          │
│          ├──── Success ────┐                        │
│          │                 │                        │
│          ▼                 ▼                        │
│   ┌─────────────┐   ┌─────────────┐                 │
│   │    ERROR    │   │   LOADED    │                 │
│   │  (failed)   │   │  (success)  │                 │
│   └─────────────┘   └─────────────┘                 │
│          │                 │                        │
│          ▼                 ▼                        │
│   Show error msg    Show user data                  │
│   + Retry button                                    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Complete Async Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// Model
// ─────────────────────────────────────
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

// ─────────────────────────────────────
// Repository (fake API)
// ─────────────────────────────────────
class UserRepository {
  Future<User> getUser(String userId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate random error (20% chance)
    if (DateTime.now().millisecond % 5 == 0) {
      throw Exception('Network error!');
    }

    // Return fake user
    return User(name: 'User $userId', age: 25);
  }
}

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

// ─────────────────────────────────────
// States
// ─────────────────────────────────────
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final user = await repository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => UserBloc(repository: UserRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Async BLoC')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          // Handle different states
          if (state is UserInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<UserBloc>().add(LoadUser('123'));
                },
                child: Text('Load User'),
              ),
            );
          }

          if (state is UserLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading user...'),
                ],
              ),
            );
          }

          if (state is UserLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'Name: ${state.user.name}',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Age: ${state.user.age}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUser('123'));
                    },
                    child: Text('Reload'),
                  ),
                ],
              ),
            );
          }

          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 100, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUser('123'));
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
```

---

## Using Equatable for Better State Comparison

Equatable helps BLoC know when states are actually different:

### Add Equatable Package

```yaml
dependencies:
  equatable: ^2.0.5
```

### Use with States

```dart
import 'package:equatable/equatable.dart';

// Events
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

// States
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;
  UserError(this.message);

  @override
  List<Object?> get props => [message];
}
```

---

## Why Equatable?

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   WITHOUT Equatable:                                │
│   ─────────────────                                 │
│   State A = UserLoaded(User(name: 'John'))          │
│   State B = UserLoaded(User(name: 'John'))          │
│                                                     │
│   A == B ?  FALSE (different objects in memory)     │
│   Result: UI rebuilds even though data is same!     │
│                                                     │
│   WITH Equatable:                                   │
│   ──────────────                                    │
│   State A = UserLoaded(User(name: 'John'))          │
│   State B = UserLoaded(User(name: 'John'))          │
│                                                     │
│   A == B ?  TRUE (Equatable compares props)         │
│   Result: No unnecessary rebuilds!                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Advanced: Multiple Async Operations

Handle loading lists of data:

```dart
// States
abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  PostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Events
abstract class PostsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostsEvent {}

class RefreshPosts extends PostsEvent {}

// BLoC
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository repository;

  PostsBloc({required this.repository}) : super(PostsInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());

    try {
      final posts = await repository.getPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onRefreshPosts(RefreshPosts event, Emitter<PostsState> emit) async {
    // Keep showing old data while refreshing
    if (state is PostsLoaded) {
      final currentPosts = (state as PostsLoaded).posts;

      try {
        final posts = await repository.getPosts();
        emit(PostsLoaded(posts));
      } catch (e) {
        // Keep old data on error
        emit(PostsLoaded(currentPosts));
        // Could also emit error separately
      }
    } else {
      // If no data yet, use regular load
      add(LoadPosts());
    }
  }
}
```

---

## Summary

For async operations with BLoC:

1. **Define states** for each stage:
   - Initial (nothing yet)
   - Loading (fetching)
   - Loaded (success)
   - Error (failed)

2. **Make handlers async**:
   - Use `Future<void>` for handler methods
   - Use `async/await` for async operations

3. **Emit states at each stage**:
   - Emit loading before fetching
   - Emit loaded on success
   - Emit error on failure

4. **Use Equatable** for better state comparison

5. **Handle errors gracefully** with try/catch

This pattern works for API calls, database queries, file operations, and any async operation!

---

## Quick Quiz

**Q1.** What three states does an async bloc usually emit?

<details>
<summary>Answer</summary>
Loading (while fetching), Loaded (success, with the data), and Error (if it failed). Often an Initial state too.
</details>

**Q2.** In what order do you emit them?

<details>
<summary>Answer</summary>
Emit Loading first, then do the work, then emit Loaded on success or Error on failure.
</details>

**Q3.** What protects against a crash when the work fails?

<details>
<summary>Answer</summary>
A `try/catch` around the `await`, emitting an Error state in the `catch`.
</details>

---

## Assignment

These use async (Level 8). Focus on the loading -> loaded/error flow.

### Problem 1: Name the states

A bloc loads a list of posts from the internet. List the states it should emit, in order, for a successful load.

### Problem 2: Order the emits

Put these in the right order inside an async handler: `emit(Loaded(data))`, `emit(Loading())`, `await fetchData()`.

### Problem 3: Spot the missing piece

This handler shows a spinner forever even after data loads. What is missing?

```dart
on<LoadData>((event, emit) async {
  emit(Loading());
  final data = await fetchData();
  // ...
});
```

---

## Assignment Answers

### Problem 1: Name the states

`Loading` (while fetching), then `Loaded(posts)` (success). If it failed instead, it would emit `Error(message)`. So a successful run is Loading then Loaded.

### Problem 2: Order the emits

```dart
emit(Loading());            // 1. show the spinner
final data = await fetchData();  // 2. do the work
emit(Loaded(data));         // 3. show the result
```

Loading first, then await the work, then emit the loaded result.

### Problem 3: Spot the missing piece

It never emits a loaded (or error) state after the data arrives, so the UI stays on the loading spinner. Add the emits (and a try/catch):

```dart
on<LoadData>((event, emit) async {
  emit(Loading());
  try {
    final data = await fetchData();
    emit(Loaded(data));
  } catch (e) {
    emit(Error(e.toString()));
  }
});
```

Now it emits Loaded on success or Error on failure, so the spinner is replaced.

---

## Navigation

⬅️ **Previous:** [Using BLoCs](06c-UsingBloc.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [BLoC Patterns](07b-BlocPatterns.md)
