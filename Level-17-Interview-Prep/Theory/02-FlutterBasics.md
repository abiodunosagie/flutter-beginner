# Flutter Basics - Interview Questions

## The Big Idea In One Sentence

> Expect the classics: "everything is a widget," Stateless vs Stateful, what `BuildContext` is, and hot reload vs hot restart, know these cold and explain them simply.

Essential Flutter concepts every interviewer expects you to know!

---

## Widgets

### Q1: What's the difference between StatelessWidget and StatefulWidget?

**Answer:**

```dart
// StatelessWidget - NEVER changes (immutable)
class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Welcome!');  // Always the same
  }
}

// StatefulWidget - CAN change (has mutable state)
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;  // This can change!

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');  // Updates when count changes
  }
}
```

**Memory tip:**
- **Stateless** = Static sign (never changes)
- **Stateful** = Digital clock (updates over time)

**When to use each:**
- Stateless: Labels, icons, images, static layouts
- Stateful: Forms, animations, user interactions, timers

---

### Q2: What is the widget tree?

**Answer:**
The widget tree is the hierarchy of all widgets in your app.

```dart
MaterialApp                    // Root
  └─ Scaffold
      ├─ AppBar
      │   └─ Text('Title')
      └─ Column
          ├─ Text('Hello')
          ├─ Image(...)
          └─ ElevatedButton
              └─ Text('Click')
```

**Why it matters:**
- Flutter rebuilds widgets from top to bottom
- Parent widgets pass data down to children
- `BuildContext` represents position in this tree

**Memory tip:** Think of it like a family tree - parents have children, children have siblings.

---

### Q3: What is BuildContext?

**Answer:**
`BuildContext` is a handle to the location of a widget in the widget tree.

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //              ^^^^^^^^^^^^^^ This tells you WHERE you are in the tree

    // Use context to:
    // 1. Access theme
    final color = Theme.of(context).primaryColor;

    // 2. Navigate
    Navigator.of(context).push(...);

    // 3. Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(...);

    // 4. Get screen size
    final size = MediaQuery.of(context).size;

    return Container();
  }
}
```

**Memory tip:** Context = Your GPS location in the widget tree

**Common mistake:**
```dart
// ❌ Wrong - using context before Scaffold exists
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This context doesn't have Scaffold yet!
    ScaffoldMessenger.of(context).showSnackBar(...);  // ❌ Error!

    return Scaffold(...);
  }
}

// ✅ Correct - use Builder or separate widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (newContext) {
          // This newContext has Scaffold!
          ScaffoldMessenger.of(newContext).showSnackBar(...);  // ✅ Works
          return Container();
        },
      ),
    );
  }
}
```

---

### Q4: What's the difference between `const` and `final` in widgets?

**Answer:**

```dart
// const - Compile-time constant (never changes, created once)
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('Hello');  // ✅ Same widget reused every time
  }
}

// Without const - New widget created every rebuild
return Text('Hello');  // ❌ Less efficient

// When you CAN'T use const
final userName = 'John';
return Text(userName);  // ❌ Can't use const (userName is runtime value)

// When you CAN use const
return const SizedBox(height: 20);  // ✅ Always the same
return const Icon(Icons.home);      // ✅ Always the same
```

**Memory tip:** Use `const` for widgets that NEVER change - Flutter will reuse them!

**Benefits:**
- Better performance (fewer rebuilds)
- Less memory usage
- Faster app

---

### Q5: What's the difference between `hot reload` and `hot restart`?

**Answer:**

```
Hot Reload (⚡ Fast - 1 second)
─────────────────────────────
• Injects updated code
• KEEPS app state (variables, scroll position)
• Only UI changes visible
• Doesn't re-run main()

Use when: Changing UI, fixing typos, adjusting layout


Hot Restart (🔄 Slower - 5 seconds)
────────────────────────────────
• Restarts the app
• LOSES app state (back to initial state)
• Re-runs main()
• All changes applied

