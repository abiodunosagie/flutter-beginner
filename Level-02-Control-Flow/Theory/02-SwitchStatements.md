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

### Problem 1: Convert if-chain to switch

Convert this if-chain into the **classic switch statement** form. Then convert it again into a **switch expression**.

```dart
void describe(String role) {
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

This switch is supposed to print a single line based on the day. It does not behave correctly. Find the bug, explain what happens, and fix it.

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

Write a function `String describeStatus(int code)` that takes an HTTP status code and returns one of these labels:

- `'Informational'` for 100, 101, 102, 103.
- `'Success'` for 200, 201, 204.
- `'Redirect'` for 301, 302, 304.
- `'Client error'` for 400, 401, 403, 404.
- `'Server error'` for 500, 502, 503, 504.
- `'Unknown'` for anything else.

Solve this twice: once with a classic switch using grouped cases, once with a switch expression.

### Problem 4: Traffic light advisor with enum

Define an enum `Light` with values `red`, `yellow`, `green`. Then write a function `String advise(Light light)` that returns:

- `'Stop and wait'` for red.
- `'Slow down and prepare to stop'` for yellow.
- `'Go safely'` for green.

Use a switch expression. The function must compile **without** a `default` case. Explain why this is possible.

### Problem 5: Mini calculator with safe division

Write a function `String calculate(double a, double b, String op)`. It supports `'+'`, `'-'`, `'*'`, `'/'`. The function returns:

- The arithmetic result as a string, like `'15.0'`.
- `'Cannot divide by zero'` if op is `/` and `b` is zero.
- `'Unknown operator'` for any other op.

Use a classic switch.

---

## Assignment Answers

### Problem 1: Convert if-chain to switch

**Classic switch:**

```dart
void describe(String role) {
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

  print(message);
}
```

How the conversion was done:

1. The variable being compared in every branch is `role`. It goes inside `switch (role)`.
2. Each `if (role == 'X')` becomes `case 'X':`.
3. The body of each `if` becomes the body of the matching `case`.
4. Each case ends with `break;` so we do not fall through to the next case.
5. The final `else` becomes `default:`.

**Switch expression form:**

```dart
void describe(String role) {
  String message = switch (role) {
    'admin'  => 'Full access',
    'editor' => 'Can edit content',
    'viewer' => 'Read only',
    _        => 'No access',
  };

  print(message);
}
```

How this is different:

1. The whole switch is on the right side of `=`, because it now **returns a value**.
2. There are no `case` keywords. Just the value, then `=>`, then the result.
3. There are no `break` statements. The expression form has no fall-through.
4. `_` replaces `default:`.
5. Notice we removed the temporary `String message;` declaration plus assignment, replaced by `String message = switch (...)`. Cleaner.

This second version is the more modern, more readable form when all you are doing is picking a value.

### Problem 2: Find the bug

**The bug:** The cases for `'Mon'` and `'Tue'` are missing `break` statements.

**What actually happens when `day == 'Mon'`:**

1. The switch matches `case 'Mon':` and runs `print('Monday')`.
2. There is no `break`, so execution **falls through** into `case 'Tue':` and runs `print('Tuesday')`.
3. There is still no `break`, so execution falls through into `case 'Wed':` and runs `print('Wednesday')`.
4. Finally `break` is hit and the switch exits.

Output: three lines instead of one:
```
Monday
Tuesday
Wednesday
```

**Fix:** add `break;` to every case.

```dart
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
```

This is exactly the trap we drilled in the lesson. In the classic switch form, a missing `break` is almost always a bug, and it is always silent at compile time. The compiler does not warn you. You only find out by running the code.

### Problem 3: HTTP status grouper

**Classic switch with grouped cases:**

```dart
String describeStatus(int code) {
  String label;

  switch (code) {
    case 100:
    case 101:
    case 102:
    case 103:
      label = 'Informational';
      break;
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
    case 504:
      label = 'Server error';
      break;
    default:
      label = 'Unknown';
  }

  return label;
}
```

How the grouping works:

When you stack multiple `case` lines on top of each other with no code between, they all fall through to the same body. This is the **only** time fall-through is intentional. The 4 informational codes all share one body, and so on.

**Switch expression form:**

```dart
String describeStatus(int code) {
  return switch (code) {
    100 || 101 || 102 || 103 => 'Informational',
    200 || 201 || 204        => 'Success',
    301 || 302 || 304        => 'Redirect',
    400 || 401 || 403 || 404 => 'Client error',
    500 || 502 || 503 || 504 => 'Server error',
    _                        => 'Unknown',
  };
}
```

In the expression form, you join multiple values with `||` (read as "or") on a single line. Much shorter than the stacked-case form, especially when the groups are large.

### Problem 4: Traffic light advisor with enum

```dart
enum Light { red, yellow, green }

String advise(Light light) {
  return switch (light) {
    Light.red    => 'Stop and wait',
    Light.yellow => 'Slow down and prepare to stop',
    Light.green  => 'Go safely',
  };
}
```

**Why no `default` is needed:**

An enum has a **fixed, finite** set of values. `Light` has exactly three: `red`, `yellow`, `green`. Our switch covers all three. Dart's compiler can see this. It knows there is no fourth case to worry about, so a `default` is unnecessary, and the code is **exhaustive**.

If you ever add a new value to the enum (say `Light.flashing`), the compiler will complain that the switch is no longer exhaustive. That is a very useful safety net. It forces you to update every switch in your codebase whenever the enum grows.

This is one of the strongest reasons to use enums plus switch in Flutter. The compiler becomes your assistant.

### Problem 5: Mini calculator with safe division

```dart
String calculate(double a, double b, String op) {
  switch (op) {
    case '+':
      return '${a + b}';
    case '-':
      return '${a - b}';
    case '*':
      return '${a * b}';
    case '/':
      if (b == 0) {
        return 'Cannot divide by zero';
      }
      return '${a / b}';
    default:
      return 'Unknown operator';
  }
}
```

A few things to notice:

1. **No `break` statements are needed.** Because every case ends with `return`, the function exits before fall-through can happen. `return` is even stronger than `break`: it leaves the entire function, not just the switch.
2. **The division case has its own internal check.** Switch only matches the operator. The "is b zero?" check is a separate concern, so it is a regular `if` statement inside the case.
3. **String interpolation `${...}`** wraps the arithmetic so the number is converted to a string for the return value.

Quick sanity test:

- `calculate(10, 2, '+')` returns `'12.0'`.
- `calculate(10, 0, '/')` returns `'Cannot divide by zero'`.
- `calculate(10, 2, '%')` returns `'Unknown operator'`.

---

**Next:** `03-ForLoops.md` to learn how to repeat actions.
