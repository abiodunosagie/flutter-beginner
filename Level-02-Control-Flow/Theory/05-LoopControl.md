# Loop Control: `break` and `continue`

## Why This Topic Exists

Sometimes a loop needs to bend the rules:

- "I found what I was looking for. Stop searching."
- "Skip this item, but keep going with the rest."

Two keywords handle these two needs: **`break`** and **`continue`**. They work in any kind of loop (`for`, `for-in`, `while`, `do-while`).

---

## The Mental Model

Think of a loop like a queue of people walking through a door, one at a time.

- **`break`** is a guard who closes the door. Nobody else gets through. The loop is over.
- **`continue`** is a guard who waves the current person past without doing anything, and lets the next person try.

Same loop structure. Different effect on the current round.

---

## `break`: Stop The Loop Now

`break` exits the loop **immediately**, no matter how many rounds were left.

```dart
for (int i = 1; i <= 10; i++) {
  if (i == 5) {
    break;       // stop the loop right here
  }
  print(i);
}
print('Done');
```

Output:
```
1
2
3
4
Done
```

When `i` becomes 5, `break` runs. The loop ends. The `print('Done')` after the loop runs as normal.

### When you use `break`

The most common case is **searching**: you find what you wanted, so there is no point in continuing.

```dart
List<int> numbers = [3, 7, 2, 9, 4, 6];
int target = 9;
int foundAt = -1;

for (int i = 0; i < numbers.length; i++) {
  if (numbers[i] == target) {
    foundAt = i;
    break;       // we found it, stop looking
  }
}

print('Found at index $foundAt');   // 3
```

Without `break`, the loop would keep checking the rest of the list for no reason. `break` saves the wasted work.

---

## `continue`: Skip This Round, Keep Going

`continue` skips the rest of the current round and jumps to the next round of the loop.

```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) {
    continue;    // skip the print for this round
  }
  print(i);
}
```

Output:
```
1
2
4
5
```

Notice 3 is missing. When `i` was 3, `continue` ran, the `print` was skipped, and the loop moved on to 4.

### When you use `continue`

The most common case is **filtering**: you want to ignore certain items but process the rest.

```dart
List<int> ages = [25, -5, 30, 0, 45, -10, 50];
int total = 0;
int count = 0;

for (int age in ages) {
  if (age <= 0) {
    continue;    // skip invalid ages
  }
  total += age;
  count++;
}

print('Average: ${total / count}');
```

The `continue` skips the totalling step for any age that is zero or negative. The valid ages still get added.

---

## Side By Side: `break` vs `continue`

Same loop, two different behaviours:

```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) break;      // stops the whole loop
  print(i);
}
// Output: 1, 2

for (int i = 1; i <= 5; i++) {
  if (i == 3) continue;   // skips just round 3
  print(i);
}
// Output: 1, 2, 4, 5
```

The pictures:

```
break    1 → 2 → 3 → STOP (4, 5 never run)

continue 1 → 2 → SKIP → 4 → 5
```

---

## Both Work In `while` Loops Too

The same keywords work in any loop. Example:

```dart
int i = 0;

while (i < 10) {
  i++;
  if (i == 3) continue;     // skip 3
  if (i == 7) break;        // stop at 7
  print(i);
}
```

Output:
```
1
2
4
5
6
```

Order matters: `i++` runs first so the counter moves before the skip/stop checks. Otherwise we would create an infinite loop on `i == 3`.

---

## Nested Loops: Which Loop Does `break` Stop?

When you have a loop inside a loop, `break` only stops the **innermost** one.

```dart
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (j == 2) break;     // breaks the inner loop only
    print('i=$i, j=$j');
  }
}
```

Output:
```
i=1, j=1
i=2, j=1
i=3, j=1
```

The outer loop kept going. The inner one was reset and re-broken three times.

### Labels: Break An Outer Loop

If you want `break` to escape **both** loops, give the outer loop a label and break that label.

```dart
outer:
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (j == 2) break outer;     // breaks the loop named 'outer'
    print('i=$i, j=$j');
  }
}
print('Done');
```

Output:
```
i=1, j=1
Done
```

The label is just a name (no quotes). Place it right before the loop, end with a colon, then use `break labelName;` inside.

`continue` works with labels too: `continue outer;` jumps to the next round of the outer loop.

