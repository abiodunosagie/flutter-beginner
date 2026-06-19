# Classes and Objects: Making Your Own Kind Of Thing

## The Big Idea In One Sentence

> A **class** is a blueprint, and an **object** is a real thing you build from that blueprint.

That is the whole idea. The rest of this lesson just shows you how to write one.

---

## A Picture To Hold In Your Head

Think of a **cookie cutter**.

- The cookie cutter is the **shape**. It is not a cookie. You cannot eat it. It just decides what every cookie will look like.
- The **cookies** are the real things you stamp out with it. You can make 1 cookie or 100. Each cookie is separate, and you can decorate each one differently.

```
   ONE COOKIE CUTTER (class)        MANY COOKIES (objects)
        ┌─────────┐                  🍪  🍪  🍪  🍪
        │  shape  │   stamp out →    each one is real,
        └─────────┘                  each one is separate
```

In code:

- A **class** is the cookie cutter: the plan.
- An **object** is a cookie: a real thing made from the plan.

You can make many objects from one class, just like many cookies from one cutter.

---

## Why We Need This

Say you want to keep track of a dog: its name and its age. With what you know, you might write:

```dart
String dogName = 'Rex';
int dogAge = 4;
```

That is fine for one dog. But for three dogs you get `dogName1`, `dogAge1`, `dogName2`, `dogAge2`... a mess. The name and age of one dog are not joined together in any way.

A **class** fixes this. It bundles the data (name, age) and the actions (bark) into one neat package called a **Dog**. Then each dog you make is one tidy object.

---

## Step 1: Write The Blueprint (The Class)

You start a class with the word `class` and a name. Class names start with a **Capital Letter**.

```dart
class Dog {
  String name;
  int age;
}
```

The two lines inside are the **properties**: the data every dog will have. This says "every Dog has a name and an age."

> This blueprint is not finished yet, so do not run it on its own. We add the missing piece (the constructor) in the next step, and then it works.

---

## Step 2: Add The Constructor (How To Build One)

When you build a real dog, you need to give it an actual name and age. The piece of code that sets this up is called the **constructor**.

A constructor has the **same name as the class**, and no return type:

```dart
class Dog {
  String name;
  int age;

  Dog(this.name, this.age);
}
```

**What is that `this.` in the parentheses?**

`this` means "this dog I am building right now." So `this.name` means "this dog's name property."

Writing `this.name` in the constructor's parentheses is Dart's shortcut for: *"take the value passed in for name and store it in this dog's name property."* It does the same for `age`. So in one short line, the constructor fills in both properties whenever you build a dog.

This `this.` form is what every Dart developer uses. Now you know what it means.

---

## Step 3: Add Methods (The Actions)

Methods are functions that live inside the class. They are the things a dog can **do**. They can use the dog's own properties directly by name.

```dart
class Dog {
  String name;
  int age;

  Dog(this.name, this.age);

  void bark() {
    print('$name says Woof!');
  }

  void haveBirthday() {
    age = age + 1;
    print('$name is now $age');
  }
}
```

That is a complete, useful class. Properties (data), a constructor (setup), and methods (actions). That is all a class is.

---

## Step 4: Build Objects And Use Them

The blueprint does nothing on its own. To use it, you **build an object** by writing the class name and passing in the values the constructor asked for.

```dart
void main() {
  Dog rex = Dog('Rex', 4);
  Dog bella = Dog('Bella', 2);

  // Read a property with a dot:
  print(rex.name);    // Rex
  print(bella.age);   // 2

  // Call a method with a dot and parentheses:
  rex.bark();          // Rex says Woof!
  bella.haveBirthday(); // Bella is now 3
}
```

The **dot** `.` is how you reach inside an object. `rex.name` means "Rex's name." `rex.bark()` means "tell Rex to bark."

You can also use `var` to save typing: `var rex = Dog('Rex', 4);` does the same thing.

---

## Each Object Is Its Own Thing

When you build two objects from the same class, they are **separate**. Changing one does not touch the other.

```dart
void main() {
  Dog rex = Dog('Rex', 4);
  Dog bella = Dog('Bella', 2);

  rex.haveBirthday();   // Rex is now 5

  print(rex.age);    // 5
  print(bella.age);  // 2  <-- Bella is not affected
}
```

Rex and Bella came from the same cookie cutter, but each keeps its own age. Giving Rex a birthday does nothing to Bella.

---

## Why This Matters In Flutter

In Flutter, almost everything is an object built from a class: a button, a screen, a piece of text. When you make your own data (a Product, a User, a Message), you write a class for it, exactly like the `Dog` class above. Master this now and the rest of Flutter feels familiar.

---

## The Top Mistakes Beginners Make

### Mistake 1: Lowercase class name

```dart
class dog { }    // works, but bad style
class Dog { }    // GOOD: class names start with a capital
```

### Mistake 2: Forgetting the values when building

```dart
Dog rex = Dog();          // BAD: the constructor needs a name and age
Dog rex = Dog('Rex', 4);  // GOOD
```

### Mistake 3: Quotes around the property name

```dart
print('rex.name');   // BAD: shows the text "rex.name"
print(rex.name);     // GOOD: shows the value, Rex
```

