# Stack and Positioned: Putting Widgets On Top Of Each Other

## The Big Idea In One Sentence

> A `Stack` lets widgets **overlap** (layered on top of one another), and `Positioned` places a child at an exact spot, like a corner.

Rows and Columns put things side by side. A Stack puts things **on top** of each other.

---

## For A 5-Year-Old

Think of stacking sheets of clear plastic, each with a drawing. You see all of them at once, stacked up. The last one you put down is on top. That is a Stack.

---

## Stack: Layers

A `Stack` shows its children on top of each other. The **first** child is at the back, the **last** child is at the front.

```dart
Stack(
  children: [
    Container(width: 200, height: 200, color: Colors.blue),   // back
    Container(width: 120, height: 120, color: Colors.red),    // middle
    Container(width: 60, height: 60, color: Colors.green),    // front
  ],
)
```

You see a big blue square, a red square on top of it, and a small green square on top of that. Order matters: last in the list is on top.

By default the children pile up at the **top-left**. You can change where they pile with `alignment`:

```dart
Stack(
  alignment: Alignment.center,   // pile them in the middle instead
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Container(width: 60, height: 60, color: Colors.green),
  ],
)
```

---

## Positioned: Place A Child Exactly

Inside a `Stack`, wrap a child in `Positioned` to pin it to specific edges. You give distances from `top`, `bottom`, `left`, or `right`.

```dart
Stack(
  children: [
    Container(width: 200, height: 200, color: Colors.blue),
    Positioned(
      top: 10,
      right: 10,
      child: Container(width: 40, height: 40, color: Colors.red),
    ),
  ],
)
```

The red box sits 10 pixels from the top and 10 from the right: the top-right corner. `Positioned` only works inside a `Stack`.

### A Real Use: A Notification Badge

The classic Stack + Positioned example is a little badge on a corner of an icon:

```dart
Stack(
  children: [
    const Icon(Icons.notifications, size: 40),
    Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    ),
  ],
)
```

A bell icon with a small red "3" badge in the corner. Every chat and email app uses this.

---

## Align: Position One Child

`Align` places a single child at a spot, using an `Alignment`. It is handy inside a `Stack` or any box.

```dart
Container(
  width: 200,
  height: 200,
  color: Colors.grey.shade300,
  child: const Align(
    alignment: Alignment.bottomRight,
    child: Text('corner'),
  ),
)
```

The common alignments read just like they sound:

```
Alignment.topLeft      Alignment.topCenter      Alignment.topRight
Alignment.centerLeft   Alignment.center         Alignment.centerRight
Alignment.bottomLeft   Alignment.bottomCenter   Alignment.bottomRight
```

(`Center`, from lesson 02c, is just `Align` with `Alignment.center`.)

---

## Text Over A Box

Stacks are great for putting text over an image or a coloured banner:

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(width: 250, height: 120, color: Colors.blue),
    const Text(
      'On top!',
      style: TextStyle(color: Colors.white, fontSize: 24),
    ),
  ],
)
```

The blue box is the background, and the white text floats centered on top of it.

---

## The Top Mistakes Beginners Make

### Mistake 1: Positioned outside a Stack

```dart
Column(
  children: [Positioned(top: 0, child: Text('x'))],  // BAD: Positioned needs a Stack
)
```

`Positioned` only works as a direct child of a `Stack`.

### Mistake 2: Forgetting that order is back-to-front

The first child is the bottom layer, the last is on top. If something is hidden, it is probably behind a later child.

### Mistake 3: A Stack with no size

If a Stack has no sized children and no constraints, it may collapse. Give it at least one child with a size (like a sized Container) to define its area.

---

## One-Minute Recap

- `Stack` layers children on top of each other; the last child is on top.
- `Stack`'s `alignment` sets where un-positioned children pile (default top-left).
- `Positioned` (inside a Stack) pins a child using `top`, `bottom`, `left`, `right`. Great for corner badges.
- `Align` places a single child at an `Alignment` like `bottomRight`.
- Use a Stack to put text or a badge over a box or image.

---

## Quick Quiz

**Q1.** In a Stack, which child is on top?

<details>
<summary>Answer</summary>
The last child in the list. The first child is at the back.
</details>

**Q2.** What does `Positioned(top: 0, right: 0, ...)` do?

<details>
<summary>Answer</summary>
It pins the child to the top-right corner of the Stack (0 from the top, 0 from the right).
</details>

**Q3.** Where can you use `Positioned`?

<details>
<summary>Answer</summary>
Only directly inside a `Stack`.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev), wrapping widgets in `Scaffold(body: Center(child: ...))`.

### Problem 1: Which is on top?

In this Stack, what colour square is on top, and what colour is at the back?

```dart
Stack(
  children: [
    Container(width: 150, height: 150, color: Colors.green),
    Container(width: 100, height: 100, color: Colors.orange),
  ],
)
```

### Problem 2: Corner box

Build a `Stack` with a 200x200 grey box, and a 40x40 red box pinned to the top-right corner using `Positioned`.

### Problem 3: Notification badge

Build a bell icon (`Icons.notifications`, size 40) with a small red circle badge showing `'5'` pinned to its top-right corner.

### Problem 4: Text over a banner

Build a `Stack` with a 250x120 blue `Container` and the centered white text `'Sale!'` on top of it.

### Problem 5: Spot the bug

Why does this fail, and how do you fix it?

```dart
Column(
  children: [
    Positioned(top: 10, child: Text('hi')),
  ],
)
```

---

## Assignment Answers

### Problem 1: Which is on top?

Orange is on top (it is the last child). Green is at the back (the first child). You see the orange square sitting on top of the green one, both at the top-left.

### Problem 2: Corner box

```dart
Stack(
  children: [
    Container(width: 200, height: 200, color: Colors.grey),
    Positioned(
      top: 0,
      right: 0,
      child: Container(width: 40, height: 40, color: Colors.red),
    ),
  ],
)
```

The grey box defines the area, and `Positioned(top: 0, right: 0)` pins the red box to the top-right corner.

### Problem 3: Notification badge

```dart
Stack(
  children: [
    const Icon(Icons.notifications, size: 40),
    Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: const Text('5', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    ),
  ],
)
```

The bell is the back layer; the small red circle with `'5'` is pinned to the corner on top of it.

### Problem 4: Text over a banner

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(width: 250, height: 120, color: Colors.blue),
    const Text('Sale!', style: TextStyle(color: Colors.white, fontSize: 24)),
  ],
)
```

`alignment: Alignment.center` centers the text over the blue banner. The text is last, so it sits on top.

### Problem 5: Spot the bug

`Positioned` only works inside a `Stack`, but here it is inside a `Column`. Fix it by using a `Stack`, or, since a Column does not overlap things, just use the widget directly:

```dart
// If you want overlap:
Stack(
  children: [
    Container(width: 100, height: 100, color: Colors.blue),
    Positioned(top: 10, child: const Text('hi')),
  ],
)

// If you just want it in a column, drop Positioned:
Column(
  children: const [Text('hi')],
)
```

---

**Next:** `06a-ButtonWidgets.md`, where you learn all the kinds of buttons and how to handle taps.
