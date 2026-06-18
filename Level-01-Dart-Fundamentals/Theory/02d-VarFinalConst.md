# var, final, and const: Shortcuts And Locked Boxes

## The Big Idea In One Sentence

> `var` is a shortcut for making a box, and `final`/`const` make a box that can **never be changed** after you fill it.

So far you always wrote the type, like `String name = 'Ada'`. This lesson shows you three handy extra words.

---

## `var`: Let Dart Figure Out The Type

When you put a value in a box, Dart can usually **guess the type by itself**. Instead of writing the type, you can just write `var`:

```dart
var name = 'Ada';    // Dart sees text, so this is a String
var age = 25;        // Dart sees a whole number, so this is an int
var price = 19.99;   // Dart sees a decimal, so this is a double
var happy = true;    // Dart sees true/false, so this is a bool
```

`var name = 'Ada'` and `String name = 'Ada'` do the **exact same thing**. `var` is just less typing.

But here is the catch: even with `var`, **the type is still locked in** once Dart guesses it.

```dart
var age = 25;       // Dart locks this as a whole number
age = 30;           // GOOD: still a whole number
age = 'thirty';     // BAD: it is locked as a number, cannot become text
```

So `var` does not mean "anything goes." It means "Dart, please guess the type for me."

---

## `final`: Fill It Once, Then Lock It

Sometimes you want a box that **must not change** after you set it. Use `final`:

```dart
final name = 'Ada';
print(name);     // Ada

name = 'Bola';   // BAD: a final box cannot be changed
```

Once a `final` box is filled, it is locked. If anyone tries to change it, Dart stops them with an error. This is helpful: it protects values that are not supposed to change, like your date of birth.

You do not need to write the type with `final` either. Dart still guesses it.

---

## `const`: A Value You Already Know

`const` is like `final`, it also makes a box that can never change. The difference is small:

> Use `const` for a value you **already know as you type the code**, like a fixed fact.

Examples of fixed facts:

```dart
const daysInWeek = 7;
const pi = 3.14;
const appName = 'My App';
```

These never change, ever, and you know them right now while writing. That is a perfect job for `const`.

```dart
const daysInWeek = 7;
daysInWeek = 8;     // BAD: const can never change (and a week is always 7 days)
```

For a beginner, a simple rule of thumb:

- If you are typing the exact fixed value yourself (like `7` or `3.14`), `const` is great.
- Both `final` and `const` give you a box that cannot change. `const` is just the stricter one for fixed, known-ahead values.

---

## Which One Should I Use?

Ask one question first: **will this value ever change?**

```
Will it change?
   |
   |-- Yes  ->  use  var
   |
   |-- No   ->  use  final
                 (or const if you already know the exact value as you type)
```

A few examples:

```dart
var score = 0;          // changes during the game -> var
final birthYear = 2010; // your birth year never changes -> final
const pi = 3.14;        // a fixed fact you know now -> const
```

A good habit: if a value does not need to change, lock it with `final` or `const`. It stops accidental changes and makes your code safer.

---

## The Top Mistakes Beginners Make

### Mistake 1: Trying to change a final or const box

```dart
final city = 'Lagos';
city = 'Abuja';     // BAD: final cannot change
```

If you need it to change, use `var` instead.

### Mistake 2: Thinking `var` means "any type"

```dart
var age = 25;
age = 'old';     // BAD: var still locks the type (here: number)
```

### Mistake 3: Writing the type AND var together

```dart
var int age = 25;   // BAD: pick one
var age = 25;       // GOOD
int age = 25;       // also GOOD
```

### Mistake 4: Using const for something that changes

```dart
const score = 0;
score = 10;     // BAD: a score changes, so it should be var
var score = 0;  // GOOD
```

---

## One-Minute Recap

- `var` lets Dart guess the type so you type less. The type is still locked once guessed.
- `final` makes a box you fill once and then cannot change.
- `const` is like `final`, used for fixed values you already know as you type (like `7` or `3.14`).
- First question to ask: will it change? Yes -> `var`. No -> `final` (or `const` for known fixed values).
- Locking values you do not want to change keeps your program safe.

