# Mixins: Reusable Code Blocks

## What Is a Mixin?

A **mixin** is a way to reuse code in multiple classes without inheritance. Think of it as adding "capabilities" or "skills" to a class.

### Simple Analogy

Think of a video game character:
- A **class** defines what the character IS (Warrior, Mage, Archer)
- A **mixin** defines what the character CAN DO (swim, fly, climb)

You can mix and match abilities without changing what the character fundamentally is!

```dart
mixin Swimmer {
  void swim() => print('Swimming...');
}

mixin Flyer {
  void fly() => print('Flying...');
}

class Duck with Swimmer, Flyer {
  void quack() => print('Quack!');
}

void main() {
  var duck = Duck();
  duck.swim();   // From Swimmer mixin
  duck.fly();    // From Flyer mixin
  duck.quack();  // From Duck class
}
```

### Breaking Down the Syntax

```dart
mixin Swimmer {        // Define a mixin with 'mixin' keyword
  void swim() => print('Swimming...');
}

class Duck with Swimmer, Flyer {  // Use mixins with 'with' keyword
  // Duck now has swim() and fly() methods!
}
```

- `mixin` - Keyword to create a mixin
- `with` - Keyword to add mixins to a class
- You can add multiple mixins separated by commas

---

## Why Mixins?

### The Problem with Inheritance

In Dart, a class can only extend ONE other class. This is called "single inheritance."

```dart
class Animal { }
class Flyer extends Animal { }
class Swimmer extends Animal { }

// Problem: Duck needs BOTH flying AND swimming!
// But Dart won't let you do this:
// class Duck extends Flyer, Swimmer { }  // ERROR!
```

This is sometimes called the "Diamond Problem":

```
        Animal
       /      \
    Flyer    Swimmer
       \      /
        Duck (???)  <- Which parent comes first?
```

### The Solution: Mixins

Mixins let you add multiple behaviors without multiple inheritance:

```dart
mixin Swimmer {
  void swim() => print('Swimming');
}

mixin Flyer {
  void fly() => print('Flying');
}

// Duck gets BOTH capabilities!
class Duck with Swimmer, Flyer { }
```

### Inheritance vs Mixins: When to Use Each

| Use Inheritance (`extends`) | Use Mixins (`with`) |
|-----------------------------|---------------------|
| When there's an "IS-A" relationship | When adding a capability |
| Dog IS-A Animal | Dog CAN-DO tricks |
| Car IS-A Vehicle | Car CAN-BE tracked with GPS |
| Only ONE parent class | Can add MANY mixins |

---

## Mixin vs Class vs Interface

| Feature | Class | Interface | Mixin |
|---------|-------|-----------|-------|
| Can be instantiated | Yes | No | No |
| Can have implementation | Yes | No* | Yes |
| Multiple "inheritance" | No | Yes | Yes |
| State (fields) | Yes | - | Yes |
| Constructor | Yes | - | No |

*In Dart, interfaces are classes but `implements` requires reimplementation

---

## Creating Mixins

### Basic Mixin

```dart
mixin Logger {
  void log(String message) {
    print('[LOG] $message');
  }

  void warn(String message) {
    print('[WARN] $message');
  }

  void error(String message) {
    print('[ERROR] $message');
  }
}

class ApiService with Logger {
  void fetchData() {
    log('Fetching data...');
    // ... fetch logic
    log('Data fetched!');
  }

  void handleError() {
    error('Something went wrong!');
  }
}
```

### Mixin with State

```dart
mixin Counter {
  int _count = 0;

  int get count => _count;

  void increment() => _count++;
  void decrement() => _count--;
  void reset() => _count = 0;
}

class ClickTracker with Counter {
  void onClick() {
    increment();
    print('Clicks: $count');
  }
}
```

---

## Combining Multiple Mixins

