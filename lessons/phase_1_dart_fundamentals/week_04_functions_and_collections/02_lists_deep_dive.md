# Week 4, Day 4-5: Lists Deep Dive - Working with Collections

## What is a List?

Imagine you have a shopping list on paper:
```
1. Milk
2. Bread
3. Eggs
4. Cheese
```

In Dart, a **List** is exactly that - an **ordered collection** of items.

**Key characteristics:**
- **Ordered** - Items have a specific position (index)
- **Indexed** - Access items by position (starting at 0)
- **Can contain duplicates** - Same item can appear multiple times
- **Growable** - Can add/remove items (unless specified as fixed-length)

---

## Creating Lists

### Empty List

```dart
List<String> fruits = [];
List<int> numbers = [];

// Or with type inference
var names = <String>[];
var scores = <int>[];
```

### List with Initial Values

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];
List<int> numbers = [1, 2, 3, 4, 5];
List<double> prices = [9.99, 19.99, 29.99];
List<bool> flags = [true, false, true];

// Mixed types (not recommended)
List<dynamic> mixed = ['Text', 123, true, 3.14];
```

### List.filled() - Create with Same Value

```dart
// Create list of 5 zeros
List<int> zeros = List.filled(5, 0);
print(zeros);  // [0, 0, 0, 0, 0]

// Create list of 3 "Hello"s
List<String> hellos = List.filled(3, 'Hello');
print(hellos);  // [Hello, Hello, Hello]
```

### List.generate() - Create with Pattern

```dart
// Generate numbers 0-4
List<int> numbers = List.generate(5, (index) => index);
print(numbers);  // [0, 1, 2, 3, 4]

// Generate squares
List<int> squares = List.generate(5, (index) => index * index);
print(squares);  // [0, 1, 4, 9, 16]

// Generate even numbers
List<int> evens = List.generate(5, (index) => index * 2);
print(evens);  // [0, 2, 4, 6, 8]
```

---

## Accessing Elements

### By Index

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Date'];

print(fruits[0]);  // Apple  (first item)
print(fruits[1]);  // Banana (second item)
print(fruits[2]);  // Cherry (third item)

// Last item
print(fruits[fruits.length - 1]);  // Date
```

**Remember:** Indexing starts at **0**!

```
Index:    0        1         2        3
Value: ['Apple', 'Banana', 'Cherry', 'Date']
```

### Special Properties

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

print(fruits.first);   // Apple  (first element)
print(fruits.last);    // Cherry (last element)
print(fruits.length);  // 3      (number of items)
```

### Safe Access (Avoid Errors)

```dart
List<int> numbers = [10, 20, 30];

// Dangerous - can crash!
// print(numbers[10]);  // RangeError!

// Safe - check first
if (numbers.length > 10) {
  print(numbers[10]);
} else {
  print('Index out of range');
}
```

---

## Modifying Lists

### Add Items

```dart
List<String> fruits = ['Apple', 'Banana'];

// Add single item
fruits.add('Cherry');
print(fruits);  // [Apple, Banana, Cherry]

// Add multiple items
fruits.addAll(['Date', 'Elderberry']);
print(fruits);  // [Apple, Banana, Cherry, Date, Elderberry]
```

### Insert at Specific Position

```dart
List<String> fruits = ['Apple', 'Cherry'];

// Insert at index 1
fruits.insert(1, 'Banana');
print(fruits);  // [Apple, Banana, Cherry]

// Insert multiple at index 2
fruits.insertAll(2, ['Blueberry', 'Blackberry']);
print(fruits);  // [Apple, Banana, Blueberry, Blackberry, Cherry]
```

### Remove Items

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Banana'];

// Remove first occurrence of value
fruits.remove('Banana');
print(fruits);  // [Apple, Cherry, Banana]

// Remove by index
fruits.removeAt(0);
print(fruits);  // [Cherry, Banana]

// Remove last item
fruits.removeLast();
print(fruits);  // [Cherry]

// Remove all items
fruits.clear();
print(fruits);  // []
```

### Update Items

