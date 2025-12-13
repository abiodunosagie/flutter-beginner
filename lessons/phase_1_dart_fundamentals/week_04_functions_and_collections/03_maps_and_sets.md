# Week 4, Day 6-7: Maps and Sets - More Collection Types

## Maps - Key-Value Pairs

### What is a Map?

Think of a **real dictionary:**
```
Word (Key)     → Definition (Value)
"Apple"        → "A round fruit"
"Banana"       → "A long yellow fruit"
"Cherry"       → "A small red fruit"
```

In Dart, a **Map** is like a dictionary - it stores **key-value pairs**.

**Real-world examples:**
- Phone book: Name → Phone Number
- Shopping prices: Product → Price
- User settings: Setting Name → Value
- Translation: English Word → Spanish Word

---

## Creating Maps

### Empty Map

```dart
Map<String, int> ages = {};
Map<String, String> capitals = {};

// Or with explicit constructor
Map<String, double> prices = Map();
```

### Map with Initial Values

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

Map<String, String> capitals = {
  'USA': 'Washington DC',
  'France': 'Paris',
  'Japan': 'Tokyo',
};

Map<String, double> prices = {
  'Apple': 0.99,
  'Banana': 0.59,
  'Cherry': 2.99,
};
```

### Type Inference

```dart
var user = {
  'name': 'Alice',
  'email': 'alice@example.com',
  'age': 25,
};
// Dart infers: Map<String, Object>
```

---

## Accessing Values

### By Key

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

print(ages['Alice']);    // 25
print(ages['Bob']);      // 30
print(ages['David']);    // null (key doesn't exist)
```

### Safe Access with Default Value

```dart
Map<String, int> ages = {'Alice': 25};

// If key doesn't exist, return default
int bobAge = ages['Bob'] ?? 0;
print(bobAge);  // 0
```

---

## Adding and Updating

### Add/Update Single Entry

```dart
Map<String, int> ages = {'Alice': 25};

// Add new entry
ages['Bob'] = 30;
print(ages);  // {Alice: 25, Bob: 30}

// Update existing entry
ages['Alice'] = 26;
print(ages);  // {Alice: 26, Bob: 30}
```

### addAll() - Add Multiple Entries

```dart
Map<String, int> ages = {'Alice': 25};

ages.addAll({
  'Bob': 30,
  'Charlie': 35,
});

print(ages);  // {Alice: 25, Bob: 30, Charlie: 35}
```

### putIfAbsent() - Add Only if Key Doesn't Exist

```dart
Map<String, int> ages = {'Alice': 25};

ages.putIfAbsent('Bob', () => 30);
print(ages);  // {Alice: 25, Bob: 30}

ages.putIfAbsent('Alice', () => 99);  // Doesn't update! Key exists
print(ages);  // {Alice: 25, Bob: 30}
```

---

## Removing Entries

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

// Remove by key
ages.remove('Bob');
print(ages);  // {Alice: 25, Charlie: 35}

// Remove all
ages.clear();
print(ages);  // {}
```

---

## Map Properties

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

// Number of entries
print(ages.length);        // 3

// Is empty?
print(ages.isEmpty);       // false
print(ages.isNotEmpty);    // true

// All keys
print(ages.keys);          // (Alice, Bob, Charlie)

// All values
print(ages.values);        // (25, 30, 35)
```

---

## Checking Keys and Values

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
};

// Check if key exists
print(ages.containsKey('Alice'));    // true
print(ages.containsKey('Charlie'));  // false

// Check if value exists
print(ages.containsValue(25));  // true
print(ages.containsValue(99));  // false
```

---

## Iterating Through Maps

### for-in with keys

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

for (var name in ages.keys) {
  print('$name is ${ages[name]} years old');
}
```

**Output:**
```
Alice is 25 years old
Bob is 30 years old
Charlie is 35 years old
```

### forEach()

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35,
};

ages.forEach((name, age) {
  print('$name: $age');
});
```

### entries - Key-Value Pairs

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
};

for (var entry in ages.entries) {
  print('${entry.key} → ${entry.value}');
}
```

---

## Transforming Maps

### map() - Transform Values

```dart
Map<String, int> prices = {
  'Apple': 100,
  'Banana': 50,
  'Cherry': 200,
};

// Apply 10% discount
var discounted = prices.map((key, value) =>
  MapEntry(key, value * 0.9)
);

print(discounted);
// {Apple: 90.0, Banana: 45.0, Cherry: 180.0}
```

---

## Real-World Examples

### Example 1: User Profile

```dart
Map<String, dynamic> user = {
  'id': 123,
  'name': 'Alice',
  'email': 'alice@example.com',
  'age': 25,
  'isPremium': true,
  'followers': 1250,
};

print('User: ${user['name']}');
print('Email: ${user['email']}');
print('Premium: ${user['isPremium']}');
```

