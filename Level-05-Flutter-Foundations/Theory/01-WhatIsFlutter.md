# What Is Flutter?

## Flutter Overview

**Flutter** is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

```
One Codebase → Multiple Platforms
     │
     ├── 📱 iOS
     ├── 📱 Android
     ├── 🖥️ Windows
     ├── 🖥️ macOS
     ├── 🖥️ Linux
     └── 🌐 Web
```

---

## Why Choose Flutter?

### 1. Single Codebase

Write once, run everywhere:

```dart
// This code works on ALL platforms
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
```

### 2. Hot Reload

See changes instantly without losing app state:

```
Make a change → Save → See result (< 1 second)
```

### 3. Beautiful UI

Built-in widgets that look great:
- Material Design (Android style)
- Cupertino (iOS style)
- Custom designs

### 4. Performance

Flutter compiles to native code:
- 60fps (or 120fps) animations
- Native performance
- Small app sizes

---

## How Flutter Works

### Traditional vs Flutter

**Traditional (React Native, Cordova):**
```
Your Code → JavaScript Bridge → Native Components
```
Problem: Bridge creates overhead

**Flutter:**
```
Your Code → Compiled Dart → Direct GPU Rendering
```
Result: No bridge, maximum performance

### Flutter's Architecture

```
┌─────────────────────────────────────┐
│           Your App Code             │  ← You write this
│         (Dart + Widgets)            │
├─────────────────────────────────────┤
│         Flutter Framework           │  ← Widgets, animations,
│    (Material, Cupertino, etc.)      │     gestures, etc.
├─────────────────────────────────────┤
│          Flutter Engine             │  ← Skia (graphics),
│      (Rendering, Platform)          │     Dart runtime
├─────────────────────────────────────┤
│        Platform Specific            │  ← iOS, Android,
│         (Embedder)                  │     Web, Desktop
└─────────────────────────────────────┘
```

### The Rendering Pipeline

```
Widget Tree    →    Element Tree    →    Render Tree
(Your code)        (Framework)          (Actual pixels)
```

---

## Everything Is a Widget

In Flutter, **everything is a widget**:

| What you see | Widget |
|--------------|--------|
| Text | `Text('Hello')` |
| Button | `ElevatedButton()` |
| Image | `Image.asset('pic.png')` |
| Layout | `Row()`, `Column()`, `Stack()` |
| Styling | `Container()`, `Padding()` |
| The whole app | `MaterialApp()` |

### Widget Example

```dart
// A simple centered text
Center(                    // Layout widget
  child: Text(             // Display widget
    'Hello, Flutter!',     // Content
    style: TextStyle(      // Styling
      fontSize: 24,
      color: Colors.blue,
    ),
  ),
)
```

---

## Project Structure

When you create a Flutter project:

```
my_app/
├── lib/
│   └── main.dart          ← Your main code
├── android/               ← Android-specific
├── ios/                   ← iOS-specific
├── web/                   ← Web-specific
├── test/                  ← Tests
├── pubspec.yaml           ← Dependencies
└── README.md
```

### The Main File

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());  // Entry point
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter'),
        ),
        body: Center(
          child: Text('Welcome!'),
        ),
      ),
    );
  }
}
```

---

## Widget Types

### StatelessWidget

Widgets that don't change:

```dart
class Greeting extends StatelessWidget {
  final String name;

  const Greeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}
```

Use when:
- Content is static
- Only depends on constructor parameters
- No user interaction changes it

### StatefulWidget

Widgets that can change:

```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => count++),
      child: Text('Count: $count'),
    );
  }
}
```

Use when:
- Content changes over time
- Responds to user interaction
- Has internal state

---

## The Build Method

Every widget has a `build` method that describes its UI:

```dart
@override
Widget build(BuildContext context) {
  // Return a widget tree
  return Container(
    child: Column(
      children: [
        Text('Title'),
        Text('Subtitle'),
      ],
    ),
  );
}
```

**Important:**
- Called whenever widget needs to update
- Should be pure (same inputs → same output)
- Should be fast
- Don't do expensive work here

---

## BuildContext

`BuildContext` tells a widget its location in the widget tree:

```dart
@override
Widget build(BuildContext context) {
  // Use context to:
  // - Access theme
  var theme = Theme.of(context);

  // - Access screen size
  var size = MediaQuery.of(context).size;

  // - Navigate
  Navigator.of(context).push(...);

  // - Show snackbar
  ScaffoldMessenger.of(context).showSnackBar(...);

  return Text('Hello');
}
```

---

## Material vs Cupertino

### Material Design (Android-style)

```dart
import 'package:flutter/material.dart';

MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text('Material')),
    body: ElevatedButton(
      onPressed: () {},
      child: Text('Button'),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    ),
  ),
)
```

### Cupertino (iOS-style)

```dart
import 'package:flutter/cupertino.dart';

CupertinoApp(
  home: CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      middle: Text('Cupertino'),
    ),
    child: CupertinoButton(
      onPressed: () {},
      child: Text('Button'),
    ),
  ),
)
```

---

## Common Terminology

| Term | Meaning |
|------|---------|
| Widget | Building block of UI |
| Widget Tree | Hierarchy of nested widgets |
| State | Data that can change |
| Build | Create the UI description |
| Hot Reload | Instant preview of changes |
| Scaffold | Basic app structure |
| Context | Widget's location info |

---

## Your First Flutter App

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
      title: 'My First App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: const Center(
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

Run with:
```bash
flutter run
```

---

## Summary

| Concept | Description |
|---------|-------------|
| Flutter | Google's cross-platform UI toolkit |
| Dart | The programming language |
| Widget | Basic building block |
| StatelessWidget | Static, unchanging UI |
| StatefulWidget | Dynamic, changing UI |
| Hot Reload | Instant preview |
| MaterialApp | App with Material Design |

---

## Quick Quiz

**Q1:** What makes Flutter different from React Native?

<details>
<summary>Answer</summary>

Flutter compiles directly to native code and renders using its own graphics engine (Skia), while React Native uses a JavaScript bridge to native components. This gives Flutter better performance.

</details>

**Q2:** What is a Widget in Flutter?

<details>
<summary>Answer</summary>

A widget is the basic building block of Flutter UI. Everything visible (and some invisible things like padding) is a widget. Widgets describe their UI in their `build` method.

</details>

**Q3:** When would you use StatefulWidget vs StatelessWidget?

<details>
<summary>Answer</summary>

- StatelessWidget: When the UI doesn't change (static text, icons, constant layouts)
- StatefulWidget: When the UI needs to update (counters, forms, animations, anything that responds to interaction)

</details>

---

**Next:** Learn about widgets in depth.

---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Understanding Widgets - Introduction](02a-WidgetIntro.md)
