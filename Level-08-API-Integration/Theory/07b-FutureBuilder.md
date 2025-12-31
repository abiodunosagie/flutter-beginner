# FutureBuilder

Learn how to build UI from asynchronous data using FutureBuilder!

---

## What is FutureBuilder?

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│                   WHAT IS FUTUREBUILDER?                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FutureBuilder is a widget that builds itself based on      │
│  the state of a Future (async operation)                    │
│                                                             │
│  Traditional Way (Manual):                                  │
│  ┌─────────────────────────────────┐                        │
│  │ 1. Create state variables       │                        │
│  │ 2. Set loading = true            │                        │
│  │ 3. Call async function           │                        │
│  │ 4. Update state on success       │                        │
│  │ 5. Handle errors manually        │                        │
│  │ 6. Build UI based on state       │                        │
│  └─────────────────────────────────┘                        │
│                                                             │
│  FutureBuilder Way (Declarative):                           │
│  ┌─────────────────────────────────┐                        │
│  │ 1. Pass a Future                 │                        │
│  │ 2. Build UI based on snapshot    │                        │
│  │    → FutureBuilder handles       │                        │
│  │      loading/error/success!      │                        │
│  └─────────────────────────────────┘                        │
│                                                             │
│  It's like having an automatic state manager!               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic FutureBuilder Pattern

### Simple Example

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreenFuture extends StatelessWidget {
  const UsersScreenFuture({super.key});

  Future<List<dynamic>> _fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          // State 1: Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 3: Error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // State 2: Success
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index]['name']),
                subtitle: Text(users[index]['email']),
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

## Understanding ConnectionState

### The Four ConnectionStates

```
┌─────────────────────────────────────────────────────────────┐
│                   CONNECTION STATES                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ConnectionState.none                                       │
│  ─────────────────────                                      │
│  Future hasn't started yet                                  │
│  (Usually only if future is null)                           │
│                                                             │
│  ConnectionState.waiting                                    │
│  ────────────────────────────                               │
│  Future is running → Show loading                           │
│  Most common state to check!                                │
│                                                             │
│  ConnectionState.active                                     │
│  ───────────────────────                                    │
│  For Streams only (not Futures)                             │
│  Receiving data but stream is still open                    │
│                                                             │
│  ConnectionState.done                                       │
│  ─────────────────────────                                  │
│  Future completed → Check hasError/hasData                  │
│                                                             │
│  FLOW FOR FUTURES:                                          │
│  none → waiting → done                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Visual: FutureBuilder Flow

```
┌─────────────────────────────────────────────────────────────┐
│                 FUTUREBUILDER FLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  START                                                      │
│    ↓                                                        │
│  ConnectionState.waiting                                    │
│    │                                                        │
│    │  Show: CircularProgressIndicator                       │
│    │                                                        │
│    ↓                                                        │
│  ConnectionState.done                                       │
│    │                                                        │
│    ├─→ snapshot.hasError?                                   │
│    │     YES → Show error message                           │
│    │                                                        │
│    └─→ snapshot.hasData?                                    │
│          YES → Show data                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Working with AsyncSnapshot

### Understanding snapshot Properties

```dart
class SnapshotExample extends StatelessWidget {
  const SnapshotExample({super.key});

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Hello, World!';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchData(),
      builder: (context, snapshot) {
        // snapshot.connectionState → Current state
        // snapshot.data → The data (if successful)
        // snapshot.error → The error (if failed)
        // snapshot.hasData → true if data exists
        // snapshot.hasError → true if error exists

        print('Connection State: ${snapshot.connectionState}');
        print('Has Data: ${snapshot.hasData}');
        print('Has Error: ${snapshot.hasError}');
        print('Data: ${snapshot.data}');
        print('Error: ${snapshot.error}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Center(child: Text(snapshot.data ?? 'No data'));
      },
    );
  }
}
```

### Visual: AsyncSnapshot Properties

