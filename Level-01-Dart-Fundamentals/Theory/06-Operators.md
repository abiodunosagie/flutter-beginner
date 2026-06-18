# Operators: All The Signs In One Place

## The Big Idea In One Sentence

> An operator is a **sign that does something** with values: `+` adds, `==` compares, `&&` combines yes/no answers, and so on.

You have met many of these already. This lesson gathers them in one place and adds a few new ones.

---

## Arithmetic: Doing Maths

Six signs do maths. You saw these in the Numbers lesson:

| Sign | Does | Example | Answer |
|------|------|---------|--------|
| `+` | add | `7 + 3` | 10 |
| `-` | subtract | `7 - 3` | 4 |
| `*` | multiply | `7 * 3` | 21 |
| `/` | divide (gives a decimal) | `7 / 2` | 3.5 |
| `~/` | divide, keep the whole part | `7 ~/ 2` | 3 |
| `%` | remainder (leftover) | `7 % 2` | 1 |

```dart
void main() {
  print(7 + 3);    // 10
  print(7 / 2);    // 3.5
  print(7 ~/ 2);   // 3
  print(7 % 2);    // 1
}
```

---

## Shortcut Maths: Compound Assignment

Often you want to change a box using its own value, like adding to a score. Instead of writing the box name twice, use a shortcut sign:

```dart
void main() {
  int x = 10;

  x += 5;   // shortcut for x = x + 5  ->  15
  x -= 2;   // shortcut for x = x - 2  ->  13
  x *= 2;   // shortcut for x = x * 2  ->  26

  print(x);   // 26
}
```

`x += 5` means exactly the same as `x = x + 5`. It is just shorter. There is one for each maths sign: `+=`, `-=`, `*=`, `~/=`, `%=`.

---

## Adding Or Subtracting One: `++` and `--`

Adding 1 is so common it has its own sign: `++`. Subtracting 1 is `--`.

```dart
void main() {
  int count = 0;

  count++;   // add 1  -> 1
  count++;   // add 1  -> 2
  count--;   // take 1 -> 1

  print(count);   // 1
}
```

`count++` is just a shorter way of writing `count = count + 1`.

---

## Comparing: Asking Yes/No Questions

These signs compare two values and give back a `bool` (`true` or `false`). You saw them in the Booleans lesson:

| Sign | Means | Example | Answer |
|------|-------|---------|--------|
| `==` | equal to | `5 == 5` | true |
| `!=` | not equal to | `5 != 3` | true |
| `>` | greater than | `5 > 3` | true |
| `<` | less than | `5 < 3` | false |
| `>=` | greater or equal | `5 >= 5` | true |
| `<=` | less or equal | `5 <= 3` | false |

> Remember: `==` (two equals) **asks a question**, `=` (one equals) **stores a value**. This mix-up is the number one beginner bug.

---

## Combining Yes/No: `&&`, `||`, `!`

Also from the Booleans lesson:

```dart
void main() {
  bool a = true;
  bool b = false;

  print(a && b);   // false  (AND: both must be true)
  print(a || b);   // true   (OR: at least one true)
  print(!a);       // false  (NOT: flip it)
}
```

---

## Joining Text: `+`

The `+` sign also joins strings (you saw this in the Strings lesson):

```dart
void main() {
  String first = 'Hello';
  String second = 'World';
  print(first + ' ' + second);   // Hello World
}
```

Most of the time the `$` way is cleaner: `'$first $second'`.

---

## Choosing Between Two Values: The `?` Sign (Ternary)

Here is a new one. Sometimes you want to pick one of two values based on a yes/no question. The `? :` sign does this in a single line:

```
condition ? valueIfTrue : valueIfFalse
```

Read it as: "Is the condition true? If yes, use the first value. If no, use the second."

```dart
void main() {
  int age = 20;
  String label = age >= 18 ? 'Adult' : 'Child';
  print(label);   // Adult
}
```

Here `age >= 18` is true, so it picks `'Adult'`. If age were 10, it would pick `'Child'`.

> This is a quick shortcut for choosing. The fuller way to make decisions, `if` and `else`, is the whole of Level 2. For now, the `? :` sign is a handy way to pick between two values.

---

## The Order Operators Run In

When several signs appear together, Dart follows an order, just like maths class. Multiply and divide happen **before** add and subtract:

```dart
void main() {
  print(2 + 3 * 4);     // 14, not 20  (3*4 first, then +2)
  print((2 + 3) * 4);   // 20          (brackets first)
}
```

The safe rule: **when in doubt, use brackets `( )`.** They cost nothing and make your meaning clear.

---

## The Top Mistakes Beginners Make

### Mistake 1: `=` when you mean `==`

```dart
int x = 5;
print(x == 5);   // GOOD: asks "is x equal to 5?" -> true
```

`=` stores. `==` compares.

### Mistake 2: Forgetting maths order

```dart
print(2 + 3 * 4);     // 14 (not 20). Multiply runs before add.
print((2 + 3) * 4);   // 20. Use brackets to force the order you want.
```

