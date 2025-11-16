# Week 3, Day 5-7: Loops - Mastering Repetition

## Why Loops Matter

Imagine you need to print numbers 1 through 100. Without loops:

```dart
print(1);
print(2);
print(3);
// ... 97 more lines!
print(100);
```

That's insane! With a loop:

```dart
for (int i = 1; i <= 100; i++) {
  print(i);
}
```

**3 lines instead of 100.** That's the power of loops.

**Real-world uses:**
- Process items in a list (every product in a cart)
- Repeat actions (send email to all users)
- Iterate through data (display all posts)
- Games (game loop runs 60 times per second)
- Calculations (sum all numbers, find average)

---

## Types of Loops in Dart

| Loop Type | When to Use | Example |
|-----------|-------------|---------|
| **for** | Know how many times to repeat | Print 1 to 10 |
| **for-in** | Iterate through a collection | Each item in a list |
| **while** | Repeat while condition is true | Keep asking until valid input |
| **do-while** | Run at least once, then check | Menu systems |

---

## The for Loop

### Basic Syntax

```dart
for (initialization; condition; increment) {
  // Code to repeat
}
```

**Breaking it down:**
1. **initialization** - Runs once at start (e.g., `int i = 0`)
2. **condition** - Checked before each iteration (e.g., `i < 10`)
3. **increment** - Runs after each iteration (e.g., `i++`)
4. **Body** - Code that repeats

