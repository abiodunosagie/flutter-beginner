# Widget Lifecycle: Birth, Life, and Goodbye

## The Big Idea In One Sentence

> A State object has a life story: it is **born** (`initState`), **lives** by rebuilding many times (`build`), and is **cleaned up** when it goes away (`dispose`).

You learned `setState` last lesson. Now you learn the special methods that run at the start and end of a widget's life.

---

## Think Of A Pet Fish

```
You bring it home      -> initState   (born, set things up)
It swims every day     -> build       (happens again and again)
You give it away       -> dispose     (clean up, say goodbye)
```

Every StatefulWidget's State follows this kind of story. Three methods matter most: `initState`, `build`, and `dispose`.

---

## initState: The Setup (Runs Once)

`initState` runs **one time**, right when the State is created, before the first `build`. It is where you set things up.

```dart
class _TimerBoxState extends State<TimerBox> {
  int seconds = 0;

  @override
  void initState() {
    super.initState();          // always call super FIRST
    seconds = 0;                // set starting values
    print('Widget is born');
  }

  @override
  Widget build(BuildContext context) {
    return Text('$seconds');
  }
}
```

Two rules for `initState`:

1. Call `super.initState()` first.
2. Do not use `context` here yet (it is not ready). If you need the theme or screen size at startup, read it in `build` instead.

Use `initState` to set starting values, or to start something that runs over time (like a timer, below).

---

## build: The Living Part (Runs Many Times)

You already know `build`. It runs the first time, and again every time you call `setState` or the parent rebuilds. Keep it simple: just return widgets. Never call `setState` inside `build` (that would loop forever).

---

## dispose: The Cleanup (Runs Once At The End)

`dispose` runs **one time**, when the widget is removed from the screen for good. It is where you turn off anything you started, so it does not keep running in the background.

The classic example is a **timer**. A timer (`Timer.periodic`) runs a piece of code over and over, like once per second. If you start one in `initState`, you must stop it in `dispose`, or it keeps ticking forever even after the widget is gone.

```dart
import 'dart:async';
import 'package:flutter/material.dart';

class SecondsCounter extends StatefulWidget {
  const SecondsCounter({super.key});

  @override
  State<SecondsCounter> createState() => _SecondsCounterState();
}

class _SecondsCounterState extends State<SecondsCounter> {
  int seconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // run this code once every second
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds = seconds + 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();    // stop the timer
    super.dispose();    // always call super LAST in dispose
  }

  @override
  Widget build(BuildContext context) {
    return Text('Seconds: $seconds');
  }
}
```

The pattern to remember: **start it in `initState`, stop it in `dispose`.** The number on screen ticks up once per second, and when the widget leaves, the timer is cancelled cleanly.

> One quirky rule: in `initState` you call `super` **first**, but in `dispose` you call `super.dispose()` **last** (after your own cleanup).

---

## Two More Lifecycle Methods (Good To Know)

You will not need these every day, but they exist:

- **`didChangeDependencies`** runs right after `initState`, and again whenever something it depends on (like the theme) changes. It is the safe place to read `Theme.of(context)` at startup, because `context` is ready here.
- **`didUpdateWidget`** runs when the parent rebuilds this widget with **new property values**. You use it to react when a property changes.

For most beginner widgets, `initState`, `build`, and `dispose` are all you need.

---

## The Order, At A Glance

```
First time on screen:   initState  ->  didChangeDependencies  ->  build
Every setState / update: build (again)
Removed from screen:    dispose
```

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting the super call

```dart
void initState() {
  seconds = 0;       // BAD: missing super.initState()
}
void initState() {
  super.initState(); // GOOD: super first
  seconds = 0;
}
```

### Mistake 2: Wrong super position in dispose

```dart
void dispose() {
  super.dispose();   // BAD: super should be last
  timer?.cancel();
}
void dispose() {
  timer?.cancel();   // GOOD
  super.dispose();
}
```

### Mistake 3: Using context in initState

