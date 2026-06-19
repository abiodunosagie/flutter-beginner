# StatefulWidget: Real Interactive Examples

## The Big Idea In One Sentence

> Now you put it all together: stateful widgets that **react to taps** by changing what is on screen.

This lesson is all practice. Each example is a complete app you can paste into [dartpad.dev](https://dartpad.dev) and tap.

> These use `ElevatedButton` (covered fully in lesson `06a`). For now: `onPressed:` runs your code when the button is tapped.

---

## Example 1: A Counter With A Step And A Face

A counter that goes up and down by a chosen amount, and shows a face based on the number.

```dart
import 'package:flutter/material.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({super.key});

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  int count = 0;
  int step = 1;

  String face() {
    if (count < 0) return ':(';
    if (count == 0) return ':|';
    return ':)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(face(), style: const TextStyle(fontSize: 64)),
            Text('$count', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
            Text('Step: $step'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => count -= step),
                  child: const Text('-'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => count = 0),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => count += step),
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => setState(() => step = 1), child: const Text('Step 1')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => setState(() => step = 5), child: const Text('Step 5')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

What is happening: `count` and `step` are state. Tapping `+` adds `step` to `count` inside `setState`, so the screen rebuilds with the new number, and `face()` picks a face based on it. The step buttons change how much each tap adds.

---

## Example 2: A Like Button

A heart that fills in when you like it, with a count.

```dart
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool liked = false;
  int likes = 0;

  void toggleLike() {
    setState(() {
      liked = !liked;
      likes = liked ? likes + 1 : likes - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: toggleLike,
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? Colors.red : Colors.grey,
          ),
        ),
        Text('$likes'),
      ],
    );
  }
}
```

`liked` is a yes/no in state. Each tap flips it: the icon switches between a filled red heart and a grey outline, and the count goes up or down. (`IconButton` is just a tappable icon; you will see it again in 06a.)

---

## Example 3: A Simple Wishlist

Tap a button to add items, and see them listed with a count. (We add a fixed item each time, because typing text in needs `TextField`, which is lesson `06b`.)

```dart
import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<String> items = [];

  void addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  void clear() {
    setState(() {
      items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist (${items.length})')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show each item as a Text (map turns the list into a list of widgets)
            ...items.map((item) => Text(item)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: addItem, child: const Text('Add')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: clear, child: const Text('Clear')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

`items` is a `List<String>` in state (lists are from Level 3). Tapping Add appends an item and rebuilds, so the new item appears and the title count updates. The `...items.map((item) => Text(item))` turns each string into a `Text` and spreads them into the Column's children. (You will learn `ListView`, a nicer way to show long lists, in lesson `06c`.)

---

## The Top Mistakes Beginners Make

### Mistake 1: Changing state without setState

```dart
void add() {
  count++;             // BAD: screen will not update
}
void add() {
  setState(() => count++);   // GOOD
}
```

### Mistake 2: Putting state in the wrong class

State variables (the ones that change) go in the **State** class, not the StatefulWidget class. The widget class only holds `final` properties passed in.

### Mistake 3: Doing slow work inside setState

Keep `setState` tiny: just change the variables. Do any heavy calculation before it, then call `setState` with the result.

### Mistake 4: Forgetting initial values

Give your state variables a starting value (`int count = 0;`), or set them in `initState`. An uninitialized value will not compile.

---

## One-Minute Recap

- Real interactive widgets keep their changing data in state and update it with `setState`.
- A counter changes a number; a like button flips a bool and swaps an icon; a wishlist grows a list.
- `setState` rebuilds the screen so the new state shows.
- Keep state in the State class, give it starting values, and keep `setState` small.

---

## Quick Quiz

**Q1.** In the like button, what two pieces of state change on each tap?

<details>
<summary>Answer</summary>
`liked` (the bool, flipped) and `likes` (the count, up or down). Both change inside one `setState`.
</details>

**Q2.** Why does the wishlist title count update when you add an item?

<details>
<summary>Answer</summary>
`addItem` adds to the list inside `setState`, which rebuilds the widget. The title reads `items.length`, so it shows the new count.
</details>

**Q3.** Where do changing variables like `count` belong?

<details>
<summary>Answer</summary>
In the State class (the `_...State` one), not the StatefulWidget class.
</details>

---

## Assignment

Paste these into [dartpad.dev](https://dartpad.dev) and tap them.

### Problem 1: Points tracker

Build a `StatefulWidget` called `Points` with an `int score` starting at 0. Show the score and two buttons: `'+5'` adds 5, `'Reset'` sets it back to 0.

### Problem 2: Show/hide toggle

Build a `StatefulWidget` called `SecretMessage` with a `bool show` starting at false. Show a button labelled `'Show'` or `'Hide'`. When `show` is true, also display the text `'Surprise!'`. Tapping the button flips `show`.

### Problem 3: A grade picker

Build a `StatefulWidget` called `Grade` with a `String grade` starting at `'A'`. Show the current grade big, and three buttons `'A'`, `'B'`, `'C'` that set the grade to that letter.

### Problem 4: Spot the bug

Why does the count never change on screen?

```dart
class _TapState extends State<Tap> {
  int taps = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        taps = taps + 1;
      },
      child: Text('Taps: $taps'),
    );
  }
}
```

---

## Assignment Answers

### Problem 1: Points tracker

```dart
import 'package:flutter/material.dart';

class Points extends StatefulWidget {
  const Points({super.key});

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Score: $score', style: const TextStyle(fontSize: 32)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => setState(() => score += 5), child: const Text('+5')),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () => setState(() => score = 0), child: const Text('Reset')),
          ],
        ),
      ],
    );
  }
}
```

Each button changes `score` inside `setState`, so the number updates on screen.

### Problem 2: Show/hide toggle

```dart
import 'package:flutter/material.dart';

class SecretMessage extends StatefulWidget {
  const SecretMessage({super.key});

  @override
  State<SecretMessage> createState() => _SecretMessageState();
}

class _SecretMessageState extends State<SecretMessage> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (show) const Text('Surprise!', style: TextStyle(fontSize: 32)),
        ElevatedButton(
          onPressed: () => setState(() => show = !show),
          child: Text(show ? 'Hide' : 'Show'),
        ),
      ],
    );
  }
}
```

`if (show) Text('Surprise!')` includes the message only when `show` is true. The button flips `show` and updates its own label.

### Problem 3: A grade picker

```dart
import 'package:flutter/material.dart';

class Grade extends StatefulWidget {
  const Grade({super.key});

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  String grade = 'A';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(grade, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => setState(() => grade = 'A'), child: const Text('A')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => setState(() => grade = 'B'), child: const Text('B')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => setState(() => grade = 'C'), child: const Text('C')),
          ],
        ),
      ],
    );
  }
}
```

Each button sets `grade` to its letter inside `setState`, and the big text shows the chosen grade.

### Problem 4: Spot the bug

The `onPressed` changes `taps` but does not call `setState`, so Flutter never rebuilds and the screen keeps showing the old number. Fix:

```dart
onPressed: () {
  setState(() {
    taps = taps + 1;
  });
},
```

Now each tap rebuilds the button with the new count.

---

**Next:** `05a-ConstraintsLayout.md`, where you learn how Flutter decides the size of everything.
