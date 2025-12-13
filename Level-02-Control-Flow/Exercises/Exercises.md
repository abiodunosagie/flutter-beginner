# Level 2 Exercises: Control Flow

Test your understanding of if/else, switch, loops, and loop control!

---

## Exercise 1: Age Category

**Difficulty:** ⭐ Easy

Write a program that categorizes a person based on their age:
- 0-2: Baby
- 3-12: Child
- 13-19: Teenager
- 20-64: Adult
- 65+: Senior

```dart
void main() {
  int age = 25;

  // TODO: Print the category based on age
}
```

<details>
<summary>💡 Hint</summary>

Use if-else if-else chain. Start from the lowest range and work up.

</details>

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

## Exercise 2: Calculator with Switch

**Difficulty:** ⭐ Easy

Create a simple calculator using switch:

```dart
void main() {
  int a = 10;
  int b = 3;
  String operator = '%'; // Try: +, -, *, /, %

  // TODO: Calculate and print result based on operator
  // Handle division by zero!
}
```

<details>
<summary>💡 Hint</summary>

Use switch on the operator string. For division and modulo, check if b is 0 first.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int a = 10;
  int b = 3;
  String operator = '%';

  switch (operator) {
    case '+':
      print('$a + $b = ${a + b}');
      break;
    case '-':
      print('$a - $b = ${a - b}');
      break;
    case '*':
      print('$a × $b = ${a * b}');
      break;
    case '/':
      if (b == 0) {
        print('Error: Cannot divide by zero!');
      } else {
        print('$a ÷ $b = ${a / b}');
      }
      break;
    case '%':
      if (b == 0) {
        print('Error: Cannot divide by zero!');
      } else {
        print('$a % $b = ${a % b}');
      }
      break;
    default:
      print('Unknown operator: $operator');
  }
}
```

</details>

---

## Exercise 3: FizzBuzz

**Difficulty:** ⭐⭐ Medium

The classic programming challenge! Print numbers 1-30, but:
- For multiples of 3, print "Fizz"
- For multiples of 5, print "Buzz"
- For multiples of both 3 and 5, print "FizzBuzz"

```dart
void main() {
  // TODO: Print FizzBuzz for numbers 1 to 30
}
```

<details>
<summary>💡 Hint</summary>

Check divisible by both 3 AND 5 FIRST, then by 3, then by 5. Order matters!

</details>

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

**Alternative using string building:**

```dart
void main() {
  for (int i = 1; i <= 30; i++) {
    String output = '';

    if (i % 3 == 0) output += 'Fizz';
    if (i % 5 == 0) output += 'Buzz';

    print(output.isEmpty ? i : output);
  }
}
```

</details>

---

## Exercise 4: Prime Number Checker

**Difficulty:** ⭐⭐ Medium

Check if a number is prime (only divisible by 1 and itself):

```dart
void main() {
  int number = 17;

  // TODO: Check if number is prime
  // Print "X is prime" or "X is not prime"
}
```

<details>
<summary>💡 Hint</summary>

A number is prime if no number from 2 to sqrt(number) divides it evenly.
Use break to exit early if you find a divisor.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 17;

  if (number <= 1) {
    print('$number is not prime');
  } else if (number <= 3) {
    print('$number is prime');
  } else {
    bool isPrime = true;

    for (int i = 2; i * i <= number; i++) {
      if (number % i == 0) {
        isPrime = false;
        break;
      }
    }

    if (isPrime) {
      print('$number is prime');
    } else {
      print('$number is not prime');
    }
  }
}
```

</details>

---

## Exercise 5: Sum of Digits

**Difficulty:** ⭐⭐ Medium

Calculate the sum of all digits in a number using a while loop:

```dart
void main() {
  int number = 12345;

  // TODO: Calculate sum of digits (1+2+3+4+5 = 15)
}
```

<details>
<summary>💡 Hint</summary>

