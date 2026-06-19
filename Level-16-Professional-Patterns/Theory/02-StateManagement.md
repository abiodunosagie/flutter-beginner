# State Management Deep Dive

## The Big Idea In One Sentence

> At a professional level, good state management is about clear rules: keep state in one predictable place, make changes flow one direction, and keep UI separate from logic, no matter which tool (Provider, Riverpod, Bloc) you use.

## The Simple Explanation

State management is like keeping track of everyone's order in a restaurant. As orders come in, get prepared, and are served, you need a system to track what's happening. The bigger the restaurant, the better the system needs to be!

```
┌─────────────────────────────────────────────────────────────┐
│                STATE MANAGEMENT EVOLUTION                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SMALL APP (1-3 screens):                                    │
│  └── setState() is fine!                                    │
│      Like a food truck - one person tracks everything       │
│                                                              │
│  MEDIUM APP (4-10 screens):                                  │
│  └── Provider or Riverpod                                   │
│      Like a small café - need order tickets                 │
│                                                              │
│  LARGE APP (10+ screens):                                    │
│  └── BLoC or Riverpod with architecture                    │
│      Like a restaurant chain - need full system             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Provider Pattern

Provider is the recommended starting point for state management.

### Basic Provider

```dart
// Step 1: Create a ChangeNotifier
class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();  // Tell widgets to rebuild
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

// Step 2: Provide it at the top of your app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MyApp(),
    ),
  );
}

// Step 3: Use it in widgets
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Read (rebuilds when count changes)
    final count = context.watch<CounterProvider>().count;

    return Scaffold(
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        // Write (doesn't rebuild)
        onPressed: () => context.read<CounterProvider>().increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Multiple Providers

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

### Provider Best Practices

```dart
// ✅ GOOD: Separate concerns
class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await AuthService.login(email, password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// ❌ BAD: Everything in one provider
class AppProvider extends ChangeNotifier {
  User? user;
  List<Product> products = [];
  Cart cart = Cart();
  ThemeMode theme = ThemeMode.light;
  // Too many responsibilities!
}
```

---

## Riverpod Pattern

Riverpod is Provider's successor with compile-time safety and more features.

### Basic Riverpod

```dart
// Step 1: Create providers (outside of widgets)
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

// Step 2: Wrap app with ProviderScope
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Step 3: Use ConsumerWidget
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Different Provider Types

```dart
// Simple value
final nameProvider = Provider<String>((ref) => 'Flutter');

// Mutable state
final countProvider = StateProvider<int>((ref) => 0);

// Complex state with notifier
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

// Async data (loading, error, data states)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return await ProductRepository().getAll();
});

// Real-time stream
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return ChatService().messageStream;
});

// Computed value
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.items.fold(0, (sum, item) => sum + item.price);
});
```

### Riverpod with AsyncValue

```dart
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return await ref.read(productRepositoryProvider).getAll();
});

class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(products[index]),
      ),
    );
  }
}
```

---

## BLoC Pattern

BLoC (Business Logic Component) separates business logic from UI completely.

### Basic BLoC

```dart
// Events - What can happen
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

// State - Current data
class CounterState {
  final int count;
  CounterState(this.count);
}

// BLoC - Business logic
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
```

### Using BLoC in Widgets

```dart
// Provide the BLoC
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterBloc(),
      child: MyApp(),
    ),
  );
}