Use when: Changing main(), adding packages, global variables
```

**Example:**
```dart
void main() {
  const apiKey = 'abc123';  // Changing this needs HOT RESTART
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello');  // Changing this only needs HOT RELOAD
  }
}
```

---

## Layout & Rendering

### Q6: What's the difference between `Container`, `SizedBox`, and `Padding`?

**Answer:**

```dart
// Container - Swiss Army knife (can do many things)
Container(
  width: 100,
  height: 100,
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Text('Hello'),
)

// SizedBox - Just for sizing (lighter, faster)
SizedBox(
  width: 100,
  height: 100,
  child: Text('Hello'),
)

// Padding - Just for padding (most specific)
Padding(
  padding: EdgeInsets.all(10),
  child: Text('Hello'),
)
```

**When to use:**
- **Container**: Need decoration, alignment, or multiple properties
- **SizedBox**: Just need to set size (more efficient than Container)
- **Padding**: Just need padding (most efficient)

**Memory tip:** Use the most specific widget for better performance!

---

### Q7: Explain the difference between `MainAxisAlignment` and `CrossAxisAlignment`

**Answer:**

```dart
// In Row (horizontal)
Row(
  mainAxisAlignment: MainAxisAlignment.center,   // Horizontal (←→)
  crossAxisAlignment: CrossAxisAlignment.start,  // Vertical (↑↓)
  children: [Text('A'), Text('B')],
)

// In Column (vertical)
Column(
  mainAxisAlignment: MainAxisAlignment.center,   // Vertical (↑↓)
  crossAxisAlignment: CrossAxisAlignment.start,  // Horizontal (←→)
  children: [Text('A'), Text('B')],
)
```

**Visual:**
```
Row:
  main axis  →  →  →  (direction children are laid out)
  cross axis ↓        (perpendicular to main)

Column:
  main axis  ↓        (direction children are laid out)
             ↓
             ↓
  cross axis →  →  →  (perpendicular to main)
```

**Memory tip:** Main = direction of layout, Cross = perpendicular

---

### Q8: What is `Expanded` vs `Flexible`?

**Answer:**

```dart
// Expanded - MUST fill available space
Row(
  children: [
    Expanded(
      child: Container(color: Colors.red),  // Takes ALL remaining space
    ),
    Container(width: 100, color: Colors.blue),
  ],
)

// Flexible - CAN fill space (but doesn't have to)
Row(
  children: [
    Flexible(
      child: Container(color: Colors.red),  // Takes space if needed
    ),
    Container(width: 100, color: Colors.blue),
  ],
)
```

**With flex property:**
```dart
Row(
  children: [
    Expanded(flex: 2, child: Container(color: Colors.red)),   // 2 parts
    Expanded(flex: 1, child: Container(color: Colors.blue)),  // 1 part
    // Red gets 2/3 of space, Blue gets 1/3
  ],
)
```

**Memory tip:**
- **Expanded** = Must take space (like flex: 1 by default)
- **Flexible** = Can shrink or grow (more flexible)

---

## Navigation

### Q9: Explain Navigator.push vs Navigator.pop

**Answer:**

```dart
// push - Go to new screen (add to stack)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);

// pop - Go back (remove from stack)
Navigator.pop(context);

// With return value
// Screen A:
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);
print(result);  // 'Success!'

// Screen B:
Navigator.pop(context, 'Success!');  // Return value
```

**Visual:**
```
Stack before push:        Stack after push:
┌─────────────┐          ┌─────────────┐
│   Screen A  │          │   Screen B  │ ← Top (visible)
└─────────────┘          ├─────────────┤
                         │   Screen A  │
                         └─────────────┘

After pop:
┌─────────────┐
│   Screen A  │ ← Back to Screen A
└─────────────┘
```

**Memory tip:** Push = Add to stack, Pop = Remove from stack

---

### Q10: What's the difference between `Navigator.push` and `Navigator.pushReplacement`?

**Answer:**

```dart
// push - Adds new screen (can go back)
Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));

