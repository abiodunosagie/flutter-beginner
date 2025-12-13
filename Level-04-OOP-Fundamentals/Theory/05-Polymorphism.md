# Polymorphism: Many Forms

## What Is Polymorphism?

**Polymorphism** means "many forms." It allows objects of different classes to be treated as objects of a common parent class.

Think of it like a remote control:
- The "play" button works on TV, DVD player, and streaming device
- Same interface, different implementations

```dart
class Animal {
  void makeSound() => print('Some sound');
}

class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');
}

class Cat extends Animal {
  @override
  void makeSound() => print('Meow!');
}

void main() {
  // Same type (Animal), different behaviors
  Animal animal1 = Dog();
  Animal animal2 = Cat();

  animal1.makeSound();  // Woof!
  animal2.makeSound();  // Meow!
}
```

---

## Why Polymorphism Matters

### Without Polymorphism (Bad)

```dart
void makeAllAnimalsSounds(List<dynamic> animals) {
  for (var animal in animals) {
    if (animal is Dog) {
      animal.bark();
    } else if (animal is Cat) {
      animal.meow();
    } else if (animal is Cow) {
      animal.moo();
    }
    // What if we add more animals? More if statements!
  }
}
```

### With Polymorphism (Good)

```dart
void makeAllAnimalsSounds(List<Animal> animals) {
  for (var animal in animals) {
    animal.makeSound();  // Each animal knows how to make its sound
  }
}
```

---

## How Polymorphism Works

```
                    ┌──────────────────┐
                    │     Animal       │
                    │──────────────────│
                    │ makeSound()      │ ◄── Common interface
                    └────────┬─────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
    ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐
    │    Dog      │   │    Cat      │   │    Cow      │
    │─────────────│   │─────────────│   │─────────────│
    │ makeSound() │   │ makeSound() │   │ makeSound() │
    │ → "Woof!"   │   │ → "Meow!"   │   │ → "Moo!"    │
    └─────────────┘   └─────────────┘   └─────────────┘

    Same method name, different implementations
```

---

## Types of Polymorphism

### 1. Runtime Polymorphism (Method Overriding)

The method called is determined at runtime based on the actual object type:

```dart
class Shape {
  double area() => 0;
}

class Rectangle extends Shape {
  double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;
}

void main() {
  List<Shape> shapes = [
    Rectangle(5, 3),
    Circle(4),
    Rectangle(2, 7),
  ];

  for (var shape in shapes) {
    print('Area: ${shape.area()}');  // Calls correct method at runtime
  }
}
```

### 2. Compile-Time Polymorphism (Overloading)

Dart doesn't support traditional method overloading, but you can achieve similar results with:

```dart
// Using optional parameters
class Calculator {
  int add(int a, [int? b, int? c]) {
    return a + (b ?? 0) + (c ?? 0);
  }
}

// Using named parameters
class Calculator2 {
  double calculate({required double a, double? b, String operation = 'add'}) {
    if (b == null) return a;
    switch (operation) {
      case 'add': return a + b;
      case 'subtract': return a - b;
      case 'multiply': return a * b;
      default: return a;
    }
  }
}
```

---

## Polymorphism with Collections

The most powerful use of polymorphism:

```dart
abstract class Drawable {
  void draw();
}

class Line extends Drawable {
  @override
  void draw() => print('Drawing a line: ────────');
}

class Rectangle extends Drawable {
  @override
  void draw() => print('Drawing a rectangle: ▭');
}

class Circle extends Drawable {
  @override
  void draw() => print('Drawing a circle: ●');
}

class Triangle extends Drawable {
  @override
  void draw() => print('Drawing a triangle: △');
}

void main() {
  // List of different shapes, all Drawable
  List<Drawable> shapes = [
    Line(),
    Rectangle(),
    Circle(),
    Triangle(),
    Circle(),
    Line(),
  ];

  // Draw all shapes - polymorphism in action!
  print('Canvas:');
  for (var shape in shapes) {
    shape.draw();
  }
}
```

