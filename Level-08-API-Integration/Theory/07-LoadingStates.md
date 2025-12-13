# Loading States

Learn how to show loading indicators and handle async state properly!

---

## Why Loading States Matter

### Think of it Like This

```
┌─────────────────────────────────────────────────────────────┐
│              WHY LOADING STATES MATTER                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Imagine clicking a button and NOTHING happens...           │
│                                                             │
│  WITHOUT Loading State:                                     │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  [Submit]               │  User clicks...                │
│  │                         │  Nothing visible happens       │
│  │                         │  User clicks again...          │
│  │                         │  And again... 😤               │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  WITH Loading State:                                        │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  [⏳ Submitting...]     │  User sees progress!           │
│  │                         │  Knows it's working            │
│  │                         │  Waits patiently 😊            │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  Loading states = User trust + Better UX                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## The Three States of Async Data

```
┌─────────────────────────────────────────────────────────────┐
│                 THREE STATES OF DATA                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  State 1: LOADING                                           │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │    ⏳ Loading...        │  Show spinner/skeleton         │
│  │                         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  State 2: SUCCESS (Data loaded)                             │
│  ┌─────────────────────────┐                                │
│  │  ✓ John                 │                                │
│  │  ✓ Jane                 │  Show the actual data          │
│  │  ✓ Bob                  │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  State 3: ERROR                                             │
│  ┌─────────────────────────┐                                │
│  │                         │                                │
│  │  ❌ Failed to load      │  Show error + retry option     │
│  │     [Try Again]         │                                │
│  └─────────────────────────┘                                │
│                                                             │
│  Your app should handle ALL THREE states!                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Loading State Pattern

### Using setState (Simple)

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Three state variables
  List<dynamic> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // Set loading state
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        // Success state
        setState(() {
          _users = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      // Error state
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // State 1: Loading
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // State 3: Error
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // State 2: Success
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(user['name']),
          subtitle: Text(user['email']),
        );
      },
    );
  }
}
```

---

## Using FutureBuilder (Declarative)

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
              );
            },
          );
        },
      ),
    );
  }
}
```

### Visual: FutureBuilder States

```
┌─────────────────────────────────────────────────────────────┐
│                 FUTUREBUILDER STATES                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ConnectionState.waiting                                    │
│  ────────────────────────                                   │
│  Future is still running → Show loading                     │
│                                                             │
│  snapshot.hasError == true                                  │
│  ─────────────────────────                                  │
│  Future threw an exception → Show error                     │
│                                                             │
│  snapshot.hasData == true                                   │
│  ────────────────────────                                   │
│  Future completed successfully → Show data                  │
│                                                             │
│  FLOW:                                                      │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐              │
│  │ waiting │ ──→ │  error  │ OR  │  data   │              │
│  │ (load)  │     │ (fail)  │     │ (done)  │              │
│  └─────────┘     └─────────┘     └─────────┘              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Loading Indicators

### Different Types of Loading Indicators

```dart
// 1. Circular Progress (most common)
const CircularProgressIndicator()

// 2. Linear Progress (for known progress)
LinearProgressIndicator(value: 0.5)  // 50%

// 3. Circular with color
const CircularProgressIndicator(
  color: Colors.blue,
  strokeWidth: 3,
)

// 4. Centered loading
const Center(
  child: CircularProgressIndicator(),
)

// 5. Loading with text
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    CircularProgressIndicator(),
    SizedBox(height: 16),
    Text('Loading...'),
  ],
)

// 6. Full screen loading overlay
Stack(
  children: [
    YourContent(),
    if (isLoading)
      Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
  ],
)
```

---

## Skeleton Loading (Shimmer Effect)

### What is Skeleton Loading?

```
┌─────────────────────────────────────────────────────────────┐
│               SKELETON LOADING (SHIMMER)                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Instead of a boring spinner, show a PREVIEW of content:    │
│                                                             │
│  LOADING:                       LOADED:                     │
│  ┌─────────────────────┐        ┌─────────────────────┐    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓▓   │        │ ┌──┐ John Doe       │    │
│  │ └──┘ ▓▓▓▓▓▓▓▓       │        │ └──┘ john@email.com │    │
│  │ ───────────────────  │        │ ─────────────────── │    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓▓   │        │ ┌──┐ Jane Smith     │    │
│  │ └──┘ ▓▓▓▓▓▓▓        │        │ └──┘ jane@email.com │    │
│  │ ───────────────────  │        │ ─────────────────── │    │
│  │ ┌──┐ ▓▓▓▓▓▓▓▓▓▓▓    │        │ ┌──┐ Bob Wilson     │    │
│  │ └──┘ ▓▓▓▓▓▓▓▓▓      │        │ └──┘ bob@email.com  │    │
│  └─────────────────────┘        └─────────────────────┘    │
│                                                             │
│  ▓▓▓▓ = Animated gray boxes that shimmer                    │
│                                                             │
│  WHY? Users perceive it as faster than a spinner!           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Simple Skeleton Implementation

```dart
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// User card skeleton
class UserCardSkeleton extends StatelessWidget {
  const UserCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar skeleton
            const SkeletonLoader(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: 16),
            // Text skeletons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonLoader(width: 150, height: 16),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 100, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// List of skeletons while loading
class UsersScreenWithSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show skeleton list
          return ListView.builder(
            itemCount: 5,  // Show 5 skeleton items
            itemBuilder: (context, index) => const UserCardSkeleton(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Show actual data
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final user = snapshot.data![index];
            return UserCard(user: user);
          },
        );
      },
    );
  }
}
```

