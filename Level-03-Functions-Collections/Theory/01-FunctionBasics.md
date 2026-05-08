# Function Basics: Saving Code So You Can Reuse It

## The Big Idea In One Sentence

> A function is a **piece of code with a name on it**, so you can use it again whenever you want.

That is it. Everything else on this page just shows you how to write one.

---

## Why Functions Exist (The Real Reason)

Imagine you are writing code that calculates the area of a room. Length times width.

You do it once:

```dart
int length1 = 5;
int width1 = 3;
int area1 = length1 * width1;
print(area1);
```

Then you need to do it for a second room:

```dart
int length2 = 8;
int width2 = 4;
int area2 = length2 * width2;
print(area2);
```

And a third:

```dart
int length3 = 6;
int width3 = 2;
int area3 = length3 * width3;
print(area3);
```

Look at all that copy-paste. Same recipe, different ingredients. If we ever need to change how area is calculated, we have to change it in three places. Easy to forget one.

A **function** lets you write the recipe once and use it as many times as you want.

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

Same result. One recipe. No copy-paste.

That is the whole reason functions exist: **write the recipe once, use it as many times as you want.**

---

## A Picture To Hold In Your Head

Think of a function like a **machine in a factory**:

- It has a **name** painted on the side.
- You feed it **inputs** (raw materials).
- It does its **work** inside.
- It hands you back **an output** (the finished product).

You do not need to know how the machine works inside. You just need to know two things:

1. What you have to feed in.
2. What you get back.

That is exactly how you should think about every function you write.

---

## The Four Parts Of A Function

Every function has the same four parts, in the same order:

```dart
int  add  (int a, int b)  { return a + b; }
//↑     ↑       ↑                  ↑
// 1   2       3                  4
```

| # | Part | Example | What it means |
|---|------|---------|---------------|
| 1 | Return type | `int` | What kind of answer comes back |
| 2 | Name | `add` | What you call it |
| 3 | Parameters | `(int a, int b)` | What you feed in |
| 4 | Body | `{ return a + b; }` | The work it does |

Read it left to right: "return type, name, inputs, body." Every Dart function follows this order.

If the function does not give anything back, write `void` instead of a real type:

```dart
void sayHello() {
  print('hello');
}
```

`void` just means "this function does its job, but does not hand anything back."

---

## How To Use A Function

Using a function is called **calling** it. You write its name, then a pair of parentheses with the inputs inside.

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  int result = add(5, 3);   // call it, catch the answer
  print(result);            // 8

  print(add(10, 20));       // call it directly inside print
}
```

Two important things:

1. **The parentheses are required.** Even if there are no inputs, you still need `()`.
2. **Without parentheses, the function does not run.**

```dart
add;        // does nothing, just refers to the function
add(5, 3);  // actually runs it, gives back 8
```

This trips up beginners all the time. If you ever wonder "why is my function not running?" check that you wrote `()` at the end.

---

## A Function With No Inputs

Not every function needs inputs. Some functions just do a job.

```dart
void sayHello() {
  print('Hello!');
}

void main() {
  sayHello();   // prints "Hello!"
}
```

The empty `()` after the name means "no inputs needed." You still write the parentheses.

---

## A Function With Inputs

Inputs go inside the parentheses. Each one needs a type and a name.

```dart
void greet(String name) {
  print('Hello, $name');
}

void main() {
  greet('Ada');     // Hello, Ada
  greet('Bola');    // Hello, Bola
}
```

The same function works for any name you give it. That is the whole point.

You can have more than one input. Separate them with commas.

```dart
void introduce(String name, int age) {
  print('I am $name, $age years old');
}

void main() {
  introduce('Ada', 25);   // I am Ada, 25 years old
}
```

---

## A Short Way: Arrow Syntax

If your function body is **just one line that gives back an answer**, you can use a shortcut: `=>`.

```dart
// Long way
int square(int n) {
  return n * n;
}

// Short way (same thing)
int square(int n) => n * n;
```

The arrow `=>` reads as "gives back." So `int square(int n) => n * n` reads: "square takes an int and gives back n times n."

Use the arrow when:
- The body is one expression.
- You do not need any `if` statements or extra steps.

For longer bodies, stick with the curly braces.

---

## Naming Your Functions Well

A function's name should be a **verb** (an action word), because functions do things.

Good names:
- `calculateTotal`
- `sendEmail`
- `formatDate`
- `loginUser`

Bad names:
- `data`, `info`, `helper` (these are nouns, they say nothing about what happens)
- `f`, `g`, `x` (single letters, you will forget in a week)

Some name prefixes have a clear meaning to other programmers:

| Prefix | Means | Example |
|--------|-------|---------|
| `is` | gives back true/false | `isAdult(age)` |
| `has` | gives back true/false | `hasAccount(user)` |
| `get` | gives back a value | `getUser(id)` |
| `set` | changes something, no answer | `setName('Ada')` |
| `calculate` | does math, gives an answer | `calculateTax(amount)` |

Names like these make code read like sentences:

```dart
if (isAdult(age) && hasAccount(user)) {
  // do something
}
```

You can almost read that out loud in plain English.

---

## Why This Matters In Flutter

Every screen in Flutter is built by a function. The most common one looks like this:

```dart
Widget build(BuildContext context) {
  return Text('Hello');
}
```

Look at the four parts:

- Return type: `Widget`
- Name: `build`
- Input: `BuildContext context`
- Body: returns a `Text` widget

The moment you understand functions, you already understand the shape of every Flutter screen you will ever see.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting the parentheses

```dart
greet;     // does nothing
greet();   // actually runs the function
```

If your function is not running, check for `()`.

### Mistake 2: Promising to return something but not doing it

```dart
int add(int a, int b) {
  print(a + b);    // forgot to return
}
```

You said `int` at the top. Dart expects `return ...;` somewhere. Either return the answer, or change the type to `void`.

### Mistake 3: Calling but not using the answer

```dart
int doubleIt(int n) => n * 2;

