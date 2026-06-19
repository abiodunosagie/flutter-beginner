# State Patterns

## The Big Idea In One Sentence

> Track your screen with ONE `enum` (initial, loading, success, error) instead of a tangle of booleans, then build a different view for each, plus an empty view and pull-to-refresh.

Learn patterns for managing loading, empty, and error states in your app!

---

## State Management Patterns

### The Loading State Pattern

```
┌─────────────────────────────────────────────────────────────┐
│              LOADING STATE PATTERN                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Three boolean flags approach:                              │
│                                                             │
│  bool isLoading = false;                                    │
│  bool hasError = false;                                     │
│  bool hasData = false;                                      │
│                                                             │
│  OR use an enum (better!):                                  │
│                                                             │
│  enum LoadingState {                                        │
│    initial,    // Not started yet                           │
│    loading,    // Currently loading                         │
│    success,    // Data loaded successfully                  │
│    error,      // Error occurred                            │
│  }                                                          │
│                                                             │
│  WHY ENUM IS BETTER:                                        │
│  ✓ Only ONE state at a time (impossible states prevented)   │
│  ✓ Exhaustive switch statements                             │
│  ✓ Clearer code                                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Using Enum for States

### Complete Example with Enum

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        if (_users.isEmpty) {
          return const _EmptyView();
        }
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('No users found'),
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

## Empty State Pattern

### Designing Good Empty States

```
┌─────────────────────────────────────────────────────────────┐
│                   EMPTY STATE DESIGN                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Good empty states should have:                             │
│                                                             │
│  1. ICON - Visual representation                            │
│     ┌───────────┐                                           │
│     │     📭    │  Large, friendly icon                     │
│     └───────────┘                                           │
│                                                             │
│  2. MESSAGE - Clear explanation                             │
│     "No messages yet"                                       │
│     (Not just "Empty" or "No data")                         │
│                                                             │
│  3. ACTION - What can user do?                              │
│     [Start a conversation]                                  │
│                                                             │
│  EXAMPLES:                                                  │
│  • No products → "Browse our catalog"                       │
│  • No friends → "Invite friends"                            │
│  • No history → "Start exploring"                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Empty State Implementation

```dart
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage examples
class EmptyStateExamples extends StatelessWidget {
  const EmptyStateExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Empty cart
        EmptyStateWidget(
          icon: Icons.shopping_cart_outlined,
          title: 'Your cart is empty',
          subtitle: 'Add items to get started',
          actionLabel: 'Browse Products',
          onAction: () {
            // Navigate to products
          },
        ),

        // No notifications
        EmptyStateWidget(
          icon: Icons.notifications_none,
          title: 'No notifications yet',
          subtitle: 'We\'ll notify you when something arrives',
        ),

        // No search results
        EmptyStateWidget(
          icon: Icons.search_off,
          title: 'No results found',
          subtitle: 'Try adjusting your search',
          actionLabel: 'Clear Filters',
          onAction: () {
            // Clear search filters
          },
        ),
      ],
    );
  }
}
```

---

## Pull to Refresh Pattern

### RefreshIndicator Implementation

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

## Advanced: Custom RefreshIndicator

### Custom Colors and Styling

```dart
class CustomRefreshExample extends StatefulWidget {
  const CustomRefreshExample({super.key});

  @override
  State<CustomRefreshExample> createState() => _CustomRefreshExampleState();
}

class _CustomRefreshExampleState extends State<CustomRefreshExample> {
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _items.add('Item ${_items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Refresh')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,  // Spinner color
        backgroundColor: Colors.blue,  // Background of spinner
        strokeWidth: 3.0,  // Thickness of spinner
        displacement: 40.0,  // Distance from top
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_items[index]),
            );
          },
        ),
      ),
    );
  }
}
```

---

## Manual Refresh with Button

### Alternative to Pull-to-Refresh

```dart
class ManualRefreshExample extends StatefulWidget {
  const ManualRefreshExample({super.key});

  @override
  State<ManualRefreshExample> createState() => _ManualRefreshExampleState();
}

class _ManualRefreshExampleState extends State<ManualRefreshExample> {
  LoadingState _state = LoadingState.initial;
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = LoadingState.loading);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _data = List.generate(10, (i) => 'Item ${i + 1}');
        _state = LoadingState.success;
      });
    } catch (e) {
      setState(() => _state = LoadingState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Refresh'),
        actions: [
          if (_state != LoadingState.loading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Refresh',
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadingState.initial:
      case LoadingState.loading:
        return const Center(child: CircularProgressIndicator());

      case LoadingState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load data'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Try Again'),
              ),
            ],
          ),
        );

      case LoadingState.success:
        return ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_data[index]),
            );
          },
        );
    }
  }
}
```

