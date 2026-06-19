# Dart Fundamentals - Interview Questions

## The Big Idea In One Sentence

> Interviewers test whether you really understand Dart basics (types, null safety, `final` vs `const`, `async`/`await`), so practice saying clear, short answers out loud, not just recognizing them.

Master these Dart concepts for your Flutter interviews!

---

## Variables & Data Types

### Q1: What's the difference between `var`, `final`, and `const`?

**Answer:**
```dart
// var - Can change, type inferred
var name = 'John';
name = 'Jane';  // ✅ OK

// final - Cannot change after initialization (runtime constant)
final age = 25;
age = 26;  // ❌ Error!

// const - Compile-time constant (must know value before running)
const pi = 3.14;
const birthYear = 1990;
```

**Memory tip:**
- `var` = **Variable** (can vary)
- `final` = **Final decision** (set once at runtime)
- `const` = **Constant** (known at compile time)

**Follow-up: When to use each?**
- `var`: When value changes (counter, input fields)
- `final`: When set once (user ID from API, current date)
- `const`: When never changes (app name, colors, math constants)

---

### Q2: What's the difference between `==` and `identical()`?

**Answer:**
```dart
String a = 'hello';
String b = 'hello';
String c = a;

print(a == b);        // true  - same VALUE
print(identical(a, b)); // false - different objects in memory
print(identical(a, c)); // true  - same object (c points to a)
```

**Memory tip:**
- `==` checks if **contents are same** (like comparing two books with same text)
- `identical()` checks if **same object** (like checking if two variables point to the exact same book)

---

### Q3: What is null safety in Dart?

**Answer:**
Null safety means variables can't be null unless you explicitly allow it.

```dart
// Non-nullable (cannot be null)
String name = 'John';
name = null;  // ❌ Error!

// Nullable (can be null)
String? email;  // The ? means "this can be null"
email = null;   // ✅ OK

// Accessing nullable variables
print(email.length);   // ❌ Error! Might be null
print(email?.length);  // ✅ OK - returns null if email is null
print(email!.length);  // ⚠️ Dangerous - crashes if email is null
```

**Memory tip:** `?` = "Maybe null", `!` = "I promise it's not null (crash if wrong)"

---

## Functions

### Q4: What's the difference between positional and named parameters?

**Answer:**
```dart
// Positional parameters - order matters
void greet(String name, int age) {
  print('$name is $age years old');
}
greet('John', 25);  // Must be in order!

// Named parameters - order doesn't matter
void introduce({required String name, required int age}) {
  print('$name is $age years old');
}
introduce(age: 25, name: 'John');  // ✅ Order doesn't matter

// Optional positional
void say(String msg, [String? suffix]) {
  print('$msg${suffix ?? ''}');
}
say('Hello');        // ✅ suffix is optional
say('Hello', '!');   // ✅ can provide suffix

// Optional named with default
void display({String msg = 'Hello'}) {
  print(msg);
}
display();           // Prints: Hello
display(msg: 'Hi');  // Prints: Hi
```

**Memory tip:** Named = use `{}`, must write parameter name when calling

---

### Q5: What is a closure in Dart?

**Answer:**
A closure is a function that "remembers" variables from where it was created.

```dart
Function makeMultiplier(int factor) {
  // This inner function "remembers" factor
  return (int number) => number * factor;
}

var multiplyBy2 = makeMultiplier(2);
var multiplyBy5 = makeMultiplier(5);

print(multiplyBy2(10));  // 20 (remembers factor = 2)
print(multiplyBy5(10));  // 50 (remembers factor = 5)
```

**Memory tip:** Closure = Function that "closes over" variables from outer scope

**Real Flutter use:**
```dart
// In Flutter, this is common:
ElevatedButton(
  onPressed: () {
    print('User ID: $userId');  // Closure remembers userId
  },
  child: Text('Click'),
)
```

---

## Collections

### Q6: What's the difference between List, Set, and Map?

