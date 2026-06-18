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

Try each in [dartpad.dev](https://dartpad.dev) before reading the answer. Everything uses loops in `main` over number ranges. (Functions and Lists come in Level 3, so we do not need them yet.)

### Problem 1: Predict the output

What does each loop print?

```dart
void main() {
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
}
```

### Problem 2: Sum the even numbers with continue

In `main`, use a `for` loop over 1 to 20. Use `continue` to skip the odd numbers, and add the even ones into an `int total`. Print the total. (Hint: `.isOdd` from the Numbers lesson tells you if a number is odd.)

### Problem 3: First prime above a number

In `main`, make `int n = 10`. Find the first prime number bigger than `n` and print it. (A prime is a number above 1 with no divisor other than 1 and itself.) Use a `while (true)` loop for the candidates, and inside it a `for` loop with `break` to test for a divisor. For `n = 10` the answer is 11.

### Problem 4: Find a product in a grid (labeled break)

In `main`, make `int target = 12`. Search a multiplication grid: `i` from 1 to 9, and `j` from 1 to 9. Find the **first** pair where `i * j == target`, then stop **both** loops using a label. Print the pair, like `Found at 2 x 6`.

### Problem 5: Collect five, skipping multiples of 3

In `main`, loop `i` from 1 upward. Skip every multiple of 3 with `continue`. Add the others into an `int total` and count them. Once you have collected 5 numbers, `break`. Print how many you collected and the total.

---

## Assignment Answers

### Problem 1: Predict the output

**Loop A:**

```
1
2
3
5
6
```

| i | `i == 4`? | `i == 7`? | what runs |
|---|-----------|-----------|-----------|
| 1-3 | no | no | print |
| 4 | yes, continue | --- | skip print |
| 5, 6 | no | no | print |
| 7 | no | yes, break | exit loop |

8, 9, 10 never run because we broke out at 7.

**Loop B:**

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

The inner loop breaks as soon as `j > i`. So row 1 prints just `j = 1`, row 2 prints `j = 1, 2`, and so on. That makes a triangle. The `break` only stops the inner loop, so the outer loop keeps going.

### Problem 2: Sum the even numbers with continue

```dart
void main() {
  int total = 0;

  for (int i = 1; i <= 20; i++) {
    if (i.isOdd) continue;   // skip odd numbers
    total += i;
  }

  print(total);   // 110
}
```

When `i` is odd, `continue` skips the addition and moves on. Only the even numbers (2, 4, 6, ... 20) reach `total += i`. Their sum is 110.

### Problem 3: First prime above a number

```dart
void main() {
  int n = 10;
  int candidate = n + 1;

  while (true) {
    bool isPrime = candidate > 1;

    for (int d = 2; d * d <= candidate; d++) {
      if (candidate % d == 0) {
        isPrime = false;
        break;             // found a divisor, stop checking
      }
    }

    if (isPrime) break;    // candidate is prime, stop searching
    candidate++;
  }

  print('First prime above $n is $candidate');   // 11
}
```

How it works:

1. Start checking at `n + 1` (which is 11).
2. For each candidate, assume it is prime, then look for a divisor with the inner `for` loop. If `candidate % d == 0`, it has a divisor, so it is not prime, and we `break` the inner loop early.
3. If the candidate survived (still prime), we `break` the outer `while`. Otherwise we try the next number.

For `n = 10`, candidate 11 has no divisor (we test d = 2, 3; `3 * 3 = 9 <= 11`, none divide), so it is prime. Prints 11.

### Problem 4: Find a product in a grid (labeled break)

```dart
void main() {
  int target = 12;
  int foundI = -1;
  int foundJ = -1;

  search:
  for (int i = 1; i <= 9; i++) {
    for (int j = 1; j <= 9; j++) {
      if (i * j == target) {
        foundI = i;
        foundJ = j;
        break search;   // exits BOTH loops
      }
    }
  }

  print('Found at $foundI x $foundJ');   // Found at 2 x 6
}
```

The label `search:` names the outer loop. `break search;` jumps all the way out of both loops at once. Scanning row by row, the first pair that multiplies to 12 is `2 x 6` (row 1 only reaches 1 x 9 = 9, so 12 first appears at i = 2, j = 6). We save the values before breaking, then print them.

### Problem 5: Collect five, skipping multiples of 3

```dart
void main() {
  int total = 0;
  int collected = 0;

  for (int i = 1; i <= 100; i++) {
    if (i % 3 == 0) continue;   // skip multiples of 3

    total += i;
    collected++;

    if (collected >= 5) break;  // stop once we have 5
  }

  print('Collected $collected numbers, total $total');
}
```

The `continue` skips 3, 6, 9, and so on. The numbers we keep are 1, 2, 4, 5, 7. After the fifth one (7), `collected` reaches 5 and `break` stops the loop. Their sum is `1 + 2 + 4 + 5 + 7 = 19`, so it prints `Collected 5 numbers, total 19`. This shows `continue` (skip) and `break` (stop) working together in one loop.

---

**Done with Level 2 theory!**

Next, head to the `Examples/` folder to run the working code, then the `Exercises/` folder to practise on your own.

When you are ready, open `../Level-03-Functions-Collections/Theory/00-LearningPath.md`.
