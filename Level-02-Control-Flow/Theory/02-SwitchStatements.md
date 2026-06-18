# Switch Statements: Picking One Out of Many

## Why This Topic Exists

You already know `if-else if-else`. It works. So why learn switch?

Because when you are checking **one variable** against **many exact values**, `if-else` becomes ugly:

```dart
if (day == 'Monday') print('Start');
else if (day == 'Tuesday') print('Day 2');
else if (day == 'Wednesday') print('Day 3');
else if (day == 'Thursday') print('Day 4');
else if (day == 'Friday') print('TGIF');
```

Notice how `day ==` is repeated five times. That repetition is a smell. Switch removes it.

The same logic in switch:

```dart
switch (day) {
  case 'Monday':    print('Start'); break;
  case 'Tuesday':   print('Day 2'); break;
  case 'Wednesday': print('Day 3'); break;
  case 'Thursday':  print('Day 4'); break;
  case 'Friday':    print('TGIF');  break;
}
```

Cleaner. That is the entire reason switch exists.

---

## The Mental Model

Think of switch like a **post office sorter**.

Letters (the value) come in. The sorter looks at the destination on each letter and drops it into the matching slot. If the destination is not on the wall, it drops into the "everything else" slot at the end.

- The **value** is what you are checking.
- A **case** is one slot on the wall.
- The **default** is the "everything else" slot.

That is switch.

---

## The Anatomy

```dart
switch (value) {     // 1. The value to check
  case match1:       // 2. One possible match
    // code to run
    break;           // 3. Exit. This is mandatory.
  case match2:
    // code
    break;
  default:           // 4. Optional. Runs if nothing matched.
    // code
}
```

Four pieces. Learn them in this order:
1. The value goes in the parentheses after the keyword `switch`.
2. Each `case` is followed by one exact value to compare against.
3. After the code in each case, you must write `break;`. We will explain why in a moment.
4. `default` runs only if no case matched. It is optional, but include it anyway, like a safety net.

---

## The `break` Trap (This Is Where Beginners Fail)

If you forget `break`, the program does not stop at the matching case. It keeps running into the next case. This is called **fall-through**, and it is almost always a bug.

Watch this carefully:

```dart
int num = 1;

switch (num) {
  case 1:
    print('One');
    // forgot break
  case 2:
    print('Two');
    break;
}
```

What prints? Most beginners say `One`. The actual output is:

```
One
Two
```

Both lines run. `case 1` matched, printed `One`, and then **fell through** into `case 2` because there was no `break` to stop it.

The fix is simple: always end every case with `break`.

```dart
switch (num) {
  case 1:
    print('One');
    break;     // stops here
  case 2:
    print('Two');
    break;
}
```

Now only `One` prints.

---

## How a Switch Runs, Step by Step

Imagine `grade = 'B'` and this code:

```dart
switch (grade) {
  case 'A': print('Excellent'); break;
  case 'B': print('Good');      break;
  case 'C': print('Pass');      break;
  default:  print('Fail');
}
```

Execution:

| Step | What happens |
|------|--------------|
| 1 | Look at `grade`. It is `'B'`. |
| 2 | Compare to `'A'`. No match. Move on. |
| 3 | Compare to `'B'`. Match! Run `print('Good')`. |
| 4 | Hit `break`. Exit the switch. |
| 5 | Continue with code after the switch. |

`'C'` and `default` are never even checked once a match is found.

---

## Grouping Cases

When several values should run the same code, stack the cases on top of each other with no code between them:

```dart
String day = 'Saturday';

switch (day) {
  case 'Saturday':
  case 'Sunday':
    print('Weekend');
    break;
  case 'Monday':
  case 'Tuesday':
  case 'Wednesday':
  case 'Thursday':
  case 'Friday':
    print('Weekday');
    break;
  default:
    print('Unknown day');
}
```

Both `'Saturday'` and `'Sunday'` end up printing `'Weekend'`. This is the **only** time fall-through is intentional and useful.

---

## Switch Works With Many Types

### With integers

```dart
int month = 3;
switch (month) {
  case 1: print('January');  break;
  case 2: print('February'); break;
  case 3: print('March');    break;
  default: print('Unknown');
}
```

### With strings

```dart
String role = 'admin';
switch (role) {
  case 'admin':  print('Full access');    break;
  case 'editor': print('Can edit');       break;
  case 'viewer': print('Read only');      break;
  default:       print('No access');
}
```

