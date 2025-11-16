# Dart Basics Cheatsheet

Quick reference for Dart fundamentals.

---

## Variables

```dart
// Explicit type
String name = 'Alice';
int age = 25;
double height = 5.9;
bool isActive = true;

// Type inference
var city = 'NYC';           // String
var count = 10;             // int
var price = 9.99;           // double
var flag = false;           // bool

// Constants
final loginTime = DateTime.now();  // Set at runtime, can't change
const pi = 3.14159;                // Compile-time constant

// Nullable
String? phone;              // Can be null
int? age;                   // Can be null
String email = '';          // Not null, but empty
```

---

## Data Types

```dart
// String
String name = 'John';
String quote = "It's working";
String multi = '''
Multiple
lines
''';
String raw = r'C:\Users\path';  // Raw string

// Numbers
int count = 42;
double price = 19.99;
num flexible = 10;      // Can be int or double

// Boolean
bool isTrue = true;
bool isFalse = false;

// Lists
List<int> numbers = [1, 2, 3];
var names = ['Alice', 'Bob'];
List<String> empty = [];

// Maps
Map<String, int> scores = {'Alice': 95, 'Bob': 87};
var user = {'name': 'John', 'age': 30};

// Sets
Set<int> unique = {1, 2, 3};
```

---

## String Operations

```dart
String text = 'Hello, World!';

// Properties
text.length                 // 13
text.isEmpty                // false
text.isNotEmpty             // true

// Methods
text.toUpperCase()          // HELLO, WORLD!
text.toLowerCase()          // hello, world!
text.trim()                 // Remove whitespace
text.contains('World')      // true
text.startsWith('Hello')    // true
text.endsWith('!')          // true
text.indexOf('W')           // 7
text.substring(0, 5)        // Hello
text.replaceAll('o', 'X')   // HellX, WXrld!
text.split(',')             // ['Hello', ' World!']

// Interpolation
String name = 'Alice';
print('Hello, $name!');                 // Hello, Alice!
print('Next year: ${age + 1}');         // Next year: 26
print('Upper: ${name.toUpperCase()}');  // Upper: ALICE
```

---

## Operators

### Arithmetic
```dart
int a = 10, b = 3;

a + b       // 13 (addition)
a - b       // 7  (subtraction)
a * b       // 30 (multiplication)
a / b       // 3.333... (division)
a ~/ b      // 3  (integer division)
a % b       // 1  (modulo/remainder)

a++         // Increment
a--         // Decrement
```

### Assignment
```dart
int x = 10;

x = 5       // Assign
x += 3      // x = x + 3
x -= 2      // x = x - 2
x *= 2      // x = x * 2
x ~/= 2     // x = x ~/ 2
```

### Comparison
```dart
a == b      // Equal to
a != b      // Not equal to
a > b       // Greater than
a < b       // Less than
a >= b      // Greater than or equal
a <= b      // Less than or equal
```

### Logical
```dart
true && false   // AND (false)
true || false   // OR  (true)
!true           // NOT (false)
```

### Type Test
```dart
x is int        // Check type
x is! String    // Check NOT type
```

---

## Control Flow

### if-else
```dart
if (age >= 18) {
  print('Adult');
} else if (age >= 13) {
  print('Teen');
} else {
  print('Child');
}

// Ternary
String status = age >= 18 ? 'Adult' : 'Minor';
```

### switch
```dart
switch (day) {
  case 'Monday':
    print('Start of week');
    break;
  case 'Friday':
    print('Almost weekend');
    break;
  default:
    print('Regular day');
}
```

### Loops
```dart
// for loop
for (int i = 0; i < 5; i++) {
  print(i);
}

// for-in loop
for (var item in list) {
  print(item);
}

// while loop
while (condition) {
  // code
}

// do-while loop
do {
  // code
} while (condition);

// break and continue
for (int i = 0; i < 10; i++) {
  if (i == 5) break;      // Exit loop
  if (i == 3) continue;   // Skip to next iteration
  print(i);
}
```

---

## Functions

```dart
// Basic function
void greet() {
  print('Hello!');
}

// With parameters
void sayHello(String name) {
  print('Hello, $name!');
}

// With return value
int add(int a, int b) {
  return a + b;
}

// Arrow function (one-liner)
int multiply(int a, int b) => a * b;

// Optional positional parameters
void show(String name, [int? age]) {
  print('$name, age: $age');
}
show('Alice');        // Alice, age: null
show('Bob', 25);      // Bob, age: 25

// Named parameters
void display({required String name, int age = 0}) {
  print('$name, age: $age');
}
display(name: 'Alice');           // Alice, age: 0
display(name: 'Bob', age: 30);    // Bob, age: 30

// Default values
void greet([String name = 'Guest']) {
  print('Hello, $name!');
}
```

---

## Lists

