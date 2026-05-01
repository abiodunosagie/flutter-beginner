# Working with Numbers

## Number Types in Dart

Dart has two main number types:

### int - Integers (Whole Numbers)

```dart
int age = 25;
int year = 2024;
int count = 0;
int negative = -100;
int million = 1000000;
```

**Integers** have no decimal points. They can be positive, negative, or zero.

### double - Floating-Point (Decimal Numbers)

```dart
double price = 19.99;
double pi = 3.14159;
double temperature = 98.6;
double negative = -273.15;
double whole = 42.0;  // Still a double
```

**Doubles** can have decimal points. They're called "floating-point" because the decimal point can "float" to different positions.

### num - Parent Type

Both `int` and `double` are subtypes of `num`:

```dart
num value1 = 42;      // Can be int
num value2 = 3.14;    // Can be double

// Useful when you don't care which type
num calculate(num a, num b) {
  return a + b;
}
```

---

## Visual Comparison

```
┌─────────────────────────────────────────────┐
│                  NUMBERS                     │
├─────────────────────────────────────────────┤
│                                             │
│   int (integers)                            │
│   ├── 0, 1, 2, 3, ...                      │
│   ├── -1, -2, -3, ...                      │
│   └── No decimal point                      │
│                                             │
│   double (floating-point)                   │
│   ├── 0.0, 1.5, 3.14, ...                  │
│   ├── -0.5, -273.15, ...                   │
│   └── Has decimal point (or can have)       │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Arithmetic Operators

### Basic Operations

```dart
int a = 10;
int b = 3;

print(a + b);   // 13  (Addition)
print(a - b);   // 7   (Subtraction)
print(a * b);   // 30  (Multiplication)
print(a / b);   // 3.333...  (Division - always returns double!)
print(a ~/ b);  // 3   (Integer division - truncates decimal)
print(a % b);   // 1   (Modulo - remainder after division)
```

### Important: Division Always Returns double

```dart
int x = 10;
int y = 2;

var result = x / y;  // result is 5.0 (double), not 5 (int)

// To get int result, use integer division
int intResult = x ~/ y;  // 5
```

### Modulo (Remainder)

The `%` operator gives the remainder after division:

```dart
print(10 % 3);  // 1  (10 = 3*3 + 1)
print(15 % 5);  // 0  (15 = 5*3 + 0)
print(7 % 2);   // 1  (7 = 2*3 + 1)
```

**Common use:** Check if a number is even or odd:

```dart
int number = 42;

if (number % 2 == 0) {
  print('Even');
} else {
  print('Odd');
}
```

---

## Compound Assignment Operators

Shortcuts for common operations:

```dart
int x = 10;

x += 5;   // Same as: x = x + 5;  (x is now 15)
x -= 3;   // Same as: x = x - 3;  (x is now 12)
x *= 2;   // Same as: x = x * 2;  (x is now 24)
x ~/= 4;  // Same as: x = x ~/ 4; (x is now 6)
x %= 4;   // Same as: x = x % 4;  (x is now 2)
```

### Increment and Decrement

```dart
int count = 0;

count++;  // Same as: count = count + 1; (count is now 1)
count--;  // Same as: count = count - 1; (count is now 0)

// Pre vs Post increment
int a = 5;
print(a++);  // Prints 5, then a becomes 6
print(++a);  // a becomes 7, then prints 7
```

---

## Number Methods and Properties

### Useful int Properties

```dart
int x = -42;

print(x.isEven);      // false
print(x.isOdd);       // true
print(x.isNegative);  // true
print(x.abs());       // 42 (absolute value)
print(x.sign);        // -1 (-1, 0, or 1)
```

### Useful double Methods

```dart
double pi = 3.14159;

print(pi.round());         // 3 (rounds to nearest int)
print(pi.floor());         // 3 (rounds down)
print(pi.ceil());          // 4 (rounds up)
print(pi.truncate());      // 3 (removes decimal part)
print(pi.toStringAsFixed(2));  // "3.14" (2 decimal places)
```

### Rounding Comparison

```dart
double value = 3.7;

