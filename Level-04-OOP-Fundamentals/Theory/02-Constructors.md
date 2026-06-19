# Constructors: Better Ways To Build Objects

## The Big Idea In One Sentence

> A **constructor** is the setup code that runs when you build an object, and Dart gives you a few handy ways to write it.

You already met the basic constructor in the last lesson. Now you learn the upgrades that make building objects easier and clearer.

---

## Quick Recap: The Basic Constructor

From the last lesson, the basic constructor has the same name as the class and uses the `this.` shortcut to fill in the properties:

```dart
class Dog {
  String name;
  int age;

  Dog(this.name, this.age);   // the constructor
}

void main() {
  var rex = Dog('Rex', 4);    // the constructor runs here
  print(rex.name);            // Rex
}
```

That is the foundation. Everything below builds on it.

---

## Upgrade 1: Default Values

Sometimes a value has a sensible default, and you want the caller to be able to skip it. Put the slot in **square brackets** `[ ]` and give it a default:

```dart
class BankAccount {
  String owner;
  double balance;

  BankAccount(this.owner, [this.balance = 0]);
}

void main() {
  var a = BankAccount('Ada');        // balance defaults to 0
  var b = BankAccount('Bola', 500);  // balance set to 500

  print(a.balance);   // 0.0
  print(b.balance);   // 500.0
}
```

`owner` is required. `balance` is optional and starts at 0 if you do not pass one. (It shows as `0.0` because `balance` is a `double`.) This is the same optional-positional idea you saw with functions in Level 3.

---

## Upgrade 2: Named Parameters (The Flutter Style)

When a class has several properties, passing them in order gets confusing. Was that `true` the active flag, or something else? **Named parameters** fix this by labelling each value.

Wrap the slots in **curly braces** `{ }`, and mark the must-have ones `required`:

```dart
class User {
  String name;
  String email;
  bool isActive;

  User({
    required this.name,
    required this.email,
    this.isActive = true,
  });
}

void main() {
  var u1 = User(name: 'Ada', email: 'ada@mail.com');
  var u2 = User(name: 'Bola', email: 'bola@mail.com', isActive: false);

  print('${u1.name}: active ${u1.isActive}');   // Ada: active true
  print('${u2.name}: active ${u2.isActive}');   // Bola: active false
}
```

Look at the call: `User(name: 'Ada', email: 'ada@mail.com')`. Every value is labelled, so it reads itself. `required` means the caller must supply it. `isActive` has a default, so it can be skipped.

> This is the exact style Flutter uses for every widget. You will write constructors like this constantly, so get comfortable now. It is the same named-parameter idea from the Level 3 Parameters lesson, now used for building objects.

---

## Upgrade 3: Named Constructors (More Than One Way To Build)

Sometimes you want a few different ways to build the same kind of object. Dart lets you add **named constructors**: extra constructors with a label after a dot.

The cleanest way is to have the named constructor call the main one with `: this(...)`:

```dart
class Point {
  double x;
  double y;

  Point(this.x, this.y);          // the main constructor

  Point.origin() : this(0, 0);    // a shortcut for the centre
  Point.square(double size) : this(size, size);
}

void main() {
  var a = Point(3, 4);     // normal
  var b = Point.origin();  // (0, 0)
  var c = Point.square(5); // (5, 5)

  print('${b.x}, ${b.y}');   // 0.0, 0.0
  print('${c.x}, ${c.y}');   // 5.0, 5.0
}
```

`Point.origin()` reads nicely at the call site, and `: this(0, 0)` means "build me by calling the main constructor with 0 and 0." No repeated setup code.

---

## Upgrade 4: A const Constructor (For Values That Never Change)

If an object's values will **never change** after it is built, you can make a `const` constructor. Two small rules: mark every property `final`, and put `const` before the constructor.

```dart
class Coordinate {
  final double lat;
  final double lng;

  const Coordinate(this.lat, this.lng);
}

void main() {
  const home = Coordinate(6.5, 3.3);
  print('${home.lat}, ${home.lng}');   // 6.5, 3.3
}
```

`final` (from Level 1) means the value is set once and locked. A `const` constructor builds a fixed, unchangeable object.

> You do not need this every day yet, but Flutter loves `const` objects because they are fast. You will see `const` widgets everywhere in Level 5. For now, just know it exists and what the two rules are.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting `required` on a named slot

```dart
class User {
  String name;
  User({this.name});   // ERROR: name is not nullable and has no default
}
```

A named slot needs `required`, a default, or a `?`. Fix: `User({required this.name});`.

### Mistake 2: Forgetting the labels when calling a named constructor

```dart
var u = User('Ada', 'ada@mail.com');          // ERROR: needs labels
var u = User(name: 'Ada', email: 'ada@mail.com'); // GOOD
```

If the constructor uses `{ }`, you must label your values.

### Mistake 3: Optional value with no default

```dart
class Box {
  int size;
  Box([this.size]);       // ERROR: needs a default or a ?
}
class Box {
  int size;
  Box([this.size = 0]);   // GOOD
}
```

