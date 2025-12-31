# BLoC Advanced Patterns: Pro Techniques

Let's learn advanced patterns that professionals use to build complex apps with BLoC. These are like secret cooking techniques that master chefs use!

---

## BLoC-to-BLoC Communication

Sometimes one BLoC needs to react to changes in another BLoC. Like when the kitchen needs to know if the restaurant just closed!

### Pattern 1: Stream Subscription

```dart
class CartBloc extends Bloc<CartEvent, CartState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  CartBloc({required this.authBloc}) : super(CartInitial()) {
    // Listen to AuthBloc's state changes
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthLoggedOut) {
        add(ClearCart());  // Clear cart when user logs out
      }
    });

    on<ClearCart>(_onClearCart);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartInitial());
  }

  @override
  Future<void> close() {
    authSubscription.cancel();  // Clean up!
    return super.close();
  }
}
```

### Pattern 2: Using BlocListener in Widget

```dart
// In your widget tree
BlocListener<AuthBloc, AuthState>(
  listener: (context, authState) {
    if (authState is AuthLoggedOut) {
      // Tell CartBloc to clear
      context.read<CartBloc>().add(ClearCart());
    }
  },
  child: MyWidget(),
)
```

---

## Event Transformers: Controlling Event Flow

Sometimes you need to control HOW events are processed. Think of it like traffic control for your events!

### Add Package

```yaml
dependencies:
  bloc_concurrency: ^0.2.1
```

### Debounce (Wait for User to Stop Typing)

Perfect for search boxes!

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(Duration(milliseconds: 300)),
      //            ^^^^^^^^
      // Wait 300ms after user stops typing
    );
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final results = await searchRepository.search(event.query);
    emit(SearchLoaded(results));
  }
}
```

### Visual: Debounce

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   User types: "h" → "he" → "hel" → "hello"         │
│                                                     │
│   WITHOUT debounce:                                 │
│   Search for "h"    → API call                      │
│   Search for "he"   → API call                      │
│   Search for "hel"  → API call                      │
│   Search for "hello" → API call                     │
│   (4 API calls! Wasteful!)                          │
│                                                     │
│   WITH debounce (300ms):                            │
│   "h" → wait → "he" → wait → "hel" → wait           │
│   → "hello" → 300ms passed → API call!              │
│   (1 API call! Efficient!)                          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Throttle (Limit Frequency)

Prevent too many events in a short time:

```dart
on<ButtonPressed>(
  _onButtonPressed,
  transformer: throttle(Duration(seconds: 1)),
  // Allow only 1 event per second
);
```

### Sequential (One at a Time)

Process events one by one:

```dart
on<LoadData>(
  _onLoadData,
  transformer: sequential(),
  // Wait for current event to finish before processing next
);
```

### Droppable (Ignore While Busy)

Drop new events while processing one:

```dart
on<LoadData>(
  _onLoadData,
  transformer: droppable(),
  // Ignore new events while one is being processed
);
```

---

## Cubit: Simplified BLoC

For simpler cases, use Cubit - it's like BLoC but without events!

### BLoC vs Cubit

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   BLOC                          CUBIT               │
│   ────                          ─────               │
│                                                     │
│   Event → BLoC → State          Method → State     │
│                                                     │
│   More structured               Simpler             │
│   Event history                 Direct methods      │
│   Better for complex            Better for simple   │
│                                                     │
│   bloc.add(Increment())         cubit.increment()   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Creating a Cubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  //                    ^^^^
  // Extend Cubit, not Bloc

  CounterCubit() : super(0);
  //                    ^^^
  //             Initial state

  // Methods (not events!)
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}
```

### Using Cubit

```dart
// Provide
BlocProvider(
  create: (_) => CounterCubit(),
  child: MyApp(),
)

// Display
BlocBuilder<CounterCubit, int>(
  builder: (context, count) {
    return Text('$count');
  },
)

// Modify (call methods directly!)
ElevatedButton(
  onPressed: () {
    context.read<CounterCubit>().increment();
    //                          ^^^^^^^^^^^
    //                   Call method directly
  },
  child: Text('+'),
)
```

### When to Use Cubit vs BLoC

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   USE CUBIT when:                                   │
│   ──────────────                                    │
│   • Simple state (counter, toggle)                  │
│   • Few operations                                  │
│   • Don't need event history                        │
│   • Want less boilerplate                           │
│                                                     │
│   USE BLOC when:                                    │
│   ─────────────                                     │
│   • Complex state                                   │
│   • Many operations                                 │
│   • Need event tracking                             │
│   • Need event transformers                         │
│   • Better debugging needed                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Complete Cubit Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// Cubit (no events needed!)
// ─────────────────────────────────────
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
  void setValue(int value) => emit(value);
}

// ─────────────────────────────────────
// App
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cubit Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: TextStyle(fontSize: 72),
                );
              },
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().decrement(),
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().reset(),
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<CounterCubit>().increment(),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Async Cubit

Cubits can handle async operations too:

```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  Future<void> loadUser(String userId) async {
    emit(UserLoading());

    try {
      final user = await repository.getUser(userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateName(String name) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      emit(UserLoading());

      try {
        final updatedUser = await repository.updateUser(
          currentUser.copyWith(name: name),
        );
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    }
  }
}
```

---

## Summary: BLoC vs Cubit

| Feature | BLoC | Cubit |
|---------|------|-------|
| Events | Yes (explicit events) | No (direct methods) |
| Boilerplate | More | Less |
| Event history | Yes | No |
| Transformers | Yes | No |
| Use case | Complex state | Simple state |
| Example | `bloc.add(Increment())` | `cubit.increment()` |

---

## Quick Reference

```dart
// Event Transformers
on<SearchQuery>(
  handler,
  transformer: debounce(Duration(milliseconds: 300)),
  // or: throttle, sequential, droppable
);

// BLoC to BLoC Communication
class BlocA extends Bloc<EventA, StateA> {
  final BlocB blocB;
  late StreamSubscription subscription;

  BlocA(this.blocB) : super(InitialState()) {
    subscription = blocB.stream.listen((state) {
      // React to BlocB changes
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

// Cubit (Simple)
class SimpleCubit extends Cubit<int> {
  SimpleCubit() : super(0);
  void increment() => emit(state + 1);
}
```

---

## When to Use What?

```
Simple counter or toggle?
  → Use Cubit

Complex form with validation?
  → Use BLoC

Need to track event history?
  → Use BLoC

Search box with debouncing?
  → Use BLoC with debounce transformer

Simple CRUD operations?
  → Use Cubit

Complex workflow with many steps?
  → Use BLoC
```

Next, we'll learn about the Repository pattern and testing!

---

## Navigation

⬅️ **Previous:** [Async with BLoC](07a-AsyncBloc.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [BLoC Testing](07c-BlocTesting.md)
