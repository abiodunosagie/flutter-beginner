# State Management - Interview Questions

## The Big Idea In One Sentence

> Be ready to compare approaches (setState, Provider, Riverpod, Bloc), explain when you would pick each, and describe the principles (single source of truth, separation of UI and logic) behind all of them.

Master state management concepts - critical for any Flutter interview!

---

## Core Concepts

### Q1: What is state in Flutter?

**Answer:**

State is data that can change over time and affects what's displayed on screen.

```dart
// Example: Counter state
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;  // ← This is STATE

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count'),  // UI depends on state
        ElevatedButton(
          onPressed: () {
            setState(() {
              _count++;  // Change state → UI updates
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**Types of state:**
```
1. Ephemeral (Local) State
   - Lives in one widget
   - Example: current tab, form input, animation progress

2. App State (Global/Shared)
   - Shared across multiple widgets
   - Example: user login, shopping cart, theme
```

**Memory tip:** State = "Things that change and affect UI"

---

### Q2: What's the difference between ephemeral state and app state?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// EPHEMERAL STATE - Local to one widget
// ═══════════════════════════════════════════════════════════

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentTab = 0;  // Ephemeral state - only this widget cares

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          currentIndex: _currentTab,
          onTap: (index) => setState(() => _currentTab = index),
        ),
        _buildTabContent(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// APP STATE - Shared across multiple widgets
// ═══════════════════════════════════════════════════════════

// User logged in? Many widgets need to know!
class UserState {
  final bool isLoggedIn;
  final User? user;

  UserState({required this.isLoggedIn, this.user});
}

// Shopping cart - multiple screens need this
class CartState {
  final List<Product> items;
  final double total;

  CartState({required this.items, required this.total});
}
```

**When to use each:**

```
Ephemeral State (setState):
✅ Current page in PageView
✅ Selected tab
✅ Form input values
✅ Animation progress
✅ Bottom sheet open/closed

App State (Provider/Riverpod/Bloc):
✅ User authentication
✅ Shopping cart
✅ App settings
✅ API data
✅ Theme mode
```

**Memory tip:** Ephemeral = local, App = shared

---

## setState Questions

### Q3: What is setState and how does it work?

**Answer:**

`setState()` tells Flutter to rebuild the widget with new state.

```dart
class _MyWidgetState extends State<MyWidget> {
  int _count = 0;

  void _increment() {
    // ❌ WRONG - Won't update UI
    _count++;

    // ✅ CORRECT - Updates UI
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    return Text('$_count');
  }
}
```

**What setState does:**
```
1. Runs the callback function
2. Marks widget as "dirty"
3. Schedules a rebuild
4. Calls build() method
5. Updates the UI
```

**Common mistakes:**
```dart
// ❌ WRONG - async in setState
setState(() async {
  final data = await fetchData();
  _data = data;
});

// ✅ CORRECT - await before setState
void loadData() async {
  final data = await fetchData();
  setState(() {
    _data = data;
  });
}

// ❌ WRONG - Heavy computation in setState
setState(() {
  _result = _expensiveCalculation();  // Blocks UI!
});

// ✅ CORRECT - Compute first, then setState
void calculate() {
  final result = _expensiveCalculation();
  setState(() {
    _result = result;
  });
}
```

---

### Q4: When should you NOT use setState?

**Answer:**

**Don't use setState when:**

1. **In StatelessWidget** (no state to set)
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setState(() {});  // ❌ Error! No setState in StatelessWidget
    return Container();
  }
}
```

2. **After dispose()** (widget removed)
```dart
class _MyWidgetState extends State<MyWidget> {
  Future<void> loadData() async {
    final data = await fetchData();

    // ❌ Might crash if widget disposed during fetch
    setState(() => _data = data);

    // ✅ Check if still mounted
    if (mounted) {
      setState(() => _data = data);
    }
  }
}
```

3. **Outside the State class**
```dart
class Helper {
  void updateWidget(_MyWidgetState state) {
    state.setState(() {});  // ❌ Don't do this!
  }
}
```

4. **For shared state across multiple widgets** (use state management)
```dart
// ❌ setState doesn't share state between widgets
// Use Provider, Riverpod, or Bloc instead
```

---

## Provider

### Q5: What is Provider and how does it work?

**Answer:**

Provider is a wrapper around InheritedWidget that makes sharing state easy.

```dart
// 1. Create a model
class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();  // Tell listeners to rebuild
  }
}

// 2. Provide it at the top
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: MyApp(),
    ),
  );
}

// 3. Consume it anywhere
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen to changes
    final counter = context.watch<Counter>();

    return Text('${counter.count}');
  }
}

class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Don't listen, just read
    final counter = context.read<Counter>();

    return ElevatedButton(
      onPressed: () => counter.increment(),
      child: Text('Add'),
    );
  }
}
```

**Key methods:**
```dart
// watch - Listen for changes, rebuilds when state changes
context.watch<Counter>()

