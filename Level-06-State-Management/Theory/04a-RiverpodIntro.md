# What is Riverpod?

## The Big Idea In One Sentence

> Riverpod is like Provider but the providers live **globally** (outside the widget tree), so any widget can reach them safely with a `ref`.

Riverpod is "Provider" with the letters rearranged. It is Provider's safer, more flexible cousin. Because you know Provider, this will feel familiar.

---

## Why Riverpod Exists

Provider is great, but it has some problems. Riverpod fixes them all!

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│   PROVIDER PROBLEMS          RIVERPOD SOLUTIONS        │
│   ────────────────          ─────────────────          │
│                                                        │
│   ❌ Needs BuildContext      ✅ Works anywhere          │
│                                                        │
│   ❌ Runtime errors          ✅ Compile-time errors     │
│      ("Provider not found")     (caught before run)    │
│                                                        │
│   ❌ Hard to test            ✅ Easy to test            │
│                                                        │
│   ❌ Provider depends on     ✅ Providers are global    │
│      widget tree position       and independent        │
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

## Think of It Like This

### Provider (Old Way)

```
Imagine a library where books (data) are stored on shelves (widget tree).
You can only get a book if you're standing near that shelf.

┌──────────────┐
│   Widget     │
│   Tree       │
│   │          │
│   ├─Provider ← Book is here!
│   │  │       │
│   │  └─Widget│ ← Can access
│   │          │
│   └─Widget   │ ← Can't access (not near the shelf!)
└──────────────┘
```

### Riverpod (New Way)

```
Imagine ALL books (data) are in a magical catalog that anyone can access from anywhere!

     GLOBAL CATALOG
     ┌────────────┐
     │ Book 1     │
     │ Book 2     │
     │ Book 3     │
     └────────────┘
         │   │   │
    ┌────┴───┴───┴────┐
    │    │    │    │  │
    ▼    ▼    ▼    ▼  ▼
  Widget Widget Widget Widget

Everyone can access any book from anywhere!
```

---

## Setting Up Riverpod

### Step 1: Add the Package

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
```

Run:
```bash
flutter pub get
```

### Step 2: Wrap Your App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // This is the ONLY setup needed!
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

That's it! Much simpler than Provider!

---

## The Big Difference: Global Providers

In Riverpod, providers live **outside** widgets:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define provider GLOBALLY (outside any class)
final counterProvider = StateProvider<int>((ref) => 0);
//                                          ^^^
//                                       Initial value

// Now ANY widget can access it!
```

### Visualized

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   PROVIDER (old way)          RIVERPOD              │
│   ─────────────────          ────────               │
│                                                     │
│   Provider must be in        Providers are GLOBAL   │
│   widget tree                                       │
│                                                     │
│   ┌─────────────┐           final counterProvider   │
│   │ Provider    │           = StateProvider(...)    │
│   │   │         │                    │              │
│   │   ▼         │           Available everywhere!   │
│   │ App         │              │    │    │          │
│   │   │         │              ▼    ▼    ▼          │
│   │   ▼         │           ┌────┐┌────┐┌────┐      │
│   │ Widget      │           │ A  ││ B  ││ C  │      │
│   └─────────────┘           └────┘└────┘└────┘      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## Simple Example: Counter

Let's create a simple counter with Riverpod:

### Step 1: Define the Provider (Globally)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Outside any class!
final counterProvider = StateProvider<int>((ref) => 0);
//    └── Provider name  └── Type    │    │
//                                   │    └── Initial value
//                                   └── ref gives access to other providers
```

### Step 2: Wrap App with ProviderScope

```dart
void main() {
  runApp(
    const ProviderScope(  // Required!
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Counter',
      home: const CounterPage(),
    );
  }
}
```

### Step 3: Use ConsumerWidget

In Provider, you used `StatelessWidget`.
In Riverpod, you use `ConsumerWidget`:

```dart
class CounterPage extends ConsumerWidget {
//                       ^^^^^^^^^^^^^^
//                       This is the Riverpod version!
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //                               ^^^^^^^^^^^^^
    //                               Extra parameter!

