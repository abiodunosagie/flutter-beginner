# Basic Display Widgets: Showing Content

## The Big Idea In One Sentence

> These are the everyday widgets that put things on the screen: **Text** for words, **Icon** for symbols, **Image** for pictures, **Container** for boxes, and **SizedBox** for spacing.

These five are the LEGO bricks you will use in almost every screen.

---

## Think Of A Toybox

Each widget is a different kind of toy:

```
Text       = letters (shows words)
Icon       = stickers (shows symbols)
Image      = photos (shows pictures)
Container  = a box (holds and styles one thing)
SizedBox   = a spacer (makes exact gaps)
```

Let us meet each one.

---

## Text: Showing Words

The simplest widget. Put your words in quotes:

```dart
Text('Hello, Flutter!')
```

### Making Text Look Nice

To style text, add a `style` with a `TextStyle`:

```dart
Text(
  'Big and blue',
  style: TextStyle(
    fontSize: 24,                  // how big
    fontWeight: FontWeight.bold,   // thickness
    color: Colors.blue,            // colour
  ),
)
```

### Lining Text Up

```dart
Text(
  'Centered',
  textAlign: TextAlign.center,   // also: left, right
)
```

### Long Text That Does Not Fit

```dart
Text(
  'This is a very long sentence that might not fit on one line',
  maxLines: 1,
  overflow: TextOverflow.ellipsis,   // shows ... at the end
)
```

`TextOverflow.ellipsis` adds `...` when the text is cut off, which looks much nicer than text spilling off the edge.

---

## Icon: Showing Symbols

Flutter comes with thousands of ready-made symbols. Use the `Icon` widget with one of the `Icons.` names:

```dart
Icon(Icons.favorite)   // a heart
```

### Styling An Icon

```dart
Icon(
  Icons.star,
  size: 48,              // how big
  color: Colors.amber,   // colour
)
```

### Some Common Icons

```dart
Icons.home       Icons.favorite   Icons.star
Icons.settings   Icons.person     Icons.search
Icons.add        Icons.delete     Icons.check
Icons.arrow_back Icons.menu       Icons.close
```

There are thousands more. In a real editor, type `Icons.` and a list pops up.

---

## Image: Showing Pictures

There are two main ways to show a picture.

### From The Internet

The easiest for now, no setup needed:

```dart
Image.network('https://picsum.photos/200')
```

### From Your App's Files (Assets)

First you list the image in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/logo.png
```

Then show it:

```dart
Image.asset('assets/images/logo.png')
```

### Sizing And Fitting

```dart
Image.network(
  'https://picsum.photos/200',
  width: 150,
  height: 150,
  fit: BoxFit.cover,   // how the picture fills the box
)
```

`fit` decides how the picture fills its space. The two you will use most:

- `BoxFit.cover` fills the whole box, cropping the edges if needed.
- `BoxFit.contain` shows the whole picture, leaving empty space if needed.

### Round Pictures: CircleAvatar

For profile pictures, `CircleAvatar` makes a circle:

```dart
// A circle with initials
CircleAvatar(
  radius: 30,
  backgroundColor: Colors.blue,
  child: Text('AB', style: TextStyle(color: Colors.white)),
)

// A circle with a picture
CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage('https://picsum.photos/100'),
)
```

---

## Container: A Box You Can Style

`Container` is the handy box widget. It holds **one** child (it uses `child`) and can add size, colour, and spacing around it.

### A Simple Coloured Box

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(child: Text('In a box')),
)
```

### Padding And Margin

Two kinds of space, and beginners mix them up:

- **padding** is space **inside** the box, between the edge and the child.
- **margin** is space **outside** the box, between the box and other widgets.

```dart
Container(
  margin: EdgeInsets.all(20),    // space outside the box
  padding: EdgeInsets.all(16),   // space inside the box
  color: Colors.blue,
  child: Text('Padded text'),
)
```

```
        margin (outside the box)
   ┌───────────────────────────┐
   │  Container                 │
   │   padding (inside)         │
   │      [ the child ]         │
   └───────────────────────────┘
```

`EdgeInsets.all(16)` means 16 pixels on all four sides. You can also do `EdgeInsets.symmetric(horizontal: 20, vertical: 8)` for different amounts.

### Rounded Corners And A Border

For fancier boxes (rounded corners, borders), use a `decoration` instead of `color`. Important rule: when you use `decoration`, the colour goes **inside** the decoration, not on the Container directly.

```dart
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.blue,                       // colour goes here now
    borderRadius: BorderRadius.circular(12),  // rounded corners
    border: Border.all(color: Colors.black, width: 2),
  ),
  child: Center(child: Text('Rounded box')),
)
```

> You cannot set both `color:` and `decoration:` on the same Container. Pick one. Use plain `color` for a simple box, and `decoration` when you want rounded corners, a border, or a shadow.

---

## SizedBox: Exact Size And Spacing

`SizedBox` is mostly used to make **gaps** between widgets. This is one of the most common things you will write.

```dart
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),   // a 20-pixel gap
    Text('Second'),
  ],
)
```

In a `Column` (vertical), use `height` for the gap. In a `Row` (horizontal), use `width`:

```dart
Row(
  children: [
    Icon(Icons.star),
    SizedBox(width: 8),   // a sideways gap
    Text('4.5'),
  ],
)
```