### With enums (the cleanest use)

We will cover enums fully in Level 4. For now, an enum is a fixed set of named values:

```dart
enum TrafficLight { red, yellow, green }

TrafficLight light = TrafficLight.red;

switch (light) {
  case TrafficLight.red:    print('Stop');   break;
  case TrafficLight.yellow: print('Slow');   break;
  case TrafficLight.green:  print('Go');     break;
}
```

Notice there is no `default`. Dart knows the enum has only three values, and we covered all three. The compiler is happy.

This is why switch and enums are best friends. Remember this for Flutter, you will use it constantly.

---

## The Modern Switch Expression (Dart 3 and newer)

Dart 3 added a new form of switch that **returns a value** instead of just doing work. It is shorter and safer.

```dart
String name = switch (dayNum) {
  1 => 'Monday',
  2 => 'Tuesday',
  3 => 'Wednesday',
  4 => 'Thursday',
  5 => 'Friday',
  6 => 'Saturday',
  7 => 'Sunday',
  _ => 'Invalid',
};
```

Read it as: "Set `name` to whatever this switch returns based on `dayNum`."

Differences from the classic form:
- No `case` keyword. Just the value, then `=>`, then the result.
- No `break`. There is no fall-through, so you do not need it.
- `_` is the default catch-all.
- The whole switch returns one value, like an expression.

You can also combine cases with `||`:

```dart
String type = switch (day) {
  'Saturday' || 'Sunday' => 'Weekend',
  _ => 'Weekday',
};
```

### When to use which form

| You want to... | Use |
|----------------|-----|
| Return or assign a value | switch expression (`=>`) |
| Run statements (print, call functions, update variables) | classic switch with `case` and `break` |

If your switch only has `print` calls and ends each case with `break`, the classic form is fine. If you find yourself writing `result = ...` in every case, you probably want the expression form instead.

---

## When To Use Switch vs If-Else

Switch wins when:
- You compare **one** variable.
- You compare against **many** exact values.

If-else wins when:
- You compare **ranges**, like `score >= 90`.
- You combine multiple conditions, like `age > 18 && hasLicense`.
- You compare **different** variables in each branch.

Trying to use switch for ranges is a common mistake:

```dart
// This does NOT compile. Switch needs exact values.
switch (age) {
  case > 18: print('Adult'); break;
}
```

Use if-else for that. Switch is for "is this value exactly equal to one of these options?"

---

## Worked Examples

### 1. Calculator

```dart
void main() {
  int a = 10;
  int b = 3;
  String op = '+';

  switch (op) {
    case '+': print('${a + b}'); break;
    case '-': print('${a - b}'); break;
    case '*': print('${a * b}'); break;
    case '/':
      if (b != 0) {
        print('${a / b}');
      } else {
        print('Cannot divide by zero');
      }
      break;
    default:
      print('Unknown operator');
  }
}
```

### 2. Season finder using switch expression

```dart
void main() {
  int month = 7;

  String season = switch (month) {
    12 || 1 || 2  => 'Winter',
    3 || 4 || 5   => 'Spring',
    6 || 7 || 8   => 'Summer',
    9 || 10 || 11 => 'Autumn',
    _             => 'Invalid month',
  };

  print(season);
}
```

### 3. Traffic light advice

```dart
enum Light { red, yellow, green }

void main() {
  Light current = Light.yellow;

  String advice = switch (current) {
    Light.red    => 'Stop and wait',
    Light.yellow => 'Slow down',
    Light.green  => 'Go safely',
  };

  print(advice);
}
```

---

## Why This Matters In Flutter

Once you reach Flutter, you will use switch all the time. The most common case is rendering different UI based on app state.

Tiny preview, do not run this yet:

```dart
enum LoadingState { loading, success, error }

Widget buildScreen(LoadingState state) {
  return switch (state) {
    LoadingState.loading => CircularProgressIndicator(),
    LoadingState.success => ProductList(),
    LoadingState.error   => ErrorMessage(),
  };
}
```

This pattern, "look at the state, return the matching widget", is the foundation of every modern Flutter app. That is why switch is worth mastering now.

---

## Common Mistakes

