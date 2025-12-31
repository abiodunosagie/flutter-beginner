# Creating a BLoC: Building Your Kitchen

Now let's learn how to actually build a BLoC! We'll create the "kitchen" that processes events and produces states.

---

## The Three Steps

Creating a BLoC involves three steps:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   STEP 1: Define States                             │
│   What can the UI show?                             │
│                                                     │
│   STEP 2: Define Events                             │
│   What actions can happen?                          │
│                                                     │
│   STEP 3: Create the BLoC                           │
│   How to handle each event?                         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Step 1: Defining States

States represent what your UI displays. There are three approaches:

### Approach 1: Simple State (Just a Value)

For simple cases like a counter:

```dart
// State is just an int
// The BLoC will be: Bloc<CounterEvent, int>

// Example values:
// 0 (initial state)
// 5 (after incrementing 5 times)
// 0 (after reset)
```

### Approach 2: Complex State (Single Class)

For multiple related values:

```dart
class CounterState {
  final int count;
  final bool isLoading;
  final String? error;

  const CounterState({
    this.count = 0,
    this.isLoading = false,
    this.error,
  });

  // Create a copy with changes
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

### Approach 3: Multiple State Types

For different situations:

```dart
// Base state
abstract class UserState {}

// Initial state (nothing loaded yet)
class UserInitial extends UserState {}

// Loading state (fetching data)
class UserLoading extends UserState {}

// Success state (data loaded)
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

// Error state (something went wrong)
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
```

### Choosing an Approach

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Simple State (int, String, bool):                 │
│   • Counter                                         │
│   • Selected index                                  │
│   • Toggle value                                    │
│                                                     │
│   Complex State (class with copyWith):              │
│   • Form with multiple fields                       │
│   • Settings with many options                      │
│   • Game state (score, level, lives)                │
│                                                     │
│   Multiple State Types (abstract + subclasses):     │
│   • Loading data from API                           │
│   • Complex workflows                               │
│   • States that are fundamentally different         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Step 2: Defining Events

Events represent actions that can happen:

```dart
// Base event class
abstract class CounterEvent {}

// Simple events (no data)
class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

class Reset extends CounterEvent {}

// Events with data
class SetValue extends CounterEvent {
  final int value;
  SetValue(this.value);
}

class AddNumber extends CounterEvent {
  final int number;
  AddNumber(this.number);
}
```

---

## Step 3: Creating the BLoC Class

Now let's put it all together:

### Basic Structure

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  //                         ^^^^^^^^^^^^  ^^^
  //                         Event type    State type

  // Constructor: Set initial state
  CounterBloc() : super(0) {
    //                ^^^
    //        Initial state = 0

    // Register event handlers
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
  }

  // Event handler methods
  void _onIncrement(Increment event, Emitter<int> emit) {
    emit(state + 1);
  }

  void _onDecrement(Decrement event, Emitter<int> emit) {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void _onReset(Reset event, Emitter<int> emit) {
    emit(0);
  }
}
```

---

## Breaking Down the Syntax

### Part 1: Class Declaration

```dart
class CounterBloc extends Bloc<CounterEvent, int>
//    ^^^^^^^^^^^        ^^^^  ^^^^^^^^^^^^  ^^^
//    Your BLoC name     Base   Event type   State type
```

### Part 2: Constructor and Initial State

```dart
CounterBloc() : super(0) {
//  Constructor    ^^^^
//              Initial state

  // Register handlers
  on<Increment>(_onIncrement);
  //  ^^^^^^^^  ^^^^^^^^^^^^
  //  Event     Handler function
}
```

### Part 3: Event Handlers

```dart
void _onIncrement(Increment event, Emitter<int> emit) {
//   ^^^^^^^^^^^^  ^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^
//   Handler name  Event received  State emitter

  emit(state + 1);
  //   ^^^^^
  //   Current state
}
```

The `on<Event>` method says:
"When this event happens, call this handler"

---

## The emit() Function

`emit()` is how you send new states to the UI:

```dart
void _onIncrement(Increment event, Emitter<int> emit) {
  // Current state
  final current = state;  // e.g., 5

  // Calculate new state
  final newState = current + 1;  // e.g., 6

  // Send new state to UI
  emit(newState);  // UI rebuilds with 6
}

// Shorter version:
void _onIncrement(Increment event, Emitter<int> emit) {
  emit(state + 1);
}
```

### Visual Flow

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   Current State: 5                                  │
│                                                     │
│   User taps button → Increment event sent           │
│                                                     │
│   _onIncrement called:                              │
│   • Reads current state: 5                          │
│   • Calculates new state: 5 + 1 = 6                 │
│   • Emits: emit(6)                                  │
│                                                     │
│   New State: 6                                      │
│                                                     │
│   UI rebuilds to show: 6                            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Complete Example: Simple Counter

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// STEP 1: Define Events
// ─────────────────────────────────────
abstract class CounterEvent {}

