# Mixins: Sharing Abilities Across Classes

## The Big Idea In One Sentence

> A **mixin** is a bundle of abilities you can drop into any class, so different classes can share the same skill without being related.

It is the answer to "I want several unrelated classes to all be able to do X."

---

## A Picture To Hold In Your Head

Think of **superpowers** in a game.

- A **class** decides what a character **is**: a Wizard, a Knight, a Robot.
- A **mixin** is a power you can hand to any of them: flying, swimming, glowing.

A Wizard and a Robot are totally different, but both could get the "flying" power. A mixin lets you give that shared power to both, without making them related.

---

## The Basics: `mixin` and `with`

You create a mixin with the word `mixin`, and you add it to a class with the word `with`.

```dart
mixin Swimmer {
  void swim() {
    print('Swimming...');
  }
}

mixin Flyer {
  void fly() {
    print('Flying...');
  }
}

class Duck with Swimmer, Flyer {
  void quack() {
    print('Quack!');
  }
}

void main() {
  var duck = Duck();
  duck.swim();    // from the Swimmer mixin
  duck.fly();     // from the Flyer mixin
  duck.quack();   // Duck's own method
}
```

`Duck with Swimmer, Flyer` means "Duck gets all the abilities from Swimmer and Flyer." Now a Duck can `swim()`, `fly()`, and `quack()`. You can add as many mixins as you like, separated by commas.

---

## Why Mixins Exist

In Dart, a class can only `extends` **one** parent. So you cannot do this:

```dart
class Duck extends Swimmer, Flyer { }   // ERROR: only one parent allowed
```

But a Duck needs both swimming and flying. Mixins solve this: you can add **many** mixins to one class.

```dart
class Duck with Swimmer, Flyer { }   // GOOD: many abilities, no problem
```

So: use `extends` for the one thing a class **is**, and `with` for the many things it **can do**.

---

## Mixins Can Hold State

A mixin can have its own data (fields), not just methods.

```dart
mixin Counter {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count = _count + 1;
  }
}

class ClickButton with Counter {
  void click() {
    increment();
    print('Clicks: $count');
  }
}

void main() {
  var b = ClickButton();
  b.click();   // Clicks: 1
  b.click();   // Clicks: 2
}
```

The `ClickButton` got the `_count` field and the `increment` method from the `Counter` mixin, then used them in its own `click` method.

---

## Mixing And Matching

The real beauty: different classes pick exactly the abilities they need.

```dart
mixin Walker {
  void walk() => print('Walking');
}
mixin Swimmer {
  void swim() => print('Swimming');
}
mixin Flyer {
  void fly() => print('Flying');
}

class Human with Walker { }                 // walks only
class Fish with Swimmer { }                 // swims only
class Duck with Walker, Swimmer, Flyer { }  // does all three

void main() {
  Duck().walk();
  Duck().swim();
  Duck().fly();
}
```

Each class takes only the powers that make sense for it.

---

## Combining `extends` And `with`

You can use a mixin **and** inheritance together. The order is: `extends` first, then `with`.

```dart
class Animal {
  String name;
  Animal(this.name);

  void breathe() => print('$name is breathing');
}

mixin Swimmer {
  void swim() => print('Swimming');
}

class Penguin extends Animal with Swimmer {
  Penguin(String name) : super(name);

  void waddle() => print('$name waddles');
}

void main() {
  var p = Penguin('Pingu');
  p.breathe();   // from Animal (extends)
  p.swim();      // from Swimmer (with)
  p.waddle();    // Penguin's own
}
```

A Penguin **is** an Animal (so it `extends Animal`) and **can** swim (so it adds `with Swimmer`).

---

## Restricting A Mixin With `on`

Sometimes a mixin needs something from the class it is added to. The `on` keyword says "this mixin can only be added to this kind of class."

```dart
class Animal {
  String name;
  Animal(this.name);
}

mixin Pet on Animal {
  void greetOwner() {
    print('$name greets their owner');   // uses 'name' from Animal
  }
}

class Dog extends Animal with Pet {
  Dog(String name) : super(name);
}

void main() {
  var d = Dog('Rex');
  d.greetOwner();   // Rex greets their owner
}
```

`mixin Pet on Animal` means "Pet can only be added to classes that extend Animal." That guarantees the `name` property exists, so the mixin can safely use it. A class that is not an Animal cannot add the `Pet` mixin.

---

## When Two Mixins Have The Same Method

If two mixins both have a method with the same name, the **last one in the list wins**.

```dart
mixin A {
  void hello() => print('Hello from A');
}
mixin B {
  void hello() => print('Hello from B');
}

class Demo with A, B { }

void main() {
  Demo().hello();   // Hello from B  (B is last)
}
```

Think of it like layers of paint: the last layer is the one you see. So if order matters, put the version you want to win **last**.

---

## Why This Matters In Flutter

Flutter uses mixins a lot to add abilities to your screens. For example, a special mixin lets a screen run animations, and another lets it keep its state alive when you switch tabs. You add the ability with `with`, and your class gains the feature. You will use this pattern often in Levels 5 and 6.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using a mixin's method without `with`

```dart
class Duck { }
Duck().swim();        // ERROR: Duck never added the Swimmer mixin

class Duck with Swimmer { }
Duck().swim();        // GOOD
```

### Mistake 2: Trying to build a mixin directly

```dart
var s = Swimmer();    // ERROR: a mixin is not a class you can build
```

A mixin is only meant to be added to a class with `with`.

### Mistake 3: Giving a mixin a constructor

Mixins cannot have constructors. If you need constructor setup, that belongs in the class, not the mixin.

