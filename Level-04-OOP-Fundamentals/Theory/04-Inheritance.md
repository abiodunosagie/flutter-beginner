# Inheritance: Extending Classes

## What Is Inheritance?

**Inheritance** lets one class acquire the properties and methods of another class.

Think of it like family traits:
- A **child** inherits characteristics from a **parent**
- A **Dog** inherits from **Animal**
- A **Car** inherits from **Vehicle**

```dart
class Animal {
  void eat() => print('Eating...');
}

class Dog extends Animal {
  void bark() => print('Woof!');
}

void main() {
  var dog = Dog();
  dog.eat();   // From Animal (inherited)
  dog.bark();  // From Dog
}
```

---

## Terminology

| Term | Meaning |
|------|---------|
| Parent/Super/Base class | The class being inherited from |
| Child/Sub/Derived class | The class that inherits |
| `extends` | Keyword to inherit |
| `super` | Reference to parent class |

---

## Basic Inheritance

Use `extends` to inherit:

```dart
// Parent class
class Animal {
  String name;

  Animal(this.name);

  void eat() {
    print('$name is eating');
  }

  void sleep() {
    print('$name is sleeping');
  }
}

// Child class
class Dog extends Animal {
  String breed;

  Dog(String name, this.breed) : super(name);

  void bark() {
    print('$name says: Woof!');
  }
}

// Another child class
class Cat extends Animal {
  Cat(String name) : super(name);

  void meow() {
    print('$name says: Meow!');
  }
}

void main() {
  var dog = Dog('Buddy', 'Labrador');
  dog.eat();   // Buddy is eating (inherited)
  dog.sleep(); // Buddy is sleeping (inherited)
  dog.bark();  // Buddy says: Woof! (own method)

  var cat = Cat('Whiskers');
  cat.eat();   // Whiskers is eating (inherited)
  cat.meow();  // Whiskers says: Meow! (own method)
}
```

---

## Visual: Inheritance Hierarchy

```
        ┌─────────────┐
        │   Animal    │
        │─────────────│
        │ name        │
        │ eat()       │
        │ sleep()     │
        └──────┬──────┘
               │
       ┌───────┴───────┐
       │               │
┌──────▼──────┐ ┌──────▼──────┐
│    Dog      │ │    Cat      │
│─────────────│ │─────────────│
│ breed       │ │ meow()      │
│ bark()      │ │             │
└─────────────┘ └─────────────┘
```

---

## The `super` Keyword

Access parent class members:

```dart
class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void displayInfo() {
    print('$brand ($year)');
  }
}

class Car extends Vehicle {
  int doors;

  // Call parent constructor with super
  Car(String brand, int year, this.doors) : super(brand, year);

  @override
  void displayInfo() {
    super.displayInfo();  // Call parent's method
    print('Doors: $doors');
  }
}

void main() {
  var car = Car('Toyota', 2022, 4);
  car.displayInfo();
  // Toyota (2022)
  // Doors: 4
}
```

---

## Method Overriding

Child class can replace parent's method:

```dart
class Shape {
  double area() {
    return 0;  // Default
  }

  void describe() {
    print('This is a shape with area ${area()}');
  }
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override  // Override parent's method
  double area() {
    return width * height;
  }
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() {
    return 3.14159 * radius * radius;
  }
}

void main() {
  var rect = Rectangle(5, 3);
  var circle = Circle(4);

  rect.describe();    // This is a shape with area 15.0
  circle.describe();  // This is a shape with area 50.265...
}
```

---

## The `@override` Annotation

Always use `@override` when overriding:

```dart
class Parent {
  void greet() => print('Hello from Parent');
}

class Child extends Parent {
  @override  // Tells Dart (and developers) this is intentional
  void greet() => print('Hello from Child');

  // @override
  // void greet2() { }  // ERROR! greet2 doesn't exist in Parent
}
```