class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// ─────────────────────────────────────
// STEP 2: State is just int
// ─────────────────────────────────────
// (No need to define, using int directly)

// ─────────────────────────────────────
// STEP 3: Create BLoC
// ─────────────────────────────────────
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    // Register event handlers
    on<Increment>((event, emit) {
      emit(state + 1);
    });

    on<Decrement>((event, emit) {
      if (state > 0) {
        emit(state - 1);
      }
    });

    on<Reset>((event, emit) {
      emit(0);
    });
  }
}
```

---

## Example: Complex State

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// State Class
// ─────────────────────────────────────
class CounterState {
  final int count;
  final bool isEven;
  final String message;

  CounterState({
    required this.count,
    required this.isEven,
    required this.message,
  });

  // Factory for initial state
  factory CounterState.initial() {
    return CounterState(
      count: 0,
      isEven: true,
      message: 'Start counting!',
    );
  }

  // Copy with changes
  CounterState copyWith({
    int? count,
    bool? isEven,
    String? message,
  }) {
    return CounterState(
      count: count ?? this.count,
      isEven: isEven ?? this.isEven,
      message: message ?? this.message,
    );
  }
}

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
  }

  void _onIncrement(Increment event, Emitter<CounterState> emit) {
    final newCount = state.count + 1;
    emit(state.copyWith(
      count: newCount,
      isEven: newCount % 2 == 0,
      message: 'Count increased to $newCount',
    ));
  }

  void _onDecrement(Decrement event, Emitter<CounterState> emit) {
    if (state.count > 0) {
      final newCount = state.count - 1;
      emit(state.copyWith(
        count: newCount,
        isEven: newCount % 2 == 0,
        message: 'Count decreased to $newCount',
      ));
    }
  }
}
```

---

## Example: Multiple State Types

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────
// States
// ─────────────────────────────────────
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String userName;
  UserLoaded(this.userName);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// ─────────────────────────────────────
// Events
// ─────────────────────────────────────
abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

// ─────────────────────────────────────
// BLoC
// ─────────────────────────────────────
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    // Show loading
    emit(UserLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Simulate success
      emit(UserLoaded('User ${event.userId}'));
    } catch (e) {
      // Show error
      emit(UserError('Failed to load user'));
    }
  }
}
```

---

## Handler Variations

### Short Form (Inline)

```dart
CounterBloc() : super(0) {
  on<Increment>((event, emit) => emit(state + 1));
  on<Decrement>((event, emit) => emit(state - 1));
  on<Reset>((event, emit) => emit(0));
}
```

### Medium Form (Inline with Logic)

```dart
CounterBloc() : super(0) {
  on<Increment>((event, emit) {
    final newValue = state + 1;
    if (newValue <= 100) {
      emit(newValue);
    }
  });
}
```

### Long Form (Separate Methods)

```dart
CounterBloc() : super(0) {
  on<Increment>(_onIncrement);
  on<Decrement>(_onDecrement);
}

void _onIncrement(Increment event, Emitter<int> emit) {
  final newValue = state + 1;
  if (newValue <= 100) {
    emit(newValue);
  }
}

void _onDecrement(Decrement event, Emitter<int> emit) {
  if (state > 0) {
    emit(state - 1);
  }
}
```

---

## Key Rules for emit()

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   DO:                                               │
│   ───                                               │
│   • emit() only inside event handlers               │
│   • emit() new states, not modified old states      │
│   • Use state.copyWith() for complex states         │
│                                                     │
│   DON'T:                                            │
│   ─────                                             │
│   • emit() in constructor                           │
│   • emit() outside event handlers                   │
│   • Modify state and re-emit it                     │
│   • emit() the same state twice in a row            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Good Example

```dart
void _onIncrement(Increment event, Emitter<CounterState> emit) {
  // Create NEW state
  emit(state.copyWith(count: state.count + 1));
}
```

### Bad Example

```dart
void _onIncrement(Increment event, Emitter<CounterState> emit) {
  // DON'T modify existing state
  state.count++;  // BAD!
  emit(state);    // BAD!
}
```

---

## Summary

To create a BLoC:

1. **Define States** - What can the UI show?
   - Simple: `int`, `String`, `bool`
   - Complex: Class with `copyWith()`
   - Multiple: Abstract class with subclasses

2. **Define Events** - What actions can happen?
   - Simple classes extending base event

3. **Create BLoC** - How to handle events?
   - Extend `Bloc<Event, State>`
   - Set initial state in constructor
   - Register handlers with `on<Event>`
   - Use `emit()` to send new states

Next, we'll learn how to use the BLoC in our widgets!

---

## Navigation

⬅️ **Previous:** [BLoC Introduction](06a-BlocIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Using BLoCs](06c-UsingBloc.md)