1. **Forgetting `break`** in classic switch. Always write it. Always.
2. **Trying to use ranges** like `case > 10`. Switch only matches exact values. Use if-else for ranges.
3. **Forgetting `default`**. Without it, an unmatched value silently does nothing. That is a bug waiting to happen.
4. **Mixing types**. The case values must match the type of the switched variable. You cannot switch on a `String` and write `case 1:`.

---

## Recap In One Minute

- Switch picks one branch based on an exact match.
- Classic form needs `case`, code, then `break`. Optional `default` at the end.
- Modern form uses `=>` and returns a value. No `break` needed.
- Use switch for many exact matches against one variable.
- Use if-else for ranges and complex conditions.

---

## Quick Quiz

**Q1.** What prints?
```dart
int x = 1;
switch (x) {
  case 1: print('A');
  case 2: print('B'); break;
  case 3: print('C'); break;
}
```

<details>
<summary>Answer</summary>
`A` and then `B`. Case 1 had no `break`, so execution fell through into case 2.
</details>

**Q2.** Rewrite this if-chain as a switch:
```dart
if (color == 'red')   stop();
if (color == 'green') go();
if (color == 'amber') slow();
```

<details>
<summary>Answer</summary>

```dart
switch (color) {
  case 'red':   stop(); break;
  case 'green': go();   break;
  case 'amber': slow(); break;
}
```
</details>

**Q3.** Convert this to a switch expression:
```dart
String label;
switch (n) {
  case 1: label = 'one';   break;
  case 2: label = 'two';   break;
  default: label = 'many';
}
```

<details>
<summary>Answer</summary>

```dart
String label = switch (n) {
  1 => 'one',
  2 => 'two',
  _ => 'many',
};
```
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before reading the answer. Everything uses `switch` with variables in `main`, no functions needed yet. (Enums, which pair beautifully with switch, come in Level 4.)

### Problem 1: Convert an if-chain to switch

Here is an if-chain in `main`. Rewrite it two ways: first as a **classic switch statement**, then as a **switch expression**. Both should put the right text in `message` and print it.

```dart
void main() {
  String role = 'editor';
  String message;

  if (role == 'admin') {
    message = 'Full access';
  } else if (role == 'editor') {
    message = 'Can edit content';
  } else if (role == 'viewer') {
    message = 'Read only';
  } else {
    message = 'No access';
  }

  print(message);
}
```

### Problem 2: Find the bug

This switch should print one line, but it does not. Find the bug, explain what happens, and fix it.

```dart
void main() {
  String day = 'Mon';

  switch (day) {
    case 'Mon':
      print('Monday');
    case 'Tue':
      print('Tuesday');
    case 'Wed':
      print('Wednesday');
      break;
    default:
      print('Unknown');
  }
}
```

### Problem 3: HTTP status grouper

In `main`, make `int code = 404`. Put the right label in `String label` using a **classic switch with grouped cases**, then print it. Use these groups:

- `'Success'` for 200, 201, 204.
- `'Redirect'` for 301, 302, 304.
- `'Client error'` for 400, 401, 403, 404.
- `'Server error'` for 500, 502, 503.
- `'Unknown'` for anything else.

Then write it again as a **switch expression** using `||` to group values.

### Problem 4: Menu command (switch expression)

In `main`, make `String command = 'pause'`. Use a **switch expression** to set `String action` to:

- `'Playing'` for `'play'`.
- `'Paused'` for `'pause'`.
- `'Stopped'` for `'stop'`.
- `'Unknown command'` for anything else.

Print `action`.

### Problem 5: Mini calculator with safe division

In `main`, make `double a = 10`, `double b = 0`, and `String op = '/'`. Use a **classic switch** to put the answer in `String result`, then print it:

- For `'+'`, `'-'`, `'*'`: the result, like `'12.0'`.
- For `'/'`: the result, unless `b` is 0, then `'Cannot divide by zero'`.
- For anything else: `'Unknown operator'`.

---

## Assignment Answers

### Problem 1: Convert an if-chain to switch

**Classic switch:**

```dart
void main() {
  String role = 'editor';
  String message;

  switch (role) {
    case 'admin':
      message = 'Full access';
      break;
    case 'editor':
      message = 'Can edit content';
      break;
    case 'viewer':
      message = 'Read only';
      break;
    default:
      message = 'No access';
  }

  print(message);   // Can edit content
}
```

How the conversion works:

