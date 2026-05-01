# Functions: Reusable Blocks Of Code

## Why This Topic Exists

You have been writing all your code inside `main()`. That works for small examples. Real apps have hundreds of operations: validate input, calculate totals, send emails, format dates. If you keep stuffing all of that into `main`, you end up with a single 2000-line file that nobody, including you, can read.

Functions solve this. A function is a **named block of code** that does one job. Once you write it, you can use it as many times as you want, from anywhere.

---

## The Mental Model

A function is like a **machine**.

- It has a name on the side.
- It takes inputs (raw materials).
- It does some work inside.
- It produces an output (a finished product).

You do not need to know how the machine works on the inside. You only need to know:
1. What you have to feed it.
2. What it gives you back.

That is the same way you should treat functions you write. Each function should do **one job**, and the rest of your code should just call it.

---

## Without Functions vs With Functions

Without:

```dart
void main() {
  int len1 = 5, wid1 = 3;
  int area1 = len1 * wid1;
  print(area1);

  int len2 = 8, wid2 = 4;
  int area2 = len2 * wid2;
  print(area2);

  int len3 = 6, wid3 = 2;
  int area3 = len3 * wid3;
  print(area3);
}
```

The same logic, written three times. Boring and bug-prone.

With:

```dart
int areaOf(int length, int width) {
  return length * width;
}

void main() {
  print(areaOf(5, 3));
  print(areaOf(8, 4));
  print(areaOf(6, 2));
}
```

Same result. One source of truth. If we ever change the formula, we change it once.

This is the core promise of functions: **write once, use many times.**

---

## The Anatomy

```dart
int add(int a, int b) {
  return a + b;
}
```

Four parts, in this exact order:

| Part | Example | What it means |
|------|---------|---------------|
| Return type | `int` | The type of value the function gives back |
| Name | `add` | What you call when you want to use it |
| Parameters | `(int a, int b)` | Inputs the function expects |
| Body | `{ return a + b; }` | The work the function does |

If the function does not give anything back (it just does work like printing), the return type is `void`.

---

## Calling A Function

Calling means "run the function now". You write the name, followed by parentheses. Inside the parentheses, you pass values that match the parameters.

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  int result = add(5, 3);     // call it, save the answer
  print(result);              // 8

  print(add(10, 20));         // call it, print the answer directly
}
```

**Watch the parentheses.** Writing `add` without `()` does not call the function. It just refers to the function as a value, which is almost never what a beginner wants.

```dart
add;        // does nothing
add(5, 3);  // runs the function, returns 8
```

---

## `void`: When A Function Returns Nothing

If your function only does work (like printing) and does not need to give back a value, use `void`:

```dart
void greet(String name) {
  print('Hello, $name');
}

void main() {
  greet('Ada');     // prints "Hello, Ada"
}
```

There is no `return` statement, because there is nothing to return. You also cannot save the result to a variable, because there is nothing to save.

```dart
String x = greet('Ada');   // ERROR: cannot store void
```

If you ever need a function to give back a value later, just change `void` to the proper type and add a `return`.

---

## `return`: How A Function Hands Back A Value

`return` does two things at once:

1. It sends the value out of the function.
2. It immediately exits the function. Code after `return` does not run.

```dart
int doubleIt(int n) {
  return n * 2;
  print('this never runs');   // dead code, ignored
}
```

You can also use `return` early to bail out:

```dart
int firstIndexOf(List<int> nums, int target) {
  for (int i = 0; i < nums.length; i++) {
    if (nums[i] == target) {
      return i;     // found it, hand back the index, stop
    }
  }
  return -1;        // got through the whole list, not found
}
```

This is a common pattern: search, return on the first match, return a "not found" value at the end.

---

## Where Functions Live

You can place functions in three different places:

### 1. Top-level (most common)

Outside any other function. They are visible to the whole file.

```dart
int square(int n) => n * n;

void main() {
  print(square(4));
}
```

### 2. Local (inside another function)

Useful for tiny helpers that nobody else needs.

```dart
void main() {
  String shout(String s) => '${s.toUpperCase()}!';
  print(shout('hello'));
}
```

### 3. Inside classes (called *methods*)

You will meet these in Level 4. Same idea, just attached to an object.

---

## Arrow Syntax: One-Line Shortcut

If a function is just a single expression that returns a value, you can write it on one line with `=>`:

```dart
// Long form
int square(int n) {
  return n * n;
}

