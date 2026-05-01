# Part 3: Using Variables

Now that you can create variables of different types, let's learn how to USE them!

---

## Printing Variables

### Basic Printing

```dart
void main() {
  String name = 'Alex';
  int age = 25;

  print(name);  // Output: Alex
  print(age);   // Output: 25
}
```

### String Interpolation (The Cool Way!)

To include variables in strings, use `$`:

```dart
String name = 'Alex';
int age = 25;

print('My name is $name');        // My name is Alex
print('I am $age years old');     // I am 25 years old
```

For expressions (calculations), use `${}`:

```dart
int age = 25;
print('Next year: ${age + 1}');  // Next year: 26

String name = 'alex';
print('Name: ${name.toUpperCase()}');  // Name: ALEX
```

---

## Using Variables in Calculations

```dart
void main() {
  int a = 10;
  int b = 5;

  int sum = a + b;
  int difference = a - b;
  int product = a * b;

  print('Sum: $sum');          // Sum: 15
  print('Difference: $difference');  // Difference: 5
  print('Product: $product');   // Product: 50
}
```

---

## Changing Values

Variables can be reassigned to new values:

```dart
void main() {
  int score = 0;
  print(score);  // Output: 0

  score = 10;
  print(score);  // Output: 10

  score = 25;
  print(score);  // Output: 25
}
```

---

## Practical Examples

### Example 1: Shopping Cart

```dart
void main() {
  String product = 'Laptop';
  double price = 999.99;
  int quantity = 2;

  double total = price * quantity;

  print('Product: $product');
  print('Price: \$$price');
  print('Quantity: $quantity');
  print('Total: \$$total');
}
```

### Example 2: User Info

```dart
void main() {
  String username = 'alex_dev';
  String email = 'alex@example.com';
  int age = 28;
  bool isPremium = true;

  print('Username: $username');
  print('Email: $email');
  print('Age: $age');
  print('Premium: $isPremium');
}
```

### Example 3: Temperature Converter

```dart
void main() {
  double celsius = 25.0;
  double fahrenheit = (celsius * 9/5) + 32;

  print('$celsius°C = $fahrenheit°F');
}
```

---

## Variable Naming Rules

### Must Follow (Syntax Rules)

```dart
// ✅ Valid names
String name;
String firstName;
String first_name;
String _private;
String name1;

// ❌ Invalid names
String 1name;      // Can't start with number
String first-name; // Can't use hyphen
String first name; // Can't have spaces
String class;      // Can't use reserved words
```

### Should Follow (Best Practices)

```dart
// ✅ Good - camelCase
String firstName;
int userAge;
bool isLoggedIn;
double accountBalance;

// ❌ Bad - hard to read
String firstname;
String FIRSTNAME;
String First_Name;
```

**Convention:** Use `camelCase` - first word lowercase, subsequent words capitalized.

### Meaningful Names

```dart
// ❌ Bad - unclear
int x = 25;
String s = 'Alex';
bool b = true;

// ✅ Good - clear purpose
int userAge = 25;
String userName = 'Alex';
bool isSubscribed = true;
```

---

## Practice Exercise

Create a program that calculates the area of a rectangle:
1. Create width (int)
2. Create height (int)
3. Calculate area = width * height
4. Print the result

Example:
```
Width: 10
Height: 5
Area: 50
```

---

## Quick Quiz

**Q1:** What does this print?
```dart
var x = 10;
x = 20;
print(x);
```

<details>
<summary>Answer</summary>
`20` - Variables can be reassigned to new values of the same type.
</details>

**Q2:** How do you include a variable in a string?

<details>
<summary>Answer</summary>
Use `$variableName` like: `print('Hello $name');`
</details>

**Q3:** What's wrong with `String 1st = 'first';`?

<details>
<summary>Answer</summary>
Variable names can't start with a number. Should be `String first = 'first';`
</details>

---

## Assignment

### Problem 1: Receipt printer

You are building a checkout receipt. Declare these variables, then print a receipt that uses string interpolation:

- `String storeName = 'Evvy Hairs'`
- `String customer = 'Ada'`
- `int items = 3`
- `double total = 24500.50`

Output should look like:
```
Welcome to Evvy Hairs
Customer: Ada
You purchased 3 items
Total: 24500.5 naira
```

### Problem 2: Predict the output

```dart
void main() {
  int a = 10;
  int b = 3;

  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a * b = ${a * b}');
  print('a / b = ${a / b}');
  print('a ~/ b = ${a ~/ b}');
  print('a % b = ${a % b}');
}
```

### Problem 3: BMI calculator

Write a program that calculates a person's BMI given their weight in kg and height in metres. Use this formula:

```
BMI = weight / (height * height)
```

