# JSON Basics - Part 2: Parsing JSON

Learn how to convert between JSON strings and Dart objects!

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

## Common API Response Patterns

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

Map<String, dynamic> result = json.decode(response);
int currentPage = result['page'];
int totalPages = result['total_pages'];
List<dynamic> users = result['data'];
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
│                    JSON PARSING CHEAT SHEET                  │
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
│  ERROR HANDLING:                                            │
│  try {                                                      │
│    json.decode(string);                                     │
│  } on FormatException catch (e) {                           │
│    // Handle invalid JSON                                   │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Great job! Now you know how to parse JSON. Next, you'll learn how to work with complex nested structures.

---

**Continue to:** [03c-NestedJSON.md](./03c-NestedJSON.md) - Master nested JSON and complex structures!

---

[← Previous: JSON Intro](./03a-JSONIntro.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: Nested JSON](./03c-NestedJSON.md)

---

## Navigation

⬅️ **Previous:** [JSON Introduction](03a-JSONIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Nested JSON](03c-NestedJSON.md)
