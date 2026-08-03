# Level 5: Flutter Foundations (Learning Path)

Welcome to Level 5! This is where you stop writing console Dart and start building **real screens you can see and tap**. You will learn the building blocks of every Flutter app: widgets.

Finish Levels 1 to 4 first. This level uses everything: variables, functions, collections, and especially classes (your widgets are classes).

---

## How To Use These Lessons

Read them **in order**, one at a time. Each lesson only uses ideas from earlier lessons.

For every lesson:

1. Read it slowly.
2. Paste the examples into [dartpad.dev](https://dartpad.dev) in **Flutter mode** and press Run.
3. Do the **Assignment** at the bottom before peeking at the answers.

Flutter's superpower is **hot reload**: change the code, and the running app updates instantly. Lean on it.

---

## The Path (Follow In Order)

### 1. What Is Flutter?
**[01-WhatIsFlutter.md](01-WhatIsFlutter.md)**
The big picture: one codebase for many platforms, everything is a widget, and your first runnable app.

### Understanding Widgets
- **[02a-WidgetIntro.md](02a-WidgetIntro.md)** — what a widget is, the widget tree, `child` vs `children`.
- **[02b-BasicWidgets.md](02b-BasicWidgets.md)** — the display widgets: Text, Icon, Image, Container, SizedBox.
- **[02c-LayoutBasics.md](02c-LayoutBasics.md)** — arranging widgets: Row, Column, Center, Padding, Scaffold.

### Building Your Own Widgets (Stateless)
- **[03a-StatelessIntro.md](03a-StatelessIntro.md)** — make your own widget that never changes.
- **[03b-StatelessProperties.md](03b-StatelessProperties.md)** — pass data in so widgets are reusable.
- **[03c-StatelessContext.md](03c-StatelessContext.md)** — use BuildContext for theme colours and screen size.

### Interactive Widgets (Stateful)
- **[04a-StatefulIntro.md](04a-StatefulIntro.md)** — widgets that change, with `setState`. (The key lesson.)
- **[04b-Lifecycle.md](04b-Lifecycle.md)** — `initState`, `build`, `dispose`.
- **[04c-StatefulExamples.md](04c-StatefulExamples.md)** — real interactive widgets you build.

### The Layout System
- **[05a-ConstraintsLayout.md](05a-ConstraintsLayout.md)** — how Flutter decides sizes (constraints down, sizes up).
- **[05b-FlexibleExpanded.md](05b-FlexibleExpanded.md)** — share space with Expanded and Flexible.
- **[05c-StackPositioned.md](05c-StackPositioned.md)** — layer widgets with Stack and Positioned.

### Common Widgets
- **[06a-ButtonWidgets.md](06a-ButtonWidgets.md)** — buttons and handling taps.
- **[06b-InputWidgets.md](06b-InputWidgets.md)** — text fields, checkboxes, switches, sliders, dropdowns.
- **[06c-ListWidgets.md](06c-ListWidgets.md)** — scrollable lists with ListView and grids.
- **[06d-CardDialogWidgets.md](06d-CardDialogWidgets.md)** — cards, dialogs, and snackbars.

---

## The One Idea To Hold Onto

> Everything on screen is a widget, and you build a screen by snapping widgets together like LEGO.

Read a chunk of Flutter code by picturing its widget tree, and it stops being scary.

---

## After The Theory

When you finish all the lessons:

1. **Practice** with the files in the `../Examples/` folder. Run each one.
2. **Do the Exercises** in `../Exercises/`. Try them before looking at the answers.
3. **Check yourself:** Can you build both a stateless and a stateful widget? Can you lay out a screen with Row and Column? Can you make a button change something with `setState`?

---

## Tips For Success

Do:
- Run every example and tweak it. Use hot reload.
- Picture the widget tree when you read code.
- Build the widgets yourself, do not just read.

Do not:
- Skip the assignments.
- Move to Level 6 before `setState` feels natural.

---

**Ready? Start here:** [01-WhatIsFlutter.md](01-WhatIsFlutter.md)

---

## Going Deeper (Level 19)

When you are comfortable here, Level 19 takes this further with the production stack that job adverts ask for:

📖 **[Widget composition, const rebuilds, keys, and responsive layout in production](../../Level-19-Job-Ready-Flutter/Theory/01a-CompositionOverInheritance.md)**