print(value.round());     // 4 (nearest)
print(value.floor());     // 3 (down)
print(value.ceil());      // 4 (up)
print(value.truncate());  // 3 (cut off)

double negative = -3.7;

print(negative.round());     // -4
print(negative.floor());     // -4
print(negative.ceil());      // -3
print(negative.truncate());  // -3
```

---

## Type Conversion

### String to Number

```dart
// String to int
String ageText = '25';
int age = int.parse(ageText);
print(age);  // 25

// String to double
String priceText = '19.99';
double price = double.parse(priceText);
print(price);  // 19.99
```

### Safe Parsing (Handle Errors)

```dart
String input = 'not a number';

// This would crash:
// int value = int.parse(input);  // Error!

// Safe way:
int? value = int.tryParse(input);
print(value);  // null (no crash)

// With default value:
int safeValue = int.tryParse(input) ?? 0;
print(safeValue);  // 0
```

### Number to String

```dart
int age = 25;
double price = 19.99;

String ageText = age.toString();      // '25'
String priceText = price.toString();  // '19.99'

// Or use interpolation
String message = 'Age: $age';  // 'Age: 25'
```

### int to double and vice versa

```dart
int whole = 42;
double decimal = whole.toDouble();  // 42.0

double pi = 3.14;
int truncated = pi.toInt();  // 3 (decimal removed)
int rounded = pi.round();    // 3 (rounded)
```

---

## The dart:math Library

For advanced math operations, import the math library:

```dart
import 'dart:math';

void main() {
  // Constants
  print(pi);   // 3.141592653589793
  print(e);    // 2.718281828459045

  // Power
  print(pow(2, 3));  // 8 (2³)
  print(pow(10, 2)); // 100 (10²)

  // Square root
  print(sqrt(16));   // 4.0
  print(sqrt(2));    // 1.4142135623730951

  // Min and Max
  print(min(5, 3));  // 3
  print(max(5, 3));  // 5

  // Trigonometry (radians)
  print(sin(pi / 2));  // 1.0
  print(cos(0));       // 1.0

  // Logarithms
  print(log(e));       // 1.0
}
```

### Random Numbers

```dart
import 'dart:math';

void main() {
  Random random = Random();

  // Random double between 0.0 and 1.0
  print(random.nextDouble());

  // Random int from 0 to max-1
  print(random.nextInt(100));  // 0 to 99

  // Random bool
  print(random.nextBool());  // true or false

  // Random in range (e.g., 1 to 6 for dice)
  int dice = random.nextInt(6) + 1;
  print('Dice: $dice');
}
```

---

## Practical Examples

### Example 1: Temperature Converter

```dart
void main() {
  double celsius = 25.0;

  // Celsius to Fahrenheit
  double fahrenheit = (celsius * 9/5) + 32;
  print('$celsius°C = $fahrenheit°F');

  // Fahrenheit to Celsius
  double f = 98.6;
  double c = (f - 32) * 5/9;
  print('$f°F = ${c.toStringAsFixed(1)}°C');
}
```

### Example 2: Calculate Average

```dart
void main() {
  int score1 = 85;
  int score2 = 92;
  int score3 = 78;
  int score4 = 90;

  double average = (score1 + score2 + score3 + score4) / 4;

  print('Average: ${average.toStringAsFixed(1)}');  // Average: 86.3
}
```

### Example 3: Simple Interest Calculator

```dart
void main() {
  double principal = 1000.0;
  double rate = 5.0;  // 5%
  int years = 3;

  double interest = principal * rate * years / 100;
  double total = principal + interest;

  print('Principal: \$$principal');
  print('Interest: \$$interest');
  print('Total after $years years: \$$total');
}
```

### Example 4: BMI Calculator

```dart
void main() {
  double weightKg = 70.0;
  double heightM = 1.75;

  double bmi = weightKg / (heightM * heightM);

  print('BMI: ${bmi.toStringAsFixed(1)}');

  if (bmi < 18.5) {
    print('Underweight');
  } else if (bmi < 25) {
    print('Normal weight');
  } else if (bmi < 30) {
    print('Overweight');
  } else {
    print('Obese');
  }
}
```

### Example 5: Currency Formatter

```dart
void main() {
  double price = 1234567.89;

  // Format with 2 decimal places
  String formatted = price.toStringAsFixed(2);
  print('Price: \$$formatted');

  // Add thousand separators (manual approach)
  int dollars = price.floor();
  int cents = ((price - dollars) * 100).round();

  print('Dollars: $dollars, Cents: $cents');
}
```

---

## Number Limits

### Integer Limits

On native platforms (mobile, desktop):
```dart
print(9223372036854775807);   // Max int (64-bit)
print(-9223372036854775808);  // Min int (64-bit)
```

On web (JavaScript):
```dart
// Integers are limited to ~53 bits of precision
// Very large ints may lose precision
```

### Double Limits

```dart
print(double.maxFinite);   // 1.7976931348623157e+308
print(double.minPositive); // 5e-324
print(double.infinity);    // Infinity
print(double.nan);         // NaN (Not a Number)
```

### Special Values

```dart
double result = 1 / 0;     // Infinity
double negative = -1 / 0;  // -Infinity
double invalid = 0 / 0;    // NaN

