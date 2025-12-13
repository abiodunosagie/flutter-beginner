# Week 2, Day 1-2: Strings Deep Dive

## 5-Year-Old Explanation

Imagine you have a long piece of string (like the string you use to tie a present). Now imagine that on this string, you can write letters and words!

In programming, a "string" is just a fancy word for **text**. Any words, sentences, or letters you see on your computer or phone - they're all strings!

**Examples of strings in real life:**
- Your name: "Emma" is a string
- A text message: "Happy Birthday!" is a string
- An address: "123 Main Street" is a string
- Even a single letter: "A" is a string!

Think of strings like beads on a necklace - each letter is a bead, and when you put them together in order, they make words and sentences.

The cool part? You can do all kinds of fun things with strings:
- Make them BIGGER or smaller
- Chop them into pieces
- Glue them together
- Search for specific words inside them
- And much more!

Strings are so important because almost everything you see in an app is made of strings - every button label, every message, every name. If you master strings, you've mastered a huge part of programming!

---

## Strings Are Everywhere

In apps, **most data is text:**
- Usernames and passwords
- Messages and posts
- Addresses and emails
- Search queries
- Error messages

Mastering strings means mastering a huge part of programming.

---

## Creating Strings

### Single vs Double Quotes

Both work identically in Dart:

```dart
String name1 = 'Alice';
String name2 = "Alice";
// These are exactly the same!
```

**When to use which?**

```dart
// Use single quotes (Dart convention)
String message = 'Hello!';

// Use double quotes when you need a single quote inside
String quote = "It's a beautiful day!";

// Or escape with backslash
String quote2 = 'It\'s a beautiful day!';
```

### Multi-Line Strings

Use triple quotes for multiple lines:

```dart
String poem = '''
Roses are red,
Violets are blue,
Dart is awesome,
And so are you!
''';

print(poem);
```

**Output:**
```
Roses are red,
Violets are blue,
Dart is awesome,
And so are you!
```

### Raw Strings

Sometimes you want the string **exactly as written** (no escaping):

```dart
// Regular string with escaping
String path1 = 'C:\\Users\\John\\Documents';  // Escape each backslash

// Raw string (prefix with r)
String path2 = r'C:\Users\John\Documents';     // Much cleaner!

print(path1);  // C:\Users\John\Documents
print(path2);  // C:\Users\John\Documents
```

---

## String Properties

### Length

```dart
String name = 'Alice';
print(name.length);  // 5

String empty = '';
print(empty.length);  // 0

String sentence = 'Hello, World!';
print(sentence.length);  // 13 (includes space and punctuation)
```

### isEmpty and isNotEmpty

```dart
String empty = '';
String full = 'Hello';

print(empty.isEmpty);       // true
print(empty.isNotEmpty);    // false

print(full.isEmpty);        // false
print(full.isNotEmpty);     // true
```

**Use case:**
```dart
String username = '';  // User didn't enter anything

if (username.isEmpty) {
  print('Please enter a username!');
}
```

---

## String Methods - Changing Text

### toUpperCase() and toLowerCase()

```dart
String name = 'Alice';

print(name.toUpperCase());  // ALICE
print(name.toLowerCase());  // alice

// Original is unchanged
print(name);  // Alice
```

**Important:** String methods return **new** strings. They don't modify the original.

```dart
String message = 'hello';
message.toUpperCase();  // This does nothing!

print(message);  // Still "hello"

// You must save the result
String loud = message.toUpperCase();
print(loud);  // HELLO
```

### trim() - Remove Whitespace

```dart
String messy = '  Hello, World!  ';
String clean = messy.trim();

print(messy);   // "  Hello, World!  "
print(clean);   // "Hello, World!"

// Also available:
print(messy.trimLeft());   // "Hello, World!  "
print(messy.trimRight());  // "  Hello, World!"
```

**Use case:** User input often has accidental spaces:
```dart
String username = '  alice123  ';
String cleaned = username.trim().toLowerCase();
print(cleaned);  // alice123
```

---

## String Methods - Searching

### contains()

```dart
String email = 'alice@example.com';

print(email.contains('@'));         // true
print(email.contains('alice'));     // true
print(email.contains('ALICE'));     // false (case-sensitive)
print(email.contains('bob'));       // false
```

### startsWith() and endsWith()