// pushReplacement - Replaces current screen (can't go back)
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

// pushAndRemoveUntil - Clear all and push new screen
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (route) => false,  // Remove all previous routes
);
```

**When to use:**
```dart
// Login → Home: Use pushReplacement (can't go back to login)
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

// Product List → Product Detail: Use push (can go back)
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen()));

// Onboarding → Home: Use pushAndRemoveUntil (clear onboarding screens)
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
  (route) => false,
);
```

---

## Keys

### Q11: What are Keys and why do we need them?

**Answer:**
Keys help Flutter identify widgets uniquely, especially when reordering.

```dart
// Without keys - Flutter gets confused
List<Widget> items = [
  TextField(),  // Which one is which when reordered?
  TextField(),
];

// With keys - Flutter knows which is which
List<Widget> items = [
  TextField(key: ValueKey('email')),
  TextField(key: ValueKey('password')),
];
```

**Types of Keys:**

```dart
// ValueKey - For simple values
ValueKey('user-123')

// ObjectKey - For objects
ObjectKey(user)

// UniqueKey - Always unique (generates new each time)
UniqueKey()

// GlobalKey - Access widget from anywhere (use sparingly!)
final formKey = GlobalKey<FormState>();
Form(key: formKey, ...)
formKey.currentState?.validate();
```

**When to use:**
- Reorderable lists
- Stateful widgets in lists
- Forms (GlobalKey<FormState>)
- Animations

**Memory tip:** Key = ID card for widgets

---

## Async & State

### Q12: What's the difference between `FutureBuilder` and `StreamBuilder`?

**Answer:**

```dart
// FutureBuilder - ONE-TIME async data
FutureBuilder<User>(
  future: fetchUser(),  // Runs once
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return Text('Hello ${snapshot.data!.name}');
  },
)

