# Cubit Deep Dive: The Simplest State Machine That Works

## The Big Idea In One Sentence

> A **Cubit** is a class that holds one value called `state` and exposes plain methods that call `emit(newState)`; the UI listens and rebuilds.

---

## The Simple Explanation

A Cubit is a light switch with a memory.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   YOU (the UI)                                       │
│      │  call a method: cubit.increment()             │
│      ▼                                               │
│   CUBIT                                              │
│      │  runs logic, then emit(state + 1)             │
│      ▼                                               │
│   NEW STATE                                          │
│      │  pushed out on a stream                       │
│      ▼                                               │
│   UI REBUILDS with the new value                     │
│                                                      │
│   No events, no event classes. Just methods.         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Bloc and Cubit come from the same package and the same author. `Bloc` adds events. `Cubit` skips them. **Cubit is the default choice**; reach for Bloc when you need what events give you (covered in the next lesson).

---

## Setup

```yaml
# pubspec.yaml
dependencies:
  flutter_bloc: ^9.1.1
  equatable: ^2.1.0

dev_dependencies:
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
```

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
```

`flutter_bloc` re-exports the `bloc` package, so you only import one thing.

---

## Your First Cubit

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);   // 0 is the initial state

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
}
```

Read that carefully. Three things define every Cubit:

1. `extends Cubit<T>` where `T` is the type of the state
2. `super(initialState)` in the constructor
3. Public methods that end in `emit(...)`

`state` is always the current value. You never assign to it; you `emit` a new one.

---

## Wiring It To The UI

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // BlocProvider CREATES the cubit and puts it in the widget tree
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BlocBuilder LISTENS and rebuilds
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) => Text('$count', style: const TextStyle(fontSize: 48)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // context.read CALLS a method without listening
        onPressed: () => context.read<CounterCubit>().increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   BlocProvider   creates it and shares it downward   │
│   BlocBuilder    listens and rebuilds on new state   │
│   context.read   grabs it to CALL a method           │
│   context.watch  grabs it AND subscribes to rebuilds │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The rule that stops most bugs: **`read` inside callbacks, `watch` (or `BlocBuilder`) inside `build`.** Calling `watch` inside `onPressed` throws, and calling `read` in `build` means your UI never updates.

---

## A Real Cubit: Loading Data

A counter is not an interview answer. This is.

```dart
// The state: one class per situation the screen can be in.
sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);
  final User user;
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}

// The cubit: depends on a repository, never on http or Dio directly.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileInitial());

  final UserRepository _repository;

  Future<void> load(String userId) async {
    emit(const ProfileLoading());
    try {
      final user = await _repository.fetchUser(userId);
      emit(ProfileLoaded(user));
    } on ApiException catch (e) {
      emit(ProfileError(e.message));
    } catch (_) {
      emit(const ProfileError('Something went wrong. Please try again.'));
    }
  }

  Future<void> refresh(String userId) => load(userId);
}
```

And the UI handles every case exhaustively:

```dart
BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) => switch (state) {
    ProfileInitial() => const SizedBox.shrink(),
    ProfileLoading() => const Center(child: CircularProgressIndicator()),
    ProfileLoaded(:final user) => ProfileView(user: user),
    ProfileError(:final message) => ErrorView(
        message: message,
        onRetry: () => context.read<ProfileCubit>().load(userId),
      ),
  },
)
```

Because `ProfileState` is a `sealed class`, the Dart compiler **forces** you to handle every case. Add a new state class later and every `switch` that forgot it becomes a compile error, not a bug in production. This is the single strongest argument for Bloc-style state management, and it is worth saying out loud in an interview.

---

## Providing A Cubit Correctly

```dart
// One cubit for one page, created when the page opens, closed when it leaves
BlocProvider(
  create: (context) => ProfileCubit(context.read<UserRepository>())..load(userId),
  child: const ProfilePage(),
)

// Several cubits for one subtree
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => CartCubit()),
    BlocProvider(create: (_) => ThemeCubit()),
  ],
  child: const ShopPage(),
)

// An EXISTING cubit passed to a new route (do not use `create` here)
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<CartCubit>(),
      child: const CheckoutPage(),
    ),
  ),
)
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   BlocProvider(create: ...)                          │
│      makes a NEW one and CLOSES it automatically     │
│      when the widget is removed                      │
│                                                      │
│   BlocProvider.value(value: existing)                │
│      re-shares an existing one and does NOT close it │
│                                                      │
│   Using `create` when you meant `.value` gives you   │
│   two cubits and a bug where one screen updates      │
│   and the other does not.                            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The `..load(userId)` cascade in `create` is the idiomatic way to kick off the first fetch. Do not call `load()` from `initState` of the page: `create` runs lazily and exactly once.

---

## Lifecycle Hooks You Should Know

```dart
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState.empty());

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    // Fires on EVERY state change. Great for logging.
    debugPrint('${change.currentState} -> ${change.nextState}');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // Fires when an unhandled error escapes a method.
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();   // clean up streams, timers, controllers
    return super.close();
  }
}
```

---

## The Emit Rules That Catch People Out

### 1. Emitting an equal state does nothing

```dart
class NameCubit extends Cubit<String> {
  NameCubit() : super('Ada');
  void setName(String n) => emit(n);
}

