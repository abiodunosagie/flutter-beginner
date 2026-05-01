# Null Safety: Understanding "Nothing" in Dart

Null safety is one of Dart's most important features. Let's understand it step by step, like explaining to a 5-year-old!

---

## What is Null? (The Foundation)

### Think of Variables as Boxes

Imagine variables as boxes that hold things:

```
┌─────────────┐
│   "Alex"    │  ← String name = 'Alex';
└─────────────┘

┌─────────────┐
│     25      │  ← int age = 25;
└─────────────┘
```

### Now, What is Null?

`null` means **the box is empty** - there's nothing inside:

```
┌─────────────┐
│    EMPTY    │  ← String? name = null;
│  (nothing)  │
└─────────────┘
```

**Real-world analogy:**
- Your wallet has $50 → wallet = 50
- Your wallet is empty → wallet = null (not 0, but EMPTY)

---

## The Big Problem (Before Null Safety)

### Old Dart (Before Null Safety)

In old Dart, ANY variable could be null without warning:

```dart
// Old Dart - DANGEROUS!
String name = 'Alex';
name = null;  // ✅ Allowed! But causes crashes later

print(name.length);  // 💥 CRASH! Can't get length of null
```

**The problem:**
```
Your code runs fine...
Then suddenly: CRASH! 💥
"Null pointer exception"

You have to find the bug manually 😓
```

### New Dart (With Null Safety) - SAFE!

Now Dart protects you at compile time (before running):

```dart
// New Dart - SAFE!
String name = 'Alex';
name = null;  // ❌ ERROR! Compiler stops you immediately

// ✅ This is caught BEFORE your app runs!
```

---

## The Two Types of Variables

Dart now has TWO types of every variable:

### 1. Non-Nullable (Cannot be null)

**No question mark `?`** = "This box MUST have something"

```dart
// These CANNOT be null
String name = 'Alex';         // Must have a value
int age = 25;                 // Must have a value
bool isStudent = true;        // Must have a value

// ❌ These cause ERRORS:
String name2;                 // Error: Must initialize!
String name3 = null;          // Error: Can't be null!
```

**Visual:**
```
┌─────────────┐
│   "Alex"    │  ← String name (MUST have value)
└─────────────┘
     ✅ OK

┌─────────────┐
│    null     │  ← String name = null
└─────────────┘
     ❌ ERROR!
```

### 2. Nullable (Can be null)

**Question mark `?`** = "This box MIGHT be empty"

```dart
// These CAN be null
String? email;                // ✅ OK - starts as null
String? phone = null;         // ✅ OK - explicitly null
int? score;                   // ✅ OK - no value yet

// Later, you can give them values
email = 'alex@email.com';     // ✅ Now has value
phone = '555-1234';           // ✅ Now has value
```

**Visual:**
```
┌─────────────┐
│    null     │  ← String? email (can be empty)
└─────────────┘
     ✅ OK

┌─────────────┐
│"a@email.com"│  ← String? email = '...' (or has value)
└─────────────┘
     ✅ Also OK
```

---

## Think of `?` as "Maybe"

The question mark means "maybe null, maybe not":

```dart
String? name;     // Maybe null
int? age;         // Maybe null
bool? isActive;   // Maybe null
```

**In your head, read it as:**
- `String?` = "Maybe String, maybe null"
- `int?` = "Maybe int, maybe null"
- `bool?` = "Maybe bool, maybe null"

---

## Using Nullable Variables (The Safe Way)

### Problem: Can't Use Nullable Variables Directly

```dart
String? email = getUserEmail();  // Might be null!

// ❌ ERROR: Can't do this directly
print(email.length);  // What if email is null? Crash!

// Dart protects you: "You must check first!"
```

### Solution 1: Check if Null

```dart
String? email = getUserEmail();

// ✅ Check first
if (email != null) {
  // Inside here, Dart KNOWS email is not null
  print(email.length);  // ✅ Safe!
}
```

