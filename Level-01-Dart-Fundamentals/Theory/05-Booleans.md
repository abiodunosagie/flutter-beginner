# Booleans: True Or False

## The Big Idea In One Sentence

> A bool is a value that is either **`true`** or **`false`**, nothing else, and it is how your program answers yes/no questions.

This is the simplest type of all. Just two possible values.

---

## A Picture To Hold In Your Head

Think of a **light switch**. It is either ON or OFF. There is no in-between.

```
ON   = true
OFF  = false
```

A bool is exactly that: a switch that is either `true` or `false`.

```dart
bool lightIsOn = true;    // the light is on
bool doorIsOpen = false;  // the door is closed
```

---

## Naming Booleans So They Read Like Questions

A nice habit: start bool names with `is`, `has`, or `can`. Then the name reads like a yes/no question.

```dart
bool isHappy = true;     // "is happy?"  yes
bool hasMoney = false;   // "has money?" no
bool canSwim = true;     // "can swim?"  yes
```

This makes your code easy to read out loud.

---

## Booleans Come From Comparisons

Most of the time you do not type `true` or `false` yourself. You **ask a question**, and the answer is a bool. You ask questions with **comparison signs**:

```dart
void main() {
  int age = 20;

  print(age > 18);    // true   (is 20 bigger than 18?)
  print(age < 18);    // false  (is 20 smaller than 18?)
  print(age == 20);   // true   (is 20 equal to 20?)
  print(age != 20);   // false  (is 20 NOT equal to 20?)
}
```

The full set of comparison signs:

| Sign | Means | Example | Answer |
|------|-------|---------|--------|
| `==` | equal to | `5 == 5` | true |
| `!=` | not equal to | `5 != 3` | true |
| `>` | greater than | `5 > 3` | true |
| `<` | less than | `5 < 3` | false |
| `>=` | greater than or equal | `5 >= 5` | true |
| `<=` | less than or equal | `5 <= 3` | false |

> Watch out: **`==` (two equals)** asks a question. **`=` (one equals)** puts a value in a box. Mixing them up is the most common beginner bug. `age == 20` checks. `age = 20` stores.

You can store the answer in a bool box:

```dart
void main() {
  int age = 20;
  bool isAdult = age >= 18;
  print(isAdult);   // true
}
```

---

## Combining Questions: AND, OR, NOT

Real life often needs more than one condition. Dart has three tools.

### AND is `&&`: both must be true

```dart
void main() {
  bool isSunny = true;
  bool isWarm = true;

  print(isSunny && isWarm);   // true (both are true)
}
```

Think: "I will go out if it is sunny **and** warm." Both have to be true.

```
true  && true  = true
true  && false = false
false && true  = false
false && false = false
```

### OR is `||`: at least one must be true

```dart
void main() {
  bool isSaturday = false;
  bool isSunday = true;

  print(isSaturday || isSunday);   // true (Sunday is true)
}
```

Think: "I can sleep in if it is Saturday **or** Sunday." Just one is enough.

```
true  || true  = true
true  || false = true
false || true  = true
false || false = false
```

(Those two bars `||` are the key above the Enter key on most keyboards.)

### NOT is `!`: flip it

`!` turns `true` into `false`, and `false` into `true`.

```dart
void main() {
  bool isRaining = true;
  print(!isRaining);   // false
}
```

---

## Putting Conditions Together

```dart
void main() {
  int age = 20;
  bool hasTicket = true;

  bool canEnter = age >= 18 && hasTicket;
  print(canEnter);   // true (18-or-over AND has a ticket)
}
```

`age >= 18` is `true`, `hasTicket` is `true`, and `true && true` is `true`. So `canEnter` is `true`.

---

## Flipping A Switch (Toggle)

A common trick: flip a bool to its opposite using `!`.

```dart
void main() {
  bool lightOn = false;

  lightOn = !lightOn;   // now true
  print(lightOn);       // true

  lightOn = !lightOn;   // now false again
  print(lightOn);       // false
}
```

Each `!lightOn` gives the opposite, and storing it back flips the switch.

---

## A Peek Ahead (You Will Learn This Properly In Level 2)

Booleans are powerful because they let your program **make decisions**. You will use them with `if` like this:

```dart
bool isLoggedIn = true;

if (isLoggedIn) {
  print('Welcome back!');
}
```