---

## Polymorphism with Functions

Functions can accept the parent type but work with any child:

```dart
class Employee {
  String name;
  Employee(this.name);

  double calculatePay() => 0;
}

class HourlyEmployee extends Employee {
  double hourlyRate;
  int hoursWorked;

  HourlyEmployee(String name, this.hourlyRate, this.hoursWorked)
      : super(name);

  @override
  double calculatePay() => hourlyRate * hoursWorked;
}

class SalariedEmployee extends Employee {
  double annualSalary;

  SalariedEmployee(String name, this.annualSalary) : super(name);

  @override
  double calculatePay() => annualSalary / 12;  // Monthly
}

class ContractEmployee extends Employee {
  double projectFee;

  ContractEmployee(String name, this.projectFee) : super(name);

  @override
  double calculatePay() => projectFee;
}

// Works with ANY type of Employee!
void processPayroll(List<Employee> employees) {
  print('Payroll:');
  double total = 0;

  for (var emp in employees) {
    var pay = emp.calculatePay();
    total += pay;
    print('  ${emp.name}: \$${pay.toStringAsFixed(2)}');
  }

  print('Total: \$${total.toStringAsFixed(2)}');
}

void main() {
  var employees = [
    HourlyEmployee('Alice', 25, 40),
    SalariedEmployee('Bob', 60000),
    ContractEmployee('Charlie', 5000),
    HourlyEmployee('Diana', 30, 35),
  ];

  processPayroll(employees);
}
```

---

## Type Checking with `is`

Sometimes you need to know the actual type:

```dart
void describe(Animal animal) {
  print('This is a ${animal.runtimeType}');

  if (animal is Dog) {
    print('  It can bark!');
    animal.bark();  // Safe to call Dog-specific method
  } else if (animal is Cat) {
    print('  It can meow!');
    animal.meow();
  }
}
```

### Smart Casts

Dart automatically casts after `is` check:

```dart
void handleAnimal(Animal animal) {
  if (animal is Dog) {
    // Dart knows animal is Dog here
    animal.bark();        // No cast needed!
    animal.wagTail();     // Dog-specific method
  }
}
```

---

## Covariant Return Types

Child can return more specific type:

```dart
class Animal {
  Animal reproduce() => Animal();
}

class Dog extends Animal {
  @override
  Dog reproduce() => Dog();  // More specific return type
}

void main() {
  Dog parent = Dog();
  Dog puppy = parent.reproduce();  // Returns Dog, not just Animal
}
```

---

## Practical Example: Payment System

```dart
abstract class PaymentMethod {
  String get name;
  bool processPayment(double amount);
  void printReceipt(double amount);
}

class CreditCard extends PaymentMethod {
  String cardNumber;
  String expiryDate;

  CreditCard(this.cardNumber, this.expiryDate);

  @override
  String get name => 'Credit Card (**** ${cardNumber.substring(cardNumber.length - 4)})';

  @override
  bool processPayment(double amount) {
    print('Processing credit card payment of \$${amount.toStringAsFixed(2)}...');
    // Simulate processing
    return true;
  }

  @override
  void printReceipt(double amount) {
    print('CREDIT CARD RECEIPT');
    print('Card: $name');
    print('Amount: \$${amount.toStringAsFixed(2)}');
  }
}

class PayPal extends PaymentMethod {
  String email;

  PayPal(this.email);

  @override
  String get name => 'PayPal ($email)';

  @override
  bool processPayment(double amount) {
    print('Processing PayPal payment of \$${amount.toStringAsFixed(2)}...');
    return true;
  }

  @override
  void printReceipt(double amount) {
    print('PAYPAL RECEIPT');
    print('Account: $email');
    print('Amount: \$${amount.toStringAsFixed(2)}');
  }
}

class Cash extends PaymentMethod {
  @override
  String get name => 'Cash';

  @override
  bool processPayment(double amount) {
    print('Accepting cash payment of \$${amount.toStringAsFixed(2)}...');
    return true;
  }

  @override
  void printReceipt(double amount) {
    print('CASH RECEIPT');
    print('Amount: \$${amount.toStringAsFixed(2)}');
  }
}

// Works with ANY payment method!
class Checkout {
  void complete(PaymentMethod payment, double amount) {
    print('\n--- Processing with ${payment.name} ---');

    if (payment.processPayment(amount)) {
      print('Payment successful!');
      payment.printReceipt(amount);
    } else {
      print('Payment failed!');
    }
  }
}

void main() {
  var checkout = Checkout();

  var creditCard = CreditCard('1234567890123456', '12/25');
  var paypal = PayPal('user@email.com');
  var cash = Cash();

  checkout.complete(creditCard, 99.99);
  checkout.complete(paypal, 49.99);
  checkout.complete(cash, 25.00);
}
```