---

## Combining Patterns

### Complete Real-World Example

```dart
class RealWorldExample extends StatefulWidget {
  const RealWorldExample({super.key});

  @override
  State<RealWorldExample> createState() => _RealWorldExampleState();
}

class _RealWorldExampleState extends State<RealWorldExample> {
  LoadingState _state = LoadingState.initial;
  List<Map<String, dynamic>> _products = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _state = LoadingState.loading;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.cast<Map<String, dynamic>>();
          _state = LoadingState.success;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = LoadingState.error;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          if (_state != LoadingState.loading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProducts,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_state == LoadingState.loading && _products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading products...'),
          ],
        ),
      );
    }

    // Error state
    if (_state == LoadingState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage ?? 'An error occurred'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (_products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.shopping_bag_outlined,
        title: 'No products available',
        subtitle: 'Check back later for new items',
        actionLabel: 'Refresh',
        onAction: _loadProducts,
      );
    }

    // Success state with data
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.network(
                product['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product['title']),
              subtitle: Text('\$${product['price']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              STATE PATTERNS CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LOADING STATE ENUM:                                        │
│  enum LoadingState {                                        │
│    initial,   // Not started                                │
│    loading,   // Loading data                               │
│    success,   // Data loaded                                │
│    error,     // Error occurred                             │
│  }                                                          │
│                                                             │
│  EMPTY STATE COMPONENTS:                                    │
│  ✓ Large, friendly icon                                     │
│  ✓ Clear message explaining why it's empty                  │
│  ✓ Action button (what can user do?)                        │
│                                                             │
│  PULL TO REFRESH:                                           │
│  RefreshIndicator(                                          │
│    onRefresh: _refreshMethod,                               │
│    child: ListView(...),                                    │
│  )                                                          │
│                                                             │
│  BEST PRACTICES:                                            │
│  ✓ Use enum instead of multiple booleans                    │
│  ✓ Always handle empty state separately                     │
│  ✓ Provide retry options on errors                          │
│  ✓ Show loading state during initial load                   │
│  ✓ Support pull-to-refresh for lists                        │
│  ✓ Disable refresh button while loading                     │
│                                                             │
│  STATE HIERARCHY:                                           │
│  1. Check loading → Show spinner                            │
│  2. Check error → Show error view with retry                │
│  3. Check empty → Show empty state                          │
│  4. Show data → Display actual content                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why is one `enum` better than three booleans (`isLoading`, `hasError`, `hasData`)?

<details>
<summary>Answer</summary>
An enum can only be one value at a time, so you cannot get into impossible states like "loading AND error" at once.
</details>

**Q2.** Why handle the empty state separately from the success state?

<details>
<summary>Answer</summary>
A successful load can still return zero items. A good empty view explains that and offers an action, instead of showing a blank screen.
</details>

**Q3.** What widget gives you swipe-down "pull to refresh"?

<details>
<summary>Answer</summary>
`RefreshIndicator(onRefresh: ..., child: ListView(...))`.
</details>

---

## Assignment

### Problem 1: Define the states

Write an `enum` named `LoadingState` with the four states used in this lesson.

### Problem 2: Order the checks

In what order should `_buildBody` check states: empty, error, loading, success? Put them in the right order.

### Problem 3: Add refresh

Wrap a `ListView` so pulling down calls `_onRefresh`.

---

## Assignment Answers

### Problem 1: Define the states

```dart
enum LoadingState { initial, loading, success, error }
```

### Problem 2: Order the checks

Check **loading** first (show spinner), then **error** (show retry), then **empty** (show empty view), then **success** (show data). Loading and error come before looking at the data.

### Problem 3: Add refresh

```dart
RefreshIndicator(
  onRefresh: _onRefresh,
  child: ListView(/* items */),
)
```

---

## Navigation

⬅️ **Previous:** [FutureBuilder](07b-FutureBuilder.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Model Basics](08a-ModelBasics.md)
