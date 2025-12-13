# If Statements: Making Decisions

## What Is an If Statement?

An **if statement** lets your program make decisions.

Think of it like this:
- **IF** it's raining, **THEN** bring an umbrella
- **IF** the password is correct, **THEN** log in
- **IF** you're old enough, **THEN** you can vote

In code:
```dart
if (condition is true) {
  // do this
}
```

---

## The Basic If Statement

```dart
int age = 20;

if (age >= 18) {
  print('You can vote!');
}
```

**How it works:**
1. Check: Is `age >= 18`? → Is `20 >= 18`? → YES (true)
2. Since it's true, run the code inside `{ }`
3. Print: "You can vote!"

**If the condition is false:**
```dart
int age = 15;

if (age >= 18) {
  print('You can vote!');  // This never runs
}
// Program continues here
```

Nothing happens. The code inside `{ }` is skipped.

---

## Visual Flow

```
Start
  │
  ▼
┌───────────────┐
│ age >= 18 ?   │
└───────┬───────┘
        │
   ┌────┴────┐
   │         │
  YES        NO
   │         │
   ▼         │
┌──────┐     │
│Print │     │
└──┬───┘     │
   │         │
   └────┬────┘
        │
        ▼
   Continue...
```

---

## If-Else: Two Choices

What if you want to do something when the condition is FALSE?

```dart
int age = 15;

if (age >= 18) {
  print('You can vote!');
} else {
  print('Too young to vote.');
}
```

**How it works:**
1. Check: Is `age >= 18`? → Is `15 >= 18`? → NO (false)
2. Skip the `if` block
3. Run the `else` block
4. Print: "Too young to vote."

**One or the other always runs. Never both. Never neither.**

---

## If-Else If-Else: Many Choices

What if you have more than two options?

```dart
int score = 85;

if (score >= 90) {
  print('Grade: A');
} else if (score >= 80) {
  print('Grade: B');
} else if (score >= 70) {
  print('Grade: C');
} else if (score >= 60) {
  print('Grade: D');
} else {
  print('Grade: F');
}
```

**How it works:**
1. Is `85 >= 90`? → NO, try next
2. Is `85 >= 80`? → YES!
3. Print: "Grade: B"
4. Skip all remaining conditions

**Important:** Once ONE condition is true, the rest are skipped!

---

## Order Matters!

```dart
int score = 95;

// ❌ Wrong order - always prints "D or above"
if (score >= 60) {
  print('D or above');
} else if (score >= 90) {
  print('A');  // Never reached!
}

// ✅ Correct order - check highest first
if (score >= 90) {
  print('A');
} else if (score >= 60) {
  print('D or above');
}
```

**Rule:** Check the most specific (highest/strictest) condition first.

---

## Nested If Statements

You can put if statements inside other if statements:

```dart
int age = 25;
bool hasLicense = true;

if (age >= 18) {
  print('Old enough to drive');

  if (hasLicense) {
    print('You can drive!');
  } else {
    print('But you need a license first.');
  }
} else {
  print('Too young to drive');
}
```

**Tip:** Don't nest too deep (3+ levels). It gets confusing.

---

## Combining Conditions

### AND (&&) - Both Must Be True

```dart
int age = 25;
bool hasID = true;

if (age >= 21 && hasID) {
  print('Welcome to the club!');
}
```

Both conditions must be true:
- `age >= 21` ✓
- `hasID` ✓
- Result: true → prints message

### OR (||) - At Least One Must Be True

```dart
String day = 'Saturday';

if (day == 'Saturday' || day == 'Sunday') {
  print('It\'s the weekend!');
}
```

Only one needs to be true:
- `day == 'Saturday'` ✓
- Result: true → prints message

### NOT (!) - Flip the Condition

```dart
bool isLoggedIn = false;

if (!isLoggedIn) {
  print('Please log in');
}
```

`!isLoggedIn` means "NOT logged in", which is true.

---

## The Ternary Operator (Shorthand If-Else)

