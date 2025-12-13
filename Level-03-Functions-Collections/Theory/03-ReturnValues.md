# Return Values & Arrow Functions

## What Is a Return Value?

A **return value** is what a function gives back after it finishes.

```dart
int add(int a, int b) {
  return a + b;  // Give back the sum
}

void main() {
  int result = add(5, 3);  // result gets 8
  print(result);
}
```

Think of it like a vending machine:
- You put in money (arguments)
- Press a button (call function)
- Get a snack (return value)

---

## Return Types

### Basic Return Types

```dart
// Returns an integer
int getAge() {
  return 25;
}

// Returns a double
double getPrice() {
  return 19.99;
}

// Returns a string
String getName() {
  return 'Alice';
}

// Returns a boolean
bool isAdult(int age) {
  return age >= 18;
}
```

### Collection Return Types

```dart
// Returns a List
List<int> getNumbers() {
  return [1, 2, 3, 4, 5];
}

// Returns a Map
Map<String, int> getScores() {
  return {'Alice': 95, 'Bob': 87};
}

// Returns a Set
Set<String> getUniqueNames() {
  return {'Alice', 'Bob', 'Charlie'};
}
```

---

## void: No Return Value

`void` means the function does something but doesn't give anything back.

```dart
void printMessage(String message) {
  print(message);
  // No return needed
}

void main() {
  printMessage('Hello');  // Just does something

  // ❌ Cannot save void
  // var result = printMessage('Hello');  // Error!
}
```

---

## The return Statement

### Stops Function Execution

```dart
int findFirstEven(List<int> numbers) {
  for (int num in numbers) {
    if (num % 2 == 0) {
      return num;  // Found! Exit immediately
    }
  }
  return -1;  // Not found
}

void main() {
  var nums = [1, 3, 5, 4, 6, 8];
  print(findFirstEven(nums));  // 4 (stopped at first even)
}
```

### Early Return Pattern

Use return to exit early when conditions aren't met:

```dart
String gradeStudent(int score) {
  // Exit early if invalid
  if (score < 0 || score > 100) {
    return 'Invalid score';
  }

  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}
```

---

## Nullable Return Types

Sometimes a function might not have a result:

```dart
String? findUser(int id) {
  if (id == 1) return 'Alice';
  if (id == 2) return 'Bob';
  return null;  // Not found
}

void main() {
  String? user = findUser(5);

  if (user != null) {
    print('Found: $user');
  } else {
    print('User not found');
  }
}
```

### Handling Nullable Returns

```dart
void main() {
  String? result = findUser(5);

  // Option 1: Null check
  if (result != null) {
    print(result.toUpperCase());
  }

  // Option 2: Default value
  print(result ?? 'Unknown');

  // Option 3: Null-aware call
  print(result?.toUpperCase());
}
```

---

## Arrow Functions

For simple functions with ONE expression, use arrow syntax:

### Regular Function

```dart
int add(int a, int b) {
  return a + b;
}
```

### Arrow Function (Same Thing)

```dart
int add(int a, int b) => a + b;
```

The `=>` replaces `{ return ... }`

### More Examples

```dart
// Regular
bool isEven(int n) {
  return n % 2 == 0;
}

// Arrow
bool isEven(int n) => n % 2 == 0;

// Regular
String greet(String name) {
  return 'Hello, $name!';
}

// Arrow
String greet(String name) => 'Hello, $name!';

// Regular
double circleArea(double radius) {
  return 3.14159 * radius * radius;
}

// Arrow
double circleArea(double radius) => 3.14159 * radius * radius;
```

### Arrow with void

```dart
// Regular
void sayHello() {
  print('Hello!');
}

// Arrow
void sayHello() => print('Hello!');
```

### When NOT to Use Arrow

When you need multiple statements:

```dart
// ❌ Cannot use arrow - multiple statements
int calculate(int a, int b) {
  int sum = a + b;
  int product = a * b;
  return sum + product;
}

// ✅ Arrow only for single expressions
int calculate(int a, int b) => (a + b) + (a * b);
```

---

## Anonymous Functions (Lambdas)

Functions without a name. Often used with collections.

### Regular Function

```dart
int double(int n) {
  return n * 2;
}
```

### Anonymous Function

```dart
(int n) {
  return n * 2;
}
```

### Arrow Anonymous Function

```dart
(int n) => n * 2;
```

### Using with Collections

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];

  // map() takes a function
  var doubled = numbers.map((n) => n * 2);
  print(doubled.toList());  // [2, 4, 6, 8, 10]

  // where() filters with a function
  var evens = numbers.where((n) => n % 2 == 0);
  print(evens.toList());  // [2, 4]

  // forEach() does something with each item
  numbers.forEach((n) => print('Number: $n'));
}
```

---

## Functions as Variables

Functions are first-class citizens - you can store them in variables!

```dart
void main() {
  // Store function in variable
  var add = (int a, int b) => a + b;
  var multiply = (int a, int b) => a * b;

  print(add(5, 3));       // 8
  print(multiply(5, 3));  // 15

  // Pass function as argument
  int calculate(int a, int b, Function operation) {
    return operation(a, b);
  }

  print(calculate(10, 5, add));       // 15
  print(calculate(10, 5, multiply));  // 50
}
```

### Function Types

```dart
// Type: Function that takes two ints and returns int
typedef MathOperation = int Function(int, int);

