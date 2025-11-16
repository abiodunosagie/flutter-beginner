# Week 4, Day 1-3: Functions - Organizing Your Code

## What is a Function?

Think of a function as a **recipe**:

```
Recipe: Make Coffee
Ingredients: Coffee beans, Water
Steps:
  1. Grind beans
  2. Heat water
  3. Brew
  4. Pour
Returns: Cup of coffee
```

In programming, a function is a **named block of code** that:
1. Has a name ("makeCoffee")
2. Takes inputs (beans, water)
3. Does something (the steps)
4. Returns a result (coffee)

**Why use functions?**
- **Reusability** - Write once, use many times
- **Organization** - Break big problems into small pieces
- **Readability** - Code becomes self-documenting
- **Maintenance** - Fix bugs in one place
- **Testing** - Test small pieces independently

---

## Your First Function

### Basic Syntax

```dart
void functionName() {
  // Code goes here
}
```

### Example: Simple Greeting

```dart
void sayHello() {
  print('Hello, World!');
}

void main() {
  sayHello();  // Call the function
  sayHello();  // Call it again!
  sayHello();  // And again!
}
```

**Output:**
```
Hello, World!
Hello, World!
Hello, World!
```

**Breaking it down:**
- `void` - This function returns nothing
- `sayHello` - Name of the function (camelCase)
- `()` - Empty parentheses (no parameters yet)
- `{}` - Function body (what it does)
- `sayHello()` - Calling (executing) the function

---

## Functions with Parameters

### Purpose
Pass information TO the function.

### Syntax

```dart
void functionName(type parameter) {
  // Use parameter
}
```

### Example 1: Personalized Greeting

```dart
void greet(String name) {
  print('Hello, $name!');
}

void main() {
  greet('Alice');    // Hello, Alice!
  greet('Bob');      // Hello, Bob!
  greet('Charlie');  // Hello, Charlie!
}
```

### Example 2: Multiple Parameters

```dart
void introduce(String name, int age) {
  print('My name is $name and I am $age years old.');
}

void main() {
  introduce('Alice', 25);
  introduce('Bob', 30);
}
```

**Output:**
```
My name is Alice and I am 25 years old.
My name is Bob and I am 30 years old.
```

### Example 3: Calculate Area

```dart
void printArea(double length, double width) {
  double area = length * width;
  print('Area: $area');
}

void main() {
  printArea(5.0, 3.0);   // Area: 15.0
  printArea(10.0, 2.5);  // Area: 25.0
}
```

---

## Return Values

### Purpose
Get a result BACK from the function.

### Syntax

```dart
returnType functionName(parameters) {
  // Do something
  return value;
}
```

### Example 1: Add Two Numbers

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  int result = add(5, 3);
  print('5 + 3 = $result');  // 5 + 3 = 8

  // Use directly
  print('10 + 20 = ${add(10, 20)}');  // 10 + 20 = 30
}
```

**Key points:**
- Return type is `int` (not `void`)
- `return a + b` sends the result back
- You can save it (`int result`) or use it directly

### Example 2: Calculate Area (with return)

```dart
double calculateArea(double length, double width) {
  return length * width;
}

void main() {
  double room1 = calculateArea(5.0, 4.0);
  double room2 = calculateArea(6.0, 3.5);
  double total = room1 + room2;

  print('Room 1: $room1 sq ft');
  print('Room 2: $room2 sq ft');
  print('Total: $total sq ft');
}
```

### Example 3: Check if Even

```dart
bool isEven(int number) {
  return number % 2 == 0;
}

