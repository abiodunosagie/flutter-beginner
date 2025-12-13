# StatefulWidget: Interactive, Changing Widgets

## What Is a StatefulWidget?

A **StatefulWidget** is a widget that **can change** over time. Think of it like a light switch - you can turn it on and off, and it remembers its current position.

```dart
// This counter can change when you tap the button
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;  // This can change!

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}
```

---

## When to Use StatefulWidget

Use StatefulWidget when your UI needs to:

| Situation | Use StatefulWidget? |
|-----------|---------------------|
| Counter that increments | ✅ Yes |
| Toggle switch (on/off) | ✅ Yes |
| Form with text input | ✅ Yes |
| Loading spinner | ✅ Yes |
| Animations | ✅ Yes |
| Static text display | ❌ No (use StatelessWidget) |
| Fixed icon | ❌ No (use StatelessWidget) |

---

## The Two-Part Structure

StatefulWidget has **two classes**:

```
StatefulWidget (the configuration)
       │
       └── State (the data that changes)
```

### Why Two Classes?

```dart
// Part 1: The Widget (immutable, like a recipe)
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

// Part 2: The State (mutable, like the actual cake)
class _CounterState extends State<Counter> {
  int count = 0;  // Can change!

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

**Why?** Flutter can recreate widgets frequently, but State persists. This keeps your data safe while allowing efficient rebuilds.

---

## Basic Structure Explained

```dart
import 'package:flutter/material.dart';

// PART 1: The Widget Class
class MyWidget extends StatefulWidget {
  // Properties passed from parent (immutable)
  final String title;

  const MyWidget({
    super.key,
    required this.title,
  });

  // Creates the State object
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// PART 2: The State Class
class _MyWidgetState extends State<MyWidget> {
  // Mutable state variables
  int counter = 0;
  bool isActive = false;

  // Access widget properties with: widget.title

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),      // From the widget
        Text('Count: $counter'), // From the state
      ],
    );
  }
}
```

### Naming Convention

```dart
class MyWidget extends StatefulWidget { ... }
class _MyWidgetState extends State<MyWidget> { ... }
//    ^
//    Underscore = private to this file
```

---

## The Magic: setState()

To update the UI, you must call `setState()`:

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  void increment() {
    // ✅ This updates the UI
    setState(() {
      count++;
    });
  }

  void wrongWay() {
    // ❌ This does NOT update the UI
    count++;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: increment,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

### How setState Works

```
1. You call setState()
       │
       ▼
2. Flutter marks widget as "dirty"
       │
       ▼
3. Flutter calls build() again
       │
       ▼
4. New UI is rendered with new values
```

### setState Rules

```dart
// ✅ Good: Change state inside setState
setState(() {
  count++;
  isLoading = true;
  items.add(newItem);
});

// ✅ Also good: Change before, call setState after
count++;
isLoading = true;
setState(() {});  // Empty but triggers rebuild

// ❌ Bad: setState in build method
@override
Widget build(BuildContext context) {
  setState(() { });  // NEVER do this! Infinite loop!
  return Container();
}

// ❌ Bad: Async work inside setState
setState(() async {  // Don't do this!
  await fetchData();
});

// ✅ Good: Async work outside, setState after
Future<void> loadData() async {
  final data = await fetchData();
  setState(() {
    items = data;
  });
}
```

---

## Complete Example: Counter App

```dart
import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_count',
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Widget Lifecycle

State objects have a lifecycle:

```
createState()
     │
     ▼
initState()        ← Called once when created
     │
     ▼
didChangeDependencies()  ← Called when dependencies change
     │
     ▼
build()           ← Called to render UI
     │
     ▼
(user interaction or parent rebuild)
     │
     ▼
setState()        ← Triggers rebuild
     │
     ▼
build()           ← Called again
     │
     ▼
didUpdateWidget() ← Called if widget config changes
     │
     ▼
(eventually)
     │
     ▼
dispose()         ← Called when removed
```

### Lifecycle Methods

```dart
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when State is created
    // Good for: setup, initial data loading
    print('Widget created!');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called when dependencies (like Theme) change
    // Good for: reacting to inherited widget changes
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Called when parent rebuilds with new widget
    // Good for: comparing old and new props
    if (widget.title != oldWidget.title) {
      print('Title changed!');
    }
  }

  @override
  void dispose() {
    // Called when widget is removed permanently
    // Good for: cleanup (controllers, subscriptions)
    print('Widget destroyed!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

---

## Real-World Examples

### Example 1: Toggle Switch

```dart
class ToggleSwitch extends StatefulWidget {
  final String label;
  final void Function(bool)? onChanged;