print(result.isInfinite);  // true
print(invalid.isNaN);      // true
```

---

## Common Mistakes

### Mistake 1: Integer Division Expectation

```dart
// ❌ Wrong expectation
int result = 10 / 3;  // Error! Division returns double

// ✅ Correct
double result = 10 / 3;    // 3.333...
int result = 10 ~/ 3;      // 3 (integer division)
```

### Mistake 2: Floating-Point Precision

```dart
// ❌ Floating-point arithmetic isn't always exact
double result = 0.1 + 0.2;
print(result);  // 0.30000000000000004

// ✅ For currency, use cents as integers
int totalCents = 10 + 20;  // 30 cents
```

### Mistake 3: Parsing Without Error Handling

```dart
String input = 'abc';

// ❌ Will crash
int value = int.parse(input);

// ✅ Safe parsing
int? value = int.tryParse(input);
if (value != null) {
  print('Parsed: $value');
} else {
  print('Invalid input');
}
```

---

## Summary

### Operators Cheat Sheet

```dart
// Arithmetic
a + b    // Addition
a - b    // Subtraction
a * b    // Multiplication
a / b    // Division (returns double)
a ~/ b   // Integer division
a % b    // Modulo (remainder)

// Compound assignment
a += b   // a = a + b
a -= b   // a = a - b
a *= b   // a = a * b
a ~/= b  // a = a ~/ b

// Increment/Decrement
a++      // Post-increment
++a      // Pre-increment
a--      // Post-decrement
--a      // Pre-decrement
```

### Conversion Cheat Sheet

```dart
// String to number
int.parse('42')          // 42
double.parse('3.14')     // 3.14
int.tryParse('bad')      // null (safe)

// Number to string
42.toString()            // '42'
3.14.toString()          // '3.14'
3.14159.toStringAsFixed(2)  // '3.14'

