# Function Basics: Saving Code So You Can Reuse It

## The Big Idea In One Sentence

> A function is a **piece of code with a name on it**, so you can use it again whenever you want.

That is it. Everything else on this page just shows you how to write one.

> **Heads up.** This first lesson focuses on functions that **just do work** (like printing a message). They do not give back any answer. In `03-ReturnValues.md` you will learn how to make a function hand back an answer. We are taking it one step at a time.

---

## Why Functions Exist (The Real Reason)

Imagine you greet three people in your code:

```dart
void main() {
  print('Welcome, Ada!');
  print('Have a great day, Ada!');

  print('Welcome, Bola!');
  print('Have a great day, Bola!');

  print('Welcome, Chidi!');
  print('Have a great day, Chidi!');
}
```

Look at all that copy-paste. Same recipe, just different names. If you ever want to change the message, you have to change it in three places. Easy to forget one.

A **function** lets you write the recipe once and use it as many times as you want.

```dart
void greet(String name) {
  print('Welcome, $name!');
  print('Have a great day, $name!');
}

void main() {
  greet('Ada');
  greet('Bola');
  greet('Chidi');
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

You do not need to know how the machine works inside. You just need to know:

1. What it is called.
2. What you have to feed it.

That is exactly how you should treat every function you write.

---

## The Four Parts Of A Function

Every function has the same four parts, in the same order:

```dart
void  greet  (String name)  { print('Hello, $name'); }
//↑      ↑         ↑                     ↑
// 1     2         3                     4
```

| # | Part | Example | What it means |
|---|------|---------|---------------|
| 1 | Return type | `void` | What kind of answer comes back |
| 2 | Name | `greet` | What you call it |
| 3 | Parameters | `(String name)` | What you feed in |
| 4 | Body | `{ print('Hello, $name'); }` | The work it does |

For now, every function in this lesson uses **`void`**. `void` is the simplest case. It means:

> "This function does its work, but it does not hand anything back."

You will learn how to make a function hand back an answer in `03-ReturnValues.md`. For now, `void` is all we need.

---

## How To Use A Function

Using a function is called **calling** it. You write its name, then a pair of parentheses with the inputs inside.

```dart
void greet(String name) {
  print('Hello, $name');
}

void main() {
  greet('Ada');     // prints "Hello, Ada"
  greet('Bola');    // prints "Hello, Bola"
}
```

Two important things:

1. **The parentheses are required.** Even if there are no inputs, you still need `()`.
2. **Without parentheses, the function does not run.**

```dart
greet;          // does nothing, just refers to the function
greet('Ada');   // actually runs it
```

This trips up beginners all the time. If you ever wonder "why is my function not running?", check that you wrote `()` at the end.

---

## A Function With No Inputs

Not every function needs inputs. Some just do a job.

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

The same function works for any name you give it. That is the point.

You can have more than one input. Separate them with commas.

```dart
void introduce(String name, int age) {
  print('I am $name, $age years old');
}

void main() {
  introduce('Ada', 25);   // I am Ada, 25 years old
}
```

The next lesson, `02-Parameters.md`, goes much deeper on the four ways to declare inputs.

---

## Naming Your Functions Well

A function's name should be a **verb** (an action word), because functions do things.

Good names:

- `printGreeting`
- `showWelcome`
- `sendEmail`
- `saveProfile`

Bad names:

- `data`, `info`, `helper` (these are nouns, they say nothing about what happens)
- `f`, `g`, `x` (single letters, you will forget what they do in a week)

Pick names that read like sentences:

```dart
welcomeUser('Ada');   // reads like "welcome user Ada"
showError('404');     // reads like "show error 404"
```

You can almost speak that out loud.

---

## Why This Matters In Flutter

Every screen, every button, every list item in a Flutter app is built by a function you write. The shape you just learned, **name plus parentheses plus body**, is the same shape used in every Flutter file.

You will not see a Flutter screen today. We will get there in Level 5. For now, just know: the moment you understand "a function is a named piece of code that does work", you already understand the building block of every Flutter file you will ever read.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting the parentheses

```dart
void sayHello() {
  print('Hello!');
}

