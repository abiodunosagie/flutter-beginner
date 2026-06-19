# How Layout Works: Constraints And Sizing

## The Big Idea In One Sentence

> A parent widget tells its child the space it is allowed (the **constraints**), the child picks its **size** within that, and the parent then places it.

This is the secret to understanding why widgets end up the size they do.

---

## For A 5-Year-Old

Imagine a parent with a toy box says:

- "Put your toy inside this box."
- "It cannot be bigger than the box."
- "But it can be smaller if it wants."

That is Flutter layout. The parent widget gives the rules, the child chooses its size within them, and the parent places it.

---

## Constraints Go Down, Sizes Go Up

Remember this one sentence and Flutter layout stops being mysterious:

> **Constraints go down. Sizes go up. The parent sets the position.**

1. **Constraints go down:** a parent gives each child a rule like "you can be up to 300 pixels wide."
2. **Sizes go up:** the child picks a size that obeys the rule and reports "I am 150 wide."
3. **Position is set by the parent:** the parent decides where to put the child.

```
Parent: "You may be up to 300 wide."   (constraint goes DOWN)
Child:  "OK, I will be 150 wide."       (size goes UP)
Parent: "I will place you here."        (parent positions)
```

This conversation repeats all the way down the widget tree.

---

## Tight vs Loose Constraints

There are two kinds of rules a parent can give.

### Tight: "You MUST be exactly this size"

The child has no choice. `SizedBox(width: 100, height: 100)` forces its child to be exactly 100 by 100.

```dart
SizedBox(
  width: 100,
  height: 100,
  child: Container(color: Colors.blue),  // forced to be 100 x 100
)
```

### Loose: "You can be any size up to this"

The child may be smaller. `Center` gives a loose rule: "be as big as you need, up to my space," then centers the child.

```dart
Center(
  child: Text('small'),   // only as big as the text, then centered
)
```

With a tight rule, the child is stretched to fit. With a loose rule, the child shrinks to its content.

---

## A Common Surprise: "Why Is My Column So Tall?"

A `Column` (and a `Row`) takes up **all** the space it is allowed on its main axis by default. So a Column in the middle of the screen grabs the whole height, even with only two small texts.

This is controlled by `mainAxisSize`:

```dart
// Default: max -> the Column takes ALL the available height
Column(
  children: const [Text('A'), Text('B')],
)

// min -> the Column takes ONLY as much height as its children need
Column(
  mainAxisSize: MainAxisSize.min,
  children: const [Text('A'), Text('B')],
)
```

- `MainAxisSize.max` (the default): take all the space on the main axis.
- `MainAxisSize.min`: take only as much as the children need.

If a Column is grabbing the whole screen, set `mainAxisSize: MainAxisSize.min`. This is why you have seen that line in many earlier examples.

---

## A Quick Recap Of Alignment

You learned these in `02c-LayoutBasics.md`, and they fit right here:

- `mainAxisAlignment` spreads children along the main axis (for a Column, up and down).
- `crossAxisAlignment` aligns them across the other axis (for a Column, left and right).

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [Text('A'), Text('B')],
)
```

The new idea in this lesson is the **constraints** behind all of it: a Column can only spread its children within the height its parent allowed.

---

## Why This Matters

When a widget is too big, too small, or in the wrong place, the cause is almost always constraints:

- A `Column` taking the whole screen? Its `mainAxisSize` is `max` (the default).
- A box not the size you expected? Check whether its parent gave a tight or a loose rule.

"Constraints down, sizes up" turns confusing layouts into something you can reason about.

---

## The Top Mistakes Beginners Make

### Mistake 1: Expecting a Column to shrink to its content

By default it does not; it takes all the height. Use `mainAxisSize: MainAxisSize.min`.

### Mistake 2: Thinking a child can be any size it likes

A child must obey the parent's constraints. If the parent says "exactly 100 wide," the child is 100 wide.

### Mistake 3: Confusing size with position

Choosing a size and being placed are two separate steps. The child chooses its size; the parent chooses where it goes.

---

## One-Minute Recap

- Layout rule: **constraints go down, sizes go up, the parent sets the position.**
- **Tight** constraints force an exact size; **loose** constraints allow up to a maximum.
- `Row`/`Column` take all their main-axis space by default (`MainAxisSize.max`). Use `MainAxisSize.min` to shrink to the children.
- `mainAxisAlignment` and `crossAxisAlignment` (from 02c) position children within that space.

---

## Quick Quiz

**Q1.** What does "constraints go down, sizes go up" mean?

<details>
<summary>Answer</summary>
The parent passes down a rule for how big the child may be. The child picks a size that obeys the rule and passes it back up. The parent then positions the child.
</details>

**Q2.** What is the difference between tight and loose constraints?

<details>
<summary>Answer</summary>
Tight means the child must be an exact size. Loose means the child may be any size up to a maximum.
</details>

**Q3.** Why does a Column often take the whole screen height?

<details>
<summary>Answer</summary>
Because `mainAxisSize` defaults to `max`. Set `mainAxisSize: MainAxisSize.min` to shrink it to its children.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev). Wrap widgets in `Scaffold(body: ...)` to see them.

### Problem 1: Predict the size

Which column takes the whole screen height, and which is only as tall as its two texts?

```dart
// A
Column(children: const [Text('one'), Text('two')])

// B
Column(mainAxisSize: MainAxisSize.min, children: const [Text('one'), Text('two')])
```

### Problem 2: Tight or loose?

For each, say whether the child gets a tight or a loose constraint:

1. `SizedBox(width: 50, height: 50, child: ...)`
2. `Center(child: ...)`

### Problem 3: Fix the tall column

This Column grabs the whole screen height. Make it only as tall as its children.

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Text('Title'),
    Text('Subtitle'),
  ],
)
```

### Problem 4: Force an exact size

Make a `Container` that is forced to be exactly 120 wide and 60 tall and is coloured green.

---

## Assignment Answers

### Problem 1: Predict the size

- **A** takes the whole screen height. With no `mainAxisSize`, a Column defaults to `MainAxisSize.max`.
- **B** is only as tall as the two texts, because `mainAxisSize: MainAxisSize.min` shrinks it to its children.

### Problem 2: Tight or loose?

1. `SizedBox(width: 50, height: 50, ...)` gives a **tight** constraint: the child must be exactly 50 by 50.
2. `Center(child: ...)` gives a **loose** constraint: the child may be any size up to the available space, then Center places it in the middle.

### Problem 3: Fix the tall column

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Text('Title'),
    Text('Subtitle'),
  ],
)
```

Adding `mainAxisSize: MainAxisSize.min` makes the Column shrink to just its two texts.

### Problem 4: Force an exact size

```dart
Container(
  width: 120,
  height: 60,
  color: Colors.green,
)
```

Giving the Container a `width` and `height` makes it exactly that size. (Behind the scenes, the Container passes a tight constraint to anything inside it.)

---

**Next:** `05b-FlexibleExpanded.md`, where you make widgets share space using Expanded and Flexible.
