# Understanding Widgets: Everything Is A Widget

## The Big Idea In One Sentence

> A widget is a small description of a piece of the screen, and you build an app by snapping widgets together like LEGO.

In the last lesson you saw your first app. Now you learn what those widgets actually are.

---

## Think Like Building With LEGO

Imagine a box of LEGO blocks. Each block is like a **widget**.

```
small block   = small widget (like Text)
big block     = big widget (like Container)
many blocks together = a whole screen!
```

Just like LEGO, you snap widgets together to build something. A small widget goes inside a bigger one, which goes inside an even bigger one.

---

## What Is A Widget?

A **widget** is anything on the screen (and sometimes things you cannot even see, like spacing).

```dart
Text('Hello')             // shows words
Icon(Icons.star)          // shows a star
Image.network('...')      // shows a picture
ElevatedButton(...)       // a button you can tap
```

Some widgets you see. Some just arrange other widgets:

```dart
Row(...)       // line widgets up left to right
Column(...)    // stack widgets top to bottom
Center(...)    // put a widget in the middle
```

And some are invisible but useful:

```dart
SizedBox(height: 20)   // empty space, like air between LEGO blocks
Padding(...)           // space around a widget
```

Even the whole app (`MaterialApp`) is a widget. **Everything is a widget.**

---

## The Widget Tree

Widgets live **inside** other widgets, which makes a shape called the **widget tree**. Think of it like a family tree: a parent widget holds its children.

```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text('My App'),
    ),
    body: Center(
      child: Column(
        children: [
          Text('Hello'),
          Icon(Icons.star),
          Text('World'),
        ],
      ),
    ),
  ),
)
```

Drawn as a tree, that is:

```
MaterialApp
 └─ Scaffold
     ├─ AppBar
     │   └─ Text('My App')
     └─ Center
         └─ Column
             ├─ Text('Hello')
             ├─ Icon(star)
             └─ Text('World')
```

Reading the tree tells you exactly what is inside what. This is the single most useful skill for understanding Flutter code: look at a chunk of widgets and picture the tree.

---

## child vs children

This is the one rule that trips up every beginner, so learn it well.

Some widgets hold **one** thing. They use `child` (singular):

```dart
Center(
  child: Text('I am alone'),
)

Padding(
  padding: EdgeInsets.all(10),
  child: Text('Padded'),
)
```

Other widgets hold **many** things. They use `children` (plural), with a list in square brackets `[ ]`:

```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)

Row(
  children: [
    Icon(Icons.star),
    Icon(Icons.star),
  ],
)
```

Remember:

- `child` = **one** widget (singular, no brackets).
- `children` = **many** widgets (plural, a list with `[ ]`).

`Center`, `Padding`, and `Container` take a single `child`. `Row` and `Column` take `children`.

---

## The Three Parts Of A Widget You Build

When you make your own widget, it is a class that `extends StatelessWidget` (remember `extends` from Level 4). It has three parts:

```dart
class GreetingCard extends StatelessWidget {
  // PART 1: Properties (what you can customize)
  final String name;

  // PART 2: Constructor (how to build one)
  const GreetingCard({super.key, required this.name});

  // PART 3: build method (what it looks like on screen)
  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}
```

Compare this to the classes you wrote in Level 4. It is the same shape: properties, a constructor, and methods. The only new part is `build`, which returns the widgets to show.

> The `super.key` in the constructor is a special optional parameter every widget has. You will rarely need it as a beginner. Just include it in your constructors and move on; you will learn what keys do much later, when you build lists that change.

You use your widget just like any of the built-in ones:

```dart
GreetingCard(name: 'Ada')   // shows: Hello, Ada!
GreetingCard(name: 'Bola')  // shows: Hello, Bola!
```

You will learn to build widgets properly in lesson `03a`. For now, just notice the three-part shape.

---

## A Bigger Example: Picture The Tree

```dart
Center(
  child: Column(
    children: [
      Text('Top'),
      SizedBox(height: 10),   // a small gap
      Text('Bottom'),
    ],
  ),
)
```

The tree:

```
Center
 └─ Column
     ├─ Text('Top')
     ├─ SizedBox (invisible gap)
     └─ Text('Bottom')
```

`Center` has one `child` (the Column). The `Column` has three `children`: two texts with a gap between them.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using `child` when you need `children`