Do not worry about `if` yet. Just know: a bool is the yes/no that decisions are built on. The whole of Level 2 is about this.

---

## The Top Mistakes Beginners Make

### Mistake 1: Using `=` instead of `==`

```dart
int age = 20;
print(age = 18);    // BAD: this stores 18 in age, it does not compare
print(age == 18);   // GOOD: this asks "is age equal to 18?"
```

### Mistake 2: Putting quotes around true/false

```dart
bool ready = 'true';   // BAD: that is text
bool ready = true;     // GOOD
```

### Mistake 3: Thinking AND when you mean OR

"Saturday and Sunday" in everyday speech usually means "either one". In code that is OR:

```dart
bool isWeekend = today == 'Saturday' || today == 'Sunday';
```

A single day can never be both, so `&&` would always be false.

---

## One-Minute Recap

- A bool is `true` or `false`, nothing else.
- Name bools like questions: `isReady`, `hasMoney`, `canSwim`.
- Comparison signs give bools: `==`, `!=`, `>`, `<`, `>=`, `<=`.
- `==` compares, `=` stores. Do not mix them up.
- `&&` (AND) needs both true. `||` (OR) needs at least one true. `!` (NOT) flips.
- Bools power decisions with `if`, which you meet in Level 2.

---

## Quick Quiz

**Q1.** What is `5 > 3`?

<details>
<summary>Answer</summary>
`true`. 5 is greater than 3.
</details>

**Q2.** What is `true && false`?

<details>
<summary>Answer</summary>
`false`. AND needs both to be true.
</details>

**Q3.** What is `false || true`?

<details>
<summary>Answer</summary>
`true`. OR needs only one to be true.
</details>

**Q4.** What is the difference between `=` and `==`?

<details>
<summary>Answer</summary>
`=` puts a value in a box (stores). `==` asks if two things are equal (compares).
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
void main() {
  bool a = true;
  bool b = false;

  print(a && b);
  print(a || b);
  print(!a);
  print(!b);
}
```

### Problem 2: Compare numbers

Make `int score = 75`. Print the true/false answers to:

1. Is the score greater than 50?
2. Is the score equal to 100?
3. Is the score at least 75 (75 or more)?

### Problem 3: Can they enter?

Make `int age = 16` and `bool hasPermission = true`. Make a bool `canEnter` that is true only if the age is 18 or more **and** they have permission. Print `canEnter`.

### Problem 4: Weekend check

Make `String today = 'Sunday'`. Make a bool `isWeekend` that is true if today is `'Saturday'` **or** `'Sunday'`. Print it.

### Problem 5: Flip the switch

Make `bool isOn = true`. Flip it with `!`, print it, flip it again, and print it again.

---

## Assignment Answers

### Problem 1: Predict the output

```
false
true
false
true
```

- `a && b` is `true && false` = `false` (AND needs both true).
- `a || b` is `true || false` = `true` (OR needs one true).
- `!a` flips `true` to `false`.
- `!b` flips `false` to `true`.

### Problem 2: Compare numbers

```dart
void main() {
  int score = 75;
  print(score > 50);     // true
  print(score == 100);   // false
  print(score >= 75);    // true
}
```

Each comparison gives back a bool. 75 is more than 50 (true), is not equal to 100 (false), and is at least 75 (true).

### Problem 3: Can they enter?

```dart
void main() {
  int age = 16;
  bool hasPermission = true;

  bool canEnter = age >= 18 && hasPermission;
  print(canEnter);   // false
}
```

`age >= 18` is `false` (16 is under 18). With `&&`, both sides must be true, so even though `hasPermission` is true, the result is `false`.

### Problem 4: Weekend check

```dart
void main() {
  String today = 'Sunday';
  bool isWeekend = today == 'Saturday' || today == 'Sunday';
  print(isWeekend);   // true
}
```

`today == 'Saturday'` is false, but `today == 'Sunday'` is true. With `||`, one true is enough, so `isWeekend` is `true`.

### Problem 5: Flip the switch

```dart
void main() {
  bool isOn = true;

  isOn = !isOn;
  print(isOn);   // false

  isOn = !isOn;
  print(isOn);   // true
}
```

`!isOn` gives the opposite each time. Storing it back flips the switch: true becomes false, then false becomes true again.

---

**Next:** `06-Operators.md`, where you see all the signs (`+`, `==`, `&&`, and more) together in one place.
