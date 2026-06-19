# Creating Your Data Class (ChangeNotifier)

## The Big Idea In One Sentence

> A `ChangeNotifier` is a class that holds your shared data and **rings a bell** (`notifyListeners`) whenever the data changes, so widgets know to rebuild.

This is step 1 of Provider: **create** the class that holds the state.

---

## What is ChangeNotifier?

`ChangeNotifier` is a special class that can tell widgets: "Hey! I changed! Update yourself!"

Think of it like a bell 🔔:

```
Normal class: Changes happen silently
ChangeNotifier class: Rings a bell when it changes! 🔔
```

---

## Your First ChangeNotifier: A Counter

Let's make a simple counter:

```dart
import 'package:flutter/foundation.dart';

class Counter extends ChangeNotifier {
  // 1. The data (private with _)
  int _count = 0;

  // 2. Getter to read the data
  int get count => _count;

  // 3. Method to change the data
  void increment() {
    _count++;
    notifyListeners();  // 🔔 Ring the bell!
  }
}
```

That's it! A complete ChangeNotifier in 15 lines!

---

## Breaking It Down: Line by Line

### Line 1: Import
```dart
import 'package:flutter/foundation.dart';
```
This gives you access to `ChangeNotifier`.

### Line 2-3: Extend ChangeNotifier
```dart
class Counter extends ChangeNotifier {
//              ^^^^^^^^^^^^^^^^
//              This is the magic word!
```

`extends ChangeNotifier` gives your class superpowers!

### Line 4: Private Data
```dart
int _count = 0;
//  ^
//  Underscore makes it private!
```

The `_` means "only this class can change me directly."

### Line 5: Getter
```dart
int get count => _count;
```

This lets other code READ the value (but not change it directly).

### Line 6-9: Method with notifyListeners
```dart
void increment() {
  _count++;                // Change the data
  notifyListeners();      // 🔔 Tell everyone!
}
```

**notifyListeners()** is the most important part! It rings the bell 🔔

---

## The Magic of notifyListeners()

```
Without notifyListeners():
──────────────────────────
_count changes from 5 → 6
Widgets show: 5           ❌ (Still shows old value!)


With notifyListeners():
───────────────────────
_count changes from 5 → 6
notifyListeners() rings 🔔
Widgets rebuild!
Widgets show: 6           ✅ (Shows new value!)
```

**Always call `notifyListeners()` after changing data!**

---

## Common Pattern: Private Data + Public Methods

```dart
class TodoList extends ChangeNotifier {
  // ❌ DON'T: Make data public
  List<String> todos = [];  // Anyone can change this!

  // ✅ DO: Make data private, provide methods
  List<String> _todos = [];

  // Let others READ (but not change directly)
  List<String> get todos => _todos;

  // Provide methods to change
  void addTodo(String todo) {
    _todos.add(todo);
    notifyListeners();  // 🔔
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();  // 🔔
  }
}
```

---

## Real Example: Shopping Cart

```dart
import 'package:flutter/foundation.dart';

class ShoppingCart extends ChangeNotifier {
  // Private data
  final List<String> _items = [];

  // Public getter
  List<String> get items => _items;
  
  // Computed property
  int get itemCount => _items.length;

  // Add item
  void addItem(String item) {
    _items.add(item);
    notifyListeners();  // 🔔 Cart changed!
  }

  // Remove item
  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();  // 🔔 Cart changed!
  }

  // Clear all
  void clear() {
    _items.clear();
    notifyListeners();  // 🔔 Cart changed!
  }
}
```

---

## Multiple Pieces of Data

You can have as many pieces of data as you need:

```dart
class UserProfile extends ChangeNotifier {
  String _name = '';
  int _age = 0;
  String _email = '';

  // Getters
  String get name => _name;
  int get age => _age;
  String get email => _email;

  // Update methods
  void updateName(String newName) {
    _name = newName;
    notifyListeners();  // 🔔
  }

  void updateAge(int newAge) {
    _age = newAge;
    notifyListeners();  // 🔔
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();  // 🔔
  }
}
```

