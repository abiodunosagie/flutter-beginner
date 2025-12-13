# Booleans: True or False

## What Is a Boolean?

A **boolean** is the simplest type of data. It can only be one of two things:
- `true`
- `false`

That's it. Nothing else. Just yes or no. On or off. True or false.

---

## Think of It Like This

Imagine a light switch:
- **ON** = `true`
- **OFF** = `false`

```dart
bool lightIsOn = true;   // The light is ON
bool lightIsOn = false;  // The light is OFF
```

Or a door:
- **OPEN** = `true`
- **CLOSED** = `false`

```dart
bool doorIsOpen = true;   // Door is open
bool doorIsOpen = false;  // Door is closed
```

---

## Creating Booleans

```dart
bool isHappy = true;
bool isRaining = false;
bool hasAccount = true;
bool isLoggedIn = false;
```

**Naming tip:** Start boolean names with `is`, `has`, `can`, `should` - it makes them read like questions:
- `isHappy` → "Is happy?" Yes (true) or No (false)
- `hasAccount` → "Has account?" Yes or No
- `canSwim` → "Can swim?" Yes or No

---

## Where Do Booleans Come From?

Booleans often come from **comparisons**.

### Comparing Numbers

```dart
int age = 25;

bool isAdult = age >= 18;    // true (25 is >= 18)
bool isTeenager = age < 20;  // false (25 is not < 20)
bool isExactly25 = age == 25; // true (25 equals 25)
```

### Comparison Operators

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | Equal to | `5 == 5` | `true` |
| `!=` | Not equal to | `5 != 3` | `true` |
| `>` | Greater than | `5 > 3` | `true` |
| `<` | Less than | `5 < 3` | `false` |
| `>=` | Greater or equal | `5 >= 5` | `true` |
| `<=` | Less or equal | `5 <= 3` | `false` |

### More Examples

```dart
print(10 == 10);  // true
print(10 == 5);   // false
print(10 != 5);   // true
print(10 > 5);    // true
print(10 < 5);    // false
print(10 >= 10);  // true
print(10 <= 5);   // false
```

---

## Combining Booleans

Sometimes you need to combine conditions. Like asking:
- "Is it sunny AND warm?" (both must be true)
- "Is it Saturday OR Sunday?" (either can be true)

### AND (`&&`)

Both must be `true` for the result to be `true`.

```dart
bool isSunny = true;
bool isWarm = true;

bool niceDay = isSunny && isWarm;  // true (both are true)
```

**Truth table for AND:**
```
true  && true  = true
true  && false = false
false && true  = false
false && false = false
```

Think: "I'll go outside if it's sunny AND warm." Both conditions must be met.

### OR (`||`)

At least one must be `true` for the result to be `true`.

```dart
bool isSaturday = false;
bool isSunday = true;

bool isWeekend = isSaturday || isSunday;  // true (Sunday is true)
```

**Truth table for OR:**
```
true  || true  = true
true  || false = true
false || true  = true
false || false = false
```

Think: "I'll sleep in if it's Saturday OR Sunday." Just one needs to be true.

### NOT (`!`)

Flips the value. `true` becomes `false`. `false` becomes `true`.

```dart
bool isRaining = true;
bool isNotRaining = !isRaining;  // false

bool isDark = false;
bool isLight = !isDark;  // true
```

---

## Simple Examples

### Example 1: Can You Vote?

```dart
void main() {
  int age = 17;

  bool canVote = age >= 18;

  print('Age: $age');
  print('Can vote: $canVote');  // false
}
```

### Example 2: Is It a Weekend?

```dart
void main() {
  String today = 'Saturday';

  bool isWeekend = today == 'Saturday' || today == 'Sunday';

  print('Is weekend: $isWeekend');  // true
}
```

### Example 3: Can Enter Club?

```dart
void main() {
  int age = 21;
  bool hasID = true;

  bool canEnter = age >= 21 && hasID;

  print('Can enter: $canEnter');  // true
}
```

---

## Using Booleans in Decisions

Booleans power `if` statements (we'll learn more in Level 2):

```dart
void main() {
  bool isLoggedIn = true;

  if (isLoggedIn) {
    print('Welcome back!');
  } else {
    print('Please log in.');
  }
}
```

---

## Common Patterns

### Toggle (Flip a Boolean)

```dart
bool lightOn = false;

lightOn = !lightOn;  // Now true
lightOn = !lightOn;  // Now false
lightOn = !lightOn;  // Now true
```

### Check Multiple Conditions

```dart
int age = 25;
bool hasLicense = true;
bool hasInsurance = true;

bool canDrive = age >= 16 && hasLicense && hasInsurance;
```

### Checking Strings

```dart
String name = 'Alex';

bool isEmpty = name == '';        // false
bool startsWithA = name[0] == 'A'; // true
```

---

## Summary

### Key Points

1. **Boolean** = `true` or `false` only
2. **Comparisons** create booleans (`==`, `!=`, `<`, `>`, `<=`, `>=`)
3. **AND** (`&&`) = both must be true
4. **OR** (`||`) = at least one must be true
5. **NOT** (`!`) = flips the value

### Quick Reference

```dart
// Creating booleans
bool flag = true;
bool flag = false;

// Comparisons
a == b   // equal
a != b   // not equal
a > b    // greater than
a < b    // less than
a >= b   // greater or equal
a <= b   // less or equal

// Combining
a && b   // AND (both true)
a || b   // OR (either true)
!a       // NOT (flip)
```

---

## Quick Quiz

**Q1:** What is `5 > 3`?

<details>
<summary>Answer</summary>
`true` - 5 is greater than 3.
</details>

**Q2:** What is `true && false`?

<details>
<summary>Answer</summary>
`false` - AND requires both to be true.
</details>

**Q3:** What is `!true`?

<details>
<summary>Answer</summary>
`false` - NOT flips the value.
</details>

**Q4:** What is `false || true`?

<details>
<summary>Answer</summary>
`true` - OR only needs one to be true.
</details>

---

**Next:** Let's wrap up with operators and expressions.

---

**Continue to:** `06-Operators.md`
