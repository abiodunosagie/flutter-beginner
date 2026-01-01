# Level 02 Checkpoint: Control Flow

Before moving to Level 03, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. If Statements
What does this code print?

```dart
var score = 75;

if (score >= 90) {
  print('A');
} else if (score >= 80) {
  print('B');
} else if (score >= 70) {
  print('C');
} else {
  print('F');
}
```

<details>
<summary>Check Answer</summary>

```
C
```
Because 75 is >= 70 but not >= 80

</details>

---

### 2. Logical Operators
What does each condition evaluate to?

```dart
var age = 25;
var hasLicense = true;
var isBanned = false;

var a = age >= 18 && hasLicense;      // ____
var b = age < 18 || hasLicense;       // ____
var c = !isBanned;                     // ____
var d = age >= 18 && !isBanned;       // ____
```

<details>
<summary>Check Answers</summary>

- a = `true` (25 >= 18 AND has license)
- b = `true` (false OR true = true)
- c = `true` (NOT false = true)
- d = `true` (true AND true)

</details>

---

### 3. Loops
How many times does each loop run?

```dart
// Loop A
for (var i = 0; i < 5; i++) {
  print(i);
}

// Loop B
var count = 3;
while (count > 0) {
  print(count);
  count--;
}

// Loop C
for (var item in ['a', 'b', 'c']) {
  print(item);
}
```

<details>
<summary>Check Answers</summary>

- Loop A: 5 times (0, 1, 2, 3, 4)
- Loop B: 3 times (3, 2, 1)
- Loop C: 3 times (a, b, c)

</details>

---

### 4. Switch Statements
What's the output?

```dart
var day = 'Monday';

switch (day) {
  case 'Saturday':
  case 'Sunday':
    print('Weekend!');
    break;
  case 'Monday':
    print('Back to work');
    break;
  default:
    print('Regular day');
}
```

<details>
<summary>Check Answer</summary>

```
Back to work
```

</details>

---

### 5. Break and Continue
What numbers are printed?

```dart
for (var i = 1; i <= 10; i++) {
  if (i == 3) continue;
  if (i == 7) break;
  print(i);
}
```

<details>
<summary>Check Answer</summary>

```
1
2
4
5
6
```
(3 is skipped, loop stops at 7)

</details>

---

## Hands-On Check

### Task 1: Price Tier Logic
Write code that assigns a tier based on price:
- Under $10: "Budget"
- $10-50: "Standard"
- Over $50: "Premium"

```dart
var price = 35.0;
// Your code here - print the tier
```

<details>
<summary>Example Solution</summary>

```dart
var price = 35.0;
String tier;

if (price < 10) {
  tier = 'Budget';
} else if (price <= 50) {
  tier = 'Standard';
} else {
  tier = 'Premium';
}

print(tier);  // Standard
```

</details>

---

### Task 2: Loop Through Products
Given a list of prices, print only those over $20:

```dart
var prices = [15.99, 29.99, 9.99, 45.00, 12.50];
// Print prices over $20
```

<details>
<summary>Example Solution</summary>

```dart
var prices = [15.99, 29.99, 9.99, 45.00, 12.50];

for (var price in prices) {
  if (price > 20) {
    print(price);
  }
}
// Output: 29.99, 45.0
```

</details>

---

### Task 3: Find First Match
Find the first price under $15 and stop:

```dart
var prices = [25.99, 19.99, 12.99, 8.99, 29.99];
// Find first price under $15
```

<details>
<summary>Example Solution</summary>

```dart
var prices = [25.99, 19.99, 12.99, 8.99, 29.99];

for (var price in prices) {
  if (price < 15) {
    print('Found: $price');
    break;
  }
}
// Output: Found: 12.99
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Condition | _________________ |
| Boolean expression | _________________ |
| Iteration | _________________ |
| break | _________________ |
| continue | _________________ |

---

## Ready for Level 03?

### I can confidently:
- [ ] Write if/else if/else chains
- [ ] Use `&&`, `||`, and `!` operators
- [ ] Write `for` loops with index
- [ ] Write `for-in` loops for collections
- [ ] Write `while` loops
- [ ] Use `switch` statements
- [ ] Use `break` and `continue` correctly

### Capstone Progress:
- [ ] My Product model has discount logic (if price > X, apply discount)
- [ ] I can validate product data (check for empty name, negative price, etc.)
- [ ] I understand how to categorize products by price tier

---

## If You're Stuck

**Common issues at this level:**

1. **Off-by-one errors in loops**
   - `< 5` vs `<= 5` - know the difference!
   - Arrays start at index 0

2. **Forgetting `break` in switch**
   - Each case needs `break` (unless you want fall-through)

3. **Condition logic confusion**
   - `&&` = ALL must be true
   - `||` = ANY can be true
   - Draw truth tables if needed

---

**Ready to level up? Head to Level 03: Functions & Collections!**