### Example 2: Product Inventory

```dart
Map<String, int> inventory = {
  'Laptop': 15,
  'Mouse': 50,
  'Keyboard': 30,
};

// Check stock
String product = 'Laptop';
if (inventory.containsKey(product)) {
  int stock = inventory[product]!;
  if (stock > 0) {
    print('$product: $stock in stock');
  } else {
    print('$product: Out of stock');
  }
}

// Sell item
void sellProduct(String product) {
  if (inventory.containsKey(product) && inventory[product]! > 0) {
    inventory[product] = inventory[product]! - 1;
    print('Sold $product. Remaining: ${inventory[product]}');
  } else {
    print('Cannot sell $product');
  }
}

sellProduct('Laptop');  // Sold Laptop. Remaining: 14
```

### Example 3: Grade Book

```dart
Map<String, List<int>> grades = {
  'Alice': [85, 92, 88],
  'Bob': [78, 85, 90],
  'Charlie': [95, 88, 92],
};

// Calculate average for each student
grades.forEach((student, scores) {
  double average = scores.reduce((a, b) => a + b) / scores.length;
  print('$student: ${average.toStringAsFixed(2)}');
});

// Add new grade
grades['Alice']!.add(90);
print('Alice grades: ${grades['Alice']}');
```

---

## Sets - Unique Collections

### What is a Set?

A **Set** is a collection of **unique items** (no duplicates).

