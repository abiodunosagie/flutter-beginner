# If Statements: Teaching Your Program To Decide

## Why This Topic Exists

Up to now, your programs have run line by line, top to bottom, no choices. That is fine for a calculator. It is not fine for a real app.

Real apps make decisions every second:
- If the user is logged in, show the dashboard. Otherwise, show the login screen.
- If the cart has items, show "Checkout". Otherwise, hide the button.
- If the network is offline, show a warning.

That word **if** is the magic. We are about to teach Dart how to use it.

---

## The Mental Model

Every if statement is a **gate**. Code waits at the gate. The gate has one rule: a true-or-false question. If the answer is true, the code is allowed through. If the answer is false, the code is skipped.

```
                ┌────── true ─────► run the body
   condition ───┤
                └────── false ────► skip the body
```

That is it. Every if statement, no matter how complex, is built from this single idea.

---

## The Basic If

```dart
int age = 20;

if (age >= 18) {
  print('You can vote');
}
```

Read it left to right:
- `if` is the keyword.
- `(age >= 18)` is the condition. It must be a boolean (true or false).
- `{ ... }` is the body. Runs only when the condition is true.

In this example, `age` is 20, so `20 >= 18` is true. The body runs. The screen shows `You can vote`.

If you change `age` to 15, then `15 >= 18` is false. The body is skipped. Nothing prints.

---

## Adding `else` (When False Should Do Something)

What if you want to print a different message when the user is too young?

```dart
int age = 15;

if (age >= 18) {
  print('You can vote');
} else {
  print('Too young');
}
```

The rule is simple:
- The `if` body runs **only when the condition is true**.
- The `else` body runs **only when the condition is false**.
- Exactly one of them runs. Never both. Never neither.

Output: `Too young`.

---

## Adding `else if` (More Than Two Branches)

Real life has more than two cases. Grades, for example: A, B, C, D, F.

```dart
int score = 85;

if (score >= 90) {
  print('A');
} else if (score >= 80) {
  print('B');
} else if (score >= 70) {
  print('C');
} else if (score >= 60) {
  print('D');
} else {
  print('F');
}
```

How it runs:
1. Is `85 >= 90`? No. Skip.
2. Is `85 >= 80`? Yes. Run `print('B')`.
3. Stop. The remaining branches are not even checked.

That last point matters. **As soon as one branch matches, the rest are ignored.** This is why order matters.

---

## Order Matters (A Common Mistake)

```dart
int score = 95;

// Wrong order
if (score >= 60) {
  print('Pass');
} else if (score >= 90) {
  print('Excellent');   // never runs, because 95 >= 60 ran first
}
```

`95 >= 60` is true, so `'Pass'` prints and `'Excellent'` is skipped, even though it would have been more accurate.

The fix is to check the **most specific** condition first:

```dart
if (score >= 90) {
  print('Excellent');   // checked first
} else if (score >= 60) {
  print('Pass');
}
```

Rule: when conditions overlap, put the strictest one on top.

---

## Combining Conditions: AND, OR, NOT

You can combine conditions with three operators.

### `&&` means AND. Both must be true.

```dart
int age = 25;
bool hasID = true;

if (age >= 18 && hasID) {
  print('Welcome');
}
```

Both `age >= 18` and `hasID` must be true. If either is false, the whole condition is false.

### `||` means OR. At least one must be true.

```dart
String day = 'Saturday';

if (day == 'Saturday' || day == 'Sunday') {
  print('Weekend');
}
```

If either side is true, the whole thing is true.

### `!` means NOT. It flips a boolean.

```dart
bool isLoggedIn = false;

if (!isLoggedIn) {
  print('Please log in');
}
```

`!isLoggedIn` reads as "not logged in". Since `isLoggedIn` is false, `!isLoggedIn` is true, and the body runs.

---

## Truth Table Cheat Sheet

| `a` | `b` | `a && b` | `a \|\| b` | `!a` |
|-----|-----|----------|------------|------|
| true | true | true | true | false |
| true | false | false | true | false |
| false | true | false | true | true |
| false | false | false | false | true |

Memorise the patterns:
- AND: only true if **both** sides are true.
- OR: false only if **both** sides are false.

---

## Nesting (An If Inside An If)

You can put one if inside another:

```dart
int age = 25;
bool hasLicense = true;

if (age >= 18) {
  if (hasLicense) {
    print('You can drive');
  } else {
    print('Get a license first');
  }
} else {
  print('Too young to drive');
}
```

This works, but be careful. Two levels deep is fine. Four levels deep is unreadable. When nesting gets too deep, combine the conditions with `&&` instead:

```dart
if (age >= 18 && hasLicense) {
  print('You can drive');
}
```

Same logic, flatter, easier to read.

---

## The Ternary Operator (Shorthand)

For simple if-else where you assign a value, there is a shorter form:

```dart
String status = age >= 18 ? 'Adult' : 'Minor';
```

Read it as: "If `age >= 18` is true, the value is `'Adult'`, otherwise `'Minor'`."

Format:
```
condition ? valueIfTrue : valueIfFalse
```

