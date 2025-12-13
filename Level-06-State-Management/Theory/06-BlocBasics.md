# BLoC Basics: Business Logic Component

BLoC (Business Logic Component) is like a **factory** that takes in orders (Events) and produces products (States). It's perfect for complex apps where you need clear, predictable state changes!

---

## What Is BLoC?

Imagine a pizza restaurant:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   WITHOUT BLoC:                                     │
│   ─────────────                                     │
│   Customer → Kitchen → Messy! Who ordered what?     │
│                                                     │
│   WITH BLoC:                                        │
│   ──────────                                        │
│                                                     │
│   Customer places ORDER ──► Kitchen receives order  │
│        (Event)                   (BLoC)             │
│                                     │               │
│                                     ▼               │
│                              Makes pizza            │
│                                     │               │
│                                     ▼               │
│   Customer gets PIZZA ◄─── Kitchen sends pizza     │
│        (State)                                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

In BLoC:
- **Events** = What happened (user actions)
- **BLoC** = The brain (processes events)
- **States** = The result (what to show)

---

## The BLoC Flow

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│     USER ACTION                                     │
│     (tap button)                                    │
│          │                                          │
│          ▼                                          │
│     ┌─────────┐                                     │
│     │  EVENT  │  "Add item to cart"                 │
│     └────┬────┘                                     │
│          │                                          │
│          ▼                                          │
│     ┌─────────┐                                     │
│     │  BLoC   │  Process the event                  │
│     │ (Brain) │  Update data                        │
│     └────┬────┘                                     │
│          │                                          │
│          ▼                                          │
│     ┌─────────┐                                     │
│     │  STATE  │  "Cart has 3 items"                 │
│     └────┬────┘                                     │
│          │                                          │
│          ▼                                          │
│     UI UPDATES                                      │
│     (shows 3 items)                                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Setting Up BLoC

### Step 1: Add Packages

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
```

Run:
```bash
flutter pub get
```

### Step 2: Import

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
```

---

## The Three Parts of BLoC

Every BLoC has three parts:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   1. EVENTS                                         │
│      What can happen?                               │
│      ┌─────────────────┐                            │
│      │ CounterIncrement│                            │
│      │ CounterDecrement│                            │
│      │ CounterReset    │                            │
│      └─────────────────┘                            │
│                                                     │
│   2. STATES                                         │
│      What can the UI show?                          │
│      ┌─────────────────┐                            │
│      │ CounterState    │                            │
│      │   value: 0      │                            │
│      └─────────────────┘                            │
│                                                     │
│   3. BLOC                                           │
│      How to handle events?                          │
│      ┌─────────────────┐                            │
│      │ on<Increment>   │ → state + 1               │
│      │ on<Decrement>   │ → state - 1               │
│      │ on<Reset>       │ → state = 0               │
│      └─────────────────┘                            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Part 1: Defining Events

Events are things that happen in your app. Define them as classes:

```dart
// Base event class
abstract class CounterEvent {}

// Specific events
class CounterIncrement extends CounterEvent {}

class CounterDecrement extends CounterEvent {}

class CounterReset extends CounterEvent {}

// Event with data
class CounterSetValue extends CounterEvent {
  final int value;
  CounterSetValue(this.value);
}
```

### Think of Events as Messages

```
User taps "+" button
       │
       ▼
app.add(CounterIncrement())
       │
       ▼
BLoC receives: "Someone wants to increment!"
```

---

## Part 2: Defining States

States represent what the UI should show. They can be simple or complex:

### Simple State (Just a Value)

```dart
// For a counter, state is just an int
// The BLoC will be: Bloc<CounterEvent, int>
```

### Complex State (Multiple Values)

```dart
// State class with multiple values
class CounterState {
  final int count;
  final bool isLoading;
  final String? error;

  const CounterState({
    this.count = 0,
    this.isLoading = false,
    this.error,
  });

  // Create a copy with some values changed
  CounterState copyWith({
    int? count,
    bool? isLoading,
    String? error,
  }) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
```

### Multiple State Types

```dart
// Different states for different situations
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
```

---

## Part 3: Creating the BLoC

The BLoC connects events to states:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// BLoC
class CounterBloc extends Bloc<CounterEvent, int> {
  // Initial state (0)
  CounterBloc() : super(0) {
    // Register event handlers
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
  }

  // Handle Increment event
  void _onIncrement(Increment event, Emitter<int> emit) {
    emit(state + 1);  // Emit new state
  }

  // Handle Decrement event
  void _onDecrement(Decrement event, Emitter<int> emit) {
    if (state > 0) {
      emit(state - 1);
    }
  }

  // Handle Reset event
  void _onReset(Reset event, Emitter<int> emit) {
    emit(0);
  }
}
```

### Breaking It Down

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
//                            ^^^^^^^^^^^^  ^^^
//                            Event type    State type
```

```dart
CounterBloc() : super(0) {
//                   ^^^
//               Initial state = 0
```

```dart
on<Increment>(_onIncrement);
// ^^^^^^^^   ^^^^^^^^^^^^
// Event type  Handler function
// "When Increment happens, call _onIncrement"
```

```dart
emit(state + 1);
// ^^^^^^^^^^^^
// Send new state to UI
// state = current value (e.g., 5)
// state + 1 = new value (e.g., 6)
```

---

## Using BLoC in Widgets

