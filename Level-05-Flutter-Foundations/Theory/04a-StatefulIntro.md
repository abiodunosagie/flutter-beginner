# StatefulWidget: Widgets That Remember and Change

## The Big Idea In One Sentence

> A StatefulWidget can **change while it is on screen**, and you make it update by calling `setState`.

This is the lesson the rest of Flutter depends on. Take your time.

> The examples here use `ElevatedButton` so you have something to tap. You learn buttons properly in lesson `06a`; for now just know `onPressed:` runs the code you give it when the button is tapped.

---

## Think Like a Kid with a Light Switch

Imagine you have a light switch on the wall:

```
💡 OFF → You flip it → 💡 ON
```

The switch **remembers** if it's on or off. Even if you leave the room and come back, it stays in the same position!

That's exactly what a **StatefulWidget** does - it's a widget that can **change** and **remember** its state.

```dart
// A counter that remembers its number
Text('Count: 0')  →  You tap  →  Text('Count: 1')
                 (remembers the count!)
```

---

## What is a StatefulWidget?

A **StatefulWidget** is a widget that can **change over time**.

Think of the difference:

| StatelessWidget | StatefulWidget |
|-----------------|----------------|
| 🗿 Like a statue - never changes | 💡 Like a light switch - can change |
| 📝 A sign that always says "STOP" | ⏰ A clock that updates every second |
| 🏔️ A mountain (stays the same) | 🌡️ A thermometer (changes) |

```dart
// This counter can change when you tap the button
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;  // This can change!

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}
```

---

## When to Use StatefulWidget

Use StatefulWidget when your UI needs to change based on user interaction or time:

| Situation | Use StatefulWidget? | Why? |
|-----------|---------------------|------|
| Counter that increases | ✅ Yes | Number changes |
| Toggle switch (on/off) | ✅ Yes | State toggles |
| Form with text input | ✅ Yes | Text changes as user types |
| Loading spinner | ✅ Yes | Animates and changes |
| Favorite button | ✅ Yes | Switches between filled/empty heart |
| Timer or clock | ✅ Yes | Updates every second |
| Static text "Hello" | ❌ No | Never changes - use StatelessWidget |
| Fixed icon | ❌ No | Never changes - use StatelessWidget |
| Company logo | ❌ No | Never changes - use StatelessWidget |

---

## The Two-Part Structure

Here's the special thing about StatefulWidget - it has **TWO classes**!

```
StatefulWidget (the recipe)
       │
       └── State (the actual food you can change)
```

Think of it like baking:
- **StatefulWidget** = The recipe card (never changes)
- **State** = The actual cake you're baking (you can add frosting, decorations, etc.)

```dart
// PART 1: The Widget (like a recipe - doesn't change)
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

// PART 2: The State (like the actual cake - can change!)
class _CounterState extends State<Counter> {
  int count = 0;  // This can change!

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

---

## Why Two Classes?

You might wonder: "Why do we need TWO classes? Why not just one?"

Here's why:

```
Imagine your toy box:

📦 The TOY BOX itself (StatefulWidget)
   - Stays the same
   - Same size, same color
   - Never changes

🎨 The TOYS INSIDE (State)
   - Can change
   - Add new toys
   - Remove old toys
   - Rearrange them
```

Flutter rebuilds widgets VERY often (hundreds of times!), but your **State** stays the same. This keeps your data safe!

```dart
// The widget can be recreated many times
class Counter extends StatefulWidget {
  const Counter({super.key});  // This is immutable (can't change)

  @override
  State<Counter> createState() => _CounterState();
}

// The state stays alive and keeps your data
class _CounterState extends State<Counter> {
  int count = 0;  // This survives through rebuilds!

  @override
  Widget build(BuildContext context) {
    // This build method is called many times,
    // but 'count' keeps its value!
    return Text('$count');
  }
}
```

---

## Basic Structure Explained

Let's break down the complete structure:

```dart
import 'package:flutter/material.dart';

