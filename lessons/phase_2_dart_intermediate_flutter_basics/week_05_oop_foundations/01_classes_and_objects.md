# Week 5, Day 1-2: Classes and Objects - Object-Oriented Programming

## The Problem with Functions

Imagine you're building a user system. With just functions:

```dart
void printUser(String name, int age, String email) {
  print('Name: $name, Age: $age, Email: $email');
}

double calculateDiscount(String userType, double price) {
  // userType: 'premium', 'regular', etc.
}

bool isEligible(int age, String membership) {
  // Check various conditions
}
```

**Problems:**
- Data is scattered (name, age, email passed separately)
- No relationship between related data
- Hard to maintain (what if we add phone number?)
- Repetitive (always passing same parameters)

**Solution:** **Classes and Objects**

---

## What is a Class?

A **class** is a **blueprint** for creating objects.

Think of it like:
- **Class** = Blueprint for a house
- **Object** = Actual house built from blueprint

Or:
- **Class** = Cookie cutter
- **Object** = Individual cookies

**Real-world analogy:**
```
Class: Dog
  - Properties: name, breed, age, color
  - Behaviors: bark(), eat(), sleep()

Objects (instances):
  - Buddy (Golden Retriever, 3 years, golden)
  - Max (Bulldog, 5 years, white)
  - Luna (Husky, 2 years, gray)
```

---

## Creating Your First Class

### Basic Syntax

```dart
class ClassName {
  // Properties (data)
  // Methods (behaviors)
}
```

### Example 1: Simple Person Class

```dart
class Person {
  // Properties
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Method
  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old.');
  }
}

void main() {
  // Create an object (instance)
  Person person1 = Person('Alice', 25);
  person1.introduce();  // Hi, I'm Alice and I'm 25 years old.

  Person person2 = Person('Bob', 30);
  person2.introduce();  // Hi, I'm Bob and I'm 30 years old.
}
```

**Breaking it down:**

1. **Class declaration:** `class Person {}`
2. **Properties:** `String name; int age;`
3. **Constructor:** `Person(this.name, this.age);`
4. **Method:** `void introduce() { ... }`
5. **Creating object:** `Person person1 = Person('Alice', 25);`
6. **Calling method:** `person1.introduce();`

---

## Properties (Fields)

Properties store data about the object.

### Example: Car Class

```dart
class Car {
  String brand;
  String model;
  int year;
  String color;

  Car(this.brand, this.model, this.year, this.color);

  void displayInfo() {
    print('$year $color $brand $model');
  }
}

void main() {
  Car myCar = Car('Toyota', 'Camry', 2023, 'Blue');
  myCar.displayInfo();  // 2023 Blue Toyota Camry

  Car yourCar = Car('Honda', 'Civic', 2022, 'Red');
  yourCar.displayInfo();  // 2022 Red Honda Civic
}
```

---

## Constructors

**Purpose:** Initialize object when it's created.

### Default Constructor

```dart
class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);
}
```

**This is shorthand for:**
```dart
class Person {
  String name;
  int age;

  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }
}
```

### Constructor with Body

```dart
class Person {
  String name;
  int age;
  String status;

  Person(this.name, this.age) {
    if (age >= 18) {
      status = 'Adult';
    } else {
      status = 'Minor';
    }
    print('Created person: $name');
  }
}

void main() {
  Person p1 = Person('Alice', 25);
  // Prints: Created person: Alice
  print(p1.status);  // Adult

  Person p2 = Person('Tim', 12);
  // Prints: Created person: Tim
  print(p2.status);  // Minor
}
```

### Named Constructors

Multiple ways to create objects:

```dart
class Person {
  String name;
  int age;

  // Default constructor
  Person(this.name, this.age);

  // Named constructor: guest user
  Person.guest() {
    name = 'Guest';
    age = 0;
  }

  // Named constructor: from birth year
  Person.fromBirthYear(this.name, int birthYear) {
    age = DateTime.now().year - birthYear;
  }

  void introduce() {
    print('Hi, I\'m $name, age $age');
  }
}

void main() {
  Person p1 = Person('Alice', 25);
  p1.introduce();  // Hi, I'm Alice, age 25

  Person p2 = Person.guest();
  p2.introduce();  // Hi, I'm Guest, age 0

  Person p3 = Person.fromBirthYear('Bob', 1990);
  p3.introduce();  // Hi, I'm Bob, age 34 (if current year is 2024)
}
```

