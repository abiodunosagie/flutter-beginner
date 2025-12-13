# Level 5: Flutter Foundations

Welcome to Flutter! You've learned Dart, now it's time to build beautiful apps.

---

## What You'll Learn

### Core Concepts
- What is Flutter?
- How Flutter works
- Project structure
- Widgets: The building blocks

### Essential Widgets
- StatelessWidget vs StatefulWidget
- MaterialApp and Scaffold
- Text, Container, Image
- Row, Column, Stack
- Buttons and Input

### Layout System
- How Flutter layouts work
- Constraints and sizing
- Common layout patterns

---

## Learning Path

### Theory (Read First)
1. `Theory/01-WhatIsFlutter.md` - Introduction to Flutter
2. `Theory/02-WidgetBasics.md` - Everything is a widget
3. `Theory/03-StatelessWidgets.md` - Simple, immutable widgets
4. `Theory/04-StatefulWidgets.md` - Interactive widgets with state
5. `Theory/05-LayoutSystem.md` - How Flutter positions things
6. `Theory/06-CommonWidgets.md` - Essential widgets reference

### Examples (Study Second)
1. `Examples/Example01-HelloFlutter.dart`
2. `Examples/Example02-BasicWidgets.dart`
3. `Examples/Example03-LayoutExamples.dart`
4. `Examples/Example04-StatefulCounter.dart`
5. `Examples/Example05-SimpleApp.dart`

### Exercises (Practice Last)
- `Exercises/Exercises.md`

---

## Prerequisites

Complete Level 4 (OOP Fundamentals) first. You should know:
- Classes and Objects
- Constructors (especially named/const)
- Inheritance
- Method overriding

---

## Key Concepts Preview

### Everything is a Widget

```dart
// Text is a widget
Text('Hello')

// A button is a widget
ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
)

// Layout is a widget
Column(
  children: [
    Text('First'),
    Text('Second'),
  ],
)
```

### StatelessWidget

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

### StatefulWidget

```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

## Setting Up Flutter

Before starting, make sure you have Flutter installed:

```bash
# Check Flutter installation
flutter doctor

# Create a new project
flutter create my_app

# Run the app
cd my_app
flutter run
```

---

## Learning Objectives

By the end of this level, you will:

1. ✅ Understand Flutter's architecture
2. ✅ Create StatelessWidget components
3. ✅ Create StatefulWidget components
4. ✅ Use setState for updates
5. ✅ Apply common layout widgets
6. ✅ Style widgets with properties
7. ✅ Handle user input
8. ✅ Build a complete simple app

---

## Time Estimate

- Theory: 90-120 minutes
- Examples: 60-90 minutes
- Exercises: 90-120 minutes

**Total: 4-6 hours**

---

## Quick Tips

💡 **Hot Reload**: Press `r` in terminal or save file to see changes instantly

💡 **Widget Tree**: Think of your UI as a tree of nested widgets

💡 **Const**: Use `const` for widgets that don't change

💡 **Context**: `BuildContext` is how widgets know their position in the tree

---

**Start Here:** `Theory/01-WhatIsFlutter.md`
