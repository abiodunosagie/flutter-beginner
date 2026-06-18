# While Loops: Repeating Until Done

## Why This Topic Exists

You already know `for` loops. They are perfect when you know **how many times** to run, like "print 1 to 10".

But what if you do not know how many times in advance?

- "Keep asking the user for a password until they get it right." (1 try? 5 tries? You do not know.)
- "Keep downloading data until the server says we are done."
- "Keep playing the game until the player loses."

For these, you need a different kind of loop. That is what `while` is for.

---

## The Mental Model

Compare the two loops in plain English:

| Loop | What it says |
|------|--------------|
| `for` | "Run this **N times**." |
| `while` | "Run this **as long as something is true**." |

A `while` loop keeps going until the condition becomes false. It is the loop you reach for when you cannot count the rounds in advance.

---

## The Syntax

```dart
while (condition) {
  // runs while the condition is true
}
```

That is it. Two parts: a condition and a body. No init. No update. You handle those yourself inside the body.

---

## A First Example

```dart
int count = 0;

while (count < 5) {
  print('count is $count');
  count++;
}
```

Output:
```
count is 0
count is 1
count is 2
count is 3
count is 4
```

Walk through it round by round:

| Round | `count` before | Check `count < 5` | Body runs | `count` after |
|-------|----------------|-------------------|-----------|---------------|
| 1 | 0 | true | print, then count++ | 1 |
| 2 | 1 | true | print, then count++ | 2 |
| 3 | 2 | true | print, then count++ | 3 |
| 4 | 3 | true | print, then count++ | 4 |
| 5 | 4 | true | print, then count++ | 5 |
| Stop | 5 | false | --- | --- |

If you know the for loop, this should look familiar. The big difference: in a for loop, the init and update are written **outside** the body. In a while loop, you write them **inside**.

---

## The Most Common Bug: Infinite Loops

If the condition never becomes false, the loop never ends. Your program freezes.

```dart
int count = 0;

while (count < 5) {
  print(count);
  // forgot count++
}
```

This prints `0` over and over forever. You will need to stop it manually with Ctrl+C.

The fix: always make sure something inside the loop changes the condition.

```dart
while (count < 5) {
  print(count);
  count++;        // this is what makes the loop end
}
```

Rule of thumb: when you write a while loop, immediately ask yourself, **"What will eventually make this condition false?"** If you cannot answer, you have a bug.

---

## Intentional Infinite Loops

Sometimes you actually **want** a loop that runs forever, with `break` as the way out. This is common in game loops and servers.

```dart
while (true) {
  print('Game running');

  if (playerLost) {
    break;     // exit the loop
  }
}
```

`while (true)` is read as "loop forever". The `break` keyword (covered in the next lesson) lets you escape.

This is fine **as long as you have a clear `break` condition inside**. Without one, you have an infinite loop bug all over again.

---

## `do-while`: Run At Least Once

There is a small variation called `do-while`. It looks like this:

```dart
int count = 10;

do {
  print('count is $count');
  count++;
} while (count < 5);
```

Output:
```
count is 10
```

Wait, what? `count` started at 10, which is **not** less than 5. So why did it print?

Because `do-while` runs the body **first**, then checks the condition. The check happens at the end of each round, not the beginning.

The difference in one sentence:

| Loop | Order |
|------|-------|
| `while` | check, then maybe run |
| `do-while` | run, then check |

A `do-while` loop **always runs at least once**, even if the condition is false from the start.

### When to use `do-while`

When the action must happen at least one time before you can decide whether to repeat. The classic example is a menu:

```dart
String choice;

do {
  print('1. Play');
  print('2. Settings');
  print('3. Quit');
  choice = readChoice();    // pretend this gets user input
} while (choice != '3');
```

You must show the menu first, then check what they picked. A regular `while` would check the choice before showing the menu, which is the wrong order.

---

## When To Use `for` vs `while` vs `do-while`

| Situation | Use |
|-----------|-----|
| You know the count, like "1 to 10" | `for` |
| You loop over a list | `for-in` |
| You loop until a condition flips, count unknown | `while` |
| You must run at least once before checking | `do-while` |

If you are not sure, default to `for`. If you find yourself fighting it, switch to `while`. If the body must always run once before the first check, use `do-while`.

---