// ============================================
// PART 1: The StatefulWidget Class
// ============================================
class MyWidget extends StatefulWidget {
  // Properties from parent (these never change)
  final String title;
  final Color color;

  const MyWidget({
    super.key,
    required this.title,
    this.color = Colors.blue,
  });

  // This creates the State object
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// ============================================
// PART 2: The State Class
// ============================================
class _MyWidgetState extends State<MyWidget> {
  // Mutable state variables (these CAN change!)
  int counter = 0;
  bool isActive = false;
  String message = 'Hello';

  // Access widget properties using: widget.propertyName

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),      // From the widget (immutable)
        Text('Count: $counter'), // From the state (mutable)
        Text(message),           // From the state (mutable)
      ],
    );
  }
}
```

### The Naming Convention

Notice the underscore `_` before the State class:

```dart
class MyWidget extends StatefulWidget { ... }
class _MyWidgetState extends State<MyWidget> { ... }
//    ^
//    Underscore = private to this file only
```

This means `_MyWidgetState` can only be used in this file. It's like a secret clubhouse - only members (code in this file) can enter!

---

## The Magic: setState()

To update the UI, you **must** call `setState()`. This is the magic spell that tells Flutter to redraw!

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  // ✅ RIGHT WAY: Use setState()
  void increment() {
    setState(() {
      count++;  // Change the value inside setState
    });
    // Flutter now knows to rebuild the UI!
  }

  // ❌ WRONG WAY: Changing without setState()
  void wrongIncrement() {
    count++;  // Value changes...
    // But UI doesn't update! 😢
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: increment,  // ✅ Use the right method
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

---

## How setState() Works

Think of setState() like telling your friend to look at your drawing again:

```
1. You change the drawing (count++)
   │
   ▼
2. You say "Hey, look again!" (setState)
   │
   ▼
3. Your friend looks (Flutter calls build)
   │
   ▼
4. They see the new drawing (UI updates)
```

In Flutter:

```
1. You call setState()
       │
       ▼
2. Flutter marks widget as "dirty" (needs redrawing)
       │
       ▼
3. Flutter calls build() again
       │
       ▼
4. New UI appears with new values
```

---

## setState() Rules

### Rule 1: Change State Inside setState

```dart
// ✅ GOOD: Change inside setState
setState(() {
  count++;
  isLoading = true;
  items.add(newItem);
});

