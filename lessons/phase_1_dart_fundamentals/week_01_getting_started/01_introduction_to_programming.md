# Day 1-2: Introduction to Programming and Dart

## What is Programming?

Imagine you have a very obedient friend who will do **exactly** what you tell them, but they only understand very specific instructions.

You can't say: "Make me breakfast."

You have to say:
1. Walk to the kitchen
2. Open the refrigerator
3. Take out 2 eggs
4. Take out the frying pan
5. Turn on the stove to medium heat
6. ...and so on

**That's programming.** You're giving a computer step-by-step instructions.

The computer is incredibly fast and never gets tired, but it's also incredibly literal. It only does **exactly** what you tell it to do.

## Why Dart?

Dart is the programming language that powers Flutter. Think of it this way:

- **Dart** = The language (like English, Spanish, French)
- **Flutter** = The tool for building apps (like a construction toolkit)

You need to learn Dart first, just like you need to learn English before you can write a novel in English.

### What Makes Dart Special?

1. **Easy to learn** - Clean, readable syntax
2. **Fast** - Your apps will run smoothly
3. **Safe** - Catches many errors before your app even runs
4. **Versatile** - Can build mobile apps, web apps, desktop apps, and more

## Your First Program

Let's write the most famous program in programming history: **Hello World**

```dart
void main() {
  print('Hello, World!');
}
```

Let's break this down word by word:

### `void main()`

- `main` - This is the **name** of a special function (think: a recipe name)
- `()` - These parentheses mean it's a function (we'll learn more later)
- `void` - This means the function doesn't give anything back (don't worry about this yet)

**Every Dart program starts with `main()`.** It's the entry point - where the computer begins reading your instructions.

Think of `main()` as the front door of your program. The computer always enters through the front door.

### `{ }` - Curly Braces

These curly braces are like a container. Everything between them belongs to the `main` function.

```dart
void main() {
  // Everything here is INSIDE main
  // This is where you write your instructions
}
```

### `print('Hello, World!');`

- `print` - This is a built-in function that displays text
- `()` - Parentheses hold what you want to print
- `'Hello, World!'` - This is text (called a "string")
- `;` - This semicolon means "end of instruction" (like a period at the end of a sentence)

## Let's Experiment

### Example 1: Print Your Name

```dart
void main() {
  print('My name is Alex');
}
```

**Output:**
```
My name is Alex
```

### Example 2: Print Multiple Lines

```dart
void main() {
  print('Welcome to Dart!');
  print('This is line 2');
  print('This is line 3');
}
```

**Output:**
```
Welcome to Dart!
This is line 2
This is line 3
```

Notice: Each `print()` statement goes on a new line in the output.

### Example 3: Print Numbers

```dart
void main() {
  print(42);
  print(3.14);
}
```

**Output:**
```
42
3.14
```

For numbers, you don't need quotes. Quotes are only for text.

## Understanding Print

Think of `print()` as speaking. Whatever you put inside the parentheses, the computer "says" it to you (displays it on screen).

```dart
print('This will be displayed');  // Text
print(100);                        // Number
print(true);                       // Boolean (true/false)
```

## Comments - Notes to Yourself

Sometimes you want to leave notes in your code for yourself or other programmers. These notes are called **comments**.

The computer completely ignores comments - they're just for humans.

### Single-Line Comments

```dart
// This is a comment
// The computer ignores this line

void main() {
  print('Hello!');  // This comment is at the end of a line
}
```

Use `//` for comments. Everything after `//` on that line is ignored.

### Multi-Line Comments

```dart
/*
This is a multi-line comment.
You can write many lines.
The computer ignores all of this.
*/

void main() {
  print('This runs!');
}
```

Use `/* */` to comment multiple lines.

### Documentation Comments

```dart
/// This is a documentation comment
/// Used to describe what code does
/// Tools can read these to generate documentation
void main() {
  print('Hello!');
}
```

Use `///` for documentation. We'll use these when our code gets more complex.