## Worked Examples

### 1. Count digits in a number

How many digits are in 12345? You do not know in advance, so use a while loop.

```dart
void main() {
  int number = 12345;
  int digits = 0;

  while (number > 0) {
    number = number ~/ 10;    // chop off the last digit
    digits++;
  }

  print('Digits: $digits');   // 5
}
```

`~/` is integer division (covered in Level 1). It gives the whole-number part with the remainder thrown away.

### 2. Password retry

```dart
void main() {
  String correct = 'open123';
  int attempts = 0;
  int maxAttempts = 3;
  bool success = false;

  while (attempts < maxAttempts && !success) {
    String input = readPassword();   // pretend this asks the user
    attempts++;

    if (input == correct) {
      success = true;
      print('Granted');
    } else {
      print('Wrong. ${maxAttempts - attempts} left');
    }
  }

  if (!success) print('Locked out');
}
```

Two stop conditions, joined by `&&`: stop when either attempts run out **or** the password matches.

### 3. Find first vowel

```dart
void main() {
  String word = 'rhythm';
  int i = 0;
  bool found = false;

  while (i < word.length && !found) {
    String c = word[i].toLowerCase();
    if ('aeiou'.contains(c)) {
      print('First vowel: $c at position $i');
      found = true;
    }
    i++;
  }

  if (!found) print('No vowel found');
}
```

Notice how the condition checks both that we are still inside the word **and** that we have not found a vowel yet. As soon as either is false, the loop stops.

### 4. Process queue until empty

```dart
List<int> queue = [1, 2, 3, 4, 5];

while (queue.isNotEmpty) {
  int item = queue.removeLast();
  print('Processing $item');
}
```

Loop until the list is empty. Lists come in Level 3, but the pattern is worth seeing now.

---

## Why This Matters In Flutter

While loops in Flutter UI code are rare, but you will use them in two key places:

1. **Polling.** "Keep checking the server every 5 seconds until the upload finishes."
2. **Game loops.** Every Flutter game has a loop running until the player exits.

Most everyday Flutter code uses `for` and `for-in`, but `while` shows up in async code (Level 8 onwards).

---

## Common Mistakes

1. **Infinite loop.** Forgetting to update the variable used in the condition. Always trace the loop on paper before running it.
2. **Off-by-one again.** `while (count <= 5)` runs one more time than `while (count < 5)`. Same trap as for loops.
3. **Updating in the wrong direction.** `count--` when the condition expects `count` to grow. Loop never stops.
4. **Using `do-while` when you really want `while`.** If the very first check might fail, do not use `do-while`. It will run the body anyway.

---

## Recap In One Minute

- `while` keeps running as long as the condition is true.
- The condition is checked **before** each round.
- `do-while` runs the body first, then checks. Always runs at least once.
- Use `while` when you do not know how many rounds in advance.
- Always make sure something inside the body changes the condition.
- `while (true)` is fine if you have a `break` as your exit.

---

## Quick Quiz

**Q1.** What is the output?
```dart
int x = 0;
while (x < 3) {
  print(x);
  x++;
}
```

<details>
<summary>Answer</summary>
0, 1, 2 (each on its own line). The loop stops when x becomes 3.
</details>

**Q2.** What is the bug?
```dart
int x = 0;
while (x < 10) {
  print(x);
}
```

<details>
<summary>Answer</summary>
There is no `x++`. `x` stays at 0 forever, the condition stays true forever. Infinite loop.
</details>

**Q3.** How many times does this print?
```dart
int i = 5;
do {
  print('hi');
} while (i < 5);
```

<details>
<summary>Answer</summary>
Once. `do-while` runs the body first, then checks. The check fails, so the loop ends after one round.
</details>

**Q4.** Convert this for loop into a while loop:
```dart
for (int i = 1; i <= 5; i++) {
  print(i);
}
```

<details>
<summary>Answer</summary>

```dart
int i = 1;
while (i <= 5) {
  print(i);
  i++;
}
```
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before reading the answer. Everything uses `while` loops in `main`. (Functions and Lists come in Level 3, so we do not need them yet.)

### Problem 1: Predict the output

What does this print?

```dart
void main() {
  int n = 16;
  int steps = 0;

  while (n > 1) {
    n = n ~/ 2;
    steps++;
    print('After step $steps, n is $n');
  }

  print('Total steps: $steps');
}
```

