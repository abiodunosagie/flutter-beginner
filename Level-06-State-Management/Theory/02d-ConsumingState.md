# Part 4: Using Your State (watch, read, and Consumer)

Now the fun part - let's USE the state in your widgets!

---

## Two Ways to Access State

There are two main ways to get your state:

```
1. context.watch<T>()  ← Rebuilds when state changes
2. context.read<T>()   ← Doesn't rebuild, just gets it once
```

---

## Method 1: context.watch() - For Displaying Data

Use `watch()` when you want to **show** the data:

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Watch the Counter - rebuild when it changes!
    final counter = context.watch<Counter>();
    
    return Text('Count: ${counter.count}');
    // When counter changes, this Text rebuilds! ✅
  }
}
```

### When to Use watch():
- ✅ Displaying data in Text, Image, etc.
- ✅ When you want the widget to update automatically
- ✅ In the `build()` method

---

## Method 2: context.read() - For Calling Methods

Use `read()` when you want to **change** the data:

```dart
class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Read the Counter - don't rebuild!
        context.read<Counter>().increment();
      },
      child: const Text('+1'),
    );
  }
}
```

### When to Use read():
- ✅ In button callbacks (`onPressed`, `onTap`)
- ✅ When calling methods that change state
- ✅ When you DON'T want to rebuild

---

## watch() vs read() - The Complete Picture

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WATCH: Get and display
    final counter = context.watch<Counter>();

    return Column(
      children: [
        // Shows current count - updates automatically!
        Text('Count: ${counter.count}'),
        
        ElevatedButton(
          onPressed: () {
            // READ: Just call the method
            context.read<Counter>().increment();
          },
          child: const Text('+1'),
        ),
      ],
    );
  }
}
```

---

## Visual Explanation

```
When counter changes from 5 → 6:

Using watch():
─────────────
Text('Count: ${context.watch<Counter>().count}')
                        ^
                        Watches for changes!
Rebuilds automatically! ✅
Shows: 6


Using read():
────────────
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();
            ^
            Just gets it once!
  }
)
Doesn't rebuild ✅ (we don't need it to!)
```

---

## Method 3: Consumer Widget

Another way to access state - useful for optimizing rebuilds:

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Text('Count: ${counter.count}');
      },
    );
  }
}
```

### When to Use Consumer:
- When only PART of your widget needs to rebuild
- For better performance

---

## Complete Example: Counter App

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WATCH: Display the count
            Text(
              'Count: ${context.watch<Counter>().count}',
              style: const TextStyle(fontSize: 48),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // READ: Decrement
                ElevatedButton(
                  onPressed: () {
                    context.read<Counter>().decrement();
                  },
                  child: const Text('-1'),
                ),
                
                const SizedBox(width: 10),
                
                // READ: Increment
                ElevatedButton(
                  onPressed: () {
                    context.read<Counter>().increment();
                  },
                  child: const Text('+1'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // READ: Reset
            TextButton(
              onPressed: () {
                context.read<Counter>().reset();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## The Golden Rules

### Rule 1: Use watch() to Display
```dart
// ✅ GOOD: Watching to display
Text('${context.watch<Counter>().count}')

// ❌ BAD: Reading to display
Text('${context.read<Counter>().count}')  // Won't update!
```

### Rule 2: Use read() in Callbacks
```dart
// ✅ GOOD: Reading in callback
onPressed: () {
  context.read<Counter>().increment();
}

// ❌ BAD: Watching in callback
onPressed: () {
  context.watch<Counter>().increment();  // Causes errors!
}
```

---

## Common Mistakes

### ❌ Mistake 1: Using watch() in onPressed
```dart
ElevatedButton(
  onPressed: () {
    context.watch<Counter>().increment();  // ❌ Error!
  },
  child: const Text('+1'),
)
```

Error: "watch() called outside of build()"

### ✅ Fix: Use read()
```dart
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();  // ✅ Correct!
  },
  child: const Text('+1'),
)
```

---

## Quick Reference Card

| Want to... | Use... | Example |
|------------|--------|---------|
| Display data | `watch()` | `Text('${context.watch<Counter>().count}')` |
| Call a method | `read()` | `context.read<Counter>().increment()` |
| Optimize rebuilds | `Consumer` | `Consumer<Counter>(builder: ...)` |

---

## Summary

✅ Use `context.watch<T>()` to display data (rebuilds when data changes)
✅ Use `context.read<T>()` to call methods (doesn't rebuild)
✅ Use `Consumer<T>` for partial widget rebuilds
✅ Watch in `build()`, read in callbacks!

---

**Congratulations!** You now know the basics of Provider! 🎉

Next, you'll learn advanced Provider patterns and then move on to Riverpod and BLoC.

---

## Navigation

⬅️ **Previous:** [Providing State](02c-ProvidingState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Multiple Providers](03a-MultipleProviders.md)
