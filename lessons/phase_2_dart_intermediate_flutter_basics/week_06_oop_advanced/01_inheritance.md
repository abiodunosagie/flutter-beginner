# Week 6, Day 1-2: Inheritance - Building Class Hierarchies

## The Problem: Repeated Code

Imagine you're building an app with different user types:

```dart
class Student {
  String name;
  String email;
  int age;

  void login() { print('$name logged in'); }
  void logout() { print('$name logged out'); }

  void study() { print('$name is studying'); }
}

class Teacher {
  String name;
  String email;
  int age;

  void login() { print('$name logged in'); }
  void logout() { print('$name logged out'); }

  void teach() { print('$name is teaching'); }
}

class Admin {
  String name;
  String email;
  int age;

  void login() { print('$name logged in'); }
  void logout() { print('$name logged out'); }

  void manageSystem() { print('$name is managing'); }
}
```

**Problems:**
- Repeated properties (name, email, age)
- Repeated methods (login, logout)
- Hard to maintain (change login logic = change 3 places!)

**Solution:** **Inheritance**

---

## What is Inheritance?

**Inheritance** lets one class **inherit** properties and methods from another class.

**Real-world analogy:**
- **Vehicle** (parent) → **Car, Truck, Motorcycle** (children)
- All vehicles have wheels, engine, can start/stop
- But each has specific features (car has 4 wheels, truck has cargo space)

**In programming:**
- **Parent class** (superclass/base class) = General features
- **Child class** (subclass/derived class) = Inherits + adds specific features

---

## Basic Inheritance Syntax

```dart
class ParentClass {
  // Parent properties and methods
}

class ChildClass extends ParentClass {
  // Inherits everything from ParentClass
  // Plus can add its own
}
```

### Example: Animal Hierarchy

```dart
// Parent class
class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

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

  Dog(String name, int age, this.breed) : super(name, age);

  void bark() {
    print('$name says: Woof! Woof!');
  }
}

void main() {
  Dog dog = Dog('Buddy', 3, 'Golden Retriever');

  // Inherited from Animal
  dog.eat();     // Buddy is eating
  dog.sleep();   // Buddy is sleeping

  // Own method
  dog.bark();    // Buddy says: Woof! Woof!

  // Inherited properties
  print('${dog.name} is ${dog.age} years old');
}
```

**Key points:**
- Dog **extends** Animal
- Dog gets **all** Animal properties/methods
- Dog adds its own (breed, bark)
- **super(name, age)** calls parent constructor

---

## The `super` Keyword

**`super`** refers to the parent class.

### Calling Parent Constructor

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

  // Must call parent constructor
  Car(String brand, int year, this.doors) : super(brand, year);

  void honk() {
    print('Beep beep!');
  }
}

void main() {
  Car car = Car('Toyota', 2023, 4);
  car.displayInfo();  // Toyota (2023)
  car.honk();         // Beep beep!
}
```

### Calling Parent Methods

```dart
class Person {
  String name;

  Person(this.name);

  void introduce() {
    print('Hi, I\'m $name');
  }
}

class Student extends Person {
  String school;

  Student(String name, this.school) : super(name);

  @override
  void introduce() {
    super.introduce();  // Call parent's introduce
    print('I study at $school');
  }
}

void main() {
  Student student = Student('Alice', 'MIT');
  student.introduce();
  // Hi, I'm Alice
  // I study at MIT
}
```

---

## Method Overriding

**Override** means replacing parent's method with child's version.

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

void main() {
  Animal animal = Animal('Generic');
  animal.makeSound();  // Generic makes a sound

  Dog dog = Dog('Buddy');
  dog.makeSound();     // Buddy barks: Woof!

  Cat cat = Cat('Whiskers');
  cat.makeSound();     // Whiskers meows: Meow!
}
```

**Best practice:** Use `@override` annotation (helps catch errors).

---

## Multi-Level Inheritance

Child can have its own children:

```dart
class LivingThing {
  void breathe() {
    print('Breathing...');
  }
}

class Animal extends LivingThing {
  void move() {
    print('Moving...');
  }
}

class Dog extends Animal {
  void bark() {
    print('Barking...');
  }
}

void main() {
  Dog dog = Dog();

  dog.breathe();  // From LivingThing
  dog.move();     // From Animal
  dog.bark();     // From Dog
}
```

**Inheritance chain:** Dog → Animal → LivingThing

---

## Real-World Example: Employee System