// read - Get once, doesn't rebuild
context.read<Counter>()

// select - Listen to specific property only
context.select<Counter, int>((c) => c.count)
```

**Memory tip:** Provider = "Provide state from top, consume at bottom"

---

### Q6: What's the difference between ChangeNotifier and ValueNotifier?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// ChangeNotifier - For complex objects with multiple properties
// ═══════════════════════════════════════════════════════════

class UserModel with ChangeNotifier {
  String _name = '';
  int _age = 0;

  String get name => _name;
  int get age => _age;

  void updateName(String name) {
    _name = name;
    notifyListeners();  // Manual notification
  }

  void updateAge(int age) {
    _age = age;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════
// ValueNotifier - For single value (simpler)
// ═══════════════════════════════════════════════════════════

final counter = ValueNotifier<int>(0);

// Automatically notifies on change
counter.value++;  // Listeners notified automatically!

// Listen to changes
ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, child) {
    return Text('$value');
  },
)
```

**When to use:**
- `ChangeNotifier`: Complex objects, multiple properties
- `ValueNotifier`: Single value (counter, toggle, selection)

---

## Riverpod

### Q7: What's the difference between Provider and Riverpod?

**Answer:**

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   PROVIDER                  RIVERPOD                    │
│   ────────                  ────────                    │
│                                                         │
│   ❌ Needs BuildContext     ✅ No BuildContext needed   │
│                                                         │
│   ❌ Runtime errors         ✅ Compile-time safety      │
│      (Provider not found)                               │
│                                                         │
│   ❌ Hard to test           ✅ Easy to test             │
│                                                         │
│   ❌ In widget tree         ✅ Global (outside tree)    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Example comparison:**

```dart
// ═══════════════════════════════════════════════════════════
// PROVIDER (old way)
// ═══════════════════════════════════════════════════════════

// Must provide in tree
ChangeNotifierProvider(
  create: (_) => Counter(),
  child: MyApp(),
);

// Need context to access
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    return Text('${counter.count}');
  }
}

// ═══════════════════════════════════════════════════════════
// RIVERPOD (new way)
// ═══════════════════════════════════════════════════════════

// Define globally (outside any class)
final counterProvider = StateProvider<int>((ref) => 0);

// One-time setup
void main() {
  runApp(ProviderScope(child: MyApp()));
}

// Access anywhere, no context needed!
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

---

### Q8: Explain Riverpod provider types

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// 1. Provider - Read-only, computed values
// ═══════════════════════════════════════════════════════════

final greetingProvider = Provider<String>((ref) {
  return 'Hello, World!';
});

final doubledProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

// ═══════════════════════════════════════════════════════════
// 2. StateProvider - Simple mutable state
// ═══════════════════════════════════════════════════════════

final counterProvider = StateProvider<int>((ref) => 0);

// Modify:
ref.read(counterProvider.notifier).state++;

// ═══════════════════════════════════════════════════════════
// 3. StateNotifierProvider - Complex state with methods
// ═══════════════════════════════════════════════════════════

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void add(Todo todo) => state = [...state, todo];
  void remove(String id) => state = state.where((t) => t.id != id).toList();
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

// ═══════════════════════════════════════════════════════════
// 4. FutureProvider - Async data (one-time)
// ═══════════════════════════════════════════════════════════

final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});

// Usage:
final userAsync = ref.watch(userProvider);
userAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
  data: (user) => Text('Hello ${user.name}'),
);

// ═══════════════════════════════════════════════════════════
// 5. StreamProvider - Continuous data stream
// ═══════════════════════════════════════════════════════════

final messagesProvider = StreamProvider<List<Message>>((ref) {
  return messageStream();
});
```

**Quick guide:**
- `Provider`: Never changes or computed
- `StateProvider`: Simple values (int, bool, String)
- `StateNotifierProvider`: Complex objects with methods
- `FutureProvider`: API calls, one-time async
- `StreamProvider`: Real-time data

---

## BLoC

### Q9: What is BLoC pattern?

**Answer:**

BLoC (Business Logic Component) separates business logic from UI using streams.

```dart
// ═══════════════════════════════════════════════════════════
// Events - User actions
// ═══════════════════════════════════════════════════════════

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

// ═══════════════════════════════════════════════════════════
// States - UI states
// ═══════════════════════════════════════════════════════════

class CounterState {
  final int count;
  CounterState(this.count);
}

// ═══════════════════════════════════════════════════════════
// BLoC - Business logic
// ═══════════════════════════════════════════════════════════

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<IncrementEvent>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<DecrementEvent>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}

// ═══════════════════════════════════════════════════════════
// UI - Separate from logic
// ═══════════════════════════════════════════════════════════

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('${state.count}'),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(IncrementEvent());
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
```

**Flow:**
```
UI → Event → BLoC → State → UI
```

**Why use BLoC:**
- Clear separation (logic vs UI)
- Testable (test BLoC without UI)
- Predictable (events → states)

---

