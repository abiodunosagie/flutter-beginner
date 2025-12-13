# Functions: Reusable Code Blocks

## What Is a Function?

A **function** is a named block of code that does a specific job.

Think of it like a recipe:
- **Name**: "Make Pancakes"
- **Ingredients** (inputs): flour, eggs, milk
- **Steps** (code): mix, pour, flip
- **Result** (output): pancakes!

```dart
// This is a function
void sayHello() {
  print('Hello!');
}
```

---

## Why Use Functions?

### Without Functions (Bad)

```dart
void main() {
  // Calculate area of rectangle 1
  int length1 = 5;
  int width1 = 3;
  int area1 = length1 * width1;
  print('Area: $area1');

  // Calculate area of rectangle 2
  int length2 = 10;
  int width2 = 4;
  int area2 = length2 * width2;
  print('Area: $area2');

  // Calculate area of rectangle 3
  int length3 = 7;
  int width3 = 2;
  int area3 = length3 * width3;
  print('Area: $area3');
}
```

Problems:
- ❌ Repeated code
- ❌ Easy to make mistakes
- ❌ Hard to change

### With Functions (Good)

```dart
int calculateArea(int length, int width) {
  return length * width;
}

void main() {
  print('Area: ${calculateArea(5, 3)}');
  print('Area: ${calculateArea(10, 4)}');
  print('Area: ${calculateArea(7, 2)}');
}
```

Benefits:
- ✅ Write once, use many times
- ✅ Easy to understand
- ✅ Easy to fix or improve

---

## Function Anatomy

```dart
returnType functionName(parameters) {
  // code
  return value;
}
```

Let's break it down:

```dart
int      add        (int a, int b)  {
↑        ↑          ↑               ↑
return   function   parameters      function
type     name       (inputs)        body

  return a + b;
  ↑
  what to give back
}
```

---

## Your First Function

### Step 1: Declare the Function

```dart
void greet() {
  print('Hello, World!');
}
```

- `void` = returns nothing
- `greet` = function name
- `()` = no parameters
- `{ }` = function body

### Step 2: Call the Function

```dart
void main() {
  greet();  // Prints: Hello, World!
  greet();  // Prints: Hello, World!
  greet();  // Prints: Hello, World!
}
```

---

## Functions with Parameters

Parameters are like blanks to fill in:

```dart
void greet(String name) {
  print('Hello, $name!');
}

void main() {
  greet('Alice');  // Hello, Alice!
  greet('Bob');    // Hello, Bob!
  greet('Charlie'); // Hello, Charlie!
}
```

### Multiple Parameters

```dart
void introduce(String name, int age) {
  print('I am $name and I am $age years old.');
}

void main() {
  introduce('Alice', 25);
  introduce('Bob', 30);
}
```

---

## The Return Statement

Functions can give back a value:

```dart
int add(int a, int b) {
  return a + b;  // Give back the sum
}

void main() {
  int result = add(5, 3);
  print(result);  // 8

  // Or use directly
  print(add(10, 20));  // 30
}
```

### Return Stops Execution

```dart
int findFirst(List<int> numbers, int target) {
  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == target) {
      return i;  // Found! Exit function immediately
    }
  }
  return -1;  // Not found
}
```

---

## void vs Return Type

### void: Does Something, Returns Nothing

```dart
void printMessage(String message) {
  print(message);
  // No return needed
}
```

### Return Type: Does Something, Returns a Value

```dart
String getMessage(String name) {
  return 'Hello, $name!';  // Must return a String
}

void main() {
  String msg = getMessage('Alice');
  print(msg);
}
```

---

## Visual: How Functions Work

```
┌─────────────────────────────────────────┐
│              Function Call              │
│            add(5, 3)                    │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│           Function Executes             │
│  ┌───────────────────────────────────┐  │
│  │  int add(int a, int b) {          │  │
│  │    a = 5                          │  │
│  │    b = 3                          │  │
│  │    return a + b;  → returns 8     │  │
│  │  }                                │  │
│  └───────────────────────────────────┘  │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│           Result: 8                     │
│     (goes back to where it was called)  │
└─────────────────────────────────────────┘
```

