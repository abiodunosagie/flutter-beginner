# Provider Basics: The Simplest State Management

Provider is like a **magical container** that holds your data and shares it with any widget that needs it. It's recommended by the Flutter team and is perfect for beginners!

---

## What Is Provider?

Imagine you have a box of cookies in your kitchen:

```
WITHOUT PROVIDER:
─────────────────
Mom gets cookies → passes to Dad → Dad passes to Child
                   (doesn't want any)    (finally eats!)

WITH PROVIDER:
─────────────────
          ┌─────────────┐
          │  🍪 Cookies │
          │   (shared)  │
          └─────────────┘
               │
      ┌────────┼────────┐
      │        │        │
      ▼        ▼        ▼
    Mom       Dad      Child

Anyone can grab cookies directly!
```

Provider works the same way - it puts your data where ANY widget can access it directly!

---

## Setting Up Provider

### Step 1: Add the Package

In your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```

Then run:
```bash
flutter pub get
```

### Step 2: Import Provider

```dart
import 'package:provider/provider.dart';
```

---

## The Three Parts of Provider

Provider has three main parts. Let's learn each one:

```
┌─────────────────────────────────────────────┐
│                                             │
│  1. THE DATA CLASS                          │
│     (What you want to share)                │
│     ┌──────────────────────┐                │
│     │ class Counter {      │                │
│     │   int value = 0;     │                │
│     │ }                    │                │
│     └──────────────────────┘                │
│                                             │
│  2. THE PROVIDER                            │
│     (Makes data available)                  │
│     ┌──────────────────────┐                │
│     │ ChangeNotifierProvider│               │
│     │   (wraps your app)   │                │
│     └──────────────────────┘                │
│                                             │
│  3. THE CONSUMER                            │
│     (Gets and uses the data)                │
│     ┌──────────────────────┐                │
│     │ context.watch<T>()   │                │
│     │ context.read<T>()    │                │
│     └──────────────────────┘                │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Part 1: The Data Class (ChangeNotifier)

This is where your data lives. It extends `ChangeNotifier` so it can tell widgets when data changes.

```dart
import 'package:flutter/foundation.dart';

// Your data class - holds the state
class Counter extends ChangeNotifier {
  // The data
  int _count = 0;

  // Getter to read the data
  int get count => _count;

  // Method to change the data
  void increment() {
    _count++;
    notifyListeners();  // 📢 "Hey everyone, I changed!"
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();  // 📢 "Hey everyone, I changed!"
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();  // 📢 "Hey everyone, I changed!"
  }
}
```

### Breaking It Down:

```dart
class Counter extends ChangeNotifier {
//              ^^^^^^^^^^^^^^^^
// This gives your class the power to notify widgets!
```

```dart
int _count = 0;
// ^^^^^^^^
// The underscore makes it private
// Use getters/setters to control access
```

```dart
notifyListeners();
// ^^^^^^^^^^^^^^^
// This is the magic!
// It tells all listening widgets: "Data changed! Update yourself!"
```

---

## Part 2: The Provider (Making Data Available)

Wrap your app (or part of it) with a Provider:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Wrap your app with ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => Counter(),  // Create the data object
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Counter',
      home: const HomePage(),
    );
  }
}
```

### What's Happening:

```
ChangeNotifierProvider
         │
         │ "I'm providing a Counter object"
         │ "Any widget below me can access it!"
         │
         ▼
      MyApp
         │
         ▼
     HomePage
         │
         ▼
   Other Widgets...  ← All can access Counter!
```

---

## Part 3: The Consumer (Getting the Data)

There are three ways to get data from Provider:

### Way 1: context.watch<T>() - Listen and Rebuild

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // watch = "Give me the data AND rebuild when it changes"
    final counter = context.watch<Counter>();

    return Text(
      'Count: ${counter.count}',
      style: TextStyle(fontSize: 48),
    );
  }
}
```

**Use `watch` when:** You need to SHOW data that might change

### Way 2: context.read<T>() - Just Get, Don't Listen

```dart
class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // read = "Give me the data, I just need to call a method"
        context.read<Counter>().increment();
      },
      child: Text('Add'),
    );
  }
}
```

**Use `read` when:** You need to CALL METHODS, not display data

### Way 3: Consumer Widget - More Control

```dart
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Column(
          children: [
            Text('Count: ${counter.count}'),
            child!,  // This part doesn't rebuild!
          ],
        );
      },
      child: const Text('This text never rebuilds'),  // Optimization
    );
  }
}
```

**Use `Consumer` when:** You want to optimize which parts rebuild

---

## Complete Example: Counter App

Let's put it all together:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────
// STEP 1: The Data Class
// ─────────────────────────────────────
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

// ─────────────────────────────────────
// STEP 2: Provide It
// ─────────────────────────────────────
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
      title: 'Provider Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterPage(),
    );
  }
}