// Short form
int square(int n) => n * n;
```

`=>` is read as "returns". It only works for functions whose body is a single expression. If you need multiple lines, stick with `{ ... }`.

This shortcut shows up everywhere in Flutter code. Get used to it now.

---

## Naming Rules That Make Code Readable

Function names should be **verbs** because they do something:

- `calculateTotal`, `sendEmail`, `formatDate`. All good.
- `data`, `info`, `helper`. All bad. They are nouns, and they say nothing about what the function does.

Common prefixes that signal what a function returns:

| Prefix | Returns | Example |
|--------|---------|---------|
| `is` | bool | `isAdult(age)` |
| `has` | bool | `hasAccount(user)` |
| `get` | a value | `getUser(id)` |
| `set` | nothing | `setName(value)` |
| `calculate` | a value | `calculateTax(amount)` |

Pick names that read like sentences:

```dart
if (isAdult(age) && hasAccount(user)) { ... }
```

You can almost speak that out loud.

---

## Why This Matters In Flutter

Every Flutter widget you ever build is wrapped in a function. The most common one looks like this:

```dart
Widget build(BuildContext context) {
  return Text('Hello');
}
```

`Widget` is the return type. `build` is the function name. `BuildContext context` is a parameter. `return Text('Hello')` is the body.

Every screen you build, every button, every list item, comes from a function like this. Master functions now and you have already learned the shape of every Flutter file you will ever read.

---

## Common Mistakes

### 1. Forgetting parentheses when calling

```dart
greet;     // does nothing
greet();   // calls the function
```

### 2. Wrong return type

```dart
int add(int a, int b) {
  print(a + b);    // forgot to return
}
```

If the type says `int`, the function must `return` an int.

### 3. Ignoring the return value

```dart
int add(int a, int b) => a + b;

void main() {
  add(5, 3);              // result thrown away
  int x = add(5, 3);      // saved, can be used
  print(x);
}
```

### 4. Doing too much in one function

If your function is 80 lines long, it is not one function, it is five disguised as one. Split it.

---

## Recap In One Minute

- A function is a named block of code that does one job.
- Four parts: return type, name, parameters, body.
- Use `void` when nothing comes back.
- `return` sends a value out and exits the function.
- Arrow syntax `=>` is a one-line shortcut.
- Name functions as verbs. Pick names that read like sentences.

---

## Quick Quiz

**Q1.** Spot the bug:
```dart
int add(int a, int b) {
  print(a + b);
}
```

<details>
<summary>Answer</summary>
The return type is `int` but the function never returns anything. Either change `int` to `void`, or replace `print(a + b)` with `return a + b`.
</details>

**Q2.** What does this print?
```dart
String greet(String name) => 'Hello, $name';

void main() {
  greet('Ada');
}
```

<details>
<summary>Answer</summary>
Nothing. The function returns the string but `main` never prints it. The fix is `print(greet('Ada'));`.
</details>

**Q3.** What is a good name for a function that returns true if a number is even?

<details>
<summary>Answer</summary>
`isEven(int n)`. The `is` prefix tells the reader the function returns a bool.
</details>

**Q4.** Convert this to arrow syntax:
```dart
int triple(int n) {
  return n * 3;
}
```

<details>
<summary>Answer</summary>

```dart
int triple(int n) => n * 3;
```
</details>

---

## Assignment

### Problem 1: Refactor repetition into a function

Take this messy block of code and rewrite it using a single function. Then call that function three times to produce the same output.

```dart
void main() {
  int len1 = 5;
  int wid1 = 3;
  int per1 = 2 * (len1 + wid1);
  print('Perimeter 1: $per1');

  int len2 = 7;
  int wid2 = 4;
  int per2 = 2 * (len2 + wid2);
  print('Perimeter 2: $per2');

  int len3 = 10;
  int wid3 = 6;
  int per3 = 2 * (len3 + wid3);
  print('Perimeter 3: $per3');
}
```

### Problem 2: Function composition

Write three small functions:

- `int addOne(int n)` returns `n + 1`.
- `int doubleIt(int n)` returns `n * 2`.
- `int square(int n)` returns `n * n`.

Then write a fourth function `int processNumber(int n)` that returns the result of applying `addOne`, then `doubleIt`, then `square`, in that order. Predict the result for `n = 3`. Then verify by running.

### Problem 3: Predict and explain

Without running, what does this print? Explain why each line prints what it does.

```dart
int mystery(int x) {
  if (x < 0) return -1;
  if (x == 0) return 0;
  return x * 2;
}

void main() {
  print(mystery(-5));
  print(mystery(0));
  print(mystery(7));
  print(mystery(100));
}
```

### Problem 4: Build a small library

Write four functions in one file, all using arrow syntax where the body is a single expression:

- `bool isEven(int n)`
- `bool isOdd(int n)`
- `int absoluteOf(int n)` (returns the positive version of any number)
- `String describeNumber(int n)` that returns `'positive even'`, `'positive odd'`, `'negative even'`, `'negative odd'`, or `'zero'`.

Hint: `describeNumber` will not be a one-liner. Use a regular block body for that one.

### Problem 5: Spot the bug

Each of these functions has at least one bug. Find them, explain what is wrong, and fix them.

```dart
// A
int multiply(int a, int b) {
  print(a * b);
}

// B
String shout(String text) => text.toUpperCase();