// ✅ ALSO GOOD: Change before, call setState after
count++;
isLoading = true;
items.add(newItem);
setState(() {});  // Empty but triggers rebuild
```

### Rule 2: NEVER Call setState in build()

```dart
// ❌ BAD: Creates infinite loop!
@override
Widget build(BuildContext context) {
  setState(() { });  // NEVER do this!
  return Container();
}
// Why? build() calls setState() which calls build() which calls setState()...
// Infinite loop! 🔄🔄🔄
```

### Rule 3: Keep What Is Inside setState Small

Put only the lines that **change your data** inside `setState`. Do the rest outside. The simplest habit: change one or two variables in there, nothing more.

```dart
void addPoint() {
  setState(() {
    score = score + 1;   // just the change
  });
}
```

---

## Complete Example: Counter App

Let's build a complete counter app with increment, decrement, and reset:

```dart
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: CounterApp()));

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  // State variable
  int _count = 0;

  // Methods to change state
  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) {  // Don't go below 0
        _count--;
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show the count
            Text(
              '$_count',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                // Reset button
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                // Increment button
                ElevatedButton(
                  onPressed: _increment,
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

Try this code! Tap the buttons and watch the number change.

---

## Common Patterns

### Pattern 1: Boolean Toggle

```dart
class _ToggleState extends State<ToggleWidget> {
  bool isOn = false;

  void toggle() {
    setState(() {
      isOn = !isOn;   // flip between true and false
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: toggle,
      child: Text(isOn ? 'ON' : 'OFF'),
    );
  }
}
```

Each tap flips `isOn` and the button label switches between `ON` and `OFF`.

### Pattern 2: A Growing List

```dart
class _TallyState extends State<TallyWidget> {
  List<String> items = [];

  void addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Items: ${items.length}'),
        ElevatedButton(onPressed: addItem, child: const Text('Add')),
      ],
    );
  }
}
```

Each tap adds to the list and rebuilds, so the count goes up.

---

## Summary

| Concept | What It Does |
|---------|--------------|
| StatefulWidget | A widget that can change |
| State class | Holds the changeable data |
| setState() | Tells Flutter to rebuild the widget |
| Two-part structure | Widget (recipe) + State (actual food) |
| Underscore `_` | Makes the State class private |

**Remember:**
- Use StatefulWidget when things need to change
- Always use setState() to update the UI
- Never call setState() inside build()
- The widget is immutable, the state is mutable

---

## Assignment

Paste these full apps into [dartpad.dev](https://dartpad.dev) (Flutter mode) and tap to see them change. Shell:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: YOUR_WIDGET()))));
```

### Problem 1: Predict the behaviour

You tap the "Add" button three times. What number shows?

```dart
class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

### Problem 2: Spot the bug

Why does this counter never change on screen, even though you tap the button?

```dart
class _BrokenState extends State<Broken> {
  int count = 0;

  void add() {
    count++;   // no setState!
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: add, child: Text('$count'));
  }
}
```

### Problem 3: Build a toggle

Build a `StatefulWidget` called `Lamp` with a `bool isOn` (start `false`). Show a button whose label is `'ON'` when `isOn` is true and `'OFF'` when false. Tapping it flips `isOn`.

### Problem 4: Happy or sad with a count

Build a `StatefulWidget` called `Mood` with a `bool isHappy` (start `true`) and an `int taps` (start `0`). Show the text `':)'` when happy and `':('` when sad, plus `'Tapped: <taps>'`. A button flips the mood and adds 1 to `taps`.

---

## Assignment Answers

### Problem 1: Predict the behaviour

It shows `3`. Each tap runs `setState(() => count++)`, which adds 1 to `count` and rebuilds. Three taps means 0, then 1, then 2, then 3.

### Problem 2: Spot the bug

The `add` method changes `count` but never calls `setState`. Without `setState`, Flutter does not know anything changed, so it never rebuilds, and the screen keeps showing the old number. The value in memory does go up, but you cannot see it.

Fix:

```dart
void add() {
  setState(() {
    count++;
  });
}
```

### Problem 3: Build a toggle

```dart
import 'package:flutter/material.dart';

class Lamp extends StatefulWidget {
  const Lamp({super.key});

  @override
  State<Lamp> createState() => _LampState();
}

class _LampState extends State<Lamp> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isOn = !isOn;
        });
      },
      child: Text(isOn ? 'ON' : 'OFF'),
    );
  }
}
```

Each tap flips `isOn` inside `setState`, so the label switches between `ON` and `OFF`.

### Problem 4: Happy or sad with a count

```dart
import 'package:flutter/material.dart';

class Mood extends StatefulWidget {
  const Mood({super.key});

  @override
  State<Mood> createState() => _MoodState();
}

class _MoodState extends State<Mood> {
  bool isHappy = true;
  int taps = 0;

  void flip() {
    setState(() {
      isHappy = !isHappy;
      taps = taps + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isHappy ? ':)' : ':(', style: const TextStyle(fontSize: 48)),
        Text('Tapped: $taps'),
        ElevatedButton(onPressed: flip, child: const Text('Flip mood')),
      ],
    );
  }
}
```

The `flip` method changes **both** state variables inside one `setState`: it flips the mood and adds one to the tap count. Then the rebuild shows the new face and the new count.

---

**Next:** `04b-Lifecycle.md`, where you learn the special methods that run when a widget is born and when it goes away.

---

**Navigation:**
- **Previous:** [03c-StatelessContext.md](03c-StatelessContext.md) - StatelessWidget and BuildContext
- **Next:** [04b-Lifecycle.md](04b-Lifecycle.md) - Widget Lifecycle Methods
- **Up:** [Level 05 Theory](../README.md)
