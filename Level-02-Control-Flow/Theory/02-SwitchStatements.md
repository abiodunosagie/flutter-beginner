# Switch Statements: Multiple Choices

## What Is a Switch Statement?

A **switch** statement checks one value against many possible matches.

Think of it like a vending machine:
- Press A1 → get chips
- Press A2 → get candy
- Press A3 → get cookies
- Anything else → "Invalid selection"

---

## Basic Switch Syntax

```dart
String grade = 'B';

switch (grade) {
  case 'A':
    print('Excellent!');
    break;
  case 'B':
    print('Good job!');
    break;
  case 'C':
    print('Passed');
    break;
  default:
    print('Try harder');
}
```

**Output:** `Good job!`

**How it works:**
1. Look at `grade` (which is 'B')
2. Is it 'A'? No, skip
3. Is it 'B'? YES! Run this code
4. `break` exits the switch
5. Done!

---

## Why Use Switch Instead of If-Else?

### With If-Else (Repetitive)

```dart
if (day == 'Monday') {
  print('Start of week');
} else if (day == 'Tuesday') {
  print('Second day');
} else if (day == 'Wednesday') {
  print('Midweek');
} else if (day == 'Thursday') {
  print('Almost Friday');
} else if (day == 'Friday') {
  print('TGIF!');
} else {
  print('Weekend!');
}
```

### With Switch (Cleaner)

```dart
switch (day) {
  case 'Monday':
    print('Start of week');
    break;
  case 'Tuesday':
    print('Second day');
    break;
  case 'Wednesday':
    print('Midweek');
    break;
  case 'Thursday':
    print('Almost Friday');
    break;
  case 'Friday':
    print('TGIF!');
    break;
  default:
    print('Weekend!');
}
```

**Use switch when:** You're comparing ONE value against MANY exact matches.

---

## The Parts of a Switch

```dart
switch (valueToCheck) {    // 1. The value we're checking
  case value1:             // 2. A possible match
    // code to run
    break;                 // 3. Exit the switch
  case value2:
    // code
    break;
  default:                 // 4. If nothing else matches
    // code
}
```

### The `break` Statement

`break` exits the switch. Without it, code "falls through" to the next case:

```dart
int num = 1;

// ❌ Without break (falls through!)
switch (num) {
  case 1:
    print('One');
    // Missing break!
  case 2:
    print('Two');
    break;
}
// Output: One, Two  (both print!)

// ✅ With break (correct)
switch (num) {
  case 1:
    print('One');
    break;
  case 2:
    print('Two');
    break;
}
// Output: One
```

### The `default` Case

Runs when no cases match:

```dart
String fruit = 'mango';

switch (fruit) {
  case 'apple':
    print('Red fruit');
    break;
  case 'banana':
    print('Yellow fruit');
    break;
  default:
    print('Unknown fruit');
}
// Output: Unknown fruit
```

---

## Combining Cases

When multiple values should do the same thing:

```dart
String day = 'Saturday';

switch (day) {
  case 'Saturday':
  case 'Sunday':
    print('Weekend!');
    break;
  case 'Monday':
  case 'Tuesday':
  case 'Wednesday':
  case 'Thursday':
  case 'Friday':
    print('Weekday');
    break;
  default:
    print('Invalid day');
}
```

---

## Switch with Different Types

### With Integers

```dart
int month = 3;

switch (month) {
  case 1:
    print('January');
    break;
  case 2:
    print('February');
    break;
  case 3:
    print('March');
    break;
  // ... etc
  default:
    print('Invalid month');
}
```

### With Enums (Best Practice)

```dart
enum Color { red, green, blue }

Color selected = Color.green;

switch (selected) {
  case Color.red:
    print('Stop');
    break;
  case Color.green:
    print('Go');
    break;
  case Color.blue:
    print('Water');
    break;
}
```

---

## Switch Expressions (Dart 3.0+)

A shorter way to return a value:

```dart
String day = 'Monday';

String type = switch (day) {
  'Saturday' || 'Sunday' => 'Weekend',
  'Monday' => 'Start of week',
  'Friday' => 'TGIF',
  _ => 'Weekday',  // _ is like default
};

print(type);  // Start of week
```

This is cleaner when you're assigning a value.

---

## Practical Examples

### Example 1: Calculator Operation

```dart
void main() {
  int a = 10;
  int b = 3;
  String op = '+';

  switch (op) {
    case '+':
      print('$a + $b = ${a + b}');
      break;
    case '-':
      print('$a - $b = ${a - b}');
      break;
    case '*':
      print('$a * $b = ${a * b}');
      break;
    case '/':
      print('$a / $b = ${a / b}');
      break;
    default:
      print('Unknown operation');
  }
}
```

### Example 2: Day of Week

```dart
void main() {
  int dayNum = 3;  // 1 = Monday, 7 = Sunday

  String dayName = switch (dayNum) {
    1 => 'Monday',
    2 => 'Tuesday',
    3 => 'Wednesday',
    4 => 'Thursday',
    5 => 'Friday',
    6 => 'Saturday',
    7 => 'Sunday',
    _ => 'Invalid',
  };

  print('Day $dayNum is $dayName');
}
```

### Example 3: Season Finder

```dart
void main() {
  int month = 7;

  switch (month) {
    case 12:
    case 1:
    case 2:
      print('Winter');
      break;
    case 3:
    case 4:
    case 5:
      print('Spring');
      break;
    case 6:
    case 7:
    case 8:
      print('Summer');
      break;
    case 9:
    case 10:
    case 11:
      print('Fall');
      break;
    default:
      print('Invalid month');
  }
}
```

---

## When to Use Switch vs If-Else

### Use Switch When:
- Comparing ONE value against MANY exact matches
- Working with enums
- The logic is simple (just matching values)

### Use If-Else When:
- Checking ranges (`age >= 18`)
- Complex conditions (`a > 10 && b < 5`)
- Different variables (`a > b`)

```dart
// ❌ Bad use of if-else (many exact matches)
if (day == 'Mon') ...
else if (day == 'Tue') ...
// Switch is better!

// ❌ Bad use of switch (can't do ranges)
switch (age) {
  case 18:  // Can only match exact values!
}
// If-else is better for ranges
```

---

## Summary

### Switch Syntax

```dart
switch (value) {
  case match1:
    // code
    break;
  case match2:
  case match3:  // Multiple cases
    // code
    break;
  default:
    // code
}
```

### Switch Expression (Dart 3.0+)

```dart
var result = switch (value) {
  pattern1 => result1,
  pattern2 => result2,
  _ => defaultResult,
};
```

---

## Quick Quiz

**Q1:** What's missing?
```dart
switch (x) {
  case 1:
    print('One');
  case 2:
    print('Two');
}
```

<details>
<summary>Answer</summary>
Missing `break` statements. Without them, if x is 1, it prints both "One" and "Two".
</details>

**Q2:** What does `default` do?

<details>
<summary>Answer</summary>
Runs when no other case matches. It's like `else` in an if statement.
</details>

---

**Next:** Let's learn about for loops!

---

**Continue to:** `03-ForLoops.md`