### Mistake 4: Forgetting the parentheses on a method

```dart
rex.bark;     // does nothing
rex.bark();   // GOOD: actually barks
```

---

## One-Minute Recap

- A **class** is a blueprint (the cookie cutter). An **object** is a real thing built from it (a cookie).
- **Properties** are the data inside (like `name`, `age`).
- The **constructor** (same name as the class) sets up a new object. `this.name` stores the value you pass in.
- **Methods** are the actions (like `bark()`).
- Build an object with `ClassName(...)`, and reach inside it with a dot: `rex.name`, `rex.bark()`.
- Each object keeps its own data. They are separate.

---

## Quick Quiz

**Q1.** What is the difference between a class and an object?

<details>
<summary>Answer</summary>
A class is the blueprint (the cookie cutter). An object is a real thing built from it (a cookie). One class can make many objects.
</details>

**Q2.** In `Dog(this.name, this.age);`, what does `this.name` do?

<details>
<summary>Answer</summary>
It stores the value passed in into this object's `name` property. `this` means "this object." The constructor fills it in for you when you build the object.
</details>

**Q3.** You build `var a = Dog('A', 1);` and `var b = Dog('B', 2);`, then call `a.haveBirthday();`. What is `b.age`?

<details>
<summary>Answer</summary>
`2`. Each object keeps its own data, so giving `a` a birthday does not change `b`.
</details>

**Q4.** How do you tell the dog `rex` to bark?

<details>
<summary>Answer</summary>
`rex.bark();` Use the dot to reach the method, and the parentheses to run it.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Make a Cat class

Write a `Cat` class with two properties: a `String name` and a `String color`. Give it a constructor and a method `void meow()` that prints `<name> says Meow!`. Then in `main`, build a cat named `'Milo'` that is `'gray'` and make it meow.

### Problem 2: Predict the output

```dart
class Counter {
  int count;
  Counter(this.count);

  void increase() {
    count = count + 1;
  }
}

void main() {
  Counter a = Counter(0);
  Counter b = Counter(10);

  a.increase();
  a.increase();
  b.increase();

  print(a.count);
  print(b.count);
}
```

### Problem 3: A Book with a method that uses its data

Write a `Book` class with a `String title`, a `String author`, and an `int pages`. Add a method `void describe()` that prints `<title> by <author>, <pages> pages`. Build a book and call `describe()`.

### Problem 4: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
class Robot {
  String name;
  Robot(this.name);

  void beep() {
    print('$name goes beep');
  }
}

void main() {
  Robot r = Robot();
  print('r.name');
  r.beep();
}
```

### Problem 5: Build a BankAccount

Write a `BankAccount` class with a `String owner` and a `double balance`. Add a method `void deposit(double amount)` that adds the amount to the balance and prints the new balance. Build an account for `'Ada'` starting at `100`, deposit `50`, and see the new balance.

---

## Assignment Answers

### Problem 1: Make a Cat class

```dart
class Cat {
  String name;
  String color;

  Cat(this.name, this.color);

  void meow() {
    print('$name says Meow!');
  }
}

void main() {
  Cat milo = Cat('Milo', 'gray');
  milo.meow();   // Milo says Meow!
}
```

The class has two properties, a constructor that fills them in with `this.`, and one method that uses `name`. Building the object with `Cat('Milo', 'gray')` runs the constructor.

### Problem 2: Predict the output

```
2
11
```

`a` starts at 0 and is increased twice, so it becomes 2. `b` starts at 10 and is increased once, so it becomes 11. They are separate objects, so increasing `a` does not change `b`.

### Problem 3: A Book with a method that uses its data

```dart
class Book {
  String title;
  String author;
  int pages;

  Book(this.title, this.author, this.pages);

  void describe() {
    print('$title by $author, $pages pages');
  }
}

void main() {
  Book hobbit = Book('The Hobbit', 'Tolkien', 310);
  hobbit.describe();   // The Hobbit by Tolkien, 310 pages
}
```

The method `describe()` uses all three properties by name. No need to pass them in again, the method already lives inside the object that owns them.

### Problem 4: Spot the bugs

The two mistakes:

1. `Robot r = Robot();` does not pass a name, but the constructor needs one.
2. `print('r.name')` has quotes, so it shows the text `r.name` instead of the value.

Fixed:

```dart
class Robot {
  String name;
  Robot(this.name);

  void beep() {
    print('$name goes beep');
  }
}

void main() {
  Robot r = Robot('Wall-E');   // pass a name
  print(r.name);               // no quotes, shows the value
  r.beep();
}
```

Output:

```
Wall-E
Wall-E goes beep
```

### Problem 5: Build a BankAccount

```dart
class BankAccount {
  String owner;
  double balance;

  BankAccount(this.owner, this.balance);

  void deposit(double amount) {
    balance = balance + amount;
    print('$owner now has $balance');
  }
}

void main() {
  BankAccount account = BankAccount('Ada', 100);
  account.deposit(50);   // Ada now has 150.0
}
```

The `deposit` method changes the object's own `balance` and prints it. It shows `150.0` because `balance` is a `double`.

---

**Next:** `02-Constructors.md`, where you learn more powerful ways to build objects.
