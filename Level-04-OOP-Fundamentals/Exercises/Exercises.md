# Level 4 Exercises: Object-Oriented Programming

Test your understanding of classes, inheritance, polymorphism, and more!

---

## Exercise 1: Create a Simple Class

**Difficulty:** ⭐ Easy

> If you have not read `../Theory/01-ClassesAndObjects.md` yet, read it first. This exercise uses exactly those ideas: properties, a constructor with `this.`, and methods.

### First, a fully worked example (study this, do not skip it)

Before you write your own, here is a complete `Dog` class built the same way you will build yours. Read every comment, then notice how `main` uses it.

```dart
class Dog {
  // 1. Properties: the data every Dog has.
  String name;
  int age;

  // 2. Constructor: the `this.` shortcut stores each value you pass in.
  Dog(this.name, this.age);

  // 3. A method that DOES something.
  void bark() {
    print('$name says Woof!');
  }

  // 4. A method that RETURNS a value (note the String return type).
  String describe() {
    return '$name is $age years old';
  }
}

void main() {
  var rex = Dog('Rex', 4);   // build a Dog object
  rex.bark();                // Rex says Woof!
  print(rex.describe());     // Rex is 4 years old
}
```

That is the whole pattern. Your `Book` class will look almost identical.

### Now your turn

Create a `Book` class so that the `main` below runs and prints the comments shown:

```dart
void main() {
  // TODO: Create a Book class with:
  //
  //   Properties:
  //     - title   (String)
  //     - author  (String)
  //     - pages   (int)
  //     - isRead  (bool) that DEFAULTS to false
  //
  //   Methods:
  //     - markAsRead()  -> sets isRead to true (returns nothing)
  //     - summary()     -> RETURNS the String "Title by Author (X pages)"

  var book = Book('The Hobbit', 'J.R.R. Tolkien', 310);
  print(book.summary());          // The Hobbit by J.R.R. Tolkien (310 pages)
  print('Read: ${book.isRead}');  // Read: false

  book.markAsRead();
  print('Read: ${book.isRead}');  // Read: true
}
```

<details>
<summary>💡 Hint (step by step)</summary>

1. Start the blueprint: `class Book {`
2. Declare the four properties, each on its own line, like `String title;`.
3. For `isRead`, give it a default value right in the blueprint: `bool isRead = false;`
   (Then you do not need to pass it into the constructor at all.)
4. Write the constructor using the `this.` shortcut for the three required values:
   `Book(this.title, this.author, this.pages);`
5. `markAsRead()` returns nothing, so its return type is `void`. Inside, set `isRead = true;`.
6. `summary()` returns text, so its return type is `String`. Use string interpolation:
   `return '$title by $author ($pages pages)';`
7. Close the class with `}`.

Compare your result to the `Dog` example above. The shape is the same.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class Book {
  String title;
  String author;
  int pages;
  bool isRead = false;   // default value lives right here in the blueprint

  Book(this.title, this.author, this.pages);

  void markAsRead() {
    isRead = true;
  }

  String summary() {
    return '$title by $author ($pages pages)';
  }
}

void main() {
  var book = Book('The Hobbit', 'J.R.R. Tolkien', 310);
  print(book.summary());          // The Hobbit by J.R.R. Tolkien (310 pages)
  print('Read: ${book.isRead}');  // Read: false

  book.markAsRead();
  print('Read: ${book.isRead}');  // Read: true
}
```

</details>

---

## Exercise 2: Bank Account with Encapsulation

**Difficulty:** ⭐⭐ Medium

Create a `BankAccount` class that protects the balance:

```dart
void main() {
  // TODO: Create BankAccount class with:
  // - Private _balance
  // - Public getter for balance (read-only)
  // - deposit(amount) - only positive amounts
  // - withdraw(amount) - only if sufficient balance
  // - transfer(amount, targetAccount)

  var alice = BankAccount('Alice', 1000);
  var bob = BankAccount('Bob', 500);

  alice.deposit(200);
  alice.withdraw(100);
  alice.transfer(300, bob);

  print('Alice: \$${alice.balance}');  // $800
  print('Bob: \$${bob.balance}');      // $800
}
```

<details>
<summary>💡 Hint</summary>

Use underscore prefix for private balance. Validate amounts before modifying. Transfer = withdraw from one + deposit to other.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class BankAccount {
  String owner;
  double _balance;

  BankAccount(this.owner, [this._balance = 0]);

  double get balance => _balance;

  bool deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('$owner deposited \$${amount.toStringAsFixed(2)}');
      return true;
    }
    return false;
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print('$owner withdrew \$${amount.toStringAsFixed(2)}');
      return true;
    }
    print('$owner: Insufficient funds or invalid amount');
    return false;
  }

  bool transfer(double amount, BankAccount target) {
    if (withdraw(amount)) {
      target.deposit(amount);
      print('Transferred \$${amount.toStringAsFixed(2)} to ${target.owner}');
      return true;
    }
    return false;
  }
}

void main() {
  var alice = BankAccount('Alice', 1000);
  var bob = BankAccount('Bob', 500);

  alice.deposit(200);
  alice.withdraw(100);
  alice.transfer(300, bob);

  print('\nFinal balances:');
  print('Alice: \$${alice.balance}');
  print('Bob: \$${bob.balance}');
}
```