void main() {
  sayHello;     // does nothing
  sayHello();   // actually runs
}
```

If your function is not running, check for `()`.

### Mistake 2: Calling without the inputs the function expects

```dart
void greet(String name) {
  print('Hello, $name');
}

void main() {
  greet();        // ERROR: missing the name input
  greet('Ada');   // GOOD
}
```

If a function asks for an input, you must give it one.

### Mistake 3: Forgetting `$` inside the string

```dart
void greet(String name) {
  print('Hello, name');     // prints the word "name"
  print('Hello, $name');    // prints the actual name
}
```

Without `$`, Dart treats `name` as plain text inside the string. With `$`, Dart pulls in the value of the variable.

### Mistake 4: One function doing way too much

If your function is 80 lines long, it is probably five functions in disguise. Split it. A good function does **one thing**.

---

## One-Minute Recap

- A function is a named piece of code you can reuse.
- Four parts: **return type, name, parameters, body**.
- For now, every function uses `void`. That means: it does its work, no answer comes back. Returning answers is taught in `03-ReturnValues.md`.
- Call a function with `()`. No `()` means it does not run.
- Name functions as verbs that describe what they do.

---

## Quick Quiz

**Q1.** Spot the bug.

```dart
void greet(String name) {
  print('Hello, $name');
}

void main() {
  greet;
}
```

<details>
<summary>Answer</summary>
The function is never called because `greet;` is missing the parentheses (and the input). Fix it as `greet('Ada');` to actually run it.
</details>

**Q2.** What does this print?

```dart
void sayHi() {
  print('Hi!');
}

void main() {
  sayHi();
  sayHi();
  sayHi();
}
```

<details>
<summary>Answer</summary>
Three lines, each saying `Hi!`. The function gets called three times, so `Hi!` is printed three times.
</details>

**Q3.** What is a good name for a function that prints a welcome message?

<details>
<summary>Answer</summary>
Names like `printWelcome`, `showWelcome`, or `welcomeUser`. They start with a verb and clearly describe what the function does. Names like `data` or `helper` say nothing.
</details>

**Q4.** Why does this print the word "name" instead of "Ada"?

```dart
void greet(String name) {
  print('Hello, name');
}

void main() {
  greet('Ada');
}
```

<details>
<summary>Answer</summary>
The string is missing the `$`. Without it, `name` is just plain text inside the string. Fix it as `print('Hello, $name');` so Dart pulls in the value of the variable.
</details>

---

## Assignment

### Problem 1: Refactor the repetition

This block prints two lines of greeting for three people. Rewrite it using one `void` function with one input. Then call that function three times to produce the same output.

```dart
void main() {
  print('Welcome, Ada!');
  print('Have a great day, Ada!');

  print('Welcome, Bola!');
  print('Have a great day, Bola!');

  print('Welcome, Chidi!');
  print('Have a great day, Chidi!');
}
```

### Problem 2: Build small functions and call them

Write four `void` functions:

- `printHello()` prints `Hello!`.
- `printGreeting(String name)` prints `Hello, name!` (using the actual name).
- `printAge(String name, int age)` prints `name is age years old` (using the actual values).
- `printSeparator()` prints `----------`.

Then in `main`, call each of them at least once to show they work.

### Problem 3: Predict the output

Without running it, what does this print?

```dart
void shout(String word) {
  print('${word.toUpperCase()}!');
}

void main() {
  shout('hello');
  shout('world');
  shout('flutter');
}
```

### Problem 4: Spot the bugs

Each of these has at least one bug. Find each bug, explain it, and fix it.

```dart
// A
void sayHi {
  print('Hi!');
}

// B
void greet(String name) {
  print('Hello, name');
}

void main() {
  greet('Ada');
}

// C
void announce() {
  print('Important!');
}

