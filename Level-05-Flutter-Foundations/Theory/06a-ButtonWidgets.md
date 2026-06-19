# Buttons: Letting The User Tap

## The Big Idea In One Sentence

> A button shows something tappable and runs your code in its `onPressed` when the user taps it.

You have used `ElevatedButton` already. Now you meet the main button types and how to handle a tap.

---

## For A 5-Year-Old

A button is like a doorbell. You press it, and something happens (a sound, a light, a door opens). In Flutter, "something happens" is the code you put in `onPressed`.

---

## The Heart Of Every Button: onPressed

Every button has an `onPressed`. You give it a function, and Flutter runs that function when the button is tapped.

```dart
ElevatedButton(
  onPressed: () {
    print('Tapped!');
  },
  child: const Text('Tap me'),
)
```

The `() { ... }` is a small function that runs on tap. The `child` is what the button shows.

> Special rule: if you set `onPressed: null`, the button is **disabled** (greyed out and not tappable). This is how you turn a button off.

---

## The Main Button Types

Flutter gives you three text buttons that look different but work the same way. Pick by how important the action is.

### ElevatedButton: the main action

A filled, raised button. Use it for the most important action (Save, Submit, Next).

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Save'),
)
```

### OutlinedButton: a secondary action

A button with a border and no fill. Use it for a less important action next to the main one (Cancel).

```dart
OutlinedButton(
  onPressed: () {},
  child: const Text('Cancel'),
)
```

### TextButton: a subtle action

Just text, no border or fill. Use it for the least important actions (Learn more, Skip).

```dart
TextButton(
  onPressed: () {},
  child: const Text('Skip'),
)
```

They look like:

```
[ Save ]        (ElevatedButton: filled)
[  Cancel  ]    (OutlinedButton: just a border)
 Skip           (TextButton: just text)
```

---

## Buttons With An Icon

Each text button has an `.icon` version that shows an icon next to the label:

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.save),
  label: const Text('Save'),
)
```

Note it uses `icon:` and `label:` instead of `child:`.

---

## IconButton: Just An Icon

When you want only an icon to tap (like a heart, a settings gear, a back arrow), use `IconButton`:

```dart
IconButton(
  onPressed: () {},
  icon: const Icon(Icons.favorite),
)
```

You often see these in the app bar.

---

## FloatingActionButton: The Round Action Button

The round button that floats over the bottom-right of a screen. It goes in the `Scaffold`'s `floatingActionButton` slot:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Home')),
  body: const Center(child: Text('Tap the + button')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
)
```

---

## Styling A Button

To change a button's colours, use `style: ElevatedButton.styleFrom(...)`:

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,   // the fill colour
    foregroundColor: Colors.white,   // the text/icon colour
  ),
  child: const Text('Green button'),
)
```

`backgroundColor` is the button's colour; `foregroundColor` is the colour of the text and icon on it.

---

## A Real Button: A Counter

Buttons shine with stateful widgets. Here is a button that actually changes the screen, combining what you learned in `04a`:

```dart
import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {
  const CounterButton({super.key});

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Count: $count', style: const TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('Add one'),
        ),
      ],
    );
  }
}
```

The button's `onPressed` calls `setState` to bump the count, and the screen rebuilds with the new number.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting onPressed

```dart
ElevatedButton(child: Text('hi'))   // BAD: onPressed is required
ElevatedButton(onPressed: () {}, child: Text('hi'))   // GOOD
```

### Mistake 2: Calling the function instead of passing it

```dart
onPressed: doThing()    // BAD: runs doThing right now, once
onPressed: doThing      // GOOD: passes the function to run on tap
onPressed: () => doThing()   // also GOOD
```

### Mistake 3: Using child for the .icon version

```dart
ElevatedButton.icon(onPressed: () {}, child: Text('Save'))           // BAD
ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.save), label: Text('Save'))  // GOOD
```

### Mistake 4: Changing data without setState

A button that updates the screen must call `setState` (or it will not show the change).

---

## One-Minute Recap

- Every button runs the function in its `onPressed` when tapped. `onPressed: null` disables it.
- `ElevatedButton` (main), `OutlinedButton` (secondary), `TextButton` (subtle) all work the same way.
- The `.icon` versions add an icon (use `icon:` and `label:`).
- `IconButton` is an icon-only button. `FloatingActionButton` is the round button in a Scaffold.
- Style with `style: ElevatedButton.styleFrom(backgroundColor: ..., foregroundColor: ...)`.

---

## Quick Quiz

**Q1.** What runs when a button is tapped?

<details>
<summary>Answer</summary>
The function you gave to `onPressed`.
</details>

**Q2.** How do you disable a button?

<details>
<summary>Answer</summary>
Set `onPressed: null`. The button greys out and cannot be tapped.
</details>

**Q3.** Which button is for the most important action on a screen?

<details>
<summary>Answer</summary>
`ElevatedButton` (the filled one). `OutlinedButton` and `TextButton` are for less important actions.
</details>

**Q4.** What is wrong with `onPressed: doThing()`?

<details>
<summary>Answer</summary>
The `()` calls `doThing` immediately, once, instead of on tap. Pass it without `()`: `onPressed: doThing`, or wrap it: `onPressed: () => doThing()`.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev), wrapping in `Scaffold(body: Center(child: ...))`.

### Problem 1: Pick the button

For each action, which button type fits best: `ElevatedButton`, `OutlinedButton`, or `TextButton`?

1. The main "Sign Up" button.
2. A "Cancel" next to a main button.
3. A subtle "Forgot password?" link.

### Problem 2: A counter button

Build a `StatefulWidget` that shows a number and an `ElevatedButton` labelled `'Add'`. Each tap adds 1 and updates the screen.

### Problem 3: A save button with an icon

Build an `ElevatedButton.icon` with a save icon and the label `'Save'` that prints `'Saved!'` when tapped.

### Problem 4: A green styled button

Build an `ElevatedButton` with a green background and white text that says `'Go'`.

### Problem 5: Spot the bug

```dart
ElevatedButton(
  onPressed: print('hi'),
  child: const Text('Tap'),
)
```

---

## Assignment Answers

### Problem 1: Pick the button

1. Sign Up -> `ElevatedButton` (the main action).
2. Cancel -> `OutlinedButton` (secondary, next to the main one).
3. Forgot password? -> `TextButton` (subtle, low importance).

### Problem 2: A counter button

```dart
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count', style: const TextStyle(fontSize: 32)),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

The button's `onPressed` calls `setState` to add 1, so the number updates each tap.

### Problem 3: A save button with an icon

```dart
ElevatedButton.icon(
  onPressed: () => print('Saved!'),
  icon: const Icon(Icons.save),
  label: const Text('Save'),
)
```

The `.icon` version uses `icon:` and `label:` instead of `child:`.

### Problem 4: A green styled button

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  ),
  child: const Text('Go'),
)
```

`backgroundColor` makes the button green, and `foregroundColor` makes the text white.

### Problem 5: Spot the bug

`onPressed: print('hi')` calls `print` immediately (when the button is built), not on tap, and passes its result to `onPressed`, which is wrong. Wrap it in a function:

```dart
ElevatedButton(
  onPressed: () => print('hi'),
  child: const Text('Tap'),
)
```

Now `print('hi')` only runs when the button is actually tapped.

---

**Next:** `06b-InputWidgets.md`, where you let the user type with text fields.
