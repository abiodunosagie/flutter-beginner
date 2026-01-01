# Operators: Doing Things with Data

## What Is an Operator?

An **operator** is a symbol that tells Dart to do something with values.

You already know some:
- `+` adds numbers
- `-` subtracts numbers
- `=` assigns values

Let's see all the operators you'll use.

---

## Arithmetic Operators

These do math. There are 6 arithmetic operators:

| Operator | Name | What It Does |
|----------|------|--------------|
| `+` | Addition | Adds two numbers together |
| `-` | Subtraction | Takes one number away from another |
| `*` | Multiplication | Multiplies two numbers |
| `/` | Division | Divides one number by another (gives decimal) |
| `~/` | Integer Division | Divides but throws away the decimal part |
| `%` | Modulo | Gives the remainder after division |

```dart
int a = 10;
int b = 3;

print(a + b);   // 13  Addition
print(a - b);   // 7   Subtraction
print(a * b);   // 30  Multiplication
print(a / b);   // 3.33... Division (always double!)
print(a ~/ b);  // 3   Integer division (whole number only)
print(a % b);   // 1   Remainder (modulo)
```

### Important Notes:

**Division `/` always returns a double:**
```dart
print(10 / 2);   // 5.0, not 5!
print(10 / 3);   // 3.333...
```

**Integer division `~/` drops decimals:**
```dart
print(10 ~/ 3);  // 3 (the .333 is thrown away)
print(7 ~/ 2);   // 3 (the .5 is thrown away)
```

**Modulo `%` gives the remainder:**
```dart
// Think: 10 divided by 3 is 3 with 1 left over
// 3 × 3 = 9, and 10 - 9 = 1
print(10 % 3);  // 1

// Useful for checking even/odd:
print(4 % 2);   // 0 (even numbers have no remainder)
print(5 % 2);   // 1 (odd numbers have remainder of 1)
```

### Visual Example

```
10 + 3 = 13    (add)
10 - 3 = 7     (subtract)
10 * 3 = 30    (multiply)
10 / 3 = 3.33  (divide)
10 ~/ 3 = 3    (divide, drop decimal)
10 % 3 = 1     (remainder: 10 = 3×3 + 1)
```

---

## Assignment Operators

These put values into variables.

### Basic Assignment

```dart
int x = 10;  // x is now 10
```

### Compound Assignment

Shortcuts that do math AND assign:

```dart
int x = 10;

x += 5;   // Same as: x = x + 5   → x is 15
x -= 3;   // Same as: x = x - 3   → x is 12
x *= 2;   // Same as: x = x * 2   → x is 24
x ~/= 4;  // Same as: x = x ~/ 4  → x is 6
```

### Increment and Decrement

The fastest way to add or subtract 1:

```dart
int count = 0;

count++;  // count is now 1 (add 1)
count++;  // count is now 2
count--;  // count is now 1 (subtract 1)
```

---

## Comparison Operators

These compare values and give back `true` or `false`.

```dart
int a = 5;
int b = 3;

print(a == b);   // false  (equal?)
print(a != b);   // true   (not equal?)
print(a > b);    // true   (greater?)
print(a < b);    // false  (less?)
print(a >= b);   // true   (greater or equal?)
print(a <= b);   // false  (less or equal?)
```

### Visual Guide

```
==   "Is equal to?"        5 == 5  → true
!=   "Is not equal to?"    5 != 3  → true
>    "Is greater than?"    5 > 3   → true
<    "Is less than?"       5 < 3   → false
>=   "Is greater or equal?"5 >= 5  → true
<=   "Is less or equal?"   5 <= 3  → false
```

### Common Mistake: `=` vs `==`

This is a very common beginner mistake!

```dart
int x = 5;       // = is ASSIGNMENT (putting a value in)
bool check = (x == 5);  // == is COMPARISON (asking a question)
```

- `=` means "put this value into the variable"
- `==` means "are these two things equal?"

```dart
// WRONG: This tries to assign, not compare!
// if (x = 5)  // Error!

// RIGHT: This compares
if (x == 5) {
  print('x is five!');
}
```

