# Level 02: Common Mistakes

Learn from these common control flow errors!

---

## Mistake #1: Using `=` Instead of `==`

```dart
// ❌ WRONG - Assignment, not comparison!
if (score = 100) {  // Error: Conditions must be bool
  print('Perfect!');
}

// ✅ RIGHT - Use == for comparison
if (score == 100) {
  print('Perfect!');
}
```

**Remember:**
- `=` assigns a value
- `==` compares values

---

## Mistake #2: Forgetting Curly Braces

```dart
// ❌ WRONG - Only first line is in the if
if (isLoggedIn)
  print('Welcome!');
  showDashboard();  // This ALWAYS runs!

// ✅ RIGHT - Use braces
if (isLoggedIn) {
  print('Welcome!');
  showDashboard();
}
```

**Best practice:** Always use `{}` even for single statements.

---

## Mistake #3: Wrong Comparison Order

```dart
// ❌ WRONG - Higher conditions never reached
if (score >= 60) {
  print('Pass');
} else if (score >= 90) {  // Never reached!
  print('Excellent');
}

// ✅ RIGHT - Check higher values first
if (score >= 90) {
  print('Excellent');
} else if (score >= 60) {
  print('Pass');
}
```

---

## Mistake #4: Infinite Loops

```dart
// ❌ WRONG - Never ends!
var i = 0;
while (i < 10) {
  print(i);
  // Forgot to increment i!
}

// ✅ RIGHT
var i = 0;
while (i < 10) {
  print(i);
  i++;  // Don't forget this!
}
```

---

## Mistake #5: Off-by-One Errors

```dart
// ❌ WRONG - Runs 6 times (0,1,2,3,4,5)
for (var i = 0; i <= 5; i++) {
  print(i);
}

// ✅ RIGHT - Runs 5 times (0,1,2,3,4)
for (var i = 0; i < 5; i++) {
  print(i);
}
```

**Tip:** `< length` is usually what you want for arrays.

---

## Mistake #6: Modifying List While Looping

```dart
// ❌ WRONG - Causes index errors!
var items = [1, 2, 3, 4, 5];
for (var i = 0; i < items.length; i++) {
  if (items[i] == 3) {
    items.removeAt(i);  // List shrinks, indices break!
  }
}

// ✅ RIGHT - Loop backwards or use where()
var items = [1, 2, 3, 4, 5];
items = items.where((item) => item != 3).toList();
```

---

## Mistake #7: Forgetting `break` in Switch

```dart
// ❌ WRONG - Falls through to next case
switch (day) {
  case 'Monday':
    print('Start of week');
    // Forgot break! Falls through to Tuesday
  case 'Tuesday':
    print('Second day');
}

// ✅ RIGHT
switch (day) {
  case 'Monday':
    print('Start of week');
    break;
  case 'Tuesday':
    print('Second day');
    break;
}
```

---

## Mistake #8: Wrong Boolean Logic

```dart
// ❌ WRONG - Impossible condition
if (age < 18 && age > 65) {  // Can't be both!
  print('Discount');
}

// ✅ RIGHT - Use OR for either condition
if (age < 18 || age > 65) {
  print('Discount');
}
```

**Remember:**
- `&&` = AND (both must be true)
- `||` = OR (either can be true)

---

## Mistake #9: Comparing Strings Wrong

```dart
// ❌ WRONG - Case sensitive!
if (answer == 'Yes') {  // 'yes' won't match!
  doSomething();
}

// ✅ RIGHT - Normalize case
if (answer.toLowerCase() == 'yes') {
  doSomething();
}
```

---

## Mistake #10: Empty Loop Body

```dart
// ❌ WRONG - Semicolon ends the loop immediately
for (var i = 0; i < 10; i++); {  // Extra semicolon!
  print(i);  // Only runs once, and i is undefined here
}

// ✅ RIGHT
for (var i = 0; i < 10; i++) {
  print(i);
}
```

---

## Quick Reference: Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `==` | Equals | `if (a == b)` |
| `!=` | Not equals | `if (a != b)` |
| `<` | Less than | `if (a < b)` |
| `<=` | Less than or equal | `if (a <= b)` |
| `>` | Greater than | `if (a > b)` |
| `>=` | Greater than or equal | `if (a >= b)` |
| `&&` | AND | `if (a && b)` |
| `\|\|` | OR | `if (a \|\| b)` |
| `!` | NOT | `if (!a)` |

---

**Still stuck? Re-read the Theory files or ask for help!**