```dart
void initState() {
  super.initState();
  Theme.of(context);   // BAD: context not ready yet
}
```

Read the theme in `build` (or in `didChangeDependencies`) instead.

### Mistake 4: Starting something and never stopping it

If you start a timer in `initState` and forget to cancel it in `dispose`, it keeps running after the widget is gone. Always clean up what you start.

---

## One-Minute Recap

- `initState` runs once at the start: set things up. Call `super` first. No `context` here.
- `build` runs many times: just return widgets.
- `dispose` runs once at the end: clean up (cancel timers). Call `super.dispose()` last.
- Start things in `initState`, stop them in `dispose`.
- `didChangeDependencies` (read theme at startup) and `didUpdateWidget` (react to new props) are extra methods you will rarely need at first.

---

## Quick Quiz

**Q1.** Which lifecycle method runs first when a widget appears?

<details>
<summary>Answer</summary>
`initState`. It runs once, before the first `build`.
</details>

**Q2.** Where do you cancel a timer you started?

<details>
<summary>Answer</summary>
In `dispose`, which runs once when the widget is removed. Call `super.dispose()` last.
</details>

**Q3.** Why should you not read `Theme.of(context)` in `initState`?

<details>
<summary>Answer</summary>
Because `context` is not ready yet in `initState`. Read it in `build` (or `didChangeDependencies`) instead.
</details>

**Q4.** In `initState` you call `super` first, but in `dispose` you call it...?

<details>
<summary>Answer</summary>
Last. You do your own cleanup first, then call `super.dispose()`.
</details>

---

## Assignment

Paste full apps into [dartpad.dev](https://dartpad.dev) (Flutter mode).

### Problem 1: Order the methods

Put these in the order they run when a widget first appears and is later removed: `dispose`, `build`, `initState`.

### Problem 2: Spot the bug

Why will this timer keep running even after the widget is gone? Fix it.

```dart
class _ClockState extends State<Clock> {
  int t = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => t++);
    });
  }

  @override
  Widget build(BuildContext context) => Text('$t');
}
```

### Problem 3: Spot the bug

What is wrong with this `initState`?

```dart
@override
void initState() {
  count = 0;
}
```

### Problem 4: Build a seconds counter

Build a `StatefulWidget` called `Stopwatch2` that shows a number starting at 0 and going up by 1 every second. Start the timer in `initState`, cancel it in `dispose`, and show the number in `build`. (Remember `import 'dart:async';` for `Timer`.)

---

## Assignment Answers

### Problem 1: Order the methods

```
initState   ->   build   ->   dispose
```

`initState` sets up, `build` draws (and runs again on every `setState`), and `dispose` cleans up when the widget is removed.

### Problem 2: Spot the bug

The timer is started but **never cancelled**, and it is not even stored in a variable, so there is no way to stop it. After the widget is removed, the timer keeps ticking and calling `setState` on a widget that is gone. Fix: store the timer and cancel it in `dispose`.

```dart
class _ClockState extends State<Clock> {
  int t = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => t++);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text('$t');
}
```

### Problem 3: Spot the bug

It is missing `super.initState()`. Every `initState` must call `super.initState()` first.

```dart
@override
void initState() {
  super.initState();   // added
  count = 0;
}
```

### Problem 4: Build a seconds counter

```dart
import 'dart:async';
import 'package:flutter/material.dart';

class Stopwatch2 extends StatefulWidget {
  const Stopwatch2({super.key});

  @override
  State<Stopwatch2> createState() => _Stopwatch2State();
}

class _Stopwatch2State extends State<Stopwatch2> {
  int seconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds = seconds + 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Seconds: $seconds');
  }
}
```

The timer starts in `initState`, ticks every second (calling `setState` so the number updates), and is cancelled in `dispose` so it stops cleanly when the widget goes away. This start-in-init, stop-in-dispose pattern is one you will use again and again.

---

**Next:** `04c-StatefulExamples.md`, where you build real interactive widgets using everything you have learned.
