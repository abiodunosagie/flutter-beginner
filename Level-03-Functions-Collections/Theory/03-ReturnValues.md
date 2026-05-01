# Return Values: What A Function Hands Back

## Why This Topic Exists

A function that only does work (like `print`) is useful, but limited. The most powerful pattern in programming is:

> Take some input, do some work, hand back a result.

That "hand back a result" piece is the **return value**. A function that returns a value is one you can use as a building block in larger expressions.

---

## The Mental Model

A function with a return value is like a **vending machine**:

- You feed it inputs (arguments).
- It does some work inside.
- It hands you something back (the return value).

Once you have what it returned, you can do anything with it: store it, print it, pass it to another function, or use it in a calculation.

---

## The Two Pieces That Must Match

```dart
int add(int a, int b) {
  return a + b;
}
```

Two pieces have to agree:

1. The **return type** at the top, here `int`.
2. The actual value passed to `return`, here `a + b`, which is an `int`.

If they do not match, the program does not compile.

```dart
int add(int a, int b) {
  return 'hello';     // ERROR: not an int
}
```

This rule is your safety net. The compiler refuses to let you forget what your function is supposed to give back.

---

## Common Return Types

```dart
int   age()   => 25;
double price() => 19.99;
String name()  => 'Ada';
bool  isAdult(int age) => age >= 18;
List<int>          numbers() => [1, 2, 3];
Map<String, int>   scores()  => {'Ada': 95, 'Bola': 87};
```

The arrow syntax `=>` is the one-liner version of `{ return ...; }`. Both forms mean the same thing.

---

## `void`: When Nothing Is Returned

If your function does work but does not give a value back, the return type is `void`.

```dart
void log(String message) {
  print('[LOG] $message');
}
```

You cannot store the result of a `void` function:

```dart
String x = log('hi');     // ERROR
```

You also do not need a `return` statement. The function ends when the last line runs.

---

## `return` Stops The Function

The moment a `return` runs, the function exits. Any code after it is dead.

```dart
int example() {
  return 5;
  print('this never prints');
}
```

This is useful for **early exit** when something is wrong:

```dart
String grade(int score) {
  if (score < 0 || score > 100) {
    return 'Invalid';     // bail out, do not continue
  }

  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}
```

This pattern, "check the bad cases first and return early", is one of the most common shapes in clean code.

---

## Returning A "Maybe": Nullable Return Types

Sometimes a function might not have an answer. Add a `?` to the return type to say "this might be null":

```dart
String? findUser(int id) {
  if (id == 1) return 'Ada';
  if (id == 2) return 'Bola';
  return null;     // not found
}
```

When you call it, you handle both cases:

```dart
String? user = findUser(99);

if (user != null) {
  print('Found $user');
} else {
  print('No user');
}

// shorter, with the ?? operator from Level 1
print(findUser(99) ?? 'No user');
```

`??` reads as "or use this default if the left side is null".

This is the standard pattern for lookups, searches, and any function that may legitimately come up empty.

---

## Arrow Syntax (Recap From Functions Basics)

If the body is a single expression, you can use `=>`:

```dart
// Long form
bool isEven(int n) {
  return n % 2 == 0;
}

// Short form
bool isEven(int n) => n % 2 == 0;
```

Use the long form when:
- You need multiple statements.
- You want to add an early-return.

Otherwise prefer the arrow form. It is shorter and more idiomatic.

---

## Bonus: Anonymous Functions (Functions Without A Name)

Sometimes you need a function for one quick task and you do not want to name it. These are called **anonymous functions** or **lambdas**.

```dart
// Named function
int doubleIt(int n) => n * 2;

// Same thing, anonymous
(int n) => n * 2;
```

The most common place to use them is when you pass a function as an argument:

```dart
List<int> nums = [1, 2, 3, 4, 5];

// Map every number to its double, anonymously
var doubled = nums.map((n) => n * 2).toList();
print(doubled);    // [2, 4, 6, 8, 10]
```

`map` is a method on lists that takes a function and applies it to every item. We will see more of this in the Lists lesson.

> **A note for teachers:** This is the first time students see "a function as an argument". It feels strange. Use this exact line: "A function is just a value, like a number or a string. You can pass it around the same way." Then move on. Closures and higher-order functions can wait until Level 4.

---

## Why This Matters In Flutter

Many Flutter callbacks are functions that you pass as arguments:

