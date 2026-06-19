# What Is Flutter?

## The Big Idea In One Sentence

> Flutter is a tool that lets you build a real app for phones (and web and desktop) using the Dart you already know.

You spent Levels 1 to 4 learning Dart. Flutter is where you finally use it to build something you can see and tap.

---

## What Flutter Gives You

Flutter is made by Google. Its superpower:

> Write your app **once**, and it runs on **iPhone, Android, web, and desktop**.

Without Flutter, you would write an iPhone app and an Android app separately, twice the work. With Flutter, one set of Dart code becomes apps for all of them.

---

## The One Big Idea: Everything Is A Widget

This is the most important sentence in all of Flutter:

> In Flutter, **everything on the screen is a widget.**

A piece of text? A widget. A button? A widget. An image? A widget. Even the spacing around things, and the whole app itself, are widgets.

A **widget** is just a small description of a piece of the screen. You build an app by snapping widgets together, like LEGO bricks. A `Text` widget inside a `Center` widget inside a `Scaffold` widget, and so on.

You will spend the rest of this level learning the most useful widgets, one at a time. For now, just hold onto this: **screen = widgets snapped together.**

---

## Your First Flutter App

Here is a complete, tiny Flutter app. It shows a bar at the top and "Hello, Flutter!" in the middle.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My First App'),
        ),
        body: const Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
```

Do not worry about understanding every word yet. Each piece gets its own lesson soon. But here is the big picture, top to bottom:

- `import 'package:flutter/material.dart';` brings in all the Flutter widgets.
- `runApp(...)` starts the app. It is the Flutter version of `main`.
- `MyApp` is a widget you made yourself (a class that `extends StatelessWidget`, which you met in Level 4 inheritance). Its `build` method describes the screen.
- `MaterialApp` wraps the whole app and gives it a standard look.
- `Scaffold` is the basic page layout: it has a slot for a top bar (`appBar`) and a slot for the main content (`body`).
- `AppBar` is the bar at the top, with a `Text` title.
- `Center` puts its child in the middle of the screen.
- `Text('Hello, Flutter!')` is the message.

Notice it is all widgets inside widgets: `Center` holds a `Text`, `Scaffold` holds an `AppBar` and a `Center`, and so on. That is the LEGO idea in action.

---

## How To Run It

The easiest way, no setup needed:

1. Go to **[dartpad.dev](https://dartpad.dev)**.
2. Delete the sample code and paste the app above.
3. Press **Run**.
4. The app appears on the right, with the bar and the centered text.

Later, when you build bigger apps on your own computer, you will run them with the command `flutter run`. But DartPad is perfect while you learn.

---

## Hot Reload: The Magic Feature

One thing developers love about Flutter is **hot reload**.

> Change your code, save, and the running app updates almost instantly, in under a second.

You do not have to restart the whole app to see a change. Tweak a color, save, and it is just there. This makes building UIs fast and fun. You will feel it the moment you start changing the examples.

---

## What You Will Learn In This Level

This level teaches the building blocks, step by step:

- **Widgets**: the LEGO bricks (text, images, boxes, rows, columns).
- **Stateless widgets**: screens that do not change.
- **Stateful widgets**: screens that **do** change when you tap (like a counter going up).
- **Layout**: how to arrange widgets neatly.
- **Common widgets**: buttons, text fields, lists, cards.

By the end, you will be building real screens.

---

## One-Minute Recap

- Flutter lets you build apps for many platforms from one Dart codebase.
- In Flutter, **everything on screen is a widget**.
- You build a screen by snapping widgets together, like LEGO.
- A tiny app is a `MyApp` widget whose `build` returns a `MaterialApp` with a `Scaffold` inside.
- Run it free on [dartpad.dev](https://dartpad.dev).
- **Hot reload** shows your changes almost instantly.

---

## Quick Quiz

**Q1.** What does Flutter let you do with one codebase?

<details>
<summary>Answer</summary>
Build an app that runs on many platforms (iPhone, Android, web, desktop) from a single set of Dart code.
</details>

**Q2.** Fill in the blank: in Flutter, everything on the screen is a ______.

<details>
<summary>Answer</summary>
A **widget**. Text, buttons, images, spacing, and the whole app are all widgets.
</details>

**Q3.** What is hot reload?

<details>
<summary>Answer</summary>
A feature that updates your running app almost instantly when you save a code change, without restarting the whole app.
</details>

**Q4.** In the first app, what does `Center` do?

<details>
<summary>Answer</summary>
It puts its child (the `Text`) in the middle of the screen.
</details>

---

## Assignment

These are hands-on. Use [dartpad.dev](https://dartpad.dev) in Flutter mode (paste the first app above to start).

### Problem 1: Run the first app

Paste the "first Flutter app" from above into DartPad and press Run. Confirm you see a top bar reading "My First App" and "Hello, Flutter!" in the middle.

### Problem 2: Change the message

Change the centered text from `'Hello, Flutter!'` to `'Hello, my name is <your name>'`. Run again and see your message.

### Problem 3: Change the title

Change the `AppBar` title from `'My First App'` to `'My Practice App'`. Run and see the top bar change.

### Problem 4: Spot the widgets

Without running anything, list every widget type you can find in the first app (there are six).

---

## Assignment Answers

### Problem 1: Run the first app

If you pasted it correctly and pressed Run, you see the bar at the top and the centered text. If you got a red error, check that you copied the whole thing, including the `import` line at the very top and all the closing brackets `)` and `}` at the bottom.

### Problem 2: Change the message

```dart
body: const Center(
  child: Text('Hello, my name is Ada'),
),
```

Only the text inside the quotes changed. Everything else stays the same. This is the fastest way to feel hot reload: change the text, save, and watch it update.

### Problem 3: Change the title

```dart
appBar: AppBar(
  title: const Text('My Practice App'),
),
```

The `AppBar`'s `title` is just a `Text` widget, so you change it the same way you changed the body text.

### Problem 4: Spot the widgets

The six widget types in the first app:

1. `MyApp` (the widget you wrote)
2. `MaterialApp`
3. `Scaffold`
4. `AppBar`
5. `Center`
6. `Text` (used twice: the title and the body, but it is one type)

That is the LEGO idea: a handful of widget types, snapped together, make a whole screen. In the next lesson you start learning these bricks properly.

---

**Next:** `02a-WidgetIntro.md`, where you learn what a widget really is and how the widget tree works.