Use `double` variables. Print the result rounded to 1 decimal place using `.toStringAsFixed(1)`.

Test with `weight = 70.0` and `height = 1.75`. Expected BMI: 22.9.

### Problem 4: Combine and reassign

What is the value of `result` at the end?

```dart
void main() {
  int x = 5;
  int y = 10;
  String result = '';

  result = result + 'x is $x';
  result = result + ', ';
  result = result + 'y is $y';
  result = result + ', sum is ${x + y}';

  print(result);
}
```

### Problem 5: Total cost with tax

Given:

```dart
double itemPrice = 1500;
int quantity = 4;
double taxRate = 0.075;
```

Calculate and print:
- The subtotal (price * quantity).
- The tax amount (subtotal * taxRate).
- The grand total (subtotal + tax).

All amounts should be formatted to 2 decimal places.

---

## Assignment Answers

### Problem 1: Receipt printer

```dart
void main() {
  String storeName = 'Evvy Hairs';
  String customer = 'Ada';
  int items = 3;
  double total = 24500.50;

  print('Welcome to $storeName');
  print('Customer: $customer');
  print('You purchased $items items');
  print('Total: $total naira');
}
```

The trick: each `print` uses `$variableName` to drop the value into the string. No `+` needed for joining. This is one of the best things about Dart strings.

Note about the total: when you assign `24500.50`, Dart drops the trailing zero and stores `24500.5`. That is just how doubles work. To force two decimals on display, use `total.toStringAsFixed(2)`. We will see this in problem 5.

### Problem 2: Predict the output

```
a + b = 13
a - b = 7
a * b = 30
a / b = 3.3333333333333335
a ~/ b = 3
a % b = 1
```

How each operation works:

- `+`, `-`, `*` are familiar. Result types: int + int = int.
- `/` always returns a double, even for whole-number division. `10 / 3` is `3.333...`.
- `~/` is integer division. The decimal part is dropped, not rounded. So `10 ~/ 3` is `3`, not `3.33`.
- `%` is the remainder. After dividing 10 by 3, the remainder is 1.

The `~/` and `%` are the most useful "less obvious" operators. You will use `%` to test even/odd: `n % 2 == 0` means n is even.

### Problem 3: BMI calculator

```dart
void main() {
  double weight = 70.0;
  double height = 1.75;

  double bmi = weight / (height * height);

  print('BMI: ${bmi.toStringAsFixed(1)}');     // BMI: 22.9
}
```

How this works:

1. Calculate `height * height` (squared).
2. Divide weight by that. Both are doubles, so the result is a double.
3. `toStringAsFixed(1)` rounds the double to 1 decimal place and returns a String.

For weight 70 and height 1.75:
- 1.75 * 1.75 = 3.0625
- 70 / 3.0625 = 22.857...
- Rounded to 1 decimal: 22.9.

### Problem 4: Combine and reassign

`result` ends up as:

```
x is 5, y is 10, sum is 15
```

Trace:

| Line | result after |
|------|--------------|
| start | '' |
| `result + 'x is $x'` | 'x is 5' |
| `result + ', '` | 'x is 5, ' |
| `result + 'y is $y'` | 'x is 5, y is 10' |
| `result + ', sum is ${x + y}'` | 'x is 5, y is 10, sum is 15' |

The lesson: strings can be added with `+`. Each line takes the current string, appends new text, and assigns back. Step by step, the string grows. Interpolation `${x + y}` evaluates the expression inside `{ }` and inserts the result.

In real code you would build this string in one step:

```dart
String result = 'x is $x, y is $y, sum is ${x + y}';
```

The exercise is meant to show how reassignment accumulates.

### Problem 5: Total cost with tax

```dart
void main() {
  double itemPrice = 1500;
  int quantity = 4;
  double taxRate = 0.075;

  double subtotal = itemPrice * quantity;
  double tax = subtotal * taxRate;
  double grandTotal = subtotal + tax;

  print('Subtotal: ${subtotal.toStringAsFixed(2)}');
  print('Tax (7.5%): ${tax.toStringAsFixed(2)}');
  print('Grand total: ${grandTotal.toStringAsFixed(2)}');
}
```

Output:
```
Subtotal: 6000.00
Tax (7.5%): 450.00
Grand total: 6450.00
```

How each value is computed:

- subtotal = 1500 * 4 = 6000
- tax = 6000 * 0.075 = 450
- grand total = 6000 + 450 = 6450

`toStringAsFixed(2)` ensures every amount shows exactly two decimal places, even when the math gives a whole number. This is the standard format for currency.

---

**Next:** Learn about advanced variable concepts like `var`, `final`, and `const`!

**Continue to:** `02d-VarFinalConst.md`