1. The variable compared in every branch is `role`, so it goes in `switch (role)`.
2. Each `if (role == 'X')` becomes `case 'X':`.
3. Each case ends with `break;` so it does not fall through.
4. The final `else` becomes `default:`.

**Switch expression:**

```dart
void main() {
  String role = 'editor';

  String message = switch (role) {
    'admin'  => 'Full access',
    'editor' => 'Can edit content',
    'viewer' => 'Read only',
    _        => 'No access',
  };

  print(message);   // Can edit content
}
```

This form **returns a value**, so the whole switch sits on the right of `=`. No `case`, no `break`, and `_` is the catch-all. Shorter and cleaner when you are just picking a value.

### Problem 2: Find the bug

**The bug:** the `'Mon'` and `'Tue'` cases are missing `break`.

When `day` is `'Mon'`:

1. It matches `case 'Mon':` and prints `Monday`.
2. No `break`, so it falls through into `case 'Tue':` and prints `Tuesday`.
3. Still no `break`, so it falls through into `case 'Wed':` and prints `Wednesday`, then finally hits `break`.

So it wrongly prints three lines:

```
Monday
Tuesday
Wednesday
```

**Fix:** add `break;` to every case.

```dart
void main() {
  String day = 'Mon';

  switch (day) {
    case 'Mon':
      print('Monday');
      break;
    case 'Tue':
      print('Tuesday');
      break;
    case 'Wed':
      print('Wednesday');
      break;
    default:
      print('Unknown');
  }
}
```

Now it prints just `Monday`. A missing `break` in a classic switch is almost always a bug, and the compiler does not warn you, so train your eye to check for it.

### Problem 3: HTTP status grouper

**Classic switch with grouped cases:**

```dart
void main() {
  int code = 404;
  String label;

  switch (code) {
    case 200:
    case 201:
    case 204:
      label = 'Success';
      break;
    case 301:
    case 302:
    case 304:
      label = 'Redirect';
      break;
    case 400:
    case 401:
    case 403:
    case 404:
      label = 'Client error';
      break;
    case 500:
    case 502:
    case 503:
      label = 'Server error';
      break;
    default:
      label = 'Unknown';
  }

  print(label);   // Client error
}
```

Stacking `case` lines with no code between them makes them share one body. This is the one time fall-through is on purpose.

**Switch expression:**

```dart
void main() {
  int code = 404;

  String label = switch (code) {
    200 || 201 || 204 => 'Success',
    301 || 302 || 304 => 'Redirect',
    400 || 401 || 403 || 404 => 'Client error',
    500 || 502 || 503 => 'Server error',
    _ => 'Unknown',
  };

  print(label);   // Client error
}
```

In the expression form you join values with `||` on one line, which is much shorter than stacking cases.

### Problem 4: Menu command (switch expression)

```dart
void main() {
  String command = 'pause';

  String action = switch (command) {
    'play'  => 'Playing',
    'pause' => 'Paused',
    'stop'  => 'Stopped',
    _       => 'Unknown command',
  };

  print(action);   // Paused
}
```

The switch expression checks `command` against each value and gives back the matching text. `_` catches anything not listed.

> Sneak peek: in Level 4 you will meet **enums** (a fixed set of named values). When you switch over an enum and cover every value, Dart lets you skip the `_` catch-all entirely, because it knows you handled them all. That is a great safety feature to look forward to.

### Problem 5: Mini calculator with safe division

```dart
void main() {
  double a = 10;
  double b = 0;
  String op = '/';

  String result;

  switch (op) {
    case '+':
      result = '${a + b}';
      break;
    case '-':
      result = '${a - b}';
      break;
    case '*':
      result = '${a * b}';
      break;
    case '/':
      if (b == 0) {
        result = 'Cannot divide by zero';
      } else {
        result = '${a / b}';
      }
      break;
    default:
      result = 'Unknown operator';
  }

  print(result);   // Cannot divide by zero
}
```

Things to notice:

1. The switch only matches the **operator**. The "is b zero?" check is a separate `if` inside the `/` case.
2. Each case ends with `break;` so they do not fall through.
3. `${ ... }` turns each calculation into text for the `result` box.

With `a = 10`, `b = 0`, `op = '/'`, it prints `Cannot divide by zero`. Change `b` to `2` and it would print `5.0`.

---

**Next:** `03-ForLoops.md` to learn how to repeat actions.
