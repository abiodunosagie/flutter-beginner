# JSON Basics - Part 3: Nested JSON

Master complex JSON structures with nested objects and lists!

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

## Working with Lists in JSON

### Simple List

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "name": "John",
    "hobbies": ["reading", "gaming", "cooking"]
  }
  ''';

  Map<String, dynamic> data = json.decode(jsonString);
  List<dynamic> hobbies = data['hobbies'];

  print('Hobbies:');
  for (var hobby in hobbies) {
    print('- $hobby');
  }
}
```

### List of Objects

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "name": "John",
    "friends": [
      {"id": 1, "name": "Jane", "age": 28},
      {"id": 2, "name": "Bob", "age": 32},
      {"id": 3, "name": "Alice", "age": 25}
    ]
  }
  ''';

  Map<String, dynamic> data = json.decode(jsonString);
  List<dynamic> friends = data['friends'];

  print('Friends:');
  for (var friend in friends) {
    print('- ${friend['name']} (${friend['age']} years old)');
  }

  // Access specific friend
  String firstFriend = friends[0]['name'];  // Jane
  int friendCount = friends.length;          // 3
}
```

---

## Complex Real-World Example

```dart
import 'dart:convert';

void main() {
  // Typical e-commerce product response
  String productJson = '''
  {
    "id": 101,
    "name": "Laptop Pro",
    "price": 1299.99,
    "inStock": true,
    "categories": ["Electronics", "Computers"],
    "specifications": {
      "cpu": "Intel i7",
      "ram": "16GB",
      "storage": "512GB SSD"
    },
    "reviews": [
      {
        "author": "John",
        "rating": 5,
        "comment": "Excellent laptop!",
        "date": "2024-01-15"
      },
      {
        "author": "Jane",
        "rating": 4,
        "comment": "Good value",
        "date": "2024-01-20"
      }
    ],
    "seller": {
      "id": 50,
      "name": "TechStore",
      "rating": 4.8,
      "location": {
        "city": "San Francisco",
        "country": "USA"
      }
    }
  }
  ''';

  Map<String, dynamic> product = json.decode(productJson);

  // Simple values
  String name = product['name'];
  double price = product['price'];
  bool inStock = product['inStock'];

  // Array
  List<dynamic> categories = product['categories'];
  String firstCategory = categories[0];

  // Nested object
  Map<String, dynamic> specs = product['specifications'];
  String cpu = specs['cpu'];

  // Array of objects
  List<dynamic> reviews = product['reviews'];
  int totalReviews = reviews.length;
  double firstRating = reviews[0]['rating'].toDouble();

  // Deeply nested
  String sellerCity = product['seller']['location']['city'];

  // Print summary
  print('Product: $name');
  print('Price: \$$price');
  print('In Stock: $inStock');
  print('Category: $firstCategory');
  print('CPU: $cpu');
  print('Reviews: $totalReviews');
  print('Sold by: ${product['seller']['name']} in $sellerCity');

  // Calculate average rating
  double totalRating = 0;
  for (var review in reviews) {
    totalRating += review['rating'];
  }
  double avgRating = totalRating / reviews.length;
  print('Average Rating: ${avgRating.toStringAsFixed(1)}');
}
```

---

## Handling Deeply Nested Structures

### The Safe Way

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "company": {
      "departments": [
        {
          "name": "Engineering",
          "teams": [
            {
              "name": "Frontend",
              "members": [
                {"name": "Alice", "role": "Senior Dev"}
              ]
            }
          ]
        }
      ]
    }
  }
  ''';

  Map<String, dynamic> data = json.decode(jsonString);

  // ❌ DANGEROUS - Can crash if any level is missing
  // String name = data['company']['departments'][0]['teams'][0]['members'][0]['name'];

  // ✅ SAFE - Check each level
  if (data.containsKey('company')) {
    Map<String, dynamic> company = data['company'];

    if (company.containsKey('departments')) {
      List<dynamic> departments = company['departments'];

      if (departments.isNotEmpty) {
        Map<String, dynamic> dept = departments[0];

        if (dept.containsKey('teams')) {
          List<dynamic> teams = dept['teams'];

          if (teams.isNotEmpty) {
            Map<String, dynamic> team = teams[0];

            if (team.containsKey('members')) {
              List<dynamic> members = team['members'];

              if (members.isNotEmpty) {
                String name = members[0]['name'];
                print('Found: $name');
              }
            }
          }
        }
      }
    }
  }
}
```