### Mistake 3: Expecting `/` to give a whole number

```dart
print(10 / 2);    // 5.0  (a decimal, because / always gives a double)
print(10 ~/ 2);   // 5    (use ~/ for a whole number)
```

### Mistake 4: Reading the ternary backwards

```dart
// condition ? value-if-TRUE : value-if-FALSE
int n = 4;
print(n > 0 ? 'positive' : 'not positive');   // positive
```

The value before the `:` is for **true**, the one after is for **false**.

---

## One-Minute Recap

- Maths signs: `+ - * /` and the two number-sharers `~/` and `%`.
- Shortcuts: `+=`, `-=`, `*=` change a box using its own value. `++` adds 1, `--` subtracts 1.
- Compare with `== != > < >= <=` (they give a bool). `==` compares, `=` stores.
- Combine yes/no with `&&` (AND), `||` (OR), `!` (NOT).
- `+` joins text too.
- `condition ? a : b` picks `a` if true, `b` if false.
- Multiply/divide run before add/subtract. Use brackets when unsure.

---

## Quick Quiz

**Q1.** What does `2 + 3 * 4` give?

<details>
<summary>Answer</summary>
`14`. Multiplication runs first (`3 * 4 = 12`), then `2 + 12 = 14`.
</details>

**Q2.** What does `x += 5` mean if `x` is 10?

<details>
<summary>Answer</summary>
It adds 5 to `x`, making it 15. It is short for `x = x + 5`.
</details>

**Q3.** What does `5 > 3 ? 'yes' : 'no'` give?

<details>
<summary>Answer</summary>
`'yes'`, because `5 > 3` is true, so it picks the value before the `:`.
</details>

**Q4.** What is the difference between `=` and `==`?

<details>
<summary>Answer</summary>
`=` stores a value in a box. `==` checks if two values are equal.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
void main() {
  int a = 9;
  int b = 4;

  print(a + b);
  print(a / b);
  print(a ~/ b);
  print(a % b);
  print(a > b);
  print(a == b);
}
```

### Problem 2: Use the shortcuts

Start with `int x = 6`. Using only the shortcut signs (`+=`, `*=`, `++`), make `x` become 20, then print it. (Hint: one possible path is add 4, then multiply by 2, then add 1, then add 1.)

### Problem 3: Order of operations

Without running, what does each line print? Explain the order.

```dart
void main() {
  print(2 + 6 / 2);
  print((2 + 6) / 2);
  print(10 - 2 * 3);
}
```

### Problem 4: Ternary choice

Make `int temperature = 30`. Use the `? :` sign to print `'hot'` if the temperature is above 25, otherwise `'cool'`.

### Problem 5: Combine it all

Make `int score = 80` and `bool didHomework = true`. Make a bool `passes` that is true if the score is at least 50 **and** they did the homework. Then use a ternary to print `'PASS'` or `'FAIL'` based on `passes`.

---

## Assignment Answers

### Problem 1: Predict the output

```
13
2.25
2
1
true
false
```

- `9 + 4 = 13`.
- `9 / 4 = 2.25` (divide always gives a decimal).
- `9 ~/ 4 = 2` (the whole part).
- `9 % 4 = 1` (leftover).
- `9 > 4` is `true`.
- `9 == 4` is `false`.

### Problem 2: Use the shortcuts

```dart
void main() {
  int x = 6;

  x += 4;   // 10
  x *= 2;   // 20
  print(x); // 20
}
```

Or, following the longer hint path:

```dart
void main() {
  int x = 6;
  x += 4;   // 10
  x *= 2;   // 20
  print(x); // 20
}
```

Either way you reach 20. The shortcut signs change `x` using its own current value.

### Problem 3: Order of operations

```
5.0
4.0
4
```

- `2 + 6 / 2`: divide first (`6 / 2 = 3.0`), then `2 + 3.0 = 5.0`. (It is a decimal because `/` gives a double.)
- `(2 + 6) / 2`: brackets first (`2 + 6 = 8`), then `8 / 2 = 4.0`.
- `10 - 2 * 3`: multiply first (`2 * 3 = 6`), then `10 - 6 = 4`.

Multiply and divide always run before add and subtract, unless brackets say otherwise.

### Problem 4: Ternary choice

```dart
void main() {
  int temperature = 30;
  print(temperature > 25 ? 'hot' : 'cool');   // hot
}
```

`temperature > 25` is true (30 is above 25), so the ternary picks the value before the `:`, which is `'hot'`.

### Problem 5: Combine it all

```dart
void main() {
  int score = 80;
  bool didHomework = true;

  bool passes = score >= 50 && didHomework;
  print(passes ? 'PASS' : 'FAIL');   // PASS
}
```

`score >= 50` is true and `didHomework` is true, so `passes` is `true`. The ternary then prints `'PASS'`.

---

**Next:** `07-NullSafety.md`, where you learn about "nothing" (null) and how Dart keeps your program safe from it.
