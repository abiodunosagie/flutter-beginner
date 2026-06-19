# Polymorphism: One Type, Many Behaviours

## The Big Idea In One Sentence

> Polymorphism means you can treat many different child objects as their shared parent type, and each one still does its **own** version of a method.

The word looks scary. It just means "many forms." You already have everything you need to understand it from the Inheritance lesson.

---

## A Picture To Hold In Your Head

Think of the **play button** on a remote.

- You press one button: "play."
- On a TV it plays a show. On a music player it plays a song. On a game it starts the game.

Same button, different result depending on the device. That is polymorphism: one instruction (`play`), many behaviours.

---

## The Core Idea In Code

Make a parent `Animal` with a `makeSound` method, and let each child override it:

```dart
class Animal {
  void makeSound() {
    print('Some sound');
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print('Woof!');
  }
}

class Cat extends Animal {
  @override
  void makeSound() {
    print('Meow!');
  }
}
```

Now the magic. You can store a `Dog` or a `Cat` in an `Animal` box, and when you call `makeSound`, each one does its own version:

```dart
void main() {
  Animal a = Dog();
  Animal b = Cat();

  a.makeSound();   // Woof!
  b.makeSound();   // Meow!
}
```

Even though `a` and `b` are both typed as `Animal`, Dart looks at what they **really are** (a Dog, a Cat) and runs the right `makeSound`. That choice happens while the program runs.

---

## Why This Is So Useful

The real power shows up with a **list**. You can put different animals in one `List<Animal>` and treat them all the same:

```dart
void main() {
  List<Animal> animals = [Dog(), Cat(), Dog()];

  for (var animal in animals) {
    animal.makeSound();
  }
}
```

Output:

```
Woof!
Meow!
Woof!
```

One loop. One line inside it. Each animal makes its own sound. You did not need any `if` checks asking "is this a dog? is this a cat?". Each object already knows what to do.

Compare the messy way without polymorphism:

```dart
for (var animal in animals) {
  if (animal is Dog) {
    animal.makeSound();
  } else if (animal is Cat) {
    animal.makeSound();
  }
  // add a new animal? add another if... ugh
}
```

The polymorphic version (`animal.makeSound()`) never needs changing, even when you add a new animal type. That is the whole point.

---

## Checking The Real Type With `is`

Sometimes you really do need to know what an object actually is. The `is` keyword checks the type and gives back a `bool`:

```dart
class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');

  void fetch() => print('Fetching the ball!');
}

void main() {
  Animal pet = Dog();

  print(pet is Dog);     // true
  print(pet is Cat);     // false

  if (pet is Dog) {
    pet.fetch();         // Dart now knows pet is a Dog, so this is allowed
  }
}
```

After `if (pet is Dog)`, Dart is smart: inside that block it treats `pet` as a `Dog`, so you can call dog-only methods like `fetch()`. This is called a **smart cast**. You did not have to convert anything yourself.

---

## A Practical Example: Paying Employees

This is where polymorphism really earns its keep. Different employees are paid in different ways, but you can process them all with one function.

```dart
class Employee {
  String name;
  Employee(this.name);

  double monthlyPay() {
    return 0;
  }
}

class HourlyEmployee extends Employee {
  double hourlyRate;
  int hours;

  HourlyEmployee(String name, this.hourlyRate, this.hours) : super(name);

  @override
  double monthlyPay() {
    return hourlyRate * hours;
  }
}

class SalariedEmployee extends Employee {
  double yearlySalary;

  SalariedEmployee(String name, this.yearlySalary) : super(name);

  @override
  double monthlyPay() {
    return yearlySalary / 12;
  }
}

void main() {
  List<Employee> team = [
    HourlyEmployee('Ada', 20, 100),    // 20 * 100 = 2000
    SalariedEmployee('Bola', 60000),   // 60000 / 12 = 5000
  ];

  for (var emp in team) {
    print('${emp.name} earns ${emp.monthlyPay()}');
  }
}
```

Output:

```
Ada earns 2000.0
Bola earns 5000.0
```

The loop calls `monthlyPay()` on every employee. Each kind works out its pay its own way. If you add a `ContractEmployee` later, this loop does not change at all.

---

## Why This Matters In Flutter

A Flutter screen is a list of widgets, and they are all treated as the shared type `Widget`. A `Text`, a `Button`, an `Image`, all in one list, all drawn the same way: "every widget, build yourself." That is polymorphism, and it is the core of how Flutter shows a screen.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting `@override` on the child's method

```dart
class Cat extends Animal {
  void makeSound() => print('Meow!');   // works, but should have @override
}
```

It still runs, but `@override` is expected and catches typos. Always add it.

### Mistake 2: Calling a child-only method on a parent-typed variable

```dart
Animal pet = Dog();
pet.fetch();           // ERROR: Animal has no fetch()
if (pet is Dog) {
  pet.fetch();         // GOOD: checked first, now allowed
}
```

If the variable is typed as the parent, you can only call methods the parent has, unless you check with `is` first.

### Mistake 3: Thinking the variable's type decides the behaviour

```dart
Animal a = Dog();
a.makeSound();   // Woof!  (it runs Dog's version, not Animal's)
```

Dart runs the method of the **real** object (Dog), not the declared type (Animal).

---

## One-Minute Recap

- Polymorphism: treat many child objects as their shared parent type.
- Each child does its **own** version of an overridden method.
- Put different children in a `List<Parent>` and loop, no `if` checks needed.
- Dart runs the method of the **real** object, decided while the program runs.
- `is` checks the real type and gives a `bool`. After `if (x is Dog)`, Dart lets you use Dog-only methods (a smart cast).

---

