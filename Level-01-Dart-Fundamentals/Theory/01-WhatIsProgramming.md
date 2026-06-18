# What Is Programming? Telling A Computer Exactly What To Do

## The Big Idea In One Sentence

> Programming is **giving a computer a list of small, clear steps to follow**, one after another.

That is the whole idea. Everything else in this lesson just shows you how to write those steps.

---

## A Picture To Hold In Your Head

Imagine you have a **robot friend**. This robot is super fast and never gets tired. But it has one funny rule:

> It only does **exactly** what you say. Not what you mean. What you say.

So if you tell your robot, "make breakfast," it just stares at you. It does not know what that means. You have to break it into tiny steps it can follow:

1. Walk to the kitchen.
2. Open the fridge.
3. Take out two eggs.
4. Close the fridge.

That list of tiny steps is a **program**. You are the boss. The computer is the robot. Programming is writing the steps.

---

## Computers Are Very, Very Literal

A person has common sense. A computer does not. Watch the difference:

```
You tell a friend: "Get me a cup of water."
Your friend: walks to the kitchen, finds a cup, fills it, brings it back. Easy.

You tell a computer: "Get me a cup of water."
The computer: "What is a cup? Where is the kitchen? What is water? I do not understand."
```

This is not the computer being silly. It just needs every step spelled out. Once you give it clear steps, it follows them perfectly, every time, faster than you can blink.

So the skill you are learning is simple to say: **break a big job into small, clear steps.**

---

## What Is A Programming Language?

You speak English. The computer speaks in 1s and 0s. A **programming language** sits in the middle and lets you write steps in a way the computer can understand.

```
What you want          What you write           What the computer does
"Show a hello"    →    print('Hello!')     →    shows  Hello!  on the screen
```

The language we use in this course is called **Dart**. We use Dart because it powers **Flutter**, the tool that builds real phone apps. Learn Dart first, build apps later.

---

## Your First Program

Here is the most famous tiny program in the world. It just shows the words "Hello, World!".

```dart
void main() {
  print('Hello, World!');
}
```

Three lines. That is a real program. Let us read it slowly.

---

## Reading It Word By Word

Do not worry about memorizing this. Just get the feel.

```dart
void main() {
  print('Hello, World!');
}
```

- **`main`** is the **starting point**. Every Dart program begins here. Think of `main` as the front door: the computer always walks in through this door first.
- **`{` and `}`** are a **box**. Everything inside the box is the list of steps for `main` to do.
- **`print(...)`** is a ready-made helper that **shows something on the screen**.
- **`'Hello, World!'`** is the **text** we want to show. Text always goes inside quotes `' '`.
- **`;`** (a semicolon) means **"this step is finished."** It is like the full stop at the end of a sentence.

So in plain English, this program says: *"Start here. Show the words Hello, World! on the screen. Done."*

---

## How To Run It (Free, No Setup)

