# Using Variables: Doing Things With Your Boxes

## The Big Idea In One Sentence

> Once a value is in a box, you can **show it, join it with other text, and do maths with it** to make new values.

You already know how to make boxes. Now you put them to work.

---

## Showing A Variable

Two ways, and you have seen both:

```dart
void main() {
  String name = 'Ada';
  int age = 12;

  print(name);              // Ada      (just the value)
  print('I am $name');      // I am Ada (value inside a sentence with $)
}
```

Quick reminder: no quotes shows the value, and `$name` drops the value into a sentence.

---

## Joining Text With `+`

You can stick two strings together with a `+`. This is called **joining** (or "concatenation", a big word for a simple thing).

```dart
void main() {
  String first = 'Ada';
  String last = 'Bello';

  String full = first + ' ' + last;
  print(full);     // Ada Bello
}
```

The `' '` in the middle is a space, so the two names do not get stuck together as `AdaBello`.

Most of the time the `$` way is cleaner, and it does the same thing:

```dart
String full = '$first $last';   // same result: Ada Bello
```

Use whichever feels clearer. Both are correct.

---

## Doing Maths With Number Boxes

If a box holds a number, you can do maths with it. For now we will use three simple ones:

- `+` adds
- `-` subtracts
- `*` multiplies

```dart
void main() {
  int apples = 5;
  int oranges = 3;

  int total = apples + oranges;
  print('Total fruit: $total');     // Total fruit: 8
}
```

The right side (`apples + oranges`) is worked out first, and the answer (`8`) is stored in the new box `total`.

> There are more maths signs (like divide and remainder). You will meet the full set later in `06-Operators.md`. For now, `+`, `-`, and `*` are all you need.

---

## Putting A Calculation Inside A Sentence

You know `$name` drops a value into a sentence. But what if you want to drop in the **answer to a calculation**? For that, wrap the calculation in `${ ... }` (with curly braces):

```dart
void main() {
  int age = 12;

  print('Next year you will be ${age + 1}');   // Next year you will be 13
}
```

The rule is small and worth remembering:

- `$name` for a **single variable**.
- `${ ... }` for a **calculation** (anything with maths in it).

---

## Making New Variables From Old Ones

A very common pattern: build a new value out of values you already have.

```dart
void main() {
  double price = 100.0;
  int quantity = 3;

  double total = price * quantity;

  print('Price: $price');
  print('Quantity: $quantity');
  print('Total: $total');
}
```

Output:

```
Price: 100.0
Quantity: 3
Total: 300.0
```

`total` was not typed in by hand. It was **calculated** from `price` and `quantity`.

---

## Changing A Variable Using Itself

You can update a box using its own current value. This looks strange the first time:

```dart
void main() {
  int score = 0;
  print(score);     // 0

  score = score + 10;   // take the old score (0), add 10, store 10 back
  print(score);     // 10

  score = score + 5;    // take 10, add 5, store 15 back
  print(score);     // 15
}
```

Read `score = score + 10` as: *"work out the right side using the current score, then put the answer back in score."* The right side is always worked out first.

---

## The Top Mistakes Beginners Make

### Mistake 1: Joining two names with no space

```dart
String full = first + last;     // AdaBello  (stuck together)
String full = first + ' ' + last; // Ada Bello (better)
```

### Mistake 2: Using `$` for a calculation

```dart
print('Total: $apples + oranges');    // BAD: shows "Total: 5 + oranges"
print('Total: ${apples + oranges}');  // GOOD: shows "Total: 8"
```

A calculation needs the curly braces `${ ... }`.

### Mistake 3: Thinking `score = score + 10` is impossible

It is not a contradiction. The `=` means "store", not "equals". The right side is worked out with the old value, then saved back.

---

## One-Minute Recap

- Show a value with `print(name)` or inside a sentence with `$name`.
- Join text with `+` (remember to add a space if you need one).
- Do maths on number boxes with `+`, `-`, `*` (more signs in lesson 06).
- Drop a single variable in a sentence with `$name`; drop a calculation with `${ ... }`.
- You can build new variables from old ones, and update a box using its own value.

---

## Quick Quiz

**Q1.** What does this show?

```dart
void main() {
  int a = 4;
  int b = 6;
  print('Sum: ${a + b}');
}
```

<details>
<summary>Answer</summary>

```
Sum: 10
```

`${a + b}` works out the calculation (10) and drops it in.
</details>

**Q2.** Why does this show `Sum: 4 + 6` instead of `Sum: 10`?

```dart
print('Sum: $a + b');
```

<details>
<summary>Answer</summary>
`$a` drops in just the value of `a` (4). The rest (`+ b`) is treated as plain text. For a calculation you need `${a + b}`.
</details>

**Q3.** What is `total` at the end?

```dart
int total = 0;
total = total + 5;
total = total + 5;
```

<details>
<summary>Answer</summary>
`10`. Each line takes the current total and adds 5. 0, then 5, then 10.
</details>

**Q4.** What does this print?

```dart
String first = 'Sun';
String second = 'shine';
print(first + second);
```

<details>
<summary>Answer</summary>

```
Sunshine
```

`+` joins the two strings with no space between them.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Full name

Make two String boxes, `first` and `last`, with your first and last name. Print your full name with a space between, using `$`.

### Problem 2: Add two numbers

Make two int boxes, `a = 8` and `b = 5`. Print one line: `8 plus 5 is 13`, using `${ ... }` for the calculation.

### Problem 3: Predict the output

```dart
void main() {
  int pens = 4;
  int books = 2;

  print('I have ${pens + books} things');
  print('Pens cost ${pens * 50} naira');
}
```

### Problem 4: Score keeper

Make an int box `score = 0`. Add 10 to it, then add 20 to it, each time using `score = score + ...`. Print the score after each change. The final score should be 30.

### Problem 5: Simple bill

Make `double price = 250.0` and `int quantity = 3`. Calculate `total` as price times quantity, then print:

```
Price: 250.0
Quantity: 3
Total: 750.0
```

---

## Assignment Answers

### Problem 1: Full name

```dart
void main() {
  String first = 'Ada';
  String last = 'Bello';

  print('$first $last');
}
```

Output:

```
Ada Bello
```

The space between `$first` and `$last` inside the quotes keeps the names apart.

### Problem 2: Add two numbers

```dart
void main() {
  int a = 8;
  int b = 5;

  print('$a plus $b is ${a + b}');
}
```

Output:

```
8 plus 5 is 13
```

`$a` and `$b` drop in the single values. `${a + b}` does the maths and drops in the answer.

### Problem 3: Predict the output

```
I have 6 things
Pens cost 200 naira
```

`pens + books` is `4 + 2 = 6`. `pens * 50` is `4 * 50 = 200`. Both are inside `${ ... }`, so the calculations run and the answers appear.

### Problem 4: Score keeper

```dart
void main() {
  int score = 0;

  score = score + 10;
  print(score);     // 10

  score = score + 20;
  print(score);     // 30
}
```

Output:

```
10
30
```

Each line takes the current score, adds to it, and stores the new value back in the same box.

### Problem 5: Simple bill

```dart
void main() {
  double price = 250.0;
  int quantity = 3;

  double total = price * quantity;

  print('Price: $price');
  print('Quantity: $quantity');
  print('Total: $total');
}
```

Output:

```
Price: 250.0
Quantity: 3
Total: 750.0
```

`total` is built from `price` and `quantity` using `*`. Because `price` is a `double`, the total is a `double` too, so it shows as `750.0`.

---

**Next:** `02d-VarFinalConst.md`, where you learn shortcuts for making boxes and how to make a box that can never change.
