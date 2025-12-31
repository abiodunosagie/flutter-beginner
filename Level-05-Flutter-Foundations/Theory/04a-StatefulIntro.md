# StatefulWidget: Widgets That Remember and Change

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

### Rule 3: Don't Do Async Work Inside setState

```dart
// ❌ WRONG: Async inside setState
setState(() async {
  await fetchData();  // Don't do this!
  items = data;
});

// ✅ RIGHT: Async outside, setState after
Future<void> loadData() async {
  final data = await fetchData();  // Do async work first
  setState(() {
    items = data;  // Then update state
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
      isOn = !isOn;  // Flip between true and false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      onChanged: (value) {
        setState(() {
          isOn = value;
        });
      },
    );
  }
}
```

### Pattern 2: List Manipulation

```dart
class _TodoListState extends State<TodoList> {
  List<String> todos = [];

  void addTodo(String todo) {
    setState(() {
      todos.add(todo);
    });
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }
}
```

### Pattern 3: Loading State

```dart
class _DataWidgetState extends State<DataWidget> {
  bool isLoading = false;
  String? data;

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final result = await fetchFromApi();

    setState(() {
      data = result;
      isLoading = false;
    });
  }
}
```

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

## Practice Challenge

Try creating a widget that:
1. Shows a smiley face 😊 or sad face 😢
2. Has a button to toggle between happy and sad
3. Shows how many times you've toggled

<details>
<summary>Hint</summary>

You'll need:
- A `bool isHappy` variable
- An `int toggleCount` variable
- A method that uses `setState()` to change both

</details>

---

**Next:** Learn about the Widget Lifecycle and how widgets are born, live, and die.

---

**Navigation:**
- **Previous:** [03c-StatelessContext.md](03c-StatelessContext.md) - StatelessWidget and BuildContext
- **Next:** [04b-Lifecycle.md](04b-Lifecycle.md) - Widget Lifecycle Methods
- **Up:** [Level 05 Theory](../README.md)
