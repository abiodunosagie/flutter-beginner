# Widget Lifecycle: Birth, Life, and Death of Widgets

## Think Like a Kid with a Pet

Imagine you get a pet fish:

```
🥚 Birth:     You bring the fish home (initState)
🐟 Growing:   Fish adapts to new tank (didChangeDependencies)
🐟 Living:    Fish swims around every day (build)
🐟 Changes:   You move to bigger tank (didUpdateWidget)
💀 Goodbye:   Fish goes to heaven (dispose)
```

Every StatefulWidget has a similar lifecycle - it's born, lives, and eventually is removed.

---

## The Complete Lifecycle

Here's what happens from birth to death:

```
        createState()
             │
             ▼
        initState() ─────────────────┐
             │                       │
             ▼                       │  Called
  didChangeDependencies()            │  ONCE
             │                       │  at start
             ▼                       │
         build() ◄───────────────────┘
             │
             ├──────────────┐
             │              │
      (User interaction)    │
             │              │
             ▼              │  Called
        setState() ─────────┤  MANY
             │              │  times
             ▼              │
         build() ◄──────────┘
             │
             ├──────────────┐
      (Parent rebuilds       │
       with new props)       │
             │              │
             ▼              │
    didUpdateWidget() ──────┘
             │
             ▼
         build()
             │
      (Eventually...)
             │
             ▼
         dispose()
             │
             ▼
          💀 Gone
```

---

## The Birth: initState()

Called **once** when the State is created. Like a baby being born!

```dart
class _MyWidgetState extends State<MyWidget> {
  int count = 0;
  late String message;

  @override
  void initState() {
    super.initState();  // ⚠️ Always call this first!

    // Setup work here
    print('Widget is born!');
    message = 'Hello!';
    count = 10;

    // Good for:
    // - Setting initial values
    // - Starting timers
    // - Subscribing to streams
    // - Loading initial data
  }

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
```

### What You Can Do in initState()

```dart
@override
void initState() {
  super.initState();

  // ✅ Set initial values
  count = 0;
  message = 'Ready!';

  // ✅ Start a timer
  timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      seconds++;
    });
  });

  // ✅ Load initial data
  loadData();
}
```

### What You CANNOT Do in initState()

```dart
@override
void initState() {
  super.initState();

  // ❌ DON'T access BuildContext
  // Theme.of(context);  // ERROR! Context not ready yet

  // ❌ DON'T call setState()
  // setState(() { count = 5; });  // Not needed, just set directly
}
```

---

## Growing Up: didChangeDependencies()

Called when the widget's dependencies change (like Theme, MediaQuery, etc.).

Called **after** initState() and whenever dependencies change.

```dart
class _ThemeAwareState extends State<ThemeAware> {
  Color? currentColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();  // ⚠️ Always call this first!

    // NOW you can access context safely!
    currentColor = Theme.of(context).primaryColor;
    print('Theme color: $currentColor');
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: currentColor);
  }
}
```

### When Is This Called?

```
1. Right after initState() (first time)
2. When Theme changes
3. When MediaQuery changes (screen rotates)
4. When InheritedWidget changes
```

---

## Living: build()

Called **many times** to create the widget tree. Like breathing - happens again and again!

```dart
@override
Widget build(BuildContext context) {
  print('Building widget...');

  // This can be called:
  // - After initState()
  // - After setState()
  // - After didUpdateWidget()
  // - When parent rebuilds
  // - MANY TIMES!

  return Text('Count: $count');
}
```

### Important Rules for build()

```dart
@override
Widget build(BuildContext context) {
  // ✅ DO: Return widgets
  // ✅ DO: Access state variables
  // ✅ DO: Use context

  // ❌ DON'T: Call setState()
  // ❌ DON'T: Do heavy computations
  // ❌ DON'T: Start timers or async work

  return Container();
}
```

---

## Changing: didUpdateWidget()

Called when the parent rebuilds with **new properties**.

