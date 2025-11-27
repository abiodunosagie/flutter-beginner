# Week 3, Day 1-2: Conditional Statements - Making Decisions

## 5-Year-Old Explanation

Imagine you're getting ready to go outside to play. Your mom says:

"IF it's raining, THEN take an umbrella. OTHERWISE, you can go without one."

This is a decision! You look outside. Is it raining?
- YES → Take the umbrella
- NO → Go without it

That's exactly what conditional statements do in programming! They help the computer make decisions.

**More everyday examples:**
- IF you finish your homework, THEN you can watch TV
- IF the cookie jar is empty, THEN we need to bake more cookies
- IF it's your birthday, THEN you get a cake!

In programming, we write these decisions like:
```
IF (something is true) {
  Do this thing
}
```

The computer checks: "Is this thing true?" If YES, it does what's inside the curly braces { }. If NO, it skips that part!

Think of it like a fork in the road - the computer needs to choose which path to take based on whether something is true or false. This is how we make programs that are smart and can respond differently to different situations!

---

## Programs Need to Make Decisions

Right now, your programs run the same way every time. But real apps need to:
- Show different messages based on user input
- Check if a password is correct
- Determine if a user is eligible
- Validate form data

**Conditional statements** let your program make decisions.

---

## The if Statement

### Basic Syntax

```dart
if (condition) {
  // Code here runs ONLY if condition is true
}
```

**Think of it as:** "IF this is true, THEN do this"

### Example 1: Simple Check

```dart
void main() {
  int age = 20;

  if (age >= 18) {
    print('You are an adult');
  }
}
```

**Output:** `You are an adult`

If age was 15, nothing would print because the condition is false.

### Example 2: User Authentication

```dart
void main() {
  String password = 'secret123';
  String userInput = 'secret123';

  if (password == userInput) {
    print('Login successful!');
  }
}
```

---

## The if-else Statement

What if you want to do something when the condition is **false**?

### Syntax

```dart
if (condition) {
  // Runs if true
} else {
  // Runs if false
}
```

### Example: Age Check

```dart
void main() {
  int age = 15;

  if (age >= 18) {
    print('You can vote');
  } else {
    print('You cannot vote yet');
  }
}
```

**Output:** `You cannot vote yet`

### Example: Login System

```dart
void main() {
  String correctPassword = 'flutter2024';
  String userPassword = 'wrong';

  if (userPassword == correctPassword) {
    print('✓ Access granted');
  } else {
    print('✗ Access denied');
  }
}
```

**Output:** `✗ Access denied`

---

## The if-else if-else Chain

When you have **multiple** conditions to check:

### Syntax

```dart
if (condition1) {
  // Runs if condition1 is true
} else if (condition2) {
  // Runs if condition1 is false but condition2 is true
} else if (condition3) {
  // Runs if condition1 and condition2 are false but condition3 is true
} else {
  // Runs if all conditions are false
}
```

**Important:** Only ONE block runs - the first one that's true.

### Example: Grade Calculator

```dart
void main() {
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
}
```

**Output:** `Grade: B`

Even though 85 >= 80, 85 >= 70, and 85 >= 60 are all true, only the first match runs.

### Example: Temperature Advice

```dart
void main() {
  int temp = 75;

  if (temp > 90) {
    print('It\'s very hot! Stay hydrated.');
  } else if (temp > 70) {
    print('Perfect weather!');
  } else if (temp > 50) {
    print('A bit cool, bring a jacket.');
  } else {
    print('It\'s cold! Bundle up!');
  }
}
```

**Output:** `Perfect weather!`

---

## Comparison Operators

Used in conditions to compare values:

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | Equal to | `5 == 5` | `true` |
| `!=` | Not equal to | `5 != 3` | `true` |
| `>` | Greater than | `5 > 3` | `true` |
| `<` | Less than | `5 < 3` | `false` |
| `>=` | Greater than or equal | `5 >= 5` | `true` |
| `<=` | Less than or equal | `5 <= 3` | `false` |

### Examples

