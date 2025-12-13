# JSON Basics

Learn how to work with JSON - the universal language of APIs!

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

## Nested JSON (Objects within Objects)

This is VERY common in real APIs:

```dart
String complexJson = '''
{
  "id": 1,
  "name": "John Doe",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  },
  "hobbies": ["reading", "gaming", "cooking"],
  "friends": [
    {"id": 2, "name": "Jane"},
    {"id": 3, "name": "Bob"}
  ]
}
''';
```

### Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    NESTED JSON                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  {                                                          │
│    "id": 1,                     ← Simple value              │
│    "name": "John",              ← Simple value              │
│    "address": {                 ← Nested object             │
│      "street": "123 Main",      │                          │
│      "city": "NYC"              │                          │
│    },                           │                          │
│    "hobbies": [                 ← Array of strings          │
│      "reading",                 │                          │
│      "gaming"                   │                          │
│    ],                           │                          │
│    "friends": [                 ← Array of objects          │
│      {"name": "Jane"},          │                          │
│      {"name": "Bob"}            │                          │
│    ]                            │                          │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Converting JSON in Dart

### The dart:convert Library

```dart
import 'dart:convert';  // Always import this!

void main() {
  // ═══════════════════════════════════════════════════════════
  // JSON String → Dart Object (DECODING / PARSING)
  // ═══════════════════════════════════════════════════════════

  String jsonString = '{"name": "John", "age": 25}';

  // Parse JSON string to Dart Map
  Map<String, dynamic> user = json.decode(jsonString);

  print(user['name']);  // John
  print(user['age']);   // 25

  // ═══════════════════════════════════════════════════════════
  // Dart Object → JSON String (ENCODING / SERIALIZATION)
  // ═══════════════════════════════════════════════════════════

  Map<String, dynamic> newUser = {
    'name': 'Jane',
    'age': 30,
    'email': 'jane@test.com',
  };

  // Convert Dart Map to JSON string
  String jsonOutput = json.encode(newUser);

  print(jsonOutput);  // {"name":"Jane","age":30,"email":"jane@test.com"}
}
```

### Visual: The Conversion Process

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON CONVERSION                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FROM API (receive)               TO API (send)             │
│  ─────────────────                ─────────────             │
│                                                             │
│  JSON String                      Dart Object               │
│       │                                │                    │
│       │  json.decode()                 │  json.encode()     │
│       ▼                                ▼                    │
│  Dart Object                      JSON String               │
│                                                             │
│  ┌─────────────┐                 ┌─────────────┐           │
│  │ '{"a": 1}'  │ ──decode()──→   │ {'a': 1}    │           │
│  │ (String)    │                 │ (Map)       │           │
│  └─────────────┘                 └─────────────┘           │
│                                                             │
│  ┌─────────────┐                 ┌─────────────┐           │
│  │ {'a': 1}    │ ──encode()──→   │ '{"a": 1}'  │           │
│  │ (Map)       │                 │ (String)    │           │
│  └─────────────┘                 └─────────────┘           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Working with JSON Arrays

```dart
import 'dart:convert';

void main() {
  // JSON array of users
  String jsonUsers = '''
  [
    {"id": 1, "name": "John", "age": 25},
    {"id": 2, "name": "Jane", "age": 30},
    {"id": 3, "name": "Bob", "age": 35}
  ]
  ''';

  // Decode to Dart List
  List<dynamic> users = json.decode(jsonUsers);

  // Access items
  print(users[0]['name']);  // John
  print(users.length);       // 3

  // Loop through
  for (var user in users) {
    print('${user['name']} is ${user['age']} years old');
  }

  // Map to specific type (better!)
  List<Map<String, dynamic>> typedUsers =
      List<Map<String, dynamic>>.from(users);
}
```

---

