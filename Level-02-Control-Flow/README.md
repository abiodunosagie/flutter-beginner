# Level 2: Control Flow

**Make your programs smart! Teach them to make decisions and repeat actions.**

## Learning Objectives

By the end of this level, you will:
- ✅ Use if, else, and else if to make decisions
- ✅ Understand switch statements
- ✅ Master for loops and while loops
- ✅ Control loops with break and continue
- ✅ Nest conditions and loops
- ✅ Build logic into your programs

## Time Commitment
**4-5 hours** (including practice)

## Prerequisites
- Completed Level 1
- Understand variables and data types
- Know comparison operators (==, <, >, etc.)

---

## What You'll Learn

### The Big Picture

So far, your programs run from top to bottom, line by line. That's boring!

Real programs need to:
- **Make decisions**: "If the user is logged in, show the dashboard. Otherwise, show the login page."
- **Repeat actions**: "Send a notification to each of the 100 users in this list."

This is **control flow** - controlling which code runs and how many times.

---

## Level Contents

### Theory (Deep Understanding)

| File | Topic | Time |
|------|-------|------|
| `01-IfStatements.md` | Making decisions | 40 min |
| `02-SwitchStatements.md` | Multiple choices | 20 min |
| `03-ForLoops.md` | Counting loops | 40 min |
| `04-WhileLoops.md` | Conditional loops | 30 min |
| `05-LoopControl.md` | Break, continue, labels | 20 min |

### Examples (Working Code)

| File | What It Demonstrates |
|------|---------------------|
| `Example01-GradeChecker.dart` | If/else decisions |
| `Example02-DayOfWeek.dart` | Switch statements |
| `Example03-Multiplication.dart` | For loops |
| `Example04-GuessingGame.dart` | While loops |
| `Example05-Patterns.dart` | Nested loops |

### Exercises (Practice)

Complete `Exercises.md` after finishing theory and examples.

---

## Key Concepts Preview

### If Statement
```dart
int age = 20;

if (age >= 18) {
  print('You are an adult');
}
```

### If-Else
```dart
int score = 75;

if (score >= 60) {
  print('You passed!');
} else {
  print('Try again');
}
```

### For Loop
```dart
for (int i = 1; i <= 5; i++) {
  print('Count: $i');
}
// Prints: 1, 2, 3, 4, 5
```

### While Loop
```dart
int count = 0;

while (count < 3) {
  print('Count: $count');
  count++;
}
// Prints: 0, 1, 2
```

---

## Study Plan

### Session 1 (1.5 hours)
1. Read `01-IfStatements.md`
2. Run `Example01-GradeChecker.dart`
3. Read `02-SwitchStatements.md`
4. Run `Example02-DayOfWeek.dart`

### Session 2 (1.5 hours)
1. Read `03-ForLoops.md`
2. Run `Example03-Multiplication.dart`
3. Read `04-WhileLoops.md`
4. Run `Example04-GuessingGame.dart`

### Session 3 (1.5 hours)
1. Read `05-LoopControl.md`
2. Run `Example05-Patterns.dart`
3. Complete all exercises

---

## Common Mistakes to Avoid

### 1. Forgetting Curly Braces
```dart
// ❌ Dangerous - only first line is in the if
if (score > 90)
  print('Great job!');
  print('You got an A!');  // Always runs!

// ✅ Safe - use braces
if (score > 90) {
  print('Great job!');
  print('You got an A!');
}
```

### 2. Using = Instead of ==
```dart
// ❌ Wrong - this assigns, not compares!
if (x = 5) { }

// ✅ Correct - double equals compares
if (x == 5) { }
```

### 3. Infinite Loops
```dart
// ❌ Never ends - forgot to increment!
int i = 0;
while (i < 10) {
  print(i);
  // Missing: i++;
}

// ✅ Will end - counter increases
int i = 0;
while (i < 10) {
  print(i);
  i++;
}
```

---

## What's Next?

After completing this level, you'll move to **Level 3: Functions and Collections** where you'll learn:
- Creating reusable code with functions
- Working with Lists (arrays)
- Using Maps and Sets
- Higher-order functions

But first, master control flow here!

---

**Let's begin! Open `Theory/01-IfStatements.md`**

---

**Continue to:** `Theory/01-IfStatements.md`
