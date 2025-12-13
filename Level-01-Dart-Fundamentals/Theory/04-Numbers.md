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

**Next:** Let's learn about booleans and logical operations.

---

**Continue to:** `05-Booleans.md`
