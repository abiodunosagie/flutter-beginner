# Lists: Ordered Collections

## What Is a List?

A **List** is an ordered collection of items. Think of it like a shopping list or a playlist.

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];
```

Key characteristics:
- **Ordered**: Items stay in the order you put them
- **Indexed**: Each item has a position (starting from 0)
- **Duplicates allowed**: Can have the same item multiple times

---

## Creating Lists

### Empty List

```dart
// Type-inferred empty list
var numbers = <int>[];

// Explicit type
List<String> names = [];

// Using constructor
var items = List<int>.empty(growable: true);
```

### List with Initial Values

```dart
var fruits = ['apple', 'banana', 'cherry'];
List<int> numbers = [1, 2, 3, 4, 5];
var mixed = [1, 'hello', true];  // List<Object>
```

### Generated List

```dart
// List of 5 zeros
var zeros = List.filled(5, 0);
print(zeros);  // [0, 0, 0, 0, 0]

// List of numbers 0-4
var generated = List.generate(5, (index) => index);
print(generated);  // [0, 1, 2, 3, 4]

// List of squares
var squares = List.generate(5, (i) => i * i);
print(squares);  // [0, 1, 4, 9, 16]
```

---

## Accessing Elements

### By Index

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits[0]);  // apple (first)
print(fruits[1]);  // banana (second)
print(fruits[2]);  // cherry (third)

// Negative index? ❌ Error!
// print(fruits[-1]);
```

### Visual: Index Positions

```
Index:    0        1         2
        ┌────┐  ┌──────┐  ┌──────┐
List:   │apple│  │banana│  │cherry│
        └────┘  └──────┘  └──────┘
```

### First and Last

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.first);  // apple
print(fruits.last);   // cherry
```

### Safe Access

```dart
var fruits = ['apple', 'banana'];

// ❌ Throws error if empty or out of bounds
// print(fruits[5]);

// ✅ Safe with null check
String? getFruit(List<String> list, int index) {
  if (index >= 0 && index < list.length) {
    return list[index];
  }
  return null;
}

// ✅ Using elementAtOrNull (Dart 3.0+)
print(fruits.elementAtOrNull(5));  // null
```

---

## Modifying Lists

### Adding Items

```dart
var fruits = ['apple', 'banana'];

// Add one item to end
fruits.add('cherry');
print(fruits);  // [apple, banana, cherry]

// Add multiple items
fruits.addAll(['date', 'elderberry']);
print(fruits);  // [apple, banana, cherry, date, elderberry]

// Insert at position
fruits.insert(1, 'blueberry');
print(fruits);  // [apple, blueberry, banana, cherry, date, elderberry]
```

### Removing Items

```dart
var fruits = ['apple', 'banana', 'cherry', 'banana'];

// Remove by value (first occurrence)
fruits.remove('banana');
print(fruits);  // [apple, cherry, banana]

// Remove by index
fruits.removeAt(0);
print(fruits);  // [cherry, banana]

// Remove last item
fruits.removeLast();
print(fruits);  // [cherry]

// Remove by condition
var numbers = [1, 2, 3, 4, 5, 6];
numbers.removeWhere((n) => n % 2 == 0);  // Remove evens
print(numbers);  // [1, 3, 5]

// Clear all
numbers.clear();
print(numbers);  // []
```

### Updating Items

```dart
var fruits = ['apple', 'banana', 'cherry'];

// Update by index
fruits[1] = 'blueberry';
print(fruits);  // [apple, blueberry, cherry]

// Replace range
fruits.replaceRange(0, 2, ['avocado', 'blackberry', 'coconut']);
print(fruits);  // [avocado, blackberry, coconut, cherry]
```

---

## List Properties

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.length);    // 3
print(fruits.isEmpty);   // false
print(fruits.isNotEmpty); // true
print(fruits.first);     // apple
print(fruits.last);      // cherry
print(fruits.reversed);  // (cherry, banana, apple)
```

---

## Searching in Lists

### Check if Contains

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.contains('banana'));  // true
print(fruits.contains('grape'));   // false
```

### Find Index

```dart
var fruits = ['apple', 'banana', 'cherry', 'banana'];

