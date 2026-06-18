# Classes and Objects: The Foundation of OOP

> New to this? Read it top to bottom, slowly. Every code block shows you exactly what it prints. Type the examples into [dartpad.dev](https://dartpad.dev) and run them yourself. That is how this clicks.

---

## 1. The problem we are trying to solve

Imagine you are building an app and you need to keep track of a person: their name, their age, and their email.

With what you already know, you might do this:

```dart
void main() {
  String name = 'Alice';
  int age = 25;
  String email = 'alice@email.com';

  print('Hi, I am $name, $age years old.');
}
```

That works for one person. But what happens when you have three people?

```dart
void main() {
  String name1 = 'Alice';
  int age1 = 25;
  String email1 = 'alice@email.com';

  String name2 = 'Bob';
  int age2 = 30;
  String email2 = 'bob@email.com';

  String name3 = 'Charlie';
  int age3 = 40;
  String email3 = 'charlie@email.com';

  // ...this gets messy fast
}
```

This is a mess. The name, age, and email of one person are not grouped together in any way. They are just loose variables with numbers stuck on the end. Now imagine 100 people.

**Object-Oriented Programming (OOP) fixes this.** It lets you bundle related data (name, age, email) together into one neat package, and attach the actions that go with it (introduce yourself, have a birthday). That package is called an **object**, and the recipe for making one is called a **class**.

---

## 2. The big idea: blueprint vs. building

This is the single most important idea in this whole topic. Read it twice.

- A **class** is a **blueprint**. It is a plan. A blueprint for a house is not a house. You cannot live in it. It just describes what a house *will have* (rooms, doors, windows) and what you *can do* in it.
- An **object** is the actual **house** built from that blueprint. You can have one blueprint and build 100 houses from it. Each house is real, separate, and can have its own paint color.

```
   ONE BLUEPRINT (class)              MANY HOUSES (objects)
   ┌───────────────────┐             🏠  🏠  🏠  🏠  🏠
   │   House plan       │   build →   each one is real,
   │   - has rooms      │             each one is separate
   │   - has a door     │
   └───────────────────┘
```

Other words you will hear:

- An object is also called an **instance**. "Create an instance of Person" means "build one Person object". Same thing.
- The data inside an object (name, age) is called its **properties** (or **fields**).
- The actions an object can do (introduce, have a birthday) are called its **methods**.

Keep that picture in your head: **class = the plan, object = the real thing built from the plan.**

---

## 3. Writing your first class

Let us turn that messy "person" code into a class. We will build it one piece at a time so nothing is mysterious.

### Step 1: the empty blueprint

You start a class with the keyword `class` and a name. By convention, class names start with a **Capital Letter**.

```dart
class Person {
  // nothing here yet
}
```

That is a valid (but empty) blueprint.

### Step 2: add the properties (the data)

Properties are just variables that live inside the class. They describe what every Person *has*.

```dart
class Person {
  String name;
  int age;
  String email;
}
```

Now the blueprint says: "Every person has a name, an age, and an email."

### Step 3: add the constructor (the setup instructions)

When you build a real Person, you need to give it an actual name, age, and email. The piece of code that does this setup is called the **constructor**.

A constructor looks like a function, but it has the **exact same name as the class**, and it has no return type. Here is the full, spelled-out version:

```dart
class Person {
  String name;
  int age;
  String email;

  // This is the constructor. It runs when you build a Person.
  Person(String name, int age, String email) {
    this.name = name;     // take the name we were given, store it in this object
    this.age = age;       // same for age
    this.email = email;   // same for email
  }
}
```

**Wait, what is `this`?**

`this` means **"this particular object I am building right now"**. Inside the constructor, `name` (no `this`) is the value passed in, and `this.name` is the property that belongs to the object. So `this.name = name;` means *"put the value I was given into this object's name slot"*.

You only need `this` when a parameter and a property share the same name and you have to tell them apart. That is exactly the situation above.

### Step 4: the shortcut every Dart developer uses

Typing `this.name = name;` for every property is repetitive. Dart gives you a shortcut that does the exact same thing automatically. You write `this.` directly in the parentheses:

```dart
class Person {
  String name;
  int age;
  String email;

  // Shortcut: this.name, this.age, this.email are filled in for you.
  Person(this.name, this.age, this.email);
}
```

This shortcut version and the spelled-out version in Step 3 do **exactly the same thing**. The short one is just less typing. From now on you will see this short form everywhere, and now you know what it means: *take each value passed in and store it in the matching property of this object.*

### Step 5: add methods (the actions)

Methods are functions that live inside the class. They describe what a Person can *do*. They can use the object's own properties directly by name.

```dart
class Person {
  String name;
  int age;
  String email;

  Person(this.name, this.age, this.email);

  // A method: introduce this person.
  void introduce() {
    print('Hi, I am $name, $age years old.');
  }

  // A method that changes a property.
  void haveBirthday() {
    age = age + 1;
    print('Happy birthday! Now $age years old.');
  }
}
```

That is a complete, useful class. Properties, a constructor, and methods. That is all a class is.

---

## 4. Building and using objects

The blueprint does nothing on its own. To use it, you **build an object** from it. You build one by writing the class name and passing in the values the constructor asked for.

```dart
void main() {
  // Build two Person objects from the one Person blueprint.
  var alice = Person('Alice', 25, 'alice@email.com');
  var bob = Person('Bob', 30, 'bob@email.com');

  // Read a property with a dot:
  print(alice.name);   // Alice
  print(bob.age);      // 30

  // Call a method with a dot and parentheses:
  alice.introduce();   // Hi, I am Alice, 25 years old.
  bob.haveBirthday();  // Happy birthday! Now 31 years old.
}
```

**The dot `.` is how you reach inside an object.** `alice.name` means "the name belonging to alice". `alice.introduce()` means "tell alice to run her introduce method".

### Let us trace exactly what happens

When Dart runs `var alice = Person('Alice', 25, 'alice@email.com');`:

1. Dart starts building a new, empty Person object.
2. The constructor runs. It stores `'Alice'` in `name`, `25` in `age`, `'alice@email.com'` in `email`.
3. The finished object is handed back and stored in the variable `alice`.

Then `alice.introduce()`:

1. Dart finds the object `alice` points to.
2. It runs that object's `introduce` method.
3. Inside the method, `name` is `'Alice'` and `age` is `25`, so it prints `Hi, I am Alice, 25 years old.`

---

## 5. Each object is its own separate thing

This trips up a lot of beginners, so let us make it crystal clear. When you build two objects from the same class, they are **completely independent**. Changing one does not touch the other.

```dart
class Counter {
  int count = 0;   // every counter starts at 0

  void increment() {
    count = count + 1;
  }
}

void main() {
  var counterA = Counter();   // first counter
  var counterB = Counter();   // second, totally separate counter

  counterA.increment();
  counterA.increment();
  counterA.increment();

  counterB.increment();

  print(counterA.count);  // 3
  print(counterB.count);  // 1  <-- not affected by counterA
}
```

`counterA` and `counterB` were built from the same blueprint, but each one keeps its own `count`. Bumping `counterA` three times has zero effect on `counterB`.

> Notice `Counter()` has empty parentheses. This class did not write a constructor, so Dart gives it a free empty one. And `count` has `= 0` right in the blueprint, so every new counter starts at 0 automatically.

---

## 6. One gotcha: two names, same object

Here is the one situation where objects are *not* independent, and it is important.

When you write `var b = a;` and `a` is an object, you do **not** get a copy. Both names now point to the **same single object**. Change it through one name and you see the change through the other.

```dart
void main() {
  var first = Person('Charlie', 40, 'charlie@email.com');
  var second = first;     // NOT a copy. Same object, second name.

  second.age = 99;        // change it through 'second'

  print(first.age);   // 99  <-- changed too, because it is the same object
  print(second.age);  // 99
}
```

Picture it like this. The object lives somewhere in memory, and both variables are arrows pointing at it:

```
  first  ─────┐
              ├──────► [ Person: name="Charlie", age=99 ]
  second ─────┘
```

Compare this to Section 5: there, `Counter()` was called twice, so **two** objects were built. Here, `Person(...)` was called **once**, so there is only **one** object and two names for it. The rule: a new object is only born when you actually call the constructor with `ClassName(...)`.

---

## 7. A full, realistic example: a bank account

Let us put it all together with something that feels real. Read the comments, then read the output.

```dart
class BankAccount {
  String owner;
  double balance;

  // The owner is required. The balance is optional and starts at 0
  // if you do not pass one. (The square brackets mean "optional".)
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

void main() {
  var account = BankAccount('Alice', 100);

  account.deposit(50);    // Alice deposited 50.0. Balance is now 150.0
  account.withdraw(30);   // Alice withdrew 30.0. Balance is now 120.0
  account.withdraw(500);  // Cannot withdraw 500.0. Balance is only 120.0
}
```

Everything here is something you have already met:

- **Properties**: `owner` and `balance` hold the account's data.
- **Constructor**: `BankAccount(this.owner, [this.balance = 0])` sets it up. The `[... = 0]` part makes `balance` optional with a default of 0.
- **Methods**: `deposit` and `withdraw` are the actions, and they use `if` to protect the account from bad input.

---

## 8. Recap

| Word | Plain meaning |
|------|---------------|
| Class | The blueprint. The plan for making objects. |
| Object | A real thing built from the blueprint. |
| Instance | Another word for object. |
| Property (field) | A variable that lives inside an object. Its data. |
| Method | A function that lives inside an object. Its actions. |
| Constructor | The special setup code that runs when you build an object. Same name as the class. |
| `this` | "This particular object." Used to tell a property apart from a parameter with the same name. |
| `.` (dot) | How you reach a property or method inside an object: `alice.name`, `alice.introduce()`. |

The whole thing in one breath: **a class is a blueprint with properties (data) and methods (actions); you build objects from it with `ClassName(...)`; each object keeps its own data; you reach inside an object with a dot.**

---

## 9. Check yourself

Try to answer before opening each box.

**Q1.** What is the difference between a class and an object?

<details>
<summary>Answer</summary>

A class is the blueprint (the plan). An object is a real thing built from that blueprint. One class can make many objects. Think: one house plan, many actual houses.

</details>

**Q2.** In `Person(this.name, this.age);`, what does `this.name` do?

<details>
<summary>Answer</summary>

It takes the value passed into the constructor and stores it in this object's `name` property. It is the shortcut for writing `this.name = name;` inside the constructor body.

</details>

**Q3.** You build two objects: `var a = Counter();` and `var b = Counter();`. You call `a.increment()` five times. What is `b.count`?

<details>
<summary>Answer</summary>

`0`. They are separate objects, so changing `a` does not touch `b`. `b` was never incremented.

</details>

**Q4.** What about this: `var a = Counter(); var b = a; a.increment();` What is `b.count`?

<details>
<summary>Answer</summary>

`1`. Here `b = a` did NOT build a new object. `a` and `b` are two names for the same single object, so incrementing through `a` shows up through `b` too. (Compare with Q3, where the constructor was called twice.)

</details>

**Q5.** How do you call a method named `bark` on an object stored in a variable called `dog`?

<details>
<summary>Answer</summary>

`dog.bark();` Use the dot to reach the method, and the parentheses to actually run it.

</details>

---

## 10. Now practice

1. Open the matching example file and run it: `../Examples/Example01-BasicClasses.dart`. It rebuilds these exact ideas as one runnable program with output.
2. Then do **Exercise 1** in `../Exercises/Exercises.md`. It is gentle and walks you through your first class step by step.

When both of those feel comfortable, move on.

**Next:** `02-Constructors.md` shows you more powerful ways to build objects.