// ─────────────────────────────────────
// STEP 3: Use It
// ─────────────────────────────────────
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 20),

            // WATCH the counter - rebuilds when count changes
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            ),

            const SizedBox(height: 40),

            // Buttons to control counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // READ to call method - doesn't need to rebuild
                  onPressed: () => context.read<Counter>().decrement(),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().reset(),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().increment(),
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

## watch vs read: When to Use Which?

This is VERY important to understand:

```
┌────────────────────────────────────────────────────┐
│                                                    │
│   context.watch<T>()                               │
│   ─────────────────                                │
│   • Listens for changes                            │
│   • Rebuilds widget when data changes              │
│   • Use in build() method                          │
│   • Use when DISPLAYING data                       │
│                                                    │
│   Example:                                         │
│   Text('${context.watch<Counter>().count}')        │
│                                                    │
├────────────────────────────────────────────────────┤
│                                                    │
│   context.read<T>()                                │
│   ────────────────                                 │
│   • Gets data once                                 │
│   • Does NOT listen for changes                    │
│   • Use in callbacks (onPressed, etc.)             │
│   • Use when CALLING METHODS                       │
│                                                    │
│   Example:                                         │
│   onPressed: () => context.read<Counter>().add()   │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Common Mistake:

```dart
// ❌ WRONG: Using read in build (won't update!)
@override
Widget build(BuildContext context) {
  final counter = context.read<Counter>();  // Won't rebuild!
  return Text('${counter.count}');  // Shows stale data!
}

// ✅ CORRECT: Using watch in build
@override
Widget build(BuildContext context) {
  final counter = context.watch<Counter>();  // Will rebuild!
  return Text('${counter.count}');  // Always up to date!
}
```

```dart
// ❌ WRONG: Using watch in callback (causes rebuild issues)
onPressed: () {
  context.watch<Counter>().increment();  // Bad!
}

// ✅ CORRECT: Using read in callback
onPressed: () {
  context.read<Counter>().increment();  // Good!
}
```

---

## Understanding notifyListeners()

This is how Provider knows to update widgets:

```
BEFORE notifyListeners():
──────────────────────────
Counter: count = 5
Widget: showing 5
Everything is synced! ✓


AFTER increment() WITHOUT notifyListeners():
─────────────────────────────────────────────
Counter: count = 6  ← Data changed
Widget: showing 5   ← Still shows old value!
Out of sync! ✗


AFTER increment() WITH notifyListeners():
─────────────────────────────────────────
Counter: count = 6
         │
         │ notifyListeners() 📢
         │ "Hey! I changed!"
         │
         ▼
Widget: "Oh! Let me rebuild!"
Widget: showing 6
Synced again! ✓
```

### Rule: Always call notifyListeners() after changing data!

```dart
void increment() {
  _count++;
  notifyListeners();  // Don't forget this!
}
```

---

## Accessing Provider from Anywhere

Once you set up a Provider, ANY widget below it can access the data:

```dart
// In HomePage
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<Counter>().count;
    return Text('$count');
  }
}

// In a deeply nested widget
class DeeplyNestedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Works here too! No need to pass it down!
    final count = context.watch<Counter>().count;
    return Text('$count');
  }
}

// In a dialog
void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      // Works in dialogs too!
      final count = context.watch<Counter>().count;
      return AlertDialog(
        content: Text('Count is $count'),
      );
    },
  );
}
```

---

## Summary

| Concept | What It Does |
|---------|--------------|
| `ChangeNotifier` | Base class for your data, enables notifications |
| `notifyListeners()` | Tells widgets "data changed, rebuild!" |
| `ChangeNotifierProvider` | Makes your data available to widgets |
| `context.watch<T>()` | Get data AND rebuild when it changes |
| `context.read<T>()` | Get data once, for calling methods |
| `Consumer<T>` | Widget that rebuilds when data changes |

---

## Quick Quiz

**Q1:** When do you use `context.watch<T>()`?

<details>
<summary>Answer</summary>

Use `watch` when you need to DISPLAY data and want the widget to rebuild when that data changes. Use it in the `build()` method when showing data to the user.

</details>

**Q2:** When do you use `context.read<T>()`?

<details>
<summary>Answer</summary>

Use `read` when you need to CALL METHODS on your provider but don't need to display the data. Use it in callbacks like `onPressed` or `onTap`. It gets the data once without listening for changes.

</details>

**Q3:** What does `notifyListeners()` do?

<details>
<summary>Answer</summary>

`notifyListeners()` tells all widgets that are watching this provider: "Hey, my data changed! You should rebuild yourself!" Without calling this, your UI won't update even when the data changes.

</details>

---

**Next:** Learn advanced Provider patterns - multiple providers, selectors, and more!

---

**Continue to:** `03-ProviderAdvanced.md`