```dart
List<int> numbers = [10, 20, 30, 40];

// Update single item
numbers[1] = 25;
print(numbers);  // [10, 25, 30, 40]

// Update multiple items
numbers[0] = 15;
numbers[2] = 35;
print(numbers);  // [15, 25, 35, 40]
```

---

## List Properties

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

// Length (number of items)
print(fruits.length);       // 3

// Is empty?
print(fruits.isEmpty);      // false
print(fruits.isNotEmpty);   // true

// First and last
print(fruits.first);        // Apple
print(fruits.last);         // Cherry

// Reversed (returns Iterable, not List)
print(fruits.reversed.toList());  // [Cherry, Banana, Apple]
```

---

## Searching in Lists

### contains() - Check if Item Exists

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

print(fruits.contains('Banana'));  // true
print(fruits.contains('Orange'));  // false

// Use in if statement
if (fruits.contains('Apple')) {
  print('We have apples!');
}
```

### indexOf() - Find Position

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Banana'];

print(fruits.indexOf('Banana'));     // 1 (first occurrence)
print(fruits.indexOf('Orange'));     // -1 (not found)
print(fruits.lastIndexOf('Banana')); // 3 (last occurrence)
```

### where() - Filter Items

```dart
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Find all even numbers
var evens = numbers.where((n) => n % 2 == 0);
print(evens.toList());  // [2, 4, 6, 8, 10]

// Find numbers greater than 5
var bigNumbers = numbers.where((n) => n > 5);
print(bigNumbers.toList());  // [6, 7, 8, 9, 10]
```

### any() and every()

```dart
List<int> numbers = [1, 2, 3, 4, 5];

// Check if ANY number is even
bool hasEven = numbers.any((n) => n % 2 == 0);
print(hasEven);  // true

// Check if EVERY number is positive
bool allPositive = numbers.every((n) => n > 0);
print(allPositive);  // true

// Check if EVERY number is even
bool allEven = numbers.every((n) => n % 2 == 0);
print(allEven);  // false
```

---

## Sorting Lists

### sort() - In-Place Sorting

```dart
List<int> numbers = [5, 2, 8, 1, 9];

// Sort ascending (modifies original list)
numbers.sort();
print(numbers);  // [1, 2, 5, 8, 9]

// Sort descending
numbers.sort((a, b) => b.compareTo(a));
print(numbers);  // [9, 8, 5, 2, 1]
```

### Sorting Strings

```dart
List<String> fruits = ['Cherry', 'Apple', 'Banana'];

fruits.sort();
print(fruits);  // [Apple, Banana, Cherry]

// Case-insensitive sort
List<String> mixed = ['apple', 'Banana', 'cherry'];
mixed.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
print(mixed);  // [apple, Banana, cherry]
```

---

## Transforming Lists

### map() - Transform Each Element

```dart
List<int> numbers = [1, 2, 3, 4, 5];

// Double each number
var doubled = numbers.map((n) => n * 2);
print(doubled.toList());  // [2, 4, 6, 8, 10]

// Convert to strings
var strings = numbers.map((n) => 'Number $n');
print(strings.toList());  // [Number 1, Number 2, Number 3, Number 4, Number 5]

// Square each number
var squares = numbers.map((n) => n * n);
print(squares.toList());  // [1, 4, 9, 16, 25]
```

### Real-World Example: Price Calculations

```dart
List<double> prices = [19.99, 29.99, 39.99];

// Apply 10% discount
var discounted = prices.map((p) => p * 0.9);
print(discounted.toList());  // [17.991, 26.991, 35.991]

// Format as strings
var formatted = prices.map((p) => '\$${p.toStringAsFixed(2)}');
print(formatted.toList());  // [$19.99, $29.99, $39.99]
```

---

## Combining Lists

### Join - List to String

```dart
List<String> words = ['Hello', 'beautiful', 'world'];

// Join with spaces
String sentence = words.join(' ');
print(sentence);  // Hello beautiful world

// Join with commas
String csv = words.join(', ');
print(csv);  // Hello, beautiful, world

