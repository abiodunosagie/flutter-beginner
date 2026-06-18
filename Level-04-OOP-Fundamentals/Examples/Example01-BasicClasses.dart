// ===========================================
// Example 01: Classes and Objects
// ===========================================
//
// This file matches Theory/01-ClassesAndObjects.md.
// Read the theory first, then run this file and watch the output.
//
// HOW TO RUN:
//   - Easiest: copy everything into https://dartpad.dev and press Run.
//   - Or in a terminal: dart Example01-BasicClasses.dart
//
// As you read main() below, the comment after each line shows you
// EXACTLY what that line prints. Try to predict it before you look.

void main() {
  // -----------------------------------------
  // PART 1: Build objects from a blueprint
  // -----------------------------------------
  // The Person class (defined at the bottom) is the blueprint.
  // Each line below BUILDS one real Person object from it.

  print('--- Part 1: Building objects ---');

  var alice = Person('Alice', 25, 'alice@email.com');
  var bob = Person('Bob', 30, 'bob@email.com');

  // Read a property with a dot:
  print(alice.name); // Alice
  print(bob.age); // 30

  // -----------------------------------------
  // PART 2: Call methods (actions)
  // -----------------------------------------

  print('\n--- Part 2: Calling methods ---');

  alice.introduce(); // Hi, I am Alice, 25 years old.
  bob.introduce(); // Hi, I am Bob, 30 years old.

  alice.haveBirthday(); // Happy birthday! Now 26 years old.
  alice.introduce(); // Hi, I am Alice, 26 years old.

  // -----------------------------------------
  // PART 3: Each object is separate
  // -----------------------------------------
  // We build TWO counters. Bumping one does not touch the other.

  print('\n--- Part 3: Objects are independent ---');

  var counterA = Counter();
  var counterB = Counter();

  counterA.increment();
  counterA.increment();
  counterA.increment();

  counterB.increment();

  print('counterA: ${counterA.count}'); // counterA: 3
  print('counterB: ${counterB.count}'); // counterB: 1

  // -----------------------------------------
  // PART 4: Two names for the SAME object
  // -----------------------------------------
  // Here we DO NOT build a new object. `second = first` makes
  // `second` point at the exact same object as `first`.

  print('\n--- Part 4: Same object, two names ---');

  var first = Person('Charlie', 40, 'charlie@email.com');
  var second = first; // not a copy! same object.

  second.haveBirthday(); // Happy birthday! Now 41 years old.

  print(first.age); // 41  <-- changed too, it is the same object
  print(second.age); // 41

  // -----------------------------------------
  // PART 5: A realistic class - BankAccount
  // -----------------------------------------

  print('\n--- Part 5: Bank account ---');

  var account = BankAccount('Alice', 100);

  account.deposit(50); // Alice deposited 50.0. Balance is now 150.0
  account.withdraw(30); // Alice withdrew 30.0. Balance is now 120.0
  account.withdraw(500); // Cannot withdraw 500.0. Balance is only 120.0
}

// ===========================================
// THE BLUEPRINTS (class definitions)
// ===========================================

// A Person has data (name, age, email) and actions (introduce, haveBirthday).
class Person {
  // Properties: the data every Person carries.
  String name;
  int age;
  String email;

  // Constructor: runs when you build a Person. The `this.` shortcut
  // stores each value you pass into the matching property.
  Person(this.name, this.age, this.email);

  // Method: an action. It can use the object's own properties by name.
  void introduce() {
    print('Hi, I am $name, $age years old.');
  }

  // Method that changes a property.
  void haveBirthday() {
    age = age + 1;
    print('Happy birthday! Now $age years old.');
  }
}

// A Counter just holds a number it can bump up.
class Counter {
  int count = 0; // every new counter starts at 0

  void increment() {
    count = count + 1;
  }
}

// A BankAccount protects its balance with simple checks.
class BankAccount {
  String owner;
  double balance;

  // owner is required; balance is optional and defaults to 0.
  BankAccount(this.owner, [this.balance = 0]);

  void deposit(double amount) {
    if (amount > 0) {
      balance = balance + amount;
      print('$owner deposited $amount. Balance is now $balance');
    } else {
      print('Deposit must be positive.');
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= balance) {
      balance = balance - amount;
      print('$owner withdrew $amount. Balance is now $balance');
    } else {
      print('Cannot withdraw $amount. Balance is only $balance');
    }
  }
}

// ===========================================
// Try it yourself:
// 1. Add an `email` change: set alice.email = 'new@email.com' and print it.
// 2. Give Counter a `reset()` method that sets count back to 0.
// 3. Add a `printBalance()` method to BankAccount and call it.
// ===========================================