// StreamBuilder - CONTINUOUS data stream
StreamBuilder<int>(
  stream: countdownStream(),  // Keeps receiving updates
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('${snapshot.data}');  // Updates as stream emits
    }
    return Text('Waiting...');
  },
)
```

**Memory tip:**
- **FutureBuilder** = Single delivery (one package)
- **StreamBuilder** = Continuous feed (live TV)

---

### Q13: What is `setState` and when should you use it?

**Answer:**

```dart
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  void increment() {
    // ❌ WRONG - Won't update UI
    count++;

    // ✅ CORRECT - Tells Flutter to rebuild
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

**Rules:**
1. Only use in StatefulWidget (not StatelessWidget)
2. Only modify state inside setState
3. Keep setState fast (no heavy computations)

**Common mistake:**
```dart
// ❌ WRONG - async in setState
setState(() async {
  final data = await fetchData();  // Don't do this!
  this.data = data;
});

// ✅ CORRECT - async before setState
void loadData() async {
  final data = await fetchData();
  setState(() {
    this.data = data;  // Only update in setState
  });
}
```

---

## Performance

### Q14: What is `const constructor` and why is it important?

**Answer:**

```dart
class MyWidget extends StatelessWidget {
  // const constructor - allows widget to be const
  const MyWidget({super.key});  // Notice 'const'

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');  // Now you can use const here
  }
}

// Usage
const MyWidget()  // ✅ Can use const because constructor is const
```

**Benefits:**
- Widget created once at compile time
- Reused instead of recreated
- Better performance
- Less memory

**When parent rebuilds:**
```dart
class Parent extends StatefulWidget {
  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),           // Rebuilds every time
        const MyWidget(),         // ✅ Never rebuilds (const)
        MyWidget(),               // ❌ Rebuilds every time
      ],
    );
  }
}
```

---

### Q15: What is the widget lifecycle?

**Answer:**

**StatelessWidget lifecycle (simple):**
```
createWidget → build → render → DONE
```

**StatefulWidget lifecycle (detailed):**
```
1. createState()          → Called once when widget created
   ↓
2. initState()            → Initialize state (called once)
   ↓
3. didChangeDependencies() → When dependencies change (InheritedWidget)
   ↓
4. build()                → Build UI (called many times)
   ↓
5. didUpdateWidget()      → When parent updates widget config
   ↓
6. setState()             → Triggers rebuild (back to build)
   ↓
7. deactivate()           → Widget removed from tree temporarily
   ↓
8. dispose()              → Clean up (called once, widget destroyed)
```

**Example:**
```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() {
    print('1. createState');
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    print('2. initState - Initialize data here');
    // Start timers, fetch data, setup listeners
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('3. didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('4. build');
    return Text('Hello');
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('5. didUpdateWidget');
  }

  @override
  void deactivate() {
    print('6. deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('7. dispose - Clean up here');
    // Cancel timers, close streams, remove listeners
    super.dispose();
  }
}
```

**Memory tip:** init → build → update → dispose

---

## Quick Fire

### Q16: What is `MaterialApp` vs `WidgetsApp` vs `CupertinoApp`?

**Answer:**
```dart
// MaterialApp - Material Design (Android style)
MaterialApp(home: Text('Hello'))

// CupertinoApp - iOS style
CupertinoApp(home: Text('Hello'))

// WidgetsApp - Base (no design system)
WidgetsApp(home: Text('Hello'))
```

---

### Q17: What is `Scaffold`?

**Answer:**
Scaffold provides Material Design layout structure:
```dart
Scaffold(
  appBar: AppBar(title: Text('Title')),        // Top bar
  body: Center(child: Text('Content')),        // Main content
  floatingActionButton: FloatingActionButton(...),  // FAB
  drawer: Drawer(...),                         // Side menu
  bottomNavigationBar: BottomNavigationBar(...),   // Bottom nav
)
```

---

### Q18: What is `MediaQuery`?

**Answer:**
Gets device information:
```dart
final size = MediaQuery.of(context).size;
final width = size.width;   // Screen width
final height = size.height; // Screen height

final padding = MediaQuery.of(context).padding;  // Safe area insets
final orientation = MediaQuery.of(context).orientation;  // Portrait/Landscape
```

---

### Q19: What is `Theme`?

**Answer:**
Defines app-wide styles:
```dart
// Define theme
MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    textTheme: TextTheme(...),
  ),
)

// Use theme
final color = Theme.of(context).primaryColor;
final textStyle = Theme.of(context).textTheme.headline1;
```

---

## Summary Table

| Concept | Key Point |
|---------|-----------|
| StatelessWidget | Immutable, never changes |
| StatefulWidget | Has mutable state, can change |
| BuildContext | Location in widget tree |
| const widget | Created once, reused |
| Hot Reload | Fast, keeps state |
| Hot Restart | Slow, resets state |
| Expanded | Must fill space |
| Flexible | Can fill space |
| Navigator.push | Add to stack |
| Navigator.pop | Remove from stack |
| FutureBuilder | One-time async |
| StreamBuilder | Continuous async |
| setState | Trigger rebuild |
| Keys | Identify widgets uniquely |

---

## Assignment

Answer each out loud, then check.

### Problem 1: Stateless vs Stateful

When do you use a StatelessWidget vs a StatefulWidget?

### Problem 2: Hot reload vs hot restart

What is the difference?

### Problem 3: BuildContext

In one sentence, what is `BuildContext`?

---

## Assignment Answers

### Problem 1: Stateless vs Stateful

Stateless when the widget never changes after it is built (it only depends on its inputs). Stateful when it has data that changes over time and needs `setState` to rebuild.

### Problem 2: Hot reload vs hot restart

Hot reload injects code changes and keeps the app's current state. Hot restart restarts the app from scratch, losing state.

### Problem 3: BuildContext

It is a handle to a widget's place in the widget tree, used to look things up (theme, navigator, providers) relative to that location.

---

**Continue to:** `03-WidgetLifecycle.md`