// Between number types
42.toDouble()            // 42.0
3.14.toInt()             // 3
3.14.round()             // 3
3.7.round()              // 4
```

---

## Quick Quiz

**Q1:** What's the difference between `10 / 3` and `10 ~/ 3`?

<details>
<summary>Answer</summary>
`10 / 3` returns `3.333...` (double), while `10 ~/ 3` returns `3` (int, integer division).
</details>

**Q2:** What does `17 % 5` return?

<details>
<summary>Answer</summary>
`2` - the remainder when 17 is divided by 5 (17 = 5×3 + 2).
</details>

**Q3:** How do you safely convert a string to int?

<details>
<summary>Answer</summary>
Use `int.tryParse(string)` which returns `null` instead of throwing an error if parsing fails.
</details>

**Q4:** What's wrong with `int result = 10 / 2;`?

<details>
<summary>Answer</summary>
Division `/` always returns a `double`, even when the result is a whole number. Use `int result = 10 ~/ 2;` or `double result = 10 / 2;`.
</details>

---

## Assignment

### Problem 1: Predict the output

```dart
void main() {
  int a = 17;
  int b = 5;

  print(a + b);
  print(a - b);
  print(a * b);
  print(a / b);
  print(a ~/ b);
  print(a % b);
  print((a / b).toStringAsFixed(2));
}
```

### Problem 2: Even or odd

Without using any if statement, write a function `String evenOrOdd(int n)` that returns `'even'` for even numbers and `'odd'` for odd numbers. Use the ternary operator and the `%` operator.

### Problem 3: Total seconds to time format

Given a number of seconds, convert to hours, minutes, and remaining seconds. Write a function `String formatDuration(int totalSeconds)` that returns the formatted string in `HH:MM:SS` form, with each component zero-padded to 2 digits.

Examples:
- `formatDuration(75)` returns `'00:01:15'`.
- `formatDuration(3661)` returns `'01:01:01'`.
- `formatDuration(0)` returns `'00:00:00'`.

Hint: use `~/` and `%`. Use `padLeft(2, '0')` to pad.

### Problem 4: Tip calculator

Given a bill amount and a tip percentage, calculate:
1. The tip amount.
2. The total (bill plus tip).
3. The amount each of N people pays if they split equally.

Write `void splitBill(double bill, double tipPercent, int people)` that prints all three, formatted to 2 decimals.

Test with `splitBill(2500, 10, 4)`. Expected:
```
Tip: 250.00
Total: 2750.00
Each pays: 687.50
```

### Problem 5: Number summary

Given a list of integers, print:
- The sum.
- The smallest.
- The largest.
- The count of negatives.
- The count of evens.

Use a single for loop. No `where`, no `reduce`, no helper methods.

Test on `[5, -3, 8, -1, 4, 0, 7, -2]`.

---

## Assignment Answers

### Problem 1: Predict the output

```
22
12
85
3.4
3
2
3.40
```

How each line:

- `17 + 5 = 22`.
- `17 - 5 = 12`.
- `17 * 5 = 85`.
- `17 / 5 = 3.4`. Division always returns a double, even when the result is exact.
- `17 ~/ 5 = 3`. Integer division drops the decimal.
- `17 % 5 = 2`. After 17 / 5 = 3 with remainder 2, modulo gives 2.
- `(17/5).toStringAsFixed(2) = '3.40'`. Forces two decimals as a string.

The pair `~/` and `%` is so common you should memorise it: `a = (a ~/ b) * b + (a % b)`. The integer-division part times the divisor, plus the remainder, equals the original. This is just school division written in code.

### Problem 2: Even or odd

```dart
String evenOrOdd(int n) => n % 2 == 0 ? 'even' : 'odd';
```

How it works:

- `n % 2` is the remainder when dividing by 2. For even numbers, this is 0. For odd, it is 1 (or -1 for negative odds, both are nonzero).
- `n % 2 == 0` is a boolean: true if even, false if odd.
- The ternary `condition ? a : b` returns `a` when the condition is true, `b` otherwise.

So we get `'even'` when the modulo is 0, and `'odd'` otherwise.

This is the classic compact pattern. No if statement, just one expression.

### Problem 3: Total seconds to time format

```dart
String formatDuration(int totalSeconds) {
  int hours = totalSeconds ~/ 3600;
  int remainAfterHours = totalSeconds % 3600;

  int minutes = remainAfterHours ~/ 60;
  int seconds = remainAfterHours % 60;

  String hh = hours.toString().padLeft(2, '0');
  String mm = minutes.toString().padLeft(2, '0');
  String ss = seconds.toString().padLeft(2, '0');

  return '$hh:$mm:$ss';
}
```

How the calculation works:

1. **Hours:** there are 3600 seconds in an hour. Integer-divide to get whole hours.
2. **Remaining:** modulo 3600 gives the seconds left after subtracting full hours.
3. **Minutes:** 60 seconds in a minute. Integer-divide the remaining.
4. **Seconds:** modulo 60 gives the leftover.
5. **Padding:** convert each to a string and pad with `'0'` so single digits become two.

Trace for 3661 seconds:
- hours = 3661 ~/ 3600 = 1
- remainAfterHours = 3661 % 3600 = 61
- minutes = 61 ~/ 60 = 1
- seconds = 61 % 60 = 1
- Padded: '01:01:01'.

Trace for 75 seconds:
- hours = 75 ~/ 3600 = 0
- remainAfterHours = 75
- minutes = 75 ~/ 60 = 1
- seconds = 75 % 60 = 15
- Padded: '00:01:15'.

This integer-divide-then-modulo pattern is one of the most useful number tricks in programming. You will use it in clocks, currency formatting, address parsing, and many other places.

### Problem 4: Tip calculator

```dart
void splitBill(double bill, double tipPercent, int people) {
  double tip = bill * tipPercent / 100;
  double total = bill + tip;
  double perPerson = total / people;

  print('Tip: ${tip.toStringAsFixed(2)}');
  print('Total: ${total.toStringAsFixed(2)}');
  print('Each pays: ${perPerson.toStringAsFixed(2)}');
}
```

How each calculation:

- Tip: bill times percentage divided by 100. So 2500 times 10 / 100 = 250.
- Total: bill + tip = 2500 + 250 = 2750.
- Per person: total / people = 2750 / 4 = 687.5.

`toStringAsFixed(2)` formats each as a string with two decimals. 687.5 becomes "687.50".

Watch out: `tipPercent / 100` is a `double / int`, which gives a `double`. If you wrote `bill * tipPercent ~/ 100`, you would lose precision. Always use plain `/` for currency math.

### Problem 5: Number summary

```dart
void summarize(List<int> nums) {
  if (nums.isEmpty) {
    print('Empty list');
    return;
  }

  int sum = 0;
  int smallest = nums[0];
  int largest = nums[0];
  int negatives = 0;
  int evens = 0;

  for (int n in nums) {
    sum += n;
    if (n < smallest) smallest = n;
    if (n > largest) largest = n;
    if (n < 0) negatives++;
    if (n.isEven) evens++;
  }

  print('Sum: $sum');
  print('Smallest: $smallest');
  print('Largest: $largest');
  print('Negatives: $negatives');
  print('Evens: $evens');
}
```

How the loop computes everything in one pass:

For each number, we update five different running totals:

1. Add it to `sum`.
2. If it is smaller than the current smallest, update.
3. If it is larger than the current largest, update.
4. If it is negative, increment negatives counter.
5. If it is even, increment evens counter.

Trace on `[5, -3, 8, -1, 4, 0, 7, -2]`:

| n | sum | smallest | largest | negatives | evens |
|---|-----|----------|---------|-----------|-------|
| start | 0 | 5 | 5 | 0 | 0 |
| 5 | 5 | 5 | 5 | 0 | 0 |
| -3 | 2 | -3 | 5 | 1 | 0 |
| 8 | 10 | -3 | 8 | 1 | 1 |
| -1 | 9 | -3 | 8 | 2 | 1 |
| 4 | 13 | -3 | 8 | 2 | 2 |
| 0 | 13 | -3 | 8 | 2 | 3 |
| 7 | 20 | -3 | 8 | 2 | 3 |
| -2 | 18 | -3 | 8 | 3 | 4 |

Final: sum 18, smallest -3, largest 8, negatives 3, evens 4 (note: 0 is even).

The lesson: a single loop can compute many statistics if you keep separate running variables. This is much more efficient than running `where(...).length` for each statistic, because you only walk the list once.

---

**Next:** Let's learn about booleans and logical operations.

---

**Continue to:** `05-Booleans.md`
