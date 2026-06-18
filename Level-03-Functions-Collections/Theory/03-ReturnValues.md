# Return Values: How A Function Sends An Answer Back

## The Big Idea In One Sentence

> Some functions just **do stuff**. Other functions **give you an answer back**. That answer is called the **return value**.

That is the whole topic. Now we explain it slowly.

---

## A Picture You Already Know

Think of a vending machine.

1. You put coins in (that is the **input**).
2. The machine does its work inside (you do not need to know how).
3. A snack drops out (that is the **answer**, the **return value**).

A function works the exact same way. You hand it some inputs. It does its job. It hands you back an answer.

```
You ──▶ [ function ] ──▶ answer
        does its job
```

That arrow on the right, the one pointing back to you, is the **return value**.

---

## The Smallest Possible Example

```dart
int addTwoNumbers(int a, int b) {
  return a + b;
}
```

Read it like this in plain English:

- "Make a function called `addTwoNumbers`."
- "It needs two numbers, `a` and `b`."
- "It will give back an `int` (a whole number)."
- "The answer it gives back is `a + b`."

Now we use it:

```dart
void main() {
  int answer = addTwoNumbers(3, 4);
  print(answer);   // 7
}
```

Three things happened on that one line:

1. We **called** `addTwoNumbers` with the numbers 3 and 4.
2. The function did its work and gave back `7`.
3. We caught that `7` and put it inside a box called `answer`.

That catching part is the new idea. The function throws you the answer. The variable on the left catches it.

---

## The Two Words That Matter Most

There are only two new words on this page. Learn these and the rest is easy.

### Word 1: The Return Type

The very first word in the function tells you **what kind of answer it gives back**.

```dart
int  addTwoNumbers(int a, int b) { ... }
//↑
// "I will give you back an int"
```

Some examples:

```dart
int     getAge()      { ... }   // gives back a whole number
double  getPrice()    { ... }   // gives back a decimal number
String  getName()     { ... }   // gives back text
bool    isAdult()     { ... }   // gives back true or false
```

### Word 2: The `return` Keyword

Inside the function, the word `return` is how you actually **send the answer out**.

```dart
int addTwoNumbers(int a, int b) {
  return a + b;   // <- "send a + b back to whoever called me"
}
```

No `return` means no answer comes back. We will see why that is a problem in a minute.

---

## The Golden Rule

> Whatever you wrote at the top must match what you `return`.

If you said the function returns an `int`, then `return` must hand back an `int`.

```dart
int addTwoNumbers(int a, int b) {
  return a + b;        // GOOD: a + b is an int
}

int wrongExample(int a, int b) {
  return 'hello';      // BAD: that is a String, not an int
}
```

Dart will refuse to run the second one. It is like a vending machine that promised a snack but tried to drop a sock instead. Not allowed.

---

## What If The Function Has No Answer?

Some functions just **do** something. They do not give anything back. Like a function that just prints a message.

For these, we use a special word: **`void`**.

```dart
void sayHello(String name) {
  print('Hello, $name');
}
```

`void` means "this function does its job but does not hand anything back".

You also do not need to write `return` inside a `void` function. There is nothing to send out.

If you try to catch the answer of a void function, Dart will stop you:

```dart
void sayHello(String name) {
  print('Hello, $name');
}

void main() {
  String x = sayHello('Ada');   // ERROR: there is nothing to catch
}
```

That is correct. There was no answer to catch in the first place.

---

## Catching The Answer (Or Not)

You can do three things with a function that gives back an answer.

### 1. Catch it in a variable

```dart
int answer = addTwoNumbers(2, 3);
print(answer);   // 5
```

### 2. Use it right away inside another piece of code

```dart
print(addTwoNumbers(2, 3));   // 5
```

Here `print` is the one that catches the answer.

### 3. Throw it away (almost never useful)

```dart
addTwoNumbers(2, 3);   // The 5 is calculated, then nothing happens with it
```

This is legal but pointless. You did the work and threw the answer in the trash.

---

## `return` Also Stops The Function

Here is the second important thing about `return`. The moment Dart hits a `return`, the function is **done**. Anything after it never runs.

```dart
int example() {
  return 5;
  print('this never prints');   // dead, never runs
}
```

Why does this matter? Because we can use `return` to **leave the function early** when we already know the answer.

Look at this grade function:

```dart
String getGrade(int score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}
```

Read it from top to bottom:

- "Is the score 90 or more? Send back 'A' and stop."
- "Otherwise, is it 80 or more? Send back 'B' and stop."
- "And so on."
- "If nothing matched, send back 'F'."

Each `return` is a "stop right here, you have your answer" door. As soon as one is hit, the rest of the function is skipped.

---

## A Short Way To Write It: Arrow Syntax

If your function is **just one line that gives an answer**, Dart has a shortcut. Instead of curly braces and `return`, you can write `=>`.