```dart
void main() {
  int a = 10;
  int b = 5;

  print(a == b);  // false
  print(a != b);  // true
  print(a > b);   // true
  print(a < b);   // false
  print(a >= 10); // true
  print(b <= 5);  // true
}
```

### Common Mistake: = vs ==

```dart
int age = 25;  // ✓ Assignment (set age to 25)

if (age == 18) {  // ✓ Comparison (check if age equals 18)
  print('Just became an adult');
}

// if (age = 18) {  // ✗ ERROR! You're trying to assign, not compare
```

**Remember:**
- `=` assigns a value
- `==` checks equality

---

## Logical Operators

Combine multiple conditions:

### AND Operator (&&)

**Both** conditions must be true:

```dart
void main() {
  int age = 25;
  bool hasLicense = true;

  if (age >= 18 && hasLicense) {
    print('You can drive');
  } else {
    print('You cannot drive');
  }
}
```

**Truth Table:**
| Condition 1 | Condition 2 | Result |
|-------------|-------------|--------|
| true | true | **true** |
| true | false | false |
| false | true | false |
| false | false | false |

### OR Operator (||)

**At least one** condition must be true:

```dart
void main() {
  String day = 'Saturday';

  if (day == 'Saturday' || day == 'Sunday') {
    print('It\'s the weekend!');
  } else {
    print('It\'s a weekday.');
  }
}
```

**Truth Table:**
| Condition 1 | Condition 2 | Result |
|-------------|-------------|--------|
| true | true | **true** |
| true | false | **true** |
| false | true | **true** |
| false | false | false |

### NOT Operator (!)

Reverses the condition:

```dart
void main() {
  bool isRaining = false;

  if (!isRaining) {
    print('Go outside!');
  } else {
    print('Stay inside.');
  }
}
```

**Truth Table:**
| Condition | Result |
|-----------|--------|
| true | false |
| false | true |

### Combining Multiple Operators

```dart
void main() {
  int age = 25;
  bool hasTicket = true;
  bool hasID = true;

  // Must be 18+, have ticket, and have ID
  if (age >= 18 && hasTicket && hasID) {
    print('Welcome to the concert!');
  } else {
    print('Entry denied');
  }
}
```

### Complex Conditions with Parentheses

```dart
void main() {
  int age = 16;
  bool withParent = true;
  bool hasTicket = true;

  // (18 or older) OR (under 18 but with parent)
  if ((age >= 18 || withParent) && hasTicket) {
    print('You can enter');
  } else {
    print('Cannot enter');
  }
}
```

---

## Nested if Statements

Put an `if` inside another `if`:

```dart
void main() {
  int age = 25;
  bool hasLicense = true;
  bool hasInsurance = true;

  if (age >= 18) {
    if (hasLicense) {
      if (hasInsurance) {
        print('You can rent a car');
      } else {
        print('Need insurance');
      }
    } else {
      print('Need a license');
    }
  } else {
    print('Too young');
  }
}
```

**Better way** using logical operators:

```dart
void main() {
  int age = 25;
  bool hasLicense = true;
  bool hasInsurance = true;

  if (age >= 18 && hasLicense && hasInsurance) {
    print('You can rent a car');
  } else if (age < 18) {
    print('Too young');
  } else if (!hasLicense) {
    print('Need a license');
  } else {
    print('Need insurance');
  }
}
```

---

## Type Test Operators

Check the type of a variable:

### is Operator

```dart
void main() {
  var value = 42;

  if (value is int) {
    print('This is an integer');
  }

  if (value is String) {
    print('This is a string');
  } else {
    print('This is not a string');
  }
}
```

### is! Operator (is not)

```dart
void main() {
  var value = 'Hello';

  if (value is! int) {
    print('This is not an integer');
  }
}
```

---

## Ternary Operator - Shorthand if-else

For simple conditions, you can use a one-liner:

### Syntax

```dart
condition ? valueIfTrue : valueIfFalse
```

### Examples