**What happens:**
```
Before check:  email is String? (maybe null)
After check:   email is String (definitely not null)
               ↑ Dart "promotes" it to non-nullable
```

### Solution 2: The Safe Call Operator `?.`

```dart
String? email = getUserEmail();

// ✅ Use ?. (safe call)
print(email?.length);

// What it means:
// "If email is not null, get length"
// "If email IS null, return null"
```

**Visual explanation:**
```dart
email?.length

Step 1: Is email null?
   ├─ No  → Get email.length (e.g., 15)
   └─ Yes → Return null (instead of crashing)
```

**Examples:**
```dart
String? email1 = 'alex@email.com';
print(email1?.length);  // 15 (email exists, so get length)

String? email2 = null;
print(email2?.length);  // null (email is null, so return null)
```

### Solution 3: Provide Default with `??`

The `??` operator means "use this if null":

```dart
String? savedName = getName();  // Might be null

// Use savedName, or 'Guest' if null
String displayName = savedName ?? 'Guest';

print(displayName);
// If savedName = 'Alex' → prints 'Alex'
// If savedName = null  → prints 'Guest'
```

**Think of it as a backup:**
```
┌─────────────┐
│   "Alex"    │  ← savedName has value
└─────────────┘
       ↓
Use "Alex" (no need for backup)


┌─────────────┐
│    null     │  ← savedName is null
└─────────────┘
       ↓
Use "Guest" (backup plan!)
```

**More examples:**
```dart
int? userAge = null;
int age = userAge ?? 18;  // Use 18 if null
print(age);  // 18

String? theme = null;
String appTheme = theme ?? 'dark';  // Default to 'dark'
print(appTheme);  // dark
```

### Solution 4: The Dangerous `!` (Force Unwrap)

The `!` means "I PROMISE this is not null (crash if I'm wrong)"

```dart
String? email = getEmail();

// ⚠️ DANGEROUS: Force unwrap with !
print(email!.length);

// What it means:
// "Trust me, email is NOT null"
// "If I'm wrong, CRASH the app!"
```

**When it's safe:**
```dart
String? email = 'alex@email.com';
print(email!.length);  // ✅ OK - we know it's not null
```

**When it crashes:**
```dart
String? email = null;
print(email!.length);  // 💥 CRASH! You said it's not null, but it is!
```

**Rule: Only use `!` when you're 100% sure it's not null!**

---

## Combining the Operators

You can combine `?.` and `??` for powerful patterns:

```dart
String? email = getEmail();

// Get length if email exists, otherwise use 0
int length = email?.length ?? 0;

// How it works:
// 1. email?.length → If email is null, this returns null
// 2. ?? 0 → If result is null, use 0

// Examples:
// email = 'alex@email.com' → length = 15
// email = null             → length = 0
```

**Another example:**
```dart
String? name = getUserName();

// Get uppercase name, or 'GUEST' if null
String displayName = name?.toUpperCase() ?? 'GUEST';

// If name = 'alex' → 'ALEX'
// If name = null   → 'GUEST'
```

---

## Real-World Examples

### Example 1: User Profile

```dart
class User {
  String name;        // ← Must have (required)
  int age;            // ← Must have (required)
  String? email;      // ← Optional (can be null)
  String? phone;      // ← Optional (can be null)

  User({
    required this.name,
    required this.age,
    this.email,   // Optional
    this.phone,   // Optional
  });
}

// Creating users:
var user1 = User(name: 'Alex', age: 25);  // ✅ OK (email/phone null)

var user2 = User(
  name: 'Sam',
  age: 30,
  email: 'sam@email.com',  // Providing email
);

// Using nullable fields safely:
print(user1.email?.length ?? 0);  // 0 (email is null)
print(user2.email?.length ?? 0);  // 14 (email exists)
```

### Example 2: Fetching Data