Use `% 10` to get the last digit, `~/ 10` to remove the last digit.
Loop while number > 0.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 12345;
  int original = number;
  int sum = 0;

  while (number > 0) {
    int digit = number % 10;  // Get last digit
    sum += digit;
    number ~/= 10;  // Remove last digit
  }

  print('Sum of digits in $original is $sum');
}
```

</details>

---

## Exercise 6: Reverse a Number

**Difficulty:** ⭐⭐ Medium

Reverse the digits of a number using a while loop:

```dart
void main() {
  int number = 12345;

  // TODO: Reverse to get 54321
}
```

<details>
<summary>💡 Hint</summary>

Build the reversed number by multiplying by 10 and adding each digit.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int number = 12345;
  int original = number;
  int reversed = 0;

  while (number > 0) {
    int digit = number % 10;
    reversed = reversed * 10 + digit;
    number ~/= 10;
  }

  print('$original reversed is $reversed');
}
```

</details>

---

## Exercise 7: Find First and Last Occurrence

**Difficulty:** ⭐⭐ Medium

Find the first and last position of a value in a list:

```dart
void main() {
  List<int> numbers = [1, 3, 5, 3, 7, 3, 9];
  int target = 3;

  // TODO: Find first and last index of target
  // Output: "First: 1, Last: 5"
}
```

<details>
<summary>💡 Hint</summary>

Use one loop going forward (with break for first), another going backward (with break for last).
Or use a single loop and update lastIndex whenever you find a match.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<int> numbers = [1, 3, 5, 3, 7, 3, 9];
  int target = 3;

  int firstIndex = -1;
  int lastIndex = -1;

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == target) {
      if (firstIndex == -1) {
        firstIndex = i;  // First occurrence
      }
      lastIndex = i;  // Keep updating for last
    }
  }

  if (firstIndex == -1) {
    print('$target not found');
  } else {
    print('First: $firstIndex, Last: $lastIndex');
  }
}
```

</details>

---

## Exercise 8: Pyramid of Numbers

**Difficulty:** ⭐⭐⭐ Hard

Print a centered pyramid with row numbers:

```
    1
   222
  33333
 4444444
555555555
```

```dart
void main() {
  int height = 5;

  // TODO: Print the number pyramid
}
```

<details>
<summary>💡 Hint</summary>

For row i: spaces = height - i, numbers = 2*i - 1.
Use nested loops or string multiplication.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int height = 5;

  for (int row = 1; row <= height; row++) {
    // Leading spaces
    String spaces = ' ' * (height - row);

    // Numbers
    String numbers = '$row' * (2 * row - 1);

    print(spaces + numbers);
  }
}
```

</details>

---

## Exercise 9: Validate Password

**Difficulty:** ⭐⭐⭐ Hard

Check if a password meets ALL requirements:
- At least 8 characters
- Contains at least one uppercase letter
- Contains at least one lowercase letter
- Contains at least one digit
- Contains at least one special character (!@#$%^&*)

```dart
void main() {
  String password = 'MyPass123!';

  // TODO: Validate and print which requirements pass/fail
}
```

<details>
<summary>💡 Hint</summary>

Use boolean flags for each requirement. Loop through each character and set flags.
Use `continue` to skip to next character after checking.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String password = 'MyPass123!';

  bool hasLength = password.length >= 8;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasDigit = false;
  bool hasSpecial = false;

  String specialChars = '!@#\$%^&*';

  for (int i = 0; i < password.length; i++) {
    String char = password[i];

    if (char.toUpperCase() != char.toLowerCase()) {
      // It's a letter
      if (char == char.toUpperCase()) {
        hasUpper = true;
      }
      if (char == char.toLowerCase()) {
        hasLower = true;
      }
    } else if ('0123456789'.contains(char)) {
      hasDigit = true;
    } else if (specialChars.contains(char)) {
      hasSpecial = true;
    }
  }

  print('Password: $password');
  print('---');
  print('${hasLength ? "✓" : "✗"} At least 8 characters');
  print('${hasUpper ? "✓" : "✗"} Has uppercase');
  print('${hasLower ? "✓" : "✗"} Has lowercase');
  print('${hasDigit ? "✓" : "✗"} Has digit');
  print('${hasSpecial ? "✓" : "✗"} Has special character');
  print('---');

  bool isValid = hasLength && hasUpper && hasLower && hasDigit && hasSpecial;
  print('Password is ${isValid ? "VALID" : "INVALID"}');
}
```

</details>

---

## Exercise 10: Find All Pairs

**Difficulty:** ⭐⭐⭐ Hard

Find all pairs of numbers in a list that add up to a target sum:

```dart
void main() {
  List<int> numbers = [1, 5, 7, 2, 9, 3, 6, 8];
  int targetSum = 10;

  // TODO: Find and print all pairs that sum to targetSum
  // Example: (1, 9), (2, 8), (3, 7)
}
```

<details>
<summary>💡 Hint</summary>

Use nested loops. Outer loop: first number. Inner loop: second number (starting after first).
Use continue to skip invalid pairs.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<int> numbers = [1, 5, 7, 2, 9, 3, 6, 8];
  int targetSum = 10;

  print('Pairs that sum to $targetSum:');

  int pairsFound = 0;

  for (int i = 0; i < numbers.length; i++) {
    for (int j = i + 1; j < numbers.length; j++) {
      if (numbers[i] + numbers[j] == targetSum) {
        print('(${numbers[i]}, ${numbers[j]})');
        pairsFound++;
      }
    }
  }

  if (pairsFound == 0) {
    print('No pairs found');
  } else {
    print('Total pairs: $pairsFound');
  }
}
```

