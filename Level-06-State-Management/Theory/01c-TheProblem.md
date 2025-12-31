# Part 3: The Problem with setState

You know how to use `setState` for local state. But what happens when you try to share state between MANY widgets using `setState`? Let's find out!

---

## The Problem: Passing Data Down, Down, Down...

Imagine you have a counter that needs to be shown on 3 different screens.

### The Wrong Way (Called "Prop Drilling")

```dart
// Top of the app - state lives here
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;  // State is at the top

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        counter: counter,                    // Pass down ⬇️
        onIncrement: incrementCounter,       // Pass down ⬇️
      ),
    );
  }
}

// HomePage receives it and passes it down AGAIN
class HomePage extends StatelessWidget {
  final int counter;                  // Receive it
  final VoidCallback onIncrement;     // Receive it

  const HomePage({
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(counter: counter),           // Pass down ⬇️
          ContentWidget(                            // Pass down ⬇️
            counter: counter,
            onIncrement: onIncrement,
          ),
          FooterWidget(counter: counter),           // Pass down ⬇️
        ],
      ),
    );
  }
}

// ContentWidget ALSO has to pass it down!
class ContentWidget extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;

  const ContentWidget({
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonSection(                    // Pass down AGAIN ⬇️
      counter: counter,
      onIncrement: onIncrement,
    );
  }
}

// Finally! The button that actually USES it!
class ButtonSection extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;

  const ButtonSection({
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onIncrement,  // Finally used here!
      child: Text('Counter: $counter'),  // Finally used here!
    );
  }
}
```

Look at all that passing! 😫

```
App
 │
 ├─> HomePage (passes counter but doesn't use it)
      │
      ├─> ContentWidget (passes counter but doesn't use it)
           │
           └─> ButtonSection (FINALLY uses counter!)
```

---

## Problem #1: Too Much Passing

The data has to travel through widgets that don't even need it!

```
┌──────────────────────────────────────┐
│                                      │
│   MyApp                              │
│   counter = 5 ────────┐              │
│                       │              │
│   ┌───────────────────▼──────────┐   │
│   │ HomePage                     │   │
│   │ (doesn't need counter)       │   │
│   │                              │   │
│   │  ┌────────────────▼───────┐  │   │
│   │  │ ContentWidget          │  │   │
│   │  │ (doesn't need counter) │  │   │
│   │  │                        │  │   │
│   │  │  ┌──────────▼───────┐  │  │   │
│   │  │  │ ButtonSection    │  │  │   │
│   │  │  │ (USES counter!)  │  │  │   │
│   │  │  └──────────────────┘  │  │   │
│   │  └────────────────────────┘  │   │
│   └─────────────────────────────┘   │
│                                      │
└──────────────────────────────────────┘

Counter travels through 2 widgets that don't care about it!
```

---

## Problem #2: Messy Code

Every single widget in the chain needs extra parameters:

```dart
// ❌ BAD: Every widget needs these parameters
class HomePage extends StatelessWidget {
  final int counter;              // Extra parameter
  final VoidCallback onIncrement; // Extra parameter
  // ...
}

class ContentWidget extends StatelessWidget {
  final int counter;              // Extra parameter
  final VoidCallback onIncrement; // Extra parameter
  // ...
}

class ButtonSection extends StatelessWidget {
  final int counter;              // Extra parameter
  final VoidCallback onIncrement; // Extra parameter
  // ...
}
```

What if you need to add MORE state?

```dart
// Now you need to add user data too...
class HomePage extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  final String userName;          // New!
  final String userEmail;         // New!
  final VoidCallback onLogout;    // New!
  // ...
}
```

Every widget in the chain needs updating! 😫

---

## Problem #3: Everything Rebuilds

When the counter changes, EVERYTHING rebuilds - even widgets that don't show the counter!

```dart
setState(() {
  counter++;  // Change the counter
});

// What rebuilds?
┌─────────────────────────────┐
│ MyApp        (rebuilds!) ❌  │
│  │                          │
│  └─> HomePage  (rebuilds!) ❌│
│       │                     │
│       ├─> Header (rebuilds!) ❌ (doesn't even show counter!)
│       ├─> Content (rebuilds!) ❌
│       └─> Footer (rebuilds!) ❌ (doesn't even show counter!)
└─────────────────────────────┘

Everything rebuilds, even widgets that don't need to!
```

This is **SLOW** and **WASTES BATTERY**!

---

## Problem #4: Hard to Test

To test the button, you need to create the ENTIRE widget tree:

```dart
// ❌ Have to create everything just to test one button
testWidgets('Counter increments', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyApp(  // Need this
        child: HomePage(  // Need this
          child: ContentWidget(  // Need this
            child: ButtonSection(  // Finally! The thing we want to test
              counter: 0,
              onIncrement: () {},
            ),
          ),
        ),
      ),
    ),
  );
});
```

---

## Problem #5: Can't Share State Between Screens

What if two different screens need the same data?

```
Screen A: Shows cart items
Screen B: Shows cart total

How do they share the cart state?
```

With `setState`, you'd need to:
1. Put state in a common parent (maybe all the way at the top!)
2. Pass it down to both screens
3. Pass callbacks up to modify it

This gets messy FAST!

---

## Real Example: Todo App

Let's say you're building a todo app:

```
┌────────────────────────────────────┐
│  Todo App                          │
│                                    │
│  Header (shows todo count)         │
│  ─────────────────────────────     │
│  Todo List (shows all todos)       │
│  ─────────────────────────────     │
│  Add Button (adds new todo)        │
│  ─────────────────────────────     │
│  Stats (shows completed count)     │
└────────────────────────────────────┘
```

With `setState`:
- Todo list state lives at the top
- Pass down to Header (to show count)
- Pass down to TodoList (to show items)
- Pass down to AddButton (to add new todos)
- Pass down to Stats (to show completed)

```
Todos = [...]
    │
    ├──> Header (needs todos.length)
    ├──> TodoList (needs todos)
    ├──> AddButton (needs addTodo function)
    └──> Stats (needs todos.where(done).length)
```

Every change requires passing through multiple widgets!

---

## Summary of Problems

| Problem | Description |
|---------|-------------|
| 🔴 Prop Drilling | Data passes through widgets that don't use it |
| 🔴 Messy Code | Every widget needs extra parameters |
| 🔴 Over-Rebuilding | Entire tree rebuilds when state changes |
| 🔴 Hard to Test | Need full widget tree just to test one widget |
| 🔴 Can't Share | Difficult to share state between distant widgets |

---

## We Need a Better Solution!

What if widgets could:
- ✅ Access data directly (no passing!)
- ✅ Only rebuild when their data changes
- ✅ Share data across the entire app
- ✅ Be easy to test

**That's exactly what state management tools do!**

---

**Next:** Learn how state management solves all these problems!

---

## Navigation

⬅️ **Previous:** [Two Types of State](01b-TypesOfState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The Solution](01d-TheSolution.md)
