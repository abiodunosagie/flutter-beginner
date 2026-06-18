# Numbers: Doing Maths In Dart

## The Big Idea In One Sentence

> Dart has two kinds of numbers, **int** (whole) and **double** (decimal), and a small set of tools to add, divide, round, and tidy them up.

You met `int` and `double` earlier. Now you put them to work.

---

## The Two Number Types (Quick Recap)

```dart
int age = 12;        // whole number, no dot
double price = 4.99; // has a decimal dot
```

- Whole number, no dot? Use **int**.
- Has a dot? Use **double**.

---

## Adding, Subtracting, Multiplying

You already know these three:

```dart
void main() {
  print(6 + 4);   // 10
  print(6 - 4);   // 2
  print(6 * 4);   // 24
}
```

Nothing new here. Now meet three number tools that are easy to mix up.

---

## Dividing: `/`, `~/`, and `%`

Imagine you have **17 sweets** to share among **5 children**. There are three different questions you might ask.

### `/` gives the exact answer (always a decimal)

```dart
print(17 / 5);   // 3.4
```

Regular divide `/` always gives a **double** (a decimal), even when it comes out even:

```dart
print(10 / 2);   // 5.0   (note the .0, it is a double)
```

### `~/` gives the whole answer (how many each child gets)

```dart
print(17 ~/ 5);   // 3   (each child gets 3 whole sweets)
```

`~/` means "divide and throw away the leftover." It gives a whole number (an `int`).

### `%` gives the leftover (the remainder)

```dart
print(17 % 5);   // 2   (after giving 3 each, 2 sweets are left over)
```

`%` is called **modulo**. It tells you what is left after sharing evenly.

Put together: 5 children, 3 sweets each is 15 sweets, and 2 left over. That is exactly `17 ~/ 5` (3) and `17 % 5` (2).

---

## A Handy Trick: Even Or Odd

A number is **even** if dividing by 2 leaves no remainder. Dart gives you ready-made tools that answer yes/no (a `bool`):

```dart
void main() {
  print(10.isEven);   // true
  print(10.isOdd);    // false
  print(7.isEven);    // false
  print(7.isOdd);     // true
}
```

Behind the scenes, `isEven` just checks if `number % 2 == 0`. But `.isEven` reads nicely, so use it.

---

## Rounding Decimals

When you have a decimal, sometimes you want a whole number. Three tools:

```dart
void main() {
  double n = 3.7;

  print(n.round());   // 4   (to the nearest whole number)
  print(n.floor());   // 3   (down to the floor, always lower)
  print(n.ceil());    // 4   (up to the ceiling, always higher)
}
```

Easy way to remember: **floor** is the ground (down), **ceil** is the ceiling (up), **round** goes to whichever is nearest.

---

## The Absolute Value: `.abs()`

`.abs()` removes a minus sign. It gives the "size" of a number, ignoring negative:

```dart
print((-8).abs());   // 8
print((8).abs());    // 8
```

---

## Showing Money Nicely: `.toStringAsFixed()`

Decimals can look messy. `toStringAsFixed(2)` gives you text with exactly 2 decimal places, perfect for prices:

```dart
void main() {
  double price = 19.5;
  print(price.toStringAsFixed(2));   // 19.50
}
```

It hands back a **String**, so it is for showing, not for more maths.

---

## Changing Between Number Types

Sometimes a number is the wrong type and you need to switch it:

```dart
void main() {
  int whole = 5;
  double asDecimal = whole.toDouble();   // 5.0

  double dec = 3.9;
  int asWhole = dec.toInt();             // 3  (just cuts off the dot part)

  int age = 25;
  String ageText = age.toString();       // '25'  (now it is text)
}
```

And if you have a number written as **text** and want a real number, use `int.parse` or `double.parse`:

```dart
void main() {
  String text = '42';
  int number = int.parse(text);
  print(number + 8);   // 50
}
```

Without `int.parse`, `'42'` is just text and you could not add to it.

---

## The Top Mistakes Beginners Make

### Mistake 1: Expecting `/` to give a whole number

```dart
int half = 10 / 2;     // BAD: / gives a double (5.0), not an int
double half = 10 / 2;  // GOOD
int half = 10 ~/ 2;    // GOOD if you want the whole number 5
```

### Mistake 2: Mixing up `~/` and `%`