```dart
ElevatedButton(
  onPressed: () {
    print('Tapped');
  },
  child: Text('Tap me'),
)
```

The `onPressed:` value is an anonymous function. Flutter calls it when the user taps the button.

You will write hundreds of these. Knowing that "a function can be a value" is the door to all of Flutter's interactive UI.

---

## Common Mistakes

### 1. Mismatched return type and value

```dart
int wrong() {
  return 'hi';     // ERROR
}
```

### 2. Missing return on a non-void function

```dart
int wrong(int a) {
  if (a > 0) return a;
  // ERROR: nothing returned when a <= 0
}
```

Either return in every branch, or return one default value at the end.

### 3. Storing the result of a void function

```dart
void f() { }
var x = f();    // ERROR: void cannot be stored
```

### 4. Using `=>` for multi-line bodies

```dart
int sumAndDouble(int a, int b) =>
  int s = a + b;          // ERROR: arrow needs an expression
  return s * 2;
```

The fix is to switch to `{ ... }`:

```dart
int sumAndDouble(int a, int b) {
  int s = a + b;
  return s * 2;
}
```

---

## Recap In One Minute

- The return type at the top must match what `return` actually hands back.
- `return` ends the function immediately.
- `void` means "returns nothing".
- A `?` after the type means "might be null".
- Arrow `=>` is for single-expression bodies.
- Anonymous functions are functions without a name, most often passed as arguments.

---

## Quick Quiz

**Q1.** What is the bug?
```dart
int score(int grade) {
  if (grade > 50) return 1;
}
```

<details>
<summary>Answer</summary>
The function only returns when `grade > 50`. Otherwise it returns nothing, which is illegal for `int`. Add `return 0;` (or some default) at the end.
</details>

**Q2.** Convert to arrow:
```dart
String greet(String name) {
  return 'Hello, $name';
}
```

<details>
<summary>Answer</summary>

```dart
String greet(String name) => 'Hello, $name';
```
</details>

**Q3.** What does this print?
```dart
String? lookup(int id) {
  if (id == 1) return 'Ada';
  return null;
}

void main() {
  print(lookup(7) ?? 'Unknown');
}
```

<details>
<summary>Answer</summary>
`Unknown`. `lookup(7)` returns null, and `??` falls back to 'Unknown'.
</details>

**Q4.** What is the type of this expression?
```dart
(int n) => n * 2
```

<details>
<summary>Answer</summary>
A function that takes an `int` and returns an `int`. Written formally: `int Function(int)`.
</details>

---

## Assignment

### Problem 1: Add return types and `return`

Each of these functions is broken. Either the return type is missing, the return is missing, or both. Fix each one.

```dart
// A
add(int a, int b) {
  return a + b;
}

// B
int subtract(int a, int b) {
  a - b;
}

// C
greaterOf(int a, int b) {
  if (a > b) return a;
}
```

### Problem 2: Nullable returns and `??`

Write a function `int? findFirstEven(List<int> nums)` that returns the first even number in the list, or null if there is none. Test on:

- `[1, 3, 4, 5]` (expected: 4)
- `[1, 3, 5, 7]` (expected: null)

Then write `int firstEvenOrZero(List<int> nums)` that returns the first even number, or 0 if there is none. Build it using `findFirstEven` and the `??` operator. Do not duplicate the loop.

### Problem 3: Convert all to arrow

Convert each of these to arrow syntax. If a function cannot be converted, explain why.

```dart
// A
bool isPositive(int n) {
  return n > 0;
}

// B
String greet(String name) {
  return 'Hello, $name';
}

// C
int absolute(int n) {
  if (n < 0) return -n;
  return n;
}

// D
double average(int a, int b) {
  return (a + b) / 2;
}
```

### Problem 4: Predict and explain the chain

Without running, what does this print?

```dart
String? lookup(int id) {
  if (id == 1) return 'Ada';
  if (id == 2) return 'Bola';
  return null;
}

String formatUser(int id) {
  return lookup(id)?.toUpperCase() ?? 'No such user';
}

void main() {
  print(formatUser(1));
  print(formatUser(2));
  print(formatUser(99));
}
```

### Problem 5: Use anonymous functions

Given this list, write code that uses **only `map`, `where`, and an anonymous function** to produce a new list of the doubled values of the even numbers.

```dart
List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8];
// Expected output: [4, 8, 12, 16]
```

In your answer, explain the role of each step in the chain.

