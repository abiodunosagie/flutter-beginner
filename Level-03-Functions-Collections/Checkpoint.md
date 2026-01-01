# Level 03 Checkpoint: Functions & Collections

Before moving to Level 04, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Function Basics
What's wrong with each function?

```dart
// Function A
calculateTotal(price, quantity) {
  return price * quantity;
}

// Function B
double calculateTax(double amount) {
  var tax = amount * 0.1;
}

// Function C
void printPrice(double price) {
  return 'Price: $price';
}
```

<details>
<summary>Check Answers</summary>

- **A**: Missing return type and parameter types
- **B**: Missing `return tax;` statement
- **C**: `void` functions can't return values

</details>

---

### 2. Named & Optional Parameters
Predict the output:

```dart
void greet({String name = 'Guest', int? age}) {
  print('Hello, $name!');
  if (age != null) print('Age: $age');
}

greet();
greet(name: 'Alice');
greet(name: 'Bob', age: 25);
```

<details>
<summary>Check Answer</summary>

```
Hello, Guest!
Hello, Alice!
Hello, Bob!
Age: 25
```

</details>

---

### 3. Arrow Functions
Convert to arrow syntax:

```dart
// Convert these:
int double(int x) {
  return x * 2;
}

bool isExpensive(double price) {
  return price > 100;
}
```

<details>
<summary>Check Answers</summary>

```dart
int double(int x) => x * 2;

bool isExpensive(double price) => price > 100;
```

</details>

---

### 4. List Operations
What's the output?

```dart
var numbers = [1, 2, 3, 4, 5];

print(numbers.length);
print(numbers.first);
print(numbers.last);
print(numbers[2]);
print(numbers.contains(3));
```

<details>
<summary>Check Answers</summary>

```
5
1
5
3
true
```

</details>

---

### 5. Map Operations
What's the output?

```dart
var user = {
  'name': 'Alice',
  'age': 25,
  'email': 'alice@example.com',
};

print(user['name']);
print(user['phone']);
print(user.containsKey('age'));
print(user.keys.length);
```

<details>
<summary>Check Answers</summary>

```
Alice
null
true
3
```

</details>

---

### 6. Higher-Order Functions
What does this code produce?

```dart
var prices = [10.0, 25.0, 15.0, 50.0, 30.0];

var expensive = prices.where((p) => p > 20).toList();
var doubled = prices.map((p) => p * 2).toList();
var total = prices.reduce((a, b) => a + b);

print(expensive);
print(doubled);
print(total);
```

<details>
<summary>Check Answers</summary>

```
[25.0, 50.0, 30.0]
[20.0, 50.0, 30.0, 100.0, 60.0]
130.0
```

</details>

---

## Hands-On Check

### Task 1: Create a Utility Function
Write a function that calculates the discounted price:

```dart
// Parameters: original price, discount percentage
// Returns: discounted price
// Example: applyDiscount(100, 20) → 80.0
```

<details>
<summary>Example Solution</summary>

```dart
double applyDiscount(double price, double discountPercent) {
  return price * (1 - discountPercent / 100);
}

// Or with arrow syntax:
double applyDiscount(double price, double discountPercent) =>
    price * (1 - discountPercent / 100);
```

</details>

---

### Task 2: Filter a List
Given a list of products (as maps), filter to only in-stock items:

```dart
var products = [
  {'name': 'Shirt', 'inStock': true},
  {'name': 'Pants', 'inStock': false},
  {'name': 'Hat', 'inStock': true},
];

// Get only in-stock products
```

<details>
<summary>Example Solution</summary>

```dart
var inStock = products
    .where((p) => p['inStock'] == true)
    .toList();

print(inStock);
// [{name: Shirt, inStock: true}, {name: Hat, inStock: true}]
```

</details>

---

### Task 3: Transform Data
Convert a list of prices to formatted strings:

```dart
var prices = [29.99, 49.50, 99.00];
// Convert to: ['$29.99', '$49.50', '$99.00']
```

<details>
<summary>Example Solution</summary>

```dart
var prices = [29.99, 49.50, 99.00];

var formatted = prices
    .map((p) => '\$${p.toStringAsFixed(2)}')
    .toList();

print(formatted);
// [$29.99, $49.50, $99.00]
```

</details>

---

### Task 4: Calculate Totals
Calculate the total of all prices in a cart:

```dart
var cart = [
  {'name': 'Shirt', 'price': 29.99, 'quantity': 2},
  {'name': 'Pants', 'price': 49.99, 'quantity': 1},
];

// Calculate total (price * quantity for each, then sum)
```

<details>
<summary>Example Solution</summary>

```dart
var cart = [
  {'name': 'Shirt', 'price': 29.99, 'quantity': 2},
  {'name': 'Pants', 'price': 49.99, 'quantity': 1},
];

var total = cart
    .map((item) => (item['price'] as double) * (item['quantity'] as int))
    .reduce((a, b) => a + b);

print(total);  // 109.97
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Parameter vs Argument | _________________ |
| Return type | _________________ |
| Arrow function | _________________ |
| Higher-order function | _________________ |
| Callback | _________________ |
| map/filter/reduce | _________________ |

---

## Ready for Level 04?

### I can confidently:
- [ ] Write functions with typed parameters and return types
- [ ] Use named and optional parameters
- [ ] Write arrow functions for simple expressions
- [ ] Create and manipulate Lists
- [ ] Create and manipulate Maps
- [ ] Use `map()` to transform data
- [ ] Use `where()` to filter data
- [ ] Use `reduce()` to aggregate data

### Capstone Progress:
- [ ] I created a Cart class with a list of CartItems
- [ ] Cart has methods: addItem, removeItem, clear
- [ ] Cart can calculate total price
- [ ] I understand how to use List methods for cart operations

---

## If You're Stuck

**Common issues at this level:**

1. **Forgetting return statements**
   - Non-void functions must return something!

2. **Type confusion with maps**
   - Map values are often `dynamic` - cast them: `item['price'] as double`

3. **Where vs Map confusion**
   - `where` = filter (returns some items)
   - `map` = transform (returns all items, but changed)

4. **Understanding reduce**
   - Think of it as: "combine all items into one value"
   - The accumulator holds the running result

---

**Ready to level up? Head to Level 04: OOP Fundamentals!**
