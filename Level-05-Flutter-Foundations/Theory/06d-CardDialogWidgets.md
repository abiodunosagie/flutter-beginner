# Cards, Dialogs, and Messages

## The Big Idea In One Sentence

> `Card` groups content in a raised box, `showDialog` pops up an `AlertDialog`, and a `SnackBar` shows a quick message at the bottom.

These are the everyday Material widgets for grouping content and talking to the user.

---

## Card: A Raised Box For Grouping

A `Card` is a box with a subtle shadow and rounded corners. It groups related content so it looks like one unit.

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Ada Bello', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text('Flutter learner'),
      ],
    ),
  ),
)
```

A Card usually wraps a `Padding` (so the content is not jammed against the edge) and then a `Column` or `Row`. It is the easy way to make something look like a tidy card without setting up `BoxDecoration` yourself.

---

## AlertDialog: A Popup

To pop up a message that the user must respond to, call `showDialog` and return an `AlertDialog`. You usually trigger it from a button.

```dart
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hello'),
          content: const Text('This is a popup.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),   // closes the dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  },
  child: const Text('Show dialog'),
)
```

The parts of an `AlertDialog`:

- `title`: the heading.
- `content`: the message.
- `actions`: the buttons at the bottom (often Cancel and OK).

> `Navigator.pop(context)` closes the popup. You will learn `Navigator` properly in Level 7, but for now just remember: **`Navigator.pop(context)` closes a dialog.**

---

## A Confirmation Dialog

The most common dialog asks "are you sure?" before doing something. Give it two actions:

```dart
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Delete item?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),     // cancel: just close
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // do the delete here
            Navigator.pop(context);                    // then close
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  },
);
```

Cancel just closes the dialog. Delete does the action, then closes.

---

## SnackBar: A Quick Message

A `SnackBar` is a little message that slides up at the bottom for a few seconds, then disappears. Great for "Saved!" or "Item deleted." You show it with `ScaffoldMessenger`:

```dart
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved!')),
    );
  },
  child: const Text('Save'),
)
```

`ScaffoldMessenger.of(context).showSnackBar(...)` pops the message up. It needs a `Scaffold` somewhere above it (which your screens always have).

---

## BottomSheet: A Panel That Slides Up

A bottom sheet is a panel that slides up from the bottom, often with a few options. Show it with `showModalBottomSheet`:

```dart
ElevatedButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  },
  child: const Text('Show options'),
)
```

It works like `showDialog`: you return the widget to show, and `Navigator.pop(context)` closes it.

---

## A Couple Of Small Extras

- `Divider()` draws a thin horizontal line to separate sections.
- `Chip(label: Text('Flutter'))` is a small rounded tag, handy for labels or categories.

```dart
Column(
  children: const [
    Text('Above'),
    Divider(),
    Text('Below'),
    Chip(label: Text('tag')),
  ],
)
```

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting to close the dialog

```dart
TextButton(onPressed: () {}, child: Text('OK'))   // BAD: dialog stays open
TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))   // GOOD
```

Every dialog button should close the dialog with `Navigator.pop(context)` (after doing its work, if any).

### Mistake 2: A Card with no padding

A Card wraps content tightly. Add a `Padding` inside so the content has room.

### Mistake 3: Showing a SnackBar with no Scaffold

`ScaffoldMessenger.of(context)` needs a `Scaffold` above it. Show snackbars from inside a screen that has one.

### Mistake 4: Confusing dialog and snackbar

A dialog blocks the screen and needs a response. A snackbar is a quick, non-blocking message that fades away. Use a dialog for "are you sure?", a snackbar for "done!".

---

## One-Minute Recap

- `Card` is a raised box for grouping content (wrap a `Padding` inside).
- `showDialog` + `AlertDialog` makes a popup with `title`, `content`, and `actions`.
- `Navigator.pop(context)` closes a dialog or bottom sheet.
- `ScaffoldMessenger.of(context).showSnackBar(...)` shows a quick bottom message.
- `showModalBottomSheet` slides a panel up from the bottom.
- Use a **dialog** for "are you sure?", a **snackbar** for "done!".

---

## Quick Quiz

**Q1.** What three parts does an AlertDialog usually have?

<details>
<summary>Answer</summary>
`title`, `content`, and `actions` (the buttons).
</details>

**Q2.** How do you close a dialog?

<details>
<summary>Answer</summary>
`Navigator.pop(context)`.
</details>

**Q3.** When would you use a SnackBar instead of a dialog?

<details>
<summary>Answer</summary>
For a quick, non-blocking message like "Saved!". A dialog is for something the user must respond to, like "are you sure?".
</details>

**Q4.** What goes wrong if a dialog button has an empty `onPressed: () {}`?

<details>
<summary>Answer</summary>
The dialog never closes, because nothing calls `Navigator.pop(context)`.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev). Use a full `Scaffold` so dialogs and snackbars work:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: YOUR_WIDGET))));
```

### Problem 1: A profile card

Build a `Card` containing a `Padding` and a `Column` with a bold name `'Ada'` and a grey subtitle `'Student'`.

### Problem 2: A hello dialog

Build an `ElevatedButton` that, when tapped, shows an `AlertDialog` with the title `'Hi'`, the message `'Welcome!'`, and an `OK` button that closes it.

### Problem 3: A confirm dialog

Build a button that shows a confirm dialog titled `'Log out?'` with a `Cancel` button and a red `Log out` button. Both buttons should close the dialog.

### Problem 4: A save snackbar

Build a button that shows a `SnackBar` saying `'Saved!'` when tapped.

### Problem 5: Spot the bug

Why does this dialog stay open forever when you tap OK?

```dart
AlertDialog(
  title: const Text('Done'),
  actions: [
    TextButton(onPressed: () {}, child: const Text('OK')),
  ],
)
```

---

## Assignment Answers

### Problem 1: A profile card

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Ada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text('Student', style: TextStyle(color: Colors.grey)),
      ],
    ),
  ),
)
```

The `Card` gives the raised look, the `Padding` keeps the text off the edges, and the `Column` stacks the name and subtitle.

### Problem 2: A hello dialog

```dart
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hi'),
        content: const Text('Welcome!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  },
  child: const Text('Greet'),
)
```

`showDialog` builds the popup. The OK button closes it with `Navigator.pop(context)`.

### Problem 3: A confirm dialog

```dart
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  },
  child: const Text('Log out'),
)
```

Two actions: Cancel just closes, and the red Log out also closes (in a real app it would log out first, then close).

### Problem 4: A save snackbar

```dart
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved!')),
    );
  },
  child: const Text('Save'),
)
```

`ScaffoldMessenger.of(context).showSnackBar(...)` slides the "Saved!" message up from the bottom for a few seconds.

### Problem 5: Spot the bug

The OK button's `onPressed: () {}` does nothing, so the dialog is never closed. Add `Navigator.pop(context)`:

```dart
TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
```

Now tapping OK closes the dialog.

---

## Level 5 Complete!

You can now build real screens:

- Widgets, the widget tree, child vs children
- Display widgets: Text, Icon, Image, Container, SizedBox
- Layout: Row, Column, Center, Padding, Scaffold, constraints, Expanded, Stack
- Your own stateless and stateful widgets, with `setState` and the lifecycle
- Buttons, inputs, lists, cards, dialogs, and snackbars

That is everything you need to lay out and run an interactive app.

**Next:** open the `Examples/` and `Exercises/` folders to practise, then head to `../../Level-06-State-Management/Theory/00-LearningPath.md` to learn how to manage data across a whole app.