---

## Methods

Methods are functions that belong to a class.

### Example: BankAccount

```dart
class BankAccount {
  String accountNumber;
  String owner;
  double balance;

  BankAccount(this.accountNumber, this.owner, this.balance);

  // Method: deposit money
  void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      print('Deposited \$$amount. New balance: \$$balance');
    } else {
      print('Invalid amount');
    }
  }

  // Method: withdraw money
  void withdraw(double amount) {
    if (amount > 0 && amount <= balance) {
      balance -= amount;
      print('Withdrew \$$amount. New balance: \$$balance');
    } else {
      print('Invalid amount or insufficient funds');
    }
  }

  // Method: display account info
  void displayInfo() {
    print('Account: $accountNumber');
    print('Owner: $owner');
    print('Balance: \$$balance');
  }
}

void main() {
  BankAccount account = BankAccount('12345', 'Alice', 1000.0);

  account.displayInfo();
  // Account: 12345
  // Owner: Alice
  // Balance: $1000.0

  account.deposit(500.0);
  // Deposited $500.0. New balance: $1500.0

  account.withdraw(200.0);
  // Withdrew $200.0. New balance: $1300.0

  account.withdraw(2000.0);
  // Invalid amount or insufficient funds
}
```

---

## The `this` Keyword

**Purpose:** Refers to the current object.

### When to Use `this`

1. **In constructors** (to distinguish parameters from properties):

```dart
class Person {
  String name;

  // Without this - CONFUSING
  Person(String n) {
    name = n;
  }

  // With this - CLEAR
  Person(String name) {
    this.name = name;  // this.name = property, name = parameter
  }
}
```

2. **In methods** (optional but can add clarity):

```dart
class Counter {
  int count = 0;

  void increment() {
    this.count++;  // 'this' is optional here
    // count++; also works
  }

  void reset() {
    this.count = 0;
  }
}
```

---

## Accessing Properties and Methods

### Dot Notation

```dart
class Student {
  String name;
  int grade;

  Student(this.name, this.grade);

  void study() {
    print('$name is studying...');
  }
}

void main() {
  Student student = Student('Alice', 10);

  // Access properties
  print(student.name);   // Alice
  print(student.grade);  // 10

  // Modify properties
  student.grade = 11;
  print(student.grade);  // 11

  // Call methods
  student.study();  // Alice is studying...
}
```

---

## Real-World Example: Complete Class

```dart
class Product {
  String id;
  String name;
  double price;
  int stock;
  String category;

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
  });

  // Method: check if in stock
  bool isInStock() {
    return stock > 0;
  }

  // Method: apply discount
  double getDiscountedPrice(double discountPercent) {
    return price * (1 - discountPercent / 100);
  }

  // Method: sell product
  bool sell(int quantity) {
    if (quantity <= stock) {
      stock -= quantity;
      print('Sold $quantity units of $name');
      return true;
    } else {
      print('Not enough stock');
      return false;
    }
  }

  // Method: restock
  void restock(int quantity) {
    stock += quantity;
    print('Restocked $quantity units. New stock: $stock');
  }

  // Method: display info
  void displayInfo() {
    print('═══════════════════');
    print('ID: $id');
    print('Name: $name');
    print('Price: \$${price.toStringAsFixed(2)}');
    print('Stock: $stock units');
    print('Category: $category');
    print('Status: ${isInStock() ? "Available" : "Out of Stock"}');
    print('═══════════════════');
  }
}

void main() {
  Product laptop = Product(
    id: 'P001',
    name: 'Gaming Laptop',
    price: 1299.99,
    stock: 15,
    category: 'Electronics',
  );

  laptop.displayInfo();

  // Check stock
  if (laptop.isInStock()) {
    print('${laptop.name} is available!');
  }

  // Get discounted price
  double salePrice = laptop.getDiscountedPrice(10);  // 10% off
  print('Sale price: \$${salePrice.toStringAsFixed(2)}');

  // Sell some units
  laptop.sell(5);   // Sold 5 units
  laptop.sell(15);  // Not enough stock

  // Restock
  laptop.restock(20);

  laptop.displayInfo();
}
```

