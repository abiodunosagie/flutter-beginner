# Variables: How A Program Remembers Things

## The Big Idea In One Sentence

> A variable is a **labeled box** that holds a value so your program can remember it and use it later.

That is the whole idea. Let us see it in action.

---

## A Picture To Hold In Your Head

Think of a variable like a **box with a label on the front**:

```
┌──────────────┐
│    'Ada'     │   <- the value inside the box
├──────────────┤
│     name     │   <- the label on the box (the variable name)
└──────────────┘
```

You put something in the box and write a label on it. Later, when you say the label out loud (`name`), the program hands you what is inside (`'Ada'`).

You already use this idea every day:

- A **name tag** holds your name.
- A **contact** in your phone holds a number.
- A **jar labeled "sugar"** holds sugar.

A variable is the same: a label, and a value inside.

---

## Making Your First Variable

In Dart, you make a variable like this:

```dart
String name = 'Ada';
```

Read it left to right:

- **`String`** says what kind of value goes in the box. `String` means **text**. (The word "string" just means "a string of letters".)
- **`name`** is the label you chose for the box.
- **`=`** means **"put this value into the box."** It does not mean "equals" like in maths. It means "store this here."
- **`'Ada'`** is the value going in. Text always sits inside quotes.
- **`;`** ends the step.

So this line says: *"Make a text box called name, and put Ada inside it."*

---

## Using The Variable

Once the box has a value, you can use the label anywhere you want the value:

```dart
void main() {
  String name = 'Ada';
  print(name);
}
```

Output:

```
Ada
```

Notice we wrote `print(name)`, not `print('name')`.

- `print(name)` with **no quotes** shows what is **inside the box**: `Ada`.
- `print('name')` **with quotes** shows the plain word: `name`.

This is a very common mix-up. Quotes mean "use these exact letters." No quotes means "use the value in the box."

---

## Putting A Variable Inside A Sentence

Most of the time you want a variable inside a longer sentence, like "Hello, Ada!". Dart has a neat way to do this. Inside a text string, put a `$` in front of the variable name:

```dart
void main() {
  String name = 'Ada';
  print('Hello, $name!');
}
```

Output:

```
Hello, Ada!
```

The `$name` part gets swapped out for the value in the box. Everything else in the quotes stays exactly as written. This swapping trick is called **string interpolation**. Fancy name, simple idea: *drop the value of a variable into a sentence with `$`.*

If you forget the `$`, you get the plain word instead:

```dart
void main() {
  String name = 'Ada';
  print('Hello, name!');    // shows: Hello, name!
}
```

---

## Changing What Is In The Box

It is called a *variable* because the value can **vary** (change). You can put a new value in the box later. When you change it, you do **not** write the type again:

```dart
void main() {
  String mood = 'happy';
  print('I feel $mood');     // I feel happy

  mood = 'excited';          // put a new value in the same box (no String here)
  print('I feel $mood');     // I feel excited
}
```

Output:

```
I feel happy
I feel excited
```

The box now holds `'excited'`. The old value `'happy'` is gone. A box only holds one thing at a time.

---

## Naming Your Variables

A few simple rules for labels:

- Start with a **lowercase letter**: `name`, `city`, `favoriteColor`.
- **No spaces.** If the name has two words, stick them together and capitalize the second word: `firstName`, `favoriteFood`. This style is called **camelCase** (the humps look like a camel).
- **No starting with a number.** `name1` is fine, `1name` is not.
- Pick names that **say what is inside**. `city` is good. `x` tells you nothing.

```dart
String firstName = 'Ada';     // good: clear, lowercase, camelCase
String favoriteFood = 'rice'; // good
```

---

## The Top Mistakes Beginners Make

### Mistake 1: Quotes around the variable name when you want the value

```dart
String name = 'Ada';
print('name');     // BAD: shows the word "name"
print(name);       // GOOD: shows Ada
```

### Mistake 2: Forgetting the `$` inside a sentence

```dart
String name = 'Ada';
print('Hi name');    // BAD: shows "Hi name"
print('Hi $name');   // GOOD: shows "Hi Ada"
```

### Mistake 3: Writing the type again when changing the value

