# Encapsulation: Hiding Implementation

## What Is Encapsulation?

**Encapsulation** means bundling data and methods together AND controlling access to them.

Think of a TV:
- You can use **buttons** (public interface)
- You can't touch **internal circuits** (private implementation)

```dart
class TV {
  int _channel = 1;       // Private (hidden)
  int _volume = 50;       // Private (hidden)

  void channelUp() {      // Public (accessible)
    _channel++;
  }

  void volumeUp() {       // Public (accessible)
    if (_volume < 100) _volume++;
  }
}
```

---

## Why Encapsulation?

### Without Encapsulation (Bad)

```dart
class BankAccount {
  double balance = 0;  // Anyone can modify!
}

void main() {
  var account = BankAccount();
  account.balance = -1000000;  // Uh oh! Invalid state!
}
```

### With Encapsulation (Good)

```dart
class BankAccount {
  double _balance = 0;  // Private

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
    }
  }

  double get balance => _balance;  // Read-only access
}

void main() {
  var account = BankAccount();
  account.deposit(100);
  // account._balance = -1000000;  // Error! Can't access private
  // account.balance = -1000000;   // Error! No setter
}
```

---

## Private in Dart

In Dart, prefix with `_` to make something private:

```dart
class Example {
  int publicField = 0;      // Anyone can access
  int _privateField = 0;    // Only this file can access

  void publicMethod() { }   // Anyone can call
  void _privateMethod() { } // Only this file can call
}
```

**Important:** Dart's private is file-level, not class-level!

```dart
// In same file - can access _private
void main() {
  var ex = Example();
  ex._privateField = 10;  // Works in same file!
}
```

---

## Getters and Setters

Control how properties are read and written.

### Getter (Read Access)

```dart
class Circle {
  double _radius;

  Circle(this._radius);

  // Getter - computed property
  double get radius => _radius;
  double get diameter => _radius * 2;
  double get area => 3.14159 * _radius * _radius;
  double get circumference => 2 * 3.14159 * _radius;
}

void main() {
  var c = Circle(5);

  print(c.radius);        // 5.0
  print(c.diameter);      // 10.0
  print(c.area);          // 78.53975
  print(c.circumference); // 31.4159
}
```

### Setter (Write Access)

```dart
class Temperature {
  double _celsius;

  Temperature(this._celsius);

  // Getter
  double get celsius => _celsius;
  double get fahrenheit => _celsius * 9 / 5 + 32;

  // Setter with validation
  set celsius(double value) {
    if (value >= -273.15) {  // Absolute zero check
      _celsius = value;
    }
  }

  set fahrenheit(double value) {
    celsius = (value - 32) * 5 / 9;  // Converts and validates
  }
}

void main() {
  var temp = Temperature(25);

  print(temp.celsius);     // 25.0
  print(temp.fahrenheit);  // 77.0

  temp.fahrenheit = 100;
  print(temp.celsius);     // 37.77...

  temp.celsius = -500;     // Ignored! Below absolute zero
  print(temp.celsius);     // Still 37.77...
}
```

---

## Read-Only Properties

Only getter, no setter:

```dart
class User {
  final String _id;
  String _name;
  final DateTime _createdAt;

  User(this._id, this._name) : _createdAt = DateTime.now();

  // Read-only (no setter)
  String get id => _id;
  DateTime get createdAt => _createdAt;

  // Read-write
  String get name => _name;
  set name(String value) {
    if (value.isNotEmpty) _name = value;
  }
}

void main() {
  var user = User('123', 'Alice');

  print(user.id);  // 123
  // user.id = '456';  // Error! No setter

  user.name = 'Bob';  // OK, has setter
  print(user.name);   // Bob
}
```

---

## Computed Properties

Properties that calculate values on demand:

```dart
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  // Computed properties
  double get area => width * height;
  double get perimeter => 2 * (width + height);
  double get diagonal => sqrt(width * width + height * height);
  bool get isSquare => width == height;
}

import 'dart:math';

void main() {
  var rect = Rectangle(3, 4);

  print('Area: ${rect.area}');           // 12.0
  print('Perimeter: ${rect.perimeter}'); // 14.0
  print('Diagonal: ${rect.diagonal}');   // 5.0
  print('Is square: ${rect.isSquare}');  // false

  rect.width = 4;
  print('Is square now: ${rect.isSquare}');  // true
}
```

---

## Encapsulation Patterns

