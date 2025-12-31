# Part 1: What Is State?

Welcome! Before we learn fancy tools like Provider or BLoC, let's understand ONE simple idea: **What is state?**

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

## Try It Yourself!

Can you identify which of these is state?

```dart
final String title = "My App";        // State? ❌ (never changes)
int score = 0;                        // State? ✅ (can increase/decrease)
bool isLoggedIn = false;              // State? ✅ (can be true/false)
final double pi = 3.14159;            // State? ❌ (never changes)
List<String> todoItems = [];          // State? ✅ (can add/remove items)
```

---

**Next:** Learn about the two types of state!

---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Two Types of State](01b-TypesOfState.md)