### Mistake 4: A const constructor with a non-final field

```dart
class C {
  int x;              // not final
  const C(this.x);    // ERROR: const needs all fields final
}
```

For `const`, every property must be `final`.

---

## One-Minute Recap

- A constructor is the setup that runs when you build an object.
- **Default values:** `[this.balance = 0]` makes a slot optional with a fallback.
- **Named parameters:** `{required this.name}` labels each value. This is the Flutter style.
- **Named constructors:** `Point.origin() : this(0, 0);` gives extra ways to build, reusing the main constructor.
- **const constructor:** for objects that never change. Mark fields `final` and add `const`.

---

## Quick Quiz

**Q1.** What does `[this.balance = 0]` do in a constructor?

<details>
<summary>Answer</summary>
It makes `balance` optional with a default of 0. If the caller does not pass a balance, it starts at 0.
</details>

**Q2.** Why is this wrong: `User({this.name})` where `name` is a non-nullable `String`?

<details>
<summary>Answer</summary>
A named slot must be `required`, have a default, or be nullable (`?`). As written, Dart cannot guarantee `name` gets a value. Fix: `User({required this.name})`.
</details>

**Q3.** What does `Point.origin() : this(0, 0);` do?

<details>
<summary>Answer</summary>
It is a named constructor that builds a Point by calling the main constructor with 0 and 0. A handy shortcut for the centre point.
</details>

**Q4.** What two rules must you follow for a `const` constructor?

<details>
<summary>Answer</summary>
Every property must be `final`, and you write `const` before the constructor.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: A class with a default

Write a `Profile` class with a `String name` and a `String role`. Make `role` optional with a default of `'member'`. In `main`, build one profile with just a name and one with a name and role `'admin'`. Print each role.

### Problem 2: Named parameters

Write a `Pizza` class using **named parameters**: a required `String size`, a required `String topping`, and an optional `bool extraCheese` that defaults to `false`. Build a pizza and print whether it has extra cheese.

### Problem 3: Predict the output

```dart
class Box {
  String label;
  int count;

  Box({required this.label, this.count = 1});
}

void main() {
  var a = Box(label: 'Apples');
  var b = Box(label: 'Pens', count: 12);

  print('${a.label}: ${a.count}');
  print('${b.label}: ${b.count}');
}
```

### Problem 4: A named constructor

Write a `Circle` class with a `double radius` and a main constructor. Add a named constructor `Circle.unit()` that builds a circle with radius 1, using `: this(...)`. Build one with `Circle.unit()` and print its radius.

### Problem 5: Spot the bugs

This program has two mistakes. Find and fix them.

```dart
class Student {
  String name;
  int grade;

  Student({this.name, this.grade = 1});
}

void main() {
  var s = Student('Ada', 5);
  print('${s.name}: grade ${s.grade}');
}
```

---

## Assignment Answers

### Problem 1: A class with a default

```dart
class Profile {
  String name;
  String role;

  Profile(this.name, [this.role = 'member']);
}

void main() {
  var a = Profile('Ada');
  var b = Profile('Bola', 'admin');

  print(a.role);   // member
  print(b.role);   // admin
}
```

`role` is in square brackets with a default, so it is optional. The first profile skips it and gets `'member'`; the second overrides it with `'admin'`.

### Problem 2: Named parameters

```dart
class Pizza {
  String size;
  String topping;
  bool extraCheese;

  Pizza({
    required this.size,
    required this.topping,
    this.extraCheese = false,
  });
}

void main() {
  var p = Pizza(size: 'large', topping: 'mushroom', extraCheese: true);
  print('Extra cheese: ${p.extraCheese}');   // Extra cheese: true
}
```

`size` and `topping` are `required`. `extraCheese` has a default of `false`, so it can be skipped. The labels make the call easy to read.

### Problem 3: Predict the output

```
Apples: 1
Pens: 12
```

`a` skips `count`, so it uses the default `1`. `b` passes `count: 12`. Both pass the required `label`.

### Problem 4: A named constructor

```dart
class Circle {
  double radius;

  Circle(this.radius);

  Circle.unit() : this(1);
}

void main() {
  var c = Circle.unit();
  print(c.radius);   // 1.0
}
```

`Circle.unit()` calls the main constructor with `1` using `: this(1)`. So it builds a circle with radius 1 without repeating any setup. It prints `1.0` because `radius` is a `double`.

### Problem 5: Spot the bugs

The two mistakes:

1. `Student({this.name, ...})` makes `name` a named slot, but `name` is non-nullable with no default. It must be `required`.
2. `Student('Ada', 5)` calls it with positional values, but the constructor uses named slots, so the values need labels.

Fixed:

```dart
class Student {
  String name;
  int grade;

  Student({required this.name, this.grade = 1});
}

void main() {
  var s = Student(name: 'Ada', grade: 5);
  print('${s.name}: grade ${s.grade}');   // Ada: grade 5
}
```

We added `required` to `name`, and used labels (`name:`, `grade:`) when building.

---

**Next:** `03-Encapsulation.md`, where you learn how to protect an object's data from being changed in the wrong way.
