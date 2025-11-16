# Week 12, Day 1-2: State Management Comparison & Best Practices

## Choosing the Right Solution

You've learned setState(), Riverpod, and Bloc. **Which one should you use?**

**The answer:** It depends on your needs!

Let's compare all approaches to help you decide.

---

## Quick Comparison Table

| Feature | setState() | Riverpod | Bloc |
|---------|-----------|----------|------|
| **Learning Curve** | Easy | Moderate | Steep |
| **Boilerplate** | Minimal | Low | High |
| **Scalability** | Poor | Excellent | Excellent |
| **Testing** | Hard | Good | Excellent |
| **Performance** | Good | Excellent | Excellent |
| **Best For** | Small widgets | Most apps | Complex flows |
| **State Sharing** | Hard | Easy | Easy |
| **Debugging** | Basic | Good | Advanced |

---

## setState() - Built-in Solution

### ✅ Use When:

1. **Single widget state**
   - Counter in one screen
   - Form in one widget
   - Toggle button

2. **Simple, isolated changes**
   - No need to share state
   - No complex logic

3. **Learning/Prototyping**
   - Just starting Flutter
   - Quick demos

### ❌ Avoid When:

1. **Multiple widgets need same state**
2. **Complex state logic**
3. **Need to test business logic**
4. **App is growing**

### Example

```dart
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _count++;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**Pros:**
- ✓ No dependencies
- ✓ Easy to understand
- ✓ Fast to implement

**Cons:**
- ✗ State tied to widget
- ✗ Hard to share
- ✗ Hard to test
- ✗ Rebuilds entire widget

---

## Riverpod - Modern & Flexible

### ✅ Use When:

1. **Most applications**
   - E-commerce apps
   - Social media apps
   - Dashboard apps

2. **Need state sharing**
   - User profile across screens
   - Shopping cart
   - Theme settings

3. **Want quick development**
   - Minimal boilerplate
   - Fast iteration

4. **Moderate complexity**
   - 5-50 screens
   - Multiple features

### ❌ Avoid When:

1. **Very simple apps** (setState is enough)
2. **Need event tracking** (Bloc is better)
3. **Very complex event flows** (Bloc is better)

### Example

```dart
// Define provider
final counterProvider = StateProvider<int>((ref) => 0);

// Use anywhere
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**Pros:**
- ✓ Easy to learn (compared to Bloc)
- ✓ Share state easily
- ✓ No BuildContext needed
- ✓ Testable
- ✓ Compile-time safety
- ✓ Less boilerplate

**Cons:**
- ✗ Extra dependency
- ✗ No event tracking
- ✗ Learning curve (compared to setState)

---

## Bloc - Enterprise Grade

### ✅ Use When:

1. **Complex business logic**
   - Banking apps
   - Healthcare apps
   - Enterprise software

2. **Need event tracking**
   - Analytics
   - Debugging complex flows
   - Audit trails

3. **Large teams**
   - Clear separation of concerns
   - Predictable patterns

4. **Need time-travel debugging**
   - Step through state changes
   - Replay events

### ❌ Avoid When:

1. **Simple apps** (overkill)
2. **Small teams** (too much ceremony)
3. **Rapid prototyping** (too much boilerplate)

### Example

```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}

// States
class CounterState {
  final int count;
  CounterState(this.count);
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) {
      emit(CounterState(state.count + 1));
    });
  }
}

// UI
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Column(
      children: [
        Text('${state.count}'),
        ElevatedButton(
          onPressed: () {
            context.read<CounterBloc>().add(Increment());
          },
          child: Text('Increment'),
        ),
      ],
    );
  },
)
```

**Pros:**
- ✓ Excellent for complex logic
- ✓ Event tracking built-in
- ✓ Best testing story
- ✓ Time-travel debugging
- ✓ Clear patterns
- ✓ Great for large teams

**Cons:**
- ✗ Steep learning curve
- ✗ More boilerplate
- ✗ Overkill for simple apps
- ✗ Slower development