```dart
// Function might not find the user
String? findUserById(int id) {
  if (id == 1) {
    return 'Alex';
  }
  return null;  // User not found
}

// Using it safely:
String? user = findUserById(5);

if (user != null) {
  print('Found user: $user');
} else {
  print('User not found');
}

// Or with ??:
String displayName = findUserById(5) ?? 'Unknown User';
print(displayName);  // 'Unknown User'
```

### Example 3: Form Input

```dart
class LoginForm {
  String? email;     // User might not fill this yet
  String? password;  // User might not fill this yet

  bool canSubmit() {
    // Check both are filled
    return email != null && password != null;
  }

  void submit() {
    if (canSubmit()) {
      // Safe to use ! here (we checked above)
      login(email!, password!);
    } else {
      print('Please fill all fields');
    }
  }
}
```

---

## Quick Reference

### Operators Cheat Sheet

```dart
// ?  = Make variable nullable
String? name;  // Can be null

// ?.  = Safe call (won't crash if null)
name?.length;  // Returns null if name is null

// ??  = Provide default if null
name ?? 'Guest';  // Use 'Guest' if name is null

// ??= = Assign only if null
name ??= 'Default';  // Only assign if name is currently null

// !  = Force unwrap (dangerous!)
name!.length;  // "I promise name is not null" (crashes if wrong)
```

---

## Common Patterns

### Pattern 1: Optional Function Parameters

```dart
void greet({String? name, int? age}) {
  print('Hello ${name ?? "friend"}');
  print('Age: ${age ?? "unknown"}');
}

greet();  // Hello friend, Age: unknown
greet(name: 'Alex');  // Hello Alex, Age: unknown
greet(name: 'Alex', age: 25);  // Hello Alex, Age: 25
```

### Pattern 2: Chaining Safe Calls

```dart
class Address {
  String? city;
}

class User {
  Address? address;
}

User? user = getUser();

// Chain safe calls:
String? city = user?.address?.city;

// With default:
String displayCity = user?.address?.city ?? 'Unknown';
```

### Pattern 3: Late Variables

When you'll assign a value later (before using):

```dart
class MyWidget {
  late String name;  // I'll set this before using it

  void init() {
    name = 'Alex';  // ✅ Set it here
  }

  void display() {
    print(name);  // ✅ Safe (init was called first)
  }
}
```

---

## Practice Problems

### Problem 1: Fix the Error

```dart
// ❌ This has an error:
String name;
print(name);

// ✅ Fix option 1: Give it a value
String name = 'Alex';
print(name);

// ✅ Fix option 2: Make it nullable
String? name;
print(name);  // null
```

### Problem 2: Safe Email Display

```dart
String? email = getUserEmail();

// Display email length, or 'No email' if null
// Write your solution:

// Solution:
String message = email != null
    ? 'Email length: ${email.length}'
    : 'No email';

// Or shorter:
String message2 = 'Email length: ${email?.length ?? 0}';
```

### Problem 3: User Greeting

```dart
String? firstName = 'Alex';
String? lastName = null;

// Create a full name, or 'Guest' if both are null
// Your solution:

// Solution:
String fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
fullName = fullName.isEmpty ? 'Guest' : fullName;
print(fullName);  // Alex

// Or:
String name = firstName ?? lastName ?? 'Guest';
```

---

## Summary

### The Golden Rules

1. **Non-nullable by default** - Variables can't be null unless you add `?`
   ```dart
   String name = 'Alex';  // Can't be null
   String? email;         // Can be null
   ```

2. **Check before using** - Always check nullable variables
   ```dart
   if (email != null) {
     print(email.length);  // ✅ Safe
   }
   ```

3. **Use safe operators** - `?.` and `??` are your friends
   ```dart
   email?.length          // Safe call
   email ?? 'default'     // Default value
   ```

4. **Avoid `!`** - Only use when 100% sure
   ```dart
   email!.length  // ⚠️ Only if you're certain!
   ```

### Benefits of Null Safety