void main() {
  doubleIt(5);   // calculated 10, then threw it away
}
```

The function did its job. But we did not catch the answer. Nothing prints.

Fix it:

```dart
void main() {
  print(doubleIt(5));   // 10
}
```

### Mistake 4: One function doing way too much

If your function is 80 lines long, it is probably five functions in disguise. Split it. A good function does **one thing**.

---

## One-Minute Recap

- A function is a named piece of code you can reuse.
- Four parts: **return type, name, parameters, body**.
- Use `void` when there is no answer to give back.
- Call a function with `()`. No `()` means it does not run.
- Use arrow `=>` for short, one-line bodies.
- Name functions as verbs that describe what they do.

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
The return type is `int` but the function never uses `return`. Either change `int` to `void`, or replace `print(a + b)` with `return a + b`.
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
Nothing. The function returns the string but `main` never prints it. Fix it with `print(greet('Ada'));`.
</details>

**Q3.** What is a good name for a function that returns true if a number is even?

<details>
<summary>Answer</summary>
`isEven(int n)`. The `is` prefix tells the reader the function gives back true or false.
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

### Problem 1: Refactor the repetition

This block of code repeats the same calculation three times. Rewrite it using a single function, then call that function three times.

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

### Problem 2: Build small functions, then combine them

Write three tiny functions:

- `int addOne(int n)` gives back `n + 1`.
- `int doubleIt(int n)` gives back `n * 2`.
- `int square(int n)` gives back `n * n`.

Then write a fourth function `int processNumber(int n)` that uses `addOne` first, then `doubleIt`, then `square`, in that order.

Predict what `processNumber(3)` returns. Then run it and check.

### Problem 3: Predict the output

Without running it, what does this print?

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

Write four functions in one file. Use arrow syntax where the body is one expression.

- `bool isEven(int n)`
- `bool isOdd(int n)`
- `int absoluteOf(int n)` gives back the positive version of any number.
- `String describeNumber(int n)` gives back `'positive even'`, `'positive odd'`, `'negative even'`, `'negative odd'`, or `'zero'`.

Hint: `describeNumber` cannot be a one-liner. Use a regular block body for that one.

### Problem 5: Spot the bug

Each of these has at least one bug. Find each one, explain it, and fix it.

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

### Problem 1: Refactor the repetition

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

How we did it:

1. **Find the repeated part.** All three blocks calculate `2 * (length + width)`. Only the inputs change.
2. **Move the calculation into a function.** The inputs (length, width) become parameters. The result is what we return.
3. **Replace each block with one line** that calls the function.

This is the most important habit you will build with functions: when you see the same operation repeated with different inputs, that operation belongs in a function.

### Problem 2: Combine small functions

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
  print(processNumber(3));   // 64
}
```

For `n = 3`:

1. `addOne(3)` gives back `4`.
2. `doubleIt(4)` gives back `8`.
3. `square(8)` gives back `64`.

Final answer: 64.

You can also write `processNumber` more compactly by chaining:

```dart
int processNumber(int n) => square(doubleIt(addOne(n)));
```

The innermost call runs first. Both versions do the same thing. The first one is friendlier when learning. The second is shorter.

### Problem 3: Predict the output

Output:

```
-1
0
14
200
```

Walk through each call:

1. `mystery(-5)`: `-5 < 0` is true. Return -1 right away. Skip the rest.
2. `mystery(0)`: `0 < 0` is false. Then `0 == 0` is true. Return 0.
3. `mystery(7)`: both `if`s are false. Fall through to `return x * 2` = 14.
4. `mystery(100)`: same path as 7. Return 200.

This problem teaches the most important property of `return`: it stops the function. Code after a matched return never runs.

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

1. **`isEven` and `isOdd`** use the modulo operator `%`. `n % 2` is the leftover when you divide n by 2. Even numbers leave 0.
2. **`absoluteOf`** uses the ternary `?` operator. If n is negative, flip the sign. Otherwise leave it.
3. **`describeNumber`** has more than one branch, so it needs a block body. We handle zero first as a special case, then split the other cases.

Notice how `describeNumber` reuses `isEven`. This is a sign of good function design: small functions plug into bigger ones.

### Problem 5: Spot the bug

**A.** Says `int` at the top but never returns.

```dart
int multiply(int a, int b) {
  print(a * b);
}
```

Fix: replace `print` with `return`.

```dart
int multiply(int a, int b) {
  return a * b;
}
```

**B.** Calls `shout('hello')` but never prints the answer.

```dart
void main() {
  shout('hello');   // 'HELLO' was made, then thrown away
}
```

Fix:

```dart
void main() {
  print(shout('hello'));   // HELLO
}
```

**C.** `half;` does not call the function. Missing `()` and an input.

```dart
void main() {
  half;     // does nothing
}
```

Fix:

```dart
void main() {
  print(half(10));   // 5.0
}
```

All three bugs share a theme: the function declaration looks fine, but something is wrong at the call site or in the body. When debugging functions, always check three places:

1. The declaration (do the parts match?).
2. The body (does it actually return?).
3. The call site (parentheses, captured answer).

---

**Next:** `02-Parameters.md` to learn the four ways to pass data into a function.
