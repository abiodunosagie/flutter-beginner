# Layout Basics: Arranging Your Widgets

## The Big Idea In One Sentence

> Layout widgets decide **where** things go: **Row** lines them up sideways, **Column** stacks them down, **Center** centers, **Padding** adds space, and **Scaffold** is the page itself.

You know the display widgets now. These are the widgets that arrange them.

---

## Think Of Organizing A Room

```
Row      = line toys up left to right  →
Column   = stack toys top to bottom    ↓
Center   = put one toy in the middle
Padding  = give a toy some breathing room
Scaffold = the room itself (with walls and a top shelf)
```

---

## Row: Line Things Up Sideways

`Row` places its `children` in a horizontal line.

```dart
Row(
  children: [
    Icon(Icons.star),
    Icon(Icons.star),
    Icon(Icons.star),
  ],
)
```

Result: three stars in a line.

### Spacing A Row With mainAxisAlignment

`mainAxisAlignment` controls how the children are spread out **along the row** (left to right):

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.person),
  ],
)
```

The common options:

```
start          [A][B][C]            (default, packed at the left)
center             [A][B][C]
end                     [A][B][C]
spaceBetween   [A]      [B]      [C]   (ends pushed out, gaps even)
spaceEvenly      [A]    [B]    [C]     (equal gaps everywhere)
spaceAround       [A]   [B]   [C]      (half-gaps at the ends)
```

### Aligning A Row With crossAxisAlignment

`crossAxisAlignment` controls the **other** direction (up/down for a Row): top, center, or bottom.

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.center,   // also: start (top), end (bottom)
  children: [...],
)
```

---

## Column: Stack Things Down

`Column` is exactly like Row, but vertical. It places its `children` top to bottom.

```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

It uses the **same** two properties:

- `mainAxisAlignment` now controls **up/down** spacing (because the main direction is vertical).
- `crossAxisAlignment` now controls **left/right** alignment.

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,   // line children up on the left
  children: [
    Text('Left aligned'),
    Text('Also left'),
  ],
)
```

---

## Main Axis vs Cross Axis (The Key Idea)

This confuses everyone at first, so here is the rule:

- The **main axis** is the direction the widget lays things out.
- The **cross axis** is the other direction (at a right angle).

| Widget | Main axis | Cross axis |
|--------|-----------|------------|
| `Row` | left to right (horizontal) | up and down (vertical) |
| `Column` | top to bottom (vertical) | left and right (horizontal) |

So `mainAxisAlignment` in a Row spreads things sideways, but in a Column it spreads things up and down. Same property name, different direction, because the main axis is different.

---

## Center: Put One Thing In The Middle

`Center` takes one `child` and puts it in the middle of the space it is given.

```dart
Center(
  child: Text('I am centered'),
)
```

To center several things, put a `Column` or `Row` inside the `Center`.

---

## Padding: Add Space Around A Widget

`Padding` adds space around its `child`.

```dart
Padding(
  padding: EdgeInsets.all(16),   // 16 pixels on all four sides
  child: Text('Roomy text'),
)
```

The `EdgeInsets` ways to describe space:

```dart
EdgeInsets.all(16)                              // same on all sides
EdgeInsets.symmetric(horizontal: 20, vertical: 8) // sides vs top/bottom
EdgeInsets.only(left: 10, top: 4)               // pick specific sides
```

(You met `padding` on `Container` in the last lesson. The `Padding` widget does the same job when you only need spacing, without a whole box.)

---

## Scaffold: The Page Itself