```dart
mixin Walkable {
  void walk() => print('Walking...');
}

mixin Swimmable {
  void swim() => print('Swimming...');
}

mixin Flyable {
  void fly() => print('Flying...');
}

// Human: walks only
class Human with Walkable { }

// Fish: swims only
class Fish with Swimmable { }

// Bird: walks and flies
class Bird with Walkable, Flyable { }

// Duck: walks, swims, and flies!
class Duck with Walkable, Swimmable, Flyable { }

void main() {
  var duck = Duck();
  duck.walk();  // Walking...
  duck.swim();  // Swimming...
  duck.fly();   // Flying...
}
```

---

## Mixins with Classes (extends + with)

You can use mixins alongside inheritance:

```dart
class Animal {
  String name;
  Animal(this.name);

  void breathe() => print('$name is breathing');
}

mixin Swimmer {
  void swim() => print('Swimming...');
}

mixin Flyer {
  void fly() => print('Flying...');
}

// Penguin: IS an Animal, CAN swim
class Penguin extends Animal with Swimmer {
  Penguin(String name) : super(name);

  void waddle() => print('$name is waddling');
}

// Eagle: IS an Animal, CAN fly
class Eagle extends Animal with Flyer {
  Eagle(String name) : super(name);

  void hunt() => print('$name is hunting');
}

// Duck: IS an Animal, CAN swim AND fly
class Duck extends Animal with Swimmer, Flyer {
  Duck(String name) : super(name);

  void quack() => print('$name says quack!');
}

void main() {
  var penguin = Penguin('Pingu');
  penguin.breathe();  // From Animal
  penguin.swim();     // From Swimmer mixin
  penguin.waddle();   // Own method
  // penguin.fly();   // ERROR! Penguins can't fly

  var duck = Duck('Donald');
  duck.breathe();  // From Animal
  duck.swim();     // From Swimmer
  duck.fly();      // From Flyer
  duck.quack();    // Own method
}
```

---

## Mixin Constraints: `on` Keyword

Sometimes you want a mixin that only works with certain classes. The `on` keyword restricts which classes can use the mixin.

### Why Use `on`?

If your mixin needs to access properties or methods from a specific class, use `on` to guarantee those exist.

```dart
class Animal {
  String name;
  Animal(this.name);
}

// This mixin can ONLY be used on Animal or its subclasses
mixin Pet on Animal {
  bool isTrained = false;

  void train() {
    isTrained = true;
    print('$name is now trained!');  // Uses 'name' from Animal
  }

  void greetOwner() {
    print('$name greets their owner!');  // Uses 'name' from Animal
  }
}

// OK: Dog is an Animal, so it can use Pet mixin
class Dog extends Animal with Pet {
  Dog(String name) : super(name);
}

// ERROR: Car is not an Animal, so it CANNOT use Pet mixin
// class Car with Pet { }  // Won't compile!

void main() {
  var dog = Dog('Buddy');
  dog.train();        // Output: Buddy is now trained!
  dog.greetOwner();   // Output: Buddy greets their owner!
}
```

### How to Read `mixin X on Y`

```dart
mixin Pet on Animal
```

Read this as: "The Pet mixin can only be used ON classes that extend Animal."

### Without `on` - The Problem

```dart
mixin Pet {
  void train() {
    print('$name is trained!');  // ERROR! What is 'name'?
  }
}

class Dog with Pet { }  // Dog has no 'name' property!
```

### With `on` - The Solution

```dart
mixin Pet on Animal {
  void train() {
    print('$name is trained!');  // OK! 'name' comes from Animal
  }
}

class Dog extends Animal with Pet { }  // Dog HAS 'name' from Animal
```

---

## Method Resolution Order

What happens when multiple mixins have the same method name? The **LAST mixin wins**!

```dart
mixin A {
  void greet() => print('Hello from A');
}

mixin B {
  void greet() => print('Hello from B');
}

mixin C {
  void greet() => print('Hello from C');
}

class Example with A, B, C { }

void main() {
  var e = Example();
  e.greet();  // "Hello from C" (last mixin wins)
}
```

