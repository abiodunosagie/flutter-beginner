# Week 5, Day 3-4: Encapsulation - Protecting Your Data

## The Problem: Direct Access

Imagine a bank account class:

```dart
class BankAccount {
  String owner;
  double balance;

  BankAccount(this.owner, this.balance);
}

void main() {
  BankAccount account = BankAccount('Alice', 1000);

  // Anyone can do ANYTHING!
  account.balance = -5000;  // Negative balance?!
  account.balance = 999999999;  // Hack the system!
  account.owner = '';  // Empty name!

  print(account.balance);  // -5000
}
```

**Problems:**
- No validation
- No protection
- No control
- Data can be corrupted

**Solution:** **Encapsulation**

---

## What is Encapsulation?

**Encapsulation** means **hiding** internal details and **controlling** access to data.

**Real-world analogy:**
- **TV Remote** - You press buttons (public interface), but you don't mess with internal circuitry (private)
- **ATM** - You use the screen and keypad (public), but can't directly access the cash vault (private)
- **Car** - You use steering wheel and pedals (public), engine internals are hidden (private)

**In programming:**
- **Private** - Hidden from outside (internal use only)
- **Public** - Available to everyone (external interface)
- **Controlled access** - Through getters and setters

---

## Private Properties

In Dart, prefix with underscore `_` to make private:

```dart
class BankAccount {
  String _owner;      // Private
  double _balance;    // Private

  BankAccount(this._owner, this._balance);
}
```

**Important:** Private means "private to the library/file" not the class.

### Example: Protected Bank Account

```dart
class BankAccount {
  String _owner;
  double _balance;

  BankAccount(this._owner, this._balance);

  // Can't access directly from outside!
  // account._balance = -500;  // ERROR if in different file
}
```

---

## Getters - Reading Data

**Getters** provide **read access** to private properties.

### Basic Syntax

```dart
class Person {
  String _name;
  int _age;

  Person(this._name, this._age);

  // Getter for name
  String get name => _name;

  // Getter for age
  int get age => _age;
}

void main() {
  Person person = Person('Alice', 25);

  // Access through getters
  print(person.name);  // Alice
  print(person.age);   // 25

  // Can't modify!
  // person.name = 'Bob';  // ERROR! No setter
}
```

**Note:** Getters look like properties but are actually methods.

### Computed Getters

Getters can calculate values on-the-fly:

```dart
class Rectangle {
  double _width;
  double _height;

  Rectangle(this._width, this._height);

  // Simple getters
  double get width => _width;
  double get height => _height;

  // Computed getters
  double get area => _width * _height;
  double get perimeter => 2 * (_width + _height);
  bool get isSquare => _width == _height;
}

void main() {
  Rectangle rect = Rectangle(5, 3);

  print('Width: ${rect.width}');        // 5
  print('Height: ${rect.height}');      // 3
  print('Area: ${rect.area}');          // 15 (calculated!)
  print('Perimeter: ${rect.perimeter}'); // 16 (calculated!)
  print('Is square: ${rect.isSquare}'); // false
}
```

---

## Setters - Writing Data with Validation

**Setters** provide **write access** with validation.

### Basic Syntax

```dart
class Person {
  String _name;
  int _age;

  Person(this._name, this._age);

  // Getter
  String get name => _name;
  int get age => _age;

  // Setter with validation
  set name(String value) {
    if (value.isEmpty) {
      print('Name cannot be empty!');
      return;
    }
    _name = value;
  }

  set age(int value) {
    if (value < 0 || value > 150) {
      print('Invalid age!');
      return;
    }
    _age = value;
  }
}

void main() {
  Person person = Person('Alice', 25);

  // Valid update
  person.name = 'Alicia';
  print(person.name);  // Alicia

  // Invalid update (caught!)
  person.name = '';     // Prints: Name cannot be empty!
  print(person.name);   // Still Alicia

  person.age = -5;      // Prints: Invalid age!
  print(person.age);    // Still 25
}
```

---

## Complete Encapsulation Example

