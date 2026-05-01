# Part 2: The Four Basic Data Types

Now that you know what variables are, let's learn about the different TYPES of data you can store.

---

## The Four Basic Types

Dart has four fundamental types you'll use constantly:

### 1. String - Text

**Strings** hold text. Any characters between quotes.

```dart
String firstName = 'Alex';
String lastName = "Smith";      // Single or double quotes work
String message = 'Hello, World!';
String empty = '';              // Empty string is valid
```

### 2. int - Whole Numbers

**int** (integer) holds whole numbers. No decimal points.

```dart
int age = 25;
int year = 2024;
int temperature = -10;          // Can be negative
int million = 1000000;
int zero = 0;
```

### 3. double - Decimal Numbers

**double** holds numbers with decimal points.

```dart
double price = 19.99;
double pi = 3.14159;
double temperature = 98.6;
double negative = -273.15;
double whole = 42.0;            // Can end in .0
```

### 4. bool - True/False

**bool** (boolean) holds only two values: `true` or `false`.

```dart
bool isLoggedIn = true;
bool hasPermission = false;
bool isAdult = true;
```

---

## Visual Summary

```
┌──────────────────────────────────────────────────────┐
│                    DATA TYPES                         │
├──────────────────────────────────────────────────────┤
│                                                      │
│   String     "Hello"   "Alex"   "123"   ""          │
│   ───────    Text, characters, words                │
│                                                      │
│   int        42   -10   0   1000000                 │
│   ───        Whole numbers, no decimals             │
│                                                      │
│   double     3.14   -0.5   100.0   19.99           │
│   ──────     Decimal numbers                        │
│                                                      │
│   bool       true   false                           │
│   ────       Yes/no, on/off, true/false            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Using All Four Types Together

```dart
void main() {
  String name = 'Alex';
  int age = 25;
  double height = 1.75;
  bool isStudent = true;

  print('Name: $name');
  print('Age: $age');
  print('Height: $height meters');
  print('Is student: $isStudent');
}
```

**Output:**
```
Name: Alex
Age: 25
Height: 1.75 meters
Is student: true
```

---

## Type Safety

Dart is **type-safe**. Once you declare a variable's type, it can only hold that type.

```dart
void main() {
  int age = 25;

  age = 30;       // ✅ OK - int can hold int
  age = 'thirty'; // ❌ ERROR - int can't hold String
}
```

This prevents bugs:
```dart
// In a type-unsafe language, this might "work" and cause problems later
int price = '19.99';  // ❌ Dart stops this immediately
```

---

## Practice Exercise

Create a complete user profile with:
- Name (String)
- Age (int)
- Account balance (double)
- Is verified (bool)

Print all the information.

---

## Quick Quiz

**Q1:** What type would you use for someone's name?

<details>
<summary>Answer</summary>
`String` - because names are text.
</details>

**Q2:** What type for someone's age?

<details>
<summary>Answer</summary>
`int` - because age is a whole number.
</details>

**Q3:** What's wrong here?
```dart
int price = 19.99;
```

<details>
<summary>Answer</summary>
`19.99` is a decimal, but `int` only holds whole numbers. Should be `double price = 19.99;`
</details>

---

## Assignment

### Problem 1: Pick the right type

For each value below, write the correct Dart type. Be specific.

1. The number 42
2. The number 3.14
3. The text "Hello"
4. The value true
5. The number -100
6. The number 0.0
7. The text "42" (in quotes)
8. The number 1000000

### Problem 2: Type detective

What type does each variable have? Just from looking, no running.

```dart
var a = 'Flutter';
var b = 100;
var c = 99.9;
var d = false;
var e = 'true';
var f = 0;
```

### Problem 3: Type mismatch hunt

Each line has a type problem. Identify it and fix it.

```dart
int score = 85.5;
String age = 25;
bool isReady = 1;
double price = "19.99";
```

### Problem 4: Convert between types

Write code that does each conversion. Then print the result and its type using `.runtimeType`.

1. Convert the int `42` to a String.
2. Convert the String `"99"` to an int.
3. Convert the double `3.7` to an int (rounded down).
4. Convert the int `5` to a double.

### Problem 5: Real-world types

For a shopping app, decide the type of each piece of data. Justify briefly.

1. The product name.
2. The price in naira.
3. Whether the product is in stock.
4. The number of items in the cart.
5. The product's average rating (e.g. 4.5 out of 5).
6. The shipping address as one piece of text.

---

## Assignment Answers

### Problem 1: Pick the right type

| Value | Type | Why |
|-------|------|-----|
| 42 | int | whole number |
| 3.14 | double | has a decimal point |
| "Hello" | String | text in quotes |
| true | bool | true/false value |
| -100 | int | whole number, negative is fine |
| 0.0 | double | the `.0` makes it a decimal |
| "42" | String | quotes make it text, even though it looks like a number |
| 1000000 | int | still a whole number, no upper limit problem here |

The trickiest one is `"42"`. It looks like a number, but the quotes make it a String. To turn it into an int you would need `int.parse("42")`.

### Problem 2: Type detective

```dart
var a = 'Flutter';     // String
var b = 100;           // int
var c = 99.9;          // double
var d = false;         // bool
var e = 'true';        // String  (quoted text, not a bool)
var f = 0;             // int
```

The lesson: `var` does not mean "any type". It means "let Dart figure out the type from the value, and lock it in". Once `b` is set to 100, Dart treats it as `int` forever. You cannot later assign `'hello'` to it.

### Problem 3: Type mismatch hunt

```dart
double score = 85.5;         // int cannot hold decimals, change to double
int age = 25;                // 25 is an int, change the variable type
bool isReady = true;         // bool needs true or false, not 1
double price = 19.99;        // remove the quotes, "19.99" is a String
```

These four bugs cover the four most common type mismatches: int with double value, String with int value, bool with int value, and double with String value. The compiler catches each one before your program runs, which is one of the reasons strong typing is helpful.

### Problem 4: Convert between types

```dart
void main() {
  // 1. int to String
  int n = 42;
  String s = n.toString();
  print('$s, ${s.runtimeType}');     // 42, String

  // 2. String to int
  String text = '99';
  int parsed = int.parse(text);
  print('$parsed, ${parsed.runtimeType}');     // 99, int

  // 3. double to int (truncates the decimal)
  double d = 3.7;
  int truncated = d.toInt();
  print('$truncated, ${truncated.runtimeType}');     // 3, int

  // 4. int to double
  int i = 5;
  double doubled = i.toDouble();
  print('$doubled, ${doubled.runtimeType}');     // 5.0, double
}
```

Each conversion uses a method on the value:

- `.toString()` works on any type, returns a String.
- `int.parse(...)` reads a String and returns an int. Throws if the String is not a valid number.
- `.toInt()` on a double drops the decimal. `3.7.toInt()` is `3`, not `4`. For rounding, use `.round()`.
- `.toDouble()` on an int adds `.0` and returns a double.

`.runtimeType` is a useful little property that prints the actual type at runtime. Handy for debugging.

### Problem 5: Real-world types

| Data | Type | Why |
|------|------|-----|
| Product name | String | text |
| Price in naira | int or double | depends. If prices are always whole nairas, int. If you have kobo, double. |
| In stock | bool | yes or no |
| Items in cart | int | count, always a whole number |
| Average rating | double | 4.5 has a decimal |
| Shipping address | String | text, possibly multiline |

The price decision is interesting. In real apps, never use `double` for money in critical calculations because of floating-point imprecision. Use `int` of the smallest unit (kobo) and convert when displaying. But for a beginner course, `double` is fine to learn with.

---

**Next:** Let's learn how to use variables in calculations and operations!

**Continue to:** `02c-UsingVariables.md`
