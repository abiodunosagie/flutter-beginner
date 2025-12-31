# Part 2: Creating Your Data Class (ChangeNotifier)

Let's create your first **data class** - the place where your state lives!

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

**Next:** Learn how to provide your data to widgets!

---

## Navigation

⬅️ **Previous:** [What is Provider?](02a-ProviderIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Providing State](02c-ProvidingState.md)