A `SizedBox` with no child is just empty space. Simple and very useful.

---

## A Bigger Example: A Simple Card

Let us snap several of these together into a little profile card:

```dart
Container(
  width: 250,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey),
  ),
  child: Column(
    children: const [
      CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue,
        child: Text('AB', style: TextStyle(color: Colors.white)),
      ),
      SizedBox(height: 12),
      Text(
        'Ada Bello',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 4),
      Text('Flutter Learner', style: TextStyle(color: Colors.grey)),
    ],
  ),
)
```

Read the tree: a `Container` (the card) holds a `Column`, which stacks a `CircleAvatar`, a gap, a bold name, a small gap, and a grey subtitle. Every piece is one of the widgets from this lesson.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using both `color` and `decoration`

```dart
Container(color: Colors.blue, decoration: BoxDecoration(...))   // BAD
Container(decoration: BoxDecoration(color: Colors.blue, ...))   // GOOD
```

### Mistake 2: Mixing up padding and margin

Padding is space **inside** the box; margin is space **outside**. If the child feels cramped against the edge, add padding.

### Mistake 3: Wrong gap direction in SizedBox

In a Column use `height` for the gap; in a Row use `width`. Using `width` inside a Column does nothing visible.

### Mistake 4: Forgetting the `Icons.` prefix

```dart
Icon(favorite)         // BAD
Icon(Icons.favorite)   // GOOD
```

---

## One-Minute Recap

- `Text('...')` shows words; style it with `style: TextStyle(...)`.
- `Icon(Icons.name)` shows a symbol; set `size` and `color`.
- `Image.network(...)` and `Image.asset(...)` show pictures; `fit: BoxFit.cover` is the common fit. `CircleAvatar` makes round pictures.
- `Container` is a box that holds one `child`; it can set size, colour, padding (inside), and margin (outside). Use `decoration` for rounded corners and borders.
- `SizedBox(height: ...)` makes vertical gaps; `SizedBox(width: ...)` makes horizontal gaps.

---

## Quick Quiz

**Q1.** How do you make text bold and size 24?

<details>
<summary>Answer</summary>

```dart
Text('Hi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
```
</details>

**Q2.** What is the difference between padding and margin?

<details>
<summary>Answer</summary>
Padding is space inside the box (between the edge and the child). Margin is space outside the box (between the box and other widgets).
</details>

**Q3.** How do you put a 16-pixel gap between two texts in a Column?

<details>
<summary>Answer</summary>
Put a `SizedBox(height: 16)` between them.
</details>

**Q4.** What is wrong with `Container(color: Colors.blue, decoration: BoxDecoration(...))`?

<details>
<summary>Answer</summary>
You cannot use `color` and `decoration` together. Move the colour inside the decoration: `decoration: BoxDecoration(color: Colors.blue, ...)`.
</details>

---

## Assignment

Paste full apps into [dartpad.dev](https://dartpad.dev) (Flutter mode) to see these. Wrap your widget in `Scaffold(body: Center(child: ...))` to view it centered.

### Problem 1: Style some text

Make a `Text` that says `'Welcome'`, is size 28, bold, and green.

### Problem 2: A rating row

Build a `Row` that shows a yellow star icon, an 8-pixel gap, and the text `'4.5'`.

### Problem 3: A coloured box with padding

Make a `Container` that is blue, has 20 pixels of padding inside, and holds the text `'Hello'`.

### Problem 4: Rounded box

Make a `Container` 150 wide and 80 tall, with a `decoration` that gives it an amber colour and rounded corners (radius 16), holding centered text `'Rounded'`.

### Problem 5: Spot the bug

```dart
Container(
  color: Colors.blue,
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  child: Text('Box'),
)
```

---

## Assignment Answers

### Problem 1: Style some text

```dart
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  ),
)
```

All three looks (size, weight, colour) go inside one `TextStyle`.

### Problem 2: A rating row

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  children: const [
    Icon(Icons.star, color: Colors.amber),
    SizedBox(width: 8),
    Text('4.5'),
  ],
)
```

The `SizedBox(width: 8)` makes the sideways gap between the star and the number. (`mainAxisSize: MainAxisSize.min` just keeps the Row only as wide as its contents; you will learn more about Row sizing in the layout lessons.)

### Problem 3: A coloured box with padding

```dart
Container(
  color: Colors.blue,
  padding: const EdgeInsets.all(20),
  child: const Text('Hello'),
)
```

`padding: EdgeInsets.all(20)` adds 20 pixels of space inside the box on every side, so the text is not jammed against the edge.

### Problem 4: Rounded box

```dart
Container(
  width: 150,
  height: 80,
  decoration: BoxDecoration(
    color: Colors.amber,
    borderRadius: BorderRadius.circular(16),
  ),
  child: const Center(child: Text('Rounded')),
)
```

Because we want rounded corners, the colour moves into the `decoration`. `Center` puts the text in the middle of the box.

### Problem 5: Spot the bug

The Container sets both `color` and `decoration`, which is not allowed. Move the colour into the decoration:

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Text('Box'),
)
```

When you use `decoration`, the Container's own `color` must go away, and the colour lives inside the `BoxDecoration` instead.

---

**Next:** `02c-LayoutBasics.md`, where you arrange widgets with Row, Column, Center, Padding, and Scaffold.
