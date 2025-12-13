# Day 5-7: Variables and Data Types

## What is a Variable?

Imagine you have a box. You can:
1. Put something in the box
2. Look at what's in the box
3. Replace what's in the box with something else
4. Label the box so you know what's inside

**A variable is like that box.** It stores information that you can use later.

### Real-World Example

Instead of writing:
```dart
void main() {
  print('Hello, Sarah!');
  print('Welcome back, Sarah!');
  print('Sarah, you have 3 messages.');
}
```

You can use a variable:
```dart
void main() {
  String name = 'Sarah';

  print('Hello, $name!');
  print('Welcome back, $name!');
  print('$name, you have 3 messages.');
}
```

Now if you need to change the name, you only change it in **one place**.

---

## Creating Variables

### Basic Syntax

```dart
String name = 'Alex';
int age = 25;
double height = 5.9;
bool isStudent = true;
```

Let's break this down:

1. **Type** (`String`, `int`, etc.) - What kind of data it is
2. **Name** (`name`, `age`, etc.) - What you call the variable
3. **`=`** - Assignment operator (means "store this value")
4. **Value** (`'Alex'`, `25`, etc.) - The actual data
5. **`;`** - End of statement

### Variable Declaration Without Type (Type Inference)

Dart is smart. It can figure out the type automatically:

```dart
var name = 'Alex';        // Dart knows this is a String
var age = 25;             // Dart knows this is an int
var height = 5.9;         // Dart knows this is a double
var isStudent = true;     // Dart knows this is a bool
```

**`var`** means "figure out the type for me."

### Which Should You Use?

Both work! But here's when to use each:

**Use explicit type** when:
- You want to be very clear
- You're learning (helps you understand types)
```dart
String username = 'john_doe';
```

**Use `var`** when:
- The type is obvious
- You want to save typing
```dart
var username = 'john_doe';  // Obviously a String
```

---

## Data Types

Dart has several **primitive** data types. Think of them as different kinds of boxes for different kinds of things.

### 1. String - Text

Stores text (letters, words, sentences).

```dart
String firstName = 'John';
String lastName = 'Smith';
String email = 'john@example.com';
String message = 'Hello, World!';
```

**Rules for Strings:**
- Must be in quotes: `'single'` or `"double"`
- Both work the same in Dart
- Can be empty: `String empty = '';`

**Examples:**
```dart
void main() {
  String greeting = 'Hello!';
  String name = 'Alice';

  print(greeting);  // Output: Hello!
  print(name);      // Output: Alice
}
```

### 2. int - Whole Numbers

Stores integers (no decimals).

```dart
int age = 25;
int followers = 1000;
int temperature = -5;
int zero = 0;
```

**Rules for int:**
- No decimal point
- Can be negative
- Can be zero

**Examples:**
```dart
void main() {
  int apples = 5;
  int oranges = 3;
  int totalFruit = apples + oranges;

  print(totalFruit);  // Output: 8
}
```

### 3. double - Decimal Numbers

Stores numbers with decimal points.

```dart
double price = 19.99;
double temperature = 98.6;
double pi = 3.14159;
double zero = 0.0;
```

**Rules for double:**
- Has a decimal point
- Can be negative
- More precise than int

**Examples:**
```dart
void main() {
  double price = 29.99;
  double tax = 2.40;
  double total = price + tax;

  print(total);  // Output: 32.39
}
```

### 4. bool - True or False

Stores only two values: `true` or `false`.

```dart
bool isLoggedIn = true;
bool hasPermission = false;
bool isRaining = false;
bool isDarkMode = true;
```

