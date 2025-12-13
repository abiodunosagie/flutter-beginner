# Loop Control: Break and Continue

## Why Control Loops?

Sometimes you need to:
- **Stop early** - "I found what I was looking for, stop searching"
- **Skip one iteration** - "Skip this item, but keep going"

That's what `break` and `continue` do.

---

## Break: Stop the Loop

`break` immediately exits the loop.

```dart
for (int i = 1; i <= 10; i++) {
  if (i == 5) {
    break;  // Stop the loop!
  }
  print(i);
}
print('Done');
```

**Output:**
```
1
2
3
4
5
Done
```

The loop stopped at 5 instead of going to 10.

---

## When to Use Break

### Finding Something

```dart
List<int> numbers = [3, 7, 2, 9, 4, 6];
int target = 9;
int index = -1;

for (int i = 0; i < numbers.length; i++) {
  if (numbers[i] == target) {
    index = i;
    break;  // Found it, stop searching
  }
}

print('Found at index: $index');  // 3
```

### First Match

```dart
List<String> names = ['Alice', 'Bob', 'Charlie'];

for (String name in names) {
  if (name.startsWith('B')) {
    print('First name starting with B: $name');
    break;  // Only want the first one
  }
}
```

---

## Continue: Skip This One

`continue` skips the rest of the current iteration and goes to the next.

```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) {
    continue;  // Skip 3
  }
  print(i);
}
```

**Output:**
```
1
2
4
5
```

Notice: 3 is missing because we skipped it.

---

## Visual Comparison

### Break
```
1 → print
2 → print
3 → BREAK → EXIT LOOP
4 → (never reached)
5 → (never reached)
```

### Continue
```
1 → print
2 → print
3 → CONTINUE → (skip print)
4 → print
5 → print
```

---

## When to Use Continue

### Skip Invalid Items

```dart
List<int> numbers = [5, -3, 8, -1, 10, -7];

for (int num in numbers) {
  if (num < 0) {
    continue;  // Skip negative numbers
  }
  print('Processing: $num');
}
```

**Output:**
```
Processing: 5
Processing: 8
Processing: 10
```

### Skip Empty Values

```dart
List<String> inputs = ['hello', '', 'world', '', 'dart'];

for (String input in inputs) {
  if (input.isEmpty) {
    continue;  // Skip empty strings
  }
  print('Input: $input');
}
```

---

## Break and Continue with While

Works the same way:

```dart
int i = 0;

while (i < 10) {
  i++;

  if (i == 3) continue;  // Skip 3
  if (i == 7) break;     // Stop at 7

  print(i);
}
```

**Output:**
```
1
2
4
5
6
```

---

## Nested Loops: Which Loop Breaks?

`break` only exits the innermost loop:

```dart
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (j == 2) break;  // Only breaks inner loop
    print('i=$i, j=$j');
  }
}
```

**Output:**
```
i=1, j=1
i=2, j=1
i=3, j=1
```

The outer loop (i) keeps running; only the inner loop (j) breaks.

---

## Labels: Break Outer Loops

Use labels to break/continue outer loops:

```dart
outerLoop:  // This is a label
for (int i = 1; i <= 3; i++) {
  for (int j = 1; j <= 3; j++) {
    if (j == 2) break outerLoop;  // Breaks the OUTER loop
    print('i=$i, j=$j');
  }
}
print('Done');
```

**Output:**
```
i=1, j=1
Done
```

---

## Practical Examples

### Example 1: Find First Even Number

```dart
void main() {
  List<int> numbers = [1, 3, 5, 8, 9, 10];

  for (int num in numbers) {
    if (num % 2 == 0) {
      print('First even: $num');
      break;
    }
  }
}
// Output: First even: 8
```

### Example 2: Process Valid Data Only

```dart
void main() {
  List<int> ages = [25, -5, 30, 0, 45, -10, 50];

  int total = 0;
  int count = 0;

  for (int age in ages) {
    if (age <= 0) continue;  // Skip invalid ages

    total += age;
    count++;
  }

  print('Average age: ${total / count}');
}
```

### Example 3: Password Validation

```dart
void main() {
  String password = 'Pass123!';
  bool hasUpper = false;
  bool hasLower = false;
  bool hasDigit = false;

  for (int i = 0; i < password.length; i++) {
    String char = password[i];

    if (char.toUpperCase() != char.toLowerCase()) {
      if (char == char.toUpperCase()) hasUpper = true;
      if (char == char.toLowerCase()) hasLower = true;
    } else if ('0123456789'.contains(char)) {
      hasDigit = true;
    }

    // Exit early if all requirements met
    if (hasUpper && hasLower && hasDigit) {
      break;
    }
  }

  print('Has uppercase: $hasUpper');
  print('Has lowercase: $hasLower');
  print('Has digit: $hasDigit');
}
```

### Example 4: Find in 2D Array

```dart
void main() {
  List<List<int>> matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  int target = 5;
  int row = -1;
  int col = -1;

  search:
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j] == target) {
        row = i;
        col = j;
        break search;  // Break out of both loops
      }
    }
  }

  print('Found $target at row $row, col $col');
}
```

---

## Common Patterns

### Pattern 1: Search and Exit

```dart
for (var item in items) {
  if (matchCondition(item)) {
    result = item;
    break;
  }
}
```

### Pattern 2: Filter While Processing

```dart
for (var item in items) {
  if (skipCondition(item)) continue;
  process(item);
}
```

### Pattern 3: Limited Processing

```dart
int count = 0;
for (var item in items) {
  process(item);
  count++;
  if (count >= maxItems) break;
}
```

---

## Summary

### Break
- Exits the loop immediately
- Loop ends, code after loop runs
- Use when you found what you need

### Continue
- Skips rest of current iteration
- Loop continues with next iteration
- Use when current item should be skipped

### Labels
- Name a loop with `labelName:`
- Break/continue that specific loop: `break labelName;`
- Useful for nested loops

---

## Quick Quiz

**Q1:** What's the output?
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) continue;
  print(i);
}
```

<details>
<summary>Answer</summary>
1, 2, 4, 5 (3 is skipped)
</details>

**Q2:** What's the output?
```dart
for (int i = 1; i <= 5; i++) {
  if (i == 3) break;
  print(i);
}
```

<details>
<summary>Answer</summary>
1, 2 (loop stops at 3)
</details>

**Q3:** Which loop does `break` exit in nested loops?

<details>
<summary>Answer</summary>
The innermost loop (unless you use a label).
</details>

---

**Congratulations!** You've completed the theory for Level 2!

Now practice with the Examples and Exercises.

---

**Continue to:** `../Examples/Example01-GradeChecker.dart`
