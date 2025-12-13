# Mixins: Reusable Code Blocks

## What Is a Mixin?

A **mixin** is a way to reuse code in multiple classes without inheritance. Think of it as adding "capabilities" to a class.

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

---

## Why Mixins?

### The Problem: Diamond Problem

```
        Animal
       /      \
    Flyer    Swimmer
       \      /
        Duck (???)
```

Dart doesn't support multiple inheritance, but mixins solve this:

```dart
mixin Swimmer {
  void swim() => print('Swimming');
}

mixin Flyer {
  void fly() => print('Flying');
}

// Duck gets both capabilities!
class Duck with Swimmer, Flyer { }
```

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

Restrict which classes can use a mixin:

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
    print('$name is now trained!');
  }

  void greetOwner() {
    print('$name greets their owner!');
  }
}

// OK: Dog is an Animal
class Dog extends Animal with Pet {
  Dog(String name) : super(name);
}

// ERROR: Car is not an Animal
// class Car with Pet { }  // Won't compile!

void main() {
  var dog = Dog('Buddy');
  dog.train();
  dog.greetOwner();
}
```

---

## Method Resolution Order

When multiple mixins have the same method, the LAST one wins:

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

### Visual: Mixin Order

```
class Example with A, B, C

Resolution order (bottom to top):
  1. Example (own methods first)
  2. C (last mixin)
  3. B
  4. A (first mixin)
  5. Object (base class)
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