### Why Does the Last One Win?

Think of it like layers of paint. The last layer covers the previous ones:

```
class Example with A, B, C

Layer 1: A's greet()     <- Painted first
Layer 2: B's greet()     <- Covers A
Layer 3: C's greet()     <- Covers B (this is what you see!)
```

### Visual: Mixin Order

```
class Example with A, B, C

When calling a method, Dart looks in this order:
  1. Example (class's own methods - checked first)
  2. C (last mixin - checked second)
  3. B (middle mixin)
  4. A (first mixin)
  5. Object (base class - checked last)
```

### Practical Tip

If order matters, put the most important mixin LAST:

```dart
// If you want DefaultLogger behavior most of the time,
// but VerboseLogger to override it for debugging:

class MyService with DefaultLogger, VerboseLogger { }
// VerboseLogger's methods will be used
```

---

## Calling Super in Mixins

Mixins can call `super` to invoke the next method in the chain:

```dart
mixin A {
  void greet() {
    print('A');
  }
}

mixin B on A {
  @override
  void greet() {
    super.greet();  // Calls A's greet
    print('B');
  }
}

mixin C on A {
  @override
  void greet() {
    super.greet();  // Calls B's greet (if B is before C)
    print('C');
  }
}

class Example with A, B, C { }

void main() {
  Example().greet();
  // Output:
  // A
  // B
  // C
}
```

---

## Practical Example: UI Capabilities

```dart
// Mixins for UI capabilities
mixin Clickable {
  bool _isPressed = false;

  void onPress() {
    _isPressed = true;
    print('Pressed!');
  }

  void onRelease() {
    _isPressed = false;
    print('Released!');
  }
}

mixin Draggable {
  double x = 0;
  double y = 0;

  void onDrag(double dx, double dy) {
    x += dx;
    y += dy;
    print('Dragged to ($x, $y)');
  }
}

mixin Resizable {
  double width = 100;
  double height = 100;

  void resize(double newWidth, double newHeight) {
    width = newWidth;
    height = newHeight;
    print('Resized to $width x $height');
  }
}

mixin Hoverable {
  bool _isHovered = false;

  void onHoverEnter() {
    _isHovered = true;
    print('Hover entered');
  }

  void onHoverExit() {
    _isHovered = false;
    print('Hover exited');
  }
}

// Button: clickable and hoverable
class Button with Clickable, Hoverable {
  String label;
  Button(this.label);
}

// Window: draggable and resizable
class Window with Draggable, Resizable {
  String title;
  Window(this.title);
}

// FloatingActionButton: clickable, draggable, hoverable
class FloatingActionButton with Clickable, Draggable, Hoverable {
  String icon;
  FloatingActionButton(this.icon);
}

void main() {
  var fab = FloatingActionButton('add');
  fab.onPress();
  fab.onDrag(10, 20);
  fab.onHoverEnter();
  fab.onRelease();
  fab.onHoverExit();
}
```

---

## Practical Example: Validation Mixins

```dart
mixin EmailValidator {
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

mixin PasswordValidator {
  bool isValidPassword(String password) {
    return password.length >= 8 &&
           password.contains(RegExp(r'[A-Z]')) &&
           password.contains(RegExp(r'[0-9]'));
  }

  String getPasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) score++;

    if (score <= 2) return 'Weak';
    if (score <= 3) return 'Medium';
    return 'Strong';
  }
}

mixin PhoneValidator {
  bool isValidPhone(String phone) {
    return RegExp(r'^\d{10,15}$').hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}

// Form that uses all validators
class RegistrationForm with EmailValidator, PasswordValidator, PhoneValidator {
  String email = '';
  String password = '';
  String phone = '';

  Map<String, List<String>> validate() {
    var errors = <String, List<String>>{};

    if (!isValidEmail(email)) {
      errors['email'] = ['Invalid email format'];
    }

    if (!isValidPassword(password)) {
      errors['password'] = ['Password must be 8+ chars with uppercase and number'];
    }

    if (!isValidPhone(phone)) {
      errors['phone'] = ['Invalid phone number'];
    }

    return errors;
  }

  void showPasswordStrength() {
    print('Password strength: ${getPasswordStrength(password)}');
  }
}

void main() {
  var form = RegistrationForm();

  form.email = 'test@email.com';
  form.password = 'MyPass123!';
  form.phone = '555-123-4567';

  var errors = form.validate();
  if (errors.isEmpty) {
    print('Form is valid!');
    form.showPasswordStrength();
  } else {
    print('Errors: $errors');
  }
}
```

