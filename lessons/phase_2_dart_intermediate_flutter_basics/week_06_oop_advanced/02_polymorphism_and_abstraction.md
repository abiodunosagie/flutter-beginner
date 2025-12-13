# Week 6, Day 3-4: Polymorphism and Abstraction

## Polymorphism - Many Forms

### What is Polymorphism?

**Polymorphism** means "many forms." One interface, multiple implementations.

**Real-world analogy:**
- **"Make a sound"** instruction works for any animal
  - Dog → Barks
  - Cat → Meows
  - Bird → Chirps
- Same instruction, different results based on who receives it

**In programming:**
- Same method name
- Different behavior based on object type
- Treat different objects uniformly

---

## Polymorphism in Action

```dart
class Animal {
  String name;

  Animal(this.name);

  void makeSound() {
    print('$name makes a sound');
  }
}

class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print('$name barks: Woof!');
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  void makeSound() {
    print('$name meows: Meow!');
  }
}

class Bird extends Animal {
  Bird(String name) : super(name);

  @override
  void makeSound() {
    print('$name chirps: Tweet!');
  }
}

void main() {
  // Polymorphism in action!
  List<Animal> zoo = [
    Dog('Buddy'),
    Cat('Whiskers'),
    Bird('Tweety'),
    Dog('Max'),
  ];

  // Same code, different behavior
  for (Animal animal in zoo) {
    animal.makeSound();  // Each makes their OWN sound!
  }
}
```

**Output:**
```
Buddy barks: Woof!
Whiskers meows: Meow!
Tweety chirps: Tweet!
Max barks: Woof!
```

**Key insight:** We treat all as `Animal`, but each behaves as its specific type!

---

## Why Polymorphism Matters

### Without Polymorphism (BAD)

```dart
void main() {
  Dog dog = Dog('Buddy');
  Cat cat = Cat('Whiskers');
  Bird bird = Bird('Tweety');

  // Have to know specific type
  dog.makeSound();
  cat.makeSound();
  bird.makeSound();

  // Can't put in same list easily
  // Different types, different handling
}
```

### With Polymorphism (GOOD)

```dart
void main() {
  List<Animal> animals = [Dog('Buddy'), Cat('Whiskers'), Bird('Tweety')];

  // Same code for all!
  for (Animal animal in animals) {
    animal.makeSound();
  }
}
```

---

## Real-World Example: Payment System

```dart
class Payment {
  double amount;

  Payment(this.amount);

  void processPayment() {
    print('Processing \$${amount.toStringAsFixed(2)}');
  }
}

class CreditCardPayment extends Payment {
  String cardNumber;

  CreditCardPayment(double amount, this.cardNumber) : super(amount);

  @override
  void processPayment() {
    print('Processing credit card payment...');
    print('Card: ${cardNumber.substring(cardNumber.length - 4)}');
    print('Amount: \$${amount.toStringAsFixed(2)}');
  }
}

class PayPalPayment extends Payment {
  String email;

  PayPalPayment(double amount, this.email) : super(amount);

  @override
  void processPayment() {
    print('Processing PayPal payment...');
    print('Email: $email');
    print('Amount: \$${amount.toStringAsFixed(2)}');
  }
}

class CryptoPayment extends Payment {
  String walletAddress;

  CryptoPayment(double amount, this.walletAddress) : super(amount);

  @override
  void processPayment() {
    print('Processing crypto payment...');
    print('Wallet: ${walletAddress.substring(0, 10)}...');
    print('Amount: \$${amount.toStringAsFixed(2)} in BTC');
  }
}

void checkout(Payment payment) {
  // Works with ANY payment type!
  payment.processPayment();
}

void main() {
  checkout(CreditCardPayment(99.99, '1234567812345678'));
  print('---');
  checkout(PayPalPayment(49.99, 'user@example.com'));
  print('---');
  checkout(CryptoPayment(149.99, 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh'));
}
```

---

## Abstract Classes - Templates

**Abstract class** = A class that can't be instantiated directly. It's a template for children.

**When to use:**
- Define common interface
- Force children to implement certain methods
- Some methods have default implementation, some don't

### Syntax

```dart
abstract class ClassName {
  // Can have regular methods
  void regularMethod() {
    print('Implementation');
  }

  // Can have abstract methods (no body)
  void abstractMethod();  // Children MUST implement
}
```

### Example: Shape Template

