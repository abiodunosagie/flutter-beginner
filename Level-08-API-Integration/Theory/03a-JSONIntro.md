# JSON Basics - Part 1: Understanding JSON

## The Big Idea In One Sentence

> JSON is text that any program can read, and it looks almost exactly like Dart Maps and Lists, which is why it is the language apps and servers use to swap data.

Learn what JSON is and why it's the universal language of APIs!

---

## What is JSON?

### Think of it Like This

JSON is like a **universal translator** for data:

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON = DATA TRANSLATOR                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Imagine sending a letter to someone in another country:    │
│                                                             │
│  Your Language    →    English    →    Their Language       │
│  (Dart objects)       (JSON)          (Server/Database)     │
│                                                             │
│  JSON is the "common language" that everyone understands!   │
│                                                             │
│  ┌─────────┐      ┌─────────┐      ┌─────────┐             │
│  │  Dart   │      │  JSON   │      │ Python  │             │
│  │  App    │ ←──→ │ String  │ ←──→ │ Server  │             │
│  └─────────┘      └─────────┘      └─────────┘             │
│                                                             │
│  Everyone can read and write JSON!                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON = JavaScript Object Notation

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON BREAKDOWN                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  J = JavaScript    (It came from JavaScript originally)     │
│  O = Object        (It represents structured data)          │
│  N = Notation      (It's a way of writing things)           │
│                                                             │
│  BUT! JSON is language-independent:                         │
│  • Dart can use it                                         │
│  • Python can use it                                       │
│  • Java can use it                                         │
│  • Every language can use it!                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON vs Dart - Side by Side

```
┌─────────────────────────────────────────────────────────────┐
│                 JSON vs DART COMPARISON                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JSON (String)                    Dart (Code)               │
│  ─────────────                    ──────────                │
│                                                             │
│  {                                Map<String, dynamic> user │
│    "name": "John",                  = {                     │
│    "age": 25,                         'name': 'John',       │
│    "email": "john@test.com"           'age': 25,            │
│  }                                    'email': 'john@test'  │
│                                     };                      │
│                                                             │
│  KEY DIFFERENCES:                                           │
│  • JSON uses double quotes "    Dart can use single '      │
│  • JSON is a STRING             Dart Map is an OBJECT       │
│  • JSON keys MUST be strings    Dart keys can be anything   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON Data Types

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON DATA TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TYPE        │ JSON EXAMPLE          │ DART EQUIVALENT      │
│  ────────────────────────────────────────────────────────── │
│  String      │ "hello"               │ String               │
│  Number      │ 42 or 3.14            │ int or double        │
│  Boolean     │ true or false         │ bool                 │
│  Null        │ null                  │ null                 │
│  Array       │ [1, 2, 3]             │ List                 │
│  Object      │ {"key": "value"}      │ Map<String, dynamic> │
│                                                             │
│  THAT'S IT! Only 6 types in JSON!                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON Object (like a Dart Map)

```dart
// JSON string (what you receive from API)
String jsonString = '''
{
  "name": "John Doe",
  "age": 25,
  "isStudent": true,
  "email": null
}
''';

// Dart equivalent (what you work with in code)
Map<String, dynamic> user = {
  'name': 'John Doe',
  'age': 25,
  'isStudent': true,
  'email': null,
};
```

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON OBJECT                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  {                           ← Opening brace                │
│    "name": "John",           ← key: value pair              │
│    "age": 25,                ← number (no quotes)           │
│    "active": true            ← boolean (no quotes)          │
│  }                           ← Closing brace                │
│                                                             │
│  Rules:                                                     │
│  • Keys MUST be in double quotes                            │
│  • Strings MUST be in double quotes                         │
│  • Numbers, booleans, null have NO quotes                   │
│  • Pairs separated by commas                                │
│  • NO trailing comma allowed!                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JSON Array (like a Dart List)

```dart
// JSON array string
String jsonArray = '''
[
  "apple",
  "banana",
  "cherry"
]
''';

// Dart equivalent
List<String> fruits = ['apple', 'banana', 'cherry'];

// Array of objects (very common!)
String usersJson = '''
[
  {"id": 1, "name": "John"},
  {"id": 2, "name": "Jane"},
  {"id": 3, "name": "Bob"}
]
''';

// Dart equivalent
List<Map<String, dynamic>> users = [
  {'id': 1, 'name': 'John'},
  {'id': 2, 'name': 'Jane'},
  {'id': 3, 'name': 'Bob'},
];
```

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON ARRAY                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Simple Array:                                              │
│  [                           ← Opening bracket              │
│    "apple",                  ← Item 1                       │
│    "banana",                 ← Item 2                       │
│    "cherry"                  ← Item 3 (no trailing comma!)  │
│  ]                           ← Closing bracket              │
│                                                             │
│  Array of Objects:                                          │
│  [                                                          │
│    { "id": 1, "name": "John" },                            │
│    { "id": 2, "name": "Jane" }                             │
│  ]                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Common JSON Errors

```
┌─────────────────────────────────────────────────────────────┐
│                 COMMON JSON ERRORS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ERROR                          │ PROBLEM                   │
│  ────────────────────────────────────────────────────────── │
│  {"name": John}                 │ Missing quotes on value   │
│  {name: "John"}                 │ Missing quotes on key     │
│  {"name": "John",}              │ Trailing comma            │
│  {'name': 'John'}               │ Single quotes (invalid!)  │
│  {"name": "John" "age": 25}     │ Missing comma             │
│                                                             │
│  CORRECT:                                                   │
│  {"name": "John", "age": 25}                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  WHAT IS JSON?                                              │
│  • Universal data format                                    │
│  • Human-readable text                                      │
│  • Language-independent                                     │
│                                                             │
│  JSON TYPES:                                                │
│  • String: "text"                                           │
│  • Number: 42 or 3.14                                       │
│  • Boolean: true or false                                   │
│  • Null: null                                               │
│  • Array: [1, 2, 3]                                         │
│  • Object: {"key": "value"}                                 │
│                                                             │
│  JSON RULES:                                                │
│  • Keys must have double quotes                             │
│  • Strings must have double quotes                          │
│  • No trailing commas                                       │
│  • No comments allowed                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Now you understand what JSON is! In the next part, you'll learn how to convert between JSON strings and Dart objects.

---

## Quick Quiz

**Q1.** A JSON `{ }` object looks most like which Dart type?

<details>
<summary>Answer</summary>
A `Map<String, dynamic>` (keys and values).
</details>

**Q2.** A JSON `[ ]` array looks most like which Dart type?

<details>
<summary>Answer</summary>
A `List`.
</details>

**Q3.** What quote type must JSON keys and string values use?

<details>
<summary>Answer</summary>
Double quotes (`"`). Single quotes are not valid JSON.
</details>

---

## Assignment

### Problem 1: Object or array?

Is each one a JSON object or array?
1. `{"id": 1, "name": "Ada"}`
2. `["red", "green", "blue"]`

### Problem 2: Fix the JSON

This JSON is invalid. Rewrite it correctly:

```
{name: 'John', "age": 25,}
```

### Problem 3: Translate to Dart

Write the Dart Map that matches this JSON: `{"city": "Lagos", "rainy": true}`.

---

## Assignment Answers

### Problem 1: Object or array?

1. **Object** (curly braces with key/value pairs).
2. **Array** (square brackets with a list of items).

### Problem 2: Fix the JSON

```json
{"name": "John", "age": 25}
```

Fixes: key `name` needs double quotes, the string `'John'` must use double quotes, and the trailing comma after `25` is removed.

### Problem 3: Translate to Dart

```dart
Map<String, dynamic> data = {'city': 'Lagos', 'rainy': true};
```

---

**Continue to:** [03b-JSONParsing.md](./03b-JSONParsing.md) - Learn how to decode and encode JSON in Dart!

---

[← HTTP Methods](./02-HTTPMethods.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: JSON Parsing](./03b-JSONParsing.md)

---

## Navigation

⬅️ **Previous:** [HTTP Methods](02-HTTPMethods.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [JSON Parsing](03b-JSONParsing.md)
