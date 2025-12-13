# Level 1: Dart Fundamentals

**Welcome to your first step! This is where it all begins.**

## Learning Objectives

By the end of this level, you will:
- ✅ Understand what programming is and how computers think
- ✅ Write and run your first Dart program
- ✅ Master variables and data types
- ✅ Work with strings, numbers, and booleans
- ✅ Use operators and expressions
- ✅ Write comments and organize code
- ✅ Debug basic errors confidently

## Time Commitment
**4-5 hours** (including practice)

## Prerequisites
- None! This is your starting point
- Just bring curiosity and patience

---

## What You'll Learn

### The Big Picture

Before you can build beautiful Flutter apps, you need to speak Dart - the programming language that powers Flutter. Think of it this way:

- **Dart** = The language (like English)
- **Flutter** = The toolkit for building apps

You can't write a novel without knowing the language. Same with apps.

### Why Dart?

1. **Easy to learn** - Clean, readable syntax
2. **Safe** - Catches errors before your app runs
3. **Fast** - Your apps will be smooth
4. **Versatile** - Mobile, web, desktop - one language

---

## Level Contents

### Theory (Deep Understanding)

| File | Topic | Time |
|------|-------|------|
| `01-WhatIsProgramming.md` | Programming fundamentals | 30 min |
| `02-VariablesAndTypes.md` | Storing and using data | 45 min |
| `03-Strings.md` | Working with text | 30 min |
| `04-Numbers.md` | Math and calculations | 30 min |
| `05-Booleans.md` | True/false logic | 20 min |
| `06-Operators.md` | Operations and expressions | 30 min |

### Examples (Working Code)

| File | What It Demonstrates |
|------|---------------------|
| `Example01-HelloWorld.dart` | Your first program |
| `Example02-Variables.dart` | All variable types |
| `Example03-Strings.dart` | String operations |
| `Example04-Calculator.dart` | Math operations |
| `Example05-TypeConversion.dart` | Converting between types |
| `Example06-UserProfile.dart` | Combining concepts |

### Exercises (Practice)

Complete `Exercises.md` after finishing theory and examples.

---

## Study Plan

### Session 1 (1.5 hours)
1. Read `01-WhatIsProgramming.md`
2. Run `Example01-HelloWorld.dart`
3. Read `02-VariablesAndTypes.md`
4. Run `Example02-Variables.dart`
5. Experiment and modify

### Session 2 (1.5 hours)
1. Read `03-Strings.md`
2. Run `Example03-Strings.dart`
3. Read `04-Numbers.md`
4. Run `Example04-Calculator.dart`
5. Try the first few exercises

### Session 3 (1.5 hours)
1. Read `05-Booleans.md`
2. Read `06-Operators.md`
3. Run `Example05-TypeConversion.dart`
4. Run `Example06-UserProfile.dart`
5. Complete all exercises

---

## Key Concepts Preview

### Variables
```dart
String name = 'Alex';       // Text
int age = 25;               // Whole number
double height = 5.9;        // Decimal number
bool isStudent = true;      // True/false
```

### Print Output
```dart
print('Hello, World!');     // Display text
print(42);                  // Display number
print(name);                // Display variable
```

### String Interpolation
```dart
String name = 'Alex';
print('Hello, $name!');     // Hello, Alex!
print('Age: ${age + 1}');   // Age: 26
```

### Type Safety
```dart
int count = 10;
count = 'hello';  // ❌ Error! Can't put text in int
count = 20;       // ✅ Works! int goes in int
```

---

## Common Mistakes to Avoid

### 1. Forgetting Semicolons
```dart
// ❌ Wrong
print('Hello')

// ✅ Correct
print('Hello');
```

### 2. Mismatched Quotes
```dart
// ❌ Wrong
String name = 'Alex";

// ✅ Correct
String name = 'Alex';
```

### 3. Using Variables Before Declaration
```dart
// ❌ Wrong
print(age);
int age = 25;

// ✅ Correct
int age = 25;
print(age);
```

### 4. Wrong Type Assignment
```dart
// ❌ Wrong
int number = '42';  // Can't assign string to int

// ✅ Correct
int number = 42;
```

---

## Self-Assessment Checklist

Before moving to Level 2, make sure you can:

- [ ] Explain what a variable is in simple terms
- [ ] Declare variables of different types
- [ ] Use `print()` to display output
- [ ] Concatenate and interpolate strings
- [ ] Perform basic math operations
- [ ] Understand the difference between `int` and `double`
- [ ] Know when to use `bool`
- [ ] Fix common syntax errors
- [ ] Write comments to explain code

---

## What's Next?

After completing this level, you'll move to **Level 2: Control Flow** where you'll learn:
- Making decisions with `if` statements
- Repeating actions with loops
- Building logic into your programs

But first, master the fundamentals here!

---

## Quick Tips

1. **Type, don't copy-paste**: Build muscle memory
2. **Break things**: Change values and see what happens
3. **Read error messages**: They tell you what's wrong
4. **Take breaks**: Let concepts sink in
5. **Explain it aloud**: Teaching helps learning

---

**Let's begin! Open `Theory/01-WhatIsProgramming.md` and start your journey!**

---

**Continue to:** `Theory/01-WhatIsProgramming.md`