```dart
String filename = 'document.pdf';

print(filename.startsWith('doc'));    // true
print(filename.endsWith('.pdf'));     // true
print(filename.endsWith('.doc'));     // false

// Case-sensitive!
print(filename.startsWith('Doc'));    // false
```

**Use case:** Validate file types:
```dart
String file = 'photo.jpg';

if (file.endsWith('.jpg') || file.endsWith('.png')) {
  print('Valid image file');
} else {
  print('Please upload an image');
}
```

### indexOf() - Find Position

```dart
String text = 'Hello, World!';

print(text.indexOf('o'));        // 4 (first 'o')
print(text.indexOf('World'));    // 7
print(text.indexOf('xyz'));      // -1 (not found)

// Find last occurrence
print(text.lastIndexOf('o'));    // 8 (last 'o' in 'World')
```

**Remember:** Indexing starts at 0!
```
H e l l o ,   W o r l d  !
0 1 2 3 4 5 6 7 8 9 10 11 12
```

---

## String Methods - Extracting Parts

### substring() - Get Part of String

```dart
String text = 'Hello, World!';

// From index 0 to 5 (not including 5)
print(text.substring(0, 5));   // Hello

// From index 7 to end
print(text.substring(7));      // World!

// Extract middle part
print(text.substring(7, 12));  // World
```

**Use case:** Extract parts of data:
```dart
String fullName = 'John Smith';
int spaceIndex = fullName.indexOf(' ');

String firstName = fullName.substring(0, spaceIndex);
String lastName = fullName.substring(spaceIndex + 1);

print(firstName);  // John
print(lastName);   // Smith
```

### split() - Break into Parts

```dart
String sentence = 'I love Dart programming';
List<String> words = sentence.split(' ');

print(words);  // [I, love, Dart, programming]
print(words[0]);  // I
print(words[1]);  // love
```

**More examples:**
```dart
String csv = 'Alice,25,Engineer';
List<String> parts = csv.split(',');

print(parts[0]);  // Alice
print(parts[1]);  // 25
print(parts[2]);  // Engineer

// Split email
String email = 'user@example.com';
List<String> emailParts = email.split('@');

print(emailParts[0]);  // user
print(emailParts[1]);  // example.com
```

---

## String Methods - Replacing

### replaceAll()

```dart
String text = 'I love cats. Cats are great!';
String modified = text.replaceAll('cats', 'dogs');

print(modified);  // I love dogs. Cats are great!
// Note: Only replaced lowercase 'cats'

// Case-insensitive replacement (we'll learn better ways later)
String text2 = 'I love cats. Cats are great!';
String result = text2.replaceAll('cats', 'dogs').replaceAll('Cats', 'Dogs');
print(result);  // I love dogs. Dogs are great!
```

### replaceFirst()

```dart
String text = 'one one one';
String result = text.replaceFirst('one', 'two');

print(result);  // two one one (only first occurrence)
```

---

## Accessing Individual Characters

### Using [] notation

```dart
String word = 'Hello';

print(word[0]);  // H
print(word[1]);  // e
print(word[4]);  // o

// word[0] = 'h';  // ERROR! Strings are immutable
```

