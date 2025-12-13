# Maps: Key-Value Collections

## What Is a Map?

A **Map** stores data as key-value pairs. Think of it like a dictionary:
- **Key** = the word you look up
- **Value** = the definition you find

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};
```

Key characteristics:
- **Key-value pairs**: Every entry has a key and a value
- **Unique keys**: Each key can only appear once
- **Fast lookup**: Finding a value by key is very fast
- **Any type**: Keys and values can be any type

---

## Creating Maps

### Empty Map

```dart
// Using literal
var scores = <String, int>{};

// Using constructor
var ages = Map<String, int>();

// Type-inferred
Map<String, String> names = {};
```

### Map with Initial Values

```dart
var person = {
  'name': 'Alice',
  'city': 'NYC',
  'country': 'USA',
};

Map<String, int> scores = {
  'math': 95,
  'science': 87,
  'english': 92,
};
```

### From Lists

```dart
// From list of entries
var list = [
  MapEntry('a', 1),
  MapEntry('b', 2),
];
var map = Map.fromEntries(list);

// From two lists (keys and values)
var keys = ['name', 'age', 'city'];
var values = ['Alice', 25, 'NYC'];
var combined = Map.fromIterables(keys, values);
print(combined);  // {name: Alice, age: 25, city: NYC}
```

---

## Visual: Map Structure

```
   Key        Value
  ┌─────┐    ┌─────┐
  │'Alice'│ → │ 25  │
  └─────┘    └─────┘
  ┌─────┐    ┌─────┐
  │'Bob' │ → │ 30  │
  └─────┘    └─────┘
  ┌─────┐    ┌─────┐
  │'Charlie'│ → │ 35  │
  └─────┘    └─────┘
```

---

## Accessing Values

### By Key

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

print(ages['Alice']);    // 25
print(ages['Bob']);      // 30
print(ages['Unknown']);  // null (key doesn't exist)
```

### Safe Access

```dart
var ages = {'Alice': 25, 'Bob': 30};

// Returns null if key doesn't exist
int? aliceAge = ages['Alice'];  // 25
int? daveAge = ages['Dave'];    // null

// With default value
int age = ages['Dave'] ?? 0;  // 0
```

### Check if Key Exists

```dart
var ages = {'Alice': 25, 'Bob': 30};

if (ages.containsKey('Alice')) {
  print('Alice is in the map');
}

if (ages.containsValue(30)) {
  print('Someone is 30');
}
```

---

## Modifying Maps

### Adding/Updating

```dart
var ages = {'Alice': 25};

// Add new key
ages['Bob'] = 30;
print(ages);  // {Alice: 25, Bob: 30}

// Update existing key
ages['Alice'] = 26;
print(ages);  // {Alice: 26, Bob: 30}

// Add multiple
ages.addAll({'Charlie': 35, 'Dave': 40});
print(ages);  // {Alice: 26, Bob: 30, Charlie: 35, Dave: 40}
```

### Conditional Add

```dart
var ages = {'Alice': 25};

// Only adds if key doesn't exist
ages.putIfAbsent('Alice', () => 100);  // Won't change, Alice exists
ages.putIfAbsent('Bob', () => 30);     // Adds Bob: 30

print(ages);  // {Alice: 25, Bob: 30}
```

### Removing

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

// Remove by key
ages.remove('Bob');
print(ages);  // {Alice: 25, Charlie: 35}

// Remove by condition
ages.removeWhere((key, value) => value > 30);
print(ages);  // {Alice: 25}

// Clear all
ages.clear();
print(ages);  // {}
```

---

## Map Properties

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

print(ages.length);      // 3
print(ages.isEmpty);     // false
print(ages.isNotEmpty);  // true
print(ages.keys);        // (Alice, Bob, Charlie)
print(ages.values);      // (25, 30, 35)
print(ages.entries);     // (MapEntry(Alice: 25), ...)
```

---

## Iterating Through Maps

### Using forEach

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

ages.forEach((key, value) {
  print('$key is $value years old');
});
```

### Using for-in with entries

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

for (var entry in ages.entries) {
  print('${entry.key}: ${entry.value}');
}
```

### Iterate Keys Only

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

for (var name in ages.keys) {
  print(name);
}
```

### Iterate Values Only

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

for (var age in ages.values) {
  print(age);
}
```

---

## Transforming Maps

### map() - Transform Entries

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

// Double all ages
var doubled = ages.map((key, value) => MapEntry(key, value * 2));
print(doubled);  // {Alice: 50, Bob: 60, Charlie: 70}

// Uppercase keys
var upper = ages.map((key, value) => MapEntry(key.toUpperCase(), value));
print(upper);  // {ALICE: 25, BOB: 30, CHARLIE: 35}
```

### Convert to List

```dart
var ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};

// Keys to list
List<String> names = ages.keys.toList();

// Values to list
List<int> ageList = ages.values.toList();

// Entries to list of strings
List<String> info = ages.entries
    .map((e) => '${e.key}: ${e.value}')
    .toList();
print(info);  // [Alice: 25, Bob: 30, Charlie: 35]
```

### Filter Entries

```dart
var scores = {'Alice': 95, 'Bob': 67, 'Charlie': 82, 'Dave': 45};

// Keep only passing scores (>= 70)
var passing = Map.fromEntries(
  scores.entries.where((e) => e.value >= 70)
);
print(passing);  // {Alice: 95, Charlie: 82}
```

---

## Nested Maps

Maps can contain other maps:

```dart
var users = {
  'user1': {
    'name': 'Alice',
    'age': 25,
    'address': {
      'city': 'NYC',
      'country': 'USA',
    },
  },
  'user2': {
    'name': 'Bob',
    'age': 30,
    'address': {
      'city': 'London',
      'country': 'UK',
    },
  },
};

