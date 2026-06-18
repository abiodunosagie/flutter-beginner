# Strings: Working With Text

## The Big Idea In One Sentence

> A String is text, and Dart gives you handy tools to **measure it, change its case, clean it up, and search inside it**, all without changing the original.

You have used strings since lesson 1. Now you learn the useful tricks.

---

## Single Quotes Or Double Quotes

Both make a string. They work the same way:

```dart
String a = 'Hello';
String b = "Hello";
```

Dart's style prefers single quotes `' '`. But there is one time double quotes are handy: when your text **contains** a single quote (an apostrophe).

```dart
String sentence = "It's a sunny day";   // easy: use double quotes outside
```

If you really want to stay with single quotes, put a backslash `\` before the apostrophe to say "this is just a character, not the end of the string":

```dart
String sentence = 'It\'s a sunny day';  // same result
```

Both print:

```
It's a sunny day
```

---

## Text On Many Lines

For text that spans several lines, use **three quotes** `'''`:

```dart
void main() {
  String poem = '''
Roses are red,
Code is fun,
I am learning Dart.''';

  print(poem);
}
```

Output:

```
Roses are red,
Code is fun,
I am learning Dart.
```

Everything between the triple quotes is kept exactly, including the line breaks.

---

## Dropping Variables Into Text (Recap)

You know this from earlier, here it is together:

```dart
void main() {
  String name = 'Ada';
  int age = 12;

  print('$name is $age');             // single variable: use $
  print('Next year: ${age + 1}');     // a calculation: use ${ ... }
}
```

Output:

```
Ada is 12
Next year: 13
```

---

## How Long Is It? `.length`

`.length` tells you how many characters are in a string. Spaces count too.

```dart
void main() {
  String name = 'Ada';
  print(name.length);     // 3

  String word = 'hi there';
  print(word.length);     // 8  (the space counts)
}
```

---

## Changing The Case

Two tools make text all UPPER or all lower:

```dart
void main() {
  String name = 'Ada Bello';

  print(name.toUpperCase());   // ADA BELLO
  print(name.toLowerCase());   // ada bello
}
```

Important idea: these do **not** change the original box. They hand you back a **new** string. Look:

```dart
void main() {
  String name = 'Ada';
  print(name.toUpperCase());   // ADA
  print(name);                 // Ada  (the original is unchanged!)
}
```

If you want to keep the upper version, store it: `name = name.toUpperCase();`.

---

## Cleaning Up Spaces: `.trim()`

`.trim()` removes spaces from the start and end of a string (not the middle). Great for cleaning messy input.

```dart
void main() {
  String messy = '   Ada   ';
  print('[${messy.trim()}]');   // [Ada]
}
```

The `[ ]` are just there so you can see the spaces are gone.

---

## Searching Inside Text

These tools ask yes/no questions about a string, so they give you a `bool`:

```dart
void main() {
  String email = 'ada@example.com';

  print(email.contains('@'));        // true
  print(email.startsWith('ada'));    // true
  print(email.endsWith('.com'));     // true
  print(email.contains('xyz'));      // false
}
```

- `.contains('@')` asks "is `@` anywhere inside?"
- `.startsWith('ada')` asks "does it begin with `ada`?"
- `.endsWith('.com')` asks "does it end with `.com`?"

---

## Swapping Text: `.replaceAll()`

`.replaceAll()` gives you a new string with every match swapped out:

```dart
void main() {
  String text = 'I like cats. Cats are great.';
  print(text.replaceAll('cats', 'dogs'));
  // I like dogs. Cats are great.
}
```

Notice only lowercase `cats` changed. The capital `Cats` did not match, because searching is **case sensitive** (`c` and `C` are different).

---

## Grabbing A Piece: `[index]` and `.substring()`

Each character in a string has a position number called an **index**. Counting starts at **0**, not 1:

```
 A  d  a
 0  1  2
```

Get one character with square brackets:

```dart
void main() {
  String name = 'Ada';
  print(name[0]);   // A
  print(name[1]);   // d
}
```

Get a piece with `.substring(start, end)`. It takes characters from `start` up to (but not including) `end`:

```dart
void main() {
  String word = 'Flutter';
  print(word.substring(0, 4));   // Flut  (positions 0,1,2,3)
  print(word.substring(4));      // ter   (from position 4 to the end)
}
```

A neat trick: make the first letter capital by joining the upper-cased first character with the rest:

```dart
void main() {
  String name = 'ada';
  String capital = name[0].toUpperCase() + name.substring(1);
  print(capital);   // Ada
}
```

---

## Special Characters (Escapes)

Some characters need a backslash `\` to write. The most useful:

```dart
void main() {
  print('Line one\nLine two');   // \n starts a new line
  print('Name:\tAda');           // \t inserts a tab (a big gap)
}
```

Output:

```
Line one
Line two
Name:	Ada
```

Handy ones:

| You write | You get |
|-----------|---------|
| `\n` | a new line |
| `\t` | a tab (gap) |
| `\'` | a single quote |
| `\\` | a backslash |

---

## The Top Mistakes Beginners Make

### Mistake 1: Expecting a method to change the original

```dart
String name = 'ada';
name.toUpperCase();    // this result is thrown away!
print(name);           // still 'ada'

name = name.toUpperCase();  // GOOD: store the new value back
print(name);                // 'ADA'
```

### Mistake 2: Forgetting counting starts at 0

```dart
String name = 'Ada';
print(name[1]);   // 'd', not 'A'. The first character is at index 0.
```

### Mistake 3: Search is case sensitive

```dart
'Hello'.contains('hello');   // false! capital H is different from small h
```

### Mistake 4: An apostrophe ending the string early

```dart
String s = 'It's late';     // BAD: the second quote ends the string
String s = "It's late";     // GOOD: use double quotes
String s = 'It\'s late';    // GOOD: escape the apostrophe
```

---

## One-Minute Recap

- Single or double quotes both make strings; double quotes are handy when the text has an apostrophe.
- Triple quotes `'''` make multi-line text.
- `.length` counts characters (spaces included).
- `.toUpperCase()` / `.toLowerCase()` give back a new string; they do not change the original.
- `.trim()` removes spaces from the ends.
- `.contains()`, `.startsWith()`, `.endsWith()` answer yes/no (a `bool`).
- `.replaceAll()` swaps text. Searching is case sensitive.
- `[index]` grabs one character (counting from 0); `.substring()` grabs a piece.

---

## Quick Quiz

**Q1.** What does this show?

```dart
void main() {
  String name = 'Dart';
  print('I love ${name.toUpperCase()}!');
}
```

<details>
<summary>Answer</summary>

```
I love DART!
```

`${ ... }` runs `name.toUpperCase()` (which gives `DART`) and drops it in.
</details>

**Q2.** What is `'Ada'.length`?

<details>
<summary>Answer</summary>
`3`. There are three characters: A, d, a.
</details>

**Q3.** What does `'Flutter'.substring(0, 4)` give?

<details>
<summary>Answer</summary>
`'Flut'`. It takes positions 0, 1, 2, 3. The end number (4) is not included.
</details>

**Q4.** What does `'Hello'.contains('hello')` give, and why?

<details>
<summary>Answer</summary>
`false`. Searching is case sensitive, so capital `H` does not match small `h`.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Predict the output

```dart
void main() {
  String name = 'Ada';
  print(name.length);
  print(name.toUpperCase());
  print(name.toLowerCase());
  print('Hello, $name!');
}
```

### Problem 2: Clean and greet

Make a String `messy = '   bola   '` (with spaces). Print a clean greeting that says `Hello, bola!` with no extra spaces. Use `.trim()`.

### Problem 3: Capitalize a name

Make a String `word = 'lagos'`. Build and print `Lagos` (first letter capital, rest the same). Use `[0]`, `.toUpperCase()`, and `.substring(1)`.

### Problem 4: Search a sentence

Make a String `sentence = 'the quick brown fox'`. Print the answers (true or false) to:

1. Does it contain `'quick'`?
2. Does it start with `'the'`?
3. Does it end with `'cat'`?

### Problem 5: Swap words

Make a String `text = 'I like tea'`. Print a new sentence that says `I like coffee` by using `.replaceAll`.

---

## Assignment Answers

### Problem 1: Predict the output

```
3
ADA
ada
Hello, Ada!
```

`name.length` is 3. `toUpperCase()` gives `ADA`, `toLowerCase()` gives `ada` (both new strings, the original `name` is still `Ada`). The last line drops `name` into the sentence with `$`.

### Problem 2: Clean and greet

```dart
void main() {
  String messy = '   bola   ';
  print('Hello, ${messy.trim()}!');
}
```

Output:

```
Hello, bola!
```

`messy.trim()` removes the spaces on both ends, and `${ ... }` drops the cleaned text into the sentence.

### Problem 3: Capitalize a name

```dart
void main() {
  String word = 'lagos';
  String capital = word[0].toUpperCase() + word.substring(1);
  print(capital);
}
```

Output:

```
Lagos
```

`word[0]` is `'l'`. `.toUpperCase()` makes it `'L'`. `word.substring(1)` is everything from position 1 onward: `'agos'`. Joined with `+`, you get `'Lagos'`.

### Problem 4: Search a sentence

```dart
void main() {
  String sentence = 'the quick brown fox';
  print(sentence.contains('quick'));    // true
  print(sentence.startsWith('the'));    // true
  print(sentence.endsWith('cat'));      // false
}
```

Output:

```
true
true
false
```

Each search asks a yes/no question and gives back a `bool`. The sentence ends with `fox`, not `cat`, so the last one is `false`.

### Problem 5: Swap words

```dart
void main() {
  String text = 'I like tea';
  print(text.replaceAll('tea', 'coffee'));
}
```

Output:

```
I like coffee
```

`.replaceAll('tea', 'coffee')` finds `tea` and swaps it for `coffee`, giving back a new string.

---

**Next:** `04-Numbers.md`, where you learn how to work with numbers and do maths.
