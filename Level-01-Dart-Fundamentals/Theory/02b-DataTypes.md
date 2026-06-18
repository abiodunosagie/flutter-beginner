# Data Types: The Four Kinds Of Boxes

## The Big Idea In One Sentence

> Every value in Dart has a **type**, which is just the **kind of thing** it is: text, a whole number, a decimal number, or a yes/no.

In the last lesson you made text boxes (`String`). Now you meet the other three kinds of boxes.

---

## A Picture To Hold In Your Head

Think of types like **different jars in a kitchen**. A jar for sugar, a jar for rice, a jar for water. You would not pour water into the sugar jar. Each jar is made for one kind of thing.

In Dart there are four jars you will use all the time:

```
String   ->  text          'Ada'   'Hello'   'rice'
int      ->  whole number   42      0       -10
double   ->  decimal number 1.75    3.14    99.9
bool     ->  yes or no      true    false
```

Let us look at each one.

---

## 1. String: Text

A **String** holds text. Anything inside quotes is a String.

```dart
String name = 'Ada';
String city = 'Lagos';
String greeting = 'Good morning!';
```

You already know this one from the last lesson. "String" just means "a string of letters".

---

## 2. int: Whole Numbers

An **int** (short for "integer") holds **whole numbers**: numbers with no decimal point. Numbers do **not** use quotes.

```dart
int age = 25;
int year = 2026;
int score = 0;
int below = -10;     // negative whole numbers are fine
```

If it is a counting number, plus or minus, use `int`.

---

## 3. double: Decimal Numbers

A **double** holds numbers **with a decimal point**.

```dart
double price = 19.99;
double height = 1.75;
double half = 0.5;
```

The name "double" is just what Dart calls decimal numbers. If your number has a dot in it, it is a `double`.

---

## 4. bool: Yes Or No

A **bool** (short for "boolean") holds only **two** possible values: `true` or `false`. Nothing else. No quotes.

```dart
bool isRaining = true;
bool isHungry = false;
bool isLoggedIn = true;
```

Use a `bool` for anything that is a yes/no, on/off, done/not-done.

---

## Using All Four Together

Here is one person described with all four types:

```dart
void main() {
  String name = 'Ada';
  int age = 25;
  double height = 1.75;
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Height: $height meters');
  print('Student: $isStudent');
}
```

Output:

```
Name: Ada
Age: 25
Height: 1.75 meters
Student: true
```

Notice the `$` trick from the last lesson works for every type, not just text.

---

## The Box Only Holds Its Own Kind

When you make a box with a type, it can only ever hold that kind of value. This is Dart protecting you from mistakes.

```dart
int age = 25;
age = 30;        // GOOD: 30 is a whole number
age = 'thirty';  // BAD: 'thirty' is text, not a whole number
```

The second line is an error. Dart catches it immediately, before the program even runs, so you fix the mistake early instead of getting a surprise later.

The same goes the other way:

```dart
int price = 19.99;   // BAD: 19.99 is a decimal, not a whole number
double price = 19.99;// GOOD
```

---

## How To Pick The Right Type

Ask yourself what the value **is**:

- Is it words? Use **String**.
- Is it a counting number with no dot? Use **int**.
- Does it have a dot? Use **double**.
- Is it a yes/no? Use **bool**.

```dart
String petName = 'Rex';   // words
int legs = 4;             // counting number
double weight = 12.5;     // has a dot
bool hasTail = true;      // yes/no
```

---

## The Top Mistakes Beginners Make

### Mistake 1: A decimal in an int box

```dart
int temperature = 36.6;   // BAD: 36.6 has a dot
double temperature = 36.6;// GOOD
```

### Mistake 2: Quotes around a number you want to do maths with

```dart
int age = '25';   // BAD: '25' is text, not a number
int age = 25;     // GOOD
```

### Mistake 3: Quotes around true or false

```dart
bool isOpen = 'true';   // BAD: 'true' is text
bool isOpen = true;     // GOOD: true with no quotes
```

### Mistake 4: Using a number where you meant yes/no

```dart
bool isReady = 1;     // BAD: bool is only true or false, not 1
bool isReady = true;  // GOOD
```

---

## One-Minute Recap