---

## Real-World Decision Guide

### Scenario 1: Todo App

**App size:** 5-10 screens
**Features:** Add, edit, delete, filter todos
**Team:** 1-2 developers

**Recommendation:** **Riverpod**

**Why:**
- Moderate complexity
- Need state sharing (todos across screens)
- Quick development
- Easy to maintain

```dart
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
```

### Scenario 2: Social Media App

**App size:** 50+ screens
**Features:** Posts, comments, likes, messaging, notifications
**Team:** 5+ developers

**Recommendation:** **Bloc**

**Why:**
- Complex business logic
- Need event tracking (analytics)
- Large team needs clear patterns
- Complex state flows

```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  // Track all post events
  // Like, comment, share, save
}
```

### Scenario 3: Settings Screen

**App size:** 1 screen
**Features:** Toggle switches, theme picker
**Team:** Any size

**Recommendation:** **setState()**

**Why:**
- Simple, isolated state
- No sharing needed
- Quick to implement

```dart
bool _isDarkMode = false;

setState(() {
  _isDarkMode = !_isDarkMode;
});
```

### Scenario 4: E-commerce App

**App size:** 20-30 screens
**Features:** Products, cart, checkout, orders
**Team:** 2-4 developers

**Recommendation:** **Riverpod**

**Why:**
- Medium complexity
- State sharing (cart, user)
- Faster development than Bloc
- Good enough for this scale

```dart
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
```

---

## Mixing Solutions

**You can use multiple approaches in one app!**

### Good Pattern

```dart
// Global state with Riverpod
final userProvider = StateProvider<User?>((ref) => null);
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(...);

// Local state with setState()
class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;  // Local animation state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: AnimatedContainer(
        scale: _isPressed ? 0.95 : 1.0,
        // ...
      ),
    );
  }
}
```

**Rule:** Use setState() for **local UI state**, Riverpod/Bloc for **business logic**.

---

## Migration Path

### From setState() to Riverpod

**Before (setState):**
```dart
class _UserScreenState extends State<UserScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await api.fetchUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return CircularProgressIndicator();
    return Text(_user!.name);
  }
}
```