> **Honest advice:** labels are rarely used in real code. If you find yourself reaching for them, your function might be doing too much. Move the search into a separate function and `return` instead.

---

## Worked Examples

### 1. First even number

```dart
List<int> nums = [1, 3, 5, 8, 9, 10];

for (int n in nums) {
  if (n % 2 == 0) {
    print('First even: $n');
    break;
  }
}
// Output: First even: 8
```

### 2. Skip empty inputs

```dart
List<String> inputs = ['hello', '', 'world', '', 'dart'];

for (String s in inputs) {
  if (s.isEmpty) continue;
  print(s);
}
// Output: hello, world, dart
```

### 3. Limited processing

```dart
List<String> tasks = ['a', 'b', 'c', 'd', 'e'];
int processed = 0;

for (String task in tasks) {
  print('Doing $task');
  processed++;
  if (processed >= 3) break;
}
// Output: Doing a, Doing b, Doing c
```

### 4. Find in a 2D grid

```dart
List<List<int>> grid = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];

int target = 5;
int row = -1, col = -1;

search:
for (int i = 0; i < grid.length; i++) {
  for (int j = 0; j < grid[i].length; j++) {
    if (grid[i][j] == target) {
      row = i;
      col = j;
      break search;
    }
  }
}

print('Found at row $row, col $col');
```

This is one of the few honest uses of a label. Once we find the target, both loops can stop.

---

## Why This Matters In Flutter

You will use `continue` constantly when filtering data:

```dart
for (var product in allProducts) {
  if (!product.inStock) continue;
  if (product.price > userBudget) continue;
  showProduct(product);
}
```

You will use `break` less often in UI code, but it still appears in tasks like "find the first product matching the search query".

---

## Common Mistakes

1. **Confusing `break` and `continue`.** Memory hook: **break** *breaks* the loop. **Continue** *continues* the loop.
2. **Putting `break` outside a loop.** It is a syntax error. Both keywords only make sense inside a loop.
3. **Forgetting to update the counter before `continue` in a `while` loop.** This creates an infinite loop, because the skip happens before the counter changes.

```dart
// Bug: i never changes when i == 3
int i = 0;
while (i < 5) {
  if (i == 3) continue;   // jumps back to the check, i still 3 forever
  print(i);
  i++;
}
```

Fix: increment `i` **before** the `continue`, or rewrite as a `for` loop.

---

## Recap In One Minute

- `break` exits the loop right now. Use it for searches and early exits.
- `continue` skips the rest of this round. Use it for filtering.
- Both work in `for`, `for-in`, `while`, and `do-while`.
- In nested loops, `break` only exits the innermost one. Use a label if you need to escape further.
- `while (true) { ... break; }` is a valid pattern when you cannot express the stop condition in the `while` part.

---

## Quick Quiz

**Q1.** What prints?
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) continue;
  print(i);
}
```

<details>
<summary>Answer</summary>
1, 2, 4, 5. Round 3 is skipped, the rest run normally.
</details>

**Q2.** What prints?
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) break;
  print(i);
}
```

<details>
<summary>Answer</summary>
1, 2. The loop stops the moment `i` is 3. Rounds 3, 4 and 5 never run.
</details>

**Q3.** Which loop does `break` exit by default in nested loops?

<details>
<summary>Answer</summary>
Only the innermost loop. To exit an outer loop, label it and use `break labelName;`.
</details>

**Q4.** Spot the bug:
```dart
int i = 0;
while (i < 5) {
  if (i == 2) continue;
  print(i);
  i++;
}
```

<details>
<summary>Answer</summary>
When `i` becomes 2, `continue` jumps back to the check without running `i++`. `i` stays at 2 forever, infinite loop. Move `i++` to the top of the body or use a for loop.
</details>

---

## Assignment

### Problem 1: Predict the output

What does each loop print?

```dart
// A
for (int i = 1; i <= 10; i++) {
  if (i == 4) continue;
  if (i == 7) break;
  print(i);
}

// B
for (int i = 1; i <= 5; i++) {
  for (int j = 1; j <= 5; j++) {
    if (j > i) break;
    print('$i,$j');
  }
}
```

### Problem 2: First prime above a threshold

