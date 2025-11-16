# Week 13, Day 1-2: JSON Explained - The Language of APIs

## What is JSON?

**JSON** stands for **J**ava**S**cript **O**bject **N**otation.

**Don't let the name fool you** - it's not just for JavaScript. JSON is the universal language that apps use to exchange data.

Think of JSON as a **menu** at a restaurant:
- The kitchen (API/server) writes the menu in a standard format
- Any customer (your app) can read it, no matter what language they speak
- It's structured, organized, and easy to understand

---

## Why JSON Matters

When your Flutter app talks to a server:

```
Your App: "Hey server, give me user data for ID 123"
Server: *sends back JSON*
Your App: *reads JSON and displays it*
```

**Examples of what JSON does:**
- Instagram sends posts as JSON
- Weather apps receive forecasts as JSON
- E-commerce apps get product lists as JSON
- Chat apps send messages as JSON

**If you want to build real apps, you MUST master JSON.**

---

## JSON Basics - The Building Blocks

JSON has only a few data types. Let's learn each one.

### 1. Objects (Like Dart Maps)

Objects use curly braces `{}` and contain key-value pairs:

```json
{
  "name": "Alice",
  "age": 25,
  "city": "New York"
}
```

**Rules:**
- Keys are strings (always in quotes)
- Values can be any JSON type
- Pairs separated by commas
- **Keys must be unique**

**Dart equivalent:**
```dart
Map<String, dynamic> person = {
  'name': 'Alice',
  'age': 25,
  'city': 'New York'
};
```

### 2. Arrays (Like Dart Lists)

Arrays use square brackets `[]`:

```json
[1, 2, 3, 4, 5]
```

```json
["apple", "banana", "cherry"]
```

**Dart equivalent:**
```dart
List<int> numbers = [1, 2, 3, 4, 5];
List<String> fruits = ['apple', 'banana', 'cherry'];
```

### 3. Strings

Text in double quotes:

```json
"Hello, World!"
```

**Important:** JSON only allows **double quotes**, not single quotes.

### 4. Numbers

Integer or decimal (no quotes):

```json
42
3.14159
-10
```

### 5. Booleans

True or false (lowercase, no quotes):

```json
true
false
```

### 6. null

Represents "no value":

```json
null
```

---

## Real-World JSON Examples

### Example 1: User Profile

```json
{
  "id": 12345,
  "username": "alice_smith",
  "email": "alice@example.com",
  "age": 28,
  "isVerified": true,
  "profilePicture": null
}
```

**What this means:**
- User ID is 12345
- Username is "alice_smith"
- Email is "alice@example.com"
- Age is 28
- Account is verified (true)
- No profile picture yet (null)

### Example 2: Product

```json
{
  "id": 501,
  "name": "Wireless Headphones",
  "price": 79.99,
  "inStock": true,
  "colors": ["black", "white", "blue"],
  "rating": 4.5
}
```

### Example 3: Weather Data

```json
{
  "city": "San Francisco",
  "temperature": 68,
  "condition": "Partly Cloudy",
  "humidity": 65,
  "windSpeed": 12.5
}
```

---

## Nested JSON - Objects Inside Objects

Real JSON is often nested:

```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "contact": {
      "email": "john@example.com",
      "phone": "555-1234"
    }
  }
}
```

**Reading this:**
- Outer object has a "user" key
- "user" value is another object
- That object has "id", "name", and "contact"
- "contact" is yet another object

**Accessing in Dart:**
```dart
String email = data['user']['contact']['email'];
// Result: "john@example.com"
```

---

## Arrays of Objects - The Most Common Pattern

APIs often return **lists of things**:

### Example: List of Users

```json
[
  {
    "id": 1,
    "name": "Alice",
    "age": 25
  },
  {
    "id": 2,
    "name": "Bob",
    "age": 30
  },
  {
    "id": 3,
    "name": "Charlie",
    "age": 35
  }
]
```

**This is:**
- An array containing 3 objects
- Each object represents a user
- All users have the same structure

**In Dart:**
```dart
List<dynamic> users = jsonData;
String firstName = users[0]['name'];  // "Alice"
int bobAge = users[1]['age'];         // 30
```

