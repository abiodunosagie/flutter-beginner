# Level 4: OOP Fundamentals (Learning Path)

Welcome to Level 4! This is where you learn to make your **own kinds of things** in code: a Dog, a User, a BankAccount. This is called Object-Oriented Programming (OOP), and it is the backbone of every Flutter app.

Finish Levels 1 to 3 first. OOP builds on variables, functions, and collections.

---

## How To Use These Lessons

Read them **in order**, one at a time. OOP builds on itself, so each lesson uses ideas from the lessons before it. Do not skip.

For every lesson:

1. Read it slowly.
2. Type the examples into [dartpad.dev](https://dartpad.dev) and press Run.
3. Do the **Assignment** at the bottom before peeking at the answers.

---

## The Path (Follow In Order)

### 1. Classes and Objects
**[01-ClassesAndObjects.md](01-ClassesAndObjects.md)**
A class is a blueprint (a cookie cutter); an object is a real thing built from it (a cookie). Covers properties, the constructor, and methods.

### 2. Constructors
**[02-Constructors.md](02-Constructors.md)**
Better ways to build objects: default values, named parameters (the Flutter style), named constructors, and a gentle `const`.

### 3. Encapsulation
**[03-Encapsulation.md](03-Encapsulation.md)**
Protect an object's data: make it private with `_`, and expose safe getters and setters that enforce the rules.

### 4. Inheritance
**[04-Inheritance.md](04-Inheritance.md)**
One class can build on another with `extends`. Covers `super`, method overriding, and when to use it.

### 5. Polymorphism
**[05-Polymorphism.md](05-Polymorphism.md)**
Treat many child objects as their shared parent type, where each does its own version of a method. Covers `List<Parent>`, `is`, and smart casts.

### 6. Abstract Classes and Interfaces
**[06-AbstractAndInterfaces.md](06-AbstractAndInterfaces.md)**
A parent that promises behaviour without doing it itself. Covers `abstract`, abstract methods, and `implements`.

### 7. Mixins
**[07-Mixins.md](07-Mixins.md)**
Share the same ability across unrelated classes with `mixin` and `with`. Covers state, `on`, and combining with `extends`.

---

## The Two Ideas To Hold Onto

- A **class** is a blueprint; an **object** is a real thing built from it.
- An object bundles **data** (properties) with **actions** (methods) into one neat package.

Everything else in this level is a tool built on those two ideas.

---

## After The Theory

When you finish all seven lessons:

1. **Practice** with the files in the `../Examples/` folder. Run each one.
2. **Do the Exercises** in `../Exercises/`. Try them before looking at the answers.
3. **Check yourself:** Can you write a class with properties, a constructor, and methods? Can you explain `extends` vs `implements`?

---

## Tips For Success

Do:
- Think of real-world things (a dog, a car, a user) when designing a class.
- Type the examples and run them.
- Make data private and expose safe getters/setters.

Do not:
- Rush. OOP is the foundation of everything that follows.
- Make everything public when it needs protection.
- Skip the assignments.

---

**Ready? Start here:** [01-ClassesAndObjects.md](01-ClassesAndObjects.md)