### The Helper Function Way

```dart
// Helper function for safe access
dynamic getNestedValue(Map<String, dynamic> map, List<String> keys) {
  dynamic current = map;

  for (String key in keys) {
    if (current is Map && current.containsKey(key)) {
      current = current[key];
    } else {
      return null;
    }
  }

  return current;
}

void main() {
  String jsonString = '''{"company": {"name": "TechCorp", "ceo": {"name": "John"}}}''';

  Map<String, dynamic> data = json.decode(jsonString);

  // Access safely
  String? companyName = getNestedValue(data, ['company', 'name']);
  String? ceoName = getNestedValue(data, ['company', 'ceo', 'name']);
  String? missing = getNestedValue(data, ['company', 'cto', 'name']);

  print('Company: ${companyName ?? 'Unknown'}');  // TechCorp
  print('CEO: ${ceoName ?? 'Unknown'}');          // John
  print('CTO: ${missing ?? 'Unknown'}');          // Unknown
}
```

---

## Working with Mixed Data Types

```dart
import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "user": {
      "id": 1,
      "name": "John",
      "scores": [95, 87, 92],
      "metadata": {
        "loginCount": 42,
        "lastLogin": "2024-01-15",
        "preferences": {
          "theme": "dark",
          "notifications": true
        }
      }
    }
  }
  ''';

  Map<String, dynamic> data = json.decode(jsonString);

  // Simple access
  int id = data['user']['id'];
  String name = data['user']['name'];

  // Array of numbers
  List<dynamic> scores = data['user']['scores'];
  int firstScore = scores[0];
  double avgScore = scores.reduce((a, b) => a + b) / scores.length;

  // Nested objects
  int loginCount = data['user']['metadata']['loginCount'];
  bool notifications = data['user']['metadata']['preferences']['notifications'];

  print('User: $name (ID: $id)');
  print('Average Score: ${avgScore.toStringAsFixed(1)}');
  print('Login Count: $loginCount');
  print('Notifications: ${notifications ? "ON" : "OFF"}');
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              NESTED JSON CHEAT SHEET                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ACCESSING NESTED DATA:                                     │
│  data['level1']['level2']['level3']                         │
│                                                             │
│  ARRAYS IN OBJECTS:                                         │
│  data['items'][0]['name']                                   │
│                                                             │
│  OBJECTS IN ARRAYS:                                         │
│  List<dynamic> items = data['items'];                       │
│  for (var item in items) {                                  │
│    print(item['name']);                                     │
│  }                                                          │
│                                                             │
│  SAFE ACCESS:                                               │
│  • Check with containsKey()                                 │
│  • Use null-aware operators (??, ?.)                        │
│  • Validate before accessing deep nesting                   │
│                                                             │
│  COMMON PATTERNS:                                           │
│  • Simple list: data['items']                               │
│  • List of objects: data['users'][0]['name']                │
│  • Nested objects: data['user']['profile']['bio']           │
│  • Mixed nesting: data['dept']['teams'][0]['lead']['name']  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

Excellent work! You now understand JSON from basics to complex nested structures. You're ready to work with real APIs!

---

**What's Next:** Now that you know JSON, you'll learn how to actually fetch it from APIs using the http package!

---

[← Previous: JSON Parsing](./03b-JSONParsing.md) | [⬆️ Back to Learning Path](./00-LearningPath.md) | [➡️ Next: Http Package](./04a-HttpSetup.md)

---

## Navigation

⬅️ **Previous:** [JSON Parsing](03b-JSONParsing.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Http Setup](04a-HttpSetup.md)