</details>

---

## Exercise 3: Named Constructors

**Difficulty:** ⭐⭐ Medium

Create a `Temperature` class with multiple constructors:

```dart
void main() {
  // TODO: Create Temperature class with:
  // - celsius property
  // - Temperature.celsius(value)
  // - Temperature.fahrenheit(value) - converts to celsius
  // - Temperature.kelvin(value) - converts to celsius
  // - Getters: fahrenheit, kelvin
  // - toString() that shows all three

  var t1 = Temperature.celsius(25);
  var t2 = Temperature.fahrenheit(98.6);
  var t3 = Temperature.kelvin(373.15);

  print(t1);  // 25°C = 77°F = 298.15K
  print(t2);  // 37°C = 98.6°F = 310.15K
  print(t3);  // 100°C = 212°F = 373.15K
}
```

<details>
<summary>💡 Hint</summary>

Named constructors use initializer lists. F to C: (F - 32) × 5/9. K to C: K - 273.15.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class Temperature {
  double celsius;

  Temperature.celsius(this.celsius);

  Temperature.fahrenheit(double f) : celsius = (f - 32) * 5 / 9;

  Temperature.kelvin(double k) : celsius = k - 273.15;

  double get fahrenheit => celsius * 9 / 5 + 32;
  double get kelvin => celsius + 273.15;

  @override
  String toString() {
    return '${celsius.toStringAsFixed(1)}°C = ${fahrenheit.toStringAsFixed(1)}°F = ${kelvin.toStringAsFixed(2)}K';
  }
}

void main() {
  var t1 = Temperature.celsius(25);
  var t2 = Temperature.fahrenheit(98.6);
  var t3 = Temperature.kelvin(373.15);

  print(t1);
  print(t2);
  print(t3);
}
```

</details>

---

## Exercise 4: Shape Hierarchy

**Difficulty:** ⭐⭐ Medium

Create an abstract `Shape` class with concrete implementations:

```dart
void main() {
  // TODO: Create:
  // - Abstract Shape class with area() and perimeter()
  // - Rectangle(width, height)
  // - Circle(radius)
  // - Triangle(a, b, c) with area using Heron's formula

  List<Shape> shapes = [
    Rectangle(5, 3),
    Circle(4),
    Triangle(3, 4, 5),
  ];

  for (var shape in shapes) {
    print('${shape.runtimeType}:');
    print('  Area: ${shape.area().toStringAsFixed(2)}');
    print('  Perimeter: ${shape.perimeter().toStringAsFixed(2)}');
  }
}
```

<details>
<summary>💡 Hint</summary>

Heron's formula: Area = √(s(s-a)(s-b)(s-c)) where s = (a+b+c)/2

</details>

<details>
<summary>✅ Solution</summary>

```dart
import 'dart:math';

abstract class Shape {
  double area();
  double perimeter();
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() => pi * radius * radius;

  @override
  double perimeter() => 2 * pi * radius;
}

class Triangle extends Shape {
  double a, b, c;

  Triangle(this.a, this.b, this.c);