### Q10: Explain BlocBuilder vs BlocListener vs BlocConsumer

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// BlocBuilder - Rebuild UI when state changes
// ═══════════════════════════════════════════════════════════

BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('${state.count}');  // Rebuilds on every state change
  },
)

// ═══════════════════════════════════════════════════════════
// BlocListener - React to state changes (side effects)
// ═══════════════════════════════════════════════════════════

BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    // Don't rebuild, just perform action
    if (state is AuthSuccess) {
      Navigator.push(context, HomeRoute());
    }
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: LoginForm(),  // Child doesn't rebuild
)

// ═══════════════════════════════════════════════════════════
// BlocConsumer - Both builder AND listener
// ═══════════════════════════════════════════════════════════

BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Side effects
    if (state is AuthError) {
      showSnackBar(state.message);
    }
  },
  builder: (context, state) {
    // Rebuild UI
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return LoginForm();
  },
)
```

**When to use:**
- `BlocBuilder`: Update UI
- `BlocListener`: Navigation, snackbars, dialogs
- `BlocConsumer`: Both UI update AND side effects

---

## Comparison Questions

### Q11: When to use setState vs Provider vs Riverpod vs BLoC?

**Answer:**

```
setState
────────
✅ Use when: Local state, simple widget
✅ Examples: Form input, tab selection, animation
❌ Don't use: Shared state, complex logic

class _FormState extends State<FormWidget> {
  String _input = '';  // Local state

  void _onChange(String value) {
    setState(() => _input = value);
  }
}


Provider / Riverpod
───────────────────
✅ Use when: Shared state across widgets
✅ Examples: User auth, cart, settings
❌ Don't use: Very complex business logic

final cartProvider = StateNotifierProvider<Cart, CartState>(...);


BLoC
────
✅ Use when: Complex business logic, need predictability
✅ Examples: Large apps, team projects, need testing
❌ Don't use: Simple apps, rapid prototyping

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  // Complex logic: validation, API, payment, etc.
}


Quick Guide:
────────────
• Small widget state → setState
• Shared simple state → Provider/Riverpod
• Complex logic → BLoC
• Very large app → BLoC + Riverpod (combined!)
```

---

### Q12: What is InheritedWidget?

**Answer:**

`InheritedWidget` is Flutter's way to pass data down the tree efficiently.

```dart
class MyInheritedWidget extends InheritedWidget {
  final int count;

  MyInheritedWidget({required this.count, required Widget child})
      : super(child: child);

  // This tells Flutter when to notify dependents
  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return count != oldWidget.count;  // Notify if count changed
  }

  // Helper to access from anywhere below in tree
  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }
}

// Usage:
MyInheritedWidget(
  count: 42,
  child: MyApp(),
)

// Access anywhere below:
final count = MyInheritedWidget.of(context)?.count;
```

**Key points:**
- Provider is built on InheritedWidget
- Theme, MediaQuery use InheritedWidget
- Most apps don't use InheritedWidget directly (use Provider/Riverpod instead)

**Memory tip:** InheritedWidget = "Pass data down tree without props drilling"

---

## Summary Table

| Solution | Use Case | Complexity | Learning Curve |
|----------|----------|------------|----------------|
| `setState` | Local widget state | Low | Easy |
| `InheritedWidget` | Foundation (rarely used directly) | Medium | Medium |
| `Provider` | Shared state, simple-medium apps | Medium | Easy |
| `Riverpod` | Shared state, better than Provider | Medium | Medium |
| `BLoC` | Complex logic, large teams | High | Hard |
| `GetX` | All-in-one (state + routing + more) | Medium | Easy |

---

## Quick Fire Questions

**Q: Can you use multiple state management solutions?**
A: Yes! Use setState for local state, Riverpod for app state.

**Q: What is the purpose of notifyListeners()?**
A: Tells all listeners that state changed, triggers rebuild.

**Q: What's the difference between ref.watch and ref.read in Riverpod?**
A: `watch` listens and rebuilds, `read` gets once without listening.

**Q: Why not just use global variables?**
A: They don't trigger rebuilds when changed. State management notifies widgets to update.

---

## Assignment

Answer each out loud, then check.

### Problem 1: setState vs a state library

When is plain `setState` enough, and when would you reach for Provider/Riverpod/Bloc?

### Problem 2: Compare two

In one sentence each, contrast Provider and Bloc.

### Problem 3: The principle

Name one principle that applies to all state management approaches.

---

## Assignment Answers

### Problem 1: setState vs a state library

`setState` is fine for local state inside one widget. Use a library when state is shared across many widgets/screens or the logic grows complex.

### Problem 2: Compare two

Provider is simple and great for sharing state with `ChangeNotifier`. Bloc is more structured and event-driven, better for complex flows that benefit from clear, traceable state changes.

### Problem 3: The principle

Any of: single source of truth, separate UI from logic, one-way/predictable data flow.

---

**Continue to:** `05-PerformanceBestPractices.md`