### Example 1: Count from 1 to 5

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    print(i);
  }
}
```

**Output:**
```
1
2
3
4
5
```

**What happens:**
1. `int i = 1` - Start with i = 1
2. Check `i <= 5`? (1 <= 5) → true → run body
3. Print 1
4. `i++` → i becomes 2
5. Check `i <= 5`? (2 <= 5) → true → run body
6. Print 2
7. ...continue until i = 6
8. Check `i <= 5`? (6 <= 5) → false → stop

### Example 2: Count Backwards

```dart
void main() {
  for (int i = 5; i >= 1; i--) {
    print(i);
  }
  print('Liftoff!');
}
```

**Output:**
```
5
4
3
2
1
Liftoff!
```

### Example 3: Count by 2s

```dart
void main() {
  for (int i = 0; i <= 10; i += 2) {
    print(i);
  }
}
```

**Output:**
```
0
2
4
6
8
10
```

### Example 4: Multiplication Table

```dart
void main() {
  int number = 7;

  for (int i = 1; i <= 10; i++) {
    print('$number x $i = ${number * i}');
  }
}
```

**Output:**
```
7 x 1 = 7
7 x 2 = 14
7 x 3 = 21
...
7 x 10 = 70
```

### Example 5: Sum of Numbers

```dart
void main() {
  int sum = 0;

  for (int i = 1; i <= 5; i++) {
    sum += i;  // sum = sum + i
    print('Added $i, sum is now $sum');
  }

  print('Final sum: $sum');
}
```

**Output:**
```
Added 1, sum is now 1
Added 2, sum is now 3
Added 3, sum is now 6
Added 4, sum is now 10
Added 5, sum is now 15
Final sum: 15
```

---

## The for-in Loop

### Purpose
Iterate through a collection (List, Set, etc.) without tracking index.

### Syntax

```dart
for (var item in collection) {
  // Use item
}
```

### Example 1: Iterate Through List

```dart
void main() {
  List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Date'];

  for (var fruit in fruits) {
    print(fruit);
  }
}
```

**Output:**
```
Apple
Banana
Cherry
Date
```

### Example 2: Sum List Values

```dart
void main() {
  List<int> numbers = [10, 20, 30, 40, 50];
  int total = 0;

  for (var number in numbers) {
    total += number;
  }

  print('Total: $total');  // Total: 150
}
```

### Example 3: Find Maximum

```dart
void main() {
  List<int> scores = [85, 92, 78, 95, 88];
  int max = scores[0];  // Start with first value

  for (var score in scores) {
    if (score > max) {
      max = score;
    }
  }

  print('Highest score: $max');  // 95
}
```

### When to Use for vs for-in

**Use regular for when:**
- You need the index
- You're counting/iterating by number
- You need precise control

```dart
for (int i = 0; i < 10; i++) {
  print('Index: $i');
}
```

**Use for-in when:**
- You just need each item
- You don't care about the index
- Cleaner, more readable

```dart
for (var item in items) {
  print(item);
}
```

---

## The while Loop

### Purpose
Repeat while a condition is true. **You don't know how many times in advance.**

### Syntax

```dart
while (condition) {
  // Code to repeat
  // Must eventually make condition false!
}
```

### Example 1: Countdown

```dart
void main() {
  int count = 5;

  while (count > 0) {
    print(count);
    count--;  // IMPORTANT! Without this, infinite loop!
  }

  print('Done!');
}
```

**Output:**
```
5
4
3
2
1
Done!
```

### Example 2: Keep Asking Until Valid

```dart
void main() {
  int guess = 0;
  int secret = 7;

  while (guess != secret) {
    // In real app, you'd get user input
    // For this example, we'll simulate:
    guess = 5;  // User's first guess
    print('Guess: $guess');

    if (guess != secret) {
      print('Wrong! Try again.');
      guess = 7;  // User's second guess (correct)
    }
  }

  print('Correct!');
}
```

### Example 3: Sum Until Limit

```dart
void main() {
  int sum = 0;
  int num = 1;

  // Add numbers until sum >= 100
  while (sum < 100) {
    sum += num;
    print('Added $num, sum: $sum');
    num++;
  }

  print('Final sum: $sum');
}
```

### ⚠️ Infinite Loop Warning

```dart
// BAD! This will never stop!
int count = 5;
while (count > 0) {
  print(count);
  // Forgot to decrease count!
}
```

**Always ensure the condition will eventually become false!**

---

## The do-while Loop

### Purpose
Run code **at least once**, then check condition.

### Syntax

```dart
do {
  // Code runs first
} while (condition);
```

**Key difference:** Code runs BEFORE checking condition.

### Example 1: Menu System

```dart
void main() {
  int choice;

  do {
    print('=== MENU ===');
    print('1. Play');
    print('2. Settings');
    print('3. Quit');
    print('Enter choice: ');

    // Simulate user input
    choice = 3;  // User chooses quit

  } while (choice != 3);

  print('Goodbye!');
}
```

**Menu displays at least once**, even if user immediately quits.

### Example 2: Validate Input

```dart
void main() {
  int age;

  do {
    // Simulate getting user input
    age = -5;  // Invalid
    print('Enter age: $age');

    if (age < 0) {
      print('Age must be positive!');
      age = 25;  // User corrects it
    }

  } while (age < 0);

  print('Age accepted: $age');
}
```

### while vs do-while

**while** - Check first, might never run:
```dart
int x = 10;
while (x < 5) {  // False immediately
  print('Never prints');
}
```

**do-while** - Run first, then check:
```dart
int x = 10;
do {
  print('Prints once');  // Runs once
} while (x < 5);  // Then checks (false)
```

---

## break - Exit Loop Early

### Purpose
Stop the loop immediately, no matter what.

### Example 1: Find First Match

```dart
void main() {
  List<String> names = ['Alice', 'Bob', 'Charlie', 'David'];
  String target = 'Charlie';

  for (var name in names) {
    print('Checking: $name');

    if (name == target) {
      print('Found $target!');
      break;  // Stop searching!
    }
  }

  print('Search complete');
}
```

**Output:**
```
Checking: Alice
Checking: Bob
Checking: Charlie
Found Charlie!
Search complete
```

**Without break**, it would keep checking David unnecessarily.

### Example 2: Limit Attempts

```dart
void main() {
  int attempts = 0;
  int maxAttempts = 3;
  String password = 'secret123';

  while (true) {  // Infinite loop (on purpose)
    attempts++;
    print('Attempt $attempts');

    // Simulate user input
    String input = 'wrong';

    if (input == password) {
      print('Login successful!');
      break;  // Exit on success
    }

    if (attempts >= maxAttempts) {
      print('Too many attempts!');
      break;  // Exit on max attempts
    }
  }
}
```

---

## continue - Skip to Next Iteration

### Purpose
Skip the rest of current iteration, go to next one.

### Example 1: Skip Even Numbers

```dart
void main() {
  for (int i = 1; i <= 10; i++) {
    if (i % 2 == 0) {
      continue;  // Skip even numbers
    }

    print(i);  // Only prints odd numbers
  }
}
```

**Output:**
```
1
3
5
7
9
```

### Example 2: Skip Invalid Values

```dart
void main() {
  List<int> numbers = [10, -5, 20, -3, 30, 0, 40];

  for (var num in numbers) {
    if (num <= 0) {
      continue;  // Skip non-positive numbers
    }

    print('Processing: $num');
  }
}
```

**Output:**
```
Processing: 10
Processing: 20
Processing: 30
Processing: 40
```

### break vs continue

**break** - Exit loop completely:
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) break;
  print(i);  // Prints: 1, 2
}
print('Done');
```

