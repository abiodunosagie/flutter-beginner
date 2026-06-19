# Providing Your State (ChangeNotifierProvider)

## The Big Idea In One Sentence

> `ChangeNotifierProvider` wraps your app (or part of it) and shares one `ChangeNotifier` with every widget below it.

This is step 2 of Provider: **provide** the class you created, so widgets can reach it.

---

## What is ChangeNotifierProvider?

`ChangeNotifierProvider` is like putting your data in a box that every widget can reach into.

```
Your App
└─ ChangeNotifierProvider  ← The box
    └─ Counter inside
       └─ All widgets below can access it!
```

---

## Basic Setup

Wrap your app with `ChangeNotifierProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),  // Create the Counter
      child: const MyApp(),             // Your app
    ),
  );
}
```

Now EVERY widget in `MyApp` can access the Counter!

---

## Understanding `create:`

```dart
ChangeNotifierProvider(
  create: (context) => Counter(),
//        ^^^^^^^^^    ^^^^^^^^^
//        when?        what to create
```

- `create:` tells Provider what to create
- `(context) =>` means "when you need it"
- `Counter()` creates a new Counter object

---

## Where to Put the Provider?

### Option 1: Wrap the Entire App
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),  // Everything can access Counter
    ),
  );
}
```

**Use when:** The data is needed everywhere (user info, theme, etc.)

### Option 2: Wrap Part of the App
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ShoppingCart(),
        child: const ShoppingPage(),  // Only shopping pages need cart
      ),
    );
  }
}
```

**Use when:** The data is only needed in one section

---

## Complete Example: Counter App

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter.dart';  // Our ChangeNotifier class

void main() {
  runApp(
    // Provide the Counter
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
      title: 'Counter App',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We can access Counter here! (Next lesson)
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: const Center(
        child: Text('Counter will go here'),
      ),
    );
  }
}
```

---

## Visual Flow

```
main()
  │
  └─> ChangeNotifierProvider(create: Counter())
       │
       └─> MyApp
            │
            └─> MaterialApp
                 │
                 └─> HomePage  ✅ Can access Counter!
                      │
                      └─> AnyWidget  ✅ Can access Counter!
```

---

## Multiple Providers? Use MultiProvider!

Need more than one ChangeNotifier?

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Counter()),
        ChangeNotifierProvider(create: (context) => ShoppingCart()),
        ChangeNotifierProvider(create: (context) => UserProfile()),
      ],
      child: const MyApp(),
    ),
  );
}
```

Now all three are available everywhere!

---

## Common Mistakes

### ❌ Mistake 1: Creating Provider Inside build()
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(  // ❌ Wrong place!
      create: (context) => Counter(),
      child: Text('Bad'),
    );
  }
}
```

This creates a NEW Counter every time the widget rebuilds!

### ✅ Fix: Put it in main() or above the widget
```dart
void main() {
  runApp(
    ChangeNotifierProvider(  // ✅ Created once!
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}
```

---

## Summary

✅ Use `ChangeNotifierProvider` to share your ChangeNotifier
✅ Put it in `main()` or wrap the part of your app that needs it
✅ Use `MultiProvider` for multiple ChangeNotifiers
✅ The `create:` parameter tells what to create

---

## Quick Quiz

**Q1.** What does `ChangeNotifierProvider` do?

<details>
<summary>Answer</summary>
It shares one `ChangeNotifier` with every widget below it in the tree, so any of them can reach the data.
</details>

**Q2.** What does the `create:` parameter do?

<details>
<summary>Answer</summary>
It builds the object to share, like `create: (context) => Counter()`.
</details>

**Q3.** How do you provide more than one ChangeNotifier?

<details>
<summary>Answer</summary>
Use `MultiProvider` with a `providers:` list of `ChangeNotifierProvider`s.
</details>

**Q4.** Why should you not create a `ChangeNotifierProvider` inside a widget's `build`?

<details>
<summary>Answer</summary>
Because `build` runs many times, so it would create a new object on every rebuild, losing the state. Put it in `main()` or above the widget.
</details>

---

## Assignment

### Problem 1: Wrap the app

Given a `Counter` ChangeNotifier, write the `main()` that wraps `MyApp` in a `ChangeNotifierProvider` so the whole app can reach the Counter.

### Problem 2: Two providers

Write a `main()` that provides both a `Counter` and a `ShoppingCart` to the whole app, using `MultiProvider`.

### Problem 3: Spot the bug

Why is this wrong?

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const Text('Hi'),
    );
  }
}
```

### Problem 4: Where to put it?

You have user-login data that almost every screen needs. Where should you put its `ChangeNotifierProvider`, and why?

---

## Assignment Answers

### Problem 1: Wrap the app

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}
```

`ChangeNotifierProvider` wraps `MyApp`, so every widget inside `MyApp` can reach the `Counter`.

### Problem 2: Two providers

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Counter()),
        ChangeNotifierProvider(create: (context) => ShoppingCart()),
      ],
      child: const MyApp(),
    ),
  );
}
```

`MultiProvider` lets you share several notifiers at once with one `providers:` list.

### Problem 3: Spot the bug

The provider is created inside `build`, which runs many times. Each rebuild would make a **new** `Counter`, throwing away the old state. Move it up to `main()` (or above this widget) so the `Counter` is created once:

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}
```

### Problem 4: Where to put it?

At the top, in `main()` wrapping the whole app. Since almost every screen needs the login data, providing it at the very top makes it reachable everywhere. You only wrap a smaller part of the app when the data is needed in just one section.

---

**Next:** `02d-ConsumingState.md`, where you finally use the provided state in your widgets.

---

## Navigation

⬅️ **Previous:** [ChangeNotifier](02b-ChangeNotifier.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Consuming State](02d-ConsumingState.md)
