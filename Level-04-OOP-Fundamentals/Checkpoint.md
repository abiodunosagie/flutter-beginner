# Level 04 Checkpoint: OOP Fundamentals

Before moving to Level 05, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Class Basics
What's the output?

```dart
class Product {
  String name;
  double price;

  Product(this.name, this.price);

  String get formattedPrice => '\$$price';
}

var shirt = Product('T-Shirt', 29.99);
print(shirt.name);
print(shirt.formattedPrice);
```

<details>
<summary>Check Answer</summary>

```
T-Shirt
$29.99
```

</details>

---

### 2. Constructors
Identify each constructor type:

```dart
class User {
  String name;
  String email;

  User(this.name, this.email);                    // Type: ____

  User.guest() : name = 'Guest', email = '';      // Type: ____

  User.fromJson(Map<String, dynamic> json)        // Type: ____
      : name = json['name'],
        email = json['email'];
}
```

<details>
<summary>Check Answers</summary>

- First: **Default/Generative constructor**
- Second: **Named constructor**
- Third: **Factory-style named constructor** (with initializer list)

</details>

---

### 3. Encapsulation
What's the difference?

```dart
class BankAccount {
  double _balance;        // What does _ mean?

  double get balance => _balance;   // Why use a getter?

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }
}
```

<details>
<summary>Check Answer</summary>

- `_balance`: Private field (only accessible within this library/file)
- Getter: Provides read-only access to private data
- `deposit` method: Controls how balance can be modified (validates input)

This is **encapsulation** - hiding internal state and exposing controlled access.

</details>

---

### 4. Inheritance
What does this code print?

```dart
class Animal {
  void speak() => print('...');
}

class Dog extends Animal {
  @override
  void speak() => print('Woof!');
}

class Cat extends Animal {
  @override
  void speak() => print('Meow!');
}

Animal pet = Dog();
pet.speak();

pet = Cat();
pet.speak();
```

<details>
<summary>Check Answer</summary>

```
Woof!
Meow!
```

This demonstrates **polymorphism** - same method call, different behavior based on actual type.

</details>

---

### 5. Abstract Classes & Interfaces
What must the subclass implement?

```dart
abstract class PaymentMethod {
  String get name;

  bool validate();

  Future<bool> process(double amount);
}

class CreditCard extends PaymentMethod {
  // What must I implement?
}
```

<details>
<summary>Check Answer</summary>

```dart
class CreditCard extends PaymentMethod {
  @override
  String get name => 'Credit Card';

  @override
  bool validate() {
    // Must implement
    return true;
  }

  @override
  Future<bool> process(double amount) async {
    // Must implement
    return true;
  }
}
```

All abstract members must be implemented: `name` getter, `validate()`, and `process()`.

</details>

---

### 6. Mixins
What does this class have access to?

```dart
mixin Discountable {
  double applyDiscount(double price, double percent) {
    return price * (1 - percent / 100);
  }
}

mixin Taxable {
  double applyTax(double price, double rate) {
    return price * (1 + rate / 100);
  }
}

class Product with Discountable, Taxable {
  String name;
  double price;

  Product(this.name, this.price);
}
```

<details>
<summary>Check Answer</summary>

`Product` has access to:
- Its own: `name`, `price`
- From `Discountable`: `applyDiscount()`
- From `Taxable`: `applyTax()`

```dart
var product = Product('Shirt', 100);
print(product.applyDiscount(product.price, 20));  // 80.0
print(product.applyTax(product.price, 10));       // 110.0
```

</details>

---

## Hands-On Check

### Task 1: Create a Class
Create a `CartItem` class with:
- Product reference
- Quantity
- Computed line total

```dart
// Your code here
```

<details>
<summary>Example Solution</summary>

```dart
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get lineTotal => product.price * quantity;

  void increment() => quantity++;

  void decrement() {
    if (quantity > 1) quantity--;
  }
}
```

</details>

---

### Task 2: Create Inheritance Hierarchy
Create a payment system:

```dart
// Create:
// - Abstract PaymentMethod with process() method
// - CreditCard subclass
// - PayPal subclass
```

<details>
<summary>Example Solution</summary>

```dart
abstract class PaymentMethod {
  String get displayName;

  Future<bool> process(double amount);
}

class CreditCard extends PaymentMethod {
  final String cardNumber;
  final String expiry;

  CreditCard({required this.cardNumber, required this.expiry});

  @override
  String get displayName => 'Card ending in ${cardNumber.substring(cardNumber.length - 4)}';

  @override
  Future<bool> process(double amount) async {
    // Simulate processing
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}

class PayPal extends PaymentMethod {
  final String email;

  PayPal({required this.email});

  @override
  String get displayName => 'PayPal ($email)';

  @override
  Future<bool> process(double amount) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
```

</details>

---

### Task 3: Use a Mixin
Add shipping calculation to products:

```dart
mixin Shippable {
  double get weight;

  double calculateShipping() {
    if (weight < 1) return 5.99;
    if (weight < 5) return 9.99;
    return 14.99;
  }
}

// Create a PhysicalProduct class that uses this mixin
```

<details>
<summary>Example Solution</summary>

```dart
class PhysicalProduct with Shippable {
  String name;
  double price;

  @override
  double weight;

  PhysicalProduct({
    required this.name,
    required this.price,
    required this.weight,
  });

  double get totalPrice => price + calculateShipping();
}

var book = PhysicalProduct(name: 'Flutter Book', price: 39.99, weight: 0.8);
print(book.calculateShipping());  // 5.99
print(book.totalPrice);           // 45.98
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Class vs Object | _________________ |
| Constructor | _________________ |
| Getter/Setter | _________________ |
| Inheritance | _________________ |
| Polymorphism | _________________ |
| Abstract class | _________________ |
| Mixin | _________________ |
| Encapsulation | _________________ |

---

## Ready for Level 05?

### I can confidently:
- [ ] Create classes with properties and methods
- [ ] Use different types of constructors
- [ ] Make properties private and use getters/setters
- [ ] Extend classes with `extends`
- [ ] Override methods properly
- [ ] Create and implement abstract classes
- [ ] Use mixins for code reuse

### Capstone Progress:
- [ ] I created Product, CartItem, Cart, and Customer classes
- [ ] I created an Order class that brings everything together
- [ ] I created a PaymentMethod abstract class with implementations
- [ ] My classes properly encapsulate their data

---

## If You're Stuck

**Common issues at this level:**

1. **When to use inheritance vs composition**
   - "Is-a" relationship → inheritance (Dog IS-A Animal)
   - "Has-a" relationship → composition (Car HAS-A Engine)

2. **Abstract class vs Mixin confusion**
   - Abstract class: defines a type, can have constructors
   - Mixin: adds behavior, can be combined multiple times

3. **Forgetting @override**
   - Always use `@override` when overriding methods
   - It helps catch typos and ensures you're actually overriding

4. **Private fields in Dart**
   - `_` prefix = library-private, not class-private
   - All code in same file can access it

---

**Ready to level up? Head to Level 05: Flutter Foundations!**