void main() {
  print(isEven(4));   // true
  print(isEven(7));   // false

  if (isEven(10)) {
    print('10 is even!');
  }
}
```

### Example 4: Get Grade

```dart
String getGrade(int score) {
  if (score >= 90) {
    return 'A';
  } else if (score >= 80) {
    return 'B';
  } else if (score >= 70) {
    return 'C';
  } else if (score >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}

void main() {
  print('Score 95: ${getGrade(95)}');  // A
  print('Score 75: ${getGrade(75)}');  // C
  print('Score 55: ${getGrade(55)}');  // F
}
```

---

## Arrow Functions (=>)

### Purpose
Shorthand for single-expression functions.

### Syntax

```dart
returnType functionName(parameters) => expression;
```

### Example 1: Simple Addition

```dart
// Regular function
int add(int a, int b) {
  return a + b;
}

// Arrow function (same thing!)
int addArrow(int a, int b) => a + b;

void main() {
  print(add(5, 3));        // 8
  print(addArrow(5, 3));   // 8
}
```

### Example 2: Multiple Arrow Functions

```dart
int square(int n) => n * n;
bool isAdult(int age) => age >= 18;
String greet(String name) => 'Hello, $name!';
double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;

void main() {
  print(square(5));                    // 25
  print(isAdult(16));                  // false
  print(greet('Alice'));               // Hello, Alice!
  print(celsiusToFahrenheit(25));      // 77.0
}
```

**When to use arrow functions:**
- ✅ Single expression
- ✅ Simple, obvious logic
- ❌ Multiple statements
- ❌ Complex logic

---

## Optional Parameters

### Positional Optional Parameters

Use `[]` to make parameters optional:

```dart
void greet(String name, [String greeting = 'Hello']) {
  print('$greeting, $name!');
}

void main() {
  greet('Alice');              // Hello, Alice!
  greet('Bob', 'Hi');          // Hi, Bob!
  greet('Charlie', 'Hey');     // Hey, Charlie!
}
```

### Named Optional Parameters

Use `{}` for named parameters:

```dart
void createUser({String name = 'Guest', int age = 0}) {
  print('User: $name, Age: $age');
}

void main() {
  createUser();                           // User: Guest, Age: 0
  createUser(name: 'Alice');              // User: Alice, Age: 0
  createUser(name: 'Bob', age: 25);       // User: Bob, Age: 25
  createUser(age: 30, name: 'Charlie');   // Order doesn't matter!
}
```

### Required Named Parameters

Make named parameters required with `required`:

```dart
void login({required String username, required String password}) {
  print('Logging in $username...');
}

void main() {
  // login();  // ERROR! Missing required parameters

  login(username: 'alice', password: 'secret123');  // OK!
  login(password: 'pass', username: 'bob');         // OK! Order doesn't matter
}
```

### Mixing Parameter Types

```dart
void displayInfo(String name, {required int age, String? city}) {
  print('Name: $name');
  print('Age: $age');
  if (city != null) {
    print('City: $city');
  }
}

void main() {
  displayInfo('Alice', age: 25);
  displayInfo('Bob', age: 30, city: 'NYC');
}
```

---

## Scope - Where Variables Live

### Local Scope

Variables inside a function:

```dart
void testFunction() {
  int localVar = 10;  // Only exists inside this function
  print(localVar);
}

void main() {
  testFunction();
  // print(localVar);  // ERROR! localVar doesn't exist here
}
```

### Global Scope

Variables outside functions:

```dart
int globalVar = 100;  // Available everywhere

void showGlobal() {
  print('Global: $globalVar');
}

void main() {
  print('Global: $globalVar');
  showGlobal();
  globalVar = 200;  // Can modify it
  print('Modified: $globalVar');
}
```

### Parameter Scope

Parameters are local to the function:

```dart
void calculate(int number) {
  int doubled = number * 2;
  print(doubled);
}

void main() {
  calculate(5);
  // print(number);  // ERROR! number only exists in calculate()
  // print(doubled); // ERROR! doubled only exists in calculate()
}
```

---

## Functions Calling Functions

Functions can call other functions:

```dart
int square(int n) {
  return n * n;
}

int sumOfSquares(int a, int b) {
  int squareA = square(a);
  int squareB = square(b);
  return squareA + squareB;
}

void main() {
  print(sumOfSquares(3, 4));  // 3² + 4² = 9 + 16 = 25
}
```

### Example: Temperature Converter

```dart
double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}

void displayTemperature(double celsius) {
  double fahrenheit = celsiusToFahrenheit(celsius);
  print('$celsius°C = $fahrenheit°F');
}

void main() {
  displayTemperature(0);    // 0°C = 32°F
  displayTemperature(25);   // 25°C = 77°F
  displayTemperature(100);  // 100°C = 212°F
}
```

---

## Pure Functions vs Side Effects

### Pure Function

Returns a value, no side effects:

```dart
int add(int a, int b) {
  return a + b;
}
```

### Function with Side Effects

Changes something outside itself (like printing):

```dart
void printSum(int a, int b) {
  print(a + b);  // Side effect: prints to console
}
```

**Best practice:** Prefer pure functions when possible - easier to test and reason about.

---

## Common Patterns

### Pattern 1: Validation

```dart
bool isValidEmail(String email) {
  return email.contains('@') && email.contains('.');
}