For simple if-else that assigns a value:

```dart
// Long way
String status;
if (age >= 18) {
  status = 'Adult';
} else {
  status = 'Minor';
}

// Short way (ternary)
String status = age >= 18 ? 'Adult' : 'Minor';
```

**Format:** `condition ? valueIfTrue : valueIfFalse`

More examples:
```dart
int score = 75;
String result = score >= 60 ? 'Pass' : 'Fail';

bool isOnline = true;
String icon = isOnline ? '🟢' : '⚫';

int a = 10, b = 20;
int max = a > b ? a : b;  // Gets the larger number
```

---

## Common Patterns

### Pattern 1: Validation

```dart
String username = 'alex';
String password = '12345';

if (username.isEmpty) {
  print('Username is required');
} else if (password.length < 6) {
  print('Password must be at least 6 characters');
} else {
  print('Login successful!');
}
```

### Pattern 2: Range Checking

```dart
int temperature = 72;

if (temperature < 32) {
  print('Freezing');
} else if (temperature < 60) {
  print('Cold');
} else if (temperature < 80) {
  print('Nice');
} else {
  print('Hot');
}
```

### Pattern 3: Null Checking

```dart
String? name;  // Could be null

if (name != null) {
  print('Hello, $name');
} else {
  print('Hello, Guest');
}

// Or use ternary
print('Hello, ${name ?? 'Guest'}');
```

---

## Practical Examples

### Example 1: Age Checker

```dart
void main() {
  int age = 17;

  if (age < 0) {
    print('Invalid age');
  } else if (age < 13) {
    print('Child');
  } else if (age < 20) {
    print('Teenager');
  } else if (age < 65) {
    print('Adult');
  } else {
    print('Senior');
  }
}
```

### Example 2: Login System

```dart
void main() {
  String correctUser = 'admin';
  String correctPass = 'secret123';

  String inputUser = 'admin';
  String inputPass = 'secret123';

  if (inputUser == correctUser && inputPass == correctPass) {
    print('Welcome, $inputUser!');
  } else if (inputUser != correctUser) {
    print('User not found');
  } else {
    print('Wrong password');
  }
}
```

### Example 3: Discount Calculator

```dart
void main() {
  double price = 150.0;
  bool isMember = true;
  int quantity = 3;

  double discount = 0;

  // Member discount
  if (isMember) {
    discount += 0.10;  // 10% off
  }

  // Bulk discount
  if (quantity >= 3) {
    discount += 0.05;  // 5% off
  }

  double finalPrice = price * quantity * (1 - discount);
  print('Total: \$${finalPrice.toStringAsFixed(2)}');
}
```

---

## Summary

### Key Syntax

```dart
// Simple if
if (condition) {
  // code
}

// If-else
if (condition) {
  // code if true
} else {
  // code if false
}

// If-else if-else
if (condition1) {
  // code
} else if (condition2) {
  // code
} else {
  // code
}

// Ternary
value = condition ? ifTrue : ifFalse;
```

### Key Rules

1. Conditions must be boolean (true/false)
2. Always use `{ }` (even for single lines)
3. Check specific conditions first
4. Don't nest too deep
5. Use `&&` for AND, `||` for OR, `!` for NOT

---

## Quick Quiz

**Q1:** What prints?
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
`B` - because 5 is not > 10, but 5 is > 3.
</details>

**Q2:** What's wrong?
```dart
if (x = 10) {
  print('Ten');
}
```

<details>
<summary>Answer</summary>
Uses `=` (assignment) instead of `==` (comparison). Should be `if (x == 10)`.
</details>

**Q3:** Simplify using ternary:
```dart
String msg;
if (score >= 60) {
  msg = 'Pass';
} else {
  msg = 'Fail';
}
```

<details>
<summary>Answer</summary>
`String msg = score >= 60 ? 'Pass' : 'Fail';`
</details>

---

**Next:** Let's learn about switch statements for multiple choices.

---

**Continue to:** `02-SwitchStatements.md`