A prime number is a number greater than 1 that is divisible only by 1 and itself. Write a function `int firstPrimeAbove(int n)` that returns the first prime number strictly greater than `n`. For `firstPrimeAbove(10)` the answer is 11. For `firstPrimeAbove(20)` it is 23.

You will use both `break` and `continue` here. Plan how before you start typing.

### Problem 3: Filter and sum

Given a list of integers, return the sum of every positive even number. Skip negatives, skip zero, skip odd numbers. Use `continue`. Do not use `where` or `map`.

Test on `[3, -2, 4, 0, 5, 6, -8, 7, 10]`. Expected sum: 4 + 6 + 10 = 20.

### Problem 4: Find target in a 2D grid

Given a 2D grid (a list of lists of ints) and a target value, return a record with the row and column where the target first appears, scanned row by row. If the target is not found, return -1, -1.

```dart
List<List<int>> grid = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
];
```

Find 5 (expected: row 1, col 1). Find 9 (expected: row 2, col 2). Find 99 (expected: -1, -1).

You will need to break out of both loops cleanly. Use a label, then write a second version that uses `return` instead.

### Problem 5: Process valid orders only

You are given a list of order amounts. Process each one by adding to a running total, but:

- Skip any negative amount (invalid).
- Skip any amount over 1,000,000 (suspicious, requires manual review).
- Stop processing entirely once you reach 5 valid orders (you only have time for so many today).

Return the total. Test on `[200, -50, 1500000, 300, 400, 500, -100, 600, 700]`. Expected: 200+300+400+500+600 = 2000 (stopped at 5 valid).

---

## Assignment Answers

### Problem 1: Predict the output

**Loop A output:**

```
1
2
3
5
6
```

Trace:

| i | check `i == 4` | check `i == 7` | what runs |
|---|----------------|----------------|-----------|
| 1 | no | no | print(1) |
| 2 | no | no | print(2) |
| 3 | no | no | print(3) |
| 4 | yes, continue | --- | skip print, go to 5 |
| 5 | no | no | print(5) |
| 6 | no | no | print(6) |
| 7 | no | yes, break | exit loop |

8, 9, 10 never run because we broke out at 7.

**Loop B output:**

```
1,1
2,1
2,2
3,1
3,2
3,3
4,1
4,2
4,3
4,4
5,1
5,2
5,3
5,4
5,5
```

Why this triangle pattern: the inner loop has the condition `if (j > i) break;`. So in row `i = 1`, the inner loop runs for `j = 1` only (when `j` becomes 2, `2 > 1` triggers break). In row `i = 2`, it runs for `j = 1, 2`. And so on. The result is a lower-triangular pattern.

`break` only exits the inner loop. The outer loop keeps going for the next `i`.

### Problem 2: First prime above a threshold

```dart
bool isPrime(int n) {
  if (n < 2) return false;
  for (int d = 2; d * d <= n; d++) {
    if (n % d == 0) return false;     // found a divisor, not prime
  }
  return true;
}

int firstPrimeAbove(int n) {
  int candidate = n + 1;
  while (true) {
    if (isPrime(candidate)) return candidate;
    candidate++;
  }
}
```

How the design works:

1. **Helper function `isPrime`.** Walk divisors `d` starting at 2. If any `d` divides `n` evenly (`n % d == 0`), it is not prime. We can stop as soon as `d * d > n`, because any divisor larger than the square root would have a partner smaller than the square root, which we would have found already. The `return false` inside the loop is essentially a `break` with a result.
2. **Main function `firstPrimeAbove`.** Start one above `n`. Loop forever (`while (true)`). Each round, check if the current candidate is prime. If yes, return. If no, increment and try again.
3. **Why `while (true)` is safe here.** We have a guaranteed exit via `return`. There are infinitely many primes (proven mathematically), so the loop cannot run forever in practice.

Trace for `firstPrimeAbove(10)`:
- candidate 11: isPrime(11)? Try d=2: 11%2=1 no. Try d=3: d*d=9 <= 11, 11%3=2 no. Try d=4: d*d=16 > 11, exit loop. Return true. We return 11.

Trace for `firstPrimeAbove(20)`:
- 21: divisible by 3 (21 = 3 * 7), not prime, increment.
- 22: divisible by 2, not prime, increment.
- 23: try d=2 (no), d=3 (no), d=4 (16 < 23, 23%4=3 no), d=5 (25 > 23, exit). Prime. Return 23.

