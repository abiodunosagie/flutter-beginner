# Using Your State (watch, read, and Consumer)

## The Big Idea In One Sentence

> Use `context.watch<T>()` to **show** data (it rebuilds when the data changes), and `context.read<T>()` to **call a method** that changes the data (no rebuild).

This is step 3 of Provider: **consume** the state. After this, you can build a full Provider app.

---

## Two Ways to Access State

There are two main ways to get your state:

```
1. context.watch<T>()  ← Rebuilds when state changes
2. context.read<T>()   ← Doesn't rebuild, just gets it once
```

---

## Method 1: context.watch() - For Displaying Data

Use `watch()` when you want to **show** the data:

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Watch the Counter - rebuild when it changes!
    final counter = context.watch<Counter>();
    
    return Text('Count: ${counter.count}');
    // When counter changes, this Text rebuilds! ✅
  }
}
```

### When to Use watch():
- ✅ Displaying data in Text, Image, etc.
- ✅ When you want the widget to update automatically
- ✅ In the `build()` method

---

## Method 2: context.read() - For Calling Methods

Use `read()` when you want to **change** the data:

```dart
class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Read the Counter - don't rebuild!
        context.read<Counter>().increment();
      },
      child: const Text('+1'),
    );
  }
}
```

### When to Use read():
- ✅ In button callbacks (`onPressed`, `onTap`)
- ✅ When calling methods that change state
- ✅ When you DON'T want to rebuild

---

## watch() vs read() - The Complete Picture

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WATCH: Get and display
    final counter = context.watch<Counter>();

    return Column(
      children: [
        // Shows current count - updates automatically!
        Text('Count: ${counter.count}'),
        
        ElevatedButton(
          onPressed: () {
            // READ: Just call the method
            context.read<Counter>().increment();
          },
          child: const Text('+1'),
        ),
      ],
    );
  }
}
```

---

## Visual Explanation

```
When counter changes from 5 → 6:

Using watch():
─────────────
Text('Count: ${context.watch<Counter>().count}')
                        ^
                        Watches for changes!
Rebuilds automatically! ✅
Shows: 6


Using read():
────────────
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();
            ^
            Just gets it once!
  }
)
Doesn't rebuild ✅ (we don't need it to!)
```

---

## Method 3: Consumer Widget

Another way to access state - useful for optimizing rebuilds:

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Text('Count: ${counter.count}');
      },
    );
  }
}
```

### When to Use Consumer:
- When only PART of your widget needs to rebuild
- For better performance

---

## Complete Example: Counter App

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WATCH: Display the count
            Text(
              'Count: ${context.watch<Counter>().count}',
              style: const TextStyle(fontSize: 48),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // READ: Decrement
                ElevatedButton(
                  onPressed: () {
                    context.read<Counter>().decrement();
                  },
                  child: const Text('-1'),
                ),
                
                const SizedBox(width: 10),
                
                // READ: Increment
                ElevatedButton(
                  onPressed: () {
                    context.read<Counter>().increment();
                  },
                  child: const Text('+1'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // READ: Reset
            TextButton(
              onPressed: () {
                context.read<Counter>().reset();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## The Golden Rules

### Rule 1: Use watch() to Display
```dart
// ✅ GOOD: Watching to display
Text('${context.watch<Counter>().count}')

// ❌ BAD: Reading to display
Text('${context.read<Counter>().count}')  // Won't update!
```

### Rule 2: Use read() in Callbacks
```dart
// ✅ GOOD: Reading in callback
onPressed: () {
  context.read<Counter>().increment();
}

