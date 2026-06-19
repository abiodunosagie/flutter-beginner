# BuildContext: Finding Out About The App Around You

## The Big Idea In One Sentence

> `BuildContext` is the `context` in your `build` method, and it lets a widget ask the app questions like "what colour is the theme?" and "how wide is the screen?".

You have seen `BuildContext context` in every `build` method. Now you learn what it is for.

---

## An Address Analogy

Imagine your house has an address. The address tells the postman exactly where you are, and from there they can find your street, your neighbourhood, your city.

`BuildContext` is your widget's address in the widget tree. From its spot, a widget can look **upward** to find shared things its parents provide, like the app's colours or the screen size.

```
MaterialApp        (knows the theme)
 └─ Scaffold
     └─ Center
         └─ MyWidget   <- its context can look up and find the theme
```

You do not create a context. Flutter hands you one as the `context` parameter of `build`.

---

## Reading The Theme

Your app has a **theme**: a set of colours and text styles used everywhere. A widget reads it with `Theme.of(context)`.

### Theme Colours

```dart
class ThemedBox extends StatelessWidget {
  const ThemedBox({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      color: color,
      child: const Text('I use the theme colour'),
    );
  }
}
```

`Theme.of(context).colorScheme.primary` is the app's main colour. Because the box reads it from the theme, if you ever change the app's colour, this box changes automatically. No need to edit it.

### Theme Text Styles

The theme also has ready-made text styles:

```dart
class ThemedTitle extends StatelessWidget {
  const ThemedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme;

    return Column(
      children: [
        Text('Big title', style: styles.headlineMedium),
        Text('Normal body text', style: styles.bodyLarge),
      ],
    );
  }
}
```

Using theme styles keeps all your text consistent across the whole app.

---

## Reading The Screen Size

To find out how big the screen is, use `MediaQuery.of(context).size`:

```dart
class ScreenInfo extends StatelessWidget {
  const ScreenInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Text('Width: ${size.width.toInt()}, Height: ${size.height.toInt()}');
  }
}
```

`size.width` and `size.height` are the screen's width and height in pixels.

### Making A Box Fit The Screen

A common use: size a widget as a fraction of the screen.

```dart
class HalfWidthBox extends StatelessWidget {
  const HalfWidthBox({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8,   // 80% of the screen width
      height: 100,
      color: Colors.blue,
      child: const Center(child: Text('80% wide')),
    );
  }
}
```

`width * 0.8` makes the box 80 percent of the screen width, so it looks right on a small phone and a big tablet alike.

---

## The One Rule: Use Context Inside build

`context` only exists inside the `build` method (and helpers called from it). You cannot use it in the constructor, because the widget is not on the tree yet.

```dart
class Bad extends StatelessWidget {
  Bad({super.key}) {
    Theme.of(context);   // ERROR: there is no context here
  }
  @override
  Widget build(BuildContext context) => const Text('hi');
}

class Good extends StatelessWidget {
  const Good({super.key});
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;  // GOOD: inside build
    return Text('hi', style: TextStyle(color: color));
  }
}
```

---

## What Else Is Context Used For?

`context` is also how you do bigger things later:

- **Move to another screen** (navigation), which is the whole of Level 7.
- **Pop up a dialog or a little message** (a snackbar), which you meet in lesson `06d`.

All of those start with `context` too. For now, just get comfortable using it to read the theme and the screen size.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using context in the constructor

```dart
MyWidget({super.key}) { Theme.of(context); }   // BAD: no context yet
```

Only use `context` inside `build`.

### Mistake 2: Forgetting `.of(context)`

```dart
Theme.primaryColor          // BAD
Theme.of(context).colorScheme.primary   // GOOD
```

You reach shared things with `Something.of(context)`.

### Mistake 3: Hard-coding sizes instead of using the screen

```dart
Container(width: 400)                              // may be too wide on a small phone
Container(width: MediaQuery.of(context).size.width * 0.8)  // fits any screen
```

---

## One-Minute Recap

- `BuildContext` is the `context` in `build`. It is your widget's address in the tree.
- `Theme.of(context)` reads the app's colours (`.colorScheme.primary`) and text styles (`.textTheme`).
- `MediaQuery.of(context).size` gives the screen `width` and `height`.
- Only use `context` inside `build`.
- Context is also used for navigation (Level 7) and dialogs (06d), later.

---

## Quick Quiz

**Q1.** What is `BuildContext`?

<details>
<summary>Answer</summary>
It is the widget's location (address) in the widget tree. It lets the widget look up shared things from its parents, like the theme and screen size. Flutter gives it to you as the `context` parameter of `build`.
</details>

**Q2.** How do you get the screen width?

<details>
<summary>Answer</summary>

```dart
MediaQuery.of(context).size.width
```
</details>

**Q3.** How do you read the app's main colour?

<details>
<summary>Answer</summary>

```dart
Theme.of(context).colorScheme.primary
```
</details>

**Q4.** Where can you use `context`?

<details>
<summary>Answer</summary>
Only inside the `build` method (or helper methods called from it). Not in the constructor.
</details>

---

## Assignment

Use [dartpad.dev](https://dartpad.dev) with this shell:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: YOUR_WIDGET()))));
```

### Problem 1: Show the screen width

Write a widget whose `build` shows `Text('Width: <width>')`, using the real screen width from `MediaQuery`.

### Problem 2: A box that is half the screen

Write a widget that returns a blue `Container` whose width is half the screen width and whose height is 120.

### Problem 3: Use the theme colour

Write a widget that returns a `Container` coloured with the app's main theme colour (`colorScheme.primary`), holding the text `'Themed'`.

### Problem 4: Use a theme text style

Write a widget that shows `'Hello'` using the theme's `headlineMedium` text style.

### Problem 5: Spot the bug

```dart
class Banner extends StatelessWidget {
  Banner({super.key}) {
    final color = Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Banner');
  }
}
```

---

## Assignment Answers

### Problem 1: Show the screen width

```dart
class WidthLabel extends StatelessWidget {
  const WidthLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text('Width: ${width.toInt()}');
  }
}
```

`MediaQuery.of(context).size.width` reads the real width. `.toInt()` drops the decimals so it reads nicely.

### Problem 2: A box that is half the screen

```dart
class HalfBox extends StatelessWidget {
  const HalfBox({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.5,
      height: 120,
      color: Colors.blue,
    );
  }
}
```

`width * 0.5` is half the screen width, so the box scales to whatever device it runs on.

### Problem 3: Use the theme colour

```dart
class ThemedBox extends StatelessWidget {
  const ThemedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary,
      child: const Text('Themed'),
    );
  }
}
```

The colour comes from the theme, so the box matches the rest of the app and updates if the theme changes.

### Problem 4: Use a theme text style

```dart
class BigHello extends StatelessWidget {
  const BigHello({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Hello', style: Theme.of(context).textTheme.headlineMedium);
  }
}
```

`Theme.of(context).textTheme.headlineMedium` is a ready-made large text style from the theme.

### Problem 5: Spot the bug

The bug: `context` is used in the **constructor**, where it does not exist yet. You can only use `context` inside `build`.

Fixed (move the work into `build`, and actually use the colour):

```dart
class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Text('Banner', style: TextStyle(color: color));
  }
}
```

Now the colour is read inside `build`, where `context` is available.

---

**Next:** `04a-StatefulIntro.md`, where you finally build widgets that **change** when the user interacts.