```dart
class Employee {
  String id;
  String name;
  double baseSalary;

  Employee(this.id, this.name, this.baseSalary);

  double calculateSalary() {
    return baseSalary;
  }

  void displayInfo() {
    print('ID: $id');
    print('Name: $name');
    print('Salary: \$${calculateSalary().toStringAsFixed(2)}');
  }
}

class Manager extends Employee {
  double bonus;
  int teamSize;

  Manager(String id, String name, double baseSalary, this.bonus, this.teamSize)
      : super(id, name, baseSalary);

  @override
  double calculateSalary() {
    return baseSalary + bonus + (teamSize * 100);
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Team Size: $teamSize');
    print('Bonus: \$$bonus');
  }
}

class Developer extends Employee {
  String programmingLanguage;
  int projectsCompleted;

  Developer(String id, String name, double baseSalary,
      this.programmingLanguage, this.projectsCompleted)
      : super(id, name, baseSalary);

  @override
  double calculateSalary() {
    return baseSalary + (projectsCompleted * 500);
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Language: $programmingLanguage');
    print('Projects: $projectsCompleted');
  }
}

class Intern extends Employee {
  String university;
  int months;

  Intern(String id, String name, double baseSalary, this.university, this.months)
      : super(id, name, baseSalary);

  @override
  double calculateSalary() {
    // Interns get monthly stipend
    return baseSalary * months;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('University: $university');
    print('Duration: $months months');
  }
}

void main() {
  Manager manager = Manager('M001', 'Alice', 5000, 2000, 10);
  Developer dev = Developer('D001', 'Bob', 4000, 'Dart', 5);
  Intern intern = Intern('I001', 'Charlie', 500, 'MIT', 3);

  print('=== MANAGER ===');
  manager.displayInfo();

  print('\n=== DEVELOPER ===');
  dev.displayInfo();

  print('\n=== INTERN ===');
  intern.displayInfo();
}
```

---

## Inheritance Benefits

### 1. Code Reusability

```dart
// Without inheritance (BAD)
class Car {
  void start() { print('Starting...'); }
  void stop() { print('Stopping...'); }
  void drive() { print('Driving car'); }
}

class Truck {
  void start() { print('Starting...'); }  // REPEATED!
  void stop() { print('Stopping...'); }   // REPEATED!
  void loadCargo() { print('Loading...'); }
}

// With inheritance (GOOD)
class Vehicle {
  void start() { print('Starting...'); }
  void stop() { print('Stopping...'); }
}

class Car extends Vehicle {
  void drive() { print('Driving car'); }
}

class Truck extends Vehicle {
  void loadCargo() { print('Loading...'); }
}
```

### 2. Easy Maintenance

Change parent = changes all children automatically:

```dart
class User {
  String name;
  String email;

  User(this.name, this.email);

  void sendEmail(String message) {
    // Change implementation here
    print('Sending email to $email: $message');
    // Now ALL child classes use new implementation!
  }
}

class Student extends User {
  Student(String name, String email) : super(name, email);
}

class Teacher extends User {
  Teacher(String name, String email) : super(name, email);
}
```

### 3. Polymorphism (Next Lesson!)

Different objects can be treated the same:

```dart
List<Animal> zoo = [
  Dog('Buddy'),
  Cat('Whiskers'),
  Bird('Tweety'),
];

for (Animal animal in zoo) {
  animal.makeSound();  // Each makes their own sound!
}
```

---

## Constructor Rules in Inheritance

### Rule 1: Child Must Call Parent Constructor

```dart
class Parent {
  String name;

  Parent(this.name);
}

class Child extends Parent {
  int age;

  // Must call super()
  Child(String name, this.age) : super(name);
}
```

### Rule 2: Parent Constructor Runs First

```dart
class Parent {
  Parent() {
    print('1. Parent constructor');
  }
}

class Child extends Parent {
  Child() : super() {
    print('2. Child constructor');
  }
}

void main() {
  Child c = Child();
  // Output:
  // 1. Parent constructor
  // 2. Child constructor
}
```

### Rule 3: No Default Constructor? Must Be Explicit

```dart
class Parent {
  String name;

  // No default constructor!
  Parent(this.name);
}

class Child extends Parent {
  // ERROR! Parent has no default constructor
  // Child();

  // Must explicitly call parent constructor
  Child(String name) : super(name);
}
```

---

## Access Modifiers in Inheritance

### Public Members (Inherited)

```dart
class Parent {
  String publicName = 'Public';

  void publicMethod() {
    print('Public method');
  }
}

class Child extends Parent {
  void test() {
    print(publicName);   // OK
    publicMethod();      // OK
  }
}
```

### Private Members (NOT Inherited)

```dart
class Parent {
  String _privateName = 'Private';

  void _privateMethod() {
    print('Private method');
  }
}

class Child extends Parent {
  void test() {
    // print(_privateName);   // ERROR! Private
    // _privateMethod();      // ERROR! Private
  }
}
```