// Access nested values
print(users['user1']?['name']);  // Alice
print(users['user1']?['address']?['city']);  // NYC
```

---

## Common Patterns

### Counting Occurrences

```dart
void main() {
  var words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple'];

  var counts = <String, int>{};

  for (var word in words) {
    counts[word] = (counts[word] ?? 0) + 1;
  }

  print(counts);  // {apple: 3, banana: 2, cherry: 1}
}
```

### Grouping Items

```dart
void main() {
  var people = [
    {'name': 'Alice', 'city': 'NYC'},
    {'name': 'Bob', 'city': 'LA'},
    {'name': 'Charlie', 'city': 'NYC'},
    {'name': 'Dave', 'city': 'LA'},
  ];

  var byCity = <String, List<String>>{};

  for (var person in people) {
    var city = person['city'] as String;
    var name = person['name'] as String;

    byCity.putIfAbsent(city, () => []);
    byCity[city]!.add(name);
  }

  print(byCity);
  // {NYC: [Alice, Charlie], LA: [Bob, Dave]}
}
```

### Inverting a Map

```dart
void main() {
  var original = {'a': 1, 'b': 2, 'c': 3};

  var inverted = original.map((key, value) => MapEntry(value, key));
  print(inverted);  // {1: a, 2: b, 3: c}
}
```

---

## Map vs List: When to Use Which?

### Use List When:
- Order matters
- You access by position (index)
- You have a sequence of similar items

```dart
var todos = ['Buy milk', 'Call mom', 'Do laundry'];
print(todos[0]);  // First item
```

### Use Map When:
- You need to look up by a specific identifier
- Data has natural key-value relationship
- Fast lookup is important

```dart
var userById = {
  'user123': 'Alice',
  'user456': 'Bob',
};
print(userById['user123']);  // Direct lookup
```

---

## Practical Examples

### Example 1: Configuration

```dart
void main() {
  Map<String, dynamic> config = {
    'appName': 'MyApp',
    'version': '1.0.0',
    'debug': true,
    'maxRetries': 3,
    'apiUrl': 'https://api.example.com',
  };

  print('App: ${config['appName']}');
  print('Version: ${config['version']}');

  if (config['debug'] == true) {
    print('Running in debug mode');
  }
}
```

### Example 2: User Profile

```dart
void main() {
  Map<String, dynamic> user = {
    'id': 12345,
    'name': 'Alice Smith',
    'email': 'alice@email.com',
    'preferences': {
      'theme': 'dark',
      'notifications': true,
      'language': 'en',
    },
  };

  // Access nested preference
  var theme = user['preferences']?['theme'] ?? 'light';
  print('Theme: $theme');

  // Update preference
  (user['preferences'] as Map)['theme'] = 'light';
  print('Updated theme: ${user['preferences']['theme']}');
}
```

### Example 3: Word Frequency Counter

```dart
void main() {
  String text = 'the quick brown fox jumps over the lazy dog the fox';

  // Split into words
  var words = text.toLowerCase().split(' ');

  // Count each word
  var frequency = <String, int>{};
  for (var word in words) {
    frequency[word] = (frequency[word] ?? 0) + 1;
  }

  // Sort by frequency
  var sorted = frequency.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // Print results
  print('Word Frequency:');
  for (var entry in sorted) {
    print('${entry.key}: ${entry.value}');
  }
}
```

### Example 4: Menu with Prices

```dart
void main() {
  Map<String, double> menu = {
    'Coffee': 3.50,
    'Tea': 2.50,
    'Sandwich': 7.00,
    'Salad': 6.50,
    'Cake': 4.00,
  };

  // Order
  Map<String, int> order = {
    'Coffee': 2,
    'Sandwich': 1,
    'Cake': 1,
  };

  // Calculate total
  double total = 0;
  order.forEach((item, quantity) {
    double price = menu[item] ?? 0;
    double subtotal = price * quantity;
    print('$quantity x $item @ \$${price.toStringAsFixed(2)} = \$${subtotal.toStringAsFixed(2)}');
    total += subtotal;
  });

  print('---');
  print('Total: \$${total.toStringAsFixed(2)}');
}
```

---

## Summary

| Operation | Method | Example |
|-----------|--------|---------|
| Create | `{}` or `Map()` | `var m = {'a': 1}` |
| Access | `[]` | `m['a']` |
| Add/Update | `[]=` | `m['b'] = 2` |
| Remove | `remove()` | `m.remove('a')` |
| Check key | `containsKey()` | `m.containsKey('a')` |
| Iterate | `forEach()`, `entries` | `m.forEach((k,v) => ...)` |
| Transform | `map()` | `m.map((k,v) => ...)` |

---

## Quick Quiz

**Q1:** What does this print?

```dart
var m = {'a': 1, 'b': 2};
print(m['c']);
```

<details>
<summary>Answer</summary>

`null` - key 'c' doesn't exist.

</details>

**Q2:** How do you add a key only if it doesn't exist?

<details>
<summary>Answer</summary>

```dart
map.putIfAbsent('key', () => value);
```

</details>

**Q3:** What's wrong here?

```dart
var ages = {'Alice': 25, 'Alice': 30};
print(ages['Alice']);
```

<details>
<summary>Answer</summary>

Keys must be unique. The second 'Alice' overwrites the first. Prints `30`.

</details>

---

**Next:** Learn about Sets for unique collections.

---

**Continue to:** `06-Sets.md`
