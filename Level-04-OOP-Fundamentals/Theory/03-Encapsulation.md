# Encapsulation: Protecting An Object's Data

## The Big Idea In One Sentence

> Encapsulation means **hiding an object's data** and only letting the outside world change it through safe, controlled steps.

It is how you stop other code from putting your object into a silly state.

---

## A Picture To Hold In Your Head

Think of a **TV**.

- You use the **buttons and remote** to change the channel and volume. That is the safe, public way.
- You do **not** open the back and poke the wires. Those are hidden inside for a reason.

Encapsulation is the same idea in code:

- The **buttons** are the public methods and getters anyone can use.
- The **wires** are the private data, hidden so nobody can mess it up.

---

## Why We Need It

Here is a bank account with no protection:

```dart
class BankAccount {
  double balance = 0;
}

void main() {
  var account = BankAccount();
  account.balance = -1000000;   // uh oh, a negative balance!
}
```

Anyone can set the balance to anything, even a nonsense negative number. There is no rule stopping them. That is a bug waiting to happen.

Encapsulation fixes this: hide the balance, and only allow changes through methods that check the rules.

---

## Making Data Private With `_`

In Dart, you make something private by starting its name with an **underscore** `_`.

```dart
class BankAccount {
  double _balance = 0;   // private: the underscore means "hands off"

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }

  double get balance => _balance;   // a safe way to read it (more on this below)
}
```

Now the balance lives behind a `deposit` method that checks the amount is positive. The outside world cannot just slam a bad value into it.

> **An honest note for DartPad.** Dart's `_` privacy works between files. If this class were in its own file (like in a real app), other files truly could not touch `_balance`. But when everything is in **one** DartPad file, Dart will still let you reach `_balance`. So while you are learning in a single file, treat anything with a `_` as off-limits even though Dart does not block you yet. The habit is what matters.

---

## Getters: A Safe Way To Read

A **getter** lets the outside read a value, but not change it. You write `get` before a name, and use `=>` to give back the value.

```dart
class BankAccount {
  double _balance = 100;

  double get balance => _balance;   // read-only view of the balance
}

void main() {
  var account = BankAccount();
  print(account.balance);   // 100.0   (no parentheses, like a property)
}
```

Notice you read it as `account.balance`, with **no parentheses**. A getter looks like a property from the outside, but it is really a tiny function.

### Getters Can Compute Things

A getter does not have to just hand back a stored value. It can **work something out** from the object's data.

```dart
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double get area => width * height;
  double get perimeter => 2 * (width + height);
  bool get isSquare => width == height;
}

void main() {
  var r = Rectangle(4, 3);
  print(r.area);       // 12.0
  print(r.perimeter);  // 14.0
  print(r.isSquare);   // false
}
```

`area` is not stored anywhere. It is calculated fresh each time you ask. This is great, because it can never go out of sync with `width` and `height`.

---

## Setters: A Safe Way To Change

A **setter** lets the outside change a value, but it can **check the rules first**. You write `set` before a name and take one value.

```dart
class Person {
  int _age = 0;

  int get age => _age;

  set age(int value) {
    if (value >= 0 && value <= 150) {
      _age = value;     // only accept sensible ages
    }
  }
}

void main() {
  var p = Person();

  p.age = 25;       // looks like a normal assignment
  print(p.age);     // 25

  p.age = -10;      // rejected by the setter's check
  print(p.age);     // 25  (unchanged)
}
```

From the outside, `p.age = 25` looks like a plain assignment. But behind the scenes the setter runs its check first. The bad value `-10` is quietly ignored, so the object stays valid.

---

## Read-Only: A Getter With No Setter

If you want a value that can be **read but never changed from outside**, give it a getter and **no** setter.

```dart
class User {
  final String _id;
  String _name;

  User(this._id, this._name);

  String get id => _id;       // read-only: no setter

  String get name => _name;   // read-write: has a setter below
  set name(String value) {
    if (value.isNotEmpty) _name = value;
  }
}

void main() {
  var u = User('A123', 'Ada');

  print(u.id);     // A123
  u.name = 'Bola'; // allowed, there is a setter
  print(u.name);   // Bola
}
```

`id` has only a getter, so once set it can never change. `name` has both, so it can be read and (carefully) changed.

---

## Why This Matters In Flutter

Real apps are full of objects that must stay valid: a cart total that is never negative, an age that is always sensible, an id that never changes. Encapsulation is how you guarantee that. You hide the raw data and expose safe getters and setters. Every serious Flutter app is built this way.

---

## The Top Mistakes Beginners Make

### Mistake 1: Calling a getter with parentheses

```dart
print(account.balance());   // BAD: a getter is not called with ()
print(account.balance);     // GOOD
```

### Mistake 2: Leaving data public when it needs rules

```dart
double balance = 0;     // BAD: anyone can set a bad value
double _balance = 0;    // GOOD: hide it, expose safe methods
```

### Mistake 3: Storing a computed value instead of using a getter

```dart
// BAD: area can get out of sync if width changes
double area;
// GOOD: compute it each time
double get area => width * height;
```

### Mistake 4: Expecting `_` to block access in one DartPad file

Within a single file, Dart still lets you reach `_name`. The protection kicks in across files in a real project. Treat `_` as "private" anyway.

---

## One-Minute Recap

