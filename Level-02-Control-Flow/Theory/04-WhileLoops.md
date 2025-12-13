# While Loops: Loop Until Done

## What Is a While Loop?

A **while loop** keeps running as long as a condition is true.

```dart
while (condition) {
  // code runs while condition is true
}
```

Think of it like:
- **WHILE** you're hungry, keep eating
- **WHILE** there's work to do, keep working
- **WHILE** the game isn't over, keep playing

---

## Basic While Loop

```dart
int count = 0;

while (count < 5) {
  print('Count: $count');
  count++;
}
```

**Output:**
```
Count: 0
Count: 1
Count: 2
Count: 3
Count: 4
```

**How it works:**
1. Check: Is `count < 5`? → `0 < 5` → YES
2. Print "Count: 0"
3. `count++` → count is now 1
4. Check: Is `count < 5`? → `1 < 5` → YES
5. Print "Count: 1"
6. ... continues...
7. Eventually count becomes 5
8. Check: Is `count < 5`? → `5 < 5` → NO
9. Exit loop

---

## Visual Flow

```
Start
  │
  ▼
┌────────────┐
│ count < 5? │ ←──────────┐
└─────┬──────┘            │
      │                   │
 ┌────┴────┐              │
YES        NO             │
 │          │             │
 ▼          │             │
┌──────┐    │             │
│print │    │             │
└──┬───┘    │             │
   │        │             │
   ▼        │             │
┌────────┐  │             │
│count++ │──┴─────────────┘
└────────┘
           │
           ▼
       Continue...
```

---

## While vs For

### Use FOR when:
- You know how many times to loop
- `for (int i = 0; i < 10; i++)`

### Use WHILE when:
- You don't know when to stop
- Loop until a condition changes

```dart
// FOR: Loop exactly 5 times
for (int i = 0; i < 5; i++) {
  print(i);
}

// WHILE: Loop until user says stop
String input = '';
while (input != 'quit') {
  print('Type quit to exit');
  // input = readLine();  // Get user input
}
```

---

## Do-While Loop

A **do-while** loop runs AT LEAST ONCE, then checks the condition.

```dart
int count = 10;

do {
  print('Count: $count');
  count++;
} while (count < 5);

// Prints: Count: 10
// Even though 10 is NOT < 5!
```

**Difference:**
- `while`: Checks FIRST, then runs
- `do-while`: Runs FIRST, then checks

### When to Use Do-While

When you need the code to run at least once:

```dart
// Menu that shows at least once
do {
  print('1. Play');
  print('2. Settings');
  print('3. Quit');
  // choice = getInput();
} while (choice != 3);
```

---

## Infinite Loops (Be Careful!)

A loop that never ends:

```dart
// ❌ INFINITE LOOP - count never changes!
int count = 0;
while (count < 5) {
  print(count);
  // Forgot: count++;
}

// ❌ INFINITE LOOP - condition always true!
while (true) {
  print('Forever...');
}
```

**Always make sure your condition will eventually become false!**

---

## Intentional Infinite Loops

Sometimes you WANT an infinite loop (with a way out):

```dart
while (true) {
  print('Running...');

  if (shouldStop) {
    break;  // Exit the loop
  }
}
```

This is common in games and servers that run continuously.

---

## Practical Examples

### Example 1: Count Digits

```dart
void main() {
  int number = 12345;
  int digits = 0;

  while (number > 0) {
    number = number ~/ 10;  // Remove last digit
    digits++;
  }

  print('Number of digits: $digits');  // 5
}
```

### Example 2: Sum Until Zero

```dart
void main() {
  List<int> numbers = [5, 10, 15, 0, 20, 25];
  int sum = 0;
  int i = 0;

  while (i < numbers.length && numbers[i] != 0) {
    sum += numbers[i];
    i++;
  }

  print('Sum until 0: $sum');  // 30
}
```

### Example 3: Password Attempts

```dart
void main() {
  String correctPassword = 'secret';
  int attempts = 0;
  int maxAttempts = 3;
  bool success = false;

  while (attempts < maxAttempts && !success) {
    String input = 'wrong';  // Simulate input
    attempts++;

    if (input == correctPassword) {
      success = true;
      print('Access granted!');
    } else {
      print('Wrong password. ${maxAttempts - attempts} attempts left.');
    }
  }

  if (!success) {
    print('Account locked!');
  }
}
```

### Example 4: Find First Vowel

```dart
void main() {
  String word = 'rhythm';
  int i = 0;
  bool found = false;

  while (i < word.length && !found) {
    String char = word[i].toLowerCase();
    if ('aeiou'.contains(char)) {
      print('First vowel: $char at position $i');
      found = true;
    }
    i++;
  }

  if (!found) {
    print('No vowel found');
  }
}
```

### Example 5: Fibonacci

```dart
void main() {
  int limit = 100;
  int a = 0;
  int b = 1;

  print('Fibonacci numbers up to $limit:');

  while (a <= limit) {
    print(a);
    int temp = a;
    a = b;
    b = temp + b;
  }
}
```

---

## Common Patterns

### Pattern 1: Process Until Empty

```dart
List<int> items = [1, 2, 3, 4, 5];

while (items.isNotEmpty) {
  int item = items.removeLast();
  print('Processing: $item');
}
```

### Pattern 2: Wait for Condition

```dart
bool dataReady = false;
int waitTime = 0;

while (!dataReady && waitTime < 10) {
  print('Waiting...');
  waitTime++;
  // dataReady = checkData();
}
```

### Pattern 3: Converge to Answer

```dart
double guess = 10.0;
double target = 25.0;

while ((guess * guess - target).abs() > 0.001) {
  guess = (guess + target / guess) / 2;
}

print('Square root of $target ≈ $guess');
```

---

## Summary

### While Loop

```dart
while (condition) {
  // runs while condition is true
}
```

### Do-While Loop

```dart
do {
  // runs at least once
} while (condition);
```

### Key Points

1. While checks condition FIRST
2. Do-while runs FIRST, then checks
3. Always update something to avoid infinite loops
4. Use while when you don't know how many iterations
5. Use for when you know exactly how many times

---

## Quick Quiz

**Q1:** What's the difference between while and do-while?

<details>
<summary>Answer</summary>
`while` checks the condition before running (might run 0 times). `do-while` runs first, then checks (always runs at least once).
</details>

**Q2:** What's wrong with this code?
```dart
int x = 0;
while (x < 10) {
  print(x);
}
```

<details>
<summary>Answer</summary>
Infinite loop! `x` never changes, so `x < 10` is always true. Need `x++;` inside the loop.
</details>

**Q3:** How many times does this print?
```dart
int i = 5;
do {
  print(i);
} while (i < 5);
```

<details>
<summary>Answer</summary>
Once. Do-while always runs at least once, then checks the condition (which is false).
</details>

---

**Next:** Learn to control loops with break and continue.

---

**Continue to:** `05-LoopControl.md`