```dart
Column(
  child: Text('One'),     // BAD: Column needs children (a list)
)
Column(
  children: [Text('One'), Text('Two')],   // GOOD
)
```

### Mistake 2: Using `children` when you need `child`

```dart
Center(
  children: [Text('One')],   // BAD: Center holds only one child
)
Center(
  child: Text('One'),        // GOOD
)
```

### Mistake 3: Forgetting the brackets on `children`

```dart
Column(children: Text('One'))      // BAD: children needs a list
Column(children: [Text('One')])    // GOOD: a list, even with one item
```

### Mistake 4: Forgetting a comma between children

```dart
Column(children: [Text('a') Text('b')])   // BAD: missing comma
Column(children: [Text('a'), Text('b')])  // GOOD
```

---

## One-Minute Recap

- A **widget** is a small piece of the screen. Everything is a widget.
- You snap widgets together; widgets inside widgets make the **widget tree**.
- `child` holds **one** widget. `children` holds **many** (a list with `[ ]`).
- A widget you build is a class with three parts: properties, a constructor, and a `build` method.
- `Center`, `Padding`, `Container` use `child`. `Row`, `Column` use `children`.

---

## Quick Quiz

**Q1.** What is the difference between `child` and `children`?

<details>
<summary>Answer</summary>
`child` is for one widget (singular). `children` is for many widgets, given as a list in `[ ]`.
</details>

**Q2.** Does `Column` use `child` or `children`?

<details>
<summary>Answer</summary>
`children`, because a Column stacks many widgets. `Center` uses `child` because it holds only one.
</details>

**Q3.** What are the three parts of a widget you build?

<details>
<summary>Answer</summary>
Properties (what you can customize), the constructor (how to build one), and the `build` method (what it looks like).
</details>

**Q4.** Draw the widget tree for this:

```dart
Center(
  child: Row(
    children: [Icon(Icons.star), Text('Hi')],
  ),
)
```

<details>
<summary>Answer</summary>

```
Center
 └─ Row
     ├─ Icon(star)
     └─ Text('Hi')
```
</details>

---

## Assignment

These are about reading and shaping widget trees. You can also paste full apps into [dartpad.dev](https://dartpad.dev) to see them.

### Problem 1: child or children?

For each widget, say whether it takes `child` or `children`:

1. `Center`
2. `Column`
3. `Padding`
4. `Row`

### Problem 2: Draw the tree

Draw the widget tree for this code:

```dart
Scaffold(
  body: Center(
    child: Column(
      children: [
        Text('Score'),
        Text('100'),
      ],
    ),
  ),
)
```

### Problem 3: Spot the bug

This code is wrong. Find the mistake and fix it.

```dart
Center(
  children: [
    Text('Hello'),
  ],
)
```

### Problem 4: Build a NameTag widget

Write a `NameTag` widget (a class that extends `StatelessWidget`) with a `String name` property. Its `build` method should return `Text('My name is <name>')`. Show what it looks like to use it for the name `'Ada'`.

---

## Assignment Answers

### Problem 1: child or children?

1. `Center` -> `child` (holds one)
2. `Column` -> `children` (holds many)
3. `Padding` -> `child` (holds one)
4. `Row` -> `children` (holds many)

The rule: layout widgets that line things up (`Row`, `Column`) take `children`. Wrapper widgets that hold a single thing (`Center`, `Padding`, `Container`) take `child`.

### Problem 2: Draw the tree

```
Scaffold
 └─ Center
     └─ Column
         ├─ Text('Score')
         └─ Text('100')
```

`Scaffold`'s `body` is one `Center`. `Center` holds one `Column`. The `Column` holds two `Text` children.

### Problem 3: Spot the bug

`Center` holds only one widget, so it uses `child`, not `children`. Fixed:

```dart
Center(
  child: Text('Hello'),
)
```

If you really needed several widgets centered, you would put a `Column` (which uses `children`) inside the `Center`.

### Problem 4: Build a NameTag widget

```dart
class NameTag extends StatelessWidget {
  final String name;

  const NameTag({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('My name is $name');
  }
}

// Using it:
NameTag(name: 'Ada')   // shows: My name is Ada
```

It is the same three-part shape: a `name` property, a constructor that fills it in, and a `build` method that returns the widget to show. You will practise this a lot in lesson `03a`.

---

**Next:** `02b-BasicWidgets.md`, where you meet the everyday display widgets: Text, Icon, Image, Container, and SizedBox.