- Encapsulation = hide the data, control how it changes.
- Make data private with a leading underscore: `_balance`.
- A **getter** (`get`) gives safe read access, and can compute values.
- A **setter** (`set`) gives controlled write access, and can check the rules.
- A getter with no setter is **read-only**.
- Read a getter with no parentheses: `account.balance`.

---

## Quick Quiz

**Q1.** How do you make a field private in Dart?

<details>
<summary>Answer</summary>
Start its name with an underscore, like `_balance`.
</details>

**Q2.** What does this print?

```dart
class Person {
  int _age = 20;
  int get age => _age;
  set age(int value) {
    if (value >= 0) _age = value;
  }
}

void main() {
  var p = Person();
  p.age = -5;
  print(p.age);
}
```

<details>
<summary>Answer</summary>
`20`. The setter rejects negative values, so the age stays at its starting value of 20.
</details>

**Q3.** What is a read-only property?

<details>
<summary>Answer</summary>
A property with a getter but no setter. You can read it from outside, but not change it.
</details>

**Q4.** Why is a computed getter (`get area => width * height`) better than a stored `area` field?

<details>
<summary>Answer</summary>
It is calculated fresh each time, so it can never get out of sync. A stored `area` would be wrong the moment `width` or `height` changed.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: A safe counter

Write a `Counter` class with a private `int _count` starting at 0. Give it a getter `count`, a method `increase()` that adds 1, and a method `decrease()` that subtracts 1 but **never** lets the count go below 0. Test it by decreasing below zero.

### Problem 2: Computed getters

Write a `Square` class with a `double side`. Add two computed getters: `area` (side times side) and `perimeter` (four times side). Build a square with side 5 and print both.

### Problem 3: Predict the output

```dart
class Thermostat {
  double _temp = 20;

  double get temp => _temp;

  set temp(double value) {
    if (value >= 10 && value <= 30) {
      _temp = value;
    }
  }
}

void main() {
  var t = Thermostat();
  t.temp = 25;
  print(t.temp);
  t.temp = 50;
  print(t.temp);
}
```

### Problem 4: Validated bank account

Write a `BankAccount` class with a private `double _balance` (starts at 0), a read-only getter `balance`, a `deposit(amount)` method that only accepts positive amounts, and a `withdraw(amount)` method that only works if the amount is positive and not more than the balance. Test all the cases.

### Problem 5: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
class Counter {
  int _count = 0;

  int get count() => _count;

  void add() {
    count = count + 1;
  }
}

void main() {
  var c = Counter();
  c.add();
  print(c.count);
}
```

---

## Assignment Answers

### Problem 1: A safe counter

```dart
class Counter {
  int _count = 0;

  int get count => _count;

  void increase() {
    _count = _count + 1;
  }

  void decrease() {
    if (_count > 0) {
      _count = _count - 1;
    }
  }
}

void main() {
  var c = Counter();
  c.increase();
  c.increase();
  c.decrease();
  c.decrease();
  c.decrease();   // would go to -1, but blocked
  print(c.count); // 0
}
```

`_count` is private, so the only way to change it is through `increase` and `decrease`. The check `if (_count > 0)` inside `decrease` stops it from ever going negative. After two increases and three decreases it lands at 0, not -1.

### Problem 2: Computed getters

```dart
class Square {
  double side;

  Square(this.side);

  double get area => side * side;
  double get perimeter => side * 4;
}

void main() {
  var s = Square(5);
  print(s.area);        // 25.0
  print(s.perimeter);   // 20.0
}
```

Neither `area` nor `perimeter` is stored. They are computed from `side` whenever you read them, so they are always correct.

### Problem 3: Predict the output

```
25.0
25.0
```

`t.temp = 25` is inside the allowed range (10 to 30), so it is accepted, and `temp` becomes 25. `t.temp = 50` is outside the range, so the setter ignores it, and `temp` stays 25.

### Problem 4: Validated bank account

```dart
class BankAccount {
  double _balance = 0;

  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance = _balance + amount;
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance = _balance - amount;
    }
  }
}

void main() {
  var account = BankAccount();
  account.deposit(100);
  account.withdraw(30);
  account.withdraw(1000);   // too much, ignored
  account.deposit(-50);     // negative, ignored
  print(account.balance);   // 70.0
}
```

The balance is private, so the only way to change it is through `deposit` and `withdraw`, which both check the rules. The bad calls (withdrawing more than the balance, depositing a negative) are quietly ignored, so the balance ends at 70.

### Problem 5: Spot the bugs

The two mistakes:

1. `int get count() => _count;` declares the getter with parentheses. A getter declaration has **no** `()`. It should be `int get count => _count;`.
2. `count = count + 1;` tries to assign to `count`, but `count` is a getter with no setter, so you cannot assign to it. To change the value, use the private field directly: `_count = _count + 1;`.

Fixed:

```dart
class Counter {
  int _count = 0;

  int get count => _count;        // no parentheses

  void add() {
    _count = _count + 1;          // change the private field, not the getter
  }
}

void main() {
  var c = Counter();
  c.add();
  print(c.count);   // 1
}
```

Output:

```
1
```

The lesson: a getter is declared with no `()`, and a getter-only property cannot be assigned to. Change the private field behind it instead.

---

**Next:** `04-Inheritance.md`, where one class can build on top of another.
