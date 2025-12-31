# Part 4: var, final, and const

You've been using explicit types like `String name = 'Alex'`. Now let's learn other ways to create variables!

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
int parsedValue = parse(someString);

// Use var when it's obvious
var name = 'Alex';
var count = 0;
var isActive = true;
```

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

**Example:**
```dart
void main() {
  final currentTime = DateTime.now();
  final userName = getUserName();

  // Can't change these after they're set
  // currentTime = DateTime.now();  // ❌ ERROR
}
```

### `const` - Compile-Time Constant

```dart
const double pi = 3.14159;
const int maxUsers = 100;

pi = 3.14;  // ❌ ERROR - can't change const
```

Use `const` when the value is known BEFORE the program runs.

**Example:**
```dart
const int maxAttempts = 3;
const double taxRate = 0.08;
const String appName = 'MyApp';
```

---

## When to Use Which?

```dart
// var - normal variable that can change
var score = 0;
score = 10;  // ✅ OK

// final - set once at runtime, then unchangeable
final userId = generateId();
// userId = generateId();  // ❌ ERROR

// const - value known before program runs
const maxLoginAttempts = 3;
// maxLoginAttempts = 5;  // ❌ ERROR
```

### Visual Guide

```
┌─────────────────────────────────────────────┐
│  var    → Can change, type inferred         │
│  final  → Set once (at runtime)             │
│  const  → Fixed value (at compile time)     │
└─────────────────────────────────────────────┘
```

---

## Practical Examples

### Example 1: Mix of All Types

```dart
void main() {
  // var - can change
  var currentLevel = 1;
  currentLevel = 2;  // ✅ OK

  // final - set once at runtime
  final startTime = DateTime.now();

  // const - fixed value
  const maxLevels = 10;

  print('Level: $currentLevel / $maxLevels');
  print('Started at: $startTime');
}
```

### Example 2: Configuration

```dart
void main() {
  // Constants for configuration
  const String apiUrl = 'https://api.example.com';
  const int timeout = 30;
  const bool debugMode = false;

  // Final for user-specific data
  final String userId = getCurrentUserId();
  final String sessionToken = generateToken();

  print('API: $apiUrl');
  print('User: $userId');
}
```

---

## The Difference Between final and const

```dart
// final - value set when program runs
final time1 = DateTime.now();  // ✅ OK - runtime value
final time2 = DateTime.now();  // Different value!

// const - must be known before program runs
const time3 = DateTime.now();  // ❌ ERROR - can't use runtime value
const maxValue = 100;          // ✅ OK - known at compile time
```

---

## Summary Cheat Sheet

```dart
// Explicit type - clear but verbose
String name = 'Alex';

// var - type inferred, can change
var name = 'Alex';
name = 'Bob';  // ✅ OK

// final - set once at runtime
final name = 'Alex';
// name = 'Bob';  // ❌ ERROR

// const - compile-time constant
const name = 'Alex';
// name = 'Bob';  // ❌ ERROR
```

---

## Practice Exercise

Create a program with:
1. A `const` for app version (e.g., "1.0.0")
2. A `final` for launch time (use `DateTime.now()`)
3. A `var` for user score that starts at 0
4. Increase the score by 10
5. Print all values

---

## Quick Quiz

**Q1:** What's the difference between `final` and `const`?

<details>
<summary>Answer</summary>
`final` is set once at runtime. `const` must be a compile-time constant (known before the program runs).
</details>

**Q2:** Why won't this work?
```dart
final name = 'Alex';
name = 'Bob';
```

<details>
<summary>Answer</summary>
`final` variables can only be assigned once. After `name = 'Alex'`, it can't be changed.
</details>

**Q3:** Can you use `var` with a final?

<details>
<summary>Answer</summary>
No, use `final name = 'Alex'` not `var final name = 'Alex'`. But `final` has type inference built-in.
</details>

---

**Congratulations!** You now understand variables completely!

**Next:** Let's dive into working with Strings in detail.

**Continue to:** `03-Strings.md`