void main() {
  MathOperation add = (a, b) => a + b;
  MathOperation subtract = (a, b) => a - b;

  print(add(10, 5));       // 15
  print(subtract(10, 5));  // 5
}
```

---

## Higher-Order Functions

Functions that take or return other functions.

### Function That Takes a Function

```dart
void repeat(int times, void Function() action) {
  for (int i = 0; i < times; i++) {
    action();
  }
}

void main() {
  repeat(3, () => print('Hello!'));
  // Hello!
  // Hello!
  // Hello!
}
```

### Function That Returns a Function

```dart
Function(int) createMultiplier(int factor) {
  return (int value) => value * factor;
}

void main() {
  var double = createMultiplier(2);
  var triple = createMultiplier(3);

  print(double(5));  // 10
  print(triple(5));  // 15
}
```

---

## Closures

Functions that "remember" variables from their surrounding scope.

```dart
Function makeCounter() {
  int count = 0;  // This is "captured"

  return () {
    count++;
    return count;
  };
}

void main() {
  var counter = makeCounter();

  print(counter());  // 1
  print(counter());  // 2
  print(counter());  // 3

  // Each counter has its own count
  var counter2 = makeCounter();
  print(counter2());  // 1
}
```

---

## Practical Examples

### Example 1: Calculator Operations

```dart
// Define operations as functions
int add(int a, int b) => a + b;
int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;
double divide(int a, int b) => b != 0 ? a / b : 0;

// Use operation based on symbol
dynamic calculate(int a, int b, String op) {
  var operations = {
    '+': add,
    '-': subtract,
    '*': multiply,
    '/': divide,
  };

  var operation = operations[op];
  if (operation != null) {
    return operation(a, b);
  }
  return 'Unknown operation';
}

void main() {
  print(calculate(10, 5, '+'));  // 15
  print(calculate(10, 5, '-'));  // 5
  print(calculate(10, 5, '*'));  // 50
  print(calculate(10, 5, '/'));  // 2.0
}
```

### Example 2: List Processing

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Filter evens
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('Evens: $evens');

  // Square each
  var squares = numbers.map((n) => n * n).toList();
  print('Squares: $squares');

  // Sum all
  var sum = numbers.reduce((a, b) => a + b);
  print('Sum: $sum');

  // Find first > 5
  var firstBig = numbers.firstWhere((n) => n > 5);
  print('First > 5: $firstBig');
}
```

### Example 3: Validation Functions

```dart
// Return function type for clarity
typedef Validator = bool Function(String);

Validator minLength(int min) {
  return (String value) => value.length >= min;
}

Validator maxLength(int max) {
  return (String value) => value.length <= max;
}

Validator contains(String pattern) {
  return (String value) => value.contains(pattern);
}

void main() {
  var password = 'Secret123';

  var isLongEnough = minLength(8);
  var notTooLong = maxLength(20);
  var hasNumber = contains(RegExp(r'[0-9]').pattern);

  print('Long enough: ${isLongEnough(password)}');
  print('Not too long: ${notTooLong(password)}');
  print('Has number: ${password.contains(RegExp(r'[0-9]'))}');
}
```

---

## Summary

### Return Values
- `return` gives back a value and exits
- Return type must match declared type
- `void` means no return value
- `?` makes return type nullable

### Arrow Functions
- `=> expression` replaces `{ return expression; }`
- Only for single expressions
- Makes code shorter and cleaner

### Anonymous Functions
- Functions without names
- `(params) => expression` or `(params) { code }`
- Commonly used with collections

### Key Points
1. Every non-void function must return a value
2. `return` immediately exits the function
3. Use arrow syntax for simple functions
4. Functions can be stored in variables
5. Functions can take/return other functions

---

## Quick Quiz

**Q1:** Convert to arrow function:

```dart
bool isPositive(int n) {
  return n > 0;
}
```

<details>
<summary>Answer</summary>

```dart
bool isPositive(int n) => n > 0;
```

</details>

**Q2:** What does this return?

```dart
int? findIndex(List<int> list, int target) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == target) return i;
  }
  return null;
}

void main() {
  print(findIndex([1, 2, 3], 5));
}
```

<details>
<summary>Answer</summary>

`null` - 5 is not in the list.

</details>

**Q3:** What's the output?

```dart
var numbers = [1, 2, 3, 4, 5];
var result = numbers.map((n) => n * 2).toList();
print(result);
```

<details>
<summary>Answer</summary>

`[2, 4, 6, 8, 10]`

</details>

---

**Next:** Learn about Lists - the most common collection.

---

**Continue to:** `04-Lists.md`
