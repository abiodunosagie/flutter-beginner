# For Loops: Repeating Actions

## What Is a Loop?

A **loop** repeats code multiple times.

Without loops:
```dart
print('Hello');
print('Hello');
print('Hello');
print('Hello');
print('Hello');
```

With a loop:
```dart
for (int i = 0; i < 5; i++) {
  print('Hello');
}
```

Same result, but much cleaner!

---

## The Basic For Loop

```dart
for (int i = 0; i < 5; i++) {
  print('Count: $i');
}
```

**Output:**
```
Count: 0
Count: 1
Count: 2
Count: 3
Count: 4
```

---

## The Three Parts of a For Loop

```dart
for (initialization; condition; update) {
  // code to repeat
}
```

Let's break it down:

```dart
for (int i = 0; i < 5; i++) {
     ─────┬─   ──┬──   ─┬─
          │      │      │
          │      │      └── UPDATE: i++ (add 1 after each loop)
          │      │
          │      └── CONDITION: i < 5 (keep going while true)
          │
          └── INIT: int i = 0 (start at 0)
}
```

**How it runs:**
1. **Initialize:** `i = 0`
2. **Check:** Is `i < 5`? → `0 < 5` → YES
3. **Run code:** Print "Count: 0"
4. **Update:** `i++` → `i = 1`
5. **Check:** Is `i < 5`? → `1 < 5` → YES
6. **Run code:** Print "Count: 1"
7. **Update:** `i++` → `i = 2`
8. ... continues until `i = 5`
9. **Check:** Is `i < 5`? → `5 < 5` → NO
10. **Exit loop**

---

## Visual Flow

```
Start
  │
  ▼
┌─────────────┐
│ int i = 0   │  ← Initialize (once)
└──────┬──────┘
       │
       ▼
  ┌────────────┐
  │  i < 5 ?   │  ← Condition (every time)
  └─────┬──────┘
        │
   ┌────┴────┐
  YES        NO ───────┐
   │                   │
   ▼                   │
┌──────────┐           │
│ print(i) │  ← Body   │
└────┬─────┘           │
     │                 │
     ▼                 │
┌──────────┐           │
│   i++    │  ← Update │
└────┬─────┘           │
     │                 │
     └─────────────────┘
                       │
                       ▼
                   Continue...
```

---

## Common For Loop Patterns

### Count Up (0 to 4)

```dart
for (int i = 0; i < 5; i++) {
  print(i);
}
// 0, 1, 2, 3, 4
```

### Count Up (1 to 5)

```dart
for (int i = 1; i <= 5; i++) {
  print(i);
}
// 1, 2, 3, 4, 5
```

### Count Down

```dart
for (int i = 5; i > 0; i--) {
  print(i);
}
// 5, 4, 3, 2, 1
```

### Count by 2s

```dart
for (int i = 0; i <= 10; i += 2) {
  print(i);
}
// 0, 2, 4, 6, 8, 10
```

---

## For-In Loop (For Collections)

Loop through a list of items:

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];

for (String fruit in fruits) {
  print(fruit);
}
// apple
// banana
// cherry
```

**Simpler than:**
```dart
for (int i = 0; i < fruits.length; i++) {
  print(fruits[i]);
}
```

Use `for-in` when you don't need the index.

---

## For-Each Method

Another way to loop through collections:

```dart
List<int> numbers = [1, 2, 3, 4, 5];

numbers.forEach((number) {
  print(number * 2);
});
// 2, 4, 6, 8, 10
```

Or shorter with arrow function:
```dart
numbers.forEach((n) => print(n * 2));
```

---

## Nested Loops

Loops inside loops:

```dart
for (int row = 1; row <= 3; row++) {
  for (int col = 1; col <= 3; col++) {
    print('Row $row, Col $col');
  }
}
```

**Output:**
```
Row 1, Col 1
Row 1, Col 2
Row 1, Col 3
Row 2, Col 1
Row 2, Col 2
Row 2, Col 3
Row 3, Col 1
Row 3, Col 2
Row 3, Col 3
```

**Use case:** Creating grids, tables, multiplication tables.

---

## Practical Examples

### Example 1: Sum of Numbers

```dart
void main() {
  int sum = 0;

  for (int i = 1; i <= 10; i++) {
    sum += i;
  }

  print('Sum of 1-10: $sum');  // 55
}
```

### Example 2: Multiplication Table

```dart
void main() {
  int number = 7;

  print('$number times table:');
  for (int i = 1; i <= 10; i++) {
    print('$number x $i = ${number * i}');
  }
}
```

### Example 3: Find Maximum

```dart
void main() {
  List<int> scores = [85, 92, 78, 95, 88];
  int max = scores[0];

  for (int score in scores) {
    if (score > max) {
      max = score;
    }
  }

  print('Highest score: $max');  // 95
}
```

### Example 4: Print Pattern

```dart
void main() {
  for (int i = 1; i <= 5; i++) {
    String stars = '*' * i;
    print(stars);
  }
}
```

**Output:**
```
*
**
***
****
*****
```

### Example 5: Factorial

```dart
void main() {
  int n = 5;
  int factorial = 1;

  for (int i = 1; i <= n; i++) {
    factorial *= i;
  }

  print('$n! = $factorial');  // 5! = 120
}
```

---

## Common Mistakes

### 1. Off-by-One Errors

```dart
// ❌ Runs 6 times (0,1,2,3,4,5)
for (int i = 0; i <= 5; i++) { }

// ✅ Runs 5 times (0,1,2,3,4)
for (int i = 0; i < 5; i++) { }
```

### 2. Infinite Loop

```dart
// ❌ Never ends!
for (int i = 0; i < 10; i--) { }  // i goes negative forever

// ✅ Correct
for (int i = 0; i < 10; i++) { }
```

### 3. Wrong Variable

```dart
// ❌ Uses wrong variable
for (int i = 0; i < 5; i++) {
  print(j);  // j doesn't exist!
}

// ✅ Use the loop variable
for (int i = 0; i < 5; i++) {
  print(i);
}
```

---

## Summary

### For Loop Syntax

```dart
// Classic for loop
for (int i = 0; i < n; i++) {
  // code
}

// For-in (collections)
for (var item in collection) {
  // code
}

// forEach
collection.forEach((item) {
  // code
});
```

### Key Points

1. **Initialize** once at the start
2. **Check condition** before each iteration
3. **Update** after each iteration
4. Use `for-in` for collections when you don't need index
5. Be careful with `<` vs `<=`

---

## Quick Quiz

**Q1:** How many times does this run?
```dart
for (int i = 0; i < 10; i++) { }
```

<details>
<summary>Answer</summary>
10 times (i = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
</details>

**Q2:** What's the output?
```dart
for (int i = 5; i >= 1; i--) {
  print(i);
}
```

<details>
<summary>Answer</summary>
5, 4, 3, 2, 1 (counts down from 5 to 1)
</details>

**Q3:** Rewrite using for-in:
```dart
List<String> names = ['A', 'B', 'C'];
for (int i = 0; i < names.length; i++) {
  print(names[i]);
}
```

<details>
<summary>Answer</summary>

```dart
for (String name in names) {
  print(name);
}
```
</details>

---

**Next:** Let's learn about while loops!

---

**Continue to:** `04-WhileLoops.md`
