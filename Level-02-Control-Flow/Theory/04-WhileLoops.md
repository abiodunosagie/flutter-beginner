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

Take this for loop and rewrite it using a `while` loop. The output must be identical.

```dart
for (int i = 10; i >= 0; i -= 2) {
  print(i);
}
```

Then, in your own words, explain which form (for or while) is more readable here, and why.

### Problem 3: Count digits

Write a function `int digitCount(int n)` that returns the number of digits in a positive integer. Use a while loop. Test on 7 (1 digit), 100 (3 digits), and 12345 (5 digits). What should it return for 0? Make a decision and justify it in your answer.

### Problem 4: Find first power of 2 above a target

Write a function `int firstPowerAbove(int target)` that returns the first power of 2 that is strictly greater than `target`. For example:
- `firstPowerAbove(10)` returns 16 (because 8 is not greater than 10, but 16 is).
- `firstPowerAbove(50)` returns 64.
- `firstPowerAbove(1)` returns 2.

Use a while loop. Do not hard-code any values.

### Problem 5: Simulate a password retry

Write a function `bool tryLogin(String correct, List<String> attempts, int maxTries)` that walks through the `attempts` list one at a time. It should:

- Return `true` if any attempt matches `correct`, but only if it happens within `maxTries` tries.
- Return `false` if `maxTries` is reached without a match.
- Return `false` if the list ends before `maxTries` (out of attempts).

Test with `tryLogin('open', ['x', 'y', 'open', 'z'], 3)` (expected: true) and `tryLogin('open', ['x', 'y', 'z'], 3)` (expected: false).

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

Walkthrough:

| Round | n before | Check `n > 1` | n after `~/2` | steps |
|-------|----------|---------------|---------------|-------|
| 1 | 16 | true | 8 | 1 |
| 2 | 8 | true | 4 | 2 |
| 3 | 4 | true | 2 | 3 |
| 4 | 2 | true | 1 | 4 |
| Stop | 1 | false (1 is not > 1) | --- | 4 |

`~/` is integer division (covered in Level 1). `16 ~/ 2 = 8`, `8 ~/ 2 = 4`, and so on. Once we hit 1, the condition `1 > 1` is false, the loop stops.

What this loop actually computes: how many times you can halve a number before it drops to 1 or below. For powers of 2, this equals the exponent. 16 is 2 to the 4, so it takes 4 halvings.

### Problem 2: Convert a for loop to a while loop

```dart
int i = 10;
while (i >= 0) {
  print(i);
  i -= 2;
}
```

How the conversion was done:

1. The init `int i = 10` moves **outside** the while loop.
2. The condition `i >= 0` becomes the while condition.
3. The update `i -= 2` moves **inside** the loop body, at the bottom.

Output of both versions: 10, 8, 6, 4, 2, 0.

**Which is more readable?** The `for` form is better here. When you know:
- Where you start (10),
- When you stop (>= 0),
- How you step (subtract 2),

a for loop puts all three in one line at the top. The while form scatters them across three different places. Pick whatever makes the intent obvious. For "count from A to B by C", that is almost always for.

### Problem 3: Count digits

```dart
int digitCount(int n) {
  if (n == 0) return 1;     // see explanation below

  int count = 0;
  while (n > 0) {
    n = n ~/ 10;
    count++;
  }
  return count;
}
```

How the loop works:

Each round, we throw away the last digit using `n ~/ 10`. We count how many times we can do this before `n` reaches 0.

Trace for `n = 12345`:

| Round | n before | n ~/ 10 | count |
|-------|----------|---------|-------|
| 1 | 12345 | 1234 | 1 |
| 2 | 1234 | 123 | 2 |
| 3 | 123 | 12 | 3 |
| 4 | 12 | 1 | 4 |
| 5 | 1 | 0 | 5 |
| Stop | 0 | --- | 5 |

Returns 5.

**Why we special-case 0:**

If we feed in `n = 0`, the while loop's condition `n > 0` is false at the very start. The loop never runs, count stays at 0, and we would return 0. But the number 0 visually has one digit. Returning 0 is wrong by human convention.

So we add a guard at the top: if `n == 0`, return 1. This is a judgement call. The rule is: if the natural behaviour of your loop produces a wrong answer for an edge case, handle the edge case before the loop runs.

### Problem 4: Find first power of 2 above a target

```dart
int firstPowerAbove(int target) {
  int power = 1;
  while (power <= target) {
    power *= 2;
  }
  return power;
}
```

How the logic was built:

1. Start with `power = 1`. This is 2 to the 0.
2. As long as `power` is **less than or equal to** `target`, double it. (`power <= target` rather than `<` because we want strictly greater than target at the end.)
3. The first time `power` becomes greater than `target`, the condition fails and we exit. We return that `power`.

Trace for `target = 10`:

| Round | power before | power <= 10? | power after `*= 2` |
|-------|--------------|--------------|--------------------|
| 1 | 1 | true | 2 |
| 2 | 2 | true | 4 |
| 3 | 4 | true | 8 |
| 4 | 8 | true | 16 |
| Stop | 16 | false | --- |

Returns 16. Correct.

This is a classic use of a while loop: we cannot pre-compute how many doublings we need, so we let the condition control when to stop.

### Problem 5: Simulate a password retry

```dart
bool tryLogin(String correct, List<String> attempts, int maxTries) {
  int tries = 0;

  while (tries < maxTries && tries < attempts.length) {
    if (attempts[tries] == correct) {
      return true;
    }
    tries++;
  }

  return false;
}
```

How this was built:

1. **Two stop conditions, joined by `&&`.** We stop if we run out of tries `tries < maxTries` becomes false, **or** if we run out of attempts `tries < attempts.length` becomes false. Both must remain true to keep going.
2. **Check the current attempt.** If it matches `correct`, return `true` immediately. No reason to keep checking.
3. **Move forward.** If no match, increment `tries` and continue.
4. **If we exit the loop without returning,** we never matched. Return `false`.

Trace for `tryLogin('open', ['x', 'y', 'open', 'z'], 3)`:

| Round | tries | attempt | match? |
|-------|-------|---------|--------|
| 1 | 0 | 'x' | no, tries++ |
| 2 | 1 | 'y' | no, tries++ |
| 3 | 2 | 'open' | yes, return true |

Returns true. Correct.

Trace for `tryLogin('open', ['x', 'y', 'z'], 3)`:

| Round | tries | attempt | match? |
|-------|-------|---------|--------|
| 1 | 0 | 'x' | no, tries++ |
| 2 | 1 | 'y' | no, tries++ |
| 3 | 2 | 'z' | no, tries++ |
| Stop | 3 | --- | tries < 3 is false |

Loop exits without a match. Return false. Correct.

The `&&` in the loop condition saves us from a crash. Without `tries < attempts.length`, we would try to read `attempts[3]` on a list of length 3, which would throw a RangeError. Both conditions together guarantee we never read past the list.

---

**Next:** `05-LoopControl.md` for the two keywords that change how loops behave: `break` and `continue`.