```dart
// Long way
int doubleIt(int n) {
  return n * 2;
}

// Short way (same thing)
int doubleIt(int n) => n * 2;
```

Read `=>` as "gives back". So `int doubleIt(int n) => n * 2` reads as: "doubleIt takes an int and gives back n times 2."

Use the short way when:

- The function is only one expression long.
- You do not need any `if` statements or extra steps.

Otherwise stick with the curly-brace version. Both work.

---

## Functions Without A Name (Anonymous Functions)

Sometimes you need a tiny one-shot function and you do not want to bother giving it a name. Dart lets you write a function with **no name at all**. These are called **anonymous functions**.

Compare:

```dart
// Named function (what you have been writing)
int doubleIt(int n) => n * 2;

// Same thing, with no name
(int n) => n * 2;
```

The unnamed version starts straight at the parentheses. No return type, no name. Dart can figure both of those out from how you use it.

### Why would you want an unnamed function?

The most common reason is to **hand a function to another function as an input**. Yes, a function can be a value, just like a number or a string.

In `04-Lists.md` you will meet a tool called `map`. Here is a sneak peek so this idea has a place to land:

```dart
List<int> nums = [1, 2, 3, 4, 5];

var doubled = nums.map((n) => n * 2).toList();
print(doubled);   // [2, 4, 6, 8, 10]
```

Read it like this: "for every `n` in `nums`, give me `n * 2`."

The piece `(n) => n * 2` is the anonymous function. It says: "I take an `n`, and I give back `n * 2`." `map` takes that little function and runs it on every value in the list.

You will see this pattern a lot in the next three lessons (`04-Lists.md`, `05-Maps.md`, `06-Sets.md`). It is the standard way to transform or filter a collection. The big idea to hold in your head:

> A function is a value. You can pass it to another function as an input.

That is all anonymous functions are. A small, no-name function used right where it is needed.

---

## Sometimes The Answer Might Not Exist

Some functions might fail to find an answer. Like looking up a friend in a contact book. Maybe the friend is there. Maybe not.

For these, we add a `?` to the return type. The `?` means "the answer might be there, or it might be empty (`null`)".

```dart
String? findFriend(int id) {
  if (id == 1) return 'Ada';
  if (id == 2) return 'Bola';
  return null;     // we did not find anyone
}
```

When you call it, you have to handle both cases:

```dart
String? friend = findFriend(99);

if (friend != null) {
  print('Found $friend');
} else {
  print('No friend with that id');
}
```

There is also a tiny shortcut for "if it is null, use this default instead". It is the `??` operator.

```dart
print(findFriend(99) ?? 'No friend');
```

Read it as: "print whatever `findFriend` gives back, or 'No friend' if it gives back null."

---

## Why This Matters In Flutter

Every screen you build in Flutter is a function that **returns** a Widget.

```dart
Widget build(BuildContext context) {
  return Text('Hello');
}
```

Look at the parts:

- Return type: `Widget` (gives back a widget).
- Name: `build`.
- Body: returns a `Text` widget.

So the moment you understand "a function gives back an answer", you already understand how every Flutter screen is built.

---

## The Top Five Mistakes Beginners Make

### Mistake 1: Saying you return something but never doing it

```dart
int addTwoNumbers(int a, int b) {
  print(a + b);    // forgot to return!
}
```

You promised an `int` at the top. But there is no `return`. Dart will refuse this.

**Fix:** Use `return` instead of `print`.

```dart
int addTwoNumbers(int a, int b) {
  return a + b;
}
```

### Mistake 2: The return type does not match the answer

```dart
int wrong() {
  return 'hello';   // 'hello' is a String, not an int
}
```

**Fix:** Match them. Either change the type to `String`, or return a real `int`.

### Mistake 3: Some paths return, others do not

```dart
int compare(int a, int b) {
  if (a > b) return a;
  // What if a is NOT bigger? Nothing returned. ERROR.
}
```

Every possible path through the function must return something.

**Fix:** Add a return for the other case.

```dart
int compare(int a, int b) {
  if (a > b) return a;
  return b;
}
```

### Mistake 4: Trying to catch a `void` answer

```dart
void sayHi() { print('hi'); }

void main() {
  String x = sayHi();   // ERROR: there is nothing to catch
}
```

**Fix:** Either give the function a real return type, or stop trying to catch the result.

### Mistake 5: Calling but ignoring the answer

```dart
int doubleIt(int n) => n * 2;

void main() {
  doubleIt(5);   // calculated 10, then threw it away
}
```

Nothing prints. You forgot to do something with the answer.

**Fix:**

```dart
void main() {
  print(doubleIt(5));   // now we see 10
}
```

---

## One-Minute Recap

- A function can **give back an answer**. That answer is the return value.
- The return type at the top tells you what kind of answer to expect.
- The word `return` sends the answer out and ends the function.
- `void` means "no answer, just do the work".
- A `?` after the type means "the answer might be empty".
- `=>` is a one-line shortcut for `{ return ...; }`.
- A function can be a value. An unnamed (anonymous) function `(n) => n * 2` can be passed to another function as an input.