Benefits:
- Documents your intention
- Catches typos (error if parent doesn't have the method)
- IDE support and warnings

---

## Constructor Chaining

Child must call parent constructor:

```dart
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  Person.guest() : name = 'Guest', age = 0;
}

class Employee extends Person {
  String company;
  double salary;

  // Call parent constructor
  Employee(String name, int age, this.company, this.salary)
      : super(name, age);

  // Call named parent constructor
  Employee.intern(this.company)
      : salary = 0,
        super.guest();  // Creates as guest
}

void main() {
  var emp = Employee('Alice', 25, 'TechCorp', 50000);
  print('${emp.name} works at ${emp.company}');

  var intern = Employee.intern('StartupInc');
  print('${intern.name} is an intern at ${intern.company}');
}
```

---

## Multilevel Inheritance

Chain of inheritance:

```dart
class LivingThing {
  void breathe() => print('Breathing...');
}

class Animal extends LivingThing {
  void eat() => print('Eating...');
}

class Mammal extends Animal {
  void produceMilk() => print('Producing milk...');
}

class Dog extends Mammal {
  void bark() => print('Barking...');
}

void main() {
  var dog = Dog();
  dog.breathe();      // From LivingThing
  dog.eat();          // From Animal
  dog.produceMilk();  // From Mammal
  dog.bark();         // From Dog
}
```

---

## What Is NOT Inherited

- Private members (starting with `_`)
- Constructors (must be explicitly called via `super`)

```dart
class Parent {
  int publicField = 1;
  int _privateField = 2;

  Parent();
  Parent.named();
}

class Child extends Parent {
  void test() {
    print(publicField);   // OK
    // print(_privateField);  // ERROR if in different file
  }

  Child() : super();  // Must explicitly call
  // Child.named()  // NOT inherited!
}
```

---

## Practical Example: UI Components

```dart
class Widget {
  double width;
  double height;
  String backgroundColor;

  Widget({
    this.width = 100,
    this.height = 100,
    this.backgroundColor = 'white',
  });

  void render() {
    print('Rendering ${width}x$height widget');
  }
}

class Button extends Widget {
  String text;
  String textColor;
  void Function()? onPressed;

  Button({
    required this.text,
    this.textColor = 'black',
    this.onPressed,
    super.width,
    super.height,
    super.backgroundColor,
  });

  @override
  void render() {
    super.render();
    print('  Button: "$text"');
  }

  void click() {
    print('Button clicked!');
    onPressed?.call();
  }
}

class TextField extends Widget {
  String placeholder;
  String value;
  bool isPassword;

  TextField({
    this.placeholder = '',
    this.value = '',
    this.isPassword = false,
    super.width = 200,
    super.height = 40,
  });

  @override
  void render() {
    super.render();
    var displayValue = isPassword ? '*' * value.length : value;
    print('  TextField: "$displayValue"');
  }
}

void main() {
  var loginButton = Button(
    text: 'Login',
    backgroundColor: 'blue',
    onPressed: () => print('Logging in...'),
  );

  var passwordField = TextField(
    placeholder: 'Enter password',
    value: 'secret',
    isPassword: true,
  );

  loginButton.render();
  passwordField.render();

  loginButton.click();
}
```

---

## When to Use Inheritance

### ✅ Good Use Cases

**"Is-a" relationship:**
- A `Dog` IS AN `Animal`
- A `Car` IS A `Vehicle`
- A `Button` IS A `Widget`

```dart
class Employee extends Person { }  // Employee IS A Person
class Cat extends Animal { }        // Cat IS AN Animal
```

### ❌ Bad Use Cases

**"Has-a" relationship (use composition instead):**
- A `Car` HAS AN `Engine` (not IS AN Engine)
- A `Person` HAS AN `Address` (not IS AN Address)

```dart
// ❌ Bad: Car is NOT an Engine
class Car extends Engine { }

// ✅ Good: Car HAS an Engine
class Car {
  Engine engine;
}
```

---

## Composition vs Inheritance

Often composition is better than inheritance:

```dart
// Using Inheritance (can be limiting)
class FlyingAnimal extends Animal {
  void fly() => print('Flying...');
}

class SwimmingAnimal extends Animal {
  void swim() => print('Swimming...');
}

// What about a Duck that flies AND swims?
// Can't extend both!

// Using Composition (more flexible)
class Animal {
  String name;
  FlyBehavior? flyBehavior;
  SwimBehavior? swimBehavior;

  Animal(this.name);

  void performFly() => flyBehavior?.fly();
  void performSwim() => swimBehavior?.swim();
}

class FlyBehavior {
  void fly() => print('Flying...');
}

class SwimBehavior {
  void swim() => print('Swimming...');
}

void main() {
  var duck = Animal('Donald');
  duck.flyBehavior = FlyBehavior();
  duck.swimBehavior = SwimBehavior();

  duck.performFly();   // Can fly!
  duck.performSwim();  // Can swim too!
}
```

---

## Summary

| Concept | Description |
|---------|-------------|
| `extends` | Inherit from a class |
| `super` | Access parent class |
| `@override` | Replace parent's method |
| Multilevel | Chain: A → B → C |
| "Is-a" | When to use inheritance |
| Composition | Alternative: "Has-a" |

---

## Quick Quiz

**Q1:** What keyword is used to inherit from another class?

<details>
<summary>Answer</summary>

`extends`

```dart
class Child extends Parent { }
```

</details>

**Q2:** How do you call the parent's constructor?

<details>
<summary>Answer</summary>

Use `super()` in the initializer list:

```dart
Child(int value) : super(value);
```

</details>

**Q3:** When should you use composition instead of inheritance?

<details>
<summary>Answer</summary>

When the relationship is "has-a" rather than "is-a":
- A Car HAS an Engine (composition)
- A Cat IS an Animal (inheritance)

Also when you need multiple behaviors that can't be combined via single inheritance.

</details>

---

**Next:** Learn about polymorphism - many forms.

---

**Continue to:** `05-Polymorphism.md`
