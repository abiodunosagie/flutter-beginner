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

### Problem 2: Multiplication table generator

Write a function `void printTable(int n)` that prints the multiplication table for `n` from `n x 1` up to `n x 12`. Then call it for 7 and 9. The output for `printTable(7)` should look like:

```
7 x 1 = 7
7 x 2 = 14
...
7 x 12 = 84
```

### Problem 3: Sum and average

Without using any list method (no `reduce`, no `fold`), write a function `double averageOf(List<int> nums)` that returns the average of the values in the list. Handle the empty list by returning 0. Test it on `[2, 4, 6, 8]` (expected: 5.0) and `[]` (expected: 0.0).

### Problem 4: Star pyramid

Write a function `void pyramid(int height)` that prints a left-aligned star pyramid. For `pyramid(5)`:

```
*
**
***
****
*****
```

Then write a second function `void centerPyramid(int height)` that prints a centred pyramid. For `centerPyramid(5)`:

```
    *
   ***
  *****
 *******
*********
```

This second one will need both spaces and stars on each line.

### Problem 5: Reverse a list manually

Without using `list.reversed`, write a function `List<int> reverseList(List<int> nums)` that returns a **new** list with the items in reverse order. Use a classic for loop and explain in plain words how the loop walks through the original list.

Hint: there are two clean ways. Either count down on the source, or count up but build backwards on the result.

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

How the trace was done, round by round:

| i | sum before | sum after `sum += i` | What prints |
|---|------------|----------------------|-------------|
| 1 | 0 | 1 | After round 1, sum is 1 |
| 2 | 1 | 3 | After round 2, sum is 3 |
| 3 | 3 | 6 | After round 3, sum is 6 |
| 4 | 6 | 10 | After round 4, sum is 10 |
| 5 | 10 | 15 | After round 5, sum is 15 |

The key is the order: we first update `sum`, then we print. That is why the printed value already includes `i`. If `print` came before `sum += i`, the values would be 0, 1, 3, 6, 10.

After round 5, `i` becomes 6, the condition `i <= 5` fails, the loop exits.

### Problem 2: Multiplication table generator

```dart
void printTable(int n) {
  for (int i = 1; i <= 12; i++) {
    print('$n x $i = ${n * i}');
  }
}

void main() {
  printTable(7);
  print('---');
  printTable(9);
}
```

How this was built:

1. The loop has to run 12 times. With the form `i = 1` and `i <= 12`, we get `i` taking values 1, 2, 3, ... 12. Twelve rounds.
2. Inside the body, we use string interpolation: `${n * i}` calculates the product on the fly and converts to a string. `$n` and `$i` are simpler interpolations because they are just variables.
3. Calling `printTable(7)` and `printTable(9)` from `main` gives us both tables, separated by a divider.

The whole point of putting the loop inside a function: we wrote the table-printing logic once, but we use it twice with two different inputs. That is the function-plus-loop combo at work.

### Problem 3: Sum and average

```dart
double averageOf(List<int> nums) {
  if (nums.isEmpty) return 0;

  int total = 0;
  for (int n in nums) {
    total += n;
  }

  return total / nums.length;
}
```

Walkthrough:

1. **Guard against the empty list first.** Dividing by zero would crash, so we return 0 right away. This is the early-return pattern from the if-statements assignment.
2. **Sum with a `for-in` loop.** We do not need indexes, just the values. Each round, add the value to `total`.
3. **Divide.** `total` is an `int`, and `nums.length` is also an `int`. In Dart, `int / int` returns a `double`. Perfect, since the return type is `double`.

Testing:
- `averageOf([2, 4, 6, 8])`: total = 2+4+6+8 = 20, length = 4, 20/4 = 5.0. Correct.
- `averageOf([])`: empty, returns 0. Correct.

### Problem 4: Star pyramid

**Left-aligned:**

```dart
void pyramid(int height) {
  for (int i = 1; i <= height; i++) {
    print('*' * i);
  }
}
```

The trick: `'*' * i` is string multiplication. It repeats `'*'` exactly `i` times. So row 1 prints 1 star, row 2 prints 2 stars, all the way to `height`.

**Centred pyramid:**

```dart
void centerPyramid(int height) {
  for (int i = 1; i <= height; i++) {
    int spaces = height - i;
    int stars = 2 * i - 1;
    print(' ' * spaces + '*' * stars);
  }
}
```

How the formula was derived:

For `height = 5`, the output rows have these counts:

| Row i | Spaces before | Stars |
|-------|---------------|-------|
| 1 | 4 | 1 |
| 2 | 3 | 3 |
| 3 | 2 | 5 |
| 4 | 1 | 7 |
| 5 | 0 | 9 |

Notice patterns:
- Spaces shrink by 1 each row, starting at `height - 1` and ending at 0. Formula: `height - i`.
- Stars grow by 2 each row, starting at 1. So stars go 1, 3, 5, 7, 9. The k-th odd number is `2k - 1`. Formula: `2 * i - 1`.

Each line is `(spaces of ' ') + (stars of '*')`. Concatenating with `+` builds the line, then `print` outputs it.

This problem teaches you that loop bodies can compute multiple things per round. The loop variable `i` is the row, and you derive other values from it.

### Problem 5: Reverse a list manually

**Approach 1: count down on the source.**

```dart
List<int> reverseList(List<int> nums) {
  List<int> result = [];
  for (int i = nums.length - 1; i >= 0; i--) {
    result.add(nums[i]);
  }
  return result;
}
```

In plain words: start at the last index of `nums` (which is `length - 1`), and walk backwards down to 0. For each step, take that item and append it to a new list. By the time we reach 0, we have appended every item in reverse order.

Trace on `[1, 2, 3, 4]`:

| i | nums[i] | result after |
|---|---------|--------------|
| 3 | 4 | [4] |
| 2 | 3 | [4, 3] |
| 1 | 2 | [4, 3, 2] |
| 0 | 1 | [4, 3, 2, 1] |

When `i` would become -1, the condition `i >= 0` fails and the loop ends. We return `[4, 3, 2, 1]`.

**Approach 2: count up but insert at the front.**

```dart
List<int> reverseList(List<int> nums) {
  List<int> result = [];
  for (int n in nums) {
    result.insert(0, n);
  }
  return result;
}
```

Each time we read an item, we insert it at index 0 (the front). The previous items get pushed back. By the end, the order is reversed.

Both work. Approach 1 is faster in practice because `insert(0, ...)` has to shift all existing items each time. Approach 1 just appends. For a beginner, either is fine. As you get more experienced, prefer the first.

---

**Next:** `04-WhileLoops.md` for the kind of loop where you do not know in advance how many times to run.