## Accessing Nested Data

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "user": {
      "name": "John",
      "address": {
        "city": "New York",
        "zip": "10001"
      },
      "phones": ["555-1234", "555-5678"]
    }
  }
  ''';

  Map<String, dynamic> data = json.decode(jsonString);

  // Accessing nested values - chain the keys!
  String name = data['user']['name'];              // John
  String city = data['user']['address']['city'];   // New York
  String firstPhone = data['user']['phones'][0];   // 555-1234

  print('$name lives in $city');
  print('Phone: $firstPhone');
}
```

### Visual: Navigating Nested JSON

```
┌─────────────────────────────────────────────────────────────┐
│                NAVIGATING NESTED JSON                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  data['user']['address']['city']                            │
│                                                             │
│  Step 1: data['user']                                       │
│         ↓                                                   │
│  {                                                          │
│    "user": { ←────── GET THIS                               │
│      "name": "John",                                        │
│      "address": {...}                                       │
│    }                                                        │
│  }                                                          │
│                                                             │
│  Step 2: ...['address']                                     │
│         ↓                                                   │
│  {                                                          │
│    "name": "John",                                          │
│    "address": { ←────── GET THIS                            │
│      "city": "NYC",                                         │
│      "zip": "10001"                                         │
│    }                                                        │
│  }                                                          │
│                                                             │
│  Step 3: ...['city']                                        │
│         ↓                                                   │
│  "NYC" ←────── FINAL VALUE!                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Safe JSON Access (Handling Missing Keys)

```dart
import 'dart:convert';

void main() {
  String jsonString = '{"name": "John"}';  // No 'age' key!
  Map<String, dynamic> user = json.decode(jsonString);

  // ❌ DANGEROUS - Crashes if key doesn't exist
  // int age = user['age'];  // Error: null is not int

  // ✅ SAFE - Check if key exists
  if (user.containsKey('age')) {
    int age = user['age'];
  }

  // ✅ SAFE - Use null-aware operator with default
  int age = user['age'] ?? 0;  // Returns 0 if null

  // ✅ SAFE - Use conditional access
  String? email = user['email'] as String?;  // null if missing

  // ✅ BEST - Check type too
  dynamic value = user['age'];
  if (value != null && value is int) {
    int age = value;
  }
}
```

---

## Common JSON Patterns from APIs

### Pattern 1: Single Object Response

```dart
// API returns one item
String response = '''
{
  "id": 1,
  "title": "Hello World",
  "body": "This is my first post"
}
''';

Map<String, dynamic> post = json.decode(response);
```

### Pattern 2: Array Response

```dart
// API returns list of items
String response = '''
[
  {"id": 1, "name": "John"},
  {"id": 2, "name": "Jane"}
]
''';

List<dynamic> users = json.decode(response);
```

### Pattern 3: Wrapped Response (very common!)

```dart
// API wraps data with metadata
String response = '''
{
  "status": "success",
  "count": 2,
  "data": [
    {"id": 1, "name": "John"},
    {"id": 2, "name": "Jane"}
  ]
}
''';

Map<String, dynamic> result = json.decode(response);
String status = result['status'];      // "success"
int count = result['count'];           // 2
List<dynamic> users = result['data'];  // The actual data
```

### Pattern 4: Paginated Response

```dart
// API returns paginated data
String response = '''
{
  "page": 1,
  "per_page": 10,
  "total": 100,
  "total_pages": 10,
  "data": [
    {"id": 1, "name": "John"},
    {"id": 2, "name": "Jane"}
  ]
}
''';
```

---

## Error Handling with JSON

```dart
import 'dart:convert';

void main() {
  String badJson = '{"name": "John", age: 25}';  // Missing quotes!

  try {
    Map<String, dynamic> user = json.decode(badJson);
  } on FormatException catch (e) {
    print('Invalid JSON: $e');
    // Handle the error gracefully
  }
}
```

### Visual: JSON Errors

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

## Pretty Printing JSON

```dart
import 'dart:convert';

void main() {
  Map<String, dynamic> user = {
    'name': 'John',
    'age': 25,
    'address': {
      'city': 'New York',
      'zip': '10001',
    },
  };

  // Compact JSON (default)
  String compact = json.encode(user);
  print(compact);
  // {"name":"John","age":25,"address":{"city":"New York","zip":"10001"}}

  // Pretty JSON (readable)
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(user);
  print(pretty);
  // {
  //   "name": "John",
  //   "age": 25,
  //   "address": {
  //     "city": "New York",
  //     "zip": "10001"
  //   }
  // }
}
```

---

## Complete Example: API Response Handling

```dart
import 'dart:convert';

void main() {
  // Simulated API response
  String apiResponse = '''
  {
    "status": "success",
    "data": {
      "users": [
        {
          "id": 1,
          "name": "John Doe",
          "email": "john@example.com",
          "profile": {
            "avatar": "https://example.com/avatar1.jpg",
            "bio": "Software Developer"
          }
        },
        {
          "id": 2,
          "name": "Jane Smith",
          "email": "jane@example.com",
          "profile": {
            "avatar": "https://example.com/avatar2.jpg",
            "bio": "Product Manager"
          }
        }
      ],
      "total": 2
    }
  }
  ''';

  try {
    // Parse the JSON
    Map<String, dynamic> response = json.decode(apiResponse);

    // Check status
    if (response['status'] == 'success') {
      // Get the data
      Map<String, dynamic> data = response['data'];
      List<dynamic> users = data['users'];
      int total = data['total'];

      print('Found $total users:');

      // Process each user
      for (var user in users) {
        String name = user['name'];
        String email = user['email'];
        String bio = user['profile']['bio'];

        print('- $name ($email) - $bio');
      }
    }
  } on FormatException catch (e) {
    print('Failed to parse JSON: $e');
  }
}

// Output:
// Found 2 users:
// - John Doe (john@example.com) - Software Developer
// - Jane Smith (jane@example.com) - Product Manager
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    JSON CHEAT SHEET                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  IMPORT:                                                    │
│  import 'dart:convert';                                     │
│                                                             │
│  DECODE (JSON → Dart):                                      │
│  Map<String, dynamic> data = json.decode(jsonString);       │
│  List<dynamic> list = json.decode(jsonArrayString);         │
│                                                             │
│  ENCODE (Dart → JSON):                                      │
│  String jsonString = json.encode(dartMap);                  │
│  String jsonArray = json.encode(dartList);                  │
│                                                             │
│  ACCESS DATA:                                               │
│  data['key']                    → Get value                 │
│  data['outer']['inner']         → Get nested value          │
│  data['array'][0]               → Get array item            │
│  data['key'] ?? defaultValue    → Safe access               │
│                                                             │
│  JSON TYPES → DART TYPES:                                   │
│  "string"  →  String                                        │
│  123       →  int                                           │
│  12.34     →  double                                        │
│  true      →  bool                                          │
│  null      →  null                                          │
│  [...]     →  List<dynamic>                                 │
│  {...}     →  Map<String, dynamic>                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← HTTP Methods](./02-HTTPMethods.md) | [Next: The http Package →](./04-HttpPackage.md)