// Join with no separator
String combined = words.join('');
print(combined);  // Hellobeautifulworld
```

### Concatenation with +

```dart
List<int> list1 = [1, 2, 3];
List<int> list2 = [4, 5, 6];

List<int> combined = list1 + list2;
print(combined);  // [1, 2, 3, 4, 5, 6]
```

### Spread Operator (...)

```dart
List<int> list1 = [1, 2, 3];
List<int> list2 = [4, 5, 6];

List<int> combined = [...list1, ...list2];
print(combined);  // [1, 2, 3, 4, 5, 6]

// Can add more items
List<int> extended = [...list1, 99, ...list2, 100];
print(extended);  // [1, 2, 3, 99, 4, 5, 6, 100]
```

---

## Iterating Through Lists

### for Loop

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

for (int i = 0; i < fruits.length; i++) {
  print('$i: ${fruits[i]}');
}
// Output:
// 0: Apple
// 1: Banana
// 2: Cherry
```

### for-in Loop

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

for (var fruit in fruits) {
  print(fruit);
}
// Output:
// Apple
// Banana
// Cherry
```

### forEach()

```dart
List<String> fruits = ['Apple', 'Banana', 'Cherry'];

fruits.forEach((fruit) {
  print(fruit);
});

// With index
fruits.asMap().forEach((index, fruit) {
  print('$index: $fruit');
});
```

---

## Advanced List Operations

### reduce() - Combine to Single Value

```dart
List<int> numbers = [1, 2, 3, 4, 5];

// Sum all numbers
int sum = numbers.reduce((value, element) => value + element);
print(sum);  // 15

// Find maximum
int max = numbers.reduce((curr, next) => curr > next ? curr : next);
print(max);  // 5
```

### fold() - Like reduce() but with Initial Value

```dart
List<int> numbers = [1, 2, 3, 4, 5];

// Sum with initial value
int sum = numbers.fold(0, (prev, element) => prev + element);
print(sum);  // 15

// Sum with initial 10
int sumPlus10 = numbers.fold(10, (prev, element) => prev + element);
print(sumPlus10);  // 25
```

### take() and skip()

```dart
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Take first 3
print(numbers.take(3).toList());  // [1, 2, 3]

// Skip first 5
print(numbers.skip(5).toList());  // [6, 7, 8, 9, 10]

// Skip first 3, take next 4
print(numbers.skip(3).take(4).toList());  // [4, 5, 6, 7]
```

### sublist() - Get Portion

```dart
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// From index 2 to 5 (not including 5)
print(numbers.sublist(2, 5));  // [3, 4, 5]

// From index 5 to end
print(numbers.sublist(5));  // [6, 7, 8, 9, 10]
```

---

## Real-World Examples

### Example 1: Shopping Cart

```dart
class CartItem {
  String name;
  double price;
  int quantity;

  CartItem(this.name, this.price, this.quantity);

  double get total => price * quantity;
}

void main() {
  List<CartItem> cart = [
    CartItem('Laptop', 999.99, 1),
    CartItem('Mouse', 29.99, 2),
    CartItem('Keyboard', 79.99, 1),
  ];

  // Calculate total
  double total = cart.fold(0.0, (sum, item) => sum + item.total);
  print('Cart Total: \$${total.toStringAsFixed(2)}');

  // List all items
  print('\nCart Items:');
  cart.forEach((item) {
    print('${item.name} x${item.quantity} = \$${item.total.toStringAsFixed(2)}');
  });

  // Find expensive items (over $50)
  var expensive = cart.where((item) => item.total > 50);
  print('\nExpensive items:');
  expensive.forEach((item) => print(item.name));
}
```

### Example 2: Grade Calculator

```dart
void main() {
  List<int> scores = [85, 92, 78, 95, 88, 73, 90];

  // Calculate average
  double average = scores.reduce((a, b) => a + b) / scores.length;
  print('Average: ${average.toStringAsFixed(2)}');

  // Find highest and lowest
  int highest = scores.reduce((curr, next) => curr > next ? curr : next);
  int lowest = scores.reduce((curr, next) => curr < next ? curr : next);
  print('Highest: $highest');
  print('Lowest: $lowest');

  // Count A grades (90+)
  int aGrades = scores.where((s) => s >= 90).length;
  print('A grades: $aGrades');

  // Failing grades (below 70)
  var failing = scores.where((s) => s < 70);
  print('Failing scores: ${failing.toList()}');
}
```

### Example 3: To-Do List Manager

```dart
class Todo {
  String task;
  bool completed;