  const ToggleSwitch({
    super.key,
    required this.label,
    this.onChanged,
  });

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool _isOn = false;

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.label),
        Switch(
          value: _isOn,
          onChanged: (value) {
            setState(() {
              _isOn = value;
            });
            widget.onChanged?.call(value);
          },
        ),
      ],
    );
  }
}
```

### Example 2: Favorite Button

```dart
class FavoriteButton extends StatefulWidget {
  final bool initialValue;
  final void Function(bool)? onChanged;

  const FavoriteButton({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: _toggle,
    );
  }
}
```

### Example 3: Loading Data

```dart
class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _users = ['Alice', 'Bob', 'Charlie'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load users';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadUsers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_users[index]),
        );
      },
    );
  }
}
```

### Example 4: Form with Validation

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Proceed with login...
    print('Logging in: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            obscureText: _obscurePassword,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

---

## Accessing Widget Properties

Use `widget.propertyName` to access the parent widget's properties:

```dart
class Greeting extends StatefulWidget {
  final String name;  // Property on the widget

  const Greeting({super.key, required this.name});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => tapCount++),
      child: Text(
        'Hello, ${widget.name}! Tapped $tapCount times',
        //        ^^^^^^^^^^^
        //        Access widget's property
      ),
    );
  }
}
```

---

## Common Mistakes

### Mistake 1: Forgetting setState

```dart
// ❌ WRONG: UI won't update
void increment() {
  count++;  // Changed but UI doesn't know!
}

// ✅ RIGHT: UI will update
void increment() {
  setState(() {
    count++;
  });
}
```

### Mistake 2: Calling setState After Dispose

```dart
// ❌ WRONG: Can crash
Future<void> loadData() async {
  final data = await api.fetch();
  setState(() {  // Widget might be gone!
    items = data;
  });
}

// ✅ RIGHT: Check if mounted
Future<void> loadData() async {
  final data = await api.fetch();
  if (mounted) {  // Check if still in tree
    setState(() {
      items = data;
    });
  }
}
```

### Mistake 3: Not Disposing Controllers

```dart
// ❌ WRONG: Memory leak
class _MyState extends State<MyWidget> {
  final controller = TextEditingController();
  // Never disposed!
}

// ✅ RIGHT: Clean up
class _MyState extends State<MyWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

### Mistake 4: Heavy Work in setState

```dart
// ❌ WRONG: Slow UI
setState(() {
  for (var i = 0; i < 1000000; i++) {
    // Heavy computation
  }
  result = computed;
});

// ✅ RIGHT: Compute first, then setState
final computed = heavyComputation();
setState(() {
  result = computed;
});
```

---

## Tips for StatefulWidget

### Tip 1: Keep State Minimal

```dart
// ❌ Too much state
class _MyState extends State<MyWidget> {
  int count = 0;
  String computedLabel = 'Count: 0';  // Derived from count
}

// ✅ Better: Compute in build
class _MyState extends State<MyWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final label = 'Count: $count';  // Computed here
    return Text(label);
  }
}
```

### Tip 2: Extract Methods

```dart
// ✅ Clean and readable
class _CounterState extends State<Counter> {
  int count = 0;

  void _increment() => setState(() => count++);
  void _decrement() => setState(() => count--);
  void _reset() => setState(() => count = 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: _decrement, icon: Icon(Icons.remove)),
        Text('$count'),
        IconButton(onPressed: _increment, icon: Icon(Icons.add)),
      ],
    );
  }
}
```

---

## Summary

| Concept | Description |
|---------|-------------|
| StatefulWidget | Widget that can change |
| State class | Holds mutable data |
| setState() | Tells Flutter to rebuild |
| initState() | Called once when created |
| dispose() | Called when removed (cleanup) |
| widget.property | Access widget's properties |
| mounted | Check if widget is still in tree |

---

## Quick Quiz

**Q1:** Why does StatefulWidget have two classes?

<details>
<summary>Answer</summary>

Flutter can recreate widgets frequently for efficiency, but State objects persist between rebuilds. This separation allows Flutter to optimize while keeping your mutable data safe. The Widget is the immutable configuration; the State holds the changing data.

</details>

**Q2:** What happens if you change a variable without calling setState?

<details>
<summary>Answer</summary>

The variable changes in memory, but the UI won't update. Flutter doesn't know to rebuild the widget. You must call `setState()` to trigger a rebuild and see the new values on screen.

</details>

**Q3:** When should you use dispose()?

<details>
<summary>Answer</summary>

Use `dispose()` to clean up resources when the widget is removed permanently:
- Dispose TextEditingControllers
- Cancel stream subscriptions
- Stop animation controllers
- Remove listeners

Always call `super.dispose()` at the end.

</details>

---

**Next:** Learn how Flutter positions widgets with the Layout System.

---

**Continue to:** `05-LayoutSystem.md`