**Answer:**
```dart
// List - Ordered, allows duplicates, accessed by index
List<String> names = ['John', 'Jane', 'John'];
print(names[0]);  // 'John'

// Set - Unordered, NO duplicates, no index access
Set<String> uniqueNames = {'John', 'Jane', 'John'};
print(uniqueNames);  // {John, Jane} - only unique values!

// Map - Key-value pairs
Map<String, int> ages = {
  'John': 25,
  'Jane': 30,
};
print(ages['John']);  // 25
```

**Memory tip:**
- **List** = Shopping list (order matters, can repeat items)
- **Set** = Guest list (no duplicates allowed)
- **Map** = Phone book (name → phone number)

---

### Q7: What's the spread operator `...` ?

**Answer:**
The spread operator "spreads out" elements of a collection.

```dart
List<int> numbers1 = [1, 2, 3];
List<int> numbers2 = [4, 5, 6];

// Without spread (wrong)
List<int> combined1 = [numbers1, numbers2];  // [[1,2,3], [4,5,6]] - list of lists!

// With spread (correct)
List<int> combined2 = [...numbers1, ...numbers2];  // [1, 2, 3, 4, 5, 6]

// Conditional spread
bool showExtra = true;
List<int> items = [
  1,
  2,
  if (showExtra) ...numbers1,  // Only add if condition is true
];
```

**Memory tip:** `...` = "Unpack this collection here"

---

## Async Programming

### Q8: What's the difference between `async`/`await` and `Future.then()`?

**Answer:**
Both handle asynchronous code, but `async`/`await` is cleaner.

```dart
// Using .then() - nested, harder to read
void fetchUserOldWay() {
  fetchUser().then((user) {
    fetchPosts(user.id).then((posts) {
      print('Got ${posts.length} posts');
    });
  });
}

// Using async/await - sequential, easier to read
Future<void> fetchUserNewWay() async {
  final user = await fetchUser();
  final posts = await fetchPosts(user.id);
  print('Got ${posts.length} posts');
}
```

**Memory tip:** `async`/`await` makes async code look like normal code!

---

### Q9: What's the difference between `Future` and `Stream`?

**Answer:**
```dart
// Future - ONE value in the future
Future<int> fetchScore() async {
  await Future.delayed(Duration(seconds: 2));
  return 100;  // Returns ONE value
}

// Stream - MULTIPLE values over time
Stream<int> countdownStream() async* {
  for (int i = 5; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // Yields multiple values: 5, 4, 3, 2, 1, 0
  }
}

// Usage
await fetchScore();  // Wait for ONE result

await for (int count in countdownStream()) {
  print(count);  // Gets each value as it comes: 5...4...3...2...1...0
}
```

**Memory tip:**
- **Future** = Ordering food (one delivery)
- **Stream** = Netflix (continuous data flow)

---

## OOP Concepts

### Q10: What's the difference between `extends`, `implements`, and `with`?

**Answer:**
```dart
// extends - Inheritance (IS-A relationship)
class Animal {
  void breathe() => print('Breathing');
}
class Dog extends Animal {
  void bark() => print('Woof!');
}
// Dog IS AN Animal, gets breathe() for free

// implements - Contract (MUST implement all methods)
abstract class Flyable {
  void fly();
}
class Bird implements Flyable {
  @override
  void fly() => print('Flying');  // MUST implement fly()
}

// with - Mixins (share behavior)
mixin Swimmable {
  void swim() => print('Swimming');
}
class Duck extends Animal with Swimmable {
  // Gets breathe() from Animal AND swim() from Swimmable
}
```

**Memory tip:**
- `extends` = **Inherit everything** from parent
- `implements` = **Promise to provide** these methods
- `with` = **Add abilities** (like adding skills to a character)

---

### Q11: What is `late` keyword?

**Answer:**
`late` means "I'll initialize this later, but before using it."

```dart
class User {
  // Without late - must initialize immediately
  String name = '';  // Empty string as placeholder

  // With late - can initialize later
  late String email;  // No need for placeholder

  void setEmail(String e) {
    email = e;  // Initialize later
  }
}

// Common use: lazy initialization
class Calculator {
  late final int expensiveValue = _compute();  // Only computed when first accessed

  int _compute() {
    print('Computing...');
    return 1000000;
  }
}

var calc = Calculator();  // Doesn't print "Computing..."
print(calc.expensiveValue);  // NOW prints "Computing..." and returns value
```

