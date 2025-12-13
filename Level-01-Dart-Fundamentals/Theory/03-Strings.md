# Working with Strings

## What Is a String?

A **String** is a sequence of characters - letters, numbers, symbols, spaces - anything you can type. It represents text.

```dart
String greeting = 'Hello, World!';
String name = "Alex";
String empty = '';
String withNumbers = 'Room 101';
String withSymbols = 'Price: $9.99!';
```

---

## Creating Strings

### Single Quotes (Preferred in Dart)

```dart
String name = 'Alex';
String message = 'Hello there!';
```

### Double Quotes

```dart
String name = "Alex";
String message = "Hello there!";
```

Both work identically. The Dart style guide prefers single quotes, but use double quotes when your string contains a single quote:

```dart
String sentence = "It's a beautiful day";  // Easier than escaping
String sentence = 'It\'s a beautiful day'; // Same result with escape
```

### Multi-Line Strings

Use triple quotes for strings spanning multiple lines:

```dart
String poem = '''
Roses are red,
Violets are blue,
Dart is awesome,
And so are you.
''';

String json = """
{
  "name": "Alex",
  "age": 25
}
""";
```

---

## String Interpolation

The most powerful way to build strings with variables.

### Basic Interpolation

Use `$variableName` to insert a variable:

```dart
String name = 'Alex';
int age = 25;

print('My name is $name');        // My name is Alex
print('I am $age years old');     // I am 25 years old
```

### Expression Interpolation

Use `${expression}` for anything more complex:

```dart
int a = 5;
int b = 3;

print('Sum: ${a + b}');           // Sum: 8
print('Product: ${a * b}');       // Product: 15

String name = 'alex';
print('Upper: ${name.toUpperCase()}');  // Upper: ALEX
print('Length: ${name.length}');        // Length: 4
```

### When to Use Which

```dart
// Simple variable - use $
String msg = 'Hello, $name';

// Property access - use ${}
String msg = 'Length is ${name.length}';

// Method call - use ${}
String msg = 'Upper: ${name.toUpperCase()}';

// Math - use ${}
String msg = 'Next year: ${age + 1}';
```

---

## String Concatenation

Joining strings together.

### Using + Operator

```dart
String first = 'Hello';
String second = 'World';
String combined = first + ' ' + second;  // Hello World
```

### Using Interpolation (Preferred)

```dart
String first = 'Hello';
String second = 'World';
String combined = '$first $second';  // Hello World
```

### Adjacent String Literals

Strings next to each other automatically combine:

```dart
String message = 'Hello '
                 'World';  // Hello World

// Useful for long strings
String query = 'SELECT * FROM users '
               'WHERE active = true '
               'ORDER BY name';
```

---

## String Properties

### Length

```dart
String name = 'Alex';
print(name.length);  // 4

String empty = '';
print(empty.length);  // 0

String space = ' ';
print(space.length);  // 1 (space counts!)
```

### isEmpty and isNotEmpty

```dart
String name = 'Alex';
String empty = '';

print(name.isEmpty);     // false
print(name.isNotEmpty);  // true
print(empty.isEmpty);    // true
print(empty.isNotEmpty); // false
```

---

## Common String Methods

### Case Conversion

```dart
String name = 'Alex Smith';

print(name.toUpperCase());  // ALEX SMITH
print(name.toLowerCase());  // alex smith
```

### Trimming Whitespace

```dart
String messy = '  Hello World  ';

print(messy.trim());       // 'Hello World' (removes both sides)
print(messy.trimLeft());   // 'Hello World  '
print(messy.trimRight());  // '  Hello World'
```

### Checking Content

```dart
String email = 'alex@example.com';

print(email.contains('@'));           // true
print(email.startsWith('alex'));      // true
print(email.endsWith('.com'));        // true
```

### Finding Position

```dart
String sentence = 'Hello World';

print(sentence.indexOf('o'));      // 4 (first occurrence)
print(sentence.lastIndexOf('o'));  // 7 (last occurrence)
print(sentence.indexOf('x'));      // -1 (not found)
```

### Replacing Text

```dart
String text = 'Hello World';

print(text.replaceAll('o', '0'));     // Hell0 W0rld
print(text.replaceFirst('l', 'L'));   // HeLlo World
```

### Splitting Strings

```dart
String csv = 'apple,banana,cherry';
List<String> fruits = csv.split(',');
print(fruits);  // [apple, banana, cherry]

String sentence = 'Hello World';
List<String> words = sentence.split(' ');
print(words);  // [Hello, World]
```

### Substring

```dart
String text = 'Hello World';

print(text.substring(0, 5));   // Hello (from index 0 to 4)
print(text.substring(6));      // World (from index 6 to end)
```

**Remember:** String indices start at 0!

```
H  e  l  l  o     W  o  r  l  d
0  1  2  3  4  5  6  7  8  9  10
```

---

## Accessing Characters

### By Index

```dart
String name = 'Alex';

print(name[0]);  // A
print(name[1]);  // l
print(name[2]);  // e
print(name[3]);  // x
```

### Iterating Through Characters

