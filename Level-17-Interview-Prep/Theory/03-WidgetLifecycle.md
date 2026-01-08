# Widget Lifecycle - Interview Deep Dive

Master the widget lifecycle - a favorite interview topic!

---

## Complete StatefulWidget Lifecycle

### The Full Journey

```
╔════════════════════════════════════════════════════════════╗
║                  WIDGET LIFECYCLE                          ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  1. Constructor                                            ║
║     └─> MyWidget() created                                 ║
║                                                            ║
║  2. createState()                                          ║
║     └─> Creates State object (called ONCE)                 ║
║                                                            ║
║  3. initState()                                            ║
║     └─> Initialize data, start listeners (called ONCE)     ║
║                                                            ║
║  4. didChangeDependencies()                                ║
║     └─> InheritedWidget dependencies changed              ║
║                                                            ║
║  5. build()                                                ║
║     └─> Creates widget tree (called MANY times)            ║
║         │                                                  ║
║         ↓                                                  ║
║  ┌──────────────────────┐                                 ║
║  │  Widget on screen    │                                 ║
║  └──────────────────────┘                                 ║
║         │                                                  ║
║         ↓                                                  ║
║  setState() or parent rebuild?                             ║
║         │                                                  ║
║         ├─> YES ──> Go back to build()                     ║
║         │                                                  ║
║         ├─> Widget config changed? ──> didUpdateWidget()   ║
║         │                              └─> build()         ║
║         │                                                  ║
║         └─> Widget removed?                                ║
║              │                                             ║
║              ↓                                             ║
║  6. deactivate()                                           ║
║     └─> Widget removed from tree (temporarily)            ║
║                                                            ║
║  7. dispose()                                              ║
║     └─> Clean up resources (called ONCE)                   ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

## Q1: Explain initState() - When and Why?

**Answer:**

`initState()` is called ONCE when the State object is created. Use it to initialize data.

```dart
class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();  // ⚠️ MUST call this first!

    print('initState called - Setting up timer');

    // ✅ Good: Start timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });

    // ✅ Good: Fetch initial data
    _fetchUserData();

    // ✅ Good: Add listeners
    someController.addListener(_onControllerChanged);
  }

  Future<void> _fetchUserData() async {
    // Fetch data from API
  }

  void _onControllerChanged() {
    // Handle controller changes
  }

  @override
  void dispose() {
    _timer.cancel();  // ⚠️ Clean up!
    someController.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Seconds: $_seconds');
  }
}
```

**What you CAN do in initState:**
- ✅ Initialize variables
- ✅ Start timers
- ✅ Add listeners
- ✅ Start async operations (fetchData)
- ✅ Subscribe to streams

**What you CANNOT do in initState:**
- ❌ Use BuildContext for things that depend on InheritedWidget
- ❌ Call setState() (not needed, build will be called automatically)

**Memory tip:** initState = "Set up shop before opening"

---

## Q2: Explain dispose() - When and Why?

**Answer:**

`dispose()` is called ONCE when the State object is permanently removed. Use it to clean up resources.

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;
  late StreamSubscription _subscription;
  Timer? _timer;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set up resources
    _controller = AnimationController(vsync: this, ...);
    _subscription = someStream.listen(...);
    _timer = Timer.periodic(...);
  }

  @override
  void dispose() {
    print('dispose called - Cleaning up');

    // ✅ Cancel timers
    _timer?.cancel();

    // ✅ Dispose controllers
    _controller.dispose();
    _textController.dispose();

    // ✅ Cancel stream subscriptions
    _subscription.cancel();

    // ✅ Remove listeners
    someObject.removeListener(_myListener);

    super.dispose();  // ⚠️ MUST call this last!
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**What to clean up in dispose:**
- ✅ AnimationController
- ✅ TextEditingController
- ✅ ScrollController
- ✅ FocusNode
- ✅ Timers
- ✅ Stream subscriptions
- ✅ Listeners

**Why it's important:**
- Prevents memory leaks
- Stops background tasks
- Releases system resources

**Memory tip:** dispose = "Close shop at end of day"

---

## Q3: What is didChangeDependencies() and when is it called?

**Answer:**

Called when a dependency (InheritedWidget) changes.

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('didChangeDependencies called');

    // ✅ Safe to use BuildContext here
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // This runs when:
    // - First time (after initState)
    // - When InheritedWidget above this widget changes
  }

  @override
  Widget build(BuildContext context) {
    // Can also use context here
    final color = Theme.of(context).primaryColor;
    return Container(color: color);
  }
}
```