```
Before null safety:
  ✍️ Write code
  ▶️ Run app
  💥 CRASH! "Null pointer exception"
  🐛 Find the bug
  🔄 Fix and repeat

With null safety:
  ✍️ Write code
  ⚠️ Compiler shows error immediately
  ✅ Fix before running
  ▶️ Run app - no null crashes!
```

---

## Memory Tips

**Think of `?` as "Maybe Box":**
- `String` = Box MUST have string
- `String?` = Box MAYBE has string

**Remember the operators:**
- `?.` = "Safe peek in the box"
- `??` = "Use this if box is empty"
- `!` = "I promise box isn't empty (danger!)"

**The ladder of safety:**
```
Safest:  if (x != null) ...
  ↓
Safe:    x?.method()
  ↓
OK:      x ?? default
  ↓
Risky:   x!.method()  ← Use only when certain!
```

---

## Common Questions

**Q: When should I use `String` vs `String?`?**

A: Ask yourself: "Could this ever be missing/unknown?"
- User's name (required at signup) → `String`
- User's nickname (optional) → `String?`
- API response (might fail) → `String?`

**Q: Is `null` the same as `0` or empty string `''`?**

A: No!
- `null` = No value at all (empty box)
- `0` = The number zero (box contains 0)
- `''` = Empty string (box contains empty text)

**Q: Why do I need null safety? Old Dart worked fine!**

A: Old Dart caused crashes at runtime. New Dart catches bugs at compile time (before running). Safer apps, happier users!

---

## Assignment

### Problem 1: Spot what compiles and what does not

For each declaration, predict whether the line is legal.

```dart
String name = null;            // 1
String? nickname = null;       // 2
int age = null;                // 3
int? grade;                    // 4
double price;                  // 5
String city = '';              // 6
```

### Problem 2: Add the right `?` and `!`

This code does not compile. Add `?` (to types) and `!` (to expressions) where appropriate to make it work. Do not change the logic.

```dart
String getName(String input) {
  if (input.isEmpty) return null;
  return input.toUpperCase();
}

void main() {
  String result = getName('ada');
  print(result.length);
}
```

### Problem 3: Predict the output

```dart
void main() {
  String? a = 'hello';
  String? b;
  String? c = null;

  print(a ?? 'default');
  print(b ?? 'default');
  print(c ?? 'default');

  print(a?.length);
  print(b?.length);

  b ??= 'set now';
  print(b);

  b ??= 'try again';
  print(b);
}
```

### Problem 4: Safe integer parser

Dart's `int.parse('123')` returns 123, but `int.parse('not a number')` **throws** an exception. There is also `int.tryParse(...)` that returns `int?` (null on failure).

Write a function `int parseOrZero(String text)` that returns the parsed integer, or 0 if parsing fails. Use `??` and `tryParse`.

Test on `'42'`, `'7'`, `''`, and `'hello'`. Expected: 42, 7, 0, 0.

### Problem 5: Build a profile getter

You have:

```dart
class User {
  String? name;
  int? age;
}
```

(Classes come in Level 4. Just read this for now.)

Write a function `String greetUser(User? user)` that returns:

- `'Hello, $name (age $age)'` if everything is non-null.
- `'Hello, $name'` if user and name are non-null but age is null.
- `'Hello, friend'` if user is non-null but name is null.
- `'No user signed in'` if user itself is null.

You will need `?.`, `??`, and a couple of explicit null checks. Walk the cases in your answer.

---

## Assignment Answers

### Problem 1: Spot what compiles and what does not

```dart
String name = null;            // 1. ERROR: String cannot be null
String? nickname = null;       // 2. ok: String? can be null
int age = null;                // 3. ERROR: int cannot be null
int? grade;                    // 4. ok: nullable, defaults to null
double price;                  // 5. ERROR: non-nullable cannot be uninitialised
String city = '';              // 6. ok: empty string is not null
```

The rules:

- A type without `?` cannot be null. If you do not give it a value, the compiler refuses, unless you mark it `late`.
- A type with `?` can be null, and defaults to null if not initialised.
- An empty string `''` is **not** null. It is a real string with zero characters.

### Problem 2: Add the right `?` and `!`

```dart
String? getName(String input) {
  if (input.isEmpty) return null;
  return input.toUpperCase();
}

void main() {
  String? result = getName('ada');
  print(result!.length);
}
```

What was added and why:

1. **Return type became `String?`.** The function can return null, so the type must say so.
2. **`result` is `String?`** because it stores the function's return value, which is nullable.
3. **`result!.length`** uses the bang `!` to assert "trust me, this is not null right now". We know it is not null because we passed `'ada'` (non-empty).

A safer version without `!`:

```dart
String? result = getName('ada');
if (result != null) {
  print(result.length);
}
```

After the null check, Dart "knows" `result` is not null inside the if, and the dot access is safe without `!`. This is called **flow analysis**.

### Problem 3: Predict the output

```
hello
default
default
5
null
set now
set now
```

Trace each:

1. `a ?? 'default'`: a is `'hello'`, not null. Result is `'hello'`.
2. `b ?? 'default'`: b is null. Result is `'default'`.
3. `c ?? 'default'`: c is null. Result is `'default'`.
4. `a?.length`: a is `'hello'`. Length is 5. Result is 5.
5. `b?.length`: b is null. The whole expression is null. Result is null.
6. `b ??= 'set now'`: b is null, so it gets set to `'set now'`. Then we print b, which is `'set now'`.
7. `b ??= 'try again'`: b is no longer null (we just set it). The assignment is skipped. b stays `'set now'`. Print again.

The lesson: `??=` only assigns when the variable is null. Once it has a value, repeated `??=` calls do nothing.

### Problem 4: Safe integer parser

```dart
int parseOrZero(String text) {
  return int.tryParse(text) ?? 0;
}

void main() {
  print(parseOrZero('42'));      // 42
  print(parseOrZero('7'));       // 7
  print(parseOrZero(''));        // 0
  print(parseOrZero('hello'));   // 0
}
```

How the one-liner works:

- `int.tryParse(text)` returns the parsed int if the text is a valid number. Otherwise it returns null.
- `?? 0` falls back to 0 when the left side is null.

This is a perfect use of nullable types. The "I might fail" return type forces the caller to handle the null case. The `??` operator handles it cleanly in one expression.

The contrast: `int.parse` would throw an exception, which would crash unless you wrap it in try/catch. `tryParse` is much friendlier.

### Problem 5: Build a profile getter

```dart
class User {
  String? name;
  int? age;
}

String greetUser(User? user) {
  if (user == null) return 'No user signed in';
  if (user.name == null) return 'Hello, friend';
  if (user.age == null) return 'Hello, ${user.name}';
  return 'Hello, ${user.name} (age ${user.age})';
}
```

How each case is reached:

1. **First, check if `user` itself is null.** If so, no point looking inside. Return the global default.
2. **Then check if `user.name` is null.** Inside this branch, we know user is non-null. We can read `user.name`. If it is null, return the friend version.
3. **Then check if `user.age` is null.** At this point, user and name are both non-null. We can use `user.name` directly.
4. **If we get here, everything is non-null.** Return the full version.

Note how each check narrows the unknown. After the first early-return, Dart knows `user` is non-null. After the second, both `user` and `user.name` are non-null. This is the "guard clause" pattern from earlier, applied to nullables.

A version using `??`:

```dart
String greetUser(User? user) {
  if (user == null) return 'No user signed in';

  String name = user.name ?? 'friend';

  if (user.age == null) return 'Hello, $name';
  return 'Hello, $name (age ${user.age})';
}
```

This is shorter but slightly different. It always prints `'friend'` instead of just dropping the part. Whether that is better depends on the requirements. The first version follows the spec exactly.

---

**Practice these concepts and null safety will become second nature.**
