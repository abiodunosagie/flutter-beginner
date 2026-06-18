# For Loops: Repeating Code A Set Number Of Times

## The Problem Loops Solve

Imagine your boss says: "Print Hello to the screen 1000 times."

Without a loop:
```dart
print('Hello');
print('Hello');
print('Hello');
// ...997 more lines...
```

Nobody does this. With a loop:

```dart
for (int i = 0; i < 1000; i++) {
  print('Hello');
}
```

Three lines. Works for 5 prints, 1000 prints, or 1 million. That is what loops are for.

---

## The Mental Model

A loop is a **repeating instruction**. It says: "Run this block of code, again and again, until I tell you to stop."

The `for` loop in particular is best when you know **how many times** you want to run. If you can answer "I want to do this exactly N times", use a `for` loop.

If you do not know how many times in advance, use `while`. We will get there in the next lesson.

---

## The Syntax, Broken Apart

```dart
for (int i = 0; i < 5; i++) {
  print(i);
}
```

That one line has **three parts**, separated by semicolons. Read each one carefully.

```
for (int i = 0;     i < 5;     i++) {
     ──┬───────    ──┬──     ─┬──
       1             2          3
}
```

**Part 1, Initialisation: `int i = 0`**
This runs **once**, before the loop starts. It creates a counter called `i` and sets it to 0. Think of it as setting up your starting point.

**Part 2, Condition: `i < 5`**
This is checked **before every round** of the loop. If true, the body runs. If false, the loop ends. This is your "should I keep going?" question.

**Part 3, Update: `i++`**
This runs **after every round** of the body. `i++` means "add 1 to `i`". This is how the counter moves forward so eventually the condition becomes false.

If you remove the update step, the counter never moves and the loop runs forever. Remember this.

---

## A Hand-Trace: Watching The Variable Change

Take this loop:

```dart
for (int i = 0; i < 5; i++) {
  print('i is $i');
}
```

Walk through it step by step. This table is what you should draw in your notebook the first time you meet a loop.

| Round | Init | Check `i < 5` | Body runs | Update | New `i` |
|-------|------|---------------|-----------|--------|---------|
| Setup | i = 0 | --- | --- | --- | 0 |
| 1 | --- | 0 < 5 → true | print "i is 0" | i++ | 1 |
| 2 | --- | 1 < 5 → true | print "i is 1" | i++ | 2 |
| 3 | --- | 2 < 5 → true | print "i is 2" | i++ | 3 |
| 4 | --- | 3 < 5 → true | print "i is 3" | i++ | 4 |
| 5 | --- | 4 < 5 → true | print "i is 4" | i++ | 5 |
| Stop | --- | 5 < 5 → false | --- | --- | --- |

Output:
```
i is 0
i is 1
i is 2
i is 3
i is 4
```

Five rounds. Five prints. The counter went 0, 1, 2, 3, 4 and then 5, which broke the condition.

If this table makes sense, you understand `for` loops. The rest of this file is just variations.

---

## Why `i`?

`i` stands for "index". It is a tradition older than most programmers alive. You will see `i` everywhere. When you have a loop inside a loop, the inner one is usually `j`, then `k`. You can name your counter anything, but stick with `i`, `j`, `k` so other developers understand your code at a glance.

---

## The Off-By-One Trap

Compare these two:

```dart
for (int i = 0; i < 5; i++)   // runs 5 times: 0, 1, 2, 3, 4
for (int i = 0; i <= 5; i++)  // runs 6 times: 0, 1, 2, 3, 4, 5
```

One small character, `<` vs `<=`, changes the count by 1. This is called an **off-by-one error**. It is one of the most common bugs in all of programming.

The rule of thumb:
- **Counting from 0**: use `i < n`. The loop runs `n` times.
- **Counting from 1**: use `i <= n`. The loop runs `n` times.

```dart
// Print 1 to 10
for (int i = 1; i <= 10; i++) print(i);

// Print 0 to 9
for (int i = 0; i < 10; i++) print(i);
```

Both run 10 times. Pick whichever feels more natural for the task.

---

## Counting Down

You are not stuck counting up. Reverse the parts:

```dart
for (int i = 5; i > 0; i--) {
  print(i);
}
// Output: 5, 4, 3, 2, 1
```

What changed:
- Init: start at 5 instead of 0.
- Condition: `i > 0` instead of `i < 5`.
- Update: `i--` (subtract 1) instead of `i++`.

Useful for countdowns, reverse sorting, and removing items from a list (we will see why in Level 3).

---

## Counting By Larger Steps

You can update by any amount, not just 1:

```dart
// Print even numbers 0 to 10
for (int i = 0; i <= 10; i += 2) {
  print(i);
}
// Output: 0, 2, 4, 6, 8, 10
```

`i += 2` means "add 2 to `i`". Same as `i = i + 2`.

---

## The For-In Loop (For Lists)

When you have a list and you want to touch each item, this form is cleaner:

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];