**Memory tip:** `late` = "Trust me, I'll set this before you need it"

---

### Q12: What's the difference between factory and regular constructors?

**Answer:**
```dart
class Logger {
  static final Logger _instance = Logger._internal();

  // Factory constructor - can return existing instance
  factory Logger() {
    return _instance;  // Returns same instance (Singleton)
  }

  // Private named constructor
  Logger._internal();
}

// Regular constructor - ALWAYS creates new instance
class User {
  String name;
  User(this.name);
}

// Usage
var logger1 = Logger();
var logger2 = Logger();
print(identical(logger1, logger2));  // true - same instance!

var user1 = User('John');
var user2 = User('John');
print(identical(user1, user2));  // false - different instances
```

**Memory tip:**
- Regular constructor = **Always** creates new object
- Factory constructor = **Can decide** what to return (existing object, subclass, etc.)

---

## Quick Fire Round

### Q13: What is `??` operator?

**Answer:** Null-coalescing operator - returns right side if left is null.
```dart
String? name;
print(name ?? 'Guest');  // 'Guest' (because name is null)

name = 'John';
print(name ?? 'Guest');  // 'John' (because name is not null)
```

---

### Q14: What is `?.` operator?

**Answer:** Null-aware operator - only calls method if not null.
```dart
String? email;
print(email?.length);  // null (doesn't crash)

email = 'test@email.com';
print(email?.length);  // 14
```

---

### Q15: What is cascade notation `..` ?

**Answer:** Allows chaining multiple operations on the same object.
```dart
// Without cascade
var button = ElevatedButton();
button.text = 'Click';
button.color = Colors.blue;
button.onPressed = () {};

// With cascade - cleaner!
var button = ElevatedButton()
  ..text = 'Click'
  ..color = Colors.blue
  ..onPressed = () {};
```

---

## Common Tricky Questions

### Q16: What's the output?

```dart
void main() {
  var list = [1, 2, 3];
  var list2 = list;
  list2.add(4);
  print(list);  // What prints?
}
```

**Answer:** `[1, 2, 3, 4]`

**Why?** Both `list` and `list2` point to the SAME object in memory. Changing one changes both.

**To fix (make a copy):**
```dart
var list2 = [...list];  // Creates new list
// or
var list2 = List.from(list);
```

---

### Q17: What's wrong with this code?

```dart
Future<void> fetchData() {
  await fetchUser();  // ❌ Error!
  print('Done');
}
```

**Answer:** Missing `async` keyword!
```dart
Future<void> fetchData() async {  // ✅ Add async
  await fetchUser();
  print('Done');
}
```

**Rule:** If you use `await`, the function MUST be marked `async`.

---

## Summary - Must Remember

| Concept | Key Point |
|---------|-----------|
| `var` vs `final` vs `const` | var changes, final set once, const compile-time |
| Null safety `?` | Variable can be null |
| Null safety `!` | I promise not null (dangerous) |
| Named parameters | Use `{}`, can be in any order |
| Closure | Function that remembers outer variables |
| List vs Set vs Map | Ordered+dups, No dups, Key-value |
| Future vs Stream | One value, Multiple values |
| `extends` vs `implements` vs `with` | Inherit, Contract, Mixin |
| `??` | If null, use this instead |
| `?.` | Safe call (won't crash if null) |
| `..` | Cascade (chain operations) |

---

## Assignment

Answer each out loud in one or two sentences, then check.

### Problem 1: final vs const

What is the difference between `final` and `const`?

### Problem 2: Null safety

What does the `?` in `String?` mean, and what does `??` do?

### Problem 3: async/await

In one sentence, what does `await` do?

---

## Assignment Answers

### Problem 1: final vs const

`final` is set once at runtime; `const` is a compile-time constant (its value must be known when you compile). Every `const` is also final.

### Problem 2: Null safety

`String?` means the value can be a string OR null. `??` provides a fallback when the left side is null (`name ?? 'Guest'`).

### Problem 3: async/await

`await` pauses an async function until a Future completes, then gives you its value, without freezing the app.

---

**Continue to:** `02-FlutterBasics.md`