  @override
  double area() {
    var s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  @override
  double perimeter() => a + b + c;
}

void main() {
  List<Shape> shapes = [
    Rectangle(5, 3),
    Circle(4),
    Triangle(3, 4, 5),
  ];

  for (var shape in shapes) {
    print('${shape.runtimeType}:');
    print('  Area: ${shape.area().toStringAsFixed(2)}');
    print('  Perimeter: ${shape.perimeter().toStringAsFixed(2)}');
  }
}
```

</details>

---

## Exercise 5: Employee Payroll with Polymorphism

**Difficulty:** ⭐⭐⭐ Hard

Create an employee system with different pay calculations:

```dart
void main() {
  // TODO: Create:
  // - Abstract Employee(name) with calculatePay()
  // - HourlyEmployee(name, hourlyRate, hoursWorked)
  //   Pay = hourlyRate × hours (1.5x for overtime > 40)
  // - SalariedEmployee(name, annualSalary)
  //   Pay = annualSalary / 12
  // - CommissionEmployee(name, baseSalary, sales, commissionRate)
  //   Pay = baseSalary/12 + sales × commissionRate

  List<Employee> employees = [
    HourlyEmployee('Alice', 25.0, 45),
    SalariedEmployee('Bob', 72000),
    CommissionEmployee('Charlie', 36000, 20000, 0.05),
  ];

  processPayroll(employees);
}

void processPayroll(List<Employee> employees) {
  double total = 0;
  for (var emp in employees) {
    var pay = emp.calculatePay();
    total += pay;
    print('${emp.name}: \$${pay.toStringAsFixed(2)}');
  }
  print('Total payroll: \$${total.toStringAsFixed(2)}');
}
```

<details>
<summary>💡 Hint</summary>

Overtime: if hours > 40, regular pay for 40 hours + 1.5x for remaining hours.

</details>

<details>
<summary>✅ Solution</summary>

```dart
abstract class Employee {
  String name;
  Employee(this.name);
  double calculatePay();
}

class HourlyEmployee extends Employee {
  double hourlyRate;
  int hoursWorked;

  HourlyEmployee(String name, this.hourlyRate, this.hoursWorked) : super(name);

  @override
  double calculatePay() {
    if (hoursWorked <= 40) {
      return hourlyRate * hoursWorked;
    } else {
      var regularPay = hourlyRate * 40;
      var overtimePay = hourlyRate * 1.5 * (hoursWorked - 40);
      return regularPay + overtimePay;
    }
  }
}

class SalariedEmployee extends Employee {
  double annualSalary;

  SalariedEmployee(String name, this.annualSalary) : super(name);

  @override
  double calculatePay() => annualSalary / 12;
}

class CommissionEmployee extends Employee {
  double baseSalary;
  double sales;
  double commissionRate;

  CommissionEmployee(String name, this.baseSalary, this.sales, this.commissionRate)
      : super(name);

  @override
  double calculatePay() => baseSalary / 12 + sales * commissionRate;
}

void processPayroll(List<Employee> employees) {
  print('Monthly Payroll:');
  print('-' * 30);
  double total = 0;
  for (var emp in employees) {
    var pay = emp.calculatePay();
    total += pay;
    print('${emp.name.padRight(15)} \$${pay.toStringAsFixed(2)}');
  }
  print('-' * 30);
  print('Total:          \$${total.toStringAsFixed(2)}');
}

void main() {
  List<Employee> employees = [
    HourlyEmployee('Alice', 25.0, 45),      // 40×25 + 5×37.5 = 1187.5
    SalariedEmployee('Bob', 72000),          // 72000/12 = 6000
    CommissionEmployee('Charlie', 36000, 20000, 0.05),  // 3000 + 1000 = 4000
  ];

  processPayroll(employees);
}
```

</details>

---

## Exercise 6: Interface Implementation

**Difficulty:** ⭐⭐⭐ Hard

Create a storage system with multiple implementations:

```dart
void main() {
  // TODO: Create:
  // - Abstract Storage interface with:
  //   save(key, value), get(key), delete(key), exists(key)
  // - MemoryStorage - stores in a Map
  // - FileStorage - simulates file storage (just print operations)
  // - CacheStorage - wraps another storage, caches gets

  testStorage(MemoryStorage());
  testStorage(FileStorage('/data'));
}

void testStorage(Storage storage) {
  print('\nTesting ${storage.runtimeType}:');
  storage.save('user', 'Alice');
  print('Get user: ${storage.get('user')}');
  print('Exists: ${storage.exists('user')}');
  storage.delete('user');
  print('After delete: ${storage.exists('user')}');
}
```

<details>
<summary>💡 Hint</summary>

Use `implements` for interface. Each class provides its own implementation.

</details>

<details>
<summary>✅ Solution</summary>

```dart
abstract class Storage {
  void save(String key, String value);
  String? get(String key);
  void delete(String key);
  bool exists(String key);
}

class MemoryStorage implements Storage {
  final Map<String, String> _data = {};