Use this only for short, simple decisions. If the logic is complex, write the full if-else for clarity.

---

## Common Patterns You Will Use Daily

### 1. Form validation

```dart
String username = 'ada';
String password = '12345';

if (username.isEmpty) {
  print('Username required');
} else if (password.length < 6) {
  print('Password must be 6 characters or more');
} else {
  print('Login successful');
}
```

### 2. Range checks

```dart
int temperature = 72;

if (temperature < 32) {
  print('Freezing');
} else if (temperature < 60) {
  print('Cold');
} else if (temperature < 80) {
  print('Mild');
} else {
  print('Hot');
}
```

### 3. Null check

```dart
String? name;   // could be null

if (name != null) {
  print('Hello, $name');
} else {
  print('Hello, Guest');
}
```

If you covered null safety in Level 1, this should look familiar. The `?` after `String` means "this variable might be null".

---

## Why This Matters In Flutter

If statements are the most common piece of logic in any Flutter app. A small preview, do not run this yet:

```dart
Widget build(BuildContext context) {
  if (isLoading) {
    return CircularProgressIndicator();
  }

  if (hasError) {
    return Text('Something went wrong');
  }

  return ProductList();
}
```

Three branches, three different screens, decided by an if statement. You will write code like this every single day in Flutter. Master the if statement now and you have one less thing to worry about later.

---

## Common Mistakes

### 1. Using `=` instead of `==`

```dart
// Wrong: this assigns 5 to x. Does not compile in Dart.
if (x = 5) { }

// Correct: this compares x to 5.
if (x == 5) { }
```

Single `=` is assignment. Double `==` is comparison. Always.

### 2. Forgetting the curly braces

```dart
// Risky: only the next line is part of the if.
if (score > 90)
  print('Great');
  print('A grade');   // this always prints, even when score is low

// Safe: braces make the body explicit.
if (score > 90) {
  print('Great');
  print('A grade');
}
```

Always use braces. Even for one line. It saves you from bugs that are very hard to spot.

### 3. Putting overlapping conditions in the wrong order

Already covered above. Strictest first.

---

## Recap In One Minute

- `if` runs a block when a condition is true.
- `else` runs when the condition is false.
- `else if` chains multiple branches. Only one runs.
- Use `&&` for AND, `||` for OR, `!` for NOT.
- Always wrap the body in `{ }`.
- Use `==` to compare, never `=`.
- Use ternary `? :` for short value-picking decisions only.

---

## Quick Quiz

**Q1.** What prints?
```dart
int x = 5;
if (x > 10) {
  print('A');
} else if (x > 3) {
  print('B');
} else {
  print('C');
}
```

<details>
<summary>Answer</summary>
`B`. 5 is not greater than 10, but 5 is greater than 3.
</details>

**Q2.** Spot the bug:
```dart
if (age = 18) {
  print('Adult');
}
```

<details>
<summary>Answer</summary>
`=` is assignment, not comparison. It should be `==`. Dart will refuse to compile this.
</details>

**Q3.** Rewrite as a ternary:
```dart
String label;
if (count > 0) {
  label = 'Items in cart';
} else {
  label = 'Cart is empty';
}
```

<details>
<summary>Answer</summary>

```dart
String label = count > 0 ? 'Items in cart' : 'Cart is empty';
```
</details>

**Q4.** What is the output?
```dart
int a = 5;
int b = 10;

if (a > 0 && b > 0) {
  print('Both positive');
} else if (a > 0 || b > 0) {
  print('At least one is positive');
} else {
  print('None are positive');
}
```

<details>
<summary>Answer</summary>
`Both positive`. Both 5 and 10 are greater than 0, so the AND condition is true and the first branch runs. The other branches are skipped.
</details>

---

## Assignment