```dart
class Greeting extends StatefulWidget {
  final String name;  // This property might change!

  const Greeting({super.key, required this.name});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  int greetCount = 0;

  @override
  void didUpdateWidget(Greeting oldWidget) {
    super.didUpdateWidget(oldWidget);  // ⚠️ Always call this first!

    // Compare old and new properties
    if (widget.name != oldWidget.name) {
      print('Name changed from ${oldWidget.name} to ${widget.name}');

      // Reset count when name changes
      setState(() {
        greetCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hello ${widget.name}! (Greeted $greetCount times)');
  }
}
```

### When to Use didUpdateWidget()

```dart
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  // ✅ Good: Compare properties
  if (widget.userId != oldWidget.userId) {
    loadUserData(widget.userId);
  }

  // ✅ Good: Reset state when props change
  if (widget.initialValue != oldWidget.initialValue) {
    setState(() {
      value = widget.initialValue;
    });
  }
}
```

---

## Death: dispose()

Called when the widget is **permanently removed**. Like cleaning your room before moving out!

```dart
class _TimerWidgetState extends State<TimerWidget> {
  late Timer timer;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() { });
    });
  }

  @override
  void dispose() {
    // Clean up everything!
    controller.dispose();  // ✅ Dispose controllers
    timer.cancel();        // ✅ Cancel timers

    super.dispose();  // ⚠️ Always call this LAST!
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

### What to Clean Up in dispose()

```dart
@override
void dispose() {
  // ✅ Dispose controllers
  textController.dispose();
  animationController.dispose();

  // ✅ Cancel timers
  timer?.cancel();

  // ✅ Cancel stream subscriptions
  subscription?.cancel();

  // ✅ Remove listeners
  scrollController.removeListener(myListener);

  super.dispose();  // ⚠️ LAST!
}
```

---

## Complete Lifecycle Example

Here's a widget that demonstrates the entire lifecycle:

```dart
import 'package:flutter/material.dart';
import 'dart:async';

class LifecycleDemo extends StatefulWidget {
  final String title;

  const LifecycleDemo({super.key, required this.title});

  @override
  State<LifecycleDemo> createState() {
    print('📋 createState() called');
    return _LifecycleDemoState();
  }
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  int _counter = 0;
  late Timer _timer;
  String _themeMode = '';

  // 1. BIRTH - Called once when created
  @override
  void initState() {
    super.initState();
    print('🐣 initState() called - Widget is born!');

    _counter = 0;

    // Start a timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });
    });
  }

  // 2. SETUP - Called after initState and when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🌱 didChangeDependencies() called');

    // Now we can access context!
    _themeMode = Theme.of(context).brightness == Brightness.dark
        ? 'Dark' : 'Light';
  }

  // 3. RENDER - Called many times
  @override
  Widget build(BuildContext context) {
    print('🎨 build() called');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Timer: $_counter seconds'),
            Text('Theme: $_themeMode'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter = 0;
                });
              },
              child: const Text('Reset Timer'),
            ),
          ],
        ),
      ),
    );
  }

  // 4. UPDATE - Called when parent rebuilds with new props
  @override
  void didUpdateWidget(LifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔄 didUpdateWidget() called');

    if (widget.title != oldWidget.title) {
      print('   Title changed: ${oldWidget.title} → ${widget.title}');
    }
  }

  // 5. DEATH - Called when widget is removed
  @override
  void dispose() {
    print('💀 dispose() called - Cleaning up!');
    _timer.cancel();  // Stop the timer
    super.dispose();
  }
}
```

---

## When Each Method Is Called

### Scenario 1: Widget First Created

```
createState()
    ↓
initState()
    ↓
didChangeDependencies()
    ↓
build()
```

### Scenario 2: User Taps Button (setState)

```
(User taps)
    ↓
setState()
    ↓
build()
```

### Scenario 3: Parent Rebuilds with New Props

```
(Parent rebuilds)
    ↓
didUpdateWidget()
    ↓
build()
```

### Scenario 4: Screen Rotates (Dependencies Change)

```
(Screen rotates)
    ↓
didChangeDependencies()
    ↓
build()
```

### Scenario 5: Widget Removed from Tree

```
(Widget removed)
    ↓
dispose()
    ↓