---

## When to Use Inheritance

### ✅ Use When:

1. **Clear "is-a" relationship**
   - Dog **is a** Animal ✓
   - Car **is a** Vehicle ✓
   - Student **is a** Person ✓

2. **Shared behavior**
   - All employees calculate salary (differently)
   - All shapes calculate area (differently)

3. **Natural hierarchy**
   - LivingThing → Animal → Mammal → Dog

### ❌ Avoid When:

1. **"Has-a" relationship** (use composition instead)
   - Car **has an** Engine (not: Car extends Engine)
   - Student **has a** Schedule (not: Student extends Schedule)

2. **No shared behavior**
   - Don't extend just to reuse code

3. **Would create deep hierarchies**
   - More than 3-4 levels gets confusing

---

## Common Mistakes

### Mistake 1: Forgetting super()

```dart
class Parent {
  String name;
  Parent(this.name);
}

class Child extends Parent {
  int age;

  // ERROR! No call to super
  Child(this.age);

  // CORRECT
  Child(String name, this.age) : super(name);
}
```

### Mistake 2: Wrong Override

```dart
class Parent {
  void greet(String name) {
    print('Hello, $name');
  }
}

class Child extends Parent {
  // Different signature = NOT an override!
  void greet() {  // Missing parameter!
    print('Hello');
  }
}
```

### Mistake 3: Overriding final Methods

```dart
class Parent {
  final void cannotOverride() {
    print('Locked!');
  }
}

class Child extends Parent {
  // ERROR! Can't override final method
  // @override
  // void cannotOverride() { }
}
```

---

## Exercises

### Exercise 1: Shape Hierarchy
Create a Shape parent class with width/height, and Rectangle/Triangle children that calculate area differently.

<details>
<summary>Solution</summary>

```dart
class Shape {
  double width;
  double height;

  Shape(this.width, this.height);

  double calculateArea() {
    return 0;  // Override in children
  }
}

class Rectangle extends Shape {
  Rectangle(double width, double height) : super(width, height);

  @override
  double calculateArea() {
    return width * height;
  }
}

class Triangle extends Shape {
  Triangle(double width, double height) : super(width, height);

  @override
  double calculateArea() {
    return (width * height) / 2;
  }
}

void main() {
  Rectangle rect = Rectangle(5, 4);
  Triangle tri = Triangle(5, 4);

  print('Rectangle area: ${rect.calculateArea()}');  // 20
  print('Triangle area: ${tri.calculateArea()}');    // 10
}
```
</details>

---

### Exercise 2: Account Hierarchy
Create Account parent with balance, and SavingsAccount/CheckingAccount children with different interest rates.

<details>
<summary>Solution</summary>

```dart
class Account {
  String accountNumber;
  double balance;

  Account(this.accountNumber, this.balance);

  void deposit(double amount) {
    balance += amount;
  }

  void displayBalance() {
    print('Account: $accountNumber, Balance: \$$balance');
  }
}

class SavingsAccount extends Account {
  double interestRate = 0.05;  // 5%

  SavingsAccount(String accountNumber, double balance)
      : super(accountNumber, balance);

  void addInterest() {
    double interest = balance * interestRate;
    balance += interest;
    print('Added interest: \$$interest');
  }
}

class CheckingAccount extends Account {
  int freeTransactions = 5;
  int transactionCount = 0;

  CheckingAccount(String accountNumber, double balance)
      : super(accountNumber, balance);

  @override
  void deposit(double amount) {
    super.deposit(amount);
    transactionCount++;

    if (transactionCount > freeTransactions) {
      balance -= 2;  // $2 fee
      print('Transaction fee applied');
    }
  }
}

void main() {
  SavingsAccount savings = SavingsAccount('S001', 1000);
  savings.addInterest();
  savings.displayBalance();

  CheckingAccount checking = CheckingAccount('C001', 500);
  checking.deposit(100);
  checking.displayBalance();
}
```
</details>

---

## Key Takeaways

1. **Inheritance** = Child class inherits from parent
2. **`extends`** keyword creates inheritance
3. **`super`** accesses parent class
4. **`@override`** marks overridden methods
5. **"is-a" relationship** = use inheritance
6. **"has-a" relationship** = use composition
7. **Reusability** + **Maintainability** = main benefits

---

## What's Next?

Tomorrow:
- **Polymorphism** - One interface, many forms
- **Abstract classes** - Templates for children
- **Interfaces** - Contracts that classes must follow

You've unlocked class hierarchies! This is core OOP! 🌳✨
