# Level 2 Exercises: Control Flow

Welcome! These exercises teach you how to control the flow of your programs with decisions and loops. Each part builds on the previous one!

**How these exercises work:**
- Each PART focuses on ONE control flow concept
- Within each part, exercises build on each other progressively
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll master control flow!

---

## PART 1: If Statements

Learn to make decisions in your programs.

### Exercise 1.1: Simple If ⭐

**Goal:** Check a single condition.

**Your Task:** Print a message only if someone is an adult.

```dart
void main() {
  int age = 20;

  // TODO: If age >= 18, print "You are an adult"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int age = 20;

  if (age >= 18) {
    print('You are an adult');
  }
}
```
</details>

---

### Exercise 1.2: If-Else ⭐

**Goal:** Handle two cases - true or false.

**Your Task:** Print different messages for adult vs not adult.

```dart
void main() {
  int age = 15;

  // TODO: If age >= 18, print "You are an adult"
  // TODO: Else, print "You are not an adult"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int age = 15;

  if (age >= 18) {
    print('You are an adult');
  } else {
    print('You are not an adult');
  }
}
```
</details>

---

### Exercise 1.3: Multiple Conditions ⭐

**Goal:** Check for multiple age ranges.

**Your Task:** Categorize age into three groups.

```dart
void main() {
  int age = 25;

  // TODO: If age < 18, print "Minor"
  // TODO: Else if age < 65, print "Adult"
  // TODO: Else, print "Senior"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int age = 25;

  if (age < 18) {
    print('Minor');
  } else if (age < 65) {
    print('Adult');
  } else {
    print('Senior');
  }
}
```
</details>

---

### Exercise 1.4: Grade Calculator ⭐⭐

**Goal:** Convert a score to a letter grade.

**Your Task:** Use if-else if chains to assign grades.

```dart
void main() {
  int score = 85;

  // TODO: Assign grade based on score:
  // 90+: A, 80-89: B, 70-79: C, 60-69: D, Below 60: F
  // TODO: Print the grade
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int score = 85;

  String grade;

  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else if (score >= 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }

  print('Score: $score, Grade: $grade');
}
```
</details>

---

### Exercise 1.5: Age Category Challenge ⭐⭐

**Goal:** Create detailed age categories - NO scaffolding!

**Requirements:**
Categorize age into:
- 0-2: Baby
- 3-12: Child
- 13-19: Teenager
- 20-64: Adult
- 65+: Senior

Given: `int age = 25;`

