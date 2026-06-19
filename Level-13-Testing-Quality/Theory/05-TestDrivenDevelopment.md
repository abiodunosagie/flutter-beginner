# Test-Driven Development (TDD)

## The Big Idea In One Sentence

> TDD flips the order: write a failing test first (Red), write just enough code to pass it (Green), then clean up (Refactor), repeating that small loop.

## The Simple Explanation

TDD is like writing a recipe BEFORE you cook. You know exactly what the dish should taste like before you start!

```
┌─────────────────────────────────────────────────────────┐
│            TEST-DRIVEN DEVELOPMENT                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  TRADITIONAL WAY:          TDD WAY:                      │
│  1. Write code             1. Write test (fails)        │
│  2. Test manually          2. Write code (to pass)      │
│  3. Hope it works          3. Refactor (keep passing)   │
│  4. Write tests (maybe)    4. Repeat                    │
│                                                          │
│        😰                         😊                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## The Red-Green-Refactor Cycle

```
        ┌─────────────────────────────────────┐
        │                                     │
        │            🔴 RED                   │
        │      Write a failing test           │
        │                                     │
        └──────────────┬──────────────────────┘
                       │
                       ▼
        ┌─────────────────────────────────────┐
        │                                     │
        │           🟢 GREEN                  │
        │   Write minimum code to pass        │
        │                                     │
        └──────────────┬──────────────────────┘
                       │
                       ▼
        ┌─────────────────────────────────────┐
        │                                     │
        │          🔵 REFACTOR                │
        │    Improve code, tests still pass   │
        │                                     │
        └──────────────┬──────────────────────┘
                       │
                       └────── Repeat! ──────→
```

---

## Example: Building a Shopping Cart

Let's build a shopping cart feature using TDD.

### Step 1: RED - Write a Failing Test

```dart
// test/models/cart_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/cart.dart';

void main() {
  test('cart starts empty', () {
    final cart = Cart();

    expect(cart.items, isEmpty);
    expect(cart.total, 0);
  });
}
```

Run the test - it FAILS! (Cart class doesn't exist)

```
$ flutter test
Error: Cart class not found
```

### Step 2: GREEN - Write Minimum Code

```dart
// lib/models/cart.dart
class Cart {
  List<CartItem> items = [];
  double total = 0;
}

class CartItem {
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}
```

Run the test - it PASSES!

```
$ flutter test
✓ cart starts empty
```

### Step 3: Add More Tests

```dart
test('can add item to cart', () {
  final cart = Cart();
  final item = CartItem(name: 'Apple', price: 1.00);

  cart.addItem(item);

  expect(cart.items.length, 1);
  expect(cart.items.first.name, 'Apple');
});
```

Test FAILS! (addItem doesn't exist)

### Step 4: GREEN - Implement addItem

```dart
class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(CartItem item) {
    _items.add(item);
  }
}
```

Test PASSES!

### Step 5: Continue the Cycle

```dart
// More tests...
group('Cart', () {
  late Cart cart;

  setUp(() {
    cart = Cart();
  });

  test('starts empty', () {
    expect(cart.items, isEmpty);
    expect(cart.total, 0);
  });

  test('adds item', () {
    cart.addItem(CartItem(name: 'Apple', price: 1.00));

    expect(cart.items.length, 1);
  });

  test('calculates total correctly', () {
    cart.addItem(CartItem(name: 'Apple', price: 1.50));
    cart.addItem(CartItem(name: 'Banana', price: 0.75));

    expect(cart.total, 2.25);
  });

  test('removes item', () {
    final apple = CartItem(name: 'Apple', price: 1.00);
    cart.addItem(apple);
    cart.removeItem(apple);

    expect(cart.items, isEmpty);
  });

  test('updates quantity', () {
    final apple = CartItem(name: 'Apple', price: 1.00);
    cart.addItem(apple);
    cart.updateQuantity(apple, 3);

    expect(cart.items.first.quantity, 3);
    expect(cart.total, 3.00);
  });

  test('clears all items', () {
    cart.addItem(CartItem(name: 'Apple', price: 1.00));
    cart.addItem(CartItem(name: 'Banana', price: 0.75));
    cart.clear();

    expect(cart.items, isEmpty);
    expect(cart.total, 0);
  });
});
```

---

## Final Cart Implementation

```dart
// lib/models/cart.dart
class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(
    0.0,
    (sum, item) => sum + item.price * item.quantity,
  );

  int get itemCount => _items.fold(
    0,
    (sum, item) => sum + item.quantity,
  );

  void addItem(CartItem item) {
    final existing = _items.where((i) => i.name == item.name).firstOrNull;
    if (existing != null) {
      updateQuantity(existing, existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }
  }

  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.name == item.name);
  }

  void updateQuantity(CartItem item, int quantity) {
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index != -1) {
      _items[index] = CartItem(
        name: item.name,
        price: item.price,
        quantity: quantity,
      );
    }
  }

  void clear() {
    _items.clear();
  }
}

