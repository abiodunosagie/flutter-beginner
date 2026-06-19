# What is Provider?

## The Big Idea In One Sentence

> Provider is a tool that puts your shared data in one place and lets any widget grab it directly, in three steps: **create, provide, consume**.

It is the easiest state-management tool, and the one the Flutter team recommends for learning.

---

## Provider: The Simple Explanation

Imagine you have a box of cookies in your kitchen:

### WITHOUT Provider (The Hard Way):
```
Mom gets cookies → passes to Dad → Dad passes to Grandma → Grandma passes to Child
                   (doesn't         (doesn't               (finally
                    want any)        want any)              eats!)
```

Everyone has to pass the cookies even if they don't want any!

### WITH Provider (The Easy Way):
```
          ┌─────────────┐
          │  🍪 Cookies │ ← Box on the table
          │   (shared)  │
          └─────────────┘
               │
      ┌────────┼────────┬────────┐
      │        │        │        │
      ▼        ▼        ▼        ▼
    Mom       Dad   Grandma    Child

Everyone can take cookies directly from the box!
```

**Provider works the same way** - it puts your data where ANY widget can grab it!

---

## Setting Up Provider

### Step 1: Add Provider to Your Project

Open `pubspec.yaml` and add Provider:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1  # Add this line!
```

### Step 2: Get the Package

Run this command:
```bash
flutter pub get
```

You'll see: ✅ "Got dependencies!"

### Step 3: Import Provider

At the top of your Dart file:

```dart
import 'package:provider/provider.dart';
```

That's it! Provider is ready! 🎉

---

## The Three Simple Steps to Use Provider

Provider works in 3 easy steps:

```
Step 1: CREATE
┌──────────────────────┐
│ Make a data class    │ ← Holds your state
│ class Counter { }    │
└──────────────────────┘

Step 2: PROVIDE
┌──────────────────────┐
│ ChangeNotifierProvider│ ← Shares the data
│ Wraps your app       │
└──────────────────────┘

Step 3: CONSUME
┌──────────────────────┐
│ context.watch()      │ ← Use the data
│ Gets the data        │
└──────────────────────┘
```

We'll learn each step in detail!

---

## Real-Life Example: Shopping Cart

Think about a shopping cart:

```
Without Provider:
─────────────────
App → HomePage → ProductPage → CartWidget
      (passes cart)  (passes cart)   (uses cart!)

Every page has to pass the cart!


With Provider:
──────────────
        ┌────────────┐
        │ CART DATA  │ ← Lives here
        └────────────┘
             │
    ┌────────┼────────┐
    │        │        │
    ▼        ▼        ▼
 HomePage ProductPage CartWidget

Every page gets cart directly!
```

---

## Why Provider is Great for Beginners

✅ **Easy to learn** - Just 3 steps!
✅ **Recommended by Flutter** - It's official!
✅ **Works everywhere** - In any widget
✅ **No prop drilling** - No passing data through widgets
✅ **Efficient** - Only rebuilds widgets that need it

---

## What You'll Learn Next

In the next lessons:

1. ✅ **ChangeNotifier** - How to create your data class
2. ✅ **ChangeNotifierProvider** - How to share your data
3. ✅ **watch() and read()** - How to use your data
4. ✅ **Real examples** - Build a counter, todo list, and more!

---

## One-Minute Recap

- Provider puts shared data in one place that any widget can reach (the cookie box on the table).
- It removes prop drilling and only rebuilds widgets that use the data.
- Three steps: **create** a data class, **provide** it above your app, **consume** it in widgets.
- Add it with `flutter pub add provider` and import `package:provider/provider.dart`.

---

## Quick Quiz

**Q1.** In one line, what does Provider do?

<details>
<summary>Answer</summary>
It keeps shared data in one place so any widget can read it directly, without passing it down.
</details>

**Q2.** What are the three steps of using Provider?

<details>
<summary>Answer</summary>
Create (a data class), provide (share it above the app), consume (use it in widgets).
</details>

**Q3.** How do you add the provider package to a project?

<details>
<summary>Answer</summary>
Run `flutter pub add provider` (or add `provider:` under dependencies in `pubspec.yaml` and run `flutter pub get`), then import `package:provider/provider.dart`.
</details>

---

## Assignment

Conceptual and setup, no widget code yet (that starts in the next lesson).

### Problem 1: Explain the box

In your own words, how is Provider like a box of cookies on the table?

### Problem 2: The three steps

Write the three steps of using Provider in order, with one word each.

### Problem 3: Add the package

Write the command you run to add Provider, and the line you put at the top of your Dart file to use it.

### Problem 4: Why Provider first?

Give two reasons Provider is a good first state-management tool.

---

## Assignment Answers

### Problem 1: Explain the box

Without Provider, data is passed person to person (widget to widget), even to people who do not want it. With Provider, the data sits in one box on the table, and anyone can reach in and take it directly. No passing.

### Problem 2: The three steps

1. Create
2. Provide
3. Consume

### Problem 3: Add the package

```bash
flutter pub add provider
```

And at the top of your Dart file:

```dart
import 'package:provider/provider.dart';
```

### Problem 4: Why Provider first?

Any two of: it is the simplest tool (just three steps); it is recommended by the Flutter team; it removes prop drilling; it only rebuilds the widgets that use the data; and understanding it makes Riverpod and Bloc easier later.

---

**Next:** `02b-ChangeNotifier.md`, where you create the data class that holds your state.

---

## Navigation

⬅️ **Previous:** [The Solution](01d-TheSolution.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [ChangeNotifier](02b-ChangeNotifier.md)