Print: `Age 25 is: Adult`

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int age = 25;

  String category;

  if (age <= 2) {
    category = 'Baby';
  } else if (age <= 12) {
    category = 'Child';
  } else if (age <= 19) {
    category = 'Teenager';
  } else if (age <= 64) {
    category = 'Adult';
  } else {
    category = 'Senior';
  }

  print('Age $age is: $category');
}
```
</details>

---

## PART 2: Switch Statements

Learn to handle multiple specific values cleanly.

### Exercise 2.1: Day of Week ⭐

**Goal:** Convert a day number to its name.

**Your Task:** Use switch to print day names.

```dart
void main() {
  int day = 3;

  // TODO: Use switch to print day name
  // 1: Monday, 2: Tuesday, 3: Wednesday, etc.
  // default: Invalid day
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int day = 3;

  switch (day) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    case 3:
      print('Wednesday');
      break;
    case 4:
      print('Thursday');
      break;
    case 5:
      print('Friday');
      break;
    case 6:
      print('Saturday');
      break;
    case 7:
      print('Sunday');
      break;
    default:
      print('Invalid day');
  }
}
```
</details>

---

### Exercise 2.2: Weekend or Weekday ⭐

**Goal:** Group multiple cases together.

**Your Task:** Check if a day is weekend or weekday.

```dart
void main() {
  int day = 6;

  // TODO: Use switch with multiple cases
  // 1-5: Weekday, 6-7: Weekend
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int day = 6;

  switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      print('Weekday');
      break;
    case 6:
    case 7:
      print('Weekend');
      break;
    default:
      print('Invalid day');
  }
}
```
</details>

---

### Exercise 2.3: Simple Calculator ⭐⭐

**Goal:** Build a calculator with switch.

**Your Task:** Perform operations based on operator.

```dart
void main() {
  int a = 10;
  int b = 3;
  String operator = '+';

  // TODO: Use switch to calculate based on operator
  // +, -, *, /, %
  // Handle division by zero for / and %
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int a = 10;
  int b = 3;
  String operator = '+';

  switch (operator) {
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
      if (b != 0) {
        print('$a / $b = ${a / b}');
      } else {
        print('Error: Division by zero');
      }
      break;
    case '%':
      if (b != 0) {
        print('$a % $b = ${a % b}');
      } else {
        print('Error: Division by zero');
      }
      break;
    default:
      print('Unknown operator');
  }
}
```
</details>

---

## PART 3: For Loops

Learn to repeat actions a specific number of times.

### Exercise 3.1: Count to 10 ⭐

**Goal:** Print numbers from 1 to 10.

**Your Task:** Use a for loop to count.

```dart
void main() {
  // TODO: Print numbers 1 to 10, each on new line
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  for (int i = 1; i <= 10; i++) {
    print(i);
  }
}
```
</details>

---

### Exercise 3.2: Count Down ⭐

**Goal:** Print numbers from 10 to 1.

**Your Task:** Use a for loop to count backwards.

```dart
void main() {
  // TODO: Print numbers 10 to 1, each on new line
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  for (int i = 10; i >= 1; i--) {
    print(i);
  }
}
```
</details>

---

### Exercise 3.3: Sum of Numbers ⭐⭐

**Goal:** Calculate sum of 1 to 100.

**Your Task:** Use a for loop to sum numbers.

```dart
void main() {
  // TODO: Calculate sum of 1 + 2 + 3 + ... + 100
  // TODO: Print the result
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int sum = 0;

  for (int i = 1; i <= 100; i++) {
    sum += i;
  }

  print('Sum: $sum');
}
```
</details>

---

### Exercise 3.4: FizzBuzz Challenge ⭐⭐

**Goal:** The classic FizzBuzz problem!

**Requirements:**
Print numbers 1 to 30, but:
- If divisible by 3: print "Fizz"
- If divisible by 5: print "Buzz"
- If divisible by both: print "FizzBuzz"
- Otherwise: print the number

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  for (int i = 1; i <= 30; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
      print('FizzBuzz');
    } else if (i % 3 == 0) {
      print('Fizz');
    } else if (i % 5 == 0) {
      print('Buzz');
    } else {
      print(i);
    }
  }
}
```
</details>

---

## PART 4: While Loops

Learn to repeat while a condition is true.

### Exercise 4.1: Count with While ⭐

**Goal:** Print numbers using while loop.

**Your Task:** Count from 1 to 5 using while.

```dart
void main() {
  int i = 1;

  // TODO: While i <= 5, print i and increment
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int i = 1;

  while (i <= 5) {
    print(i);
    i++;
  }
}
```
</details>

---

### Exercise 4.2: Do-While ⭐

**Goal:** Use a do-while loop.

**Your Task:** Print numbers 1 to 5 using do-while.

```dart
void main() {
  int i = 1;

  // TODO: Use do-while to print numbers
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int i = 1;

  do {
    print(i);
    i++;
  } while (i <= 5);
}
```
</details>

---

### Exercise 4.3: Sum of Digits ⭐⭐

**Goal:** Add all digits in a number.

**Your Task:** Extract and sum each digit.

Given: `int number = 12345;`
Expected: `Sum of digits: 15` (1+2+3+4+5)

```dart
void main() {
  int number = 12345;

  // TODO: Sum all digits using while loop
  // Hint: Use % 10 to get last digit, ~/ 10 to remove it
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 12345;
  int sum = 0;

  while (number > 0) {
    sum += number % 10;  // Add last digit
    number ~/= 10;        // Remove last digit
  }

  print('Sum of digits: $sum');
}
```
</details>

---

### Exercise 4.4: Reverse Number Challenge ⭐⭐

**Goal:** Reverse the digits of a number - NO scaffolding!

**Requirements:**
Given: `int number = 12345;`
Expected: `Reversed: 54321`