```dart
abstract class Shape {
  String color;

  Shape(this.color);

  // Abstract method - children MUST implement
  double calculateArea();

  // Abstract method
  double calculatePerimeter();

  // Regular method - all shapes can use
  void displayInfo() {
    print('Color: $color');
    print('Area: ${calculateArea().toStringAsFixed(2)}');
    print('Perimeter: ${calculatePerimeter().toStringAsFixed(2)}');
  }
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(String color, this.width, this.height) : super(color);

  @override
  double calculateArea() {
    return width * height;
  }

  @override
  double calculatePerimeter() {
    return 2 * (width + height);
  }
}

class Circle extends Shape {
  double radius;

  Circle(String color, this.radius) : super(color);

  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }

  @override
  double calculatePerimeter() {
    return 2 * 3.14159 * radius;
  }
}

void main() {
  // Shape shape = Shape('red');  // ERROR! Can't instantiate abstract class

  Rectangle rect = Rectangle('blue', 5, 3);
  Circle circle = Circle('red', 4);

  rect.displayInfo();
  print('---');
  circle.displayInfo();

  // Polymorphism with abstract class
  List<Shape> shapes = [rect, circle];
  for (Shape shape in shapes) {
    print('Area: ${shape.calculateArea()}');
  }
}
```

---

## Interfaces (implements)

In Dart, **any class** can be used as an interface with `implements`.

**Difference:**
- **extends** = Inheritance (get implementation)
- **implements** = Interface (must provide all implementation)

### Example: Flyable Interface

```dart
class Flyable {
  void fly() {}
  void land() {}
}

class Bird implements Flyable {
  @override
  void fly() {
    print('Bird is flying');
  }

  @override
  void land() {
    print('Bird is landing');
  }
}

class Airplane implements Flyable {
  @override
  void fly() {
    print('Airplane is flying');
  }

  @override
  void land() {
    print('Airplane is landing');
  }
}

void main() {
  List<Flyable> flyingThings = [Bird(), Airplane()];

  for (Flyable thing in flyingThings) {
    thing.fly();
    thing.land();
  }
}
```

### Multiple Interfaces

```dart
class Swimmable {
  void swim() {}
}

class Flyable {
  void fly() {}
}

// Can implement multiple interfaces!
class Duck implements Flyable, Swimmable {
  @override
  void fly() {
    print('Duck is flying');
  }

  @override
  void swim() {
    print('Duck is swimming');
  }
}

void main() {
  Duck duck = Duck();
  duck.fly();
  duck.swim();
}
```

---

## Abstract Classes vs Interfaces

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| Keyword | `abstract class` | `implements` |
| Can have implementation | ✓ Yes | ✗ No |
| Multiple inheritance | ✗ No (single) | ✓ Yes |
| When to use | Shared implementation | Contract only |

### When to Use Each

**Abstract Class:**
```dart
// Use when classes share implementation
abstract class Employee {
  String name;

  Employee(this.name);

  // Shared implementation
  void clockIn() {
    print('$name clocked in');
  }

  // Must override
  double calculateSalary();
}
```

**Interface:**
```dart
// Use for contract only (no shared code)
class Printable {
  void print() {}
}

class Document implements Printable {
  @override
  void print() {
    print('Printing document...');
  }
}
```

---

## Complete Example: E-Commerce System

```dart
abstract class Product {
  String id;
  String name;
  double basePrice;

  Product(this.id, this.name, this.basePrice);

  // Abstract - children must implement
  double calculateFinalPrice();

  // Shared implementation
  void displayInfo() {
    print('Product: $name');
    print('Price: \$${calculateFinalPrice().toStringAsFixed(2)}');
  }
}

class PhysicalProduct extends Product {
  double weight;
  double shippingCost;

  PhysicalProduct(
    String id,
    String name,
    double basePrice,
    this.weight,
    this.shippingCost,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    return basePrice + shippingCost;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Weight: ${weight}kg');
    print('Shipping: \$${shippingCost.toStringAsFixed(2)}');
  }
}

class DigitalProduct extends Product {
  String downloadLink;

  DigitalProduct(
    String id,
    String name,
    double basePrice,
    this.downloadLink,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    return basePrice;  // No shipping!
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Download: $downloadLink');
  }
}

class SubscriptionProduct extends Product {
  int months;
  double monthlyPrice;

  SubscriptionProduct(
    String id,
    String name,
    double basePrice,
    this.months,
    this.monthlyPrice,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    double discount = months >= 12 ? 0.1 : 0;  // 10% off yearly
    return (monthlyPrice * months) * (1 - discount);
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Duration: $months months');
    print('Monthly: \$${monthlyPrice.toStringAsFixed(2)}');
  }
}

void main() {
  List<Product> cart = [
    PhysicalProduct('P001', 'Laptop', 999.99, 2.5, 15.99),
    DigitalProduct('D001', 'eBook', 9.99, 'https://download.com/book'),
    SubscriptionProduct('S001', 'Premium Plan', 0, 12, 9.99),
  ];

  double total = 0;

  for (Product product in cart) {
    product.displayInfo();
    total += product.calculateFinalPrice();
    print('---');
  }

  print('TOTAL: \$${total.toStringAsFixed(2)}');
}
```