### Step 1: Provide the BLoC

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    // Provide the BLoC
    BlocProvider(
      create: (context) => CounterBloc(),
      child: const MyApp(),
    ),
  );
}
```

### Step 2: Read State with BlocBuilder

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Counter')),
      body: Center(
        // BlocBuilder rebuilds when state changes
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            return Text(
              '$count',
              style: const TextStyle(fontSize: 72),
            );
          },
        ),
      ),
    );
  }
}
```

### Step 3: Send Events

```dart
// Get the BLoC and add events
ElevatedButton(
  onPressed: () {
    context.read<CounterBloc>().add(Increment());
  },
  child: const Icon(Icons.add),
)

// Or using BlocProvider.of
ElevatedButton(
  onPressed: () {
    BlocProvider.of<CounterBloc>(context).add(Decrement());
  },
  child: const Icon(Icons.remove),
)
```

---

## Complete Example: Counter with BLoC

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// EVENTS
// ─────────────────────────────────────
abstract class CounterEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

class Reset extends CounterEvent {}

// ─────────────────────────────────────
// BLOC
// ─────────────────────────────────────
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) {
      if (state > 0) emit(state - 1);
    });
    on<Reset>((event, emit) => emit(0));
  }
}

// ─────────────────────────────────────
// APP
// ─────────────────────────────────────
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Counter',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// UI
// ─────────────────────────────────────
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Counter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CounterBloc>().add(Reset());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 20),

            // Display state
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Decrement());
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Increment());
                  },
                  child: const Icon(Icons.add),
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

## BlocBuilder vs BlocListener vs BlocConsumer

### BlocBuilder: Rebuild UI

Use when you need to **display** state:

```dart
BlocBuilder<CounterBloc, int>(
  builder: (context, count) {
    return Text('$count');  // Shows the count
  },
)
```

### BlocListener: Side Effects

Use when you need to **react** to state (navigation, dialogs, etc.):

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacement(context, HomeRoute());
    }
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: LoginForm(),
)
```

### BlocConsumer: Both Together

Use when you need **both** displaying and reacting:

```dart
BlocConsumer<CounterBloc, int>(
  listener: (context, count) {
    // React to changes (side effects)
    if (count == 10) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Achievement!'),
          content: Text('You reached 10!'),
        ),
      );
    }
  },
  builder: (context, count) {
    // Build UI
    return Text('$count');
  },
)
```

### When to Use Which?

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   BlocBuilder                                       │
│   • Display data on screen                          │
│   • Text, icons, colors based on state              │
│                                                     │
│   BlocListener                                      │
│   • Show snackbars                                  │
│   • Navigate to another screen                      │
│   • Show dialogs                                    │
│   • Log analytics                                   │
│                                                     │
│   BlocConsumer                                      │
│   • When you need both!                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Multiple BLoCs

Real apps often need multiple BLoCs:

```dart
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => SettingsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Accessing BLoCs

### context.read<T>() - Get BLoC Once

```dart
// Good for adding events
onPressed: () {
  context.read<CounterBloc>().add(Increment());
}
```

### context.watch<T>() - Listen for Changes

```dart
// Good in build method (rebuilds on change)
@override
Widget build(BuildContext context) {
  final count = context.watch<CounterBloc>().state;
  return Text('$count');
}
```

### BlocProvider.of<T>(context)

```dart
// Same as context.read
final bloc = BlocProvider.of<CounterBloc>(context);
bloc.add(Increment());
```

---

## The emit Function

`emit` is how you send new states from the BLoC:

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) {
      // emit sends the new state
      emit(state + 1);

      // You can emit multiple times!
      // emit(state + 1);  // This would emit again
    });
  }
}
```

### Important Rules:

1. **Only emit inside handlers** - Not in constructor or other methods
2. **Don't emit after async gaps without checking** - BLoC might be closed
3. **Emit immutable states** - Don't modify and re-emit same object

---

## Summary

| Concept | Purpose |
|---------|---------|
| Event | What happened (user action) |
| State | What to show (UI data) |
| BLoC | Processes events, emits states |
| emit() | Send new state to UI |
| BlocProvider | Make BLoC available |
| BlocBuilder | Rebuild UI when state changes |
| BlocListener | React to state (side effects) |
| BlocConsumer | Both builder and listener |

---

## Quick Quiz

**Q1:** What are the three parts of BLoC?

<details>
<summary>Answer</summary>

1. **Events** - Things that happen (user actions, triggers)
2. **States** - What the UI should display
3. **BLoC** - The class that processes events and emits states

</details>

**Q2:** When do you use BlocListener vs BlocBuilder?

<details>
<summary>Answer</summary>

- **BlocBuilder**: When you need to BUILD/DISPLAY UI based on state (Text, widgets, colors)
- **BlocListener**: When you need to DO SOMETHING in response to state (navigate, show snackbar, log)

BlocBuilder rebuilds widgets. BlocListener performs side effects.

</details>

**Q3:** How do you send an event to a BLoC?

<details>
<summary>Answer</summary>

Use `context.read<T>().add(event)`:
```dart
context.read<CounterBloc>().add(Increment());
```

Or in older style:
```dart
BlocProvider.of<CounterBloc>(context).add(Increment());
```

</details>

---

**Next:** Learn advanced BLoC patterns!

---

**Continue to:** `07-BlocAdvanced.md`
