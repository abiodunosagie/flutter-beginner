# What Is Programming?

## The Simple Explanation

Imagine you have a robot assistant that's incredibly fast and never gets tired, but it only understands very specific instructions.

You can't say: "Make me breakfast."

You have to say:
1. Walk to the kitchen
2. Open the refrigerator
3. Take out 2 eggs
4. Take out the butter
5. Close the refrigerator
6. Walk to the stove
7. Turn on the burner to medium heat
8. Place the pan on the burner
9. ...and so on

**That's programming.** You're giving a computer step-by-step instructions.

The computer is incredibly fast and never makes mistakes following your instructions. But it's also incredibly literal - it does **exactly** what you tell it. Not what you meant. What you said.

---

## How Computers Think

### Computers Are Literal

```
Human thinking: "Get me some coffee"
  - Understands context
  - Knows where coffee is
  - Knows how to make it
  - Uses common sense

Computer thinking: "Get me some coffee"
  - What is "me"?
  - What is "coffee"?
  - Where is it?
  - How do I "get"?
  - ERROR: Instructions unclear
```

### Computers Need Exact Steps

```
✅ Computer-friendly instructions:
1. Variable: cupLocation = kitchen cabinet, shelf 2
2. Open cabinet door
3. Reach to position (x: 10, y: 5)
4. Grasp object at position
5. Move object to counter
6. ...
```

This is why programming languages exist - they let us write these exact instructions in a way computers understand.

---

## What Is a Programming Language?

A programming language is a translator between human thinking and computer operations.

```
Human Idea     →     Programming Language     →     Computer Action
"Show a greeting"    print('Hello!')               Displays "Hello!" on screen
```

### Why So Many Languages?

Different tools for different jobs:

| Language | Best For |
|----------|----------|
| **Dart** | Mobile apps (Flutter), web |
| JavaScript | Websites, web apps |
| Python | Data science, automation |
| Swift | iPhone apps |
| Java | Android apps, enterprise |
| C++ | Games, operating systems |

We're learning **Dart** because it powers **Flutter**, which lets us build beautiful apps for iOS, Android, web, and desktop from a single codebase.

---

## Your First Program

Let's write the most famous program in programming history: **Hello World**

```dart
void main() {
  print('Hello, World!');
}
```

That's it. Three lines. Let's break it down word by word.

---

## Breaking Down the Code

### `void main()`

```dart
void main() {
```

- **`main`** - This is the name of a special function (think: a recipe name)
- **`()`** - Parentheses indicate it's a function
- **`void`** - Means this function doesn't give anything back (don't worry about this yet)
- **`{`** - Opens the function body

**Every Dart program starts with `main()`.** It's the entry point - where the computer begins reading your instructions.

Think of `main()` as the front door of your house. No matter how big your house is, guests always enter through the front door. The computer always starts at `main()`.

### The Curly Braces `{ }`

```dart
void main() {
  // Everything here is INSIDE main
  // This is where your instructions go
}
```

Curly braces are containers. Everything between `{` and `}` belongs to that function.

### `print('Hello, World!');`

```dart
print('Hello, World!');
```

- **`print`** - A built-in function that displays text on screen
- **`(`** - Opens what you want to print
- **`'Hello, World!'`** - The text to display (called a "string")
- **`)`** - Closes the print function
- **`;`** - Semicolon means "end of instruction"

The semicolon is like a period at the end of a sentence. It tells the computer "this instruction is complete."

---

## Running Your First Program

### Option 1: DartPad (Easiest)