  Todo(this.task, {this.completed = false});

  void toggle() {
    completed = !completed;
  }
}

void main() {
  List<Todo> todos = [
    Todo('Buy groceries'),
    Todo('Clean house'),
    Todo('Study Dart', completed: true),
    Todo('Exercise'),
  ];

  // Show all todos
  print('All Todos:');
  todos.asMap().forEach((index, todo) {
    String status = todo.completed ? '✓' : ' ';
    print('${index + 1}. [$status] ${todo.task}');
  });

  // Show only incomplete
  print('\nIncomplete:');
  var incomplete = todos.where((t) => !t.completed);
  incomplete.forEach((t) => print('- ${t.task}'));

  // Complete a task
  todos[0].toggle();
  print('\nCompleted: ${todos[0].task}');
}
```

---

## Common Patterns

### Pattern 1: Find Item

```dart
// Find first item matching condition
int? findFirst(List<int> list, bool Function(int) test) {
  for (var item in list) {
    if (test(item)) return item;
  }
  return null;
}

void main() {
  List<int> numbers = [1, 2, 3, 4, 5];
  var firstEven = findFirst(numbers, (n) => n % 2 == 0);
  print(firstEven);  // 2
}
```

### Pattern 2: Remove Duplicates

```dart
List<T> removeDuplicates<T>(List<T> list) {
  return list.toSet().toList();
}

void main() {
  List<int> numbers = [1, 2, 2, 3, 3, 3, 4];
  print(removeDuplicates(numbers));  // [1, 2, 3, 4]
}
```

### Pattern 3: Chunk List

```dart
List<List<T>> chunk<T>(List<T> list, int size) {
  List<List<T>> chunks = [];
  for (int i = 0; i < list.length; i += size) {
    int end = (i + size < list.length) ? i + size : list.length;
    chunks.add(list.sublist(i, end));
  }
  return chunks;
}

void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  print(chunk(numbers, 3));  // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
}
```

---

## Exercises

### Exercise 1: Sum of List
Write a function that returns the sum of all numbers in a list.

<details>
<summary>Solution</summary>

```dart
int sumList(List<int> numbers) {
  return numbers.fold(0, (sum, n) => sum + n);
  // Or: return numbers.reduce((a, b) => a + b);
}

void main() {
  print(sumList([1, 2, 3, 4, 5]));  // 15
}
```
</details>

---

### Exercise 2: Reverse List
Write a function that reverses a list without using .reversed

<details>
<summary>Solution</summary>

```dart
List<T> reverseList<T>(List<T> list) {
  List<T> reversed = [];
  for (int i = list.length - 1; i >= 0; i--) {
    reversed.add(list[i]);
  }
  return reversed;
}

void main() {
  print(reverseList([1, 2, 3, 4, 5]));  // [5, 4, 3, 2, 1]
}
```
</details>

---

### Exercise 3: Count Occurrences
Count how many times a value appears in a list.

<details>
<summary>Solution</summary>

```dart
int countOccurrences<T>(List<T> list, T value) {
  return list.where((item) => item == value).length;
}

void main() {
  print(countOccurrences([1, 2, 3, 2, 4, 2], 2));  // 3
}
```
</details>

---

## Key Takeaways

1. **Lists are ordered collections** indexed from 0
2. **Dynamic size** - can grow and shrink
3. **Rich methods** - add, remove, sort, filter, map
4. **Powerful transformations** - map(), where(), reduce()
5. **Easy iteration** - for, for-in, forEach
6. **Type-safe** - `List<int>`, `List<String>`, etc.

---

## What's Next?

Tomorrow:
- **Maps** - Key-value pairs
- **Sets** - Unique collections
- **When to use each** collection type

You've mastered Lists! This is fundamental for building real apps. 📋✨
