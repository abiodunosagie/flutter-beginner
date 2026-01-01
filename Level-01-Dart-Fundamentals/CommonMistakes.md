# Level 01: Common Mistakes

Learn from these common beginner errors so you don't make them yourself!

---

## Mistake #1: Trying to Change a `final` Variable

```dart
// ❌ WRONG
final name = 'John';
name = 'Jane';  // Error: Can't assign to a final variable

// ✅ RIGHT
var name = 'John';
name = 'Jane';  // Works! var can be reassigned
```

**Remember:** `final` = set once, never changes. Use `var` if you need to change it.

---

## Mistake #2: Confusing `final` and `const`

```dart
// ❌ WRONG - const with runtime value
const now = DateTime.now();  // Error: Not a compile-time constant

// ✅ RIGHT
final now = DateTime.now();  // Works! final can hold runtime values
```

**Rule:**
- `const` = value known at compile time (before app runs)
- `final` = value set once at runtime (when app runs)

---

## Mistake #3: Using Wrong Quote Marks

```dart
// ❌ WRONG - smart quotes from Word/Notes
var name = "John";  // These are curly quotes, not straight quotes!

// ✅ RIGHT
var name = 'John';  // Single straight quotes
var name = "John";  // Double straight quotes
```

**Tip:** Always code in a proper code editor, not Word or Notes!

---

## Mistake #4: Forgetting Null Safety

```dart
// ❌ WRONG
String name;
print(name.length);  // Error: name might be null

// ✅ RIGHT - Option 1: Initialize it
String name = '';
print(name.length);

// ✅ RIGHT - Option 2: Make it nullable and check
String? name;
print(name?.length ?? 0);
```

---

## Mistake #5: Using Wrong Type for Numbers

```dart
// ❌ WRONG
int price = 29.99;  // Error: double can't be assigned to int

// ✅ RIGHT
double price = 29.99;  // Use double for decimals
int quantity = 5;      // Use int for whole numbers
```

---

## Mistake #6: Forgetting the `$` in String Interpolation

```dart
// ❌ WRONG
var name = 'John';
print('Hello, name!');  // Prints: Hello, name!

// ✅ RIGHT
var name = 'John';
print('Hello, $name!');  // Prints: Hello, John!
```

---

## Mistake #7: Wrong Braces in Interpolation

```dart
// ❌ WRONG
print('Total: $price * quantity');  // Only $price is interpolated

// ✅ RIGHT
print('Total: ${price * quantity}');  // Whole expression is evaluated
```

**Rule:** Use `$variable` for simple variables, `${expression}` for calculations.

---

## Mistake #8: Case Sensitivity Errors

```dart
// ❌ WRONG
var Name = 'John';
print(name);  // Error: name is not defined (capital N vs lowercase n)

// ✅ RIGHT
var name = 'John';
print(name);
```

**Dart is case-sensitive:** `name`, `Name`, and `NAME` are three different things!

---

## Mistake #9: Missing Semicolons

```dart
// ❌ WRONG
var name = 'John'
var age = 25  // Error: Expected ';'

// ✅ RIGHT
var name = 'John';
var age = 25;
```

---

## Mistake #10: Type Mismatch

```dart
// ❌ WRONG
String count = 5;        // Error: int can't be assigned to String
int name = 'John';       // Error: String can't be assigned to int

// ✅ RIGHT
int count = 5;
String name = 'John';

// If you need to convert:
String countStr = count.toString();  // int to String
int parsed = int.parse('5');         // String to int
```

---

## Quick Reference: When to Use What

| Use Case | Type | Example |
|----------|------|---------|
| Whole numbers | `int` | `int age = 25;` |
| Decimals | `double` | `double price = 29.99;` |
| Text | `String` | `String name = 'John';` |
| Yes/No | `bool` | `bool isActive = true;` |
| Will change | `var` | `var count = 0;` |
| Won't change | `final` | `final id = '123';` |
| Compile-time constant | `const` | `const pi = 3.14159;` |
| Might be null | `Type?` | `String? nickname;` |

---

**Still stuck? Re-read the Theory files or ask for help!**