💀 Gone forever
```

---

## Best Practices for Each Method

### initState()

```dart
@override
void initState() {
  super.initState();  // ✅ FIRST

  // ✅ DO: Initialize variables
  count = 0;

  // ✅ DO: Create controllers
  controller = TextEditingController();

  // ✅ DO: Start timers
  timer = Timer.periodic(...);

  // ✅ DO: Subscribe to streams
  subscription = stream.listen(...);

  // ❌ DON'T: Access context
  // ❌ DON'T: Call setState()
}
```

### didChangeDependencies()

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();  // ✅ FIRST

  // ✅ DO: Access inherited widgets
  theme = Theme.of(context);
  mediaQuery = MediaQuery.of(context);

  // ⚠️ WARNING: Can be called multiple times!
  // Be careful with expensive operations
}
```

### build()

```dart
@override
Widget build(BuildContext context) {
  // ✅ DO: Return widget tree
  // ✅ DO: Keep it simple and fast

  // ❌ DON'T: Call setState()
  // ❌ DON'T: Do async work
  // ❌ DON'T: Heavy computations

  return Container();
}
```

### didUpdateWidget()

```dart
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);  // ✅ FIRST

  // ✅ DO: Compare old and new props
  if (widget.value != oldWidget.value) {
    // React to change
  }

  // ✅ DO: Reset state when needed
  setState(() {
    localValue = widget.value;
  });
}
```

### dispose()

```dart
@override
void dispose() {
  // ✅ DO: Clean up everything
  controller.dispose();
  timer.cancel();
  subscription.cancel();

  super.dispose();  // ✅ LAST

  // ❌ DON'T: Call setState()
  // ❌ DON'T: Access context
}
```

---

## Common Mistakes

### Mistake 1: Forgetting super Calls

```dart
// ❌ WRONG: Missing super.initState()
@override
void initState() {
  count = 0;  // Will cause errors!
}

// ✅ RIGHT: Always call super first
@override
void initState() {
  super.initState();  // ✅ First!
  count = 0;
}

// ⚠️ EXCEPTION: dispose() - super is LAST
@override
void dispose() {
  controller.dispose();
  super.dispose();  // ✅ Last!
}
```

### Mistake 2: Using Context Too Early

```dart
// ❌ WRONG: Context not ready yet
@override
void initState() {
  super.initState();
  theme = Theme.of(context);  // ERROR!
}

// ✅ RIGHT: Use didChangeDependencies
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  theme = Theme.of(context);  // ✅ Works!
}
```

### Mistake 3: Not Disposing Resources

```dart
// ❌ WRONG: Memory leak!
class _MyState extends State<MyWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(...);
  }
  // Missing dispose! Timer runs forever! 💀
}

// ✅ RIGHT: Always clean up
@override
void dispose() {
  timer.cancel();  // ✅ Stop the timer
  super.dispose();
}
```

---

## Summary

| Method | When Called | Purpose |
|--------|-------------|---------|
| createState() | Once | Creates State object |
| initState() | Once at start | Setup, initialization |
| didChangeDependencies() | After init, when deps change | Access context, inherited widgets |
| build() | Many times | Create widget tree |
| didUpdateWidget() | When parent rebuilds | Compare old/new props |
| dispose() | Once at end | Cleanup resources |

**Remember the order:**
1. initState() - Birth
2. didChangeDependencies() - Growing
3. build() - Living (many times)
4. didUpdateWidget() - Changing (when needed)
5. dispose() - Death

---

## Practice Challenge

Create a widget that:
1. Starts a timer in initState()
2. Shows elapsed time in build()
3. Prints the current theme in didChangeDependencies()
4. Cancels timer in dispose()

<details>
<summary>Hint</summary>

```dart
late Timer _timer;
int _seconds = 0;

@override
void initState() {
  super.initState();
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() => _seconds++);
  });
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}
```

</details>

---

**Next:** Learn real-world examples of StatefulWidget in action!

---

**Navigation:**
- **Previous:** [04a-StatefulIntro.md](04a-StatefulIntro.md) - Introduction to StatefulWidget
- **Next:** [04c-StatefulExamples.md](04c-StatefulExamples.md) - Real-World Examples
- **Up:** [Level 05 Theory](../README.md)
