# Level 03: Common Mistakes

Learn from these common function and collection errors!

---

## Mistake #1: Forgetting to Return a Value

```dart
// ❌ WRONG - No return statement
double calculateTotal(double price, int quantity) {
  var total = price * quantity;
  // Forgot to return!
}

// ✅ RIGHT
double calculateTotal(double price, int quantity) {
  var total = price * quantity;
  return total;
}

// ✅ BETTER - Arrow function
double calculateTotal(double price, int quantity) => price * quantity;
```

---

## Mistake #2: Wrong Parameter Order

```dart
// ❌ WRONG - Arguments in wrong order
void createUser(String name, int age, String email) { ... }

createUser(25, 'John', 'john@email.com');  // Error!

// ✅ RIGHT - Match parameter order
createUser('John', 25, 'john@email.com');

// ✅ BETTER - Use named parameters
void createUser({required String name, required int age, required String email}) { ... }
createUser(name: 'John', email: 'john@email.com', age: 25);  // Order doesn't matter!
```

---

## Mistake #3: Returning in Void Function

```dart
// ❌ WRONG
void printMessage(String msg) {
  return 'Hello, $msg';  // Error: void function can't return value
}

// ✅ RIGHT - Change return type
String getMessage(String msg) {
  return 'Hello, $msg';
}

// Or don't return anything
void printMessage(String msg) {
  print('Hello, $msg');
}
```

---

## Mistake #4: List Index Out of Bounds

```dart
// ❌ WRONG
var items = ['a', 'b', 'c'];  // indices 0, 1, 2
print(items[3]);  // Error: Index out of range!

// ✅ RIGHT
print(items[2]);  // 'c' - last index is length - 1

// Or check first
if (items.length > 3) {
  print(items[3]);
}
```

---

## Mistake #5: Modifying Unmodifiable List

```dart
// ❌ WRONG
const items = ['a', 'b', 'c'];
items.add('d');  // Error: Can't modify const list

// ✅ RIGHT - Use var or final
var items = ['a', 'b', 'c'];
items.add('d');  // Works!
```

---

## Mistake #6: Wrong Map Access

```dart
// ❌ WRONG - Key doesn't exist
var user = {'name': 'John'};
print(user['age'].toString());  // Error: null has no toString

// ✅ RIGHT - Check for null
var user = {'name': 'John'};
print(user['age']?.toString() ?? 'Unknown');
```

---

## Mistake #7: Forgetting toList() After Map/Where

```dart
// ❌ WRONG - Returns Iterable, not List
List<int> doubled = numbers.map((n) => n * 2);  // Error!

// ✅ RIGHT
List<int> doubled = numbers.map((n) => n * 2).toList();
```

---

## Mistake #8: Arrow Function with Multiple Statements

```dart
// ❌ WRONG - Arrow syntax only for single expression
int calculate(int a, int b) => {
  var sum = a + b;
  return sum * 2;
};

// ✅ RIGHT - Use regular function body
int calculate(int a, int b) {
  var sum = a + b;
  return sum * 2;
}

// Arrow is only for: expression that returns the result
int calculate(int a, int b) => (a + b) * 2;
```

---

## Mistake #9: Reduce on Empty List

```dart
// ❌ WRONG - Empty list has no initial value
var numbers = <int>[];
var sum = numbers.reduce((a, b) => a + b);  // Error!

// ✅ RIGHT - Use fold with initial value
var sum = numbers.fold(0, (a, b) => a + b);

// Or check first
var sum = numbers.isEmpty ? 0 : numbers.reduce((a, b) => a + b);
```

---

## Mistake #10: Confusing map() with forEach()

```dart
// ❌ WRONG - map() doesn't execute without toList()
prices.map((p) => print(p));  // Nothing prints!

// ✅ RIGHT - Use forEach for side effects
prices.forEach((p) => print(p));

// Use map() for transformations
var doubled = prices.map((p) => p * 2).toList();
```

**Remember:**
- `map()` = transform each item, returns new list
- `forEach()` = do something with each item, returns nothing

---

## Quick Reference: Collection Methods

| Method | Purpose | Returns |
|--------|---------|---------|
| `add(item)` | Add to end | void |
| `insert(i, item)` | Add at index | void |
| `remove(item)` | Remove by value | bool |
| `removeAt(i)` | Remove by index | item |
| `map((e) => ...)` | Transform each | Iterable |
| `where((e) => ...)` | Filter | Iterable |
| `reduce((a, b) => ...)` | Combine all | single value |
| `fold(init, (a, b) => ...)` | Combine with initial | single value |
| `any((e) => ...)` | Check if any match | bool |
| `every((e) => ...)` | Check if all match | bool |

---

**Still stuck? Re-read the Theory files or ask for help!**