  @override
  void save(String key, String value) {
    _data[key] = value;
    print('  [Memory] Saved $key');
  }

  @override
  String? get(String key) {
    print('  [Memory] Getting $key');
    return _data[key];
  }

  @override
  void delete(String key) {
    _data.remove(key);
    print('  [Memory] Deleted $key');
  }

  @override
  bool exists(String key) => _data.containsKey(key);
}

class FileStorage implements Storage {
  final String basePath;
  final Map<String, String> _simulatedFiles = {};

  FileStorage(this.basePath);

  @override
  void save(String key, String value) {
    _simulatedFiles[key] = value;
    print('  [File] Writing to $basePath/$key');
  }

  @override
  String? get(String key) {
    print('  [File] Reading from $basePath/$key');
    return _simulatedFiles[key];
  }

  @override
  void delete(String key) {
    _simulatedFiles.remove(key);
    print('  [File] Deleting $basePath/$key');
  }

  @override
  bool exists(String key) => _simulatedFiles.containsKey(key);
}

class CacheStorage implements Storage {
  final Storage _underlying;
  final Map<String, String> _cache = {};

  CacheStorage(this._underlying);

  @override
  void save(String key, String value) {
    _cache[key] = value;
    _underlying.save(key, value);
  }

  @override
  String? get(String key) {
    if (_cache.containsKey(key)) {
      print('  [Cache] Hit for $key');
      return _cache[key];
    }
    print('  [Cache] Miss for $key');
    var value = _underlying.get(key);
    if (value != null) _cache[key] = value;
    return value;
  }

  @override
  void delete(String key) {
    _cache.remove(key);
    _underlying.delete(key);
  }

  @override
  bool exists(String key) => _cache.containsKey(key) || _underlying.exists(key);
}

void testStorage(Storage storage) {
  print('\nTesting ${storage.runtimeType}:');
  storage.save('user', 'Alice');
  print('Get user: ${storage.get('user')}');
  print('Exists: ${storage.exists('user')}');
  storage.delete('user');
  print('After delete: ${storage.exists('user')}');
}

void main() {
  testStorage(MemoryStorage());
  testStorage(FileStorage('/data'));

  print('\nTesting CacheStorage with FileStorage:');
  var cached = CacheStorage(FileStorage('/data'));
  cached.save('item', 'value');
  cached.get('item');  // Cache hit
  cached.get('item');  // Cache hit
}
```

</details>

---

## Exercise 7: Mixins for Capabilities

**Difficulty:** ⭐⭐⭐ Hard

Create a vehicle system using mixins:

```dart
void main() {
  // TODO: Create:
  // - Mixins: Driveable, Flyable, Sailable
  // - Car: Driveable
  // - Boat: Sailable
  // - Plane: Flyable
  // - AmphibiousVehicle: Driveable, Sailable
  // - FlyingCar: Driveable, Flyable

  List<Vehicle> vehicles = [
    Car('Toyota'),
    Boat('Speedster'),
    Plane('Boeing'),
    AmphibiousVehicle('Amphicar'),
    FlyingCar('Terrafugia'),
  ];

  for (var v in vehicles) {
    print('\n${v.name} (${v.runtimeType}):');
    v.showCapabilities();
  }
}
```

<details>
<summary>💡 Hint</summary>

Each mixin adds specific methods. A class can use multiple mixins with `with`.

</details>

<details>
<summary>✅ Solution</summary>

```dart
mixin Driveable {
  void drive() => print('  🚗 Driving on road');
}

mixin Flyable {
  void fly() => print('  ✈️ Flying in the air');
}

mixin Sailable {
  void sail() => print('  ⛵ Sailing on water');
}

abstract class Vehicle {
  String name;
  Vehicle(this.name);

  void showCapabilities();
}

class Car extends Vehicle with Driveable {
  Car(String name) : super(name);

  @override
  void showCapabilities() {
    drive();
  }
}

class Boat extends Vehicle with Sailable {
  Boat(String name) : super(name);