---

## Logical Operators

These combine boolean values to make decisions.

```dart
bool a = true;
bool b = false;

print(a && b);  // false  (AND: both must be true)
print(a || b);  // true   (OR: at least one true)
print(!a);      // false  (NOT: flip the value)
```

### Simple Rules

```
AND (&&): true only if BOTH are true
OR  (||): true if AT LEAST ONE is true
NOT (!):  flips true↔false
```

### AND (&&) Truth Table

Both sides MUST be true for the result to be true:

```dart
true  && true   // true  (both true? YES)
true  && false  // false (both true? NO)
false && true   // false (both true? NO)
false && false  // false (both true? NO)
```

Example:
```dart
int age = 25;
bool hasLicense = true;

// Can drive only if BOTH conditions are met
bool canDrive = age >= 18 && hasLicense;
print(canDrive);  // true
```

### OR (||) Truth Table

At least ONE side must be true for the result to be true:

```dart
true  || true   // true  (at least one true? YES)
true  || false  // true  (at least one true? YES)
false || true   // true  (at least one true? YES)
false || false  // false (at least one true? NO)
```

Example:
```dart
bool isWeekend = true;
bool isHoliday = false;

// Day off if EITHER is true
bool dayOff = isWeekend || isHoliday;
print(dayOff);  // true
```

### NOT (!) Operator

Flips the boolean value:

```dart
bool isSunny = true;
print(!isSunny);  // false (flip true to false)

bool isRaining = false;
print(!isRaining);  // true (flip false to true)
```

---

## String Operators

### Concatenation with +

```dart
String first = 'Hello';
String second = 'World';
String combined = first + ' ' + second;  // 'Hello World'
```

### Better: Interpolation

```dart
String name = 'Alex';
int age = 25;

String message = 'Name: $name, Age: $age';
// 'Name: Alex, Age: 25'
```

---

## Null-Aware Operators

These help with values that might be `null` (empty/nothing).

### What is null?

`null` means "no value" or "nothing". It's different from 0 or an empty string.

```dart
String? name = null;  // name has NO value
String name2 = '';    // name2 has a value (empty string)
int? count = null;    // count has NO value
int count2 = 0;       // count2 has a value (zero)
```

### ?? (If Null)

"Use the left value, unless it's null, then use the right value."

Think of it as a backup plan:

```dart
String? name = null;
String displayName = name ?? 'Guest';
print(displayName);  // 'Guest' (name was null, so use backup)

String? name2 = 'Alex';
String displayName2 = name2 ?? 'Guest';
print(displayName2);  // 'Alex' (name2 has value, no need for backup)
```

More examples:
```dart
int? savedScore = null;
int score = savedScore ?? 0;  // Use 0 if no saved score

String? userTheme = null;
String theme = userTheme ?? 'light';  // Default to 'light' theme
```

### ??= (Assign If Null)

"Only assign if the variable is currently null."

```dart
String? name;           // Currently null
name ??= 'Default';     // IS null, so assign 'Default'
print(name);            // 'Default'

name ??= 'Other';       // NOT null anymore, so DON'T assign
print(name);            // Still 'Default'
```

This is useful for setting default values only once:
```dart
int? userScore;
userScore ??= 100;  // Set initial score
userScore ??= 200;  // Won't change, already has a value
print(userScore);   // 100
```

---

## Conditional Operator (Ternary)

A short way to choose between two values. Called "ternary" because it has 3 parts.

**Format:**
```dart
condition ? valueIfTrue : valueIfFalse
```

**How to read it:**
1. First, check the condition
2. If true, use the value after `?`
3. If false, use the value after `:`

```dart
int age = 20;
String status = age >= 18 ? 'Adult' : 'Minor';
print(status);  // 'Adult'
```

It's like asking a question:
```
Is age >= 18?
  Yes → 'Adult'
  No  → 'Minor'
```

### Step by Step Example

```dart
int score = 75;
String result = score >= 60 ? 'Pass' : 'Fail';

// Step 1: Is score >= 60?
// Step 2: 75 >= 60 is TRUE
// Step 3: Since true, use 'Pass'
// Result: result = 'Pass'
```

