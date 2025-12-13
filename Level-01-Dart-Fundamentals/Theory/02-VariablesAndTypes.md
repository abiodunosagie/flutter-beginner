# Variables and Data Types

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

## Creating Variables in Dart

### The Basic Pattern

```dart
type name = value;
```

- **type** - What kind of data it holds
- **name** - What you call it
- **value** - What's inside

### Example

```dart
String name = 'Alex';
```

Let's break this down:
- `String` = This variable holds text
- `name` = We're calling this variable "name"
- `=` = Assignment operator (puts value into variable)
- `'Alex'` = The actual text we're storing
- `;` = End of statement

---

## The Four Basic Data Types

Dart has four fundamental types you'll use constantly:

### 1. String - Text

```dart
String firstName = 'Alex';
String lastName = "Smith";      // Single or double quotes work
String message = 'Hello, World!';
String empty = '';              // Empty string is valid
```

**Strings** hold text. Any characters between quotes.

### 2. int - Whole Numbers

```dart
int age = 25;
int year = 2024;
int temperature = -10;          // Can be negative
int million = 1000000;
int zero = 0;
```

**int** (integer) holds whole numbers. No decimal points.

### 3. double - Decimal Numbers

```dart
double price = 19.99;
double pi = 3.14159;
double temperature = 98.6;
double negative = -273.15;
double whole = 42.0;            // Can end in .0
```

**double** holds numbers with decimal points.

### 4. bool - True/False

```dart
bool isLoggedIn = true;
bool hasPermission = false;
bool isAdult = true;
```

**bool** (boolean) holds only two values: `true` or `false`.

---

## Visual Summary