---

## Common Mistakes

### ❌ Mistake 1: Forgetting notifyListeners()
```dart
void increment() {
  _count++;
  // Forgot notifyListeners()! ❌
  // Widgets won't update!
}
```

### ✅ Fix:
```dart
void increment() {
  _count++;
  notifyListeners();  // ✅ Always remember!
}
```

### ❌ Mistake 2: Calling notifyListeners() Too Much
```dart
void addMany(List<String> items) {
  for (var item in items) {
    _items.add(item);
    notifyListeners();  // ❌ Called 10 times for 10 items!
  }
}
```

### ✅ Fix:
```dart
void addMany(List<String> items) {
  _items.addAll(items);
  notifyListeners();  // ✅ Called once after all changes!
}
```

---

## Summary Checklist

When creating a ChangeNotifier:

- [ ] Extend `ChangeNotifier`
- [ ] Make data private with `_`
- [ ] Provide getters for reading
- [ ] Create methods for changing
- [ ] Call `notifyListeners()` after every change
- [ ] Don't call `notifyListeners()` too often

---

## Quick Quiz

**Q1.** What does `notifyListeners()` do?

<details>
<summary>Answer</summary>
It "rings the bell" to tell the widgets listening to this ChangeNotifier that the data changed, so they rebuild.
</details>

**Q2.** What happens if you change the data but forget `notifyListeners()`?

<details>
<summary>Answer</summary>
The data changes in memory, but the widgets do not update, because they were never told. The screen keeps showing the old value.
</details>

**Q3.** Why make the data private (`_count`) with a getter?

<details>
<summary>Answer</summary>
So the outside can read it but only change it through your methods (which call `notifyListeners`). This is the encapsulation idea from Level 4.
</details>

---

## Assignment

These are pure-Dart classes; you can check them in [dartpad.dev](https://dartpad.dev).

### Problem 1: A counter notifier

Write a `Counter` class that `extends ChangeNotifier` with a private `int _count = 0`, a getter `count`, an `increment()` method, and a `decrement()` method. Both methods must call `notifyListeners()`.

### Problem 2: Spot the bug

Why will widgets not update when `toggle()` is called?

```dart
class Switch1 extends ChangeNotifier {
  bool _on = false;
  bool get on => _on;

  void toggle() {
    _on = !_on;
  }
}
```

### Problem 3: A tally notifier

Write a `Tally` class that `extends ChangeNotifier` holding a private `List<String> _items`, a getter `items`, a getter `count` (the list length), an `add(String item)` method, and a `clear()` method. Remember `notifyListeners()`.

### Problem 4: Fix the over-notify

Rewrite this so `notifyListeners` is called once, not once per item.

```dart
void addAll(List<String> newItems) {
  for (var item in newItems) {
    _items.add(item);
    notifyListeners();
  }
}
```

---

## Assignment Answers

### Problem 1: A counter notifier

```dart
import 'package:flutter/foundation.dart';

class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
```

Each method changes the private data and then rings the bell with `notifyListeners()`.

### Problem 2: Spot the bug

`toggle()` changes `_on` but never calls `notifyListeners()`, so no widget is told about the change and nothing rebuilds. Fix:

```dart
void toggle() {
  _on = !_on;
  notifyListeners();
}
```

### Problem 3: A tally notifier

```dart
import 'package:flutter/foundation.dart';

class Tally extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;
  int get count => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

The data is private; reading is through getters; changing is through methods that call `notifyListeners()`.

### Problem 4: Fix the over-notify

```dart
void addAll(List<String> newItems) {
  _items.addAll(newItems);
  notifyListeners();
}
```

Add everything first, then ring the bell once. Calling `notifyListeners()` inside the loop would rebuild the widgets many times for one logical change, which is wasteful.

---

**Next:** `02c-ProvidingState.md`, where you share this class with your whole app.

---

## Navigation

⬅️ **Previous:** [What is Provider?](02a-ProviderIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Providing State](02c-ProvidingState.md)