// ❌ BAD: Watching in callback
onPressed: () {
  context.watch<Counter>().increment();  // Causes errors!
}
```

---

## Common Mistakes

### ❌ Mistake 1: Using watch() in onPressed
```dart
ElevatedButton(
  onPressed: () {
    context.watch<Counter>().increment();  // ❌ Error!
  },
  child: const Text('+1'),
)
```

Error: "watch() called outside of build()"

### ✅ Fix: Use read()
```dart
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();  // ✅ Correct!
  },
  child: const Text('+1'),
)
```

---

## Quick Reference Card

| Want to... | Use... | Example |
|------------|--------|---------|
| Display data | `watch()` | `Text('${context.watch<Counter>().count}')` |
| Call a method | `read()` | `context.read<Counter>().increment()` |
| Optimize rebuilds | `Consumer` | `Consumer<Counter>(builder: ...)` |

---

## Summary

✅ Use `context.watch<T>()` to display data (rebuilds when data changes)
✅ Use `context.read<T>()` to call methods (doesn't rebuild)
✅ Use `Consumer<T>` for partial widget rebuilds
✅ Watch in `build()`, read in callbacks!

---

## Quick Quiz

**Q1.** Which do you use to display data: `watch` or `read`?

<details>
<summary>Answer</summary>
`watch`. It rebuilds the widget when the data changes, so the display stays current.
</details>

**Q2.** Which do you use inside a button's `onPressed` to change data?

<details>
<summary>Answer</summary>
`read`. You just want to call the method, not rebuild, and `watch` is not allowed in a callback.
</details>

**Q3.** What happens if you use `read` to display a value?

<details>
<summary>Answer</summary>
It shows the value once but never updates when the data changes, because `read` does not rebuild. Use `watch` for display.
</details>

---

## Assignment

Paste full apps into [dartpad.dev](https://dartpad.dev) (Flutter mode). Use this `Counter` and wrap the app in a `ChangeNotifierProvider`:

```dart
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() { _count++; notifyListeners(); }
  void decrement() { _count--; notifyListeners(); }
}
```

### Problem 1: Display the count

Write a widget whose `build` shows `Text('Count: <count>')` using `context.watch<Counter>()`.

### Problem 2: An increment button

Write a widget with an `ElevatedButton` that calls the counter's `increment()` using `context.read<Counter>()` in `onPressed`.

### Problem 3: Spot the bug

Why does this number never change on screen?

```dart
Text('Count: ${context.read<Counter>().count}')
```

### Problem 4: A full counter screen

Put it together: a `ChangeNotifierProvider(create: ...)` over the app, a screen that watches the count to show it, and two buttons (`+1` and `-1`) that read the counter to change it.

---

## Assignment Answers

### Problem 1: Display the count

```dart
class CountText extends StatelessWidget {
  const CountText({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    return Text('Count: ${counter.count}');
  }
}
```

`watch` makes this Text rebuild whenever the counter changes, so it always shows the latest count.

### Problem 2: An increment button

```dart
class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<Counter>().increment(),
      child: const Text('+1'),
    );
  }
}
```

In the callback we use `read`, because we are calling a method, not displaying.

### Problem 3: Spot the bug

`read` gets the value once and does not rebuild when it changes, so the Text is stuck on the first value. For display, use `watch`:

```dart
Text('Count: ${context.watch<Counter>().count}')
```

### Problem 4: A full counter screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() { _count++; notifyListeners(); }
  void decrement() { _count--; notifyListeners(); }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Count: ${context.watch<Counter>().count}',   // watch to display
                style: const TextStyle(fontSize: 32),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<Counter>().decrement(),  // read to change
                    child: const Text('-1'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.read<Counter>().increment(),
                    child: const Text('+1'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

This is a complete Provider app: the Counter is **created** (the class), **provided** (`ChangeNotifierProvider`), and **consumed** (`watch` to show, `read` to change). The count updates on screen with no prop drilling. You just built real state management.

---

**Congratulations, you know the basics of Provider!** Next you will learn a couple of handy patterns, then move on to Riverpod and Bloc.

---

## Navigation

⬅️ **Previous:** [Providing State](02c-ProvidingState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Multiple Providers](03a-MultipleProviders.md)