---

## Pull to Refresh

```dart
class RefreshableUsersList extends StatefulWidget {
  const RefreshableUsersList({super.key});

  @override
  State<RefreshableUsersList> createState() => _RefreshableUsersListState();
}

class _RefreshableUsersListState extends State<RefreshableUsersList> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _users = json.decode(response.body);
        _isLoading = false;
      });
    }
  }

  // This is called when user pulls down
  Future<void> _onRefresh() async {
    await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,  // ← Pull to refresh handler
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['name']),
            subtitle: Text(user['email']),
          );
        },
      ),
    );
  }
}
```

### Visual: Pull to Refresh

```
┌─────────────────────────────────────────────────────────────┐
│                 PULL TO REFRESH                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Step 1: User pulls down                                    │
│  ┌─────────────────────┐                                    │
│  │       ↓ ↓ ↓         │                                    │
│  │    (pulling...)     │                                    │
│  │                     │                                    │
│  │  ✓ John             │                                    │
│  │  ✓ Jane             │                                    │
│  └─────────────────────┘                                    │
│                                                             │
│  Step 2: Spinner appears                                    │
│  ┌─────────────────────┐                                    │
│  │         ⏳          │  ← RefreshIndicator                │
│  │                     │                                    │
│  │  ✓ John             │                                    │
│  │  ✓ Jane             │                                    │
│  └─────────────────────┘                                    │
│                                                             │
│  Step 3: Data reloaded                                      │
│  ┌─────────────────────┐                                    │
│  │  ✓ John             │                                    │
│  │  ✓ Jane             │                                    │
│  │  ✓ NEW USER!        │  ← Fresh data                      │
│  └─────────────────────┘                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Button Loading State

```dart
class SubmitButton extends StatefulWidget {
  final Future<void> Function() onSubmit;

  const SubmitButton({super.key, required this.onSubmit});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    setState(() => _isLoading = true);

    try {
      await widget.onSubmit();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handlePress,  // Disable when loading
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Submit'),
    );
  }
}

// Usage
SubmitButton(
  onSubmit: () async {
    await api.createUser({'name': 'John'});
  },
)
```

### Visual: Button States

```
┌─────────────────────────────────────────────────────────────┐
│                    BUTTON LOADING STATES                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  STATE          │ BUTTON APPEARANCE                         │
│  ────────────────────────────────────────────────────────── │
│                                                             │
│  Normal         │ ┌─────────────┐                           │
│                 │ │   Submit    │  Blue, clickable          │
│                 │ └─────────────┘                           │
│                                                             │
│  Loading        │ ┌─────────────┐                           │
│                 │ │     ⏳      │  Gray, disabled           │
│                 │ └─────────────┘                           │
│                                                             │
│  Success        │ ┌─────────────┐                           │
│                 │ │     ✓       │  Green, briefly           │
│                 │ └─────────────┘                           │
│                                                             │
│  Error          │ ┌─────────────┐                           │
│                 │ │  Try Again  │  Red or normal            │
│                 │ └─────────────┘                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Loading State with Enum

```dart
enum LoadingState { initial, loading, success, error }

class UsersScreenWithEnum extends StatefulWidget {
  const UsersScreenWithEnum({super.key});

  @override
  State<UsersScreenWithEnum> createState() => _UsersScreenWithEnumState();
}

class _UsersScreenWithEnumState extends State<UsersScreenWithEnum> {
  LoadingState _state = LoadingState.initial;
  List<dynamic> _users = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _state = LoadingState.loading);

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
          _state = LoadingState.success;
        });
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = LoadingState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadingState.initial:
      case LoadingState.loading:
        return const Center(child: CircularProgressIndicator());

      case LoadingState.error:
        return _ErrorView(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _loadUsers,
        );

      case LoadingState.success:
        return _UsersList(users: _users);
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  final List<dynamic> users;

  const _UsersList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text(user['email']),
        );
      },
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              LOADING STATES CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  THREE STATES TO HANDLE:                                    │
│  1. Loading → Show spinner/skeleton                         │
│  2. Success → Show data                                     │
│  3. Error   → Show error + retry button                     │
│                                                             │
│  LOADING INDICATORS:                                        │
│  • CircularProgressIndicator() → Spinner                    │
│  • LinearProgressIndicator()   → Progress bar               │
│  • Skeleton widgets            → Content preview            │
│                                                             │
│  PATTERNS:                                                  │
│  • setState() → Simple, works everywhere                    │
│  • FutureBuilder → Declarative, one-time loads              │
│  • RefreshIndicator → Pull to refresh                       │
│                                                             │
│  BUTTON LOADING:                                            │
│  • Disable button while loading                             │
│  • Show spinner inside button                               │
│  • Re-enable after completion                               │
│                                                             │
│  BEST PRACTICES:                                            │
│  ✓ Always show SOME feedback                                │
│  ✓ Disable actions while loading                            │
│  ✓ Use skeleton loaders for lists                           │
│  ✓ Provide retry options on error                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Error Handling](./06-ErrorHandling.md) | [Next: Data Models →](./08-DataModels.md)