void main() {
  shout('hello');
}

// C
double half(int n) {
  return n / 2;
}

void main() {
  half;
}
```

---

## Assignment Answers

### Problem 1: Refactor repetition into a function

```dart
int perimeterOf(int length, int width) {
  return 2 * (length + width);
}

void main() {
  print('Perimeter 1: ${perimeterOf(5, 3)}');
  print('Perimeter 2: ${perimeterOf(7, 4)}');
  print('Perimeter 3: ${perimeterOf(10, 6)}');
}
```

How the refactor was done:

1. **Identify the repeated pattern.** Three blocks all do the same thing: declare a length, declare a width, compute `2 * (length + width)`, print the result. Only the inputs change.
2. **Pull the calculation into a function.** The function takes the inputs that vary (length, width) and returns the result.
3. **The print statements become single lines that call the function.** String interpolation `${...}` lets us call the function inside the message and convert the result to a string in one step.

This is the single most important lesson about functions. When you see the same operation done with different inputs, that operation belongs in a function.

### Problem 2: Function composition

```dart
int addOne(int n) => n + 1;
int doubleIt(int n) => n * 2;
int square(int n) => n * n;

int processNumber(int n) {
  int step1 = addOne(n);
  int step2 = doubleIt(step1);
  int step3 = square(step2);
  return step3;
}

void main() {
  print(processNumber(3));     // 64
}
```

Walkthrough for `n = 3`:

1. `addOne(3)` returns `4`.
2. `doubleIt(4)` returns `8`.
3. `square(8)` returns `64`.

Final result: 64.

You could also write `processNumber` more compactly by chaining:

```dart
int processNumber(int n) => square(doubleIt(addOne(n)));
```

This is the same logic but read inside-out. The innermost call runs first. Either form works. The first version is friendlier when learning, the chained version is more idiomatic.

### Problem 3: Predict and explain

Output:

```
-1
0
14
200
```

Why each one:

1. `mystery(-5)`: the first `if` matches because `-5 < 0`. We return -1 immediately. The other lines are skipped.
2. `mystery(0)`: the first `if` is false (0 is not less than 0). The second `if` is true (`0 == 0`). We return 0.
3. `mystery(7)`: both `if`s are false (7 is not less than 0, 7 is not 0). We fall through to the last line, return `7 * 2`, which is 14.
4. `mystery(100)`: same as above, return `100 * 2`, which is 200.

This problem reinforces the most important property of `return`: it exits the function. The "early return" pattern means later code only runs if no earlier return matched.

### Problem 4: Build a small library

```dart
bool isEven(int n) => n % 2 == 0;
bool isOdd(int n) => n % 2 != 0;
int absoluteOf(int n) => n < 0 ? -n : n;

String describeNumber(int n) {
  if (n == 0) return 'zero';

  bool positive = n > 0;
  bool even = isEven(n);

  if (positive && even) return 'positive even';
  if (positive && !even) return 'positive odd';
  if (!positive && even) return 'negative even';
  return 'negative odd';
}
```

How the design works:

1. **`isEven` and `isOdd`** use the modulo operator. `n % 2` is the remainder when `n` is divided by 2. Even numbers leave 0, odd numbers leave 1 (or -1 for negative odd).
2. **`absoluteOf`** uses the ternary operator. If the number is negative, flip its sign. Otherwise return as-is.
3. **`describeNumber`** is the only one that needs a block body, because it has more than one return statement. We handle zero first (special case), then split into positive/negative, then split each into even/odd.

We also reuse `isEven` inside `describeNumber`. That is a sign of good function design: small functions get composed into bigger ones.

Quick test:

- `describeNumber(0)` returns `'zero'`.
- `describeNumber(8)` returns `'positive even'`.
- `describeNumber(-7)` returns `'negative odd'`.

### Problem 5: Spot the bug

**A. `int multiply(int a, int b) { print(a * b); }`**

Bug: the return type is `int`, but the function never returns anything. It only prints.

Fix:

```dart
int multiply(int a, int b) {
  return a * b;
}
```

Or change `int` to `void` if printing is really all you wanted.

**B. `void main() { shout('hello'); }`**

Bug: `shout` returns a string, but we never print it. Calling a function and ignoring the return value gives no visible output.

Fix:

```dart
void main() {
  print(shout('hello'));     // HELLO
}
```

**C. `void main() { half; }`**

Bug: `half;` does not call the function. It just refers to the function as a value. Without `()`, no work happens.

Fix:

```dart
void main() {
  print(half(10));     // 5.0
}
```

Notice how all three bugs are very different but share a theme: a function declaration looks correct, but the call site (or the body) is missing the piece that makes it actually do work. When debugging functions, always check three places: the declaration, the body (does it return?), and the call site (parentheses, captured result).

---

**Next:** `02-Parameters.md` to learn the four kinds of parameters Dart supports.
