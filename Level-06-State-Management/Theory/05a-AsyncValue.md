# AsyncValue: Handling Loading, Error, and Data

## The Big Idea In One Sentence

> Data that takes time to arrive (like from the internet) has three possible states, **loading**, **error**, and **data**, and `AsyncValue` lets you handle all three with one neat `.when(...)`.

When you order pizza, three things can happen: you wait (loading), something goes wrong (error), or you get your pizza (data). AsyncValue handles all three.

> **A quick heads-up about "async".** This lesson uses `Future` and `async` (data that arrives later, like from a server). You learn those properly in Level 8. For now, all you need: a **Future** is a value that is not ready yet but will arrive after a wait, and a **FutureProvider** is a Riverpod provider that holds such a value. Do not worry about the details of `async`/`await` yet; focus on the three states (loading, error, data).

---

## What is AsyncValue?

When you use `FutureProvider` or `StreamProvider`, Riverpod wraps the result in an `AsyncValue`. This wrapper contains information about whether the data is still loading, had an error, or succeeded.

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   AsyncValue is like a package delivery tracker:   │
│                                                     │
│   📦 Loading     "Package is on the way..."         │
│   ❌ Error       "Delivery failed!"                 │
│   ✅ Data        "Package delivered! Here it is."   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## The Three States

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Future/Stream starts                              │
│          │                                          │
│          ▼                                          │
│   ┌─────────────┐                                   │
│   │   LOADING   │  ← Waiting for data               │
│   │  (no data   │    Show spinner                   │
│   │   yet)      │                                   │
│   └─────────────┘                                   │
│          │                                          │
│          ├──── Success ────┐                        │
│          │                 │                        │
│          ▼                 ▼                        │
│   ┌─────────────┐   ┌─────────────┐                 │
│   │    ERROR    │   │    DATA     │                 │
│   │  (failed)   │   │  (success)  │                 │
│   └─────────────┘   └─────────────┘                 │
│          │                 │                        │
│          ▼                 ▼                        │
│   Show error msg    Show the data                   │
│   + Retry button                                    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## FutureProvider and AsyncValue

Let's create a provider that loads user data:

```dart
// Define a model
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

// Create a FutureProvider
final userProvider = FutureProvider<User>((ref) async {
  // Simulate API call that takes 2 seconds
  await Future.delayed(Duration(seconds: 2));

  // Could throw an error:
  // throw Exception('Failed to load user');

  return User(name: 'John', age: 25);
});
```

---

## Method 1: Using .when()

The `.when()` method is like a traffic light - it handles all three states:

```dart
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider - returns AsyncValue<User>
    final userAsync = ref.watch(userProvider);

    // Handle all three states
    return userAsync.when(
      // 🔄 While loading
      loading: () => CircularProgressIndicator(),

      // ❌ If error occurred
      error: (error, stackTrace) => Column(
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              // Retry by refreshing the provider
              ref.invalidate(userProvider);
            },
            child: Text('Retry'),
          ),
        ],
      ),

      // ✅ When data is loaded
      data: (user) => Column(
        children: [
          Text('Name: ${user.name}', style: TextStyle(fontSize: 24)),
          Text('Age: ${user.age}', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
```

### Visual Flow

```
userProvider starts
        │
        ▼
┌───────────────┐
│ when(         │
│   loading: () │ → Shows: CircularProgressIndicator
│ )             │
└───────────────┘
        │
        ├─── Success ────┐
        │                │
        ▼                ▼
┌───────────────┐  ┌───────────────┐
│ when(         │  │ when(         │
│   error: (e)  │  │   data: (user)│
│ )             │  │ )             │
└───────────────┘  └───────────────┘
        │                │
        ▼                ▼
Shows error msg    Shows user data
```

---

## Method 2: Using .maybeWhen()

Use `.maybeWhen()` when you only care about some states:

```dart
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.maybeWhen(
      // Only handle data state
      data: (user) => Text('Hello, ${user.name}!'),

      // Use 'orElse' for all other states (loading, error)
      orElse: () => CircularProgressIndicator(),
    );
  }
}
```

### Example: Handle Error Differently

```dart
userAsync.maybeWhen(
  data: (user) => UserCard(user),
  error: (e, s) => ErrorWidget(e),
  // orElse handles loading state
  orElse: () => LoadingWidget(),
);
```

---

## Method 3: Using .value and Checking States

For more control, check states manually:

```dart
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // Check if loading
    if (userAsync.isLoading) {
      return CircularProgressIndicator();
    }

    // Check if error
    if (userAsync.hasError) {
      return Column(
        children: [
          Text('Error: ${userAsync.error}'),
          Text('Stack: ${userAsync.stackTrace}'),
        ],
      );
    }

    // Check if has data
    if (userAsync.hasValue) {
      final user = userAsync.value!;  // Safe because hasValue is true
      return Text('Hello, ${user.name}!');
    }

    // Should never reach here
    return Text('Unknown state');
  }
}
```

### Accessing .value Directly

```dart
// Get the data (might be null!)
final user = userAsync.value;

if (user != null) {
  print('User name: ${user.name}');
} else {
  print('No user data yet');
}
```

---

## StreamProvider and AsyncValue

Streams work the same way, but they can emit multiple values over time:

```dart
// Create a StreamProvider that counts every second
final timerProvider = StreamProvider<int>((ref) {
  return Stream.periodic(
    Duration(seconds: 1),
    (count) => count,  // 0, 1, 2, 3, ...
  );
});

// Use in widget
class TimerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerAsync = ref.watch(timerProvider);

    return timerAsync.when(
      loading: () => Text('Starting timer...'),
      error: (e, s) => Text('Timer error: $e'),
      data: (seconds) => Text(
        'Seconds: $seconds',
        style: TextStyle(fontSize: 48),
      ),
    );
  }
}
```

---

## Real-World Example: Loading Posts

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────
// Model
// ─────────────────────────────────────
class Post {
  final String title;
  final String body;

  Post({required this.title, required this.body});
}

// ─────────────────────────────────────
// Provider that fetches posts
// ─────────────────────────────────────
final postsProvider = FutureProvider<List<Post>>((ref) async {
  // Simulate API delay
  await Future.delayed(Duration(seconds: 2));

  // Simulate random error (10% chance)
  if (DateTime.now().millisecond % 10 == 0) {
    throw Exception('Network error!');
  }

  // Return mock data
  return [
    Post(title: 'First Post', body: 'Hello World!'),
    Post(title: 'Second Post', body: 'Flutter is awesome!'),
    Post(title: 'Third Post', body: 'Learning Riverpod!'),
  ];
});

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: PostsPage(),
      ),
    ),
  );
}

// ─────────────────────────────────────
// Widget displaying posts
// ─────────────────────────────────────
class PostsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh posts
              ref.invalidate(postsProvider);
            },
          ),
        ],
      ),
      body: postsAsync.when(
        // Loading state
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading posts...'),
            ],
          ),
        ),

        // Error state
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error: $error',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(postsProvider);
                },
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
              ),
            ],
          ),
        ),

        // Data state
        data: (posts) {
          if (posts.isEmpty) {
            return Center(child: Text('No posts yet'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    post.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(post.body),
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Handling All States Summary

```dart
// Method 1: .when() - Handle all states (recommended)
asyncValue.when(
  loading: () => LoadingWidget(),
  error: (e, s) => ErrorWidget(e),
  data: (data) => DataWidget(data),
);

// Method 2: .maybeWhen() - Handle some states
asyncValue.maybeWhen(
  data: (data) => DataWidget(data),
  orElse: () => LoadingWidget(),
);

// Method 3: Manual checks
if (asyncValue.isLoading) return LoadingWidget();
if (asyncValue.hasError) return ErrorWidget(asyncValue.error);
if (asyncValue.hasValue) return DataWidget(asyncValue.value!);

// Method 4: Direct access (unsafe - might be null)
final data = asyncValue.value;
if (data != null) {
  // Use data
}
```

---

## AsyncValue Properties

| Property | Type | Description |
|----------|------|-------------|
| `isLoading` | `bool` | True while waiting for data |
| `hasError` | `bool` | True if an error occurred |
| `hasValue` | `bool` | True if data loaded successfully |
| `value` | `T?` | The data (null if loading/error) |
| `error` | `Object?` | The error (null if loading/success) |
| `stackTrace` | `StackTrace?` | Error stack trace |

---

## Summary

AsyncValue is like a package delivery system:
- **Loading**: Package is on the way (show spinner)
- **Error**: Delivery failed (show error + retry button)
- **Data**: Package delivered (show the contents)

Use `.when()` to handle all three states cleanly, and your users will always know what's happening with their data!

---

## Quick Quiz

**Q1.** What are the three states an `AsyncValue` can be in?

<details>
<summary>Answer</summary>
Loading (waiting), error (it failed), and data (it arrived).
</details>

**Q2.** What does `.when(...)` do?

<details>
<summary>Answer</summary>
It lets you give one widget for each state: `loading:`, `error:`, and `data:`. Riverpod shows the right one.
</details>

**Q3.** What kind of provider gives you an `AsyncValue`?

<details>
<summary>Answer</summary>
A `FutureProvider` (one-time async data) or a `StreamProvider` (continuous async data).
</details>

---

## Assignment

Use [dartpad.dev](https://dartpad.dev) with `flutter_riverpod` and a `ProviderScope`.

### Problem 1: Name the states

A widget shows data loaded from the internet. List the three things it might need to show, and what you would display for each.

### Problem 2: Handle all three with .when

Given `final greetingProvider = FutureProvider<String>((ref) async => 'Hello');`, write a `ConsumerWidget` that watches it and uses `.when` to show a spinner while loading, the text when it arrives, and an error message if it fails.

### Problem 3: Spot the bug

Why might this crash, and how does `.when` avoid the problem?

```dart
final userAsync = ref.watch(userProvider);
return Text(userAsync.value!.name);   // assuming the data is ready
```

---

## Assignment Answers

### Problem 1: Name the states

- **Loading**: show a spinner (`CircularProgressIndicator`).
- **Error**: show an error message (and maybe a retry button).
- **Data**: show the actual content.

Handling all three means the user always sees something sensible.

### Problem 2: Handle all three with .when

```dart
class Greeting extends ConsumerWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greetingAsync = ref.watch(greetingProvider);
    return greetingAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (greeting) => Text(greeting),
    );
  }
}
```

`.when` picks the right widget for whichever state the provider is in.

### Problem 3: Spot the bug

`userAsync.value` is null while loading or on error, so `userAsync.value!.name` would crash with a null error before the data arrives. `.when` avoids this: the `data:` branch only runs when the data actually exists, so you never touch a null value. Always prefer `.when` over forcing `.value!`.

---

## Navigation

⬅️ **Previous:** [Consuming Riverpod](04c-ConsumingRiverpod.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Modifiers](05b-Modifiers.md)