Try each one in [dartpad.dev](https://dartpad.dev) before reading the answer. Everything here uses only `if`/`else`, variables, and what you learned in Level 1. (Functions and loops come later, so we do not need them yet.)

### Problem 1: Predict the output

Without running it, what does this print, and why?

```dart
void main() {
  int a = 10;
  int b = 5;

  if (a > b) {
    if (a - b > 3) {
      print('A');
    } else {
      print('B');
    }
  } else if (a == b) {
    print('C');
  } else {
    print('D');
  }
}
```

### Problem 2: Cinema ticket price

In `main`, make these three boxes:

```dart
int age = 22;
bool isStudent = true;
bool isWeekend = true;
```

Work out the ticket price into a `double price` using these rules, then print it:

- The base price is 2000.
- If the customer is under 13, the price is 1000 (nothing else applies).
- If the customer is over 60, the price is 1500 (nothing else applies).
- Otherwise, students get 25% off the base price (so 1500), and everyone else pays 2000.
- After all that, if it is the weekend, add 20% on top.

With the values above (student, weekend), the answer should be 1800. After it works, try changing the three boxes to test other cases.

### Problem 3: Spot and fix the bug

This is supposed to put the right letter grade in `result`, but it has a bug. Run it with `score = 95` and you will see the wrong answer. Find the bug, explain it, then fix it.

```dart
void main() {
  int score = 95;
  String result;

  if (score >= 50) {
    result = 'F or above';
  } else if (score >= 70) {
    result = 'C';
  } else if (score >= 80) {
    result = 'B';
  } else if (score >= 90) {
    result = 'A';
  } else {
    result = 'F';
  }

  print(result);
}
```

### Problem 4: Login check

In `main`, make `String username = 'ada'` and `String password = 'secret'`. Put the right message in a `String message` box using these rules, then print it:

- `'Username required'` if the username is empty.
- `'Password required'` if the password is empty.
- `'Password too short'` if the password has fewer than 8 characters.
- `'Login successful'` if everything is fine.

(Hint: `.isEmpty` and `.length` from the Strings lesson will help. Check one rule at a time with `else if`.)

### Problem 5: Flatten the nesting

This nested `if` works, but it is hard to read. Rewrite it as a single `if`/`else if`/`else` chain that puts the right text in a `String message` box. The result must be the same.

```dart
void main() {
  int age = 20;
  bool hasLicense = true;
  bool hasInsurance = false;

  String message;

  if (age >= 18) {
    if (hasLicense) {
      if (hasInsurance) {
        message = 'You can drive';
      } else {
        message = 'Get insurance first';
      }
    } else {
      message = 'Get a license first';
    }
  } else {
    message = 'Too young to drive';
  }

  print(message);
}
```

---

## Assignment Answers

### Problem 1: Predict the output

**Answer: `A`**

Step by step:

1. `a` is 10, `b` is 5.
2. The outer condition `a > b` is `10 > 5`, which is `true`. We go inside the outer `if`.
3. The inner condition `a - b > 3` is `5 > 3`, which is `true`.
4. So `print('A')` runs.
5. The outer `else if` and `else` are skipped, because the outer `if` already matched. Only one branch of a chain ever runs.

### Problem 2: Cinema ticket price

```dart
void main() {
  int age = 22;
  bool isStudent = true;
  bool isWeekend = true;

  double price;

  if (age < 13) {
    price = 1000;
  } else if (age > 60) {
    price = 1500;
  } else if (isStudent) {
    price = 2000 * 0.75;   // 25% off  -> 1500
  } else {
    price = 2000;
  }

  if (isWeekend) {
    price = price * 1.20;  // add 20%
  }

  print(price);   // 1800.0
}
```

How the logic was built:

1. **Age is checked first** with an `else if` chain, because a child or senior price replaces everything else. Only one age bracket can match.
2. **The student discount** is in the chain too, so it only applies to normal-age customers.
3. **The weekend surcharge** is a separate `if` afterwards, because it can be added on top of any price.

With age 22, student, weekend: the chain gives `2000 * 0.75 = 1500`, then the weekend `if` gives `1500 * 1.20 = 1800`. It prints `1800.0` (a double, so it shows the `.0`).

### Problem 3: Spot and fix the bug

**The bug:** the conditions are in the wrong order. `score >= 50` is true for 95 too, so it matches first and sets `result` to `'F or above'`. The more exact checks below never get a chance.

**The fix:** check the strictest condition first (highest score at the top):

```dart
void main() {
  int score = 95;
  String result;

  if (score >= 90) {
    result = 'A';
  } else if (score >= 80) {
    result = 'B';
  } else if (score >= 70) {
    result = 'C';
  } else if (score >= 50) {
    result = 'F or above';
  } else {
    result = 'F';
  }

  print(result);   // A
}
```

Now 95 matches the very first check and prints `A`. When ranges overlap, always put the strictest one on top.

### Problem 4: Login check

```dart
void main() {
  String username = 'ada';
  String password = 'secret';

  String message;

  if (username.isEmpty) {
    message = 'Username required';
  } else if (password.isEmpty) {
    message = 'Password required';
  } else if (password.length < 8) {
    message = 'Password too short';
  } else {
    message = 'Login successful';
  }

  print(message);   // Password too short
}
```

With `password = 'secret'` (6 letters), the first two checks pass, but `password.length < 8` is true, so it prints `Password too short`. Checking one rule at a time with `else if` makes sure only the first failing rule is reported.

### Problem 5: Flatten the nesting

```dart
void main() {
  int age = 20;
  bool hasLicense = true;
  bool hasInsurance = false;

  String message;

  if (age < 18) {
    message = 'Too young to drive';
  } else if (!hasLicense) {
    message = 'Get a license first';
  } else if (!hasInsurance) {
    message = 'Get insurance first';
  } else {
    message = 'You can drive';
  }

  print(message);   // Get insurance first
}
```

How the flattening works:

1. List the failure cases first, in order: too young, no license, no insurance.
2. Each one uses `else if`, so only the first problem found is reported.
3. The last `else` is the success case: if none of the problems happened, you can drive.

This reads top to bottom like a checklist, which is much easier than the deeply nested version. With the given values (old enough, has a license, no insurance), it prints `Get insurance first`.

---

**Next:** `02-SwitchStatements.md` to learn a tidy way to handle many exact matches.