---

## When to Use Mixins - Quick Guide

### Use a Mixin When:

1. **Multiple classes need the same functionality**
   ```dart
   // Many classes might need logging
   mixin Loggable {
     void log(String msg) => print('[LOG] $msg');
   }

   class UserService with Loggable { }
   class OrderService with Loggable { }
   class PaymentService with Loggable { }
   ```

2. **You want to add a capability without changing inheritance**
   ```dart
   // Dog is already an Animal, but you want to add tricks
   class Dog extends Animal with Trainable { }
   ```

3. **The functionality doesn't fit the "is-a" relationship**
   ```dart
   // A car isn't a "GPS", but it CAN have GPS tracking
   class Car with GPSTrackable { }
   ```

### DON'T Use a Mixin When:

1. **There's a clear "is-a" relationship** - Use inheritance instead
   ```dart
   // A Dog IS an Animal - use extends
   class Dog extends Animal { }
   ```

2. **You only need it in one class** - Just put the code in the class

3. **The mixin would have a constructor** - Mixins can't have constructors

---

## Best Practices

### 1. Name Mixins by Capability

```dart
// ✅ Good: Describes what it adds
mixin Printable { }
mixin Serializable { }
mixin Loggable { }
mixin Comparable { }

// ❌ Bad: Unclear purpose
mixin Helper { }
mixin Utils { }
mixin Stuff { }
```

### 2. Keep Mixins Focused

```dart
// ✅ Good: Single responsibility
mixin JsonSerializable {
  String toJson();
}

mixin XmlSerializable {
  String toXml();
}

// ❌ Bad: Too many responsibilities
mixin DataHandler {
  String toJson();
  String toXml();
  void saveToFile();
  void loadFromFile();
  void validate();
}
```

### 3. Use `on` for Dependencies

```dart
// ✅ Good: Clear dependency
mixin Saveable on Entity {
  void save() => print('Saving ${this.id}');
}

// ❌ Bad: Assumes properties exist
mixin Saveable {
  void save() => print('Saving ${(this as dynamic).id}');  // Dangerous!
}
```

---

## Summary

| Feature | Purpose |
|---------|---------|
| `mixin` | Define reusable code block |
| `with` | Use one or more mixins |
| `on` | Restrict which classes can use the mixin |
| Multiple mixins | Add many capabilities to one class |
| Method resolution | Last mixin wins for same method |

---

## Quick Quiz

**Q1:** What's the main advantage of mixins over inheritance?

<details>
<summary>Answer</summary>

You can add multiple mixins to a class, effectively achieving "multiple inheritance" of behavior without the diamond problem.

</details>

**Q2:** What does `mixin Pet on Animal` mean?

<details>
<summary>Answer</summary>

The `Pet` mixin can only be applied to classes that extend `Animal` (or `Animal` itself).

</details>

**Q3:** If you have `class X with A, B, C` and all three mixins have a `greet()` method, which one is called?

<details>
<summary>Answer</summary>

`C`'s method - the last mixin in the list wins.

</details>

---

## Level 4 Complete!

You've learned:
- Classes and Objects
- Constructors
- Encapsulation
- Inheritance
- Polymorphism
- Abstract Classes and Interfaces
- Mixins

---

**Next Level:** Start building with Flutter!

---

**Continue to:** `../../Level-05-Flutter-Foundations/README.md`
