# What Is State?

## The Big Idea In One Sentence

> State is simply **data in your app that can change**, like a counter, a toggle, or the items in a cart.

Welcome to Level 6. Before we learn tools like Provider or Bloc, let's nail one simple idea: what is state? You already used it with `setState` in Level 5.

---

## State: The 5-Year-Old Explanation

Imagine you have a light switch in your room.

```
OFF                    ON
 ○                     ●
 │                     │
 Switch down           Switch up
```

Right now, is your light ON or OFF? That's the light's **state**!

The **state** of your light is either "ON" or "OFF". That's it!

---

## What Is State in Programming?

**State** is simply **information that can change**.

Think of these examples:

### Example 1: A Toggle Button
```
Is WiFi on?
[OFF]  →  Tap it  →  [ON]
```
The state changed from OFF to ON!

### Example 2: A Counter
```
Counter: 0  →  Press +  →  Counter: 1  →  Press +  →  Counter: 2
```
The state (the number) keeps changing!

### Example 3: Your Name in a Form
```
Name: [___________]  →  Type "Alex"  →  Name: [Alex______]
```
The state (text in the box) changes as you type!

---

## State in Flutter Apps

Let's look at a shopping app:

```
┌─────────────────────────────────┐
│        Shopping Cart            │
│                                 │
│  🍎 Apple        $1.00    [x]  │
│  🍌 Banana       $0.50    [x]  │
│  🍊 Orange       $0.75    [x]  │
│                                 │
│  Total: $2.25                   │
│                                 │
│  Items in cart: 3               │
└─────────────────────────────────┘
```

What can change in this cart?
- ✅ Items in the cart (you can add/remove items)
- ✅ Total price (changes when items change)
- ✅ Number of items (changes when items change)

All of these are **state** because they can change!

---

## Things That Are NOT State

Some things in your app NEVER change:

```dart
// These are NOT state - they're constants
final String appName = "My Cool App";  // Never changes
final Color primaryColor = Colors.blue;  // Never changes
final int maxLoginAttempts = 3;  // Never changes
```

If it never changes, it's NOT state - it's just a regular variable or constant!

---

## Simple Flutter Example

Here's a simple counter with state:

```dart
class CounterApp extends StatefulWidget {
  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  // This is STATE - it can change!
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Show the current state
            Text('Counter: $counter'),

            // Button to change the state
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;  // State changes!
                });
              },
              child: Text('Add 1'),
            ),
          ],
        ),
      ),
    );
  }
}
```

See how `counter` changes when you press the button? That's state!

---

## Key Takeaways

1. **State** = Data that can change
2. When state changes, Flutter rebuilds the screen to show the new data
3. Use `setState()` to tell Flutter "Hey, something changed!"

---

## One-Minute Recap

- State is data that can change while the app runs (a counter, a toggle, a cart).
- Things that never change (an app name, a fixed colour) are not state, just constants.
- When state changes, you call `setState` so Flutter rebuilds the screen with the new data.

---

## Quick Quiz

**Q1.** In one sentence, what is state?

<details>
<summary>Answer</summary>
Data in your app that can change while it is running.
</details>

**Q2.** Is the app's name (which never changes) state?

<details>
<summary>Answer</summary>
No. If it never changes, it is just a constant, not state.
</details>

**Q3.** When state changes, what do you call so the screen updates?

<details>
<summary>Answer</summary>
`setState` (from Level 5). It tells Flutter to rebuild.
</details>

---

## Assignment

### Problem 1: State or not?

For each, say whether it is **state** (can change) or **not state** (never changes):

1. `int score = 0;`
2. `final String appName = 'My App';`
3. `bool isDark = false;`
4. `final double pi = 3.14159;`
5. `List<String> todos = [];`

### Problem 2: List the state

Think about a music player app. List three pieces of **state** it would have (things that change while you use it).

### Problem 3: Build a counter (recap)

Using `setState` from Level 5, build a `StatefulWidget` with an `int count` and a button that adds 1 and shows the count. (This is state in action.)

---

## Assignment Answers

### Problem 1: State or not?

1. `score` -> **state** (it goes up and down).
2. `appName` -> **not state** (it is `final` and never changes).
3. `isDark` -> **state** (it can flip true/false).
4. `pi` -> **not state** (a fixed constant).
5. `todos` -> **state** (you add and remove items).

The test: ask "does this change while the app runs?" If yes, it is state.

### Problem 2: List the state

A music player's state could include: the current song, whether it is playing or paused, the volume, the current position in the song, and whether it is on shuffle. All of these change as you use the app. (Any three are fine.)

### Problem 3: Build a counter (recap)

```dart
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;   // this is state

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('Add 1'),
        ),
      ],
    );
  }
}
```

`count` is state. Tapping the button changes it inside `setState`, and the screen rebuilds with the new number. This is exactly the kind of changing data the rest of Level 6 helps you manage across a whole app.

---

**Next:** `01b-TypesOfState.md`, the two kinds of state.

---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Two Types of State](01b-TypesOfState.md)
