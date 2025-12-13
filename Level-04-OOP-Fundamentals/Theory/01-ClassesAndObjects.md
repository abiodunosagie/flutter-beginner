# Classes and Objects: The Foundation of OOP

## What Is Object-Oriented Programming?

**Object-Oriented Programming (OOP)** is a way of organizing code around "objects" - things that have data and behavior.

Think of the real world:
- A **dog** has data (name, breed, age) and behavior (bark, run, eat)
- A **car** has data (color, speed, fuel) and behavior (start, stop, accelerate)
- A **person** has data (name, email, age) and behavior (walk, talk, work)

OOP lets us model these real-world concepts in code!

---

## Classes vs Objects

### Class = Blueprint

A **class** is a blueprint or template. It defines what something IS and what it CAN DO.

```dart
class Dog {
  String name;
  int age;

  Dog(this.name, this.age);

  void bark() {
    print('Woof!');
  }
}
```

### Object = Instance

An **object** is a real thing created from the blueprint. Also called an "instance".

```dart
var buddy = Dog('Buddy', 3);   // Object 1
var max = Dog('Max', 5);       // Object 2
var bella = Dog('Bella', 2);   // Object 3
```

---

## Visual: Class vs Object

```
        CLASS (Blueprint)                    OBJECTS (Instances)
    ┌──────────────────────┐          ┌─────────────────────────┐
    │       Dog            │          │  buddy                  │
    │──────────────────────│          │  name: "Buddy"          │
    │  name: String        │  ──────► │  age: 3                 │
    │  age: int            │          └─────────────────────────┘
    │──────────────────────│
    │  bark()              │          ┌─────────────────────────┐
    │  eat()               │          │  max                    │
    │  run()               │  ──────► │  name: "Max"            │
    └──────────────────────┘          │  age: 5                 │
                                      └─────────────────────────┘

                                      ┌─────────────────────────┐
                              ──────► │  bella                  │
                                      │  name: "Bella"          │
                                      │  age: 2                 │
                                      └─────────────────────────┘
```

---

## Creating a Class

### Basic Syntax

```dart
class ClassName {
  // Properties (data)
  Type propertyName;

  // Constructor (how to create)
  ClassName(this.propertyName);

  // Methods (behavior)
  void methodName() {
    // code
  }
}
```

### Real Example

```dart
class Person {
  // Properties
  String name;
  int age;
  String email;

  // Constructor
  Person(this.name, this.age, this.email);

  // Methods
  void introduce() {
    print('Hi, I am $name, $age years old.');
  }

  void haveBirthday() {
    age++;
    print('Happy birthday! Now $age years old.');
  }
}
```

---

## Creating Objects

Use the class name like a function:

```dart
void main() {
  // Create objects
  var alice = Person('Alice', 25, 'alice@email.com');
  var bob = Person('Bob', 30, 'bob@email.com');

  // Access properties
  print(alice.name);  // Alice
  print(bob.age);     // 30

  // Call methods
  alice.introduce();  // Hi, I am Alice, 25 years old.
  bob.haveBirthday(); // Happy birthday! Now 31 years old.
}
```

---

## Properties: The Data

Properties hold the data for each object.

```dart
class Car {
  // Properties with types
  String brand;
  String model;
  int year;
  double speed = 0;  // Default value
  bool isRunning = false;

  Car(this.brand, this.model, this.year);
}

void main() {
  var myCar = Car('Toyota', 'Camry', 2022);

  print(myCar.brand);     // Toyota
  print(myCar.speed);     // 0
  print(myCar.isRunning); // false

  // Modify properties
  myCar.speed = 60;
  myCar.isRunning = true;
}
```

---

## Methods: The Behavior

Methods are functions that belong to the class.

```dart
class Calculator {
  int value = 0;

  void add(int n) {
    value += n;
  }

  void subtract(int n) {
    value -= n;
  }

  void multiply(int n) {
    value *= n;
  }

  void reset() {
    value = 0;
  }

  void display() {
    print('Current value: $value');
  }
}

void main() {
  var calc = Calculator();

  calc.add(10);
  calc.display();     // Current value: 10

  calc.multiply(3);
  calc.display();     // Current value: 30

  calc.subtract(5);
  calc.display();     // Current value: 25

  calc.reset();
  calc.display();     // Current value: 0
}
```