```dart
print(17 ~/ 5);   // 3  -> how many times 5 fits
print(17 % 5);    // 2  -> what is left over
```

### Mistake 3: Thinking a method changes the number

```dart
double n = 3.7;
n.round();      // result thrown away, n is still 3.7
print(n);       // 3.7
int r = n.round();  // GOOD: store the result
```

### Mistake 4: Doing maths on a number that is really text

```dart
String age = '25';
print(age + 5);          // BAD: age is text, not a number
print(int.parse(age) + 5); // GOOD: turn it into a number first
```

---

## One-Minute Recap

- `int` is whole, `double` is decimal.
- `+ - *` work as expected.
- `/` always gives a decimal (double). `~/` gives the whole part. `%` gives the leftover.
- `.isEven` / `.isOdd` answer yes/no.
- `.round()`, `.floor()`, `.ceil()` turn a decimal into a whole number.
- `.abs()` drops the minus sign.
- `.toStringAsFixed(2)` shows a number with 2 decimals (as text).
- `.toDouble()`, `.toInt()`, `.toString()`, and `int.parse(...)` switch between types.

---

## Quick Quiz

**Q1.** What does `10 / 4` give?

<details>
<summary>Answer</summary>
`2.5`. Regular divide `/` always gives a decimal (double).
</details>

**Q2.** What do `17 ~/ 5` and `17 % 5` give?

<details>
<summary>Answer</summary>
`17 ~/ 5` is `3` (the whole part). `17 % 5` is `2` (the leftover).
</details>

**Q3.** What does `3.2.ceil()` give?

<details>
<summary>Answer</summary>
`4`. `ceil` always rounds up to the ceiling.
</details>

**Q4.** What is wrong with `int x = 9 / 3;`?

<details>
<summary>Answer</summary>
`/` gives a double (`3.0`), not an int. Use `double x = 9 / 3;` or `int x = 9 ~/ 3;`.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
void main() {
  print(20 + 7);
  print(20 - 7);
  print(20 * 7);
  print(20 / 8);
  print(20 ~/ 8);
  print(20 % 8);
}
```

### Problem 2: Share the sweets

You have 23 sweets and 4 children. Print how many whole sweets each child gets, and how many are left over. Use `~/` and `%`.

### Problem 3: Round it

Make a `double total = 8.6`. Print its `round`, its `floor`, and its `ceil`, each on its own line.

### Problem 4: Show a price

Make a `double price = 7.5`. Print it as money with two decimals, like `Price: 7.50`. Use `.toStringAsFixed(2)` inside the sentence.

### Problem 5: Even or odd

Print whether 12 is even, and whether 5 is odd, using `.isEven` and `.isOdd`.

---

## Assignment Answers

### Problem 1: Predict the output

```
27
13
140
2.5
2
4
```

- `20 + 7 = 27`, `20 - 7 = 13`, `20 * 7 = 140`.
- `20 / 8 = 2.5` (regular divide gives a decimal).
- `20 ~/ 8 = 2` (the whole part: 8 fits into 20 twice).
- `20 % 8 = 4` (leftover: 2 times 8 is 16, and 20 - 16 = 4).

### Problem 2: Share the sweets

```dart
void main() {
  int sweets = 23;
  int children = 4;

  print('Each child gets ${sweets ~/ children}');
  print('Sweets left over: ${sweets % children}');
}
```

Output:

```
Each child gets 5
Sweets left over: 3
```

5 sweets each is 20, and 3 are left over. `~/` gives the whole share, `%` gives the leftover.

### Problem 3: Round it

```dart
void main() {
  double total = 8.6;
  print(total.round());   // 9
  print(total.floor());   // 8
  print(total.ceil());    // 9
}
```

`round` goes to the nearest (9), `floor` goes down (8), `ceil` goes up (9).

### Problem 4: Show a price

```dart
void main() {
  double price = 7.5;
  print('Price: ${price.toStringAsFixed(2)}');
}
```

Output:

```
Price: 7.50
```

`toStringAsFixed(2)` keeps exactly two decimals, so `7.5` shows as `7.50`.

### Problem 5: Even or odd

```dart
void main() {
  print(12.isEven);   // true
  print(5.isOdd);     // true
}
```

Output:

```
true
true
```

`isEven` and `isOdd` each give back a `bool` (true or false).

---

**Next:** `05-Booleans.md`, where you learn about true/false values and how to ask questions in code.