  @override
  void showCapabilities() {
    sail();
  }
}

class Plane extends Vehicle with Flyable {
  Plane(String name) : super(name);

  @override
  void showCapabilities() {
    fly();
  }
}

class AmphibiousVehicle extends Vehicle with Driveable, Sailable {
  AmphibiousVehicle(String name) : super(name);

  @override
  void showCapabilities() {
    drive();
    sail();
  }
}

class FlyingCar extends Vehicle with Driveable, Flyable {
  FlyingCar(String name) : super(name);

  @override
  void showCapabilities() {
    drive();
    fly();
  }
}

void main() {
  List<Vehicle> vehicles = [
    Car('Toyota'),
    Boat('Speedster'),
    Plane('Boeing'),
    AmphibiousVehicle('Amphicar'),
    FlyingCar('Terrafugia'),
  ];

  for (var v in vehicles) {
    print('\n${v.name} (${v.runtimeType}):');
    v.showCapabilities();
  }
}
```

</details>

---

## Exercise 8: Factory Pattern - Logger

**Difficulty:** ⭐⭐⭐ Hard

Create a logging system with factory constructor:

```dart
void main() {
  // TODO: Create Logger class with:
  // - Singleton pattern using factory constructor
  // - log(message), warn(message), error(message)
  // - setLevel(level) - 'debug', 'info', 'warn', 'error'
  // - Only show messages at or above current level

  var logger1 = Logger();
  var logger2 = Logger();

  print('Same instance: ${identical(logger1, logger2)}');

  logger1.setLevel('info');

  logger1.debug('Debug message');  // Not shown
  logger1.info('Info message');    // Shown
  logger1.warn('Warning!');        // Shown
  logger1.error('Error occurred'); // Shown
}
```

<details>
<summary>💡 Hint</summary>

Use static field for single instance. Define log levels as integers for comparison.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class Logger {
  static final Logger _instance = Logger._internal();

  static const Map<String, int> _levels = {
    'debug': 0,
    'info': 1,
    'warn': 2,
    'error': 3,
  };

  int _currentLevel = 0;

  factory Logger() => _instance;

  Logger._internal();

  void setLevel(String level) {
    _currentLevel = _levels[level.toLowerCase()] ?? 0;
    print('Log level set to: $level');
  }

  void _log(String level, String message) {
    var levelValue = _levels[level] ?? 0;
    if (levelValue >= _currentLevel) {
      var timestamp = DateTime.now().toString().substring(11, 19);
      print('[$timestamp] [${level.toUpperCase()}] $message');
    }
  }

  void debug(String message) => _log('debug', message);
  void info(String message) => _log('info', message);
  void warn(String message) => _log('warn', message);
  void error(String message) => _log('error', message);
}

void main() {
  var logger1 = Logger();
  var logger2 = Logger();

  print('Same instance: ${identical(logger1, logger2)}');

  print('\nWith default level (debug):');
  logger1.debug('Debug message');
  logger1.info('Info message');

  print('\nWith info level:');
  logger1.setLevel('info');
  logger1.debug('Debug message');  // Not shown
  logger1.info('Info message');
  logger1.warn('Warning!');
  logger1.error('Error occurred');

  print('\nWith error level:');
  logger1.setLevel('error');
  logger1.info('Info message');    // Not shown
  logger1.warn('Warning!');        // Not shown
  logger1.error('Error occurred');
}
```

</details>

---

## Exercise 9: Complete Library System

**Difficulty:** ⭐⭐⭐⭐ Expert

Create a library management system:

```dart
void main() {
  // TODO: Create:
  // - Book: id, title, author, isAvailable
  // - Member: id, name, borrowedBooks
  // - Library: books, members
  //   Methods: addBook, addMember, borrowBook, returnBook, searchBooks

  var library = Library('City Library');

  // Add books
  library.addBook(Book('B001', 'The Hobbit', 'Tolkien'));
  library.addBook(Book('B002', '1984', 'Orwell'));
  library.addBook(Book('B003', 'Dune', 'Herbert'));

  // Add members
  library.addMember(Member('M001', 'Alice'));
  library.addMember(Member('M002', 'Bob'));

  // Operations
  library.borrowBook('M001', 'B001');
  library.borrowBook('M001', 'B002');
  library.borrowBook('M002', 'B001');  // Should fail

  library.printStatus();

  library.returnBook('M001', 'B001');
  library.borrowBook('M002', 'B001');  // Now should work

  library.printStatus();
}
```

<details>
<summary>💡 Hint</summary>

Track availability in Book. Track borrowed books in Member. Library orchestrates all operations with validation.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class Book {
  final String id;
  final String title;
  final String author;
  bool isAvailable;

  Book(this.id, this.title, this.author, [this.isAvailable = true]);

  @override
  String toString() => '$title by $author ${isAvailable ? "(Available)" : "(Borrowed)"}';
}

class Member {
  final String id;
  final String name;
  final List<Book> borrowedBooks = [];

