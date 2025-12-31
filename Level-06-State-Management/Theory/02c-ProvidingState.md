# Part 3: Providing Your State (ChangeNotifierProvider)

You've created a ChangeNotifier class. Now let's make it available to your widgets!

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

**Next:** Learn how to USE the provided state in your widgets!

---

## Navigation

⬅️ **Previous:** [ChangeNotifier](02b-ChangeNotifier.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Consuming State](02d-ConsumingState.md)