---

## Practical Example: Plugin System

```dart
abstract class Plugin {
  String get name;
  void initialize();
  void execute();
  void shutdown();
}

class LoggingPlugin extends Plugin {
  @override
  String get name => 'Logging Plugin';

  @override
  void initialize() => print('[$name] Initializing logger...');

  @override
  void execute() => print('[$name] Logging data...');

  @override
  void shutdown() => print('[$name] Closing log files...');
}

class CachePlugin extends Plugin {
  @override
  String get name => 'Cache Plugin';

  @override
  void initialize() => print('[$name] Setting up cache...');

  @override
  void execute() => print('[$name] Caching data...');

  @override
  void shutdown() => print('[$name] Clearing cache...');
}

class AnalyticsPlugin extends Plugin {
  @override
  String get name => 'Analytics Plugin';

  @override
  void initialize() => print('[$name] Connecting to analytics...');

  @override
  void execute() => print('[$name] Sending analytics...');

  @override
  void shutdown() => print('[$name] Flushing analytics queue...');
}

class Application {
  List<Plugin> plugins = [];

  void registerPlugin(Plugin plugin) {
    plugins.add(plugin);
    print('Registered: ${plugin.name}');
  }

  void start() {
    print('\n--- Starting Application ---');
    for (var plugin in plugins) {
      plugin.initialize();
    }
  }

  void run() {
    print('\n--- Running Application ---');
    for (var plugin in plugins) {
      plugin.execute();
    }
  }

  void stop() {
    print('\n--- Stopping Application ---');
    for (var plugin in plugins.reversed) {
      plugin.shutdown();
    }
  }
}

void main() {
  var app = Application();

  app.registerPlugin(LoggingPlugin());
  app.registerPlugin(CachePlugin());
  app.registerPlugin(AnalyticsPlugin());

  app.start();
  app.run();
  app.stop();
}
```

---

## Summary

| Concept | Description |
|---------|-------------|
| Polymorphism | Same interface, different implementations |
| Method Overriding | Child provides own version of parent's method |
| Runtime Polymorphism | Method called based on actual object type |
| `is` keyword | Check actual type at runtime |
| Smart casts | Automatic casting after `is` check |

---

## Quick Quiz

**Q1:** What is polymorphism?

<details>
<summary>Answer</summary>

The ability for objects of different classes to be treated as objects of a common parent class, where each class can have its own implementation of methods.

</details>

**Q2:** Why is this code better with polymorphism?

```dart
// Instead of:
if (shape is Rectangle) { /* calc rectangle area */ }
else if (shape is Circle) { /* calc circle area */ }

// We do:
shape.area();
```

<details>
<summary>Answer</summary>

- No need to check types with if/else
- Adding new shapes doesn't require changing existing code
- Each shape handles its own area calculation
- Cleaner, more maintainable code

</details>

**Q3:** When is the correct method determined in runtime polymorphism?

<details>
<summary>Answer</summary>

At runtime, based on the actual type of the object (not the declared type of the variable).

</details>

---

**Next:** Learn about abstract classes and interfaces.

---

**Continue to:** `06-AbstractAndInterfaces.md`
