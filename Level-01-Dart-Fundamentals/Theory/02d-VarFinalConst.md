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

## Assignment

### Problem 1: Pick var, final, or const

For each scenario, decide which keyword you would use. Justify briefly.

1. The user's name, set when they log in.
2. The maximum login attempts, the same for the whole app (3).
3. A counter that goes up every time a button is tapped.
4. The app's brand color, the same for every screen.
5. The current page number when paginating a list.
6. The launch year of the app (2026).

### Problem 2: Predict the errors

Each line below tries to do something illegal. Which lines compile? Which fail? Explain why.

```dart
void main() {
  var a = 10;
  a = 20;
  a = 'hello';

  final b = 10;
  b = 20;

  const c = 10;
  c = 20;

  final d;
  d = 5;
  d = 6;
}
```

### Problem 3: const list vs final list

Predict the behaviour. Which line throws and which line works?

```dart
void main() {
  final fruits = ['apple', 'banana'];
  fruits.add('cherry');
  print(fruits);

  const colors = ['red', 'green'];
  colors.add('blue');
  print(colors);
}
```

### Problem 4: Build a config

Create a small program that simulates an app config. It should have:

- A `const` for the app name (`'Evvy Hairs'`).
- A `const` for the launch year (`2026`).
- A `final` for the user's session ID (decided at runtime).
- A regular `var` for the current cart count, that changes during the program.

Set them up, change the cart count three times, then print everything.

### Problem 5: Spot the design issue

Look at this code and explain why every variable should be `final` instead of `var`. What problem does the current code allow?

```dart
void calculateBill() {
  var basePrice = 100.0;
  var quantity = 5;
  var subtotal = basePrice * quantity;

  // ...later in the function...
  basePrice = 200.0;     // someone changed it!
  print('Subtotal was: $subtotal');
}
```

---

## Assignment Answers

### Problem 1: Pick var, final, or const

| Scenario | Choice | Why |
|----------|--------|-----|
| User's name from login | `final` | known at runtime, never changes after login |
| Max login attempts (3) | `const` | known at compile time, fixed forever |
| Tap counter | `var` | needs to change every tap |
| Brand color | `const` | fixed at compile time, used everywhere |
| Current page number | `var` | changes as user paginates |
| Launch year (2026) | `const` | fixed forever, known when code is written |

The decision tree:

1. Will the value change during the program? Yes -> `var`.
2. Set once and never changes again, but the value is known only at runtime? -> `final`.
3. Known at compile time and never changes? -> `const`.

`const` is the strictest. Use it whenever you can, then `final`, then `var`.

### Problem 2: Predict the errors

```dart
var a = 10;
a = 20;             // ok, var allows reassignment to same type
a = 'hello';        // ERROR: var locks in type, a is int

final b = 10;
b = 20;             // ERROR: final cannot be reassigned

const c = 10;
c = 20;             // ERROR: const cannot be reassigned

final d;            // ok, declare without initial value
d = 5;              // ok, set once
d = 6;              // ERROR: final can only be assigned once
```

The lessons:

- `var` allows reassignment, but only to the same type.
- `final` allows exactly one assignment. After that, locked.
- `const` is the same as final but stricter (must be known at compile time).
- A `final` variable can be declared without an initial value, then assigned later, but only once.

### Problem 3: const list vs final list

```dart
final fruits = ['apple', 'banana'];
fruits.add('cherry');     // works, prints [apple, banana, cherry]

const colors = ['red', 'green'];
colors.add('blue');       // ERROR at runtime
```

Why the difference:

- `final` means the variable cannot be reassigned to a new list. But the list itself is still mutable. You can add, remove, or change items.
- `const` means the list itself is immutable. You cannot add, remove, or change anything inside it.

So `final` is about the **variable**, while `const` is about the **value** (and the variable, since you cannot reassign a const variable either).

If you want a list that cannot be reassigned **and** cannot be modified, use `const`.

### Problem 4: Build a config

```dart
void main() {
  const String appName = 'Evvy Hairs';
  const int launchYear = 2026;
  final String sessionId = 'sess_${DateTime.now().millisecondsSinceEpoch}';
  var cartCount = 0;

  cartCount = 1;
  cartCount = 3;
  cartCount = 5;

  print('App: $appName ($launchYear)');
  print('Session: $sessionId');
  print('Cart items: $cartCount');
}
```

Why each choice:

- `appName` and `launchYear` are `const`. They are part of the app's identity, fixed forever, known at compile time.
- `sessionId` is `final`. It is set once at app start using a runtime value (the current time). After that, it never changes.
- `cartCount` is `var`. It changes every time the user adds or removes a product.

This is the typical shape of a real app: a few constants, a few values fixed at startup, and the rest that changes during runtime.

### Problem 5: Spot the design issue

The problem: `basePrice` and `quantity` are declared with `var`. That means they can be changed at any point in the function. The line `basePrice = 200.0;` changes the value **after** `subtotal` was already computed. That is misleading: the printed subtotal still shows 500 (5 * 100), but the new `basePrice` is 200. A reader of the code might assume the subtotal was based on 200.

Better design:

```dart
void calculateBill() {
  final basePrice = 100.0;
  final quantity = 5;
  final subtotal = basePrice * quantity;

  // basePrice = 200.0;     // would now fail to compile
  print('Subtotal was: $subtotal');
}
```

Now the compiler refuses to allow the reassignment. The values are pinned. If someone tries to change `basePrice`, they get an error and have to think about it.

The principle: **`final` by default**. Use `var` only when you actually need the value to change. This prevents bugs where someone modifies a value you assumed was fixed.

---

**Congratulations!** You now understand variables completely!

**Next:** Let's dive into working with Strings in detail.

**Continue to:** `03-Strings.md`