That is everything. Re-read this list once. If each line makes sense, you are ready.

---

## Quick Quiz

**Q1.** What is wrong with this function?

```dart
int score(int grade) {
  if (grade > 50) return 1;
}
```

<details>
<summary>Answer</summary>
It only returns when `grade > 50`. If grade is 50 or less, the function returns nothing, which breaks the rule. Add `return 0;` (or any default) at the end.
</details>

**Q2.** Convert this to the short arrow form.

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
`Unknown`. `lookup(7)` does not match id 1, so it returns `null`. The `??` then swaps in `'Unknown'`.
</details>

---

## Assignment

### Problem 1: Fix the broken functions

Each of these is broken. Either the return type is missing, or the `return` is missing. Fix each one.

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

### Problem 2: Medal titles

Write a function `String? rankTitle(int rank)` that gives back `'Gold'` for rank 1, `'Silver'` for 2, `'Bronze'` for 3, and `null` for anything else.

Test:
- `rankTitle(1)` (expected: Gold)
- `rankTitle(5)` (expected: null)

Then write a second function `String rankTitleOrNone(int rank)` that gives back the title, or `'No medal'` if there is none. Build it on top of `rankTitle` using `??`. Do not repeat the logic.

(Lists come in the next lesson, so we are not using them yet.)

### Problem 3: Convert to arrow

Convert each one to arrow syntax. If a function cannot be converted, explain why.

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

### Problem 4: Predict the output

Without running it, what does this print?

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

---

## Assignment Answers

### Problem 1: Fix the broken functions

**A.** Missing the return type.

```dart
int add(int a, int b) {
  return a + b;
}
```

Always say what you give back at the top. Without it, Dart guesses, and that hurts your code later.

**B.** Missing the `return` keyword.

```dart
int subtract(int a, int b) {
  return a - b;
}
```

Without `return`, the line `a - b;` does the math and then throws the answer away. The `return` word is what hands the answer back to whoever called the function.

**C.** Missing the second return.

```dart
int greaterOf(int a, int b) {
  if (a > b) return a;
  return b;
}
```

Every path through the function must give back a value. Here the original only handled `a > b`. We added `return b;` for the other case.

### Problem 2: Medal titles

```dart
String? rankTitle(int rank) {
  if (rank == 1) return 'Gold';
  if (rank == 2) return 'Silver';
  if (rank == 3) return 'Bronze';
  return null;
}

String rankTitleOrNone(int rank) {
  return rankTitle(rank) ?? 'No medal';
}

void main() {
  print(rankTitle(1));          // Gold
  print(rankTitle(5));          // null
  print(rankTitleOrNone(2));    // Silver
  print(rankTitleOrNone(5));    // No medal
}
```

How this works:

1. `rankTitle` checks the rank and returns the matching title, stopping as soon as it finds one. If nothing matches, it returns `null`.
2. `rankTitleOrNone` calls `rankTitle` and adds the `?? 'No medal'` shortcut. If the answer is null, it hands back `'No medal'` instead.

This is a really nice pattern. The first function is honest: "I might not find anything." The second function takes that honesty and turns null into a default. Two callers can pick two different defaults without changing the first function at all.

### Problem 3: Convert to arrow

**A.** `bool isPositive(int n) => n > 0;`

The body is one expression. Easy.

**B.** `String greet(String name) => 'Hello, $name';`

Same: one expression.

**C.** This one cannot be converted as-is, because it has an `if`. Arrow only works for one expression. But you can use the `?` shortcut (the ternary), which is one expression:

```dart
int absolute(int n) => n < 0 ? -n : n;
```

Read it as: "if n is less than 0, give back -n; otherwise, give back n."

**D.** `double average(int a, int b) => (a + b) / 2;`

One expression. Done.

### Problem 4: Predict the output

Output:

```
ADA
BOLA
No such user
```

Walk through each line:

1. `formatUser(1)`: `lookup(1)` gives back `'Ada'`. The `?.` only calls `toUpperCase()` if the answer is not null. It is not null, so we get `'ADA'`. The `??` is not needed because we already have an answer. Print `'ADA'`.
2. `formatUser(2)`: same path. Print `'BOLA'`.
3. `formatUser(99)`: `lookup(99)` gives back `null`. The `?.` sees null and skips `toUpperCase()`. So the whole left side is `null`. Then `??` swaps in `'No such user'`. Print `'No such user'`.

This brings together three null-safety friends:

- `String?` says "the answer might be empty".
- `?.` says "only do this if the answer is not empty".
- `??` says "if it is empty, use this instead".

These three together let you write very compact code that handles missing data safely.

---

**Next:** `04-Lists.md` to learn how to store many values in one variable.