### Problem 2: Convert a for loop to a while loop

Rewrite this for loop using a `while` loop in `main`. The output must be identical. Then say, in one sentence, which form you find clearer here and why.

```dart
for (int i = 10; i >= 0; i -= 2) {
  print(i);
}
```

### Problem 3: Count the digits

In `main`, make `int n = 12345`. Use a `while` loop to count how many digits it has, then print `12345 has 5 digits`. (Hint: `n ~/ 10` chops off the last digit. Keep going until `n` reaches 0.) Keep the original number in a second box so you can print it.

### Problem 4: First power of 2 above a target

In `main`, make `int target = 10`. Use a `while` loop to find the first power of 2 that is bigger than `target`, then print it. (Start at `power = 1` and keep doubling while `power <= target`.) For 10, the answer is 16.

### Problem 5: Months to a savings goal

In `main`, you start with `int balance = 1000` and add 150 every month. Use a `while` loop to find how many months it takes for the balance to reach at least 5000. Print the number of months and the final balance.

---

## Assignment Answers

### Problem 1: Predict the output

```
After step 1, n is 8
After step 2, n is 4
After step 3, n is 2
After step 4, n is 1
Total steps: 4
```

| Round | n before | `n > 1`? | n after `~/2` | steps |
|-------|----------|----------|---------------|-------|
| 1 | 16 | true | 8 | 1 |
| 2 | 8 | true | 4 | 2 |
| 3 | 4 | true | 2 | 3 |
| 4 | 2 | true | 1 | 4 |
| Stop | 1 | false | --- | 4 |

`~/` is integer divide (from Level 1). Once `n` is 1, `1 > 1` is false and the loop stops. This counts how many times you can halve 16 before reaching 1, which is 4.

### Problem 2: Convert a for loop to a while loop

```dart
void main() {
  int i = 10;
  while (i >= 0) {
    print(i);
    i -= 2;
  }
}
```

How the conversion was done:

1. The start `int i = 10` moves **above** the loop.
2. The condition `i >= 0` becomes the `while` condition.
3. The step `i -= 2` moves **inside** the body, at the bottom.

Both print 10, 8, 6, 4, 2, 0. The **for** form is clearer here, because the start, stop, and step all sit together on one line. Use `for` when you know the count; use `while` when you do not.

### Problem 3: Count the digits

```dart
void main() {
  int n = 12345;
  int original = n;
  int count = 0;

  while (n > 0) {
    n = n ~/ 10;
    count++;
  }

  print('$original has $count digits');   // 12345 has 5 digits
}
```

Each round chops off the last digit with `n ~/ 10` (12345 to 1234 to 123 to 12 to 1 to 0) and counts the chop. After 5 chops, `n` is 0 and the loop stops. We saved `original` first because the loop destroys `n`.

### Problem 4: First power of 2 above a target

```dart
void main() {
  int target = 10;
  int power = 1;

  while (power <= target) {
    power *= 2;
  }

  print('First power of 2 above $target is $power');   // 16
}
```

| Round | power before | `power <= 10`? | power after `*= 2` |
|-------|--------------|----------------|--------------------|
| 1 | 1 | true | 2 |
| 2 | 2 | true | 4 |
| 3 | 4 | true | 8 |
| 4 | 8 | true | 16 |
| Stop | 16 | false | --- |

We keep doubling while `power` is still at or below the target. The moment it goes past, the loop stops and `power` is the answer (16). We cannot know in advance how many doublings we need, which is exactly why a `while` loop fits.

### Problem 5: Months to a savings goal

```dart
void main() {
  int balance = 1000;
  int months = 0;

  while (balance < 5000) {
    balance += 150;
    months++;
  }

  print('Months needed: $months');     // 27
  print('Final balance: $balance');    // 5050
}
```

Each round is one month: add 150 and count the month. The loop keeps going while the balance is still under 5000. Starting at 1000, after 26 months the balance is 4900 (still under), and after 27 months it is 5050 (reached the goal), so the loop stops at 27 months. This is a real-world "loop until a goal is met" where you do not know the count beforehand.

---

**Next:** `05-LoopControl.md` for the two keywords that change how loops behave: `break` and `continue`.