bool isValidAge(int age) {
  return age >= 0 && age <= 150;
}

void main() {
  if (isValidEmail('user@example.com')) {
    print('Email is valid');
  }

  if (isValidAge(25)) {
    print('Age is valid');
  }
}
```

### Pattern 2: Transformation

```dart
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String formatPrice(double price) {
  return '\$${price.toStringAsFixed(2)}';
}

void main() {
  print(capitalize('hello'));      // Hello
  print(formatPrice(19.99));       // $19.99
}
```

### Pattern 3: Calculation

```dart
double calculateTax(double price, double rate) {
  return price * rate;
}

double calculateTotal(double price, double taxRate) {
  double tax = calculateTax(price, taxRate);
  return price + tax;
}

void main() {
  double price = 100.0;
  double total = calculateTotal(price, 0.08);
  print('Total: \$${total.toStringAsFixed(2)}');  // Total: $108.00
}
```

### Pattern 4: Decision Making

```dart
String getShippingCost(double orderTotal) {
  if (orderTotal >= 50) {
    return 'FREE';
  } else {
    return '\$5.99';
  }
}

void main() {
  print('Order \$30: Shipping ${getShippingCost(30)}');   // $5.99
  print('Order \$75: Shipping ${getShippingCost(75)}');   // FREE
}
```

---

## Exercises

### Exercise 1: Max Function
Write a function that returns the larger of two numbers.

```dart
int max(int a, int b) {
  // Your code here
}

void main() {
  print(max(10, 20));  // Should print 20
  print(max(5, 3));    // Should print 5
}
```

<details>
<summary>Solution</summary>

```dart
int max(int a, int b) {
  return a > b ? a : b;
}
```
</details>

---

### Exercise 2: Is Prime
Write a function that checks if a number is prime.

```dart
bool isPrime(int n) {
  // Your code here
}

void main() {
  print(isPrime(7));   // true
  print(isPrime(10));  // false
}
```

<details>
<summary>Solution</summary>

```dart
bool isPrime(int n) {
  if (n <= 1) return false;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}
```
</details>

---

### Exercise 3: Count Vowels
Write a function that counts vowels in a string.

```dart
int countVowels(String text) {
  // Your code here
}

void main() {
  print(countVowels('hello'));  // 2 (e, o)
  print(countVowels('dart'));   // 1 (a)
}
```

<details>
<summary>Solution</summary>

```dart
int countVowels(String text) {
  int count = 0;
  String vowels = 'aeiouAEIOU';

  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i])) {
      count++;
    }
  }

  return count;
}
```
</details>

---

### Exercise 4: Format Name
Write a function that formats a name (capitalize first letter, lowercase rest).

```dart
String formatName(String name) {
  // Your code here
}

void main() {
  print(formatName('ALICE'));   // Alice
  print(formatName('bob'));     // Bob
}
```

<details>
<summary>Solution</summary>

```dart
String formatName(String name) {
  if (name.isEmpty) return name;
  String lower = name.toLowerCase();
  return lower[0].toUpperCase() + lower.substring(1);
}
```
</details>

---

### Exercise 5: Calculate Discount
Write a function that calculates the final price after discount.

```dart
double applyDiscount(double price, double discountPercent) {
  // Your code here
}

void main() {
  print(applyDiscount(100, 20));  // 80.0 (20% off)
  print(applyDiscount(50, 10));   // 45.0 (10% off)
}
```

<details>
<summary>Solution</summary>

```dart
double applyDiscount(double price, double discountPercent) {
  double discount = price * (discountPercent / 100);
  return price - discount;
}
```
</details>

---

## Key Takeaways

1. **Functions organize code** into reusable pieces
2. **Parameters** pass data TO functions
3. **Return values** send data BACK from functions
4. **void** means no return value
5. **Arrow functions** (`=>`) for single expressions
6. **Optional parameters** use `[]` or `{}`
7. **required** keyword for mandatory named parameters
8. **Scope** determines where variables exist
9. **Pure functions** are easier to test and reason about

---

## What's Next?

Tomorrow:
- **Lists in detail** - Working with collections
- **List methods** - add, remove, sort, filter
- **Iterating** through lists efficiently

You've unlocked code organization! Functions are the building blocks of all great programs. 🏗️
