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

These problems go beyond the quiz. They are designed to make you think before you type. Try each one on paper or in your editor before reading the answer.

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

### Problem 2: Cinema ticket pricing

Write a function `ticketPrice(int age, bool isStudent, bool isWeekend)` that returns the price in naira based on these rules:

- Base price is 2000.
- If the customer is under 13, the price is 1000 (no other discount stacks).
- If the customer is over 60, the price is 1500 (no other discount stacks).
- Students get 25% off the base price.
- On weekends, prices are 20% higher than the calculated price (applied last).

Test with these cases and verify your function:

| age | isStudent | isWeekend | expected |
|-----|-----------|-----------|----------|
| 10 | false | false | 1000 |
| 65 | false | true | 1800 |
| 22 | true | false | 1500 |
| 22 | true | true | 1800 |
| 30 | false | false | 2000 |

### Problem 3: Spot and fix the bug

This function is supposed to return a letter grade. It has a bug. Find it, explain why it is wrong, then fix it.

```dart
String grade(int score) {
  if (score >= 50) return 'F or above';
  if (score >= 70) return 'C';
  if (score >= 80) return 'B';
  if (score >= 90) return 'A';
  return 'F';
}
```

### Problem 4: Login validator

Write a function `String validateLogin(String username, String password)` that returns one of these messages:

- `'Username required'` if the username is empty.
- `'Password required'` if the password is empty.
- `'Password too short'` if the password has fewer than 8 characters.
- `'Password must contain a number'` if the password has no digit.
- `'Login successful'` if everything passes.

Hint: check one rule at a time and return early.

### Problem 5: Flatten the nesting

Rewrite this nested if into a flat one using `&&` and early returns. The behaviour should not change.

```dart
String message(int age, bool hasLicense, bool hasInsurance) {
  if (age >= 18) {
    if (hasLicense) {
      if (hasInsurance) {
        return 'You can drive';
      } else {
        return 'Get insurance first';
      }
    } else {
      return 'Get a license first';
    }
  } else {
    return 'Too young to drive';
  }
}
```

---

## Assignment Answers

### Problem 1: Predict the output

**Answer: `A`**

Walkthrough, line by line:

1. `a` is 10, `b` is 5.
2. The outer condition `a > b` is `10 > 5`, which is `true`. We enter the outer `if` block.
3. Now the inner condition: `a - b > 3` is `10 - 5 > 3`, which is `5 > 3`, which is `true`.
4. Because the inner condition is true, the inner `if` body runs. `print('A')` is called.
5. After the inner block ends, the program exits the outer block too. Nothing else runs.

The `else if` and `else` of the outer chain are skipped because the outer `if` already matched. This is the rule we covered: only one branch in an if-else chain runs.

### Problem 2: Cinema ticket pricing

```dart
double ticketPrice(int age, bool isStudent, bool isWeekend) {
  double price;

  if (age < 13) {
    price = 1000;
  } else if (age > 60) {
    price = 1500;
  } else if (isStudent) {
    price = 2000 * 0.75;     // 25% off
  } else {
    price = 2000;
  }

  if (isWeekend) {
    price = price * 1.20;     // 20% surcharge
  }

  return price;
}
```

How the logic was built:

1. **Order of checks matters.** The rules say child and senior discounts do not stack with student. So we check age first. If the customer is a child or senior, we set the price and skip the student check entirely. The `else if` chain is the right tool because exactly one age bracket should match.
2. **Student discount is only checked if the customer is in the working-age bracket.** That is what the final `else if` and `else` handle.
3. **Weekend surcharge is always applied last.** It is a separate `if` statement, not part of the chain, because it can apply on top of any age bracket.

Verifying with the test table:

- age 10: child, price 1000, not weekend, final 1000. ok
- age 65: senior, price 1500, weekend, final 1500 * 1.20 = 1800. ok
- age 22 student, weekday: 2000 * 0.75 = 1500. ok
- age 22 student, weekend: 1500 * 1.20 = 1800. ok
- age 30, not student, weekday: 2000. ok

The trick here is recognising that "no other discount stacks" means the conditions are mutually exclusive, which is exactly what `else if` is for.

### Problem 3: Spot and fix the bug

**The bug:** The conditions are checked in the wrong order. `score >= 50` matches everything from 50 upward, including 70, 80, and 90. So a score of 95 hits the first branch and returns `'F or above'`, never reaching the more specific checks.

**Why it is wrong:** As we discussed in "Order Matters", when conditions overlap, you must check the strictest one first. `score >= 90` is stricter than `score >= 50`. The strictest condition has to be at the top.

**Fixed version:**

```dart
String grade(int score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 50) return 'F or above';
  return 'F';
}
```

Now a score of 95 matches the very first check and correctly returns `'A'`.

### Problem 4: Login validator

```dart
String validateLogin(String username, String password) {
  if (username.isEmpty) return 'Username required';
  if (password.isEmpty) return 'Password required';
  if (password.length < 8) return 'Password too short';

  bool hasDigit = false;
  for (int i = 0; i < password.length; i++) {
    if ('0123456789'.contains(password[i])) {
      hasDigit = true;
      break;
    }
  }
  if (!hasDigit) return 'Password must contain a number';

  return 'Login successful';
}
```

How this was built:

1. **Check the cheapest things first.** Empty checks are very cheap. Length is cheap. Scanning every character for a digit is the most expensive, so it goes last.
2. **Return early.** As soon as a rule fails, return the matching message. This avoids deeply nested if-else.
3. **The digit check** uses a small loop and a `break` (which we will officially cover in topic 5). For each character of the password, we ask "is this character one of the digit characters '0' to '9'?". If yes, set the flag and stop looking. If we never found one, the flag stays `false` and we return the error.

You could also do the digit check more compactly with `password.contains(RegExp(r'[0-9]'))`, but that introduces regular expressions which are not in scope here. The explicit loop is fine and more readable for a beginner.

### Problem 5: Flatten the nesting

```dart
String message(int age, bool hasLicense, bool hasInsurance) {
  if (age < 18) return 'Too young to drive';
  if (!hasLicense) return 'Get a license first';
  if (!hasInsurance) return 'Get insurance first';
  return 'You can drive';
}
```

How the flattening was done:

1. **Start with the failure cases.** The nested version returns one of four results. Three of them are failures. List them first, in the order they would have been checked.
2. **Use `return` to exit early.** Once we know the answer, we return. There is no reason to nest deeper.
3. **The success case is the very last line.** If we get past every guard, we know everything passed.

Notice how the flat version reads top to bottom like a checklist:
- "Too young? bail."
- "No license? bail."
- "No insurance? bail."
- "All good? you can drive."

This pattern is called the **early return** or **guard clause** pattern. It is one of the most useful tools to keep code readable. Use it whenever you find yourself nesting three or more `if` statements.

---

**Next:** `02-SwitchStatements.md` to learn the cleaner way to handle many exact matches.