1. Open your web browser.
2. Go to **[dartpad.dev](https://dartpad.dev)**.
3. Delete whatever code is there.
4. Type the Hello World program from above.
5. Click **Run**.
6. Look at the box on the right. You will see `Hello, World!`.

That is it. You just ran a program. Do this now before reading on. Seeing it work makes everything click.

---

## Playing Around

Change the program and run it again. Playing is how you learn.

**Show your own name:**

```dart
void main() {
  print('My name is Ada');
}
```

**Show three lines:**

```dart
void main() {
  print('Line one');
  print('Line two');
  print('Line three');
}
```

Output:

```
Line one
Line two
Line three
```

Each `print` puts its text on a **new line**.

**Show numbers (no quotes needed for numbers):**

```dart
void main() {
  print(42);
  print(7);
}
```

Output:

```
42
7
```

Quotes are for text. Numbers do not need them.

---

## Comments: Notes For You, Ignored By The Computer

Sometimes you want to leave yourself a note inside the code. That is a **comment**. The computer skips it completely.

```dart
void main() {
  // This is a note for me. The computer ignores it.
  print('Hello!');   // you can also leave a note at the end of a line
}
```

Anything after `//` is a note. Use comments to remind yourself what something does.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting the semicolon

```dart
void main() {
  print('Hello')     // BAD: no semicolon, the computer complains
}
```

Fix: put a `;` at the end.

```dart
void main() {
  print('Hello');    // GOOD
}
```

### Mistake 2: Forgetting the quotes around text

```dart
void main() {
  print(Hello);      // BAD: without quotes, the computer thinks Hello is a thing it should already know
}
```

Fix: wrap text in quotes.

```dart
void main() {
  print('Hello');    // GOOD
}
```

### Mistake 3: A box that does not close

Every `{` needs a matching `}`. Every `(` needs a matching `)`. They come in pairs.

```dart
void main() {
  print('Hello');
                     // BAD: the main box was never closed with }
```

```dart
void main() {
  print('Hello');
}                    // GOOD: box is closed
```

### Mistake 4: Wrong capital letters

Dart cares about capital letters. `print` works. `Print` does not.

```dart
Print('Hello');      // BAD
print('Hello');      // GOOD
```

---

## One-Minute Recap

- Programming is giving a computer small, clear steps in order.
- A computer is very literal: it does exactly what you say.
- We write steps in a language called **Dart**.
- Every program starts at **`main`**.
- **`print('...')`** shows text on the screen. Text goes in quotes.
- End every step with a **semicolon** `;`.
- **Comments** (`//`) are notes for you that the computer ignores.

---

## Quick Quiz

**Q1.** Where does every Dart program start?

<details>
<summary>Answer</summary>
At `main`. It is the front door. The computer always begins there.
</details>

**Q2.** What does this show on the screen?

```dart
void main() {
  print('One');
  print('Two');
}
```

<details>
<summary>Answer</summary>

```
One
Two
```

Each `print` goes on its own new line.
</details>

**Q3.** What is wrong here?

```dart
void main() {
  print('Hello')
}
```

<details>
<summary>Answer</summary>
The semicolon is missing. It should be `print('Hello');`.
</details>

**Q4.** Why do we use comments?

<details>
<summary>Answer</summary>
To leave notes for ourselves (and other people) explaining what the code does. The computer ignores them.
</details>

---

## Assignment

Try these yourself in [dartpad.dev](https://dartpad.dev) before peeking at the answers.

### Problem 1: Say hello to yourself

Write a program that shows one line: `Hello, my name is ` followed by your own name.

### Problem 2: A tiny poem

Write a program that shows these three lines, each on its own line:

```
Roses are red
Code is fun
I am learning Dart
```

### Problem 3: Predict the output

Without running it, what does this show?

```dart
void main() {
  print('Top');
  print(100);
  print('Bottom');
}
```

### Problem 4: Spot the bugs

This program has two mistakes. Find them and fix them.

```dart
void main() {
  print('Good morning')
  print(Sunshine);
}
```

### Problem 5: Add a comment

Take your answer from Problem 1 and add a comment above the `print` line that says what the line does. Make sure the program still runs.

---

## Assignment Answers

### Problem 1: Say hello to yourself

```dart
void main() {
  print('Hello, my name is Ada');
}
```

Output:

```
Hello, my name is Ada
```

You just put your own name inside the quotes. The text inside quotes is shown exactly as you write it.

### Problem 2: A tiny poem

```dart
void main() {
  print('Roses are red');
  print('Code is fun');
  print('I am learning Dart');
}
```

Output:

```
Roses are red
Code is fun
I am learning Dart
```

Three steps, three `print` lines, each ending with a semicolon. Each one shows up on its own line.

### Problem 3: Predict the output

Output:

```
Top
100
Bottom
```

The program runs top to bottom. `'Top'` is text in quotes. `100` is a number, so it needs no quotes. `'Bottom'` is text again. Each `print` is on its own line.

### Problem 4: Spot the bugs

The two mistakes:

1. The first `print` is missing a semicolon.
2. `Sunshine` has no quotes, so the computer does not know what it is.

Fixed:

```dart
void main() {
  print('Good morning');   // added the semicolon
  print('Sunshine');       // added the quotes
}
```

Output:

```
Good morning
Sunshine
```

### Problem 5: Add a comment

```dart
void main() {
  // Show a friendly greeting with my name
  print('Hello, my name is Ada');
}
```

The line starting with `//` is a note for you. The computer skips it, so the program still runs and shows:

```
Hello, my name is Ada
```

---

**Next:** `02-VariablesAndTypes.md`, where you learn how to store information so your program can remember it.