**When it's called:**
1. After `initState()` (first time)
2. When `Theme` changes
3. When `MediaQuery` changes (rotation, keyboard)
4. When any `InheritedWidget` ancestor changes

**initState vs didChangeDependencies:**
```dart
@override
void initState() {
  super.initState();

  // ❌ RISKY - InheritedWidget might not be ready
  final theme = Theme.of(context);  // Might fail!
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  // ✅ SAFE - InheritedWidget is ready
  final theme = Theme.of(context);  // Always works!
}
```

**Memory tip:** Use `didChangeDependencies` when you need context for InheritedWidget

---

## Q4: What is didUpdateWidget() and when is it called?

**Answer:**

Called when parent rebuilds this widget with different configuration.

```dart
class CounterDisplay extends StatefulWidget {
  final int initialCount;  // Configuration from parent

  const CounterDisplay({required this.initialCount});

  @override
  _CounterDisplayState createState() => _CounterDisplayState();
}

class _CounterDisplayState extends State<CounterDisplay> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;  // Use initial value
  }

  @override
  void didUpdateWidget(CounterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('didUpdateWidget called');
    print('Old value: ${oldWidget.initialCount}');
    print('New value: ${widget.initialCount}');

    // Update local state if needed
    if (widget.initialCount != oldWidget.initialCount) {
      setState(() {
        _count = widget.initialCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('Count: $_count');
  }
}

// Parent widget
class Parent extends StatefulWidget {
  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CounterDisplay(initialCount: _value),  // Child gets new config
        ElevatedButton(
          onPressed: () {
            setState(() {
              _value++;  // This triggers didUpdateWidget in child!
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**When it's called:**
- Parent rebuilds with different widget configuration
- Widget properties change

**Memory tip:** didUpdateWidget = "Boss changed your instructions"

---

## Q5: What is deactivate() and when is it called?

**Answer:**

Called when widget is removed from the tree (but might be reinserted).

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void deactivate() {
    print('deactivate - Widget removed from tree');
    super.deactivate();

    // Widget is being removed
    // But dispose() hasn't been called yet
    // Widget might be reinserted elsewhere
  }

  @override
  void dispose() {
    print('dispose - Widget permanently destroyed');
    super.dispose();

    // Now widget is truly gone
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**When it's called:**
- Widget removed from tree (navigation, conditional rendering)
- Widget moved to different location in tree

**Deactivate vs Dispose:**
```
deactivate() → Widget might come back
dispose()    → Widget is gone forever
```

**Most common use:** Rarely needed! Usually you only need `dispose()`.

---

## Complete Example with All Lifecycle Methods

```dart
class LifecycleDemo extends StatefulWidget {
  final String title;

  const LifecycleDemo({Key? key, required this.title}) : super(key: key);

  @override
  _LifecycleDemoState createState() {
    print('▶ createState()');
    return _LifecycleDemoState();
  }
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  int _counter = 0;
  late Timer _timer;

  // ════════════════════════════════════════════════════════════
  // 1. INITIALIZATION
  // ════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    print('1️⃣ initState() - Called ONCE');
    print('   Setting up timer...');

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {  // ⚠️ Always check mounted before setState
        setState(() {
          _counter++;
        });
      }
    });
  }

  // ════════════════════════════════════════════════════════════
  // 2. DEPENDENCY CHANGES
  // ════════════════════════════════════════════════════════════

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('2️⃣ didChangeDependencies() - InheritedWidget changed');

    // Safe to use context here
    final theme = Theme.of(context);
    print('   Current theme: ${theme.brightness}');
  }

  // ════════════════════════════════════════════════════════════
  // 3. BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    print('3️⃣ build() - Building UI (counter: $_counter)');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $_counter'),
            Text('Check console for lifecycle logs'),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 4. UPDATE
  // ════════════════════════════════════════════════════════════

  @override
  void didUpdateWidget(LifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('4️⃣ didUpdateWidget() - Widget config changed');
    print('   Old title: ${oldWidget.title}');
    print('   New title: ${widget.title}');
  }

  // ════════════════════════════════════════════════════════════
  // 5. DEACTIVATION
  // ════════════════════════════════════════════════════════════

  @override
  void deactivate() {
    print('5️⃣ deactivate() - Widget removed from tree');
    super.deactivate();
  }

  // ════════════════════════════════════════════════════════════
  // 6. DISPOSAL
  // ════════════════════════════════════════════════════════════

  @override
  void dispose() {
    print('6️⃣ dispose() - Cleaning up');
    _timer.cancel();
    print('   Timer cancelled');
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // HELPER: Check if widget is still in tree
  // ════════════════════════════════════════════════════════════

  void _safeSetState() {
    if (mounted) {  // Check before setState
      setState(() {
        // Update state
      });
    }
  }
}
```

---

## Common Interview Scenarios

### Q6: What happens when you navigate away from a screen?

**Answer:**
```dart
// Screen A → Screen B (push)
// Screen A lifecycle:
// - deactivate()  (A removed from tree)
// - (NOT dispose - A is still in navigation stack)