---

## Naming Functions

Good names describe what the function DOES:

```dart
// ✅ Good names - verbs that describe action
int calculateTotal(List<int> prices) { ... }
bool isValidEmail(String email) { ... }
void sendNotification(String message) { ... }
String formatDate(DateTime date) { ... }
List<int> filterEven(List<int> numbers) { ... }

// ❌ Bad names - unclear
int calc(List<int> p) { ... }
bool check(String e) { ... }
void do_stuff(String m) { ... }
```

### Common Patterns

| Prefix | Meaning | Example |
|--------|---------|---------|
| `get` | Returns a value | `getName()` |
| `set` | Sets a value | `setName(name)` |
| `is` | Returns boolean | `isEmpty()` |
| `has` | Returns boolean | `hasError()` |
| `calculate` | Computes something | `calculateTotal()` |
| `create` | Makes something new | `createUser()` |
| `update` | Modifies something | `updateProfile()` |
| `delete` | Removes something | `deleteItem()` |

---

## Function Location

Functions can be:

### 1. Top-Level (Outside any class)

```dart
// This is a top-level function
void sayHello() {
  print('Hello!');
}

void main() {
  sayHello();
}
```

### 2. Inside main()

```dart
void main() {
  // This is a local function
  void greet(String name) {
    print('Hello, $name!');
  }

  greet('Alice');
}
```

### 3. Inside Classes (Methods - covered in Level 4)

```dart
class Person {
  void introduce() {
    print('I am a person');
  }
}
```

---

## Common Mistakes

### Mistake 1: Forgetting to Call

```dart
void greet() {
  print('Hello!');
}

void main() {
  greet;  // ❌ Does nothing! Missing ()
  greet(); // ✅ Calls the function
}
```

### Mistake 2: Wrong Return Type

```dart
// ❌ Says int but returns nothing
int add(int a, int b) {
  print(a + b);
  // Missing return!
}

// ✅ Correct
int add(int a, int b) {
  return a + b;
}
```

### Mistake 3: Ignoring Return Value

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  add(5, 3);  // ⚠️ Result is thrown away

  int result = add(5, 3);  // ✅ Result is saved
  print(result);
}
```

---

## Practical Example

Let's build a simple calculator:

```dart
// Addition
int add(int a, int b) {
  return a + b;
}

// Subtraction
int subtract(int a, int b) {
  return a - b;
}

// Multiplication
int multiply(int a, int b) {
  return a * b;
}

// Division (returns double for accuracy)
double divide(int a, int b) {
  if (b == 0) {
    print('Error: Cannot divide by zero!');
    return 0;
  }
  return a / b;
}

void main() {
  print('5 + 3 = ${add(5, 3)}');
  print('10 - 4 = ${subtract(10, 4)}');
  print('6 × 7 = ${multiply(6, 7)}');
  print('20 ÷ 4 = ${divide(20, 4)}');
}
```

---

## Summary

### Function Basics

```dart
// Declaration
returnType name(parameters) {
  // code
  return value;
}

// Call
name(arguments);
```

### Key Points

1. Functions are reusable code blocks
2. Parameters are inputs
3. Return values are outputs
4. `void` means no return value
5. Use descriptive names (verbs)
6. Don't forget the parentheses when calling!

---

## Quick Quiz

**Q1:** What's wrong with this function?

```dart
void add(int a, int b) {
  return a + b;
}
```

<details>
<summary>Answer</summary>

`void` means no return, but we're returning a value. Should be:
```dart
int add(int a, int b) {
  return a + b;
}
```

</details>

**Q2:** What does this print?

```dart
String greet(String name) {
  return 'Hello, $name!';
}

void main() {
  greet('Alice');
}
```

<details>
<summary>Answer</summary>

Nothing! The function returns a string but we don't print it. Should be:
```dart
print(greet('Alice'));
```

</details>

**Q3:** What's a good name for a function that checks if a number is even?

<details>
<summary>Answer</summary>

`isEven(int number)` - uses the `is` prefix for boolean returns.

</details>

---

**Next:** Learn about different types of parameters.

---

**Continue to:** `02-Parameters.md`
