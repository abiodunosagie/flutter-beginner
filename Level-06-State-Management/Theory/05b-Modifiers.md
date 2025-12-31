# Provider Modifiers: .family and .autoDispose

Imagine you have a toy library. Sometimes you need different versions of the same toy (like toy cars in different colors). Sometimes you want to return toys when you're done so they don't clutter your room. That's what .family and .autoDispose do for providers!

---

## .family: Providers with Parameters

Sometimes you need to create different instances of the same provider with different parameters. Like ordering pizza - same restaurant, different toppings!

### The Problem

```dart
// How do we fetch DIFFERENT users?
final userProvider = FutureProvider<User>((ref) async {
  // Which user ID should we use??
  return fetchUser('???');
});
```

### The Solution: .family

```dart
// Now we can pass a parameter!
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  //                             ^^^^^^  ^^^^  ^^^^^^  ^^^^^^
  //                             family  Type  Param   Param
  //                                     (User)(String)(value)
  return fetchUser(userId);  // Use the parameter!
});

// Use with different user IDs
class UserProfile extends ConsumerWidget {
  final String userId;

  UserProfile({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass the parameter when watching
    final userAsync = ref.watch(userProvider(userId));
    //                                      ^^^^^^^^
    //                         Pass userId as argument

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
      data: (user) => Text('Name: ${user.name}'),
    );
  }
}

// Different widgets can watch with different IDs
UserProfile(userId: 'user1')  // Fetches user1
UserProfile(userId: 'user2')  // Fetches user2
UserProfile(userId: 'user3')  // Fetches user3
```

---

## Visual: How .family Works

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   userProvider.family                               │
│                                                     │
│   Widget A watches:  userProvider('user1')          │
│          │                     │                    │
│          └─────────────────────┼───► Fetches user1  │
│                                                     │
│   Widget B watches:  userProvider('user2')          │
│          │                     │                    │
│          └─────────────────────┼───► Fetches user2  │
│                                                     │
│   Widget C watches:  userProvider('user1')          │
│          │                     │                    │
│          └─────────────────────┼───► Reuses user1   │
│                                   (already cached!) │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## .family Examples

### Example 1: Fetching Different Products

```dart
// Product provider with ID parameter
final productProvider = FutureProvider.family<Product, int>(
  (ref, productId) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return Product(id: productId, name: 'Product $productId');
  },
);

// Use it
class ProductCard extends ConsumerWidget {
  final int productId;

  ProductCard({required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));

    return productAsync.when(
      loading: () => Card(child: CircularProgressIndicator()),
      error: (e, s) => Card(child: Text('Error')),
      data: (product) => Card(
        child: Column(
          children: [
            Text(product.name),
            Text('ID: ${product.id}'),
          ],
        ),
      ),
    );
  }
}
```

### Example 2: Multiple Parameters (Using Records)

```dart
// Use Dart 3 records for multiple parameters
final searchProvider = FutureProvider.family<List<Item>, ({String query, String category})>(
  (ref, params) async {
    // Access parameters
    final query = params.query;
    final category = params.category;

    return searchItems(query: query, category: category);
  },
);

// Use it
ref.watch(searchProvider((query: 'laptop', category: 'electronics')));
```

### Example 3: StateProvider with .family

```dart
// Different counters for different IDs
final counterProvider = StateProvider.family<int, String>((ref, id) => 0);

// Use different counters
ref.watch(counterProvider('counter1'));  // First counter
ref.watch(counterProvider('counter2'));  // Second counter
ref.watch(counterProvider('counter3'));  // Third counter

// Modify specific counter
ref.read(counterProvider('counter1').notifier).state++;
```

---

## .autoDispose: Clean Up When Done

By default, providers stay in memory forever. Use `.autoDispose` to clean them up when no one is watching.

### The Problem

```dart
// This stays in memory FOREVER
final userProvider = FutureProvider<User>((ref) async {
  return fetchUser();  // Cached forever, even if not used!
});
```

### The Solution: .autoDispose

```dart
// This cleans up when not watched
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return fetchUser();  // Cleaned up when no widgets watch it!
});
```

---

## Visual: How .autoDispose Works

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   WITHOUT .autoDispose                              │
│   ────────────────────                              │
│                                                     │
│   Widget created  → Provider cached                 │
│   Widget disposed → Provider STILL in memory        │
│                     (stays forever!)                │
│                                                     │
│   WITH .autoDispose                                 │
│   ──────────────────                                │
│                                                     │
│   Widget created  → Provider cached                 │
│   Widget disposed → Provider cleaned up             │
│                     (memory freed!)                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## When to Use .autoDispose

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   USE .autoDispose when:                            │
│   ──────────────────────                            │
│   • Data is screen-specific                         │
│   • Fetching data that changes frequently           │
│   • Using streams or real-time data                 │
│   • Memory usage is a concern                       │
│   • Data should be fresh each time                  │
│                                                     │
│   DON'T use .autoDispose when:                      │
│   ─────────────────────────────                     │
│   • Data should be cached (user profile)            │
│   • Multiple screens use the same data              │
│   • Data rarely changes                             │
│   • You want data to persist between screens        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## .autoDispose Examples