**continue** - Skip to next iteration:
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) continue;
  print(i);  // Prints: 1, 2, 4, 5
}
print('Done');
```

---

## Nested Loops

### Purpose
Loop inside another loop.

### Example 1: Multiplication Table (Full)

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    for (int j = 1; j <= 5; j++) {
      print('$i x $j = ${i * j}');
    }
    print('---');  // Separator
  }
}
```

**Output:**
```
1 x 1 = 1
1 x 2 = 2
1 x 3 = 3
1 x 4 = 4
1 x 5 = 5
---
2 x 1 = 2
2 x 2 = 4
...
```

### Example 2: Grid Pattern

```dart
void main() {
  for (int row = 1; row <= 3; row++) {
    String line = '';
    for (int col = 1; col <= 4; col++) {
      line += '* ';
    }
    print(line);
  }
}
```

**Output:**
```
* * * *
* * * *
* * * *
```

### Example 3: Number Pyramid

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    String line = '';
    for (int j = 1; j <= i; j++) {
      line += '$j ';
    }
    print(line);
  }
}
```

**Output:**
```
1
1 2
1 2 3
1 2 3 4
1 2 3 4 5
```

---

## Common Loop Patterns

### Pattern 1: Sum All Numbers

```dart
int sum(List<int> numbers) {
  int total = 0;
  for (var num in numbers) {
    total += num;
  }
  return total;
}
```

### Pattern 2: Find Average

```dart
double average(List<int> numbers) {
  if (numbers.isEmpty) return 0;

  int total = 0;
  for (var num in numbers) {
    total += num;
  }
  return total / numbers.length;
}
```

### Pattern 3: Count Occurrences

```dart
int count(List<String> items, String target) {
  int count = 0;
  for (var item in items) {
    if (item == target) {
      count++;
    }
  }
  return count;
}
```

### Pattern 4: Filter Items

```dart
List<int> getEvens(List<int> numbers) {
  List<int> evens = [];
  for (var num in numbers) {
    if (num % 2 == 0) {
      evens.add(num);
    }
  }
  return evens;
}
```

### Pattern 5: Find First Match

```dart
String? findFirst(List<String> items, String target) {
  for (var item in items) {
    if (item.contains(target)) {
      return item;  // Found it!
    }
  }
  return null;  // Not found
}
```

---

## Exercises

### Exercise 1: Print Even Numbers
Print all even numbers from 2 to 20.

<details>
<summary>Solution</summary>

```dart
void main() {
  for (int i = 2; i <= 20; i += 2) {
    print(i);
  }
}
```
</details>

---

### Exercise 2: Factorial
Calculate factorial of 5 (5! = 5 × 4 × 3 × 2 × 1 = 120)

<details>
<summary>Solution</summary>

```dart
void main() {
  int n = 5;
  int factorial = 1;

  for (int i = 1; i <= n; i++) {
    factorial *= i;
  }

  print('$n! = $factorial');
}
```
</details>

---

### Exercise 3: Reverse a List
Print list items in reverse order without using .reversed

<details>
<summary>Solution</summary>

```dart
void main() {
  List<String> fruits = ['Apple', 'Banana', 'Cherry'];

  for (int i = fruits.length - 1; i >= 0; i--) {
    print(fruits[i]);
  }
}
```
</details>

---

### Exercise 4: FizzBuzz
Classic problem:
- Print numbers 1-30
- If divisible by 3: print "Fizz"
- If divisible by 5: print "Buzz"
- If divisible by both: print "FizzBuzz"
- Otherwise: print the number

<details>
<summary>Solution</summary>

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

### Exercise 5: Star Pattern
Print this pattern:
```
*
**
***
****
*****
```

<details>
<summary>Solution</summary>

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    String line = '';
    for (int j = 1; j <= i; j++) {
      line += '*';
    }
    print(line);
  }
}
```
</details>

---

## Key Takeaways

1. **for loop** - When you know how many iterations
2. **for-in loop** - To iterate through collections
3. **while loop** - When you check condition first
4. **do-while loop** - When you run code first, then check
5. **break** - Exit loop immediately
6. **continue** - Skip to next iteration
7. **Nested loops** - Loop inside a loop
8. **Always ensure loops end** - Avoid infinite loops!

---

## What's Next?

Tomorrow:
- **Functions** - Organize code into reusable blocks
- **Parameters** - Pass data to functions
- **Return values** - Get results back

You now have the power of repetition! This is where programming becomes truly powerful. 🔄💪