---

## The `this` Keyword

`this` refers to the current object.

```dart
class Rectangle {
  double width;
  double height;

  // 'this' distinguishes parameter from property
  Rectangle(double width, double height) {
    this.width = width;
    this.height = height;
  }

  double area() {
    return this.width * this.height;  // 'this' optional here
  }

  void describe() {
    print('Rectangle: ${this.width} x ${this.height}');
  }
}
```

### Shorthand Constructor

Dart has a shorthand that automatically assigns `this`:

```dart
class Rectangle {
  double width;
  double height;

  // Shorthand: automatically assigns this.width and this.height
  Rectangle(this.width, this.height);
}
```

---

## Multiple Objects Are Independent

Each object has its own copy of properties:

```dart
class Counter {
  int count = 0;

  void increment() {
    count++;
  }
}

void main() {
  var counter1 = Counter();
  var counter2 = Counter();

  counter1.increment();
  counter1.increment();
  counter1.increment();

  counter2.increment();

  print(counter1.count);  // 3
  print(counter2.count);  // 1  (separate!)
}
```

---

## Object References

Variables hold references (addresses) to objects, not the objects themselves:

```dart
void main() {
  var dog1 = Dog('Buddy', 3);
  var dog2 = dog1;  // Same object, different variable!

  dog2.age = 5;

  print(dog1.age);  // 5  (same object!)
  print(dog2.age);  // 5
}
```

### Visual

```
dog1 ──────┐
           ├────► [ Dog object: name="Buddy", age=5 ]
dog2 ──────┘
```

---

## Practical Example: Bank Account

```dart
class BankAccount {
  String owner;
  String accountNumber;
  double balance;

  BankAccount(this.owner, this.accountNumber, [this.balance = 0]);

  void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      print('Deposited \$$amount. New balance: \$$balance');
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= balance) {
      balance -= amount;
      print('Withdrew \$$amount. New balance: \$$balance');
    } else {
      print('Invalid withdrawal amount');
    }
  }

  void displayBalance() {
    print('Account $accountNumber ($owner): \$$balance');
  }
}

void main() {
  var account = BankAccount('Alice', '1234567890', 100);

  account.displayBalance();  // Account 1234567890 (Alice): $100

  account.deposit(50);       // Deposited $50. New balance: $150
  account.withdraw(30);      // Withdrew $30. New balance: $120
  account.withdraw(200);     // Invalid withdrawal amount
}
```

---

## Practical Example: Student

```dart
class Student {
  String name;
  String id;
  List<int> grades = [];

  Student(this.name, this.id);

  void addGrade(int grade) {
    if (grade >= 0 && grade <= 100) {
      grades.add(grade);
    }
  }

  double getAverage() {
    if (grades.isEmpty) return 0;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  String getLetterGrade() {
    var avg = getAverage();
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }

  void printReport() {
    print('Student: $name ($id)');
    print('Grades: $grades');
    print('Average: ${getAverage().toStringAsFixed(1)}');
    print('Letter Grade: ${getLetterGrade()}');
  }
}

void main() {
  var student = Student('Alice', 'S12345');

  student.addGrade(85);
  student.addGrade(92);
  student.addGrade(78);
  student.addGrade(88);

  student.printReport();
}
```

---

## Summary

| Term | Definition |
|------|------------|
| Class | Blueprint/template for creating objects |
| Object | Instance of a class with actual data |
| Property | Variable that belongs to a class (data) |
| Method | Function that belongs to a class (behavior) |
| Instance | Another word for object |
| `this` | Reference to the current object |

---

## Quick Quiz

**Q1:** What's the difference between a class and an object?

<details>
<summary>Answer</summary>

A class is a blueprint/template that defines properties and methods.
An object is a specific instance created from that class with actual values.

</details>

**Q2:** What does `this` refer to?

<details>
<summary>Answer</summary>

`this` refers to the current object instance.

</details>

**Q3:** If you create two objects from the same class, do they share the same data?

<details>
<summary>Answer</summary>

No! Each object has its own independent copy of properties.

</details>

---

**Next:** Learn about different types of constructors.

---

**Continue to:** `02-Constructors.md`