print(fruits.indexOf('banana'));      // 1 (first occurrence)
print(fruits.lastIndexOf('banana'));  // 3 (last occurrence)
print(fruits.indexOf('grape'));       // -1 (not found)
```

### Find Element

```dart
var numbers = [1, 2, 3, 4, 5, 6];

// First matching
var firstEven = numbers.firstWhere((n) => n % 2 == 0);
print(firstEven);  // 2

// With default if not found
var bigNumber = numbers.firstWhere(
  (n) => n > 100,
  orElse: () => -1,
);
print(bigNumber);  // -1

// Last matching
var lastEven = numbers.lastWhere((n) => n % 2 == 0);
print(lastEven);  // 6
```

---

## Iterating Through Lists

### For Loop

```dart
var fruits = ['apple', 'banana', 'cherry'];

// Traditional for
for (int i = 0; i < fruits.length; i++) {
  print('$i: ${fruits[i]}');
}

// For-in loop
for (var fruit in fruits) {
  print(fruit);
}
```

### forEach Method

```dart
var fruits = ['apple', 'banana', 'cherry'];

fruits.forEach((fruit) {
  print(fruit);
});

// Arrow syntax
fruits.forEach((fruit) => print(fruit));
```

### With Index using asMap()

```dart
var fruits = ['apple', 'banana', 'cherry'];

fruits.asMap().forEach((index, fruit) {
  print('$index: $fruit');
});
// 0: apple
// 1: banana
// 2: cherry
```

---

## Transforming Lists

### map() - Transform Each Item

```dart
var numbers = [1, 2, 3, 4, 5];

// Double each number
var doubled = numbers.map((n) => n * 2);
print(doubled.toList());  // [2, 4, 6, 8, 10]

// Convert to strings
var strings = numbers.map((n) => 'Number: $n');
print(strings.toList());
// [Number: 1, Number: 2, Number: 3, Number: 4, Number: 5]
```

### where() - Filter Items

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Get even numbers
var evens = numbers.where((n) => n % 2 == 0);
print(evens.toList());  // [2, 4, 6, 8, 10]

// Get numbers greater than 5
var big = numbers.where((n) => n > 5);
print(big.toList());  // [6, 7, 8, 9, 10]
```

### reduce() - Combine to Single Value

```dart
var numbers = [1, 2, 3, 4, 5];

// Sum all numbers
var sum = numbers.reduce((a, b) => a + b);
print(sum);  // 15

// Product of all numbers
var product = numbers.reduce((a, b) => a * b);
print(product);  // 120

// Find maximum
var max = numbers.reduce((a, b) => a > b ? a : b);
print(max);  // 5
```

### fold() - Reduce with Initial Value

```dart
var numbers = [1, 2, 3, 4, 5];

// Sum starting from 10
var sum = numbers.fold(10, (prev, curr) => prev + curr);
print(sum);  // 25 (10 + 1 + 2 + 3 + 4 + 5)

// Concatenate to string
var str = numbers.fold('Numbers:', (prev, curr) => '$prev $curr');
print(str);  // Numbers: 1 2 3 4 5
```

---

## Sorting Lists

### sort() - In Place

```dart
var numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// Sort ascending (modifies original list)
numbers.sort();
print(numbers);  // [1, 1, 2, 3, 4, 5, 6, 9]

// Sort descending
numbers.sort((a, b) => b.compareTo(a));
print(numbers);  // [9, 6, 5, 4, 3, 2, 1, 1]
```

### Custom Sort

```dart
var words = ['banana', 'apple', 'cherry', 'date'];

// Sort by length
words.sort((a, b) => a.length.compareTo(b.length));
print(words);  // [date, apple, banana, cherry]

// Sort objects
var people = [
  {'name': 'Alice', 'age': 30},
  {'name': 'Bob', 'age': 25},
  {'name': 'Charlie', 'age': 35},
];

people.sort((a, b) => (a['age'] as int).compareTo(b['age'] as int));
// Sorted by age: Bob, Alice, Charlie
```

---

## List Operations

### Combining Lists

```dart
var list1 = [1, 2, 3];
var list2 = [4, 5, 6];

// Using addAll
var combined1 = [...list1];
combined1.addAll(list2);

// Using spread operator (preferred)
var combined2 = [...list1, ...list2];
print(combined2);  // [1, 2, 3, 4, 5, 6]
```