```dart
void main() {
  int age = 20;

  // Long way
  String status1;
  if (age >= 18) {
    status1 = 'adult';
  } else {
    status1 = 'minor';
  }

  // Short way (ternary)
  String status2 = age >= 18 ? 'adult' : 'minor';

  print(status2);  // adult
}
```

**More examples:**

```dart
void main() {
  int score = 85;
  String result = score >= 60 ? 'Pass' : 'Fail';
  print(result);  // Pass

  int a = 10;
  int b = 20;
  int max = a > b ? a : b;
  print('Max: $max');  // Max: 20

  bool isWeekend = true;
  String plan = isWeekend ? 'Relax' : 'Work';
  print(plan);  // Relax
}
```

**When to use:**
- ✓ Simple, one-line decisions
- ✗ Complex logic (use regular if-else)

---

## Exercises

### Exercise 1: Even or Odd
Check if a number is even or odd.

**Hint:** Use the modulo operator `%`. If `number % 2 == 0`, it's even.

<details>
<summary>Solution</summary>

```dart
void main() {
  int number = 7;

  if (number % 2 == 0) {
    print('$number is even');
  } else {
    print('$number is odd');
  }
}
```
</details>

---

### Exercise 2: Largest of Three
Find the largest of three numbers.

<details>
<summary>Solution</summary>

```dart
void main() {
  int a = 10;
  int b = 25;
  int c = 15;

  if (a >= b && a >= c) {
    print('$a is largest');
  } else if (b >= a && b >= c) {
    print('$b is largest');
  } else {
    print('$c is largest');
  }
}
```
</details>

---

### Exercise 3: Login System
Create a simple login with username and password check.

Username: "admin"
Password: "pass123"

<details>
<summary>Solution</summary>

```dart
void main() {
  String correctUser = 'admin';
  String correctPass = 'pass123';

  String inputUser = 'admin';
  String inputPass = 'pass123';

  if (inputUser == correctUser && inputPass == correctPass) {
    print('✓ Login successful!');
  } else if (inputUser != correctUser) {
    print('✗ Invalid username');
  } else {
    print('✗ Invalid password');
  }
}
```
</details>

---

### Exercise 4: Ticket Pricing
Calculate ticket price based on age:
- Under 5: Free
- 5-17: $10
- 18-64: $20
- 65+: $15 (senior discount)

<details>
<summary>Solution</summary>

```dart
void main() {
  int age = 30;
  int price;

  if (age < 5) {
    price = 0;
  } else if (age < 18) {
    price = 10;
  } else if (age < 65) {
    price = 20;
  } else {
    price = 15;
  }

  print('Age: $age');
  print('Ticket price: \$$price');
}
```
</details>

---

### Exercise 5: BMI Calculator with Categories
Calculate BMI and categorize:
- BMI < 18.5: Underweight
- BMI 18.5-24.9: Normal
- BMI 25-29.9: Overweight
- BMI >= 30: Obese

Formula: `BMI = weight / (height * height)` (weight in kg, height in meters)

<details>
<summary>Solution</summary>

```dart
void main() {
  double weight = 70;  // kg
  double height = 1.75;  // meters

  double bmi = weight / (height * height);

  print('BMI: ${bmi.toStringAsFixed(1)}');

  if (bmi < 18.5) {
    print('Category: Underweight');
  } else if (bmi < 25) {
    print('Category: Normal');
  } else if (bmi < 30) {
    print('Category: Overweight');
  } else {
    print('Category: Obese');
  }
}
```
</details>

---

## Key Takeaways

1. **`if` executes code when condition is true**
2. **`else` handles the false case**
3. **`else if` chains multiple conditions**
4. **Comparison operators:** `==`, `!=`, `>`, `<`, `>=`, `<=`
5. **Logical operators:** `&&` (AND), `||` (OR), `!` (NOT)
6. **Ternary operator** for simple conditions
7. **Use parentheses** to clarify complex conditions

---

## What's Next?

Tomorrow:
- **Switch statements** - cleaner way to handle multiple values
- **When to use switch vs if-else**

You're building logic! This is where programming gets powerful. 🚀