`Scaffold` gives you the standard page shape: a top bar and a main area. Almost every screen starts with one.

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('My App'),
  ),
  body: const Center(
    child: Text('Content goes here'),
  ),
)
```

The two slots you will use constantly:

- `appBar`: the bar across the top, usually with a title.
- `body`: the main content of the screen.

A third handy slot is the **floating action button**, the round button that floats over the bottom-right:

```dart
Scaffold(
  appBar: AppBar(title: const Text('My App')),
  body: const Center(child: Text('Hello')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
)
```

```
┌────────────────────────────┐
│ AppBar (title)             │
├────────────────────────────┤
│                            │
│        body (content)      │
│                       [+]  │  <- floatingActionButton
└────────────────────────────┘
```

> Scaffold has more slots (a side drawer, a bottom navigation bar), but those belong to navigation, which is Level 7. For now, `appBar` and `body` are all you need.

---

## Putting It Together

### A row with an icon and a label

```dart
Row(
  children: const [
    Icon(Icons.person, size: 30),
    SizedBox(width: 8),
    Text('Ada Bello'),
  ],
)
```

### An icon stacked above a label

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: const [
    Icon(Icons.favorite, color: Colors.red, size: 40),
    SizedBox(height: 4),
    Text('Favourite'),
  ],
)
```

### A bottom action bar (three labelled icons, spread evenly)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: const [
    Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.thumb_up), Text('Like')]),
    Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.comment), Text('Comment')]),
    Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.share), Text('Share')]),
  ],
)
```

Notice how Rows and Columns nest: a Row of Columns makes a neat action bar. This nesting is how every real screen is built.

---

## The Top Mistakes Beginners Make

### Mistake 1: Mixing up the two axis properties

In a Row, `mainAxisAlignment` spreads things **sideways**. In a Column, the same property spreads things **up and down**. Picture the main axis first.

### Mistake 2: Expecting `crossAxisAlignment.center` to do nothing

It is the default, so leaving it out usually centers on the cross axis. To line a Column's children on the left, you must set `crossAxisAlignment: CrossAxisAlignment.start`.

### Mistake 3: Giving Row or Column a `child`

`Row` and `Column` take `children` (a list), never `child`.

### Mistake 4: Forgetting the Scaffold

If your text appears stuck in the top-left corner with odd styling, you probably forgot to wrap your screen in a `Scaffold` (inside a `MaterialApp`).

---

## One-Minute Recap

- `Row` lays children out sideways; `Column` stacks them down. Both use `children`.
- `mainAxisAlignment` spreads children along the main axis; `crossAxisAlignment` aligns them across it.
- Main axis: horizontal for Row, vertical for Column. Cross axis is the other one.
- `Center` centers one `child`. `Padding` adds space around one `child`.
- `Scaffold` is the page: `appBar` on top, `body` for content, plus a `floatingActionButton`.

---

## Quick Quiz

**Q1.** What is the difference between Row and Column?

<details>
<summary>Answer</summary>
`Row` lays widgets out left to right (horizontal). `Column` stacks them top to bottom (vertical). They share the same alignment properties.
</details>

**Q2.** In a Column, which direction does `mainAxisAlignment` control?

<details>
<summary>Answer</summary>
Up and down (vertical), because a Column's main axis is vertical.
</details>

**Q3.** How do you line a Column's children up on the left?

<details>
<summary>Answer</summary>
Set `crossAxisAlignment: CrossAxisAlignment.start`.
</details>

**Q4.** What are the two main slots of a Scaffold?

<details>
<summary>Answer</summary>
`appBar` (the top bar) and `body` (the main content).
</details>

---

## Assignment

Paste full apps into [dartpad.dev](https://dartpad.dev). A handy shell to test a widget:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: Scaffold(
  appBar: AppBar(title: const Text('Practice')),
  body: Center(child: YOUR_WIDGET_HERE),
)));
```

### Problem 1: A spaced row

Build a `Row` of three icons (`Icons.home`, `Icons.search`, `Icons.person`) spread out with `spaceBetween`.

### Problem 2: A left-aligned column

Build a `Column` with three `Text` widgets (`'Name'`, `'Age'`, `'City'`) all lined up on the left.

### Problem 3: Icon above a label

Build a `Column` that shows a red heart icon, a small gap, and the text `'Liked'` underneath it.

### Problem 4: A simple screen

Build a full `Scaffold` with an `AppBar` titled `'Profile'` and a `body` that centers the text `'Welcome!'`.

### Problem 5: Spot the bug

```dart
Column(
  child: Text('Only one'),
)
```

---

## Assignment Answers

### Problem 1: A spaced row

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: const [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.person),
  ],
)
```

`spaceBetween` pushes the first and last icons to the edges and puts equal gaps between them.

### Problem 2: A left-aligned column

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    Text('Name'),
    Text('Age'),
    Text('City'),
  ],
)
```

By default a Column centers its children across the cross axis. Setting `crossAxisAlignment: CrossAxisAlignment.start` lines them up on the left.

### Problem 3: Icon above a label

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: const [
    Icon(Icons.favorite, color: Colors.red, size: 40),
    SizedBox(height: 4),
    Text('Liked'),
  ],
)
```

A Column stacks the icon and the text. The `SizedBox(height: 4)` is the small gap between them. (`mainAxisSize: MainAxisSize.min` keeps the Column only as tall as its contents.)

### Problem 4: A simple screen

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Welcome!'),
      ),
    ),
  ));
}
```

`Scaffold` gives the page shape, `AppBar` is the top bar with the title, and `body` holds a `Center` with the welcome text.

### Problem 5: Spot the bug

`Column` takes `children` (a list), not `child`. Fixed:

```dart
Column(
  children: const [
    Text('Only one'),
  ],
)
```

Even with a single item, a Column needs a list in `children`. (If you truly have only one widget and do not need a Column, you could just use the widget on its own.)

---

**Next:** `03a-StatelessIntro.md`, where you start building your own widgets properly.
