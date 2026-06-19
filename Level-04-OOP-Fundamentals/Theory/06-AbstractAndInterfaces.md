# Abstract Classes and Interfaces: Promising Behaviour

## The Big Idea In One Sentence

> An **abstract class** is a blueprint you cannot build directly; it lists methods that every child **must** provide.

It is a way to say "every shape must have an `area`, but I am not going to decide how, each shape figures that out itself."

---

## A Picture To Hold In Your Head

Think of a **job description**.

A job description for "Driver" says: "must be able to drive, must be able to park." It does not actually drive anything. It is just the list of must-haves. A real person (a concrete class) then fills the role and actually does the driving.

An abstract class is that job description. It lists what every child must be able to do. The children do the actual work.

---

## What Makes A Class Abstract

You put the word `abstract` before `class`. Inside, you can have:

- **Abstract methods:** a method with no body (just a name and a semicolon). Every child **must** provide it.
- **Regular methods:** normal methods with a body. Children get these for free.

```dart
abstract class Animal {
  void makeSound();          // abstract: no body, every child must write it

  void breathe() {           // regular: has a body, children get it free
    print('Breathing...');
  }
}
```

You **cannot build an Animal directly**, because `makeSound` has no body. It is not finished. Try it and Dart stops you:

```dart
var a = Animal();   // ERROR: you cannot build an abstract class
```

Instead, a child fills in the missing method:

```dart
class Dog extends Animal {
  @override
  void makeSound() {
    print('Woof!');
  }
}

void main() {
  var d = Dog();
  d.makeSound();   // Woof!     (Dog provided this)
  d.breathe();     // Breathing... (free from Animal)
}
```

`Dog` is a **concrete** class: it filled in every abstract method, so it can be built.

---

## Why This Is Useful

An abstract class forces every child to provide certain behaviour. That means you can safely treat them all the same (polymorphism, from the last lesson), knowing the method is guaranteed to exist.

```dart
abstract class Shape {
  double area();                 // every shape must provide this

  void describe() {              // shared, written once
    print('My area is ${area()}');
  }
}

class Square extends Shape {
  double side;
  Square(this.side);

  @override
  double area() => side * side;
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

void main() {
  List<Shape> shapes = [Square(4), Circle(2)];
  for (var s in shapes) {
    s.describe();
  }
}
```

Output:

```
My area is 16.0
My area is 12.56
```

`describe()` is written once in the parent and works for every shape, because the parent guarantees every shape has an `area()`.

---

## Interfaces: A Pure Contract With `implements`

Sometimes you do not want to share any code, you just want a **contract**: a list of methods a class promises to have. In Dart, an abstract class with only abstract methods works as an **interface**, and a class uses `implements` to promise it.

```dart
abstract class Notifier {
  void send(String message);
}

class EmailNotifier implements Notifier {
  @override
  void send(String message) {
    print('Email: $message');
  }
}

class SmsNotifier implements Notifier {
  @override
  void send(String message) {
    print('SMS: $message');
  }
}

void main() {
  List<Notifier> channels = [EmailNotifier(), SmsNotifier()];
  for (var c in channels) {
    c.send('Hello!');
  }
}
```

Output:

```
Email: Hello!
SMS: Hello!
```

Both classes promise to be a `Notifier`, so both **must** have a `send` method. That promise lets us treat them all as `Notifier` and call `send` on each.

---

## extends vs implements (The Key Difference)

This is the part to get clear:

- **`extends`**: you inherit the parent's code. If the parent has a finished method, you get it for free.
- **`implements`**: you only borrow the parent's list of methods. You must write **all** of them yourself, even ones that had a body.

```dart
class Animal {
  void eat() => print('Eating');
}

class Dog extends Animal {
  // gets eat() for free
}

class Robot implements Animal {
  @override
  void eat() => print('Robot pretends to eat');   // MUST write it
}
```

`Dog extends Animal` reuses `eat`. `Robot implements Animal` only copies the promise, so it must provide its own `eat`.

A simple way to remember:
- `extends` = "I **am a** kind of this, and I reuse its code."
- `implements` = "I **can do** what this promises, but I do it all my own way."

---

## Promising More Than One Thing

A class can `implements` **several** interfaces at once (separated by commas). This is how an object can have many capabilities.

```dart
abstract class Flyable {
  void fly();
}
abstract class Swimmable {
  void swim();
}

class Duck implements Flyable, Swimmable {
  @override
  void fly() => print('Duck flies');

  @override
  void swim() => print('Duck swims');
}

void main() {
  var d = Duck();
  d.fly();    // Duck flies
  d.swim();   // Duck swims
}
```

A Duck can fly **and** swim, because it promises both interfaces. (A class can only `extends` one parent, but it can `implements` many interfaces.)

---

## Why This Matters In Flutter

Flutter is full of contracts. Many Flutter features say "give me any object that can do X." You provide a class that implements that promise, and Flutter uses it without caring about the details. You will also use abstract classes to define things like "a Repository that can load and save data," then write different versions (one for the network, one for testing) that all keep the same promise.

---

## The Top Mistakes Beginners Make

### Mistake 1: Trying to build an abstract class

```dart
var a = Animal();   // ERROR: cannot build an abstract class
var d = Dog();      // GOOD: build a concrete child instead
```

### Mistake 2: Forgetting to provide an abstract method

```dart
class Fish extends Animal {
  // ERROR: did not provide makeSound(), so this will not compile
}
```