```
┌──────────────────────────────────────────────────────┐
│                    DATA TYPES                         │
├──────────────────────────────────────────────────────┤
│                                                      │
│   String     "Hello"   "Alex"   "123"   ""          │
│   ───────    Text, characters, words                │
│                                                      │
│   int        42   -10   0   1000000                 │
│   ───        Whole numbers, no decimals             │
│                                                      │
│   double     3.14   -0.5   100.0   19.99           │
│   ──────     Decimal numbers                        │
│                                                      │
│   bool       true   false                           │
│   ────       Yes/no, on/off, true/false            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Using Variables

### Declaring and Using

```dart
void main() {
  String name = 'Alex';
  int age = 25;

  print(name);  // Output: Alex
  print(age);   // Output: 25
}
```

### Changing Values

Variables can change (that's why they're called "variables"):

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

### Using Variables in Calculations

```dart
void main() {
  int a = 10;
  int b = 5;
  int sum = a + b;

  print(sum);  // Output: 15
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

## Type Safety

Dart is **type-safe**. Once you declare a variable's type, it can only hold that type.

```dart
void main() {
  int age = 25;

  age = 30;       // ✅ OK - int can hold int
  age = 'thirty'; // ❌ ERROR - int can't hold String
}
```

This prevents bugs:
```dart
// In a type-unsafe language, this might "work" and cause problems later
int price = '19.99';  // ❌ Dart stops this immediately
```

---

## The `var` Keyword

If you don't want to write the type, use `var`:

```dart
var name = 'Alex';   // Dart knows it's a String
var age = 25;        // Dart knows it's an int
var price = 19.99;   // Dart knows it's a double
var active = true;   // Dart knows it's a bool
```

Dart **infers** the type from the value. But once set, it's fixed:

```dart
var name = 'Alex';
name = 'Bob';    // ✅ OK - still a String
name = 42;       // ❌ ERROR - can't change to int
```

### When to Use `var` vs Explicit Type

```dart
// Use explicit type when it's not obvious
String jsonResponse = fetchData();

// Use var when it's obvious
var name = 'Alex';
var count = 0;
```

---

## The `dynamic` Keyword

If you truly need a variable that can hold any type:

```dart
dynamic anything = 'Hello';
anything = 42;      // ✅ OK
anything = true;    // ✅ OK
anything = 3.14;    // ✅ OK
```

**Warning:** Avoid `dynamic` when possible. It removes type safety and can lead to runtime errors.

---

## Constants: `final` and `const`

Sometimes you want a variable that can't change.

### `final` - Set Once, Never Change

```dart
final String name = 'Alex';
name = 'Bob';  // ❌ ERROR - can't change final

final age = 25;  // Type inference works with final too
```

Use `final` when the value is set at runtime but shouldn't change after.

### `const` - Compile-Time Constant

```dart
const double pi = 3.14159;
const int maxUsers = 100;

pi = 3.14;  // ❌ ERROR - can't change const
```

Use `const` when the value is known before the program runs.

### When to Use Which

```dart
// const - value known at compile time
const int maxAttempts = 3;
const double taxRate = 0.08;

// final - value set at runtime, but shouldn't change
final DateTime now = DateTime.now();
final String id = generateId();
```

---

## Null Safety

In Dart, variables can't be `null` (empty) by default.

### Non-Nullable (Default)

```dart
String name = 'Alex';  // Must have a value
name = null;           // ❌ ERROR - can't be null
```

### Nullable (Opt-In)

Add `?` to allow null:

```dart
String? name = 'Alex';  // Can have a value
name = null;            // ✅ OK - can be null
```

### Why This Matters

Null errors are one of the most common bugs in programming. Dart's null safety catches these at compile time:

```dart
String? maybeName;  // Could be null

// ❌ This would crash if maybeName is null
print(maybeName.length);

// ✅ Safe - check first
if (maybeName != null) {
  print(maybeName.length);
}
```

We'll dive deeper into null safety in later levels.

---

## Practical Examples

### Example 1: User Profile

```dart
void main() {
  String username = 'alex_dev';
  String email = 'alex@example.com';
  int age = 28;
  bool isPremium = true;
  double accountBalance = 150.75;

  print('Username: $username');
  print('Email: $email');
  print('Age: $age');
  print('Premium: $isPremium');
  print('Balance: \$$accountBalance');
}
```

### Example 2: Product Info

```dart
void main() {
  String productName = 'Wireless Headphones';
  double price = 79.99;
  int quantity = 50;
  bool inStock = quantity > 0;

  print('Product: $productName');
  print('Price: \$$price');
  print('In Stock: $inStock');
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

## String Interpolation

To include variables in strings, use `$`:

### Simple Variable

```dart
String name = 'Alex';
print('Hello, $name!');  // Output: Hello, Alex!
```

### Expression

Use `${}` for expressions:

```dart
int age = 25;
print('Next year: ${age + 1}');  // Output: Next year: 26

String name = 'alex';
print('Name: ${name.toUpperCase()}');  // Output: Name: ALEX
```

### Compare Methods

```dart
// Method 1: Concatenation (old way)
String greeting = 'Hello, ' + name + '!';

// Method 2: Interpolation (preferred)
String greeting = 'Hello, $name!';
```

Interpolation is cleaner and easier to read.

---

## Summary

### Key Takeaways

1. **Variables** store data with a name and type
2. **Four basic types**: String, int, double, bool
3. **Type safety** prevents mixing types
4. **`var`** lets Dart infer the type
5. **`final`** creates unchangeable variables
6. **`const`** creates compile-time constants
7. **Null safety** prevents null errors

### Type Cheat Sheet

```dart
String text = 'Hello';     // Text
int whole = 42;            // Whole number
double decimal = 3.14;     // Decimal number
bool flag = true;          // True or false

var inferred = 'Hello';    // Type inferred
final fixed = 'Can\'t change';  // Set once
const constant = 100;      // Compile-time constant
```

---

## Quick Quiz

**Q1:** What type would you use for someone's name?

<details>
<summary>Answer</summary>
`String` - because names are text.
</details>

**Q2:** What type for someone's age?

<details>
<summary>Answer</summary>
`int` - because age is a whole number.
</details>

**Q3:** What's wrong here?
```dart
int price = 19.99;
```

<details>
<summary>Answer</summary>
`19.99` is a decimal, but `int` only holds whole numbers. Should be `double price = 19.99;`
</details>

**Q4:** What does this print?
```dart
var x = 10;
x = 20;
print(x);
```

<details>
<summary>Answer</summary>
`20` - Variables can be reassigned to new values of the same type.
</details>

**Q5:** Why won't this work?
```dart
final name = 'Alex';
name = 'Bob';
```

<details>
<summary>Answer</summary>
`final` variables can only be assigned once. After `name = 'Alex'`, it can't be changed.
</details>

---

**Next:** Let's dive deeper into working with text (Strings).

---

**Continue to:** `03-Strings.md`
