# Part 1: Understanding Variables

## What Is a Variable?

A **variable** is a container that holds a piece of information. Think of it as a labeled box where you store something.

```
┌─────────────┐
│    "Alex"   │  ← The value inside
├─────────────┤
│    name     │  ← The label (variable name)
└─────────────┘
```

In real life:
- A **name tag** holds your name
- A **wallet** holds your money
- A **phone contact** holds a phone number

In programming:
- A **variable** holds data (text, numbers, true/false, etc.)

---

## Creating Your First Variable

### The Basic Pattern

```dart
type name = value;
```

- **type** - What kind of data it holds
- **name** - What you call it
- **value** - What's inside

### Your First String Variable

```dart
String name = 'Alex';
```

Let's break this down:
- `String` = This variable holds text
- `name` = We're calling this variable "name"
- `=` = Assignment operator (puts value into variable)
- `'Alex'` = The actual text we're storing
- `;` = End of statement

### Try It!

```dart
void main() {
  String name = 'Alex';
  print(name);  // Output: Alex
}
```

---

## Changing Variable Values

Variables can change (that's why they're called "variables"):

```dart
void main() {
  String favoriteColor = 'blue';
  print(favoriteColor);  // Output: blue

  favoriteColor = 'red';
  print(favoriteColor);  // Output: red
}
```

---

## Practice Exercise

Create three String variables:
1. Your name
2. Your favorite food
3. Your city

Print all three.

---

## Assignment

### Problem 1: Predict the output

What does this print?

```dart
void main() {
  String name = 'Ada';
  int age = 25;
  double height = 1.65;
  bool isStudent = true;

  print('$name is $age years old');
  print('Height: $height m, Student: $isStudent');
}
```

### Problem 2: Build a personal profile

Declare four variables that describe yourself: a `String` name, an `int` age, a `double` height in metres, and a `bool` `isLearningFlutter`. Then print a one-line summary using string interpolation.

### Problem 3: Spot the bugs

Each line below has a problem. Find it and fix it.

```dart
int price = 19.99;
String 1stName = 'Ada';
bool active = "true";
double age = 25;
```

### Problem 4: Variable swap (without a third variable)

You have two int variables `a = 10` and `b = 20`. Swap their values so that `a` becomes 20 and `b` becomes 10. Do not declare a third variable. Use only addition and subtraction.

### Problem 5: Reassignment trace

Predict the value of `x` at the end of this program. Walk through it step by step.

```dart
void main() {
  int x = 5;
  x = x + 3;
  x = x * 2;
  x = x - 1;
  print(x);
}
```

---

## Assignment Answers

### Problem 1: Predict the output

```
Ada is 25 years old
Height: 1.65 m, Student: true
```

How interpolation works:

- `$name` is replaced by the value of `name`, which is `'Ada'`.
- `$age` becomes `25`.
- `$height` becomes `1.65` (a double prints with its decimal).
- `$isStudent` becomes `true` (a bool prints as the word `true` or `false`).

The literal text outside the `$...` parts stays the same.

### Problem 2: Build a personal profile

Example answer:

```dart
void main() {
  String name = 'Ada';
  int age = 25;
  double height = 1.65;
  bool isLearningFlutter = true;

  print('$name is $age, $height m tall, learning Flutter: $isLearningFlutter');
}
```

Output: `Ada is 25, 1.65 m tall, learning Flutter: true`.

The lesson: each type has a specific keyword (`String`, `int`, `double`, `bool`) and the value must match the type. You cannot put a number in a `String` variable.

### Problem 3: Spot the bugs

```dart
double price = 19.99;          // int can only hold whole numbers, 19.99 is a decimal
String firstName = 'Ada';      // names cannot start with a digit
bool active = true;            // bool needs true/false, not the string "true"
double age = 25;               // 25 is an int. Either change type to int OR write 25.0
```

Notes on the last one: `double age = 25;` is actually accepted by Dart in this context because Dart will convert `25` to `25.0`. But conceptually it is misleading. If you mean a whole number, use `int`. If you really mean a decimal, write `25.0`.

The first three are real compile errors. The fourth is a style issue rather than a bug, but worth flagging.

### Problem 4: Variable swap

```dart
int a = 10;
int b = 20;

a = a + b;     // a is now 30
b = a - b;     // b is now 30 - 20 = 10
a = a - b;     // a is now 30 - 10 = 20

print('a = $a, b = $b');     // a = 20, b = 10
```

How the trick works:

1. After `a = a + b`, `a` holds the sum (30). `b` is still its original value.
2. To get `b` to be the original value of `a`, subtract `b` (its original value) from the sum: `30 - 20 = 10`. Now `b` is 10 (which was originally `a`).
3. To get `a` to be the original value of `b`, subtract the new `b` from the sum: `30 - 10 = 20`. Now `a` is 20 (which was originally `b`).

This trick is mostly for fun and to test understanding of order of operations. In real code, the simple version with a temporary is fine and clearer:

```dart
int temp = a;
a = b;
b = temp;
```

### Problem 5: Reassignment trace

```
15
```

Trace:

| Line | What happens | x after |
|------|--------------|---------|
| `int x = 5` | declare and assign | 5 |
| `x = x + 3` | x becomes 5 + 3 | 8 |
| `x = x * 2` | x becomes 8 * 2 | 16 |
| `x = x - 1` | x becomes 16 - 1 | 15 |

The print at the end shows 15.

The key idea: `x = x + 3` is not "x equals x plus 3", which would be a contradiction. It is "take the current value of x, add 3 to it, store the result back in x". The right side is computed first using the old value, then assigned.

---

**Next:** Learn about different types of data you can store!

**Continue to:** `02b-DataTypes.md`
