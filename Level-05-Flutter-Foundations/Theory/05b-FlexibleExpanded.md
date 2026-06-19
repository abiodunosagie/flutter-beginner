# Expanded and Flexible: Sharing Space In A Row Or Column

## The Big Idea In One Sentence

> `Expanded` makes a child **stretch to fill** the leftover space in a Row or Column, and `flex` lets several children **share** that space in chosen amounts.

This is how you make widgets fill the screen nicely instead of clumping at one end.

---

## For A 5-Year-Old

Imagine a bench with three kids. If everyone sits normally, there is empty space at the end. But if you say "everyone spread out to fill the bench," they share the whole bench evenly.

`Expanded` is saying "spread out and fill the space."

---

## Expanded: Fill The Leftover Space

Put `Expanded` around a child inside a `Row` or `Column`, and it grows to take all the remaining room.

```dart
Row(
  children: [
    Expanded(
      child: Container(height: 50, color: Colors.blue),
    ),
  ],
)
```

That blue container now stretches across the whole width of the row. Without `Expanded`, a `Container` with no width would shrink to nothing.

---

## Sharing Space With flex

When several children are `Expanded`, they share the leftover space. By default each has `flex: 1`, so they split it **equally**.

```dart
Row(
  children: [
    Expanded(child: Container(height: 50, color: Colors.red)),
    Expanded(child: Container(height: 50, color: Colors.green)),
    Expanded(child: Container(height: 50, color: Colors.blue)),
  ],
)
```

Three equal stripes, each one-third of the width.

You can change the shares with `flex`. A child with `flex: 2` gets twice as much as one with `flex: 1`.

```dart
Row(
  children: [
    Expanded(flex: 2, child: Container(height: 50, color: Colors.red)),   // 2 shares
    Expanded(flex: 1, child: Container(height: 50, color: Colors.blue)),  // 1 share
  ],
)
```

Total shares = 2 + 1 = 3. The red one gets two-thirds, the blue one gets one-third.

---

## Mixing Fixed Sizes And Expanded

A very common layout: some fixed-size widgets, and one `Expanded` that soaks up the rest.

```dart
Row(
  children: [
    const Icon(Icons.menu),                 // fixed size
    Expanded(                                // takes all the middle space
      child: Container(height: 40, color: Colors.amber),
    ),
    const Icon(Icons.search),               // fixed size
  ],
)
```

The two icons take only the space they need, and the amber bar in the middle stretches to fill everything left over. This is exactly how app toolbars are built.

---

## Flexible vs Expanded

These are close cousins:

- **`Expanded`** says: "Take my full share of the space, **even if I do not need it all**." It always fills its share.
- **`Flexible`** says: "I **may** use up to my share, but only as much as I actually need." It can be smaller.

```dart
Row(
  children: [
    Expanded(child: Container(color: Colors.red, child: const Text('Expanded'))),
    Flexible(child: Container(color: Colors.blue, child: const Text('Flexible'))),
  ],
)
```

The red `Expanded` fills its half completely. The blue `Flexible` is only as wide as its text needs.

Rule of thumb: use `Expanded` to fill space (a content area, a stretchy bar). Use `Flexible` when you just want to stop a widget from overflowing but do not need it to fill.

> Container sizing (no child fills the parent, a child makes it wrap) and padding vs margin were covered in `02b-BasicWidgets.md`. This lesson is just about sharing space with Expanded and Flexible.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using Expanded outside a Row or Column

```dart
Center(
  child: Expanded(child: Text('hi')),   // BAD: Expanded only works in Row/Column
)
```

`Expanded` and `Flexible` only make sense as direct children of a `Row` or `Column`. Using them elsewhere is an error.

### Mistake 2: Expecting an un-Expanded child to fill space

```dart
Row(children: [Container(color: Colors.blue)])   // shrinks to nothing
Row(children: [Expanded(child: Container(color: Colors.blue))])  // fills the row
```

### Mistake 3: Confusing flex numbers with pixels

`flex: 2` does not mean 2 pixels. It means 2 shares of the leftover space, relative to the other flex values.

---

## One-Minute Recap

- `Expanded` makes a child stretch to fill the leftover space in a Row or Column.
- Several `Expanded` children share the space; `flex` sets the ratio (default 1 each).
- Mix fixed widgets with one `Expanded` to make the rest stretch (like a toolbar).
- `Flexible` may take up to its share but can be smaller; `Expanded` always fills its share.
- `Expanded`/`Flexible` only work directly inside a `Row` or `Column`.

---

## Quick Quiz

**Q1.** What does `Expanded` do?

<details>
<summary>Answer</summary>
It makes its child stretch to fill the remaining space in a Row or Column.
</details>

**Q2.** In a Row with `Expanded(flex: 3, ...)` and `Expanded(flex: 1, ...)`, how is the space shared?

<details>
<summary>Answer</summary>
Total shares = 4. The first takes three-quarters, the second takes one-quarter.
</details>

**Q3.** What is the difference between `Expanded` and `Flexible`?

<details>
<summary>Answer</summary>
`Expanded` always fills its full share. `Flexible` may take up to its share but can be smaller if it does not need it all.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev), wrapping rows in `Scaffold(body: ...)`.

### Problem 1: Two equal stripes

Build a `Row` with two `Expanded` children, each a `Container` of height 50, one red and one blue. They should each fill half the width.

### Problem 2: Two-to-one split

Build a `Row` with two `Expanded` children where the first (green) takes twice as much width as the second (orange). Use `flex`.

### Problem 3: Toolbar layout

Build a `Row` with a menu icon, then an `Expanded` amber container of height 40, then a search icon. The amber bar should fill the middle.

### Problem 4: Spot the bug

Why does this not work, and how do you fix it?

```dart
Center(
  child: Expanded(
    child: Container(color: Colors.blue),
  ),
)
```

---

## Assignment Answers

### Problem 1: Two equal stripes

```dart
Row(
  children: [
    Expanded(child: Container(height: 50, color: Colors.red)),
    Expanded(child: Container(height: 50, color: Colors.blue)),
  ],
)
```

Both are `Expanded` with the default `flex: 1`, so they split the width equally.

### Problem 2: Two-to-one split

```dart
Row(
  children: [
    Expanded(flex: 2, child: Container(height: 50, color: Colors.green)),
    Expanded(flex: 1, child: Container(height: 50, color: Colors.orange)),
  ],
)
```

Total shares = 3. Green gets two-thirds, orange gets one-third.

### Problem 3: Toolbar layout

```dart
Row(
  children: [
    const Icon(Icons.menu),
    Expanded(child: Container(height: 40, color: Colors.amber)),
    const Icon(Icons.search),
  ],
)
```

The two icons take only the space they need; the `Expanded` amber bar fills everything in between.

### Problem 4: Spot the bug

`Expanded` only works as a direct child of a `Row` or `Column`, but here it is inside a `Center`. That is an error. To fill space inside a `Center`, give the Container a size or use the whole space differently. If you wanted a stretchy child, put the `Expanded` inside a `Row` or `Column`:

```dart
Column(
  children: [
    Expanded(child: Container(color: Colors.blue)),
  ],
)
```

Now the Container fills the column's leftover height.

---

**Next:** `05c-StackPositioned.md`, where you place widgets on top of each other with Stack and Positioned.