```dart
class BankAccount {
  String _accountNumber;
  String _owner;
  double _balance;

  BankAccount(this._accountNumber, this._owner, this._balance);

  // Getters (read-only)
  String get accountNumber => _accountNumber;
  String get owner => _owner;
  double get balance => _balance;

  // Setter for owner (with validation)
  set owner(String newOwner) {
    if (newOwner.isEmpty) {
      print('Owner name cannot be empty');
      return;
    }
    _owner = newOwner;
  }

  // NO setter for balance!
  // Only methods can modify it (with rules)

  // Method: deposit (with validation)
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive');
      return;
    }
    _balance += amount;
    print('Deposited \$${amount.toStringAsFixed(2)}');
    print('New balance: \$${_balance.toStringAsFixed(2)}');
  }

  // Method: withdraw (with validation)
  bool withdraw(double amount) {
    if (amount <= 0) {
      print('Withdrawal amount must be positive');
      return false;
    }
    if (amount > _balance) {
      print('Insufficient funds');
      return false;
    }
    _balance -= amount;
    print('Withdrew \$${amount.toStringAsFixed(2)}');
    print('New balance: \$${_balance.toStringAsFixed(2)}');
    return true;
  }

  // Computed getter
  bool get isOverdrawn => _balance < 0;

  void displayInfo() {
    print('\n=== Account Info ===');
    print('Account: $_accountNumber');
    print('Owner: $_owner');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
    print('==================\n');
  }
}

void main() {
  BankAccount account = BankAccount('12345', 'Alice', 1000);

  account.displayInfo();

  // Controlled deposits
  account.deposit(500);     // OK
  account.deposit(-100);    // Rejected!

  // Controlled withdrawals
  account.withdraw(200);    // OK
  account.withdraw(5000);   // Rejected - insufficient funds!

  // Read balance (but can't set directly!)
  print('Current balance: \$${account.balance}');

  // Can't do this (good!):
  // account.balance = 999999;  // ERROR! No setter

  account.displayInfo();
}
```

**Output:**
```
=== Account Info ===
Account: 12345
Owner: Alice
Balance: $1000.00
==================

Deposited $500.00
New balance: $1500.00
Deposit amount must be positive
Withdrew $200.00
New balance: $1300.00
Insufficient funds
Current balance: $1300.00

=== Account Info ===
Account: 12345
Owner: Alice
Balance: $1300.00
==================
```

---

## Read-Only Properties

Make properties completely read-only (no setter):

```dart
class Product {
  final String _id;  // Can't change after creation
  String _name;
  double _price;

  Product(this._id, this._name, this._price);

  // Read-only (no setter!)
  String get id => _id;

  // Read-write (has setter)
  String get name => _name;
  set name(String value) {
    if (value.isNotEmpty) _name = value;
  }

  double get price => _price;
  set price(double value) {
    if (value > 0) _price = value;
  }
}

void main() {
  Product product = Product('P001', 'Laptop', 999.99);

  print(product.id);     // P001

  // Can change name and price
  product.name = 'Gaming Laptop';
  product.price = 1299.99;

  // CANNOT change ID
  // product.id = 'P002';  // ERROR! No setter
}
```

---

## Benefits of Encapsulation

### 1. Data Validation

```dart
class User {
  String _email;
  int _age;

  User(this._email, this._age);

  String get email => _email;
  set email(String value) {
    if (value.contains('@') && value.contains('.')) {
      _email = value;
    } else {
      print('Invalid email format');
    }
  }

  int get age => _age;
  set age(int value) {
    if (value >= 0 && value <= 150) {
      _age = value;
    } else {
      print('Invalid age');
    }
  }
}
```

### 2. Consistent State

```dart
class Circle {
  double _radius;

  Circle(this._radius);

  double get radius => _radius;
  set radius(double value) {
    if (value > 0) {
      _radius = value;
    }
  }

  // Computed properties always consistent
  double get diameter => _radius * 2;
  double get circumference => 2 * 3.14159 * _radius;
  double get area => 3.14159 * _radius * _radius;
}
```

### 3. Change Internal Implementation

```dart
class Temperature {
  double _celsius;

  Temperature(this._celsius);

  // Users only see Fahrenheit
  double get fahrenheit => (_celsius * 9 / 5) + 32;
  set fahrenheit(double f) => _celsius = (f - 32) * 5 / 9;

  // Internally stored as Celsius (users don't care!)
  double get celsius => _celsius;
  set celsius(double c) => _celsius = c;
}
```

---

## Public vs Private Design

### Bad Design (Everything Public)

```dart
class BadBankAccount {
  String accountNumber;  // Anyone can change!
  double balance;        // Anyone can set to anything!

  BadBankAccount(this.accountNumber, this.balance);
}

void main() {
  BadBankAccount account = BadBankAccount('12345', 1000);

  // This is BAD!
  account.balance = 999999999;  // Hack!
  account.accountNumber = '';   // Break the system!
}
```

### Good Design (Encapsulated)

```dart
class GoodBankAccount {
  final String _accountNumber;
  double _balance;

  GoodBankAccount(this._accountNumber, this._balance);

  String get accountNumber => _accountNumber;
  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) _balance += amount;
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      return true;
    }
    return false;
  }
}

void main() {
  GoodBankAccount account = GoodBankAccount('12345', 1000);

  // Only allowed operations
  account.deposit(500);
  account.withdraw(200);

  // Can't hack it!
  // account.balance = 999999;  // ERROR! No setter
}
```