- Every value has a **type**, the kind of thing it is.
- **String** = text (in quotes). **int** = whole number. **double** = decimal number. **bool** = `true`/`false`.
- Numbers and bools do **not** use quotes.
- A box can only hold its own kind of value. Dart catches the mistake right away.
- Pick the type by asking what the value is: words, whole number, decimal, or yes/no.

---

## Quick Quiz

**Q1.** What type for someone's name?

<details>
<summary>Answer</summary>
`String`, because a name is text.
</details>

**Q2.** What type for the number of students in a class?

<details>
<summary>Answer</summary>
`int`, because it is a whole counting number.
</details>

**Q3.** What type for the price 4.99?

<details>
<summary>Answer</summary>
`double`, because it has a decimal point.
</details>

**Q4.** What is wrong here?

```dart
int price = 19.99;
```

<details>
<summary>Answer</summary>
`19.99` is a decimal, but `int` only holds whole numbers. Use `double price = 19.99;`.
</details>

**Q5.** What is wrong here?

```dart
bool isDone = 'false';
```

<details>
<summary>Answer</summary>
`'false'` is text (it has quotes). A `bool` needs `true` or `false` with no quotes: `bool isDone = false;`.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Pick the right type

For each value, write the correct type (`String`, `int`, `double`, or `bool`):

1. `42`
2. `3.14`
3. `'Hello'`
4. `true`
5. `-100`
6. `0.0`
7. `'42'`
8. `false`

### Problem 2: Predict the output

```dart
void main() {
  String name = 'Bola';
  int age = 12;
  double shoe = 7.5;
  bool likesPizza = true;

  print('$name is $age');
  print('Shoe size $shoe, likes pizza: $likesPizza');
}
```

### Problem 3: Spot the bugs

Each line has a type problem. Fix each one.

```dart
int score = 85.5;
double price = '19.99';
bool isReady = 1;
int age = '25';
```

### Problem 4: Build a pet profile

Make four variables for a pet: a `String` name, an `int` number of legs, a `double` weight, and a `bool` for whether it has a tail. Then print one sentence per fact using `$`.

### Problem 5: Choose types for an app

For a simple game, write the type you would use for each, and one word saying why:

1. The player's username.
2. The player's score.
3. The player's health bar level like 87.5.
4. Whether the game is paused.

---

## Assignment Answers

### Problem 1: Pick the right type

| Value | Type | Why |
|-------|------|-----|
| `42` | int | whole number |
| `3.14` | double | has a decimal point |
| `'Hello'` | String | text in quotes |
| `true` | bool | a yes/no value |
| `-100` | int | whole number, negative is fine |
| `0.0` | double | the `.0` makes it a decimal |
| `'42'` | String | the quotes make it text, even though it looks like a number |
| `false` | bool | a yes/no value |

The tricky one is `'42'`. It looks like a number, but the quotes make it a String.

### Problem 2: Predict the output

```
Bola is 12
Shoe size 7.5, likes pizza: true
```

Every type drops into the sentence with `$`. The `double` shows its decimal (`7.5`) and the `bool` shows the word `true`.

### Problem 3: Spot the bugs

```dart
double score = 85.5;     // 85.5 has a dot, so use double
double price = 19.99;    // remove the quotes, 19.99 is a number not text
bool isReady = true;     // bool needs true/false, not 1
int age = 25;            // remove the quotes, 25 is a whole number
```

These are the four most common type mix-ups: a decimal in an int box, a number wrapped in quotes, a number used as a yes/no, and a number written as text.

### Problem 4: Build a pet profile

```dart
void main() {
  String name = 'Rex';
  int legs = 4;
  double weight = 12.5;
  bool hasTail = true;

  print('Name: $name');
  print('Legs: $legs');
  print('Weight: $weight kg');
  print('Has a tail: $hasTail');
}
```

Output:

```
Name: Rex
Legs: 4
Weight: 12.5 kg
Has a tail: true
```

Each fact used the type that matches what it is: text, whole number, decimal, yes/no.

### Problem 5: Choose types for an app

| Data | Type | Why |
|------|------|-----|
| Username | String | text |
| Score | int | whole number |
| Health like 87.5 | double | has a decimal |
| Game paused | bool | yes/no |

---

**Next:** `02c-UsingVariables.md`, where you start doing things with your variables.