void main() {
  announce;
}
```

### Problem 5: A small library

Write a `void` function called `printProfile` that takes three inputs:

- `String name`
- `int age`
- `String city`

It should print three lines:

```
Name: Ada
Age: 25
City: Lagos
```

Then call it twice in `main` for two different people.

---

## Assignment Answers

### Problem 1: Refactor the repetition

```dart
void greet(String name) {
  print('Welcome, $name!');
  print('Have a great day, $name!');
}

void main() {
  greet('Ada');
  greet('Bola');
  greet('Chidi');
}
```

How we did it:

1. **Find the repeated part.** All three blocks print the same two lines. Only the name changes.
2. **Move the work into a function.** The name becomes a parameter (input). The two `print` lines become the body.
3. **Replace each block with one line** that calls the function with a different name.

This is the most important habit you will build with functions: when you see the same operation done with different inputs, that operation belongs in a function.

### Problem 2: Build small functions and call them

```dart
void printHello() {
  print('Hello!');
}

void printGreeting(String name) {
  print('Hello, $name!');
}

void printAge(String name, int age) {
  print('$name is $age years old');
}

void printSeparator() {
  print('----------');
}

void main() {
  printHello();
  printGreeting('Ada');
  printAge('Ada', 25);
  printSeparator();

  printGreeting('Bola');
  printAge('Bola', 30);
  printSeparator();
}
```

Notes:

- `printHello` and `printSeparator` take no inputs. The empty `()` shows that.
- `printGreeting` takes one input.
- `printAge` takes two inputs, separated by a comma.
- Every function uses `void` because none of them gives back an answer. They just print.

### Problem 3: Predict the output

Output:

```
HELLO!
WORLD!
FLUTTER!
```

For each call:

1. `shout('hello')`: `word` is `'hello'`. `word.toUpperCase()` makes it `'HELLO'`. The `${...}` injects that into the string, then we print with a `!` at the end.
2. `shout('world')`: same path, prints `WORLD!`.
3. `shout('flutter')`: same path, prints `FLUTTER!`.

The `${...}` is string interpolation. Inside the curly braces you can put any expression, in this case a method call. The result of that expression goes into the string.

### Problem 4: Spot the bugs

**A.** Missing parentheses on the function declaration.

```dart
void sayHi {           // BAD
  print('Hi!');
}
```

A function name is always followed by `()`, even if there are no inputs.

```dart
void sayHi() {         // GOOD
  print('Hi!');
}
```

**B.** The string uses the word `name` literally instead of the value passed in.

```dart
void greet(String name) {
  print('Hello, name');     // BAD: prints the word "name"
}
```

Fix: use string interpolation with `$`.

```dart
void greet(String name) {
  print('Hello, $name');    // GOOD: prints the actual name
}
```

**C.** `announce;` does not call the function.

```dart
void main() {
  announce;        // does nothing
}
```

Calling a function always needs the parentheses.

```dart
void main() {
  announce();      // GOOD: actually runs
}
```

All three bugs share a theme: the function declaration looks fine on the surface, but something small is wrong. When debugging functions, always check three places:

1. The declaration (do all four parts look right?).
2. The body (is the string correct? are inputs used with `$`?).
3. The call site (parentheses, the right number of inputs).

### Problem 5: A small library

```dart
void printProfile(String name, int age, String city) {
  print('Name: $name');
  print('Age: $age');
  print('City: $city');
}

void main() {
  printProfile('Ada', 25, 'Lagos');
  print('---');
  printProfile('Bola', 30, 'Abuja');
}
```

Output:

```
Name: Ada
Age: 25
City: Lagos
---
Name: Bola
Age: 30
City: Abuja
```

How the design works:

1. **One function, three inputs.** All three pieces are needed for a profile.
2. **The body is just three `print` calls.** Each uses string interpolation to inject the input value.
3. **The function is `void`** because it just does work (printing). It does not give back any answer.

Calling it twice in `main` shows the value of functions: the same work for different inputs, no copy-paste.

---

**Next:** `02-Parameters.md` to learn the four ways to pass data into a function.
