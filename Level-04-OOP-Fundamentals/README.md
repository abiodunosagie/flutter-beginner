# Level 4: Object-Oriented Programming Fundamentals

Welcome to Level 4! You'll learn how to organize code using objects and classes - the building blocks of Flutter apps.

---

## What You'll Learn

### Core OOP Concepts
- Classes and Objects
- Constructors
- Properties and Methods
- Encapsulation (private/public)
- Getters and Setters

### Advanced OOP
- Inheritance
- Polymorphism
- Abstract Classes
- Interfaces
- Mixins

---

## Learning Path

### Theory (Read First)
1. `Theory/01-ClassesAndObjects.md` - Blueprint and instances
2. `Theory/02-Constructors.md` - Creating objects
3. `Theory/03-Encapsulation.md` - Hiding implementation
4. `Theory/04-Inheritance.md` - Extending classes
5. `Theory/05-Polymorphism.md` - Many forms
6. `Theory/06-AbstractAndInterfaces.md` - Contracts
7. `Theory/07-Mixins.md` - Code reuse

### Examples (Study Second)
1. `Examples/Example01-BasicClasses.dart`
2. `Examples/Example02-Constructors.dart`
3. `Examples/Example03-Inheritance.dart`
4. `Examples/Example04-Polymorphism.dart`
5. `Examples/Example05-RealWorldOOP.dart`

### Exercises (Practice Last)
- `Exercises/Exercises.md`

---

## Prerequisites

Complete Level 3 (Functions & Collections) first. You should know:
- Functions with parameters
- Return values
- Lists, Maps, and Sets
- Anonymous functions

---

## Key Concepts Preview

### Classes and Objects

```dart
// Class = Blueprint
class Dog {
  String name;
  int age;

  Dog(this.name, this.age);

  void bark() {
    print('$name says: Woof!');
  }
}

// Object = Instance
var myDog = Dog('Buddy', 3);
myDog.bark();  // Buddy says: Woof!
```

### Inheritance

```dart
class Animal {
  void eat() => print('Eating...');
}

class Cat extends Animal {
  void meow() => print('Meow!');
}

var cat = Cat();
cat.eat();   // From Animal
cat.meow();  // From Cat
```

### Encapsulation

```dart
class BankAccount {
  double _balance = 0;  // Private

  double get balance => _balance;  // Read-only access

  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }
}
```

---

## Why OOP Matters for Flutter

Flutter is built on OOP principles:

```dart
// Every Flutter widget is a class!
class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

---

## Learning Objectives

By the end of this level, you will:

1. ✅ Create classes with properties and methods
2. ✅ Use different constructor types
3. ✅ Apply encapsulation with private members
4. ✅ Extend classes with inheritance
5. ✅ Implement polymorphism
6. ✅ Create abstract classes and interfaces
7. ✅ Use mixins for code reuse
8. ✅ Design object-oriented solutions

---

## Time Estimate

- Theory: 90-120 minutes
- Examples: 60-75 minutes
- Exercises: 90-120 minutes

**Total: 4-5 hours**

---

## Quick Tips

💡 **Class Naming**: Use PascalCase for class names: `MyClass`, `BankAccount`

💡 **Private Members**: Prefix with underscore: `_privateField`

💡 **Composition over Inheritance**: Often better to "have a" than "be a"

💡 **Single Responsibility**: Each class should do one thing well

---

**Start Here:** `Theory/01-ClassesAndObjects.md`