// Screen B → Screen A (pop)
// Screen B lifecycle:
// - deactivate()
// - dispose()  (B is gone forever)

// Screen A lifecycle:
// - (NO initState - A was never disposed)
// - build()  (A becomes visible again)
```

---

### Q7: What is the `mounted` property?

**Answer:**

`mounted` tells you if the State object is still in the widget tree.

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void> loadData() async {
    final data = await fetchFromAPI();

    // ❌ WRONG - might crash if widget was disposed
    setState(() {
      this.data = data;
    });

    // ✅ CORRECT - check if still mounted
    if (mounted) {
      setState(() {
        this.data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**When mounted is false:**
- After `dispose()` is called
- Widget removed from tree

**Why it matters:**
- Calling `setState()` on unmounted widget causes error
- Always check `mounted` before `setState()` in async operations

---

### Q8: Can you call setState in initState?

**Answer:**

**Technically yes, but you shouldn't!**

```dart
@override
void initState() {
  super.initState();

  // ❌ DON'T - Not needed!
  setState(() {
    _count = 0;
  });

  // ✅ DO - Direct assignment
  _count = 0;  // build() will be called anyway
}
```

**Why you don't need setState in initState:**
- `build()` is automatically called after `initState()`
- No need to trigger rebuild manually

**Exception - async setState:**
```dart
@override
void initState() {
  super.initState();

  // ✅ This is OK (async operation)
  Future.delayed(Duration(seconds: 1), () {
    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  });
}
```

---

## Lifecycle Comparison Table

| Method | Called When | How Many Times | Purpose |
|--------|------------|----------------|---------|
| `createState()` | Widget created | Once | Create State object |
| `initState()` | State created | Once | Initialize data, start listeners |
| `didChangeDependencies()` | After initState, or dependency changes | Multiple | React to InheritedWidget changes |
| `build()` | After init, or setState | Many | Build UI |
| `didUpdateWidget()` | Parent updates config | Multiple | React to config changes |
| `setState()` | You call it | Many | Trigger rebuild |
| `deactivate()` | Removed from tree | Multiple | Pause operations |
| `dispose()` | Permanently removed | Once | Clean up resources |

---

## Quick Quiz Scenarios

### Scenario 1: Timer that updates UI

```dart
// ❌ Memory leak - timer never cancelled
class BadTimer extends StatefulWidget {
  @override
  _BadTimerState createState() => _BadTimerState();
}

class _BadTimerState extends State<BadTimer> {
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
    // ❌ No way to cancel this timer!
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_seconds');
  }
}

// ✅ Proper cleanup
class GoodTimer extends StatefulWidget {
  @override
  _GoodTimerState createState() => _GoodTimerState();
}

class _GoodTimerState extends State<GoodTimer> {
  int _seconds = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();  // ✅ Clean up!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_seconds');
  }
}
```

---

### Scenario 2: Async data loading

```dart
class DataWidget extends StatefulWidget {
  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  String? _data;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final data = await fetchFromAPI();

    // ✅ Check mounted before setState
    if (mounted) {
      setState(() {
        _data = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();
    return Text(_data ?? 'No data');
  }
}
```

---

## Summary - Must Remember

**Initialization Order:**
```
Constructor → createState → initState → didChangeDependencies → build
```

**Update Cycle:**
```
setState → build
Parent updates → didUpdateWidget → build
```

**Cleanup:**
```
Navigate away → deactivate → (maybe dispose)
```

**Golden Rules:**
1. Always call `super` in lifecycle methods
2. Initialize in `initState`, clean up in `dispose`
3. Check `mounted` before async `setState`
4. Use `const` constructors when possible
5. Cancel timers/streams in `dispose`

---

**Continue to:** `04-StateManagement.md`