### More Examples

```dart
int score = 85;
String grade = score >= 60 ? 'Pass' : 'Fail';  // 'Pass'

bool isLoggedIn = true;
String message = isLoggedIn ? 'Welcome!' : 'Please log in';  // 'Welcome!'

int a = 10;
int b = 20;
int bigger = a > b ? a : b;  // 20 (because 10 > 20 is false, use b)
```

### Ternary vs If-Else

The ternary operator is a shortcut for simple if-else statements:

```dart
// Using if-else (longer)
String status;
if (age >= 18) {
  status = 'Adult';
} else {
  status = 'Minor';
}

// Using ternary (shorter, same result)
String status = age >= 18 ? 'Adult' : 'Minor';
```

Use ternary for simple choices. Use if-else for complex logic.

---

## Operator Precedence

When there are multiple operators, Dart follows an order (like math class):

**High to Low Priority:**
1. `()` Parentheses
2. `!` `-` (unary)
3. `*` `/` `~/` `%`
4. `+` `-`
5. `<` `>` `<=` `>=`
6. `==` `!=`
7. `&&`
8. `||`
9. `??`
10. `=` `+=` etc.

### Example

```dart
int result = 2 + 3 * 4;  // 14, not 20
// Multiplication happens first: 3 * 4 = 12
// Then addition: 2 + 12 = 14

int result2 = (2 + 3) * 4;  // 20
// Parentheses first: 2 + 3 = 5
// Then multiplication: 5 * 4 = 20
```

**Tip:** When in doubt, use parentheses to make it clear!

---

## Practical Examples

### Example 1: Calculate Total Price

```dart
void main() {
  double price = 29.99;
  int quantity = 3;
  double taxRate = 0.08;

  double subtotal = price * quantity;
  double tax = subtotal * taxRate;
  double total = subtotal + tax;

  print('Subtotal: \$${subtotal.toStringAsFixed(2)}');
  print('Tax: \$${tax.toStringAsFixed(2)}');
  print('Total: \$${total.toStringAsFixed(2)}');
}
```

### Example 2: Check Age Range

```dart
void main() {
  int age = 25;

  bool isTeenager = age >= 13 && age <= 19;
  bool isAdult = age >= 18;
  bool isSenior = age >= 65;

  print('Teenager: $isTeenager');
  print('Adult: $isAdult');
  print('Senior: $isSenior');
}
```

### Example 3: Grade Calculator

```dart
void main() {
  int score = 85;

  String grade = score >= 90 ? 'A' :
                 score >= 80 ? 'B' :
                 score >= 70 ? 'C' :
                 score >= 60 ? 'D' : 'F';

  print('Score: $score, Grade: $grade');
}
```

---

## Summary

### All Operators at a Glance

```dart
// Arithmetic
+   -   *   /   ~/   %

// Assignment
=   +=   -=   *=   /=   ~/=

// Increment/Decrement
++   --

// Comparison
==   !=   >   <   >=   <=

// Logical
&&   ||   !

// Null-aware
??   ??=

// Conditional (Ternary)
condition ? ifTrue : ifFalse
```

---

## Quick Quiz

**Q1:** What is `10 % 3`?

<details>
<summary>Answer</summary>
`1` - the remainder when 10 is divided by 3.
</details>

**Q2:** What does `x += 5` do?

<details>
<summary>Answer</summary>
Adds 5 to x. Same as `x = x + 5`.
</details>

**Q3:** What is `null ?? 'default'`?

<details>
<summary>Answer</summary>
`'default'` - the `??` operator returns the right side if the left is null.
</details>

**Q4:** What is `5 > 3 ? 'yes' : 'no'`?

<details>
<summary>Answer</summary>
`'yes'` - because 5 > 3 is true.
</details>

---

**Congratulations!** You've completed all the theory for Level 1!

Now it's time to practice with the Examples and Exercises.

---

**Continue to:** `../Examples/Example01-HelloWorld.dart`