**Remember:** Strings are **immutable** (can't be changed). To modify, create a new string.

### Iterate through characters

```dart
String word = 'Dart';

for (int i = 0; i < word.length; i++) {
  print(word[i]);
}
```

**Output:**
```
D
a
r
t
```

---

## String Interpolation (Review + Advanced)

### Basic Interpolation

```dart
String name = 'Alice';
int age = 25;

print('My name is $name and I am $age years old.');
```

### Expression Interpolation

```dart
int a = 5;
int b = 3;

print('The sum is ${a + b}');               // The sum is 8
print('Double of $a is ${a * 2}');          // Double of 5 is 10

String name = 'alice';
print('Hello, ${name.toUpperCase()}!');     // Hello, ALICE!
```

### Complex Expressions

```dart
String firstName = 'John';
String lastName = 'Doe';

print('Initials: ${firstName[0]}.${lastName[0]}.');  // Initials: J.D.
```

---

## Combining Strings

### Using + operator

```dart
String first = 'Hello';
String second = 'World';
String combined = first + ' ' + second;

print(combined);  // Hello World
```

### Using String Interpolation (Better)

```dart
String first = 'Hello';
String second = 'World';
String combined = '$first $second';

print(combined);  // Hello World
```

### Using join()

```dart
List<String> words = ['Hello', 'beautiful', 'world'];
String sentence = words.join(' ');

print(sentence);  // Hello beautiful world

// Different separator
String csv = words.join(',');
print(csv);  // Hello,beautiful,world
```

---

## Common String Patterns

### Email Validation (Simple)

```dart
String email = 'user@example.com';
bool isValid = email.contains('@') && email.contains('.');

print(isValid);  // true
```

### Extract Username from Email

```dart
String email = 'alice@example.com';
String username = email.split('@')[0];

print(username);  // alice
```

### Format Phone Number

```dart
String phone = '1234567890';
String formatted = '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';

print(formatted);  // (123) 456-7890
```

### Capitalize First Letter

```dart
String name = 'alice';
String capitalized = name[0].toUpperCase() + name.substring(1);

print(capitalized);  // Alice
```

---

## Exercises

### Exercise 1: Email Processor
Write a program that:
1. Takes an email address
2. Extracts the username
3. Extracts the domain
4. Prints both

**Example:**
```
Email: john.doe@company.com
Username: john.doe
Domain: company.com
```

<details>
<summary>Solution</summary>

```dart
void main() {
  String email = 'john.doe@company.com';

  int atIndex = email.indexOf('@');
  String username = email.substring(0, atIndex);
  String domain = email.substring(atIndex + 1);

  print('Email: $email');
  print('Username: $username');
  print('Domain: $domain');

  // Alternative using split
  List<String> parts = email.split('@');
  print('\nAlternative:');
  print('Username: ${parts[0]}');
  print('Domain: ${parts[1]}');
}
```
</details>

---

### Exercise 2: Name Formatter
Take a full name in lowercase and format it properly (capitalize first letter of each word).

**Input:** `john smith`
**Output:** `John Smith`

<details>
<summary>Solution</summary>

```dart
void main() {
  String fullName = 'john smith';

  List<String> words = fullName.split(' ');

  String firstName = words[0];
  String lastName = words[1];

  String formattedFirst = firstName[0].toUpperCase() + firstName.substring(1);
  String formattedLast = lastName[0].toUpperCase() + lastName.substring(1);

  String formatted = '$formattedFirst $formattedLast';

  print(formatted);  // John Smith
}
```
</details>

---

### Exercise 3: Password Validator
Check if a password:
- Is at least 8 characters long
- Contains '@' or '#'

**Example:**
```
Password: hello123
Valid: false (too short, no special char)

Password: secure@pass
Valid: true
```

<details>
<summary>Solution</summary>

```dart
void main() {
  String password = 'secure@pass';

  bool isLongEnough = password.length >= 8;
  bool hasSpecialChar = password.contains('@') || password.contains('#');
  bool isValid = isLongEnough && hasSpecialChar;

  print('Password: $password');
  print('Length check: $isLongEnough');
  print('Special character: $hasSpecialChar');
  print('Valid: $isValid');
}
```
</details>

---

### Exercise 4: Word Counter
Count how many words are in a sentence.

**Example:**
```
Input: "I love programming in Dart"
Output: 5 words
```

<details>
<summary>Solution</summary>

```dart
void main() {
  String sentence = 'I love programming in Dart';
  List<String> words = sentence.split(' ');
  int count = words.length;

  print('Input: "$sentence"');
  print('Output: $count words');
}
```
</details>

---

### Exercise 5: Text Censorer
Replace a "bad word" with asterisks.

**Example:**
```
Input: "This is a badword in the text"
Output: "This is a ******* in the text"
```

<details>
<summary>Solution</summary>

```dart
void main() {
  String text = 'This is a badword in the text';
  String badWord = 'badword';
  String censored = '*' * badWord.length;  // Create asterisks

  String result = text.replaceAll(badWord, censored);

  print('Input: "$text"');
  print('Output: "$result"');
}
```
</details>

---

## Key Takeaways

1. **Strings are immutable** - methods return new strings
2. **Case matters** - `contains()`, `startsWith()`, etc. are case-sensitive
3. **Indexing starts at 0** - first character is [0]
4. **`split()` breaks strings into lists**
5. **String interpolation is cleaner than concatenation**
6. **Always check `isEmpty` before processing**

---

## What's Next?

Tomorrow we'll learn:
- **Numbers and Math** - arithmetic, rounding, math functions
- **Operators** - comparison, assignment, and more

Practice these string exercises! String manipulation is critical in real apps.