class CartItem {
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}
```

---

## TDD Benefits

```
┌─────────────────────────────────────────────────────────┐
│                    TDD BENEFITS                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. BETTER DESIGN                                        │
│     Writing tests first makes you think about            │
│     how the code will be USED.                          │
│                                                          │
│  2. CONFIDENCE                                           │
│     Every feature has tests from the start.             │
│     No "I'll add tests later" (you won't).              │
│                                                          │
│  3. DOCUMENTATION                                        │
│     Tests describe exactly what the code does.          │
│                                                          │
│  4. FEWER BUGS                                           │
│     You catch issues immediately, not in production.    │
│                                                          │
│  5. EASIER REFACTORING                                   │
│     Change code fearlessly - tests catch mistakes.      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## TDD for a Validator

```dart
// Step 1: Write tests first
void main() {
  group('EmailValidator', () {
    late EmailValidator validator;

    setUp(() {
      validator = EmailValidator();
    });

    test('returns error for empty email', () {
      expect(validator.validate(''), 'Email is required');
    });

    test('returns error for email without @', () {
      expect(validator.validate('invalid'), 'Invalid email format');
    });

    test('returns error for email without domain', () {
      expect(validator.validate('user@'), 'Invalid email format');
    });

    test('returns null for valid email', () {
      expect(validator.validate('user@example.com'), isNull);
    });

    test('handles uppercase emails', () {
      expect(validator.validate('USER@EXAMPLE.COM'), isNull);
    });

    test('handles emails with dots', () {
      expect(validator.validate('first.last@example.com'), isNull);
    });
  });
}
```

```dart
// Step 2: Implement to pass tests
class EmailValidator {
  String? validate(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }

    // Simple regex for email validation
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null; // Valid
  }
}
```

---

## Common TDD Mistakes

```
❌ WRITING TOO MUCH CODE AT ONCE
   Write just enough to pass ONE test

❌ SKIPPING THE RED PHASE
   If your test passes immediately, it's not testing anything new

❌ NOT REFACTORING
   Don't skip the blue phase - clean up your code

❌ TESTING IMPLEMENTATION, NOT BEHAVIOR
   Test WHAT it does, not HOW it does it

❌ GIVING UP TOO EARLY
   TDD feels slow at first but speeds up over time
```

---

## When to Use TDD

```
GREAT FOR:
✓ Business logic (calculations, validation)
✓ Data models
✓ Services and utilities
✓ Complex algorithms
✓ Bug fixes (write failing test first)

LESS IDEAL FOR:
○ Experimental/prototype code
○ UI layout exploration
○ Third-party integrations
○ Very simple code
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                  TDD SUMMARY                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  THE CYCLE:                                              │
│  🔴 RED     - Write failing test                        │
│  🟢 GREEN   - Write minimum code to pass                │
│  🔵 REFACTOR - Improve code, keep tests passing         │
│                                                          │
│  RULES:                                                  │
│  ├── Write test BEFORE code                             │
│  ├── Only write code to pass the test                   │
│  ├── Each test should test ONE thing                    │
│  └── Keep cycles short (minutes, not hours)             │
│                                                          │
│  BENEFITS:                                               │
│  ├── Better design                                      │
│  ├── Built-in documentation                             │
│  ├── Confidence to refactor                             │
│  └── Fewer bugs                                         │
│                                                          │
│  REMEMBER:                                               │
│  TDD is a skill - it gets easier with practice!         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Congratulations!** You now understand testing in Flutter:
- Unit Tests for logic
- Widget Tests for UI
- Integration Tests for flows
- TDD for quality-first development

## Quick Quiz

**Q1.** What are the three steps of the TDD cycle?

<details>
<summary>Answer</summary>
Red (write a failing test), Green (write minimal code to pass it), Refactor (clean up while tests stay green).
</details>

**Q2.** Why write the test before the code?

<details>
<summary>Answer</summary>
It forces you to define exactly what "working" means first, and guarantees the feature is tested.
</details>

**Q3.** In the "Green" step, how much code should you write?

<details>
<summary>Answer</summary>
Just enough to make the test pass, no more. You add complexity later only when a test demands it.
</details>

---

## Assignment

### Problem 1: Order the cycle

Put in order: Refactor, Green, Red.

### Problem 2: First step

You are adding a `total()` function with TDD. What do you write first?

### Problem 3: Why refactor last?

Why is it safe to clean up code in the Refactor step?

---

## Assignment Answers

### Problem 1: Order the cycle

Red → Green → Refactor.

### Problem 2: First step

A failing test that says what `total()` should return for some input (for example `expect(total([1,2,3]), 6)`), before writing `total` itself.

### Problem 3: Why refactor last?

Because the passing test acts as a safety net: if your cleanup breaks behavior, the test fails immediately and tells you.

---

**Next Steps:** Practice! Write tests for your existing projects.