### Pattern 1: Validation

```dart
class Age {
  int _years = 0;

  int get years => _years;

  set years(int value) {
    if (value >= 0 && value <= 150) {
      _years = value;
    } else {
      throw ArgumentError('Invalid age: $value');
    }
  }
}
```

### Pattern 2: Logging

```dart
class Counter {
  int _count = 0;

  int get count => _count;

  set count(int value) {
    print('Counter changed: $_count -> $value');
    _count = value;
  }
}
```

### Pattern 3: Lazy Loading

```dart
class ExpensiveData {
  List<int>? _data;

  List<int> get data {
    // Only calculate once, on first access
    _data ??= _loadExpensiveData();
    return _data!;
  }

  List<int> _loadExpensiveData() {
    print('Loading expensive data...');
    return List.generate(1000000, (i) => i);
  }
}
```

### Pattern 4: Derived/Computed Values

```dart
class Person {
  String firstName;
  String lastName;

  Person(this.firstName, this.lastName);

  // Computed from other properties
  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}
```

---

## Practical Example: Shopping Cart

```dart
class ShoppingCart {
  final List<CartItem> _items = [];
  double _discount = 0;

  // Read-only access to items (copy to prevent modification)
  List<CartItem> get items => List.unmodifiable(_items);

  // Computed properties
  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.total);

  double get discount => _discount;

  double get total => subtotal * (1 - _discount);

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  // Controlled modification
  void addItem(CartItem item) {
    var existing = _items.where((i) => i.productId == item.productId);
    if (existing.isNotEmpty) {
      existing.first.quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  void applyDiscount(double percent) {
    if (percent >= 0 && percent <= 0.5) {  // Max 50% discount
      _discount = percent;
    }
  }

  void clear() {
    _items.clear();
    _discount = 0;
  }
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;

  CartItem(this.productId, this.name, this.price, this.quantity);

  double get total => price * quantity;
}

void main() {
  var cart = ShoppingCart();

  cart.addItem(CartItem('001', 'Apple', 1.50, 5));
  cart.addItem(CartItem('002', 'Bread', 2.50, 2));
  cart.addItem(CartItem('001', 'Apple', 1.50, 3));  // Adds to existing

  print('Items: ${cart.itemCount}');
  print('Subtotal: \$${cart.subtotal}');

  cart.applyDiscount(0.1);  // 10% off
  print('After discount: \$${cart.total}');

  // Can't directly modify _items
  // cart._items.clear();  // Error!
  // cart.items.add(...);  // Error! Unmodifiable list
}
```

---

## Best Practices

### 1. Make Fields Private by Default

```dart
// ✅ Good: Private with controlled access
class User {
  String _email;

  String get email => _email;
  set email(String value) {
    if (_isValidEmail(value)) _email = value;
  }
}

// ❌ Bad: Public, no validation
class User {
  String email;  // Anyone can set invalid email
}
```

### 2. Use Getters for Computed Values

```dart
// ✅ Good: Computed from actual data
class Circle {
  double radius;
  double get area => 3.14159 * radius * radius;
}

// ❌ Bad: Storing computed value (can get out of sync)
class Circle {
  double radius;
  double area;  // What if radius changes?
}
```

### 3. Validate in Setters

```dart
class Score {
  int _value = 0;

  set value(int v) {
    _value = v.clamp(0, 100);  // Always valid
  }
}
```

---

## Summary

| Concept | Purpose |
|---------|---------|
| Private (`_`) | Hide implementation details |
| Getter | Control read access |
| Setter | Control write access + validate |
| Computed property | Calculate value from other fields |
| Read-only | Getter without setter |

---

## Quick Quiz

**Q1:** How do you make something private in Dart?

<details>
<summary>Answer</summary>

Prefix with underscore: `_privateField`, `_privateMethod()`

</details>

**Q2:** What's the difference between a getter and a regular method?

<details>
<summary>Answer</summary>

Syntax: getter is accessed like a property (`obj.value`), method needs parentheses (`obj.getValue()`)

Both can contain logic, but getters should be fast and have no side effects.

</details>

**Q3:** When should you use a setter vs a method?

<details>
<summary>Answer</summary>

Use setter for single-value assignment with validation: `obj.age = 25`

Use method for complex operations or multiple parameters: `obj.updateProfile(name, age, email)`

</details>

---

**Next:** Learn about inheritance - extending classes.

---

**Continue to:** `04-Inheritance.md`