cubit.setName('Ada');   // no rebuild: 'Ada' == 'Ada'
```

Bloc skips a state that is `==` to the current one. That is a feature (it prevents pointless rebuilds), but it bites when your state is a class **without** value equality:

```dart
// Bad: two Cart objects with identical contents are not ==,
// so every emit rebuilds, even when nothing changed.
class Cart { final List<Item> items; Cart(this.items); }

// Good: Equatable gives you value equality
class Cart extends Equatable {
  const Cart(this.items);
  final List<Item> items;

  @override
  List<Object?> get props => [items];
}
```

The mirror image bug is worse: **mutating a list in place and emitting it**.

```dart
// BROKEN: same list object, so state == oldState, so NO rebuild
void addItem(Item item) {
  state.items.add(item);
  emit(state);
}

// CORRECT: a brand new list in a brand new state
void addItem(Item item) {
  emit(Cart([...state.items, item]));
}
```

Emit **new** objects, always. Never mutate.

### 2. Do not emit after close

```dart
Future<void> load() async {
  final data = await _repo.fetch();
  if (isClosed) return;      // the user left the page while we waited
  emit(Loaded(data));
}
```

`isClosed` is the guard. Without it, a slow request that finishes after the page closes throws a `StateError`.

---

## When Cubit Is Not Enough

Use Cubit until one of these is true:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Use BLOC instead when you need:                    │
│                                                      │
│   • A record of WHAT happened (event log, analytics, │
│     undo/redo, replay)                               │
│   • Event transformers: debounce a search box,       │
│     drop taps while busy, process one at a time      │
│   • Many different triggers feeding one flow         │
│   • A team convention that says so                   │
│                                                      │
│   Everything else: Cubit. Less code, same testing,   │
│   same widgets, same architecture.                   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • extends Cubit<T>, super(initial), emit(new)      │
│   • BlocProvider creates, BlocBuilder rebuilds       │
│   • read in callbacks, watch/BlocBuilder in build    │
│   • sealed state classes give exhaustive switches    │
│   • .value to re-share, create to make new           │
│   • Never mutate state, always emit a new object     │
│   • Guard async emits with `if (isClosed) return;`   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What are the three parts of every Cubit?

<details>
<summary>Answer</summary>
`extends Cubit<StateType>`, an initial state passed to `super(...)`, and public methods that call `emit(newState)`.
</details>

**Q2.** Why does `state.items.add(item); emit(state);` fail to update the UI?

<details>
<summary>Answer</summary>
It mutates the same object, so the new state is `==` to the old state and bloc skips the emit. Build a new list and a new state object instead.
</details>

**Q3.** When do you use `BlocProvider.value` instead of `BlocProvider(create:)`?

<details>
<summary>Answer</summary>
When you are sharing a cubit that already exists (for example passing it to a pushed route). `create` would build a second, separate instance and close it when that route pops.
</details>

---

## Assignment

### Problem 1: Write a cubit

Write a `ThemeCubit` that holds a `ThemeMode` and has a `toggle()` method switching between light and dark.

### Problem 2: Find the bug

```dart
class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);
  void add(Todo t) {
    state.add(t);
    emit(state);
  }
}
```

What is wrong and what is the fix?

### Problem 3: read or watch

For each, say `read` or `watch`: showing the cart count in a `Text`, calling `logout()` from a button, disabling a button while `isSubmitting` is true.

### Problem 4: Async safety

A cubit fetches a user and emits the result. The user backs out of the screen while the request is in flight. What line prevents the crash, and where does it go?

---

## Assignment Answers

### Problem 1: Write a cubit

```dart
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggle() => emit(
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );
}
```

### Problem 2: Find the bug

`state.add(t)` mutates the existing list, so `emit(state)` passes an object that is identical to the current state and bloc skips it. The UI never updates. Fix:

```dart
void add(Todo t) => emit([...state, t]);
```

### Problem 3: read or watch

- Cart count in a `Text`: `watch` (or a `BlocBuilder`), because it must rebuild
- `logout()` from a button: `read`, it is a callback
- Disabling a button while `isSubmitting`: `watch`, because the button's appearance depends on state

### Problem 4: Async safety

```dart
if (isClosed) return;
```

It goes immediately after the `await`, before the `emit`. Otherwise emitting on a closed cubit throws a `StateError`.

---

## Navigation

⬅️ **Previous:** [Adaptive Layouts](01d-AdaptiveLayouts.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Bloc Deep Dive](02b-BlocDeepDive.md)
