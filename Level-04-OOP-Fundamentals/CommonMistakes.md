# Level 04: Common Mistakes

Learn from these common OOP errors!

---

## Mistake #1: Forgetting `this.` in Constructors

```dart
// ❌ WRONG - Parameters shadow fields
class Product {
  String name;
  double price;

  Product(String name, double price) {
    name = name;    // Assigns to itself!
    price = price;  // Assigns to itself!
  }
}

// ✅ RIGHT - Use this.
class Product {
  String name;
  double price;

  Product(this.name, this.price);  // Shorthand
}
```

---

## Mistake #2: Not Initializing Non-Nullable Fields

```dart
// ❌ WRONG
class Product {
  String name;   // Error: must be initialized
  double price;  // Error: must be initialized
}

// ✅ RIGHT - Option 1: Initialize in constructor
class Product {
  String name;
  double price;

  Product(this.name, this.price);
}

// ✅ RIGHT - Option 2: Default values
class Product {
  String name = '';
  double price = 0.0;
}

// ✅ RIGHT - Option 3: late keyword (be careful!)
class Product {
  late String name;
  late double price;
}
```

---

## Mistake #3: Accessing Private Fields From Outside

```dart
// ❌ WRONG
class BankAccount {
  double _balance = 0;  // Private (underscore)
}

var account = BankAccount();
print(account._balance);  // Works in same file, but bad practice!

// ✅ RIGHT - Use getters
class BankAccount {
  double _balance = 0;

  double get balance => _balance;  // Read-only access
}
```

**Note:** Dart's `_` is library-private, not class-private. Use getters for proper encapsulation.

---

## Mistake #4: Forgetting `@override`

```dart
// ❌ WRONG - Typo goes unnoticed
class Dog extends Animal {
  void speek() {  // Typo! Not overriding speak()
    print('Woof!');
  }
}

// ✅ RIGHT - Compiler catches the typo
class Dog extends Animal {
  @override
  void speek() {  // Error: No method to override!
    print('Woof!');
  }
}
```

---

## Mistake #5: Calling Abstract Class Constructor

```dart
// ❌ WRONG
abstract class Animal {
  void speak();
}

var pet = Animal();  // Error: Can't instantiate abstract class

// ✅ RIGHT - Instantiate concrete subclass
class Dog extends Animal {
  @override
  void speak() => print('Woof!');
}

var pet = Dog();
```

---

## Mistake #6: Forgetting `super` Call

```dart
// ❌ WRONG - Parent constructor not called
class Animal {
  String name;
  Animal(this.name);
}

class Dog extends Animal {
  String breed;
  Dog(this.breed);  // Error: No super call!
}

// ✅ RIGHT
class Dog extends Animal {
  String breed;
  Dog(String name, this.breed) : super(name);
}
```

---

## Mistake #7: Using `extends` Instead of `implements`

```dart
// ❌ WRONG - Can only extend one class
class MyClass extends ClassA, ClassB { }  // Error!

// ✅ RIGHT - Extend one, implement many
class MyClass extends ClassA implements InterfaceB, InterfaceC { }

// Or use mixins
class MyClass extends ClassA with MixinB, MixinC { }
```

---

## Mistake #8: Mixin Without Required Method

```dart
// ❌ WRONG - Mixin uses method not provided
mixin Discountable {
  double applyDiscount() {
    return price * 0.9;  // Error: price not defined!
  }
}

// ✅ RIGHT - Declare what mixin needs
mixin Discountable {
  double get price;  // Mixin expects this

  double applyDiscount() {
    return price * 0.9;
  }
}

class Product with Discountable {
  @override
  double get price => 100.0;
}
```

---

## Mistake #9: Static vs Instance Confusion

```dart
// ❌ WRONG - Accessing instance from static
class Counter {
  int count = 0;

  static void increment() {
    count++;  // Error: Can't access instance member from static
  }
}

// ✅ RIGHT - Static methods need static fields
class Counter {
  static int count = 0;

  static void increment() {
    count++;
  }
}
```

---

## Mistake #10: Getter Without Return

```dart
// ❌ WRONG
class Product {
  double _price = 0;

  double get price {
    _price;  // Missing return!
  }
}

// ✅ RIGHT
class Product {
  double _price = 0;

  double get price {
    return _price;
  }

  // Or arrow syntax
  double get price => _price;
}
```

---

## Quick Reference: OOP Keywords

| Keyword | Use |
|---------|-----|
| `class` | Define a class |
| `extends` | Inherit from one class |
| `implements` | Implement interface(s) |
| `with` | Use mixin(s) |
| `abstract` | Can't be instantiated |
| `@override` | Explicitly override parent |
| `super` | Call parent method/constructor |
| `this` | Reference current instance |
| `static` | Belongs to class, not instance |
| `get` | Read-only property |
| `set` | Write property |

---

**Still stuck? Re-read the Theory files or ask for help!**