**Rules for bool:**
- Only `true` or `false` (no quotes!)
- Used for yes/no questions
- Used for conditions (we'll learn this in Week 3)

**Examples:**
```dart
void main() {
  bool isOnline = true;
  bool hasMessages = false;

  print(isOnline);      // Output: true
  print(hasMessages);   // Output: false
}
```

---

## Type Inference - Let Dart Figure It Out

Dart can determine types automatically:

```dart
void main() {
  var name = 'Bob';           // Dart: "This is a String"
  var age = 30;               // Dart: "This is an int"
  var price = 9.99;           // Dart: "This is a double"
  var isAvailable = true;     // Dart: "This is a bool"

  // Once set, the type is LOCKED
  // name = 42;  // ERROR! Can't change String to int
}
```

**Important:** Once Dart determines the type, it can't change.

---

## String Interpolation - Putting Variables in Text

Instead of:
```dart
String name = 'Alex';
print('Hello, ' + name + '!');  // This works but is ugly
```

Use **string interpolation**:
```dart
String name = 'Alex';
print('Hello, $name!');  // Much cleaner!
```

### Basic Interpolation

Use `$variableName` to insert a variable:

```dart
void main() {
  String name = 'Sarah';
  int age = 28;

  print('My name is $name');           // My name is Sarah
  print('I am $age years old');        // I am 28 years old
  print('$name is $age years old');    // Sarah is 28 years old
}
```

### Expression Interpolation

Use `${expression}` for calculations or method calls:

```dart
void main() {
  int a = 5;
  int b = 3;

  print('$a + $b = ${a + b}');         // 5 + 3 = 8
  print('${a * b}');                   // 15

  String name = 'alice';
  print('Hello, ${name.toUpperCase()}!');  // Hello, ALICE!
}
```

**Rule:**
- Simple variable? Use `$variable`
- Expression or method? Use `${expression}`

---

## final vs const - Variables That Don't Change

Sometimes you want a variable that **never changes** after you set it.

### final - Set Once, Can't Change

```dart
void main() {
  final String name = 'John';
  final int age = 25;

  // name = 'Jane';  // ERROR! Can't change final

  print(name);  // John
}
```

**Use `final` when:**
- The value is set at runtime (when the program runs)
- You won't change it after setting it
- Example: user's login time, API response

```dart
final currentTime = DateTime.now();  // Set when program runs
```

### const - Compile-Time Constant

```dart
void main() {
  const double pi = 3.14159;
  const int maxUsers = 100;

  // pi = 3.14;  // ERROR! Can't change const

  print(pi);  // 3.14159
}
```

**Use `const` when:**
- The value is known before the program runs
- It's truly constant (like pi, max limits)
- Example: configuration values, fixed limits

### final vs const - What's the Difference?

```dart
void main() {
  // const - Value must be known at compile time
  const int maxAttempts = 3;  // ✓ We know this before running
  // const String time = DateTime.now();  // ✗ ERROR! Don't know until runtime

  // final - Value set at runtime, then locked
  final String loginTime = DateTime.now().toString();  // ✓ Set once when running

  print(maxAttempts);
  print(loginTime);
}
```

**Simple Rule:**
- If you know the value while writing code → `const`
- If the value comes from user input or calculations → `final`
- If it might change → regular variable

---

## Variable Naming Rules

### The Rules (Must Follow)

1. **Start with letter or underscore**
   ```dart
   String name = 'Valid';      // ✓
   String _private = 'Valid';  // ✓
   // String 2cool = 'Invalid'; // ✗ ERROR
   ```

2. **Can contain letters, numbers, underscores**
   ```dart
   String user1 = 'Valid';      // ✓
   String first_name = 'Valid'; // ✓
   // String first-name = 'Invalid'; // ✗ ERROR (no hyphens)
   ```

3. **No spaces**
   ```dart
   String firstName = 'Valid';     // ✓
   // String first name = 'Invalid'; // ✗ ERROR
   ```

4. **Case-sensitive**
   ```dart
   String name = 'John';
   String Name = 'Jane';
   String NAME = 'Jake';
   // These are THREE different variables!
   ```

5. **Can't use reserved words**
   ```dart
   // String class = 'Invalid';  // ✗ ERROR (class is reserved)
   // String if = 'Invalid';     // ✗ ERROR (if is reserved)
   String className = 'Valid';   // ✓
   ```

### Conventions (Should Follow)

1. **Use camelCase**
   ```dart
   String firstName = 'John';     // ✓ Good
   String first_name = 'John';    // ✗ Not Dart style
   String FirstName = 'John';     // ✗ That's for classes
   ```

2. **Use descriptive names**
   ```dart
   int userAge = 25;              // ✓ Clear
   int a = 25;                    // ✗ What is 'a'?
   ```

3. **Boolean variables should ask a question**
   ```dart
   bool isLoggedIn = true;        // ✓ Good
   bool hasPermission = false;    // ✓ Good
   bool loggedIn = true;          // ✗ Less clear
   ```

---

## Complete Example

```dart
void main() {
  // Personal information
  String firstName = 'Alex';
  String lastName = 'Johnson';
  int age = 28;
  double height = 5.9;
  bool isStudent = false;

  // Combine first and last name
  String fullName = '$firstName $lastName';

  // Print profile
  print('===== USER PROFILE =====');
  print('Name: $fullName');
  print('Age: $age years old');
  print('Height: $height feet');
  print('Student: $isStudent');

  // Calculate next year's age
  int nextYearAge = age + 1;
  print('Next year I will be $nextYearAge');
}
```

**Output:**
```
===== USER PROFILE =====
Name: Alex Johnson
Age: 28 years old
Height: 5.9 feet
Student: false
Next year I will be 29
```

---

## Exercises

### Exercise 1: Personal Profile
Create variables for your personal information and print them nicely.

**Requirements:**
- First name (String)
- Last name (String)
- Age (int)
- Height in feet (double)
- Are you a student? (bool)

Print it in a formatted way.

<details>
<summary>Solution</summary>

```dart
void main() {
  String firstName = 'Emma';
  String lastName = 'Wilson';
  int age = 22;
  double height = 5.4;
  bool isStudent = true;

  print('Name: $firstName $lastName');
  print('Age: $age');
  print('Height: $height ft');
  print('Student: $isStudent');
}
```
</details>

---

### Exercise 2: Simple Calculator
Create two number variables and print their sum, difference, product, and quotient.

**Example:**
```
a = 10
b = 3
10 + 3 = 13
10 - 3 = 7
10 * 3 = 30
10 / 3 = 3.3333...
```

<details>
<summary>Solution</summary>

```dart
void main() {
  int a = 10;
  int b = 3;

  print('a = $a');
  print('b = $b');
  print('$a + $b = ${a + b}');
  print('$a - $b = ${a - b}');
  print('$a * $b = ${a * b}');
  print('$a / $b = ${a / b}');
}
```
</details>

---

### Exercise 3: Price Calculator
A product costs $29.99. Tax is 8%. Calculate and print the total price.

<details>
<summary>Solution</summary>

```dart
void main() {
  double price = 29.99;
  double taxRate = 0.08;
  double tax = price * taxRate;
  double total = price + tax;

  print('Price: \$$price');
  print('Tax (8%): \$$tax');
  print('Total: \$$total');
}
```

**Note:** Use `\$` to print an actual dollar sign (the backslash escapes it).
</details>

---

### Exercise 4: Temperature Converter
Create a variable for temperature in Celsius. Convert and print it in Fahrenheit.

Formula: `F = (C * 9/5) + 32`

**Example:**
```
25°C = 77°F
```

<details>
<summary>Solution</summary>

```dart
void main() {
  double celsius = 25;
  double fahrenheit = (celsius * 9 / 5) + 32;

  print('${celsius}°C = ${fahrenheit}°F');
}
```
</details>

---

### Exercise 5: About Me Card

Create a program that prints a nicely formatted "About Me" card with:
- Your name
- Your age
- Your favorite programming language (String)
- Number of projects you've built (int - can be 0!)
- Are you learning Flutter? (bool)

Make it look professional!

<details>
<summary>Solution</summary>

```dart
void main() {
  String name = 'Jordan Lee';
  int age = 24;
  String favLanguage = 'Dart';
  int projects = 3;
  bool learningFlutter = true;

  print('╔════════════════════════════════╗');
  print('║        ABOUT ME CARD           ║');
  print('╚════════════════════════════════╝');
  print('');
  print('Name: $name');
  print('Age: $age years old');
  print('Favorite Language: $favLanguage');
  print('Projects Completed: $projects');
  print('Learning Flutter: $learningFlutter');
  print('');
  print('Thank you for reading!');
}
```
</details>

---

## Common Mistakes

### 1. Forgetting Quotes for Strings
```dart
String name = Alex;  // ✗ ERROR
String name = 'Alex';  // ✓ Correct
```

### 2. Decimal Point on int
```dart
int age = 25.5;  // ✗ ERROR (int can't have decimals)
double age = 25.5;  // ✓ Correct
```

### 3. Forgetting $ in Interpolation
```dart
String name = 'Bob';
print('Hello, name!');  // ✗ Prints: Hello, name!
print('Hello, $name!');  // ✓ Prints: Hello, Bob!
```

### 4. Changing const/final
```dart
final String name = 'Alex';
name = 'Bob';  // ✗ ERROR - can't change final
```

---

## Key Takeaways

1. **Variables store data** you can use later
2. **Four main types:** String (text), int (whole numbers), double (decimals), bool (true/false)
3. **Use `var`** if you want Dart to figure out the type
4. **String interpolation** with `$variable` or `${expression}`
5. **`final`** = set once, locked forever (value at runtime)
6. **`const`** = compile-time constant (value before running)
7. **camelCase** for variable names
8. **Descriptive names** make code readable

---

## What's Next?

You now know how to store and display data! Next week, we'll learn:
- **String manipulation** - splitting, combining, searching text
- **Math operations** - more complex calculations
- **Operators** - comparison, logical operations

Keep practicing! Create variables for everything you see around you. The more you practice, the more natural it becomes.

**Pro Tip:** Try to describe your day using variables and print statements. It's a fun way to practice!