### Mistake 4: Wrong order with extends and with

```dart
class Penguin with Swimmer extends Animal { }   // ERROR: wrong order
class Penguin extends Animal with Swimmer { }   // GOOD: extends first, then with
```

---

## One-Minute Recap

- A **mixin** is a bundle of abilities you add to a class.
- Create it with `mixin`, add it with `with`. Add as many as you like.
- Use mixins because a class can only `extends` one parent but can have many abilities.
- Mixins can hold their own fields and methods.
- `extends` comes first, then `with`.
- `mixin X on Y` restricts the mixin to classes that extend `Y`.
- If two mixins share a method name, the **last** one wins.

---

## Quick Quiz

**Q1.** What keyword adds a mixin to a class?

<details>
<summary>Answer</summary>
`with`. For example, `class Duck with Swimmer { }`.
</details>

**Q2.** Why use a mixin instead of `extends`?

<details>
<summary>Answer</summary>
A class can only `extends` one parent, but it can add many mixins. Use mixins to give a class several abilities that do not fit a single "is a" relationship.
</details>

**Q3.** In `class Demo with A, B` where both `A` and `B` have a `hello()` method, which runs?

<details>
<summary>Answer</summary>
`B`'s, because the last mixin in the list wins.
</details>

**Q4.** What does `mixin Pet on Animal` mean?

<details>
<summary>Answer</summary>
The `Pet` mixin can only be added to classes that extend `Animal`. This lets the mixin safely use `Animal`'s properties.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
mixin Walker {
  void walk() => print('Walking');
}
mixin Flyer {
  void fly() => print('Flying');
}

class Bird with Walker, Flyer {
  void chirp() => print('Chirp');
}

void main() {
  var b = Bird();
  b.walk();
  b.fly();
  b.chirp();
}
```

### Problem 2: Make two mixins

Write a mixin `Glowing` with a method `glow()` that prints `Glowing!`, and a mixin `Floating` with a method `float()` that prints `Floating!`. Write a class `Ghost` that uses **both** mixins, then build a ghost and call both methods.

### Problem 3: A mixin with state

Write a mixin `Score` with a private `int _points = 0`, a getter `points`, and a method `addPoint()` that adds 1. Write a class `Player` that uses the `Score` mixin and has a method `win()` that calls `addPoint()` and prints the new points. Call `win()` twice.

### Problem 4: extends plus with

Write a class `Vehicle` with a `String name` and a method `start()` that prints `<name> starting`. Write a mixin `GpsTracker` with a method `track()` that prints `Tracking...`. Write a class `Car` that **extends** `Vehicle` and **uses** `GpsTracker`. Build a car, call `start()` and `track()`.

### Problem 5: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
mixin Barker {
  void bark() => print('Woof');
}

class Dog {
}

void main() {
  var b = Barker();
  b.bark();
}
```

---

## Assignment Answers

### Problem 1: Predict the output

```
Walking
Flying
Chirp
```

`Bird` got `walk()` from the Walker mixin and `fly()` from the Flyer mixin, and has its own `chirp()`. All three work.

### Problem 2: Make two mixins

```dart
mixin Glowing {
  void glow() => print('Glowing!');
}

mixin Floating {
  void float() => print('Floating!');
}

class Ghost with Glowing, Floating { }

void main() {
  var g = Ghost();
  g.glow();    // Glowing!
  g.float();   // Floating!
}
```

`Ghost with Glowing, Floating` gives the ghost both abilities. The class body can even be empty, because all its abilities come from the mixins.

### Problem 3: A mixin with state

```dart
mixin Score {
  int _points = 0;

  int get points => _points;

  void addPoint() {
    _points = _points + 1;
  }
}

class Player with Score {
  void win() {
    addPoint();
    print('Points: $points');
  }
}

void main() {
  var p = Player();
  p.win();   // Points: 1
  p.win();   // Points: 2
}
```

The mixin carries the `_points` field and the `addPoint` method. The `Player` class uses them in `win()`. Mixins can hold data, not just methods.

### Problem 4: extends plus with

```dart
class Vehicle {
  String name;
  Vehicle(this.name);

  void start() => print('$name starting');
}

mixin GpsTracker {
  void track() => print('Tracking...');
}

class Car extends Vehicle with GpsTracker {
  Car(String name) : super(name);
}

void main() {
  var c = Car('Toyota');
  c.start();   // Toyota starting
  c.track();   // Tracking...
}
```

A `Car` **is** a Vehicle (so it `extends Vehicle`) and **can** be tracked (so it adds `with GpsTracker`). Remember the order: `extends` first, then `with`.

### Problem 5: Spot the bugs

The two mistakes:

1. `var b = Barker();` tries to build a mixin directly. A mixin is not a buildable class; it must be added to a class with `with`.
2. `Dog` never uses the `Barker` mixin, so it has no `bark()` method anyway.

Fixed:

```dart
mixin Barker {
  void bark() => print('Woof');
}

class Dog with Barker { }

void main() {
  var d = Dog();
  d.bark();   // Woof
}
```

We added `Barker` to `Dog` with `with`, then built a `Dog` (a real class) and called `bark()` on it.

---

## Level 4 Complete!

You now know the whole of Object-Oriented Programming basics:

- Classes and Objects
- Constructors
- Encapsulation
- Inheritance
- Polymorphism
- Abstract Classes and Interfaces
- Mixins

These ideas are the backbone of every Flutter app you will build.

**Next:** open the `Examples/` and `Exercises/` folders to practise, then head to `../../Level-05-Flutter-Foundations/Theory/00-LearningPath.md` to start building real apps with Flutter.