1. Open your browser
2. Go to [dartpad.dev](https://dartpad.dev)
3. Delete any existing code
4. Type:
```dart
void main() {
  print('Hello, World!');
}
```
5. Click **Run**
6. See the output in the console (right side)

**Try it now!**

### Option 2: VS Code

If you've set up VS Code with Dart:
1. Create a new file: `hello.dart`
2. Type the code above
3. Open terminal
4. Run: `dart hello.dart`

---

## Experimenting

Change the code and see what happens:

### Print Your Name
```dart
void main() {
  print('My name is Alex');
}
```

### Print Multiple Lines
```dart
void main() {
  print('Line 1');
  print('Line 2');
  print('Line 3');
}
```

**Output:**
```
Line 1
Line 2
Line 3
```

Each `print()` displays on a new line.

### Print Numbers
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

Numbers don't need quotes. Quotes are for text.

---

## Comments - Notes for Humans

Sometimes you want to leave notes in your code. These notes are called **comments**. The computer ignores them completely.

### Single-Line Comments

```dart
// This is a comment
// The computer ignores this

void main() {
  print('Hello!');  // This prints a greeting
}
```

Use `//` for comments. Everything after `//` on that line is ignored.

### Multi-Line Comments

```dart
/*
This is a multi-line comment.
You can write many lines here.
The computer ignores all of this.
*/

void main() {
  print('Hello!');
}
```

Use `/* */` for multiple lines.

### Why Comments Matter

```dart
void main() {
  // Calculate price with 8% sales tax
  print(99.99 * 1.08);
}
```

In 6 months, the comment reminds you what this code does.

**Rule of thumb:**
- Good code tells you **HOW**
- Good comments tell you **WHY**

---

## Common Mistakes

### Mistake 1: Forgetting Semicolon

```dart
// ❌ ERROR
void main() {
  print('Hello')  // Missing semicolon!
}

// ✅ CORRECT
void main() {
  print('Hello');
}
```

### Mistake 2: Missing Quotes for Text

```dart
// ❌ ERROR
void main() {
  print(Hello);  // Dart thinks Hello is a variable name
}

// ✅ CORRECT
void main() {
  print('Hello');  // Quotes tell Dart it's text
}
```

### Mistake 3: Mismatched Braces

```dart
// ❌ ERROR
void main() {
  print('Hello');
// Missing closing brace!

// ✅ CORRECT
void main() {
  print('Hello');
}
```

**Rule:** Every `{` needs a `}`. Every `(` needs a `)`. They come in pairs.

---

## The Rules of Dart

### Rule 1: Case Sensitive
```dart
Print('Hello');  // ❌ ERROR - "Print" is not "print"
print('Hello');  // ✅ Correct
```

### Rule 2: Whitespace Mostly Ignored
```dart
// These are all valid:
print('Hello');
print(    'Hello'    );
print(
  'Hello'
);
```

But be consistent for readability.

### Rule 3: Execution Order
Code runs top to bottom, line by line:
```dart
void main() {
  print('First');   // Runs 1st
  print('Second');  // Runs 2nd
  print('Third');   // Runs 3rd
}
```

---

## Summary

### Key Takeaways

1. **Programming** = Giving computers precise, step-by-step instructions
2. **Dart** = The language we use to write Flutter apps
3. **`main()`** = Where every Dart program starts
4. **`print()`** = Displays output to the screen
5. **Semicolons** = End every statement
6. **Quotes** = Surround text (strings)
7. **Comments** = Notes for humans, ignored by computer

### Mental Model

```
┌─────────────────────────────────────┐
│           Your Dart Program          │
├─────────────────────────────────────┤
│  void main() {                       │
│    // Computer starts here           │
│    instruction 1;                    │
│    instruction 2;  ←── runs in order │
│    instruction 3;                    │
│  }                                   │
└─────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What function does every Dart program need?

<details>
<summary>Answer</summary>
`main()` - It's the entry point where execution begins.
</details>

**Q2:** What does this print?
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
Each print() outputs on its own line.
</details>

**Q3:** What's wrong with this code?
```dart
void main() {
  print('Hello')
}
```

<details>
<summary>Answer</summary>
Missing semicolon after `print('Hello')`. Should be `print('Hello');`
</details>

**Q4:** Why use comments?

<details>
<summary>Answer</summary>
To leave notes for yourself and other programmers. Comments explain WHY code does something, making it easier to understand later.
</details>

---

**Next:** Now that you understand the basics, let's learn how to store and use data with variables.

---

**Continue to:** `02-VariablesAndTypes.md`
