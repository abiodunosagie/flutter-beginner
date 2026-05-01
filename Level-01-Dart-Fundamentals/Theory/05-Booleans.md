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

## Assignment

### Problem 1: Predict the output

```dart
void main() {
  bool a = true;
  bool b = false;

  print(a && b);
  print(a || b);
  print(!a);
  print(!b);
  print(a && !b);
  print(!a || b);
}
```

### Problem 2: Truth table builder

For two booleans `p` and `q`, fill in this truth table by tracing each combination by hand. After you fill it in, write the same table in code with print statements.

| p | q | p && q | p \|\| q | !p | !p \|\| q |
|---|---|--------|----------|----|-----------|
| true | true | ? | ? | ? | ? |
| true | false | ? | ? | ? | ? |
| false | true | ? | ? | ? | ? |
| false | false | ? | ? | ? | ? |

### Problem 3: Booleans from conditions

Write a function that takes an integer and a person's name, and returns three booleans (using a record):

- `isAdult` (age 18 or above).
- `hasShortName` (name length under 5 characters).
- `isYoungAdultWithShortName` (both of the above).

```dart
({bool isAdult, bool hasShortName, bool isYoungAdultWithShortName}) classify(int age, String name) {
  // ...
}
```

Test on:
- `classify(25, 'Ada')` -> all three true.
- `classify(15, 'Ada')` -> isAdult false, hasShortName true, combined false.
- `classify(30, 'Adekunle')` -> isAdult true, hasShortName false, combined false.

### Problem 4: Short-circuit evaluation

The `&&` and `||` operators "short-circuit". This means they stop evaluating as soon as the answer is known.

For each expression, predict whether the right side is even evaluated. Explain your reasoning.

```dart
bool a = true;
bool b = false;

// 1. a || expensiveCheck()
// 2. a && expensiveCheck()
// 3. b || expensiveCheck()
// 4. b && expensiveCheck()
```

### Problem 5: De Morgan's law

De Morgan's law says these two pairs are always equivalent:

- `!(a && b)` is the same as `!a || !b`.
- `!(a || b)` is the same as `!a && !b`.

Write a small program that confirms this for all four combinations of `a` and `b`. Print whether each pair matches.

---

## Assignment Answers

### Problem 1: Predict the output

```
false
true
false
true
true
false
```

How each line:

1. `a && b` = `true && false` = false. AND requires both true.
2. `a || b` = `true || false` = true. OR requires at least one true.
3. `!a` = `!true` = false. NOT flips.
4. `!b` = `!false` = true.
5. `a && !b` = `true && true` = true. `!b` is true (since b is false), and a is true.
6. `!a || b` = `false || false` = false. `!a` is false (since a is true), and b is also false.

### Problem 2: Truth table builder

| p | q | p && q | p \|\| q | !p | !p \|\| q |
|---|---|--------|----------|----|-----------|
| true | true | true | true | false | true |
| true | false | false | true | false | false |
| false | true | false | true | true | true |
| false | false | false | false | true | true |

How each row was filled:

- `p && q`: true only when both are true. Only the first row.
- `p || q`: true when at least one is true. False only in the last row.
- `!p`: flips p. So false, false, true, true.
- `!p || q`: true if `!p` is true OR q is true. Trace each row carefully.

In code:

```dart
void main() {
  for (bool p in [true, false]) {
    for (bool q in [true, false]) {
      print('p=$p, q=$q | && = ${p && q}, || = ${p || q}, !p = ${!p}, !p||q = ${!p || q}');
    }
  }
}
```

This nested loop walks all four combinations and prints the results. The outer loop sets `p`, the inner sets `q`.

### Problem 3: Booleans from conditions

```dart
({bool isAdult, bool hasShortName, bool isYoungAdultWithShortName}) classify(int age, String name) {
  bool isAdult = age >= 18;
  bool hasShortName = name.length < 5;
  bool isYoungAdultWithShortName = isAdult && hasShortName;

  return (
    isAdult: isAdult,
    hasShortName: hasShortName,
    isYoungAdultWithShortName: isYoungAdultWithShortName,
  );
}

void main() {
  print(classify(25, 'Ada'));
  print(classify(15, 'Ada'));
  print(classify(30, 'Adekunle'));
}
```

How each boolean was built:

1. `isAdult = age >= 18`. The result of a comparison is itself a boolean. We do not need a separate if statement.
2. `hasShortName = name.length < 5`. `length` is a property of a String. We compare it to 5.
3. `isYoungAdultWithShortName = isAdult && hasShortName`. Two booleans combined with AND. True only when both are true.

The lesson: comparisons produce booleans directly. You can store them, combine them, return them. Booleans are first-class values like ints and strings.

### Problem 4: Short-circuit evaluation

```dart
// 1. a || expensiveCheck()    a is true.
//    OR is true if either side is true. We already know the left is true.
//    The right is NOT evaluated. expensiveCheck() does not run.
//
// 2. a && expensiveCheck()    a is true.
//    AND needs both to be true. The left is true, so the answer depends on the right.
//    expensiveCheck() IS evaluated.
//
// 3. b || expensiveCheck()    b is false.
//    The left is false, so OR depends on the right.
//    expensiveCheck() IS evaluated.
//
// 4. b && expensiveCheck()    b is false.
//    AND needs both true. The left is false, so the result is already false.
//    expensiveCheck() is NOT evaluated.
```

The pattern:

- `||` skips the right side if the left is **true**.
- `&&` skips the right side if the left is **false**.

Why this matters in real code:

```dart
if (user != null && user.isAdmin) { ... }
```

If `user` is null, `user.isAdmin` would throw. But thanks to short-circuit, the right side is only evaluated when the left is true. The check is safe by design.

Always put the cheaper or null-safe condition first when using `&&` and `||`. Short-circuit will save you from crashes and wasted work.

### Problem 5: De Morgan's law

```dart
void main() {
  for (bool a in [true, false]) {
    for (bool b in [true, false]) {
      bool left1 = !(a && b);
      bool right1 = !a || !b;
      bool match1 = left1 == right1;

      bool left2 = !(a || b);
      bool right2 = !a && !b;
      bool match2 = left2 == right2;

      print('a=$a, b=$b | !(a&&b)==(!a||!b)? $match1 | !(a||b)==(!a&&!b)? $match2');
    }
  }
}
```

Output:
```
a=true, b=true | !(a&&b)==(!a||!b)? true | !(a||b)==(!a&&!b)? true
a=true, b=false | !(a&&b)==(!a||!b)? true | !(a||b)==(!a&&!b)? true
a=false, b=true | !(a&&b)==(!a||!b)? true | !(a||b)==(!a&&!b)? true
a=false, b=false | !(a&&b)==(!a||!b)? true | !(a||b)==(!a&&!b)? true
```

Both pairs match in every combination. De Morgan's law is correct.

Why this matters: when refactoring conditions, you can flip `&&` and `||` if you also flip the negations. For example:

```dart
// "not (logged in and email verified)"
if (!(loggedIn && emailVerified)) { showLogin(); }

// equivalent: "not logged in OR email not verified"
if (!loggedIn || !emailVerified) { showLogin(); }
```

The second reads more naturally to many people. De Morgan's law lets you rewrite without changing behaviour.

---

**Next:** Let's wrap up with operators and expressions.

---

**Continue to:** `06-Operators.md`
