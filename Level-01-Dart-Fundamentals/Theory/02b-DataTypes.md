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

**Next:** Let's learn how to use variables in calculations and operations!

**Continue to:** `02c-UsingVariables.md`