// Use with BlocBuilder
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Center(child: Text('Count: ${state.count}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterBloc>().add(IncrementEvent());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Real-World BLoC Example

```dart
// EVENTS
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

// STATES
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// BLOC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await repository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthInitial());
  }
}

// WIDGET
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return LoginForm(
          onSubmit: (email, password) {
            context.read<AuthBloc>().add(LoginRequested(email, password));
          },
        );
      },
    );
  }
}
```

---

## Comparing Approaches

```
┌─────────────────────────────────────────────────────────────┐
│           STATE MANAGEMENT COMPARISON                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  PROVIDER:                                                   │
│  ├── Pros: Simple, official Flutter team                   │
│  ├── Cons: No compile-time safety, global state            │
│  └── Best for: Small to medium apps                         │
│                                                              │
│  RIVERPOD:                                                   │
│  ├── Pros: Type-safe, testable, powerful                   │
│  ├── Cons: More boilerplate, learning curve                │
│  └── Best for: Medium to large apps                         │
│                                                              │
│  BLOC:                                                       │
│  ├── Pros: Clear separation, scalable, testable            │
│  ├── Cons: Lots of boilerplate, steep learning curve       │
│  └── Best for: Large apps, team projects                    │
│                                                              │
│  RECOMMENDATION:                                             │
│  Start with Provider → Graduate to Riverpod → Use BLoC     │
│  when needed for specific complex features                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management Best Practices

### 1. Keep State Close to Where It's Used

```dart
// ❌ BAD: Everything in global state
class AppState extends ChangeNotifier {
  bool isDialogOpen = false;  // This is UI state, not app state!
  String searchQuery = '';    // This is screen-local state!
}

// ✅ GOOD: Local state stays local
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';  // Screen-local state

  // ...
}
```

### 2. Separate UI State from Business State

```dart
// ✅ GOOD: Clear separation
class ProductsProvider extends ChangeNotifier {
  // Business state
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Business logic
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 3. Use Immutable State When Possible

```dart
// ✅ GOOD: Immutable state
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,  // Intentionally allows null
    );
  }
}

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(const TodoState());

  void addTodo(Todo todo) {
    state = state.copyWith(
      todos: [...state.todos, todo],
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│          STATE MANAGEMENT SUMMARY                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  PROVIDER:                                                   │
│  ├── ChangeNotifierProvider for mutable state              │
│  ├── context.watch() to listen                              │
│  ├── context.read() for actions                             │
│  └── Great starting point                                   │
│                                                              │
│  RIVERPOD:                                                   │
│  ├── StateNotifierProvider for complex state               │
│  ├── FutureProvider for async data                         │
│  ├── ref.watch() and ref.read()                            │
│  └── Better for larger apps                                 │
│                                                              │
│  BLOC:                                                       │
│  ├── Events trigger state changes                          │
│  ├── BlocBuilder to display state                          │
│  ├── BlocListener for side effects                         │
│  └── Best for complex business logic                        │
│                                                              │
│  KEY PRINCIPLES:                                             │
│  ├── Keep state as local as possible                       │
│  ├── Separate UI state from business state                 │
│  ├── Use immutable state                                    │
│  └── Choose complexity appropriate to your app              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does "single source of truth" mean for state?

<details>
<summary>Answer</summary>
Each piece of state lives in exactly one place, so the UI always reads the same value and there are no conflicting copies.
</details>

**Q2.** Why keep UI separate from state logic?

<details>
<summary>Answer</summary>
So you can test the logic without the UI, reuse it, and change one without breaking the other.
</details>

**Q3.** Does the choice of tool (Provider/Riverpod/Bloc) change these principles?

<details>
<summary>Answer</summary>
No. The principles (single source of truth, one-way data flow, separated logic) apply to all of them.
</details>

---

## Assignment

### Problem 1: Spot the smell

Two screens each keep their own copy of the logged-in user. What principle does this break?

### Problem 2: One direction

In one line, why is one-way data flow easier to reason about?

### Problem 3: Tool-agnostic

Name one principle that stays the same whether you use Bloc or Riverpod.

---

## Assignment Answers

### Problem 1: Spot the smell

It breaks "single source of truth", two copies can disagree. The user should live in one shared place both screens read.

### Problem 2: One direction

You always know where changes come from (events flow one way to update state, state flows to the UI), so bugs are easier to trace.

### Problem 3: Tool-agnostic

Any of: single source of truth, separate UI from logic, one-way data flow, or make state changes explicit/predictable.

---

**Next:** `03-DependencyInjection.md` - Making code modular and testable