**After (Riverpod):**
```dart
final userProvider = FutureProvider<User>((ref) async {
  return await api.fetchUser();
});

class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

**Benefits:**
- Less code
- Automatic loading/error states
- Testable
- Reusable

---

## Performance Comparison

### setState()

```dart
// Rebuilds ENTIRE widget tree under setState
setState(() {
  _count++;  // Everything rebuilds!
});
```

**Problem:** Inefficient for large widgets.

### Riverpod

```dart
// Only rebuilds widgets watching this provider
ref.read(counterProvider.notifier).state++;
```

**Better:** Surgical rebuilds.

### Bloc

```dart
// Only BlocBuilder rebuilds
context.read<CounterBloc>().add(Increment());
```

**Best:** Fine-grained control.

---

## Testing Comparison

### setState() - Hard to Test

```dart
// Can't test business logic separately
// Must test through widget
testWidgets('increment counter', (tester) async {
  await tester.pumpWidget(CounterWidget());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

### Riverpod - Easy to Test

```dart
test('counter increments', () {
  final container = ProviderContainer();
  expect(container.read(counterProvider), 0);

  container.read(counterProvider.notifier).state++;
  expect(container.read(counterProvider), 1);
});
```

### Bloc - Easiest to Test

```dart
blocTest<CounterBloc, CounterState>(
  'emits [1] when Increment is added',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(Increment()),
  expect: () => [CounterState(1)],
);
```

---

## Code Organization

### setState() Structure

```
lib/
├── screens/
│   ├── home_screen.dart         # State inside
│   └── profile_screen.dart      # State inside
└── main.dart
```

**Problem:** Logic mixed with UI.

### Riverpod Structure

```
lib/
├── providers/
│   ├── user_provider.dart       # Business logic
│   ├── cart_provider.dart
│   └── products_provider.dart
├── screens/
│   ├── home_screen.dart         # UI only
│   └── cart_screen.dart
├── models/
│   └── user.dart
└── main.dart
```

**Better:** Separation of concerns.

### Bloc Structure

```
lib/
├── bloc/
│   ├── user/
│   │   ├── user_bloc.dart
│   │   ├── user_event.dart
│   │   └── user_state.dart
│   └── cart/
│       ├── cart_bloc.dart
│       ├── cart_event.dart
│       └── cart_state.dart
├── screens/
│   ├── home_screen.dart
│   └── cart_screen.dart
├── models/
│   └── user.dart
└── main.dart
```

**Best:** Clear structure, great for teams.

---

## Common Mistakes

### Mistake 1: Using Bloc for Everything

```dart
// DON'T do this for simple state
class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  // Overkill for button press animation!
}

// DO this instead
bool _isPressed = false;
setState(() => _isPressed = !_isPressed);
```

### Mistake 2: Using setState() for Global State

```dart
// DON'T pass state down manually
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(user: user);  // Prop drilling!
  }
}

// DO use state management
final userProvider = StateProvider<User?>((ref) => null);
```

### Mistake 3: Not Using Any State Management

```dart
// DON'T use global variables
User? globalUser;  // BAD!

void login(User user) {
  globalUser = user;
}

// DO use proper state management
final userProvider = StateProvider<User?>((ref) => null);
```

---

## My Recommendation by App Type

### Simple Apps (Calculator, Stopwatch)
**Use:** setState()
- Fast
- No dependencies
- Perfect for learning

### Most Apps (Todo, E-commerce, Social)
**Use:** Riverpod
- Great balance
- Quick development
- Scales well
- Easy to learn

### Enterprise Apps (Banking, Healthcare)
**Use:** Bloc
- Best structure
- Event tracking
- Team collaboration
- Testing

### Hybrid Approach (Recommended!)
**Use:** Riverpod + setState()
- Riverpod for business logic
- setState() for local UI state
- Best of both worlds

---

## Migration Strategy

### Step 1: Identify State Types

```dart
// Local UI state → Keep setState()
bool _isExpanded = false;
bool _showPassword = false;

// Business logic → Migrate to Riverpod/Bloc
User? _user;
List<Product> _cart;
bool _isLoading;
```

### Step 2: Migrate Gradually

Start with one feature at a time:

1. Week 1: User authentication → Riverpod
2. Week 2: Shopping cart → Riverpod
3. Week 3: Product catalog → Riverpod
4. Keep UI animations in setState()

### Step 3: Refactor

```dart
// Before: Mixed concerns
class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];
  bool _isLoading = false;

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    _products = await api.fetchProducts();
    setState(() => _isLoading = false);
  }
}

// After: Separated concerns
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return await api.fetchProducts();
});

class ProductScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    // Clean UI code
  }
}
```

---

## Decision Flowchart

```
Start
  │
  ├─ Is it local UI state (animation, focus)?
  │   └─ YES → Use setState()
  │
  ├─ Is it a simple app (< 5 screens)?
  │   └─ YES → Use setState() or Riverpod
  │
  ├─ Need event tracking or time-travel debugging?
  │   └─ YES → Use Bloc
  │
  ├─ Complex business logic with many events?
  │   └─ YES → Use Bloc
  │
  └─ Everything else
      └─ Use Riverpod
```

---

## Key Takeaways

1. **setState()** = Local UI state, simple apps
2. **Riverpod** = Most apps, balanced solution
3. **Bloc** = Enterprise apps, complex flows
4. **Mix solutions** = Use right tool for each job
5. **Start simple** = Can migrate later
6. **Test business logic** = Separate from UI
7. **Team size matters** = Bigger team → More structure

---

## What's Next?

Tomorrow: **State Persistence**
- Saving state to disk
- Hydration on app start
- SharedPreferences integration
- Secure storage for sensitive data

You've mastered choosing the right state management! 🎯✨
