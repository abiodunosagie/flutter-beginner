# Level 01 Checkpoint: Dart Fundamentals

Before moving to Level 02, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Variables & Types
Can you explain what each line does?

```dart
var name = 'Flutter';
String greeting = 'Hello';
final age = 25;
const pi = 3.14159;
```

**Check yourself:**
- [ ] I know the difference between `var` and explicit types
- [ ] I know when to use `final` vs `const`
- [ ] I know what happens if I try to change a `final` variable

---

### 2. Basic Data Types
What type is each variable?

```dart
var a = 42;           // Type: ____
var b = 3.14;         // Type: ____
var c = 'Hello';      // Type: ____
var d = true;         // Type: ____
var e = [1, 2, 3];    // Type: ____
```

<details>
<summary>Check Answers</summary>

- a = `int`
- b = `double`
- c = `String`
- d = `bool`
- e = `List<int>`

</details>

---

### 3. Null Safety
What's wrong with this code?

```dart
String? name;
print(name.length);
```

**Check yourself:**
- [ ] I understand why this causes an error
- [ ] I know at least 2 ways to fix it
- [ ] I know what `?` and `!` and `??` mean

---

### 4. String Operations
Can you predict the output?

```dart
var name = 'Flutter';
print(name.toUpperCase());
print(name.substring(0, 4));
print('Hello, $name!');
print('2 + 2 = ${2 + 2}');
```

<details>
<summary>Check Answers</summary>

```
FLUTTER
Flut
Hello, Flutter!
2 + 2 = 4
```

</details>

---

## Hands-On Check

### Task 1: Create a Product Variable
Without looking at notes, create variables for a product:

```dart
// Create these variables:
// - Product name (can't change)
// - Price (can change)
// - In stock status
// - Optional description (might be null)
```

<details>
<summary>Example Solution</summary>

```dart
final name = 'T-Shirt';
var price = 29.99;
var inStock = true;
String? description;
```

</details>

---

### Task 2: Fix This Code
This code has 3 errors. Find and fix them:

```dart
const price = 29.99;
price = 19.99;

String name;
print(name);

var count = '5';
var total = count + 10;
```

<details>
<summary>Solutions</summary>

1. Can't reassign `const` - use `var` instead
2. `name` is not initialized - add `= ''` or make it nullable
3. Can't add String and int - parse the string: `int.parse(count) + 10`

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Variable | _________________ |
| Data type | _________________ |
| Null safety | _________________ |
| String interpolation | _________________ |
| final vs const | _________________ |

---

## Ready for Level 02?

### I can confidently:
- [ ] Declare variables with `var`, `final`, and `const`
- [ ] Use all basic data types (int, double, String, bool)
- [ ] Work with nullable types using `?`, `!`, and `??`
- [ ] Use string interpolation with `$` and `${}`
- [ ] Explain why null safety matters

### Capstone Progress:
- [ ] I created the Product model with basic properties
- [ ] My Product class has the required fields (name, price, description, etc.)

---

## If You're Stuck

**Feeling unsure about something?**
1. Re-read the Theory files for that topic
2. Try the exercises again without looking at solutions
3. Practice by creating your own examples
4. Move on - sometimes the next level makes things clearer!

**Common sticking points at this level:**
- Null safety can feel confusing at first - that's normal!
- The difference between `final` and `const` becomes clearer with practice
- String interpolation is a superpower - use it everywhere!

---

**Ready to level up? Head to Level 02: Control Flow!**
