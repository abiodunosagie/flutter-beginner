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

**Next:** Learn about advanced variable concepts like `var`, `final`, and `const`!

**Continue to:** `02d-VarFinalConst.md`