for (String fruit in fruits) {
  print(fruit);
}
```

Read it as: "For each fruit in the list of fruits, print it."

Compare to the long way:
```dart
for (int i = 0; i < fruits.length; i++) {
  print(fruits[i]);
}
```

Both produce the same output. The for-in form is shorter and clearer **when you do not need the index**. Use it whenever you can.

If you do need the index (for example, "print the first three"), stick with the classic `for` loop.

> **Note:** If you have not seen `List` yet, do not panic. We cover lists fully in Level 3. For now, just know a list is a group of items, and you can loop over them with `for-in`.

---

## Nested Loops (Loop Inside A Loop)

A loop can sit inside another loop. The inner loop runs all the way through, **for each round** of the outer loop.

```dart
for (int row = 1; row <= 3; row++) {
  for (int col = 1; col <= 3; col++) {
    print('Row $row, Col $col');
  }
}
```

Output:
```
Row 1, Col 1
Row 1, Col 2
Row 1, Col 3
Row 2, Col 1
Row 2, Col 2
Row 2, Col 3
Row 3, Col 1
Row 3, Col 2
Row 3, Col 3
```

The outer loop ran 3 times. The inner loop ran 3 times **inside each** outer round. Total: 9 prints.

Use nested loops for grids, multiplication tables, and 2D patterns.

---

## Worked Examples

### 1. Sum of 1 to 10

```dart
void main() {
  int total = 0;

  for (int i = 1; i <= 10; i++) {
    total += i;     // same as: total = total + i
  }

  print(total);     // 55
}
```

Trace it: total starts at 0, then becomes 1, 3, 6, 10, 15, 21, 28, 36, 45, 55.

### 2. Multiplication table

```dart
void main() {
  int n = 7;

  for (int i = 1; i <= 12; i++) {
    print('$n x $i = ${n * i}');
  }
}
```

### 3. Find the largest number

```dart
void main() {
  List<int> scores = [42, 91, 18, 77, 65];
  int max = scores[0];

  for (int score in scores) {
    if (score > max) {
      max = score;
    }
  }

  print('Highest: $max');   // 91
}
```

### 4. Build a star pattern

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    print('*' * i);
  }
}
```

Output:
```
*
**
***
****
*****
```

`'*' * i` repeats the star character `i` times. Useful trick.

---

## Why This Matters In Flutter

In Flutter, you build lists of UI elements (called **widgets**) by looping over data.

Tiny preview, do not run yet:

```dart
List<String> products = ['T-shirt', 'Shoes', 'Cap'];

return Column(
  children: [
    for (String name in products)
      Text(name),
  ],
);
```

That is a real Flutter pattern called a **collection-for**. It builds one `Text` widget per product. Every shopping app you have ever used builds its product list this way. Every chat app builds its message list this way. The `for` loop is one of the building blocks of any real app.

---

## Common Mistakes

1. **Off-by-one.** Mixing up `<` and `<=`. Trace the loop on paper before running.
2. **Infinite loop.** Forgetting the update or writing the wrong direction (`i--` when you meant `i++`).
3. **Wrong variable.** Using `j` inside a loop when the counter is `i`.
4. **Modifying the list while looping over it.** This breaks for-in loops. We will cover safe ways in Level 3.

---

## Recap In One Minute

- A `for` loop runs the same code multiple times with a counter.
- Three parts: init, condition, update. All three are needed.
- The body runs as long as the condition is true.
- Use `for-in` for lists when you do not need the index.
- Watch for off-by-one with `<` vs `<=`.
- Loops can nest. Inner loop runs all the way through for each outer round.

---

## Quick Quiz

**Q1.** How many times does this run?
```dart
for (int i = 0; i < 8; i++) { }
```

<details>
<summary>Answer</summary>
8 times. The counter goes 0, 1, 2, 3, 4, 5, 6, 7 and then stops when 8 is not less than 8.
</details>

**Q2.** What does this print?
```dart
for (int i = 10; i >= 5; i -= 2) {
  print(i);
}
```

<details>
<summary>Answer</summary>
10, 8, 6. The counter starts at 10 and subtracts 2 each round. After 6, the next value is 4 which fails the `i >= 5` check, so the loop stops.
</details>

**Q3.** Rewrite using `for-in`:
```dart
List<String> names = ['Ada', 'Bola', 'Chidi'];
for (int i = 0; i < names.length; i++) {
  print(names[i]);
}
```

<details>
<summary>Answer</summary>

```dart
for (String name in names) {
  print(name);
}
```
</details>

**Q4.** What is the bug?
```dart
for (int i = 0; i < 5; i--) {
  print(i);
}
```

<details>
<summary>Answer</summary>
The update is `i--` (subtract), but the condition expects `i` to grow toward 5. `i` starts at 0 and goes -1, -2, -3, forever. This is an infinite loop. The fix is `i++`.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before reading the answer. Everything uses classic `for` loops in `main`. (Functions and Lists come in Level 3, so we do not need them yet.)