```dart
String word = 'Dart';

for (int i = 0; i < word.length; i++) {
  print(word[i]);
}
// D
// a
// r
// t
```

---

## Escape Characters

Special characters that have meaning in strings.

### Common Escape Sequences

```dart
print('Hello\nWorld');   // Newline
// Hello
// World

print('Hello\tWorld');   // Tab
// Hello   World

print('It\'s OK');       // Single quote in single-quoted string
// It's OK

print("Say \"Hi\"");     // Double quote in double-quoted string
// Say "Hi"

print('C:\\Users\\Alex'); // Backslash
// C:\Users\Alex
```

### Escape Sequence Table

| Escape | Meaning |
|--------|---------|
| `\n` | New line |
| `\t` | Tab |
| `\'` | Single quote |
| `\"` | Double quote |
| `\\` | Backslash |
| `\r` | Carriage return |

### Raw Strings

Prefix with `r` to ignore escape sequences:

```dart
String path = r'C:\Users\Alex\Documents';
print(path);  // C:\Users\Alex\Documents

String regex = r'\d+';  // Useful for regular expressions
```

---

## String Comparison

### Equality

```dart
String a = 'hello';
String b = 'hello';
String c = 'Hello';

print(a == b);  // true
print(a == c);  // false (case sensitive)
```

### Case-Insensitive Comparison

```dart
String a = 'Hello';
String b = 'hello';

print(a.toLowerCase() == b.toLowerCase());  // true
```

### Comparing Order

```dart
String a = 'apple';
String b = 'banana';

print(a.compareTo(b));  // Negative (a comes before b)
print(b.compareTo(a));  // Positive (b comes after a)
print(a.compareTo(a));  // 0 (equal)
```

---

## Practical Examples

### Example 1: Formatting a Name

```dart
void main() {
  String firstName = 'john';
  String lastName = 'doe';

  // Capitalize first letter
  String formattedFirst = firstName[0].toUpperCase() +
                          firstName.substring(1);
  String formattedLast = lastName[0].toUpperCase() +
                         lastName.substring(1);

  String fullName = '$formattedFirst $formattedLast';
  print(fullName);  // John Doe
}
```

### Example 2: Email Validation (Basic)

```dart
void main() {
  String email = 'alex@example.com';

  bool hasAt = email.contains('@');
  bool hasDot = email.contains('.');
  bool notEmpty = email.isNotEmpty;

  if (hasAt && hasDot && notEmpty) {
    print('Email looks valid');
  } else {
    print('Invalid email');
  }
}
```

### Example 3: Word Counter

```dart
void main() {
  String text = 'Hello World from Dart';

  List<String> words = text.split(' ');
  int wordCount = words.length;

  print('Word count: $wordCount');  // Word count: 4
}
```

### Example 4: Initials Generator

```dart
void main() {
  String fullName = 'John William Smith';

  List<String> parts = fullName.split(' ');
  String initials = '';

  for (String part in parts) {
    initials += part[0];
  }

  print('Initials: $initials');  // Initials: JWS
}
```

---

## String Buffer (Advanced)

For building strings in loops, use `StringBuffer` for better performance:

```dart
void main() {
  StringBuffer buffer = StringBuffer();

  for (int i = 1; i <= 5; i++) {
    buffer.write('Item $i, ');
  }

  String result = buffer.toString();
  print(result);  // Item 1, Item 2, Item 3, Item 4, Item 5,
}
```

Why? String concatenation in loops creates many intermediate strings. StringBuffer is more efficient.

---

## Summary

### Key Methods Cheat Sheet

```dart
String s = '  Hello World  ';

// Properties
s.length              // 15
s.isEmpty             // false
s.isNotEmpty          // true

// Case
s.toUpperCase()       // '  HELLO WORLD  '
s.toLowerCase()       // '  hello world  '

// Trimming
s.trim()              // 'Hello World'
s.trimLeft()          // 'Hello World  '
s.trimRight()         // '  Hello World'

// Searching
s.contains('World')   // true
s.startsWith('  H')   // true
s.endsWith('  ')      // true
s.indexOf('o')        // 4

// Modifying
s.replaceAll('l', 'L')    // '  HeLLo WorLd  '
s.substring(2, 7)         // 'Hello'
s.split(' ')              // ['', '', 'Hello', 'World', '', '']

// Interpolation
'Value: $variable'
'Expression: ${a + b}'
```

---

## Quick Quiz

**Q1:** What's the output?
```dart
String name = 'Dart';
print('I love ${name.toUpperCase()}!');
```

<details>
<summary>Answer</summary>
`I love DART!`
</details>

**Q2:** How do you check if a string is empty?

<details>
<summary>Answer</summary>
`string.isEmpty` or `string.length == 0`
</details>

**Q3:** What does `'Hello'.substring(1, 4)` return?

<details>
<summary>Answer</summary>
`'ell'` - characters at index 1, 2, 3 (end index is exclusive)
</details>

**Q4:** How do you include a single quote in a single-quoted string?

<details>
<summary>Answer</summary>
Escape it: `'It\'s great'` or use double quotes: `"It's great"`
</details>

---

**Next:** Let's learn about working with numbers.

---

**Continue to:** `04-Numbers.md`