</details>

---

## Bonus Challenge: Mini Game Loop

**Difficulty:** ⭐⭐⭐⭐ Expert

Create a simple text-based adventure using all control flow concepts:

```dart
void main() {
  // Create a game where:
  // 1. Player has health (starts at 100)
  // 2. Each round, show menu: Attack, Defend, Heal, Run
  // 3. Random enemy attacks back
  // 4. Game ends when health <= 0 or player runs
  // 5. Track rounds survived
}
```

<details>
<summary>✅ Solution</summary>

```dart
import 'dart:math';

void main() {
  int playerHealth = 100;
  int enemyHealth = 80;
  int rounds = 0;
  bool gameOver = false;
  Random random = Random();

  // Simulate player choices
  List<int> choices = [1, 2, 1, 3, 1, 2, 1, 1, 4];
  int choiceIndex = 0;

  print('=== BATTLE BEGINS ===');
  print('Your health: $playerHealth');
  print('Enemy health: $enemyHealth\n');

  while (!gameOver && choiceIndex < choices.length) {
    rounds++;
    print('--- Round $rounds ---');
    print('Your HP: $playerHealth | Enemy HP: $enemyHealth');
    print('1. Attack  2. Defend  3. Heal  4. Run');

    int choice = choices[choiceIndex];
    print('You chose: $choice\n');
    choiceIndex++;

    bool defending = false;

    switch (choice) {
      case 1: // Attack
        int damage = random.nextInt(20) + 10;
        enemyHealth -= damage;
        print('You attack for $damage damage!');
        break;

      case 2: // Defend
        defending = true;
        print('You brace for impact!');
        break;

      case 3: // Heal
        int heal = random.nextInt(15) + 5;
        playerHealth += heal;
        if (playerHealth > 100) playerHealth = 100;
        print('You heal for $heal HP!');
        break;

      case 4: // Run
        print('You fled the battle!');
        gameOver = true;
        continue;
    }

    // Check enemy death
    if (enemyHealth <= 0) {
      print('\nENEMY DEFEATED! You won in $rounds rounds!');
      gameOver = true;
      continue;
    }

    // Enemy attacks
    int enemyDamage = random.nextInt(15) + 5;
    if (defending) {
      enemyDamage ~/= 2;
      print('Enemy attacks! Blocked some damage: -$enemyDamage HP');
    } else {
      print('Enemy attacks! You take $enemyDamage damage!');
    }
    playerHealth -= enemyDamage;

    // Check player death
    if (playerHealth <= 0) {
      print('\nYOU DIED! Survived $rounds rounds.');
      gameOver = true;
    }

    print('');
  }

  print('=== GAME OVER ===');
}
```

</details>

---

## Self-Assessment

After completing these exercises, you should be able to:

- [ ] Use if/else if/else for multiple conditions
- [ ] Choose between if-else and switch appropriately
- [ ] Write for loops with custom start, end, and step
- [ ] Use while loops when count is unknown
- [ ] Use do-while when you need at least one iteration
- [ ] Apply break to exit loops early
- [ ] Apply continue to skip iterations
- [ ] Handle nested loops with labels
- [ ] Combine multiple control structures

---

**Congratulations!** You've completed Level 2!

---

**Next Level:** `../../Level-03-Functions-Collections/README.md`