```dart
String mood = 'happy';
String mood = 'sad';   // BAD: you cannot make the box "mood" twice
mood = 'sad';          // GOOD: just put a new value in the existing box
```

### Mistake 4: Starting a name with a capital or a number

```dart
String City = 'Lagos';   // works, but bad style: start variables lowercase
String 1stName = 'Ada';  // BAD: cannot start with a number
String firstName = 'Ada';// GOOD
```

---

## One-Minute Recap

- A variable is a labeled box that holds a value.
- `String name = 'Ada';` makes a text box called `name` holding `Ada`.
- `=` means "put this value in the box," not "equals."
- Use the label with **no quotes** to get the value: `print(name)`.
- Drop a variable into a sentence with `$`: `print('Hi $name')`.
- Change a value by assigning again, **without** the type: `name = 'Bola';`.
- Name variables in lowercase camelCase, and make the name describe the value.

---

## Quick Quiz

**Q1.** What does this show?

```dart
void main() {
  String city = 'Lagos';
  print(city);
}
```

<details>
<summary>Answer</summary>

```
Lagos
```

`city` with no quotes shows the value inside the box.
</details>

**Q2.** What does this show?

```dart
void main() {
  String city = 'Lagos';
  print('city');
}
```

<details>
<summary>Answer</summary>

```
city
```

With quotes, it shows the plain word, not the value.
</details>

**Q3.** What does this show?

```dart
void main() {
  String pet = 'cat';
  print('I have a $pet');
}
```

<details>
<summary>Answer</summary>

```
I have a cat
```

`$pet` is swapped for the value `cat`.
</details>

**Q4.** Why is the second line wrong?

```dart
String color = 'blue';
String color = 'green';
```

<details>
<summary>Answer</summary>
You are trying to make a box called `color` twice. To change it, just write `color = 'green';` without `String`.
</details>

---

## Assignment

Try each one in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Make and show a variable

Make a `String` variable called `name` holding your own name. Then print `My name is ` followed by the name, using `$`.

### Problem 2: Predict the output

```dart
void main() {
  String drink = 'water';
  print('I like $drink');
  print('drink');
}
```

What are the two lines it shows?

### Problem 3: Change the value

Make a `String` variable `weather` holding `'sunny'` and print `Today is sunny`. Then change `weather` to `'rainy'` and print `Now it is rainy`. Use `$` both times.

### Problem 4: Spot the bugs

Two of these lines are wrong. Find them and fix them.

```dart
String 2ndName = 'Bola';
String food = 'rice';
print('I eat food');
```

### Problem 5: Build a tiny intro

Make three `String` variables: `name`, `city`, and `hobby`. Then print one sentence that uses all three, like: `Ada lives in Lagos and loves drawing.`

---

## Assignment Answers

### Problem 1: Make and show a variable

```dart
void main() {
  String name = 'Ada';
  print('My name is $name');
}
```

Output:

```
My name is Ada
```

The `$name` drops the value of the box into the sentence.

### Problem 2: Predict the output

```
I like water
drink
```

First line: `$drink` becomes `water`. Second line: `'drink'` is in quotes, so it shows the plain word `drink`, not the value.

### Problem 3: Change the value

```dart
void main() {
  String weather = 'sunny';
  print('Today is $weather');

  weather = 'rainy';
  print('Now it is $weather');
}
```

Output:

```
Today is sunny
Now it is rainy
```

Notice the second `weather =` does not repeat `String`. The box already exists, we just put a new value in it.

### Problem 4: Spot the bugs

The two problems:

1. `2ndName` starts with a number, which is not allowed.
2. `'I eat food'` shows the plain word `food`. To show the value, it needs `$food`.

Fixed:

```dart
String secondName = 'Bola';    // does not start with a number
String food = 'rice';
print('I eat $food');          // added the $
```

Output:

```
I eat rice
```

### Problem 5: Build a tiny intro

```dart
void main() {
  String name = 'Ada';
  String city = 'Lagos';
  String hobby = 'drawing';

  print('$name lives in $city and loves $hobby.');
}
```

Output:

```
Ada lives in Lagos and loves drawing.
```

You can put as many `$variable` drops in one sentence as you like. Each one is swapped for the value in its box.

---

**Next:** `02b-DataTypes.md`, where you learn the other kinds of boxes: numbers and true/false values.