### Problem 3: Filter and sum

```dart
int sumPositiveEvens(List<int> nums) {
  int total = 0;

  for (int n in nums) {
    if (n <= 0) continue;        // skip negatives and zero
    if (n.isOdd) continue;       // skip odd numbers
    total += n;
  }

  return total;
}
```

How the logic flows:

For each number, we check the disqualifying conditions one at a time. If any of them apply, we `continue` and skip the addition. Only numbers that pass every check reach `total += n`.

Trace on `[3, -2, 4, 0, 5, 6, -8, 7, 10]`:

| n | check | action |
|---|-------|--------|
| 3 | odd | continue |
| -2 | <= 0 | continue |
| 4 | passes | total = 4 |
| 0 | <= 0 | continue |
| 5 | odd | continue |
| 6 | passes | total = 10 |
| -8 | <= 0 | continue |
| 7 | odd | continue |
| 10 | passes | total = 20 |

Final total: 20. Correct.

This pattern, "use `continue` to skip items that fail a filter", is one of the most common shapes in real code. As you get more advanced you will use `where` for the same job, but the explicit version makes the intent crystal clear.

### Problem 4: Find target in a 2D grid

**Version 1, with a label:**

```dart
({int row, int col}) findInGrid(List<List<int>> grid, int target) {
  int foundRow = -1;
  int foundCol = -1;

  search:
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      if (grid[i][j] == target) {
        foundRow = i;
        foundCol = j;
        break search;
      }
    }
  }

  return (row: foundRow, col: foundCol);
}
```

How the label version works:

1. **The label `search:`** is placed right before the outer loop. It does not change behaviour by itself. It just gives the loop a name we can refer to.
2. **`break search;`** breaks the loop with the matching label. Since the outer loop has that label, we exit the outer loop, which automatically also exits the inner loop.
3. **We capture the indexes** in outer variables before breaking, because after the break we cannot reach the values of `i` and `j` from inside the loops.
4. **The return type `({int row, int col})`** is a Dart record, a quick way to bundle two values together. You will see this more in Level 4.

**Version 2, with return:**

```dart
({int row, int col}) findInGrid(List<List<int>> grid, int target) {
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      if (grid[i][j] == target) {
        return (row: i, col: j);     // exits the whole function
      }
    }
  }
  return (row: -1, col: -1);
}
```

This is shorter and arguably cleaner. `return` does the same job as `break search` here, plus it sends the result back at the same time. We also do not need temporary variables. As we said in the lesson, "if you reach for a label, often a function with `return` is the better answer". This is the proof.

### Problem 5: Process valid orders only

```dart
int processOrders(List<int> orders) {
  int total = 0;
  int processed = 0;

  for (int amount in orders) {
    if (amount < 0) continue;            // skip invalid
    if (amount > 1000000) continue;      // skip suspicious

    total += amount;
    processed++;

    if (processed >= 5) break;           // done for the day
  }

  return total;
}
```

How the rules map to the code:

1. **Two `continue` statements** at the top of the body handle the two skip conditions. Order does not matter much here since both are disqualifying.
2. **The valid-order work** (add to total, increment processed) only runs if neither `continue` fired.
3. **The `break`** is at the bottom of the body. Once we have processed 5 valid orders, no point in looking at the rest of the list.

Trace on `[200, -50, 1500000, 300, 400, 500, -100, 600, 700]`:

| amount | check | action | total | processed |
|--------|-------|--------|-------|-----------|
| 200 | passes | add | 200 | 1 |
| -50 | < 0 | continue | 200 | 1 |
| 1500000 | > 1M | continue | 200 | 1 |
| 300 | passes | add | 500 | 2 |
| 400 | passes | add | 900 | 3 |
| 500 | passes | add | 1400 | 4 |
| -100 | < 0 | continue | 1400 | 4 |
| 600 | passes | add | 2000 | 5, then break |

Final total: 2000. Correct.

Note that 700 was never visited. The loop ended at the break.

---

**Done with Level 2 theory!**

Next, head to the `Examples/` folder to run the working code, then `Exercises.md` to practise on your own.

When you are ready to move on, open `../Level-03-Functions-Collections/README.md`.