Hint: Build the reverse by extracting digits one by one.

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 12345;
  int reversed = 0;

  while (number > 0) {
    int digit = number % 10;
    reversed = reversed * 10 + digit;
    number ~/= 10;
  }

  print('Reversed: $reversed');
}
```
</details>

---

## PART 5: Loop Control

Learn to control loops with break and continue.

### Exercise 5.1: Break on 5 ⭐

**Goal:** Exit loop when reaching a value.

**Your Task:** Print 1-10 but stop at 5.

```dart
void main() {
  // TODO: Loop 1-10, but break when i == 5
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  for (int i = 1; i <= 10; i++) {
    if (i == 5) {
      break;
    }
    print(i);
  }
}
```
</details>

---

### Exercise 5.2: Skip Even Numbers ⭐

**Goal:** Use continue to skip values.

**Your Task:** Print only odd numbers from 1-10.

```dart
void main() {
  // TODO: Loop 1-10, continue if even, print if odd
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) {
      continue;  // Skip even numbers
    }
    print(i);
  }
}
```
</details>

---

### Exercise 5.3: Prime Number Checker ⭐⭐⭐

**Goal:** Check if a number is prime.

**Your Task:** Use loops and break to check for factors.

Given: `int number = 17;`

A prime number is only divisible by 1 and itself.

```dart
void main() {
  int number = 17;

  // TODO: Check if number is prime
  // Hint: Loop from 2 to number-1, if any divides evenly, it's not prime
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 17;
  bool isPrime = true;

  if (number <= 1) {
    isPrime = false;
  } else {
    for (int i = 2; i < number; i++) {
      if (number % i == 0) {
        isPrime = false;
        break;  // Found a factor, no need to continue
      }
    }
  }

  if (isPrime) {
    print('$number is prime');
  } else {
    print('$number is not prime');
  }
}
```
</details>

---

## FINAL PROJECT: Password Validator ⭐⭐⭐

**Goal:** Build a complete password validator!

**Your Task:** Check if a password is strong - NO scaffolding!

### Requirements:

Given a password string, check:
1. Length >= 8 characters
2. Contains at least one uppercase letter
3. Contains at least one lowercase letter
4. Contains at least one digit
5. Contains at least one special character (!@#$%^&*)

Print: `Password is valid` or `Password is invalid: [reasons]`

**Example:**
```dart
String password = 'Abc123!@';
```

Expected: `Password is valid`

**Example 2:**
```dart
String password = 'weak';
```

Expected: `Password is invalid: too short, no uppercase, no digits, no special chars`

**Hints:**
- Use a for loop to check each character
- Use String methods like contains()
- Track what's missing in boolean variables

**Build this completely on your own!**

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String password = 'Abc123!@';

  bool isLongEnough = password.length >= 8;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasDigit = false;
  bool hasSpecial = false;

  // Check each character
  for (int i = 0; i < password.length; i++) {
    String char = password[i];

    if (char.toUpperCase() != char.toLowerCase()) {
      // It's a letter
      if (char == char.toUpperCase()) {
        hasUppercase = true;
      } else {
        hasLowercase = true;
      }
    } else if (int.tryParse(char) != null) {
      hasDigit = true;
    } else if ('!@#\$%^&*'.contains(char)) {
      hasSpecial = true;
    }
  }

  // Check all conditions
  bool isValid = isLongEnough && hasUppercase && hasLowercase && hasDigit && hasSpecial;

  if (isValid) {
    print('Password is valid');
  } else {
    print('Password is invalid:');
    if (!isLongEnough) print('- Too short (minimum 8 characters)');
    if (!hasUppercase) print('- No uppercase letter');
    if (!hasLowercase) print('- No lowercase letter');
    if (!hasDigit) print('- No digit');
    if (!hasSpecial) print('- No special character');
  }
}
```
</details>

---

## Submission Checklist

Before moving to Level 3, make sure you can:

- [ ] Use if, else if, and else statements correctly
- [ ] Write switch statements for multiple values
- [ ] Create for loops to repeat code
- [ ] Use while and do-while loops
- [ ] Apply break to exit loops early
- [ ] Apply continue to skip loop iterations
- [ ] Combine conditions with && and ||
- [ ] Choose between if/switch and for/while appropriately
- [ ] Solve problems without looking at solutions first

---

## Bonus Challenge: Pyramid Pattern ⭐⭐⭐

Print a pyramid of numbers:
```
    1
   121
  12321
 1234321
123454321
```

Use nested for loops!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int rows = 5;

  for (int i = 1; i <= rows; i++) {
    // Print spaces
    for (int j = 1; j <= rows - i; j++) {
      stdout.write(' ');
    }

    // Print ascending numbers
    for (int j = 1; j <= i; j++) {
      stdout.write(j);
    }

    // Print descending numbers
    for (int j = i - 1; j >= 1; j--) {
      stdout.write(j);
    }

    print('');  // New line
  }
}
```

Note: Need `import 'dart:io';` for stdout.
</details>

---

**Congratulations!** You've completed Level 2!

You now understand control flow. Time to learn functions and code organization!

---

**Continue to:** `../../Level-03-Functions-Collections/README.md`