### Problem 1: Predict the output

Without running, what does this print?

```dart
void main() {
  int sum = 0;
  for (int i = 1; i <= 5; i++) {
    sum += i;
    print('After round $i, sum is $sum');
  }
}
```

### Problem 2: Multiplication table

In `main`, make `int n = 7`. Use a `for` loop to print the table from `7 x 1` up to `7 x 12`:

```
7 x 1 = 7
7 x 2 = 14
...
7 x 12 = 84
```

### Problem 3: Sum and average of 1 to N

In `main`, make `int n = 5`. Use a `for` loop to add up all the numbers from 1 to `n` into an `int total`. Then print the total and the average (`total / n`). For `n = 5`, the total is 15 and the average is 3.0.

### Problem 4: Star pyramids

In `main`, make `int height = 5`. First print a left-aligned pyramid using a `for` loop:

```
*
**
***
****
*****
```

Then, below it, print a centred pyramid:

```
    *
   ***
  *****
 *******
*********
```

Hint for the centred one: on row `i`, print `(height - i)` spaces, then `(2 * i - 1)` stars. Remember `' ' * n` repeats a space `n` times.

### Problem 5: Multiplication grid (nested loops)

In `main`, use a loop inside a loop to print a 3 by 3 grid of products. Each line should show one row, like this:

```
1 2 3
2 4 6
3 6 9
```

Hint: the outer loop is the row (1 to 3), the inner loop is the column (1 to 3), and each cell is `row * col`. Build each row into a `String` and print it once per row.

---

## Assignment Answers

### Problem 1: Predict the output

```
After round 1, sum is 1
After round 2, sum is 3
After round 3, sum is 6
After round 4, sum is 10
After round 5, sum is 15
```

Round by round:

| i | sum before | sum after `sum += i` | prints |
|---|------------|----------------------|--------|
| 1 | 0 | 1 | After round 1, sum is 1 |
| 2 | 1 | 3 | After round 2, sum is 3 |
| 3 | 3 | 6 | After round 3, sum is 6 |
| 4 | 6 | 10 | After round 4, sum is 10 |
| 5 | 10 | 15 | After round 5, sum is 15 |

We update `sum` first, then print, so the printed value already includes `i`. After round 5, `i` becomes 6, the check `i <= 5` fails, and the loop stops.

### Problem 2: Multiplication table

```dart
void main() {
  int n = 7;
  for (int i = 1; i <= 12; i++) {
    print('$n x $i = ${n * i}');
  }
}
```

The loop runs 12 times with `i` going 1 to 12. Inside, `${n * i}` works out the product and drops it into the sentence, while `$n` and `$i` drop in the plain values.

### Problem 3: Sum and average of 1 to N

```dart
void main() {
  int n = 5;
  int total = 0;

  for (int i = 1; i <= n; i++) {
    total += i;
  }

  print('Total: $total');           // Total: 15
  print('Average: ${total / n}');   // Average: 3.0
}
```

Each round adds `i` to `total`: 1, then 3, then 6, then 10, then 15. The average is `total / n`, which is `15 / 5 = 3.0`. (Divide always gives a decimal, so it shows `3.0`.)

### Problem 4: Star pyramids

```dart
void main() {
  int height = 5;

  // Left-aligned
  for (int i = 1; i <= height; i++) {
    print('*' * i);
  }

  print('');   // a blank line between the two

  // Centred
  for (int i = 1; i <= height; i++) {
    int spaces = height - i;
    int stars = 2 * i - 1;
    print(' ' * spaces + '*' * stars);
  }
}
```

The left pyramid uses `'*' * i`, which repeats a star `i` times, so each row has one more star.

For the centred one, look at the pattern for `height = 5`:

| Row i | Spaces | Stars |
|-------|--------|-------|
| 1 | 4 | 1 |
| 2 | 3 | 3 |
| 3 | 2 | 5 |
| 4 | 1 | 7 |
| 5 | 0 | 9 |

Spaces shrink (`height - i`) and stars grow by 2 (`2 * i - 1`). Each line is the spaces joined with the stars using `+`.

### Problem 5: Multiplication grid (nested loops)

```dart
void main() {
  for (int row = 1; row <= 3; row++) {
    String line = '';
    for (int col = 1; col <= 3; col++) {
      line += '${row * col} ';
    }
    print(line);
  }
}
```

Output:

```
1 2 3 
2 4 6 
3 6 9 
```

How it works:

1. The **outer loop** picks the row (1, 2, 3).
2. For each row, we start with an empty `line`.
3. The **inner loop** runs fully (col 1, 2, 3), adding `row * col` and a space to `line` each time.
4. After the inner loop finishes, we print the whole row at once.

The inner loop runs completely for every single round of the outer loop, which is the heart of nested loops. (There is a trailing space at the end of each line, which is fine.)

---

**Next:** `04-WhileLoops.md` for the kind of loop where you do not know in advance how many times to run.