```
┌─────────────────────────────────────────────────────────────┐
│              ASYNCSNAPSHOT PROPERTIES                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PROPERTY           │ DESCRIPTION                           │
│  ────────────────────────────────────────────────────────── │
│                                                             │
│  connectionState    │ Current state of Future               │
│                     │ (none/waiting/active/done)            │
│                                                             │
│  data               │ The result if successful              │
│                     │ (null if not done or error)           │
│                                                             │
│  error              │ The error if failed                   │
│                     │ (null if no error)                    │
│                                                             │
│  hasData            │ true if data is available             │
│                     │ (shorthand for data != null)          │
│                                                             │
│  hasError           │ true if error occurred                │
│                     │ (shorthand for error != null)         │
│                                                             │
│  stackTrace         │ Stack trace if error occurred         │
│                     │                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Handling All States Properly

### Complete Example with All States

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<dynamic>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Future<List<dynamic>> _fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load posts');
  }

  void _retry() {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retry,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // Handle each state explicitly
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Press button to start'));

            case ConnectionState.waiting:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading posts...'),
                  ],
                ),
              );

            case ConnectionState.active:
              // Not used for Futures (only Streams)
              return const Center(child: Text('Active'));

            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _retry,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No posts found'),
                    ],
                  ),
                );
              }

              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${post['id']}')),
                      title: Text(post['title']),
                      subtitle: Text(
                        post['body'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
```

---

## FutureBuilder Best Practices

### DO: Store Future in State (StatefulWidget)

```dart
class GoodExample extends StatefulWidget {
  const GoodExample({super.key});

  @override
  State<GoodExample> createState() => _GoodExampleState();
}

class _GoodExampleState extends State<GoodExample> {
  late Future<String> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();  // ✓ Create Future once in initState
  }

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _dataFuture,  // ✓ Use the stored Future
      builder: (context, snapshot) {
        // Build UI
        return Container();
      },
    );
  }
}
```

### DON'T: Create Future in build Method

```dart
class BadExample extends StatelessWidget {
  const BadExample({super.key});

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchData(),  // ✗ Creates new Future on every rebuild!
      builder: (context, snapshot) {
        // This will trigger infinite loading!
        return Container();
      },
    );
  }
}
```

### Visual: Future Creation Best Practice

```
┌─────────────────────────────────────────────────────────────┐
│           FUTURE CREATION BEST PRACTICE                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ CORRECT (StatefulWidget):                                │
│  ┌─────────────────────────────────┐                        │
│  │ initState()                     │                        │
│  │   ↓                              │                        │
│  │ Create Future ONCE               │                        │
│  │   ↓                              │                        │
│  │ Store in variable                │                        │
│  │   ↓                              │                        │
│  │ Use in FutureBuilder             │                        │
│  │   ↓                              │                        │
│  │ Future runs ONCE                 │                        │
│  └─────────────────────────────────┘                        │
│                                                             │
│  ✗ WRONG (Creating in build):                               │
│  ┌─────────────────────────────────┐                        │
│  │ build()                         │                        │
│  │   ↓                              │                        │
│  │ Create Future                    │                        │
│  │   ↓                              │                        │
│  │ FutureBuilder rebuilds           │                        │
│  │   ↓                              │                        │
│  │ build() called again             │                        │
│  │   ↓                              │                        │
│  │ Create Future AGAIN ♾️           │                        │
│  └─────────────────────────────────┘                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              FUTUREBUILDER CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WHAT IS IT?                                                │
│  Widget that builds UI based on Future state                │
│                                                             │
│  BASIC PATTERN:                                             │
│  FutureBuilder<T>(                                          │
│    future: myFuture,                                        │
│    builder: (context, snapshot) {                           │
│      // Return widget based on snapshot                     │
│    },                                                       │
│  )                                                          │
│                                                             │
│  CHECK THESE STATES:                                        │
│  1. snapshot.connectionState == ConnectionState.waiting     │
│     → Show loading indicator                                │
│                                                             │
│  2. snapshot.hasError                                       │
│     → Show error message                                    │
│                                                             │
│  3. snapshot.hasData                                        │
│     → Show the data                                         │
│                                                             │
│  BEST PRACTICES:                                            │
│  ✓ Create Future in initState (StatefulWidget)              │
│  ✓ Handle all states (loading, error, empty, success)       │
│  ✓ Provide retry mechanism for errors                       │
│  ✗ Never create Future in build method                      │
│  ✗ Don't forget to check for empty data                     │
│                                                             │
│  WHEN TO USE:                                               │
│  ✓ One-time data fetching                                   │
│  ✓ Simple async operations                                  │
│  ✓ When you don't need manual state management              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

---

## Navigation

⬅️ **Previous:** [Loading Indicators](07a-LoadingIndicators.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [State Patterns](07c-StatePatterns.md)