  Member(this.id, this.name);

  bool canBorrow() => borrowedBooks.length < 3;

  void borrow(Book book) {
    borrowedBooks.add(book);
    book.isAvailable = false;
  }

  void returnBook(Book book) {
    borrowedBooks.remove(book);
    book.isAvailable = true;
  }

  @override
  String toString() => '$name (${borrowedBooks.length} books borrowed)';
}

class Library {
  final String name;
  final List<Book> books = [];
  final List<Member> members = [];

  Library(this.name);

  void addBook(Book book) {
    books.add(book);
    print('Added book: ${book.title}');
  }

  void addMember(Member member) {
    members.add(member);
    print('Added member: ${member.name}');
  }

  Book? findBook(String bookId) {
    try {
      return books.firstWhere((b) => b.id == bookId);
    } catch (e) {
      return null;
    }
  }

  Member? findMember(String memberId) {
    try {
      return members.firstWhere((m) => m.id == memberId);
    } catch (e) {
      return null;
    }
  }

  bool borrowBook(String memberId, String bookId) {
    var member = findMember(memberId);
    var book = findBook(bookId);

    if (member == null) {
      print('Error: Member not found');
      return false;
    }
    if (book == null) {
      print('Error: Book not found');
      return false;
    }
    if (!book.isAvailable) {
      print('Error: Book "${book.title}" is not available');
      return false;
    }
    if (!member.canBorrow()) {
      print('Error: ${member.name} has reached borrowing limit');
      return false;
    }

    member.borrow(book);
    print('${member.name} borrowed "${book.title}"');
    return true;
  }

  bool returnBook(String memberId, String bookId) {
    var member = findMember(memberId);
    var book = findBook(bookId);

    if (member == null || book == null) {
      print('Error: Invalid member or book');
      return false;
    }

    if (!member.borrowedBooks.contains(book)) {
      print('Error: ${member.name} did not borrow this book');
      return false;
    }

    member.returnBook(book);
    print('${member.name} returned "${book.title}"');
    return true;
  }

  List<Book> searchBooks(String query) {
    return books.where((b) =>
        b.title.toLowerCase().contains(query.toLowerCase()) ||
        b.author.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void printStatus() {
    print('\n=== $name Status ===');
    print('\nBooks:');
    for (var book in books) {
      print('  $book');
    }
    print('\nMembers:');
    for (var member in members) {
      print('  $member');
      for (var book in member.borrowedBooks) {
        print('    - ${book.title}');
      }
    }
    print('');
  }
}

void main() {
  var library = Library('City Library');

  library.addBook(Book('B001', 'The Hobbit', 'Tolkien'));
  library.addBook(Book('B002', '1984', 'Orwell'));
  library.addBook(Book('B003', 'Dune', 'Herbert'));

  library.addMember(Member('M001', 'Alice'));
  library.addMember(Member('M002', 'Bob'));

  print('');
  library.borrowBook('M001', 'B001');
  library.borrowBook('M001', 'B002');
  library.borrowBook('M002', 'B001');

  library.printStatus();

  library.returnBook('M001', 'B001');
  library.borrowBook('M002', 'B001');

  library.printStatus();
}
```

</details>

---

## Self-Assessment

After completing these exercises, you should be able to:

- [ ] Create classes with properties and methods
- [ ] Use different constructor types
- [ ] Implement encapsulation with private members
- [ ] Create class hierarchies with inheritance
- [ ] Apply polymorphism with abstract classes
- [ ] Use interfaces with `implements`
- [ ] Apply mixins for code reuse
- [ ] Implement common design patterns

---

**Congratulations!** You've completed Level 4!

---

**Next Level:** `../../Level-05-Flutter-Foundations/README.md`