### Example: Social Media Post with Comments

```json
{
  "id": 101,
  "author": "Alice",
  "content": "Just learned Flutter!",
  "likes": 42,
  "comments": [
    {
      "user": "Bob",
      "text": "Awesome!"
    },
    {
      "user": "Charlie",
      "text": "Keep it up!"
    }
  ]
}
```

**Structure:**
- Post object
- Contains "comments" array
- Each comment is an object

---

## JSON Rules and Common Mistakes

### ✓ Valid JSON

```json
{
  "name": "Alice",
  "age": 25,
  "hobbies": ["reading", "coding"]
}
```

### ✗ Invalid JSON

```json
{
  name: "Alice",          // ✗ Keys must have quotes
  'age': 25,              // ✗ Must use double quotes, not single
  "hobbies": ["reading", "coding"],  // ✗ Trailing comma
}
```

**Common mistakes:**
1. Forgetting quotes around keys
2. Using single quotes instead of double
3. Trailing commas after last item
4. Comments (JSON doesn't support comments!)

---

## Converting Between Dart and JSON

In Dart, we use the `dart:convert` library.

### Import the Library

```dart
import 'dart:convert';
```

### JSON String to Dart Object (Decoding/Parsing)

```dart
void main() {
  // JSON as a string
  String jsonString = '''
  {
    "name": "Alice",
    "age": 25,
    "city": "NYC"
  }
  ''';

  // Parse JSON string to Map
  Map<String, dynamic> user = jsonDecode(jsonString);

  // Access values
  print(user['name']);  // Alice
  print(user['age']);   // 25
  print(user['city']);  // NYC
}
```

### Dart Object to JSON String (Encoding)

```dart
void main() {
  // Dart Map
  Map<String, dynamic> user = {
    'name': 'Bob',
    'age': 30,
    'city': 'LA'
  };

  // Convert to JSON string
  String jsonString = jsonEncode(user);

  print(jsonString);
  // {"name":"Bob","age":30,"city":"LA"}
}
```

---

## Parsing Complex JSON

### Example: Array of Objects

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  [
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30},
    {"name": "Charlie", "age": 35}
  ]
  ''';

  // Parse to List
  List<dynamic> users = jsonDecode(jsonString);

  // Access data
  print(users[0]['name']);  // Alice
  print(users[1]['age']);   // 30

  // Loop through all users
  for (var user in users) {
    print('${user['name']} is ${user['age']} years old');
  }
}
```

**Output:**
```
Alice
30
Alice is 25 years old
Bob is 30 years old
Charlie is 35 years old
```

### Example: Nested Objects

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "user": {
      "id": 1,
      "name": "Alice",
      "contact": {
        "email": "alice@example.com",
        "phone": "555-1234"
      }
    }
  }
  ''';

  Map<String, dynamic> data = jsonDecode(jsonString);

  // Access nested data
  String name = data['user']['name'];
  String email = data['user']['contact']['email'];

  print('Name: $name');
  print('Email: $email');
}
```

**Output:**
```
Name: Alice
Email: alice@example.com
```

---

## Why `Map<String, dynamic>`?

You'll see this type everywhere when working with JSON:

```dart
Map<String, dynamic> data = jsonDecode(jsonString);
```

**What does `dynamic` mean?**

JSON values can be different types:
```json
{
  "name": "Alice",      // String
  "age": 25,            // int
  "score": 95.5,        // double
  "isActive": true,     // bool
  "friends": [],        // List
  "metadata": {}        // Map
}
```

Since we don't know the exact type of every value, we use `dynamic`.

**Later**, you'll create **model classes** to make this type-safe. But for now, `Map<String, dynamic>` is perfect.

---

## Handling Null and Missing Values

JSON from APIs often has missing or null values:

```json
{
  "name": "Alice",
  "email": "alice@example.com",
  "phone": null,
  "age": 25
}
```

**Safe access in Dart:**

```dart
Map<String, dynamic> user = jsonDecode(jsonString);

String? phone = user['phone'];  // Might be null
print(phone);  // null

