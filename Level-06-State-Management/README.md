# Level 6: State Management

Welcome to State Management! This is one of the most important topics in Flutter development. We'll learn three popular approaches: Provider, Riverpod, and BLoC.

---

## What You'll Learn

### Understanding State
- What is "state"?
- Why do we need state management?
- The problems with setState()
- Different types of state

### Provider
- What is Provider?
- Setting up Provider
- ChangeNotifier pattern
- Consumer widgets
- Multiple providers

### Riverpod
- What is Riverpod?
- Why Riverpod over Provider?
- Different provider types
- Reading and watching state
- State notifiers

### BLoC Pattern
- What is BLoC?
- Events and States
- Streams explained simply
- Building your first BLoC
- BlocBuilder and BlocListener

---

## Learning Path

### Theory (Read First)
1. `Theory/01-WhatIsState.md` - Understanding state (the foundation)
2. `Theory/02-ProviderBasics.md` - Provider fundamentals
3. `Theory/03-ProviderAdvanced.md` - Advanced Provider patterns
4. `Theory/04-RiverpodBasics.md` - Riverpod fundamentals
5. `Theory/05-RiverpodAdvanced.md` - Advanced Riverpod patterns
6. `Theory/06-BlocBasics.md` - BLoC fundamentals
7. `Theory/07-BlocAdvanced.md` - Advanced BLoC patterns
8. `Theory/08-ChoosingStateManagement.md` - Which one to use?

### Examples (Study Second)
1. `Examples/Example01-ProviderCounter.dart`
2. `Examples/Example02-ProviderTodoApp.dart`
3. `Examples/Example03-RiverpodCounter.dart`
4. `Examples/Example04-RiverpodTodoApp.dart`
5. `Examples/Example05-BlocCounter.dart`
6. `Examples/Example06-BlocTodoApp.dart`

### Exercises (Practice Last)
- `Exercises/Exercises.md`

---

## Prerequisites

Complete Level 5 (Flutter Foundations) first. You should know:
- StatefulWidget and setState
- Widget tree and rebuilding
- Basic Flutter layouts
- BuildContext

---

## The Big Picture

Think of state management like this:

### Without State Management (Using setState)
```
┌────────────────────────────────────────┐
│              Your App                  │
│  ┌──────────────────────────────────┐  │
│  │     Parent Widget                 │  │
│  │     (has all the data)           │  │
│  │  ┌────────────────────────────┐  │  │
│  │  │   Child Widget              │  │  │
│  │  │   (passes data down)       │  │  │
│  │  │  ┌──────────────────────┐  │  │  │
│  │  │  │   Grandchild         │  │  │  │
│  │  │  │   (passes data down) │  │  │  │
│  │  │  │  ┌────────────────┐  │  │  │  │
│  │  │  │  │ Great-grand    │  │  │  │  │
│  │  │  │  │ (finally uses │  │  │  │  │
│  │  │  │  │  the data!)    │  │  │  │  │
│  │  │  │  └────────────────┘  │  │  │  │
│  │  │  └──────────────────────┘  │  │  │
│  │  └────────────────────────────┘  │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘

Problem: Data has to pass through EVERY widget!
This is called "prop drilling" - very messy!
```

### With State Management
```
┌────────────────────────────────────────┐
│              Your App                  │
│                                        │
│        ┌─────────────────┐             │
│        │  State Manager  │ ◄── Single  │
│        │  (holds data)   │    source   │
│        └────────┬────────┘    of truth │
│                 │                      │
│    ┌────────────┼────────────┐         │
│    │            │            │         │
│    ▼            ▼            ▼         │
│ ┌──────┐   ┌──────┐   ┌──────┐        │
│ │Widget│   │Widget│   │Widget│        │
│ │  A   │   │  B   │   │  C   │        │
│ └──────┘   └──────┘   └──────┘        │
│                                        │
│ Any widget can access data directly!   │
└────────────────────────────────────────┘
```

---

## Quick Comparison

| Feature | Provider | Riverpod | BLoC |
|---------|----------|----------|------|
| Learning Curve | Easy | Medium | Harder |
| Setup | Simple | Simple | More code |
| Type Safety | Good | Excellent | Excellent |
| Testing | Good | Excellent | Excellent |
| Boilerplate | Low | Low | Higher |
| Flutter team support | Yes | Community | Community |
| Best for | Small-medium apps | Any size | Large apps |

---

## Time Estimate

- Theory: 3-4 hours
- Examples: 2-3 hours
- Exercises: 3-4 hours

**Total: 8-11 hours**

Take your time! State management is crucial to understand well.

---

## Quick Tips

💡 **Start with Provider**: It's the easiest to understand first

💡 **Practice each one**: Don't just read - build the examples

💡 **Compare them**: Build the same app with each to see differences

💡 **Think in "states"**: What data changes? That's your state.

---

## Packages You'll Need

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Provider
  provider: ^6.1.1

  # Riverpod
  flutter_riverpod: ^2.4.9

  # BLoC
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
```

Run: `flutter pub get`

---

**Start Here:** `Theory/01-WhatIsState.md`

---

## Build This App (required project)

After exercises, complete **[Build-This-App/README.md](Build-This-App/README.md)**.

Larger apps: [Full-App-Tutorials](../Full-App-Tutorials/README.md).