### Sublist (Slicing)

```dart
var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

// Get items 2-5 (exclusive end)
var slice = numbers.sublist(2, 5);
print(slice);  // [2, 3, 4]

// Get from index 5 to end
var rest = numbers.sublist(5);
print(rest);  // [5, 6, 7, 8, 9]
```

### Take and Skip

```dart
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Take first 3
print(numbers.take(3).toList());  // [1, 2, 3]

// Skip first 3
print(numbers.skip(3).toList());  // [4, 5, 6, 7, 8, 9, 10]

// Take while condition is true
print(numbers.takeWhile((n) => n < 5).toList());  // [1, 2, 3, 4]

// Skip while condition is true
print(numbers.skipWhile((n) => n < 5).toList());  // [5, 6, 7, 8, 9, 10]
```

---

## Common Patterns

### Check All/Any

```dart
var numbers = [2, 4, 6, 8, 10];

// Are ALL even?
bool allEven = numbers.every((n) => n % 2 == 0);
print(allEven);  // true

// Is ANY greater than 5?
bool anyBig = numbers.any((n) => n > 5);
print(anyBig);  // true
```

### Join to String

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.join());       // applebananacherry
print(fruits.join(', '));   // apple, banana, cherry
print(fruits.join(' | '));  // apple | banana | cherry
```

### Convert Other Types to List

```dart
// String to list of characters
var chars = 'hello'.split('');
print(chars);  // [h, e, l, l, o]

// Set to list
var set = {1, 2, 3};
var list = set.toList();

// Map keys/values to list
var map = {'a': 1, 'b': 2};
var keys = map.keys.toList();
var values = map.values.toList();
```

---

## Practical Examples

### Example 1: Shopping Cart

```dart
void main() {
  List<Map<String, dynamic>> cart = [];

  // Add items
  cart.add({'name': 'Apple', 'price': 1.50, 'quantity': 3});
  cart.add({'name': 'Bread', 'price': 2.00, 'quantity': 1});
  cart.add({'name': 'Milk', 'price': 3.50, 'quantity': 2});

  // Calculate total
  double total = cart.fold(0.0, (sum, item) {
    return sum + (item['price'] * item['quantity']);
  });

  print('Cart Total: \$${total.toStringAsFixed(2)}');
  // Cart Total: $13.50
}
```

### Example 2: Student Grades

```dart
void main() {
  var grades = [85, 92, 78, 96, 88, 73, 91];

  // Statistics
  var sum = grades.reduce((a, b) => a + b);
  var average = sum / grades.length;
  var highest = grades.reduce((a, b) => a > b ? a : b);
  var lowest = grades.reduce((a, b) => a < b ? a : b);
  var passing = grades.where((g) => g >= 70).length;

  print('Average: ${average.toStringAsFixed(1)}');
  print('Highest: $highest');
  print('Lowest: $lowest');
  print('Passing: $passing/${grades.length}');
}
```

---

## Summary

| Operation | Method | Example |
|-----------|--------|---------|
| Add | `add()`, `addAll()` | `list.add(item)` |
| Remove | `remove()`, `removeAt()` | `list.remove(item)` |
| Access | `[]`, `first`, `last` | `list[0]` |
| Search | `contains()`, `indexOf()` | `list.contains(x)` |
| Transform | `map()`, `where()` | `list.map((x) => x*2)` |
| Aggregate | `reduce()`, `fold()` | `list.reduce((a,b) => a+b)` |
| Sort | `sort()` | `list.sort()` |

---

## Quick Quiz

**Q1:** What's the index of 'cherry' in `['apple', 'banana', 'cherry']`?

<details>
<summary>Answer</summary>

`2` - Lists are zero-indexed.

</details>

**Q2:** What does this return?

```dart
[1, 2, 3, 4, 5].where((n) => n > 3).toList();
```

<details>
<summary>Answer</summary>

`[4, 5]` - Only elements greater than 3.

</details>

**Q3:** How do you get the last element safely?

<details>
<summary>Answer</summary>

```dart
list.isNotEmpty ? list.last : null;
// or
list.lastOrNull;  // Dart 3.0+
```

</details>

---

**Next:** Learn about Maps for key-value storage.

---

**Continue to:** `05-Maps.md`