// Provide default value
String phoneNumber = user['phone'] ?? 'No phone';
print(phoneNumber);  // No phone
```

---

## Exercises

### Exercise 1: Parse Simple User

Given this JSON, parse it and print each field:

```json
{
  "id": 42,
  "username": "coder123",
  "email": "coder@example.com",
  "isActive": true
}
```

<details>
<summary>Solution</summary>

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "id": 42,
    "username": "coder123",
    "email": "coder@example.com",
    "isActive": true
  }
  ''';

  Map<String, dynamic> user = jsonDecode(jsonString);

  print('ID: ${user['id']}');
  print('Username: ${user['username']}');
  print('Email: ${user['email']}');
  print('Active: ${user['isActive']}');
}
```
</details>

---

### Exercise 2: Parse Array

Given this JSON array, print all product names:

```json
[
  {"id": 1, "name": "Laptop", "price": 999},
  {"id": 2, "name": "Mouse", "price": 25},
  {"id": 3, "name": "Keyboard", "price": 75}
]
```

<details>
<summary>Solution</summary>

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  [
    {"id": 1, "name": "Laptop", "price": 999},
    {"id": 2, "name": "Mouse", "price": 25},
    {"id": 3, "name": "Keyboard", "price": 75}
  ]
  ''';

  List<dynamic> products = jsonDecode(jsonString);

  for (var product in products) {
    print(product['name']);
  }
}
```

**Output:**
```
Laptop
Mouse
Keyboard
```
</details>

---

### Exercise 3: Create JSON from Dart

Create a Dart Map representing a book, then convert it to JSON:
- title: "1984"
- author: "George Orwell"
- year: 1949
- available: true

<details>
<summary>Solution</summary>

```dart
import 'dart:convert';

void main() {
  Map<String, dynamic> book = {
    'title': '1984',
    'author': 'George Orwell',
    'year': 1949,
    'available': true
  };

  String jsonString = jsonEncode(book);
  print(jsonString);
}
```

**Output:**
```
{"title":"1984","author":"George Orwell","year":1949,"available":true}
```
</details>

---

### Exercise 4: Parse Nested Data

Parse this JSON and extract the street address:

```json
{
  "user": "Alice",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  }
}
```

<details>
<summary>Solution</summary>

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "user": "Alice",
    "address": {
      "street": "123 Main St",
      "city": "New York",
      "zip": "10001"
    }
  }
  ''';

  Map<String, dynamic> data = jsonDecode(jsonString);
  String street = data['address']['street'];

  print('Street: $street');
}
```
</details>

---

### Exercise 5: Find Expensive Products

Given this products JSON, print names of products over $50:

```json
[
  {"name": "Laptop", "price": 999},
  {"name": "Mouse", "price": 25},
  {"name": "Monitor", "price": 299},
  {"name": "USB Cable", "price": 10}
]
```

<details>
<summary>Solution</summary>

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  [
    {"name": "Laptop", "price": 999},
    {"name": "Mouse", "price": 25},
    {"name": "Monitor", "price": 299},
    {"name": "USB Cable", "price": 10}
  ]
  ''';

  List<dynamic> products = jsonDecode(jsonString);

  print('Products over \$50:');
  for (var product in products) {
    if (product['price'] > 50) {
      print('- ${product['name']}: \$${product['price']}');
    }
  }
}
```

**Output:**
```
Products over $50:
- Laptop: $999
- Monitor: $299
```
</details>

---

## Key Takeaways

1. **JSON is text** - structured data as a string
2. **6 data types:** objects, arrays, strings, numbers, booleans, null
3. **`jsonDecode()`** converts JSON string to Dart objects
4. **`jsonEncode()`** converts Dart objects to JSON string
5. **Keys must be strings** with double quotes
6. **No trailing commas** or comments
7. **`Map<String, dynamic>`** for JSON objects
8. **`List<dynamic>`** for JSON arrays

---

## What's Next?

Tomorrow we'll learn:
- **Data Models** - Creating classes for JSON
- **Type-safe JSON** - No more `dynamic`
- **fromJson() and toJson()** methods

You now understand JSON! This is huge - you can now understand what APIs send and receive. 🎉