## Why Comments Matter

```dart
void main() {
  // Calculate total price with tax
  print(99.99 * 1.08);  // 8% tax rate
}
```

In 6 months, when you look at this code, the comment will remind you what you were doing.

**Good code tells you HOW. Good comments tell you WHY.**

## Running Your First Program

### Option 1: DartPad (Easiest for Starting)

1. Go to [dartpad.dev](https://dartpad.dev)
2. Delete any existing code
3. Type your program
4. Click "Run"
5. See output in the console (right side)

**Try it now!**

### Option 2: VS Code (For Serious Development)

We'll set this up in the next lesson. For now, use DartPad to experiment.

## Common Mistakes (and How to Fix Them)

### Mistake 1: Forgetting Semicolon

```dart
void main() {
  print('Hello')  // ERROR! Missing semicolon
}
```

**Fix:**
```dart
void main() {
  print('Hello');  // Correct!
}
```

### Mistake 2: Missing Quotes Around Text

```dart
void main() {
  print(Hello);  // ERROR! Dart thinks Hello is a variable
}
```

**Fix:**
```dart
void main() {
  print('Hello');  // Correct! Quotes mean it's text
}
```

### Mistake 3: Mismatched Parentheses or Braces

```dart
void main() {
  print('Hello';  // ERROR! Missing closing )
}
```

**Fix:**
```dart
void main() {
  print('Hello');  // Correct!
}
```

**Pro Tip:** Every `(` needs a `)`. Every `{` needs a `}`. They come in pairs.

## Exercises

### Exercise 1: Hello You
Write a program that prints your name.

**Expected Output:**
```
John Smith
```

<details>
<summary>Solution</summary>

```dart
void main() {
  print('John Smith');
}
```
</details>

---

### Exercise 2: Three Things
Write a program that prints three things you like (each on a separate line).

**Expected Output:**
```
I like pizza
I like coding
I like music
```

<details>
<summary>Solution</summary>

```dart
void main() {
  print('I like pizza');
  print('I like coding');
  print('I like music');
}
```
</details>

---

### Exercise 3: Mini Story
Write a program that prints a short 5-line story.

**Example Output:**
```
Once upon a time, there was a programmer.
They learned Dart.
They built amazing apps.
People loved their work.
The end.
```

<details>
<summary>Solution</summary>

```dart
void main() {
  print('Once upon a time, there was a programmer.');
  print('They learned Dart.');
  print('They built amazing apps.');
  print('People loved their work.');
  print('The end.');
}
```
</details>

---

### Exercise 4: Numbers and Text
Write a program that prints:
- Your age (number)
- Your city (text)
- Your favorite number (number)

**Example Output:**
```
25
New York
7
```

<details>
<summary>Solution</summary>

```dart
void main() {
  print(25);
  print('New York');
  print(7);
}
```
</details>

---

### Exercise 5: Commented Code
Write a program that prints "Learning Dart is fun!" and include:
- A single-line comment above the code
- A comment at the end of the print line

<details>
<summary>Solution</summary>

```dart
void main() {
  // Display a motivational message
  print('Learning Dart is fun!');  // This keeps me motivated
}
```
</details>

## Key Takeaways

1. **Every Dart program starts with `main()`**
2. **`print()` displays information**
3. **Text needs quotes: `'like this'`**
4. **Numbers don't need quotes: `42`**
5. **Every statement ends with `;`**
6. **Comments (`//`) are ignored by the computer**
7. **Code is read top to bottom, line by line**

## What's Next?

In the next lesson, we'll learn about:
- **Variables** - storing information to use later
- **Data types** - different kinds of information
- **Naming things** - how to name your variables properly

But for now, practice these exercises until you're comfortable with the basics.

**Remember:** Every expert programmer started exactly where you are now. The difference is they kept going.

---

**Challenge for the Brave:**

Can you create a program that prints a picture using text characters?

Example:
```
  *
 ***
*****
 ***
  *
```

Try it! Experimentation is how you learn best.