---

## Quick Quiz

**Q1.** What type does Dart give `var count = 5;`?

<details>
<summary>Answer</summary>
`int`, because `5` is a whole number. Dart guesses the type from the value.
</details>

**Q2.** Why does the second line fail?

```dart
final name = 'Ada';
name = 'Bola';
```

<details>
<summary>Answer</summary>
`final` boxes can be filled only once. After `name = 'Ada'`, it is locked and cannot change.
</details>

**Q3.** Which keyword fits a player's score that goes up during the game?

<details>
<summary>Answer</summary>
`var`, because the score changes.
</details>

**Q4.** Which keyword fits the number of hours in a day (24)?

<details>
<summary>Answer</summary>
`const`, because it is a fixed value you already know and it never changes.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Pick var, final, or const

For each, write which keyword you would use and one short reason:

1. A score that goes up while playing.
2. The number of days in a week.
3. Your birth year.
4. The current page number as you scroll a list.
5. The value of pi (3.14).

### Problem 2: Predict which lines fail

```dart
void main() {
  var a = 10;
  a = 20;
  a = 'hello';

  final b = 5;
  b = 6;

  const c = 7;
  c = 8;
}
```

Which lines are fine, and which cause an error? Say why for each error.

### Problem 3: Rewrite with var

Rewrite these three lines using `var` instead of the explicit type:

```dart
String pet = 'cat';
int legs = 4;
bool friendly = true;
```

### Problem 4: Lock the right boxes

Here is some code using `var` for everything. Change each box to the best keyword (`var`, `final`, or `const`):

```dart
void main() {
  var appName = 'Evvy Hairs';   // never changes, known now
  var taxRate = 0.05;           // never changes, known now
  var cartCount = 0;            // changes as items are added
}
```

### Problem 5: Find the mistake

This code does not run. Find the mistake and fix it.

```dart
void main() {
  const greeting = 'Hello';
  greeting = 'Hi';
  print(greeting);
}
```

---

## Assignment Answers

### Problem 1: Pick var, final, or const

| Value | Choice | Why |
|-------|--------|-----|
| Score while playing | `var` | it changes |
| Days in a week | `const` | fixed value (7), known now |
| Birth year | `final` (or `const`) | never changes; if you type the exact year, `const` works too |
| Current page number | `var` | it changes as you scroll |
| Value of pi (3.14) | `const` | fixed value, known now |

The first question is always: will it change? If yes, `var`. If no, `final`, or `const` when you already know the exact value.

### Problem 2: Predict which lines fail

```dart
var a = 10;
a = 20;          // FINE: var can change to another whole number
a = 'hello';     // ERROR: a is locked as a number, cannot become text

final b = 5;
b = 6;           // ERROR: final cannot be changed after it is set

const c = 7;
c = 8;           // ERROR: const cannot be changed
```

So one line is fine (`a = 20`) and three lines cause errors.

### Problem 3: Rewrite with var

```dart
var pet = 'cat';
var legs = 4;
var friendly = true;
```

Dart guesses the types: `pet` is a String, `legs` is an int, `friendly` is a bool. The result is exactly the same as writing the types yourself.

### Problem 4: Lock the right boxes

```dart
void main() {
  const appName = 'Evvy Hairs';   // fixed and known now -> const
  const taxRate = 0.05;           // fixed and known now -> const
  var cartCount = 0;              // changes -> var
}
```

The two values that never change become `const`. The one that changes stays `var`.

### Problem 5: Find the mistake

The mistake: `greeting` is `const`, so it can never change, but the next line tries to change it to `'Hi'`.

Two ways to fix it. If the greeting should be able to change, use `var`:

```dart
void main() {
  var greeting = 'Hello';
  greeting = 'Hi';
  print(greeting);     // Hi
}
```

Or, if it should stay `'Hello'`, just remove the line that changes it:

```dart
void main() {
  const greeting = 'Hello';
  print(greeting);     // Hello
}
```

---

**Next:** `03-Strings.md`, where you learn lots of handy things you can do with text.