If the parent has an abstract method, the child must fill it in.

### Mistake 3: Expecting free code with `implements`

```dart
class Robot implements Animal {
  // ERROR: must write eat() yourself, implements gives no free code
}
```

`implements` copies the promise, not the code. Write every method yourself.

### Mistake 4: Forgetting `@override`

When you fill in an abstract method, add `@override`. It is expected and catches typos.

---

## One-Minute Recap

- `abstract class` is a blueprint you cannot build directly.
- An **abstract method** has no body; every child must provide it.
- A child fills in the abstract methods to become **concrete** (buildable).
- `extends` reuses the parent's code; `implements` only copies the promise (write everything yourself).
- A class can `extends` one parent but `implements` many interfaces.
- Think: `extends` = "is a", `implements` = "can do".

---

## Quick Quiz

**Q1.** Why can't you write `var a = Animal();` if `Animal` is abstract?

<details>
<summary>Answer</summary>
An abstract class has unfinished (abstract) methods, so it is not complete enough to build. You build a concrete child that fills them in.
</details>

**Q2.** What does a child have to do when it `extends` an abstract class?

<details>
<summary>Answer</summary>
It must provide a body for every abstract method. It gets the regular (already-written) methods for free.
</details>

**Q3.** What is the difference between `extends` and `implements`?

<details>
<summary>Answer</summary>
`extends` inherits the parent's code (you get finished methods for free). `implements` only copies the list of methods as a promise; you must write all of them yourself.
</details>

**Q4.** Can a class implement more than one interface?

<details>
<summary>Answer</summary>
Yes. You can `implements` several interfaces (comma-separated). You can only `extends` one parent, though.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
abstract class Shape {
  double area();
  void show() {
    print('Area: ${area()}');
  }
}
class Square extends Shape {
  double side;
  Square(this.side);
  @override
  double area() => side * side;
}

void main() {
  Square s = Square(5);
  s.show();
}
```

### Problem 2: An abstract Animal

Write an abstract class `Animal` with an abstract method `makeSound()` and a regular method `breathe()` that prints `Breathing`. Then write a `Cow` that fills in `makeSound()` to print `Moo!`. Build a cow, call both methods.

### Problem 3: An interface with implements

Write an interface (an abstract class) `Greeter` with one method `greet()`. Then write two classes, `EnglishGreeter` (prints `Hello`) and `FrenchGreeter` (prints `Bonjour`), that each `implements Greeter`. Put both in a `List<Greeter>` and call `greet()` on each.

### Problem 4: Two interfaces

Write two interfaces, `Walker` (method `walk()`) and `Swimmer` (method `swim()`). Write a class `Frog` that implements **both** and provides both methods. Build a frog and call both.

### Problem 5: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
abstract class Tool {
  void use();
}

class Hammer extends Tool {
}

void main() {
  Tool t = Tool();
  t.use();
}
```

---

## Assignment Answers

### Problem 1: Predict the output

```
Area: 25.0
```

`show()` is written once in `Shape` and calls `area()`. `Square` provides `area()` as `5 * 5 = 25`, so `show()` prints `Area: 25.0`.

### Problem 2: An abstract Animal

```dart
abstract class Animal {
  void makeSound();

  void breathe() {
    print('Breathing');
  }
}

class Cow extends Animal {
  @override
  void makeSound() {
    print('Moo!');
  }
}

void main() {
  var cow = Cow();
  cow.makeSound();   // Moo!
  cow.breathe();     // Breathing
}
```

`Cow` fills in the abstract `makeSound()`, so it can be built. It gets `breathe()` for free from `Animal`.

### Problem 3: An interface with implements

```dart
abstract class Greeter {
  void greet();
}

class EnglishGreeter implements Greeter {
  @override
  void greet() => print('Hello');
}

class FrenchGreeter implements Greeter {
  @override
  void greet() => print('Bonjour');
}

void main() {
  List<Greeter> greeters = [EnglishGreeter(), FrenchGreeter()];
  for (var g in greeters) {
    g.greet();
  }
}
```

Output:

```
Hello
Bonjour
```

Both classes promise to be a `Greeter`, so both must have `greet()`. That lets us treat them all as `Greeter` in the list.

### Problem 4: Two interfaces

```dart
abstract class Walker {
  void walk();
}

abstract class Swimmer {
  void swim();
}

class Frog implements Walker, Swimmer {
  @override
  void walk() => print('Frog hops');

  @override
  void swim() => print('Frog swims');
}

void main() {
  var f = Frog();
  f.walk();   // Frog hops
  f.swim();   // Frog swims
}
```

`Frog` promises both interfaces, so it must provide both methods. A class can implement as many interfaces as it needs.

### Problem 5: Spot the bugs

The two mistakes:

1. `class Hammer extends Tool {}` does not provide the abstract `use()` method, so it will not compile.
2. `Tool t = Tool();` tries to build the abstract class directly, which is not allowed.

Fixed:

```dart
abstract class Tool {
  void use();
}

class Hammer extends Tool {
  @override
  void use() => print('Bang!');
}

void main() {
  Tool t = Hammer();   // build a concrete child
  t.use();             // Bang!
}
```

`Hammer` now fills in `use()`, and we build a `Hammer` (a concrete class) instead of the abstract `Tool`.

---

**Next:** `07-Mixins.md`, the last OOP lesson, where you share the same ability across many unrelated classes.