Think of it like:
- Lottery numbers (each number appears once)
- Unique usernames (can't have duplicates)
- Tags/categories (each tag is unique)

**Key characteristics:**
- **Unordered** - No specific position
- **Unique** - No duplicate values
- **Fast lookup** - Checking if item exists is very fast

---

## Creating Sets

### Empty Set

```dart
Set<int> numbers = {};
Set<String> tags = Set();
```

### Set with Initial Values

```dart
Set<int> numbers = {1, 2, 3, 4, 5};
Set<String> fruits = {'Apple', 'Banana', 'Cherry'};

// Duplicates are automatically removed!
Set<int> withDuplicates = {1, 2, 2, 3, 3, 3};
print(withDuplicates);  // {1, 2, 3}
```

### From List (Remove Duplicates)

```dart
List<int> numbers = [1, 2, 2, 3, 3, 3, 4, 4, 5];
Set<int> unique = numbers.toSet();
print(unique);  // {1, 2, 3, 4, 5}
```

---

## Adding to Sets

```dart
Set<String> fruits = {'Apple', 'Banana'};

// Add single item
fruits.add('Cherry');
print(fruits);  // {Apple, Banana, Cherry}

// Try adding duplicate (no effect)
fruits.add('Apple');
print(fruits);  // {Apple, Banana, Cherry} (unchanged)

// Add multiple
fruits.addAll(['Date', 'Elderberry']);
print(fruits);  // {Apple, Banana, Cherry, Date, Elderberry}
```

---

## Removing from Sets

```dart
Set<String> fruits = {'Apple', 'Banana', 'Cherry'};

// Remove item
fruits.remove('Banana');
print(fruits);  // {Apple, Cherry}

// Remove all
fruits.clear();
print(fruits);  // {}
```

---

## Set Operations

### Union (Combine Sets)

```dart
Set<int> set1 = {1, 2, 3};
Set<int> set2 = {3, 4, 5};

Set<int> union = set1.union(set2);
print(union);  // {1, 2, 3, 4, 5}
```

### Intersection (Common Elements)

```dart
Set<int> set1 = {1, 2, 3, 4};
Set<int> set2 = {3, 4, 5, 6};

Set<int> common = set1.intersection(set2);
print(common);  // {3, 4}
```

### Difference (Elements in First but Not Second)

```dart
Set<int> set1 = {1, 2, 3, 4};
Set<int> set2 = {3, 4, 5, 6};

Set<int> difference = set1.difference(set2);
print(difference);  // {1, 2}
```

---

## Set Properties and Methods

```dart
Set<String> fruits = {'Apple', 'Banana', 'Cherry'};

// Length
print(fruits.length);      // 3

// Is empty?
print(fruits.isEmpty);     // false

// Contains
print(fruits.contains('Apple'));   // true
print(fruits.contains('Orange'));  // false

// First and last (order not guaranteed!)
print(fruits.first);
print(fruits.last);
```

---

## When to Use Each Collection

### List vs Map vs Set

| Collection | When to Use | Example |
|------------|-------------|---------|
| **List** | Ordered items, duplicates allowed, access by index | Shopping list, scores |
| **Map** | Key-value pairs, look up by key | User data, settings, dictionary |
| **Set** | Unique items, no duplicates, fast lookup | Tags, unique IDs, permissions |

### Examples

**Use List:**
```dart
// Order matters, duplicates OK
List<String> shoppingList = ['Milk', 'Bread', 'Milk'];  // Can buy milk twice!
```

**Use Map:**
```dart
// Look up by key
Map<String, String> translations = {
  'hello': 'hola',
  'goodbye': 'adiós',
};
```

**Use Set:**
```dart
// Unique items
Set<String> tags = {'flutter', 'dart', 'mobile', 'flutter'};
// Automatically becomes: {flutter, dart, mobile}
```

---

## Real-World Example: Complete App

```dart
class TodoApp {
  List<String> todos = [];  // Ordered tasks
  Set<String> tags = {};    // Unique tags
  Map<String, bool> status = {};  // Task → completed?

  void addTodo(String task, List<String> taskTags) {
    todos.add(task);
    status[task] = false;
    tags.addAll(taskTags);  // Add to unique tag set
    print('Added: $task');
  }

  void completeTodo(String task) {
    if (status.containsKey(task)) {
      status[task] = true;
      print('Completed: $task');
    }
  }

  void showAll() {
    print('\n=== ALL TODOS ===');
    for (var task in todos) {
      String check = status[task]! ? '✓' : ' ';
      print('[$check] $task');
    }
  }

  void showTags() {
    print('\nTags: ${tags.join(', ')}');
  }
}

void main() {
  TodoApp app = TodoApp();

  app.addTodo('Learn Dart basics', ['learning', 'dart']);
  app.addTodo('Build Flutter app', ['flutter', 'project']);
  app.addTodo('Study algorithms', ['learning', 'algorithms']);

  app.completeTodo('Learn Dart basics');

  app.showAll();
  app.showTags();
}
```

---

## Exercises

### Exercise 1: Word Counter
Count how many times each word appears in a list.

<details>
<summary>Solution</summary>

```dart
Map<String, int> countWords(List<String> words) {
  Map<String, int> counts = {};

  for (var word in words) {
    counts[word] = (counts[word] ?? 0) + 1;
  }

  return counts;
}

void main() {
  List<String> words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple'];
  print(countWords(words));
  // {apple: 3, banana: 2, cherry: 1}
}
```
</details>

---

### Exercise 2: Find Common Elements
Find elements that appear in both lists (using Set).

<details>
<summary>Solution</summary>

```dart
Set<int> findCommon(List<int> list1, List<int> list2) {
  Set<int> set1 = list1.toSet();
  Set<int> set2 = list2.toSet();
  return set1.intersection(set2);
}

void main() {
  List<int> a = [1, 2, 3, 4, 5];
  List<int> b = [4, 5, 6, 7, 8];
  print(findCommon(a, b));  // {4, 5}
}
```
</details>

---

### Exercise 3: Phone Book
Create a phone book with add, find, and update features.

<details>
<summary>Solution</summary>

```dart
class PhoneBook {
  Map<String, String> contacts = {};

  void add(String name, String number) {
    contacts[name] = number;
    print('Added $name: $number');
  }

  String? find(String name) {
    return contacts[name];
  }

  void update(String name, String newNumber) {
    if (contacts.containsKey(name)) {
      contacts[name] = newNumber;
      print('Updated $name to $newNumber');
    } else {
      print('$name not found');
    }
  }

  void showAll() {
    contacts.forEach((name, number) {
      print('$name: $number');
    });
  }
}

void main() {
  PhoneBook book = PhoneBook();
  book.add('Alice', '555-1234');
  book.add('Bob', '555-5678');
  book.update('Alice', '555-9999');
  book.showAll();
}
```
</details>

---

## Key Takeaways

### Maps
1. **Key-value pairs** - look up by key
2. **Unique keys** - each key appears once
3. **Fast lookup** - O(1) access by key
4. **Use for:** dictionaries, settings, lookups

### Sets
1. **Unique values** - no duplicates
2. **Unordered** - no specific position
3. **Fast contains** - quickly check membership
4. **Use for:** tags, unique IDs, removing duplicates

### Choosing Collections
- **List:** When order matters and you need duplicates
- **Map:** When you need key-value lookups
- **Set:** When you need unique values

---

## What's Next?

You've completed Week 4! You now master:
- ✅ Functions
- ✅ Lists
- ✅ Maps
- ✅ Sets

**Next week:**
- **Object-Oriented Programming** - Classes, objects, inheritance
- **Encapsulation** - Getters, setters, private members
- **Your first real projects** with OOP

Congratulations on completing Dart fundamentals! 🎉 You're ready for OOP! 🚀