### Example 1: Screen-Specific Data

```dart
// Comments for a specific post (dispose when leaving screen)
final postCommentsProvider = FutureProvider.autoDispose.family<List<Comment>, int>(
  (ref, postId) async {
    return fetchComments(postId);
  },
);

// When you navigate away from the post screen,
// the comments are cleaned up automatically!
```

### Example 2: Search Results

```dart
// Search results (clean up old searches)
final searchResultsProvider = FutureProvider.autoDispose.family<List<Item>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    return searchItems(query);
  },
);

// Each new search disposes the old one
```

### Example 3: Real-Time Stream

```dart
// Live chat stream (clean up when leaving chat)
final chatStreamProvider = StreamProvider.autoDispose<Message>((ref) {
  // Connect to chat stream
  final stream = chatService.connect();

  // When widget is disposed, stream is automatically closed!
  return stream;
});
```

---

## Combining .family and .autoDispose

You can use both together!

```dart
// Clean up AND accept parameters
final userPostsProvider = FutureProvider.autoDispose.family<List<Post>, String>(
  (ref, userId) async {
    return fetchUserPosts(userId);
  },
);

// Usage
class UserPostsPage extends ConsumerWidget {
  final String userId;

  UserPostsPage({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetches posts for this user
    // Cleans up when you leave the screen
    final postsAsync = ref.watch(userPostsProvider(userId));

    return postsAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error loading posts'),
      data: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(posts[index]),
      ),
    );
  }
}
```

---

## Notifier and AsyncNotifier (Modern Way)

Riverpod 2.0+ introduced a cleaner way to create providers. Think of it as the new recipe format!

### Old Way: StateNotifier

```dart
// Old way (still works, but verbose)
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
```

### New Way: Notifier

```dart
// New way (cleaner!)
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;  // Initial state

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});
```

---

## AsyncNotifier for Async State

For async state, use `AsyncNotifier`:

```dart
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    // This runs when provider is first accessed
    return await fetchUser();
  }

  Future<void> updateName(String name) async {
    // Set loading state
    state = const AsyncValue.loading();

    // Try to update
    state = await AsyncValue.guard(() async {
      final user = await updateUserName(name);
      return user;
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchUser());
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

// Use in widget
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Column(
        children: [
          Text('Error: $e'),
          ElevatedButton(
            onPressed: () => ref.read(userProvider.notifier).refresh(),
            child: Text('Retry'),
          ),
        ],
      ),
      data: (user) => Column(
        children: [
          Text('Hello, ${user.name}'),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).updateName('Alice');
            },
            child: Text('Change Name'),
          ),
        ],
      ),
    );
  }
}
```

---

## Notifier vs StateNotifier

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   StateNotifier (Old Way)                           │
│   ────────────────────────                          │
│   • Constructor sets initial state                  │
│   • More boilerplate                                │
│   • Still works, still supported                    │
│                                                     │
│   Notifier (New Way - Recommended)                  │
│   ──────────────────────────────────                │
│   • build() method sets initial state               │
│   • Less boilerplate                                │
│   • Can access ref in build()                       │
│   • Better for dependencies                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Summary

| Modifier | Purpose | Example |
|----------|---------|---------|
| `.family` | Pass parameters to provider | `provider(userId)` |
| `.autoDispose` | Clean up when not used | Auto-dispose streams |
| `Notifier` | Modern sync state class | Counter, toggles |
| `AsyncNotifier` | Modern async state class | User data, API calls |

---

## Quick Reference

```dart
// .family - Accept parameters
final provider = FutureProvider.family<User, String>((ref, id) async {
  return fetchUser(id);
});
ref.watch(provider('user123'));

// .autoDispose - Clean up when done
final provider = FutureProvider.autoDispose<Data>((ref) async {
  return fetchData();
});

// Both together
final provider = FutureProvider.autoDispose.family<Post, int>(
  (ref, postId) async => fetchPost(postId),
);

// Modern Notifier
class Counter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}
final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// Modern AsyncNotifier
class UserData extends AsyncNotifier<User> {
  @override
  Future<User> build() async => fetchUser();
  Future<void> refresh() async => state = AsyncValue.guard(fetchUser);
}
final userProvider = AsyncNotifierProvider<UserData, User>(UserData.new);
```

---

## Navigation

⬅️ **Previous:** [Async with Riverpod](05a-AsyncValue.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Advanced Patterns](05c-AdvancedPatterns.md)