```dart
List<int> numbers = [1, 2, 3, 4, 5];

// Properties
numbers.length          // 5
numbers.first           // 1
numbers.last            // 5
numbers.isEmpty         // false
numbers.isNotEmpty      // true

// Methods
numbers.add(6);                 // [1, 2, 3, 4, 5, 6]
numbers.addAll([7, 8]);         // Add multiple
numbers.insert(0, 0);           // Insert at index
numbers.remove(3);              // Remove value
numbers.removeAt(0);            // Remove at index
numbers.clear();                // Remove all
numbers.contains(3);            // true
numbers.indexOf(3);             // Index of value
numbers.reversed;               // Reverse
numbers.sort();                 // Sort

// Iteration
for (var num in numbers) {
  print(num);
}

numbers.forEach((num) => print(num));

// Transformation
var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n % 2 == 0).toList();
```

---

## Maps

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
  'Charlie': 35
};

// Access
ages['Alice']           // 25
ages['David']           // null (doesn't exist)

// Modify
ages['Alice'] = 26;              // Update
ages['David'] = 28;              // Add
ages.remove('Bob');              // Remove

// Properties
ages.length             // 3
ages.isEmpty            // false
ages.keys               // ['Alice', 'Bob', 'Charlie']
ages.values             // [25, 30, 35]
ages.containsKey('Alice')        // true
ages.containsValue(30)           // true

// Iteration
ages.forEach((key, value) {
  print('$key: $value');
});
```

---

## Classes (Basic)

```dart
class Person {
  // Properties
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Named constructor
  Person.guest() : name = 'Guest', age = 0;

  // Method
  void introduce() {
    print('Hi, I\'m $name, age $age');
  }

  // Getter
  bool get isAdult => age >= 18;

  // Setter
  set updateAge(int newAge) {
    if (newAge > 0) age = newAge;
  }
}

// Usage
Person person = Person('Alice', 25);
person.introduce();         // Hi, I'm Alice, age 25
print(person.isAdult);      // true
person.updateAge = 26;
```

---

## JSON

```dart
import 'dart:convert';

// JSON to Dart
String jsonString = '{"name": "Alice", "age": 25}';
Map<String, dynamic> user = jsonDecode(jsonString);
print(user['name']);  // Alice

// Dart to JSON
Map<String, dynamic> data = {'name': 'Bob', 'age': 30};
String json = jsonEncode(data);
print(json);  // {"name":"Bob","age":30}

// List of objects
String jsonArray = '[{"name": "Alice"}, {"name": "Bob"}]';
List<dynamic> users = jsonDecode(jsonArray);
```

---

## Null Safety

```dart
// Non-nullable (can't be null)
String name = 'Alice';
// name = null;  // ERROR

// Nullable (can be null)
String? phone;
phone = null;           // OK
phone = '555-1234';     // OK

// Null-aware operators
String? userName;
print(userName ?? 'Guest');         // If null, use 'Guest'
userName ??= 'Default';             // Assign if null
print(userName?.toUpperCase());     // Call only if not null

// Assert non-null
String guaranteed = userName!;      // Tell Dart: "I know it's not null"
```

---

## Async/Await (Preview)

```dart
// Async function
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded';
}

// Using await
void main() async {
  print('Loading...');
  String data = await fetchData();
  print(data);  // Prints after 2 seconds
}

// Error handling
try {
  String data = await fetchData();
  print(data);
} catch (e) {
  print('Error: $e');
}
```

---

## Common Patterns

### Even/Odd Check
```dart
bool isEven(int n) => n % 2 == 0;
```

### Find Max
```dart
int max(int a, int b) => a > b ? a : b;
```

### Capitalize First Letter
```dart
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
```

### Sum List
```dart
int sum(List<int> numbers) {
  int total = 0;
  for (var n in numbers) {
    total += n;
  }
  return total;
}
// Or using reduce:
int sum2(List<int> numbers) => numbers.reduce((a, b) => a + b);
```

### Filter List
```dart
List<int> getEvens(List<int> numbers) {
  return numbers.where((n) => n % 2 == 0).toList();
}
```

---

## Print Debugging

```dart
print('Debug: $variable');
print('Object: ${object.toString()}');
print('Type: ${variable.runtimeType}');
```

---

## Quick Reference

| Task | Code |
|------|------|
| Create variable | `var name = 'value';` |
| String interpolation | `'Hello, $name!'` |
| Check equality | `a == b` |
| If statement | `if (condition) { }` |
| For loop | `for (int i = 0; i < 10; i++) { }` |
| Function | `void name() { }` |
| List | `List<int> nums = [1, 2, 3];` |
| Map | `Map<String, int> = {'key': 1};` |
| Parse JSON | `jsonDecode(jsonString)` |
| Await | `await asyncFunction()` |

---

**Print this and keep it handy!**