---

## Multiple Objects from One Class

```dart
class Dog {
  String name;
  String breed;
  int age;

  Dog(this.name, this.breed, this.age);

  void bark() {
    print('$name says: Woof! Woof!');
  }

  void celebrate Birthday() {
    age++;
    print('$name turned $age years old!');
  }
}

void main() {
  Dog dog1 = Dog('Buddy', 'Golden Retriever', 3);
  Dog dog2 = Dog('Max', 'Bulldog', 5);
  Dog dog3 = Dog('Luna', 'Husky', 2);

  dog1.bark();  // Buddy says: Woof! Woof!
  dog2.bark();  // Max says: Woof! Woof!
  dog3.bark();  // Luna says: Woof! Woof!

  dog1.celebrateBirthday();  // Buddy turned 4 years old!
}
```

**Key point:** Each object has its own copy of the properties, but shares the class methods.

---

## Lists of Objects

```dart
class Student {
  String name;
  int grade;

  Student(this.name, this.grade);

  void introduce() {
    print('$name, Grade $grade');
  }
}

void main() {
  // Create a list of Student objects
  List<Student> students = [
    Student('Alice', 10),
    Student('Bob', 11),
    Student('Charlie', 10),
    Student('David', 12),
  ];

  // Iterate through students
  for (Student student in students) {
    student.introduce();
  }

  // Find students in grade 10
  print('\nGrade 10 students:');
  for (Student student in students) {
    if (student.grade == 10) {
      print(student.name);
    }
  }
}
```

---

## Exercises

### Exercise 1: Rectangle Class
Create a Rectangle class with width and height, and methods to calculate area and perimeter.

<details>
<summary>Solution</summary>

```dart
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double getArea() {
    return width * height;
  }

  double getPerimeter() {
    return 2 * (width + height);
  }

  void displayInfo() {
    print('Rectangle: ${width}x$height');
    print('Area: ${getArea()}');
    print('Perimeter: ${getPerimeter()}');
  }
}

void main() {
  Rectangle rect = Rectangle(5, 3);
  rect.displayInfo();
}
```
</details>

---

### Exercise 2: Book Class
Create a Book class with title, author, pages, and a method to calculate reading time (assume 1 page per minute).

<details>
<summary>Solution</summary>

```dart
class Book {
  String title;
  String author;
  int pages;

  Book(this.title, this.author, this.pages);

  int getReadingTime() {
    return pages;  // 1 page per minute
  }

  void displayInfo() {
    print('Title: $title');
    print('Author: $author');
    print('Pages: $pages');
    print('Reading time: ${getReadingTime()} minutes');
  }
}

void main() {
  Book book = Book('1984', 'George Orwell', 328);
  book.displayInfo();
}
```
</details>

---

### Exercise 3: Temperature Class
Create a Temperature class that stores Celsius and has methods to get Fahrenheit and Kelvin.

<details>
<summary>Solution</summary>

```dart
class Temperature {
  double celsius;

  Temperature(this.celsius);

  double toFahrenheit() {
    return (celsius * 9 / 5) + 32;
  }

  double toKelvin() {
    return celsius + 273.15;
  }

  void displayAllFormats() {
    print('Celsius: ${celsius}°C');
    print('Fahrenheit: ${toFahrenheit().toStringAsFixed(2)}°F');
    print('Kelvin: ${toKelvin().toStringAsFixed(2)}K');
  }
}

void main() {
  Temperature temp = Temperature(25);
  temp.displayAllFormats();
}
```
</details>

---

## Key Takeaways

1. **Class** = Blueprint for objects
2. **Object** = Instance of a class
3. **Properties** = Data/attributes of object
4. **Methods** = Functions that belong to class
5. **Constructor** = Initializes object when created
6. **`this`** = Refers to current object
7. **Named constructors** = Multiple ways to create objects
8. **Dot notation** = Access properties and methods (`object.property`)

---

## What's Next?

Tomorrow:
- **Encapsulation** - Hiding data with private properties
- **Getters and Setters** - Controlled access to properties
- **Computed properties** - Dynamic values

You've mastered the basics of OOP! This is the foundation for everything in Flutter. 🏗️✨