    // WATCH the provider (rebuilds when it changes)
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Counter')),
      body: Center(
        child: Text(
          '$count',
          style: const TextStyle(fontSize: 48),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // READ to modify (doesn't rebuild)
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## ref: Your Key to Providers

In Riverpod, `ref` is how you access providers:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  //                               ^^^^^^^^^^^^^
  //                               This is your key!
```

### Two Main Methods

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ref.watch(provider)                               │
│   ───────────────────                               │
│   • Listens for changes                             │
│   • Widget rebuilds when value changes              │
│   • Use in build() method                           │
│   • For DISPLAYING data                             │
│                                                     │
│   ref.read(provider)                                │
│   ──────────────────                                │
│   • Gets value once                                 │
│   • No listening, no rebuilds                       │
│   • Use in callbacks (onPressed, etc.)              │
│   • For ACTIONS/METHODS                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Examples

```dart
// WATCH: For displaying (rebuilds on change)
final count = ref.watch(counterProvider);
return Text('$count');

// READ: For actions (no rebuild)
onPressed: () {
  ref.read(counterProvider.notifier).state++;
}
```

---

## Complete Working Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────
// STEP 1: Define Providers (globally)
// ─────────────────────────────────────
final counterProvider = StateProvider<int>((ref) => 0);

// ─────────────────────────────────────
// STEP 2: Wrap App with ProviderScope
// ─────────────────────────────────────
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Counter',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// STEP 3: Use Providers in Widgets
// ─────────────────────────────────────
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WATCH - rebuilds when count changes
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: $count',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // READ - modify without rebuilding
                    ref.read(counterProvider.notifier).state--;
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
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

## Summary

| Concept | Purpose |
|---------|---------|
| `ProviderScope` | Wraps app, enables Riverpod |
| `ConsumerWidget` | Widget that can read providers |
| `ref.watch` | Read + listen for changes |
| `ref.read` | Read once, no listening |
| `StateProvider` | Simple mutable state |
| Global providers | Defined outside widgets |

---

## Key Takeaways

1. **Riverpod** is Provider 2.0 with better safety and testing
2. **Providers are global** - defined outside widgets
3. **ProviderScope** wraps your app (one time setup)
4. **ConsumerWidget** replaces StatelessWidget
5. **ref.watch** for displaying, **ref.read** for actions

---

## Quick Quiz

**Q1.** Where do Riverpod providers live?

<details>
<summary>Answer</summary>
Globally, outside the widget tree (defined as top-level `final` variables), so any widget can reach them.
</details>

**Q2.** What replaces `StatelessWidget` so a widget can read providers?

<details>
<summary>Answer</summary>
`ConsumerWidget`. Its `build` gets an extra `WidgetRef ref` parameter.
</details>

**Q3.** Which do you use to display a value, `ref.watch` or `ref.read`?

<details>
<summary>Answer</summary>
`ref.watch` (it rebuilds on change). Use `ref.read` in callbacks to change the value.
</details>

**Q4.** What one widget must wrap the app to enable Riverpod?

<details>
<summary>Answer</summary>
`ProviderScope`, placed around the app in `main()`.
</details>

---

## Assignment

Paste full apps into [dartpad.dev](https://dartpad.dev). (DartPad supports Riverpod.)

### Problem 1: Define a counter provider

Write the one global line that defines a `StateProvider<int>` called `counterProvider` starting at 0.

### Problem 2: Display the count

Inside a `ConsumerWidget`'s `build(context, ref)`, write the line that watches `counterProvider` and a `Text` that shows it.

### Problem 3: Increment it

Write the `onPressed` line that increases the counter by 1 using `ref.read`.

### Problem 4: Spot the difference

In Provider you wrote `context.watch<Counter>()`. What is the Riverpod equivalent for reading `counterProvider`?

---

## Assignment Answers

### Problem 1: Define a counter provider

```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

It is a top-level (global) variable, defined outside any class.

### Problem 2: Display the count

```dart
final count = ref.watch(counterProvider);
return Text('$count');
```

`ref.watch` reads the value and rebuilds when it changes.

### Problem 3: Increment it

```dart
onPressed: () => ref.read(counterProvider.notifier).state++,
```

For a `StateProvider`, you change the value through `.notifier).state`. We use `ref.read` here because it is a callback, not display.

### Problem 4: Spot the difference

In Riverpod it is `ref.watch(counterProvider)` instead of `context.watch<Counter>()`. The idea is the same (watch to display), but Riverpod uses the global provider variable and a `ref` instead of the type and `context`.

---

**Next:** `04b-ProviderTypes.md`, the different kinds of Riverpod providers.

---

## Navigation

⬅️ **Previous:** [Optimization](03b-Optimization.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Provider Types](04b-ProviderTypes.md)