---

## Assignment Answers

### Problem 1: Add return types and `return`

**A: missing return type.**

```dart
int add(int a, int b) {
  return a + b;
}
```

A function declaration without a return type compiles, but Dart treats the type as `dynamic`, which loses type safety. Always declare the return type explicitly.

**B: missing `return` keyword.**

```dart
int subtract(int a, int b) {
  return a - b;
}
```

The original `a - b;` computed the difference and threw it away. The `return` keyword is what hands the value back to the caller.

**C: missing return for the case `a <= b`.**

```dart
int greaterOf(int a, int b) {
  if (a > b) return a;
  return b;
}
```

If `a > b` is false, the original function fell off the end without returning anything. That is illegal for a non-void function. Either return in every branch, or add a default return at the bottom.

### Problem 2: Nullable returns and `??`

```dart
int? findFirstEven(List<int> nums) {
  for (var n in nums) {
    if (n.isEven) return n;
  }
  return null;
}

int firstEvenOrZero(List<int> nums) {
  return findFirstEven(nums) ?? 0;
}
```

How this works:

1. **`findFirstEven` returns `int?`.** That is the right type because the answer might not exist. We loop over the list and return the first even number we find. If the loop finishes without finding one, we return `null`.
2. **`firstEvenOrZero` reuses `findFirstEven`.** The `??` operator says "if the left side is null, use the right side instead". So if `findFirstEven` returns null, we return 0. Otherwise we return whatever it found.

This is a powerful pattern. The lower-level function honestly says "I might not find anything". A higher-level function can convert that null into whatever default it wants. Different callers can use different defaults without us touching `findFirstEven`.

### Problem 3: Convert all to arrow

**A:** `bool isPositive(int n) => n > 0;`

The body is a single expression `n > 0`. Arrow form fits perfectly.

**B:** `String greet(String name) => 'Hello, $name';`

Single expression with string interpolation. Arrow.

**C: cannot convert directly.** The body has an `if` statement and two `return`s. Arrow needs a single expression. We **can** convert it using the ternary operator, which is an expression:

```dart
int absolute(int n) => n < 0 ? -n : n;
```

This is a valid alternative when the logic is simple enough to fit in a ternary.

**D:** `double average(int a, int b) => (a + b) / 2;`

Single expression. Arrow form is straightforward.

### Problem 4: Predict and explain the chain

Output:

```
ADA
BOLA
No such user
```

How each line resolves:

1. `formatUser(1)`: `lookup(1)` returns `'Ada'`. The `?.` operator on a non-null value calls the method. `'Ada'.toUpperCase()` is `'ADA'`. The `??` is not needed because the left side is not null. We print `'ADA'`.
2. `formatUser(2)`: `lookup(2)` returns `'Bola'`. Same path. We print `'BOLA'`.
3. `formatUser(99)`: `lookup(99)` returns `null`. The `?.` operator on null **does not** call `toUpperCase`. Instead the whole `?.toUpperCase()` expression evaluates to null. Then `?? 'No such user'` substitutes the right side. We print `'No such user'`.

This problem brings together three null-aware operators:

- `?.` calls a method only if the left side is not null.
- `??` provides a default if the left side is null.
- A nullable return type `String?` is the trigger that makes both safe.

Once you grok this chain, you can write very compact null-safe code.

### Problem 5: Use anonymous functions

```dart
List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8];

List<int> result = nums
    .where((n) => n.isEven)
    .map((n) => n * 2)
    .toList();

print(result);     // [4, 8, 12, 16]
```

How the chain works, step by step:

1. **`nums.where((n) => n.isEven)`** keeps only the items where the function returns true. Even numbers in our list: 2, 4, 6, 8.
2. **`.map((n) => n * 2)`** transforms every item by the function. Each remaining number is doubled: 4, 8, 12, 16.
3. **`.toList()`** finalises the chain into a real `List`. Without this you would get an `Iterable`, which is fine for some uses but not when you need a List.

The two anonymous functions are `(n) => n.isEven` and `(n) => n * 2`. Each takes one int parameter and returns one value (a bool, then an int). They are passed into `where` and `map` as arguments. This is exactly the "function is a value" idea from the lesson.

You could write the same logic with a regular for loop and a temporary list, but it would be longer and noisier. The chain version expresses the intent in three short lines: filter, transform, collect.

---

**Next:** `04-Lists.md` to learn how to store and work with collections of values.