## Quick Quiz

**Q1.** What does this print?

```dart
class Animal {
  void makeSound() => print('...');
}
class Cow extends Animal {
  @override
  void makeSound() => print('Moo!');
}
void main() {
  Animal a = Cow();
  a.makeSound();
}
```

<details>
<summary>Answer</summary>
`Moo!`. Even though `a` is typed `Animal`, the real object is a Cow, so Dart runs Cow's `makeSound`.
</details>

**Q2.** Why is `animal.makeSound()` better than a chain of `if (animal is Dog) ...` checks?

<details>
<summary>Answer</summary>
Each object already knows how to make its own sound, so no type checks are needed. When you add a new animal type, the loop does not change at all.
</details>

**Q3.** What does `pet is Dog` give back?

<details>
<summary>Answer</summary>
A `bool`: `true` if `pet` is really a Dog, `false` otherwise.
</details>

**Q4.** After `if (pet is Dog) { ... }`, why can you call `pet.fetch()` inside the block?

<details>
<summary>Answer</summary>
Because of a smart cast: once Dart has checked `pet` is a Dog, it treats it as a Dog inside that block, so Dog-only methods are allowed.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
class Shape {
  double area() => 0;
}
class Square extends Shape {
  double side;
  Square(this.side);
  @override
  double area() => side * side;
}
class Rect extends Shape {
  double w, h;
  Rect(this.w, this.h);
  @override
  double area() => w * h;
}

void main() {
  List<Shape> shapes = [Square(3), Rect(2, 5)];
  for (var s in shapes) {
    print(s.area());
  }
}
```

### Problem 2: Animal sounds

Write an `Animal` class with a method `makeSound()` that prints `Some sound`. Then write `Dog` and `Cat` subclasses that override it to print `Woof!` and `Meow!`. Put one of each in a `List<Animal>` and loop, calling `makeSound()` on each.

### Problem 3: Employee pay

Write an `Employee` base class with a `String name` and a method `double pay()` that returns 0. Add a `Manager` (fixed `pay()` of 5000) and a `Cleaner` (fixed `pay()` of 2000), each calling `super`. Put both in a `List<Employee>` and print each name with its pay.

### Problem 4: Use `is`

Using the `Animal`/`Dog` classes, add a `fetch()` method to `Dog` only. Then write code with `Animal pet = Dog();` that checks `if (pet is Dog)` and, inside, calls `fetch()`. Print whether `pet is Cat` too.

### Problem 5: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
class Vehicle {
  void move() => print('moving');
}
class Plane extends Vehicle {
  void fly() => print('flying');
}

void main() {
  Vehicle v = Plane();
  v.fly();
  print(v is Plane);
}
```

---

## Assignment Answers

### Problem 1: Predict the output

```
9.0
10.0
```

The loop calls `area()` on each shape. `Square(3)` gives `3 * 3 = 9`, `Rect(2, 5)` gives `2 * 5 = 10`. Each object runs its own overridden `area()`. (They show `.0` because `area` returns a `double`.)

### Problem 2: Animal sounds

```dart
class Animal {
  void makeSound() {
    print('Some sound');
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print('Woof!');
  }
}

class Cat extends Animal {
  @override
  void makeSound() {
    print('Meow!');
  }
}

void main() {
  List<Animal> animals = [Dog(), Cat()];
  for (var a in animals) {
    a.makeSound();
  }
}
```

Output:

```
Woof!
Meow!
```

Both are stored as `Animal`, but each runs its own `makeSound`. The loop never asks what type each one is.

### Problem 3: Employee pay

```dart
class Employee {
  String name;
  Employee(this.name);

  double pay() => 0;
}

class Manager extends Employee {
  Manager(String name) : super(name);
  @override
  double pay() => 5000;
}

class Cleaner extends Employee {
  Cleaner(String name) : super(name);
  @override
  double pay() => 2000;
}

void main() {
  List<Employee> staff = [Manager('Ada'), Cleaner('Bola')];
  for (var e in staff) {
    print('${e.name}: ${e.pay()}');
  }
}
```

Output:

```
Ada: 5000.0
Bola: 2000.0
```

One loop pays everyone, even though each role calculates pay differently.

### Problem 4: Use `is`

```dart
class Animal {
  void makeSound() => print('Some sound');
}

class Cat extends Animal {
  @override
  void makeSound() => print('Meow!');
}

class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');

  void fetch() => print('Fetching!');
}

void main() {
  Animal pet = Dog();

  if (pet is Dog) {
    pet.fetch();      // allowed: Dart knows pet is a Dog here
  }
  print(pet is Cat);  // false
}
```

Output:

```
Fetching!
false
```

`fetch()` only exists on `Dog`. We can call it after the `is Dog` check, because the smart cast lets Dart treat `pet` as a Dog inside the block. `pet is Cat` is `false` because `pet` is really a Dog.

### Problem 5: Spot the bugs

The two mistakes:

1. `Plane` overrides nothing here; `fly()` is a new method, which is fine, but `v.fly()` fails because `v` is typed `Vehicle`, and `Vehicle` has no `fly()`. You must check the type first.
2. Because of that, `fly()` can only be called after `if (v is Plane)`.

Fixed:

```dart
void main() {
  Vehicle v = Plane();

  if (v is Plane) {
    v.fly();          // allowed after the check
  }
  print(v is Plane);  // true
}
```

Output:

```
flying
true
```

The lesson: a variable typed as the parent can only use parent methods directly. To use a child-only method like `fly()`, check with `is` first, then the smart cast lets you call it.

---

**Next:** `06-AbstractAndInterfaces.md`, where you make a parent that promises behaviour without doing it itself.
