# Abstract Classes and Interfaces

## What Is an Abstract Class?

An **abstract class** is a class that cannot be instantiated directly. It serves as a blueprint for other classes.

Think of it like:
- A **template** that must be completed
- A **contract** that says "you must implement these methods"

```dart
// Abstract class - cannot create directly
abstract class Animal {
  // Abstract method - no body, must be implemented
  void makeSound();

  // Regular method - has implementation
  void breathe() {
    print('Breathing...');
  }
}

// Concrete class - must implement abstract methods
class Dog extends Animal {
  @override
  void makeSound() {
    print('Woof!');
  }
}

void main() {
  // var animal = Animal();  // ERROR! Can't instantiate abstract class
  var dog = Dog();  // OK!
  dog.makeSound();  // Woof!
  dog.breathe();    // Breathing... (inherited)
}
```

---

## Abstract Methods vs Regular Methods

```dart
abstract class Shape {
  // Abstract method - NO body
  // Subclasses MUST implement
  double area();
  double perimeter();

  // Regular method - HAS body
  // Subclasses inherit (can override)
  void describe() {
    print('This shape has area ${area()} and perimeter ${perimeter()}');
  }
}

class Rectangle extends Shape {
  double width, height;

  Rectangle(this.width, this.height);

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}
```

---

## Visual: Abstract Class

```
    ┌─────────────────────────────────┐
    │      Shape (abstract)           │
    │─────────────────────────────────│
    │  area() → abstract              │  Must be implemented
    │  perimeter() → abstract         │  by subclasses
    │  describe() → implemented       │  Already has code
    └───────────────┬─────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼───────┐       ┌───────▼───────┐
│  Rectangle    │       │    Circle     │
│───────────────│       │───────────────│
│  area() ✓     │       │  area() ✓     │
│  perimeter() ✓│       │  perimeter() ✓│
│  (describe)   │       │  (describe)   │
└───────────────┘       └───────────────┘
```

---

## Interfaces in Dart

In Dart, **every class is implicitly an interface**. Use `implements` to implement an interface:

```dart
// This class can be used as an interface
class Printable {
  void print() {
    print('Printing...');
  }
}

class Document implements Printable {
  @override
  void print() {
    print('Printing document...');
  }
}
```

### Abstract Class vs Interface

| Abstract Class (extends) | Interface (implements) |
|-------------------------|------------------------|
| Can inherit implementation | Must implement ALL members |
| Single inheritance only | Multiple interfaces |
| "Is-a" relationship | "Can-do" relationship |

```dart
abstract class Animal {
  void eat() => print('Eating');  // Has implementation
}

// extends: Gets the implementation
class Dog extends Animal {
  // eat() already works!
}

// implements: Must provide ALL implementations
class Robot implements Animal {
  @override
  void eat() => print('Robot cannot eat');  // MUST implement
}
```

---

## Multiple Interfaces

Dart supports implementing multiple interfaces:

```dart
abstract class Flyable {
  void fly();
}

abstract class Swimmable {
  void swim();
}

abstract class Walkable {
  void walk();
}

// Duck can do all three!
class Duck implements Flyable, Swimmable, Walkable {
  @override
  void fly() => print('Duck flying');

  @override
  void swim() => print('Duck swimming');

  @override
  void walk() => print('Duck walking');
}

// Fish can only swim
class Fish implements Swimmable {
  @override
  void swim() => print('Fish swimming');
}

// Plane can only fly
class Plane implements Flyable {
  @override
  void fly() => print('Plane flying');
}
```

---

## Abstract Class + Interface Pattern

Combine both for maximum flexibility:

```dart
// Abstract class with some implementation
abstract class Vehicle {
  String brand;

  Vehicle(this.brand);

  void start() => print('$brand starting...');
  void stop() => print('$brand stopping...');

  // Abstract - must be implemented
  void move();
}

// Interface - capability
abstract class Electric {
  void charge();
  int get batteryLevel;
}

// Interface - capability
abstract class Autonomous {
  void enableAutopilot();
  void disableAutopilot();
}

// Tesla: is a Vehicle, can be Electric and Autonomous
class Tesla extends Vehicle implements Electric, Autonomous {
  int _batteryLevel = 100;

  Tesla() : super('Tesla');

  @override
  void move() => print('Tesla moving silently');

  @override
  void charge() => print('Charging Tesla...');

  @override
  int get batteryLevel => _batteryLevel;

  @override
  void enableAutopilot() => print('Autopilot enabled');

  @override
  void disableAutopilot() => print('Autopilot disabled');
}

// Regular car: just a Vehicle
class Honda extends Vehicle {
  Honda() : super('Honda');

  @override
  void move() => print('Honda driving');
}
```

---

## Practical Example: Repository Pattern

Common pattern in Flutter apps:

```dart
// Abstract interface - defines contract
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

// Concrete implementation - API
class ApiUserRepository implements UserRepository {
  @override
  Future<User?> getUser(String id) async {
    print('Fetching user $id from API...');
    // API call here
    return User(id, 'API User');
  }

  @override
  Future<List<User>> getAllUsers() async {
    print('Fetching all users from API...');
    return [User('1', 'User 1'), User('2', 'User 2')];
  }

  @override
  Future<void> saveUser(User user) async {
    print('Saving user ${user.id} to API...');
  }

  @override
  Future<void> deleteUser(String id) async {
    print('Deleting user $id from API...');
  }
}

// Concrete implementation - Local Database
class LocalUserRepository implements UserRepository {
  final Map<String, User> _storage = {};

  @override
  Future<User?> getUser(String id) async {
    print('Fetching user $id from local storage...');
    return _storage[id];
  }

  @override
  Future<List<User>> getAllUsers() async {
    print('Fetching all users from local storage...');
    return _storage.values.toList();
  }

  @override
  Future<void> saveUser(User user) async {
    print('Saving user ${user.id} to local storage...');
    _storage[user.id] = user;
  }

  @override
  Future<void> deleteUser(String id) async {
    print('Deleting user $id from local storage...');
    _storage.remove(id);
  }
}

// Mock implementation - for testing
class MockUserRepository implements UserRepository {
  @override
  Future<User?> getUser(String id) async => User(id, 'Mock User');

  @override
  Future<List<User>> getAllUsers() async => [User('test', 'Test User')];

  @override
  Future<void> saveUser(User user) async {}

  @override
  Future<void> deleteUser(String id) async {}
}

class User {
  String id;
  String name;
  User(this.id, this.name);
}

// Service that uses the repository - doesn't care which implementation!
class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<void> displayUser(String id) async {
    var user = await repository.getUser(id);
    print('User: ${user?.name ?? 'Not found'}');
  }
}

void main() async {
  // Use API in production
  var apiService = UserService(ApiUserRepository());
  await apiService.displayUser('123');

  // Use local in offline mode
  var localService = UserService(LocalUserRepository());
  await localService.displayUser('123');

  // Use mock in tests
  var testService = UserService(MockUserRepository());
  await testService.displayUser('123');
}
```

---

## Practical Example: Payment Gateway

```dart
// Payment gateway interface
abstract class PaymentGateway {
  String get name;
  Future<bool> processPayment(double amount, String currency);
  Future<bool> refund(String transactionId);
  bool get supportsRecurring;
}

// Stripe implementation
class StripeGateway implements PaymentGateway {
  @override
  String get name => 'Stripe';

  @override
  Future<bool> processPayment(double amount, String currency) async {
    print('Processing \$${amount.toStringAsFixed(2)} $currency via Stripe...');
    // Stripe API call
    return true;
  }

  @override
  Future<bool> refund(String transactionId) async {
    print('Refunding transaction $transactionId via Stripe...');
    return true;
  }

  @override
  bool get supportsRecurring => true;
}

// PayPal implementation
class PayPalGateway implements PaymentGateway {
  @override
  String get name => 'PayPal';

  @override
  Future<bool> processPayment(double amount, String currency) async {
    print('Processing \$${amount.toStringAsFixed(2)} $currency via PayPal...');
    return true;
  }

  @override
  Future<bool> refund(String transactionId) async {
    print('Refunding transaction $transactionId via PayPal...');
    return true;
  }

  @override
  bool get supportsRecurring => true;
}

// Cash gateway (doesn't support recurring)
class CashGateway implements PaymentGateway {
  @override
  String get name => 'Cash';

  @override
  Future<bool> processPayment(double amount, String currency) async {
    print('Received \$${amount.toStringAsFixed(2)} cash');
    return true;
  }

  @override
  Future<bool> refund(String transactionId) async {
    print('Cash refund for $transactionId');
    return true;
  }

  @override
  bool get supportsRecurring => false;
}

// Checkout system - works with any gateway
class Checkout {
  final PaymentGateway gateway;

  Checkout(this.gateway);

  Future<void> completePayment(double amount) async {
    print('\nUsing ${gateway.name}...');
    var success = await gateway.processPayment(amount, 'USD');
    print(success ? 'Payment successful!' : 'Payment failed!');
  }

  void setupSubscription(double amount) {
    if (gateway.supportsRecurring) {
      print('Setting up recurring payment of \$$amount/month');
    } else {
      print('${gateway.name} does not support recurring payments');
    }
  }
}

void main() async {
  // Can use any payment gateway
  var stripeCheckout = Checkout(StripeGateway());
  await stripeCheckout.completePayment(99.99);
  stripeCheckout.setupSubscription(9.99);

  var cashCheckout = Checkout(CashGateway());
  await cashCheckout.completePayment(50.00);
  cashCheckout.setupSubscription(9.99);  // Will say not supported
}
```

---

## When to Use What

| Use Case | Use |
|----------|-----|
| Shared code + contract | Abstract class |
| Contract only | Interface (abstract class with only abstract methods) |
| Multiple capabilities | Multiple interfaces |
| Single inheritance + shared code | Abstract class with extends |

---

## Summary

| Concept | Keyword | Purpose |
|---------|---------|---------|
| Abstract class | `abstract class` | Blueprint with some/no implementation |
| Abstract method | No body | Must be implemented by subclass |
| Interface | `implements` | Contract - must implement all members |
| Extends | `extends` | Inherit implementation |

---

## Quick Quiz

**Q1:** What's the difference between `extends` and `implements`?

<details>
<summary>Answer</summary>

- `extends`: Inherit implementation, can override. Single inheritance.
- `implements`: Must provide ALL implementations. Multiple interfaces possible.

</details>

**Q2:** Can you create an instance of an abstract class?

<details>
<summary>Answer</summary>

No! Abstract classes cannot be instantiated. You must create a concrete subclass that implements all abstract methods.

</details>

**Q3:** When would you use an interface over an abstract class?

<details>
<summary>Answer</summary>

- When you only need to define a contract (no shared code)
- When a class needs to implement multiple contracts
- When defining capabilities ("can do" vs "is a")

</details>

---

**Next:** Learn about mixins for code reuse.

---

**Continue to:** `07-Mixins.md`