---

## Type Checking and Casting

### is Operator

```dart
void processAnimal(Animal animal) {
  if (animal is Dog) {
    print('This is a dog!');
    animal.bark();  // Can call Dog-specific methods
  } else if (animal is Cat) {
    print('This is a cat!');
  }
}
```

### as Operator (Type Casting)

```dart
Animal animal = Dog('Buddy');

// Cast to Dog
Dog dog = animal as Dog;
dog.bark();

// Safe casting
if (animal is Dog) {
  animal.bark();  // Automatic promotion!
}
```

---

## Exercises

### Exercise 1: Vehicle Polymorphism
Create abstract Vehicle class with Car, Truck, Motorcycle children. Each calculates fuel efficiency differently.

<details>
<summary>Solution</summary>

```dart
abstract class Vehicle {
  String brand;
  String model;

  Vehicle(this.brand, this.model);

  double calculateFuelEfficiency();

  void displayInfo() {
    print('$brand $model');
    print('Fuel Efficiency: ${calculateFuelEfficiency()} MPG');
  }
}

class Car extends Vehicle {
  int cylinders;

  Car(String brand, String model, this.cylinders) : super(brand, model);

  @override
  double calculateFuelEfficiency() {
    return 30.0 - (cylinders * 2);  // More cylinders = less efficient
  }
}

class Truck extends Vehicle {
  double cargoWeight;

  Truck(String brand, String model, this.cargoWeight) : super(brand, model);

  @override
  double calculateFuelEfficiency() {
    return 20.0 - (cargoWeight / 1000);  // Heavier = less efficient
  }
}

class Motorcycle extends Vehicle {
  int engineSize;

  Motorcycle(String brand, String model, this.engineSize) : super(brand, model);

  @override
  double calculateFuelEfficiency() {
    return 50.0 - (engineSize / 100);
  }
}

void main() {
  List<Vehicle> garage = [
    Car('Toyota', 'Camry', 4),
    Truck('Ford', 'F-150', 2000),
    Motorcycle('Harley', 'Sportster', 883),
  ];

  for (Vehicle vehicle in garage) {
    vehicle.displayInfo();
    print('---');
  }
}
```
</details>

---

### Exercise 2: Media Player
Create interface Playable with play(), pause(), stop(). Implement for Song, Video, Podcast.

<details>
<summary>Solution</summary>

```dart
abstract class Playable {
  void play();
  void pause();
  void stop();
}

class Song implements Playable {
  String title;
  String artist;

  Song(this.title, this.artist);

  @override
  void play() {
    print('Playing song: $title by $artist');
  }

  @override
  void pause() {
    print('Paused: $title');
  }

  @override
  void stop() {
    print('Stopped: $title');
  }
}

class Video implements Playable {
  String title;
  int duration;

  Video(this.title, this.duration);

  @override
  void play() {
    print('Playing video: $title ($duration min)');
  }

  @override
  void pause() {
    print('Paused video: $title');
  }

  @override
  void stop() {
    print('Stopped video: $title');
  }
}

class Podcast implements Playable {
  String title;
  int episode;

  Podcast(this.title, this.episode);

  @override
  void play() {
    print('Playing podcast: $title - Episode $episode');
  }

  @override
  void pause() {
    print('Paused podcast');
  }

  @override
  void stop() {
    print('Stopped podcast');
  }
}

void main() {
  List<Playable> playlist = [
    Song('Shape of You', 'Ed Sheeran'),
    Video('Flutter Tutorial', 45),
    Podcast('Tech Talk', 42),
  ];

  for (Playable media in playlist) {
    media.play();
    media.pause();
    media.stop();
    print('---');
  }
}
```
</details>

---

## Key Takeaways

1. **Polymorphism** = One interface, many forms
2. **Abstract class** = Template with some implementation
3. **Interface** = Contract with no implementation
4. **`implements`** = Must provide all methods
5. **`is`** = Type checking
6. **`as`** = Type casting
7. **Treat different objects uniformly** = Power of polymorphism

---

## What's Next?

Tomorrow:
- **Mixins** - Reusable behaviors
- **Multiple inheritance** with mixins
- **When to use** mixins vs inheritance

You've mastered polymorphism! This is advanced OOP! 🎭✨