---

## Real-World Example: User Class

```dart
class User {
  final String _id;
  String _username;
  String _email;
  DateTime _createdAt;
  bool _isActive;

  User(this._id, this._username, this._email)
      : _createdAt = DateTime.now(),
        _isActive = true;

  // Read-only properties
  String get id => _id;
  DateTime get createdAt => _createdAt;

  // Username (validated)
  String get username => _username;
  set username(String value) {
    if (value.length >= 3 && value.length <= 20) {
      _username = value;
    } else {
      print('Username must be 3-20 characters');
    }
  }

  // Email (validated)
  String get email => _email;
  set email(String value) {
    if (value.contains('@') && value.contains('.')) {
      _email = value;
    } else {
      print('Invalid email');
    }
  }

  // Active status
  bool get isActive => _isActive;

  // Methods to change status (not direct setter)
  void activate() {
    _isActive = true;
    print('User activated');
  }

  void deactivate() {
    _isActive = false;
    print('User deactivated');
  }

  // Computed getter
  int get accountAge {
    return DateTime.now().difference(_createdAt).inDays;
  }

  void displayInfo() {
    print('\n=== User Info ===');
    print('ID: $_id');
    print('Username: $_username');
    print('Email: $_email');
    print('Status: ${_isActive ? "Active" : "Inactive"}');
    print('Account age: $accountAge days');
    print('================\n');
  }
}

void main() {
  User user = User('U001', 'alice_dev', 'alice@example.com');

  user.displayInfo();

  // Valid updates
  user.username = 'alice_coder';
  user.email = 'alice.new@example.com';

  // Invalid updates (rejected)
  user.username = 'ab';  // Too short
  user.email = 'invalid';  // No @ or .

  // Change status through methods
  user.deactivate();
  user.activate();

  user.displayInfo();

  // Can't modify these (good!)
  // user.id = 'U002';  // ERROR
  // user.createdAt = DateTime.now();  // ERROR
}
```

---

## Exercises

### Exercise 1: Temperature Class
Create a Temperature class that stores Celsius privately and provides getters/setters for both Celsius and Fahrenheit.

<details>
<summary>Solution</summary>

```dart
class Temperature {
  double _celsius;

  Temperature(this._celsius);

  double get celsius => _celsius;
  set celsius(double value) => _celsius = value;

  double get fahrenheit => (_celsius * 9 / 5) + 32;
  set fahrenheit(double f) => _celsius = (f - 32) * 5 / 9;

  void display() {
    print('${_celsius.toStringAsFixed(2)}°C = ${fahrenheit.toStringAsFixed(2)}°F');
  }
}

void main() {
  Temperature temp = Temperature(25);
  temp.display();  // 25.00°C = 77.00°F

  temp.fahrenheit = 86;
  temp.display();  // 30.00°C = 86.00°F
}
```
</details>

---

### Exercise 2: Password Field
Create a Password class that validates password strength (min 8 chars, has number and special char).

<details>
<summary>Solution</summary>

```dart
class Password {
  String _password = '';

  String get password => '*' * _password.length;  // Hide actual password

  set password(String value) {
    if (value.length < 8) {
      print('Password must be at least 8 characters');
      return;
    }

    bool hasNumber = value.contains(RegExp(r'[0-9]'));
    bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasNumber) {
      print('Password must contain a number');
      return;
    }

    if (!hasSpecial) {
      print('Password must contain a special character');
      return;
    }

    _password = value;
    print('Password set successfully');
  }

  bool verify(String input) {
    return input == _password;
  }
}

void main() {
  Password pwd = Password();

  pwd.password = 'weak';           // Too short
  pwd.password = 'weakpass';       // No number or special
  pwd.password = 'weakpass1';      // No special
  pwd.password = 'Strong@123';     // Valid!

  print(pwd.password);  // ********** (hidden)
  print(pwd.verify('Strong@123'));  // true
}
```
</details>

---

## Key Takeaways

1. **Encapsulation** = Hide internal details, control access
2. **Private** = Prefix with `_` (private to library)
3. **Getters** = Read access (`get propertyName => value`)
4. **Setters** = Write access with validation (`set propertyName(value) { }`)
5. **Computed properties** = Calculate values on-the-fly
6. **Benefits** = Validation, consistency, flexibility

---

## What's Next?

Tomorrow:
- **Inheritance** - Creating class hierarchies
- **Method overriding** - Changing parent behavior
- **`super`** keyword - Accessing parent class

Encapsulation is your first step to writing professional code! 🔒✨
