# Constructors: Creating Objects

## What Is a Constructor?

A **constructor** is a special method that creates and initializes an object.

```dart
class Dog {
  String name;
  int age;

  // Constructor
  Dog(this.name, this.age);
}

void main() {
  var buddy = Dog('Buddy', 3);  // Constructor is called here
}
```

Think of it like:
- The class is a **recipe**
- The constructor is the **cooking process**
- The object is the **finished dish**

---

## Default Constructor

If you don't define a constructor, Dart provides a default one:

```dart
class Point {
  double x = 0;
  double y = 0;
}

void main() {
  var p = Point();  // Uses default constructor
  print('(${p.x}, ${p.y})');  // (0.0, 0.0)
}
```

---

## Basic Constructor

The most common type:

```dart
class Person {
  String name;
  int age;

  // Basic constructor
  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }
}
```

### Shorthand Syntax (Preferred)

Dart has a cleaner shorthand:

```dart
class Person {
  String name;
  int age;

  // Shorthand - automatically assigns this.name and this.age
  Person(this.name, this.age);
}

void main() {
  var alice = Person('Alice', 25);
}
```

---

## Named Constructors

Create multiple constructors with different names:

```dart
class Point {
  double x;
  double y;

  // Default constructor
  Point(this.x, this.y);

  // Named constructor: at origin
  Point.origin() : x = 0, y = 0;

  // Named constructor: from another point
  Point.fromPoint(Point other) : x = other.x, y = other.y;

  // Named constructor: on x-axis
  Point.onXAxis(double x) : x = x, y = 0;

  // Named constructor: on y-axis
  Point.onYAxis(double y) : x = 0, y = y;

  @override
  String toString() => '($x, $y)';
}

void main() {
  var p1 = Point(3, 4);
  var p2 = Point.origin();
  var p3 = Point.onXAxis(5);
  var p4 = Point.onYAxis(7);
  var p5 = Point.fromPoint(p1);

  print(p1);  // (3.0, 4.0)
  print(p2);  // (0.0, 0.0)
  print(p3);  // (5.0, 0.0)
  print(p4);  // (0.0, 7.0)
  print(p5);  // (3.0, 4.0)
}
```

---

## Named Parameters in Constructors

Make constructors more readable:

```dart
class User {
  String name;
  String email;
  int? age;
  bool isActive;

  User({
    required this.name,
    required this.email,
    this.age,
    this.isActive = true,
  });
}

void main() {
  var user1 = User(
    name: 'Alice',
    email: 'alice@email.com',
  );

  var user2 = User(
    name: 'Bob',
    email: 'bob@email.com',
    age: 30,
    isActive: false,
  );

  print('${user1.name}: active=${user1.isActive}');  // Alice: active=true
  print('${user2.name}: active=${user2.isActive}');  // Bob: active=false
}
```

---

## Initializer Lists

Run code BEFORE the constructor body:

```dart
class Rectangle {
  double width;
  double height;
  double area;
  double perimeter;

  // Initializer list: executes BEFORE constructor body
  Rectangle(this.width, this.height)
      : area = width * height,
        perimeter = 2 * (width + height);
}

void main() {
  var rect = Rectangle(5, 3);
  print('Area: ${rect.area}');          // Area: 15.0
  print('Perimeter: ${rect.perimeter}'); // Perimeter: 16.0
}
```

### With Assertions

Validate values in the initializer list:

```dart
class PositiveNumber {
  int value;

  PositiveNumber(this.value)
      : assert(value > 0, 'Value must be positive');
}

void main() {
  var num = PositiveNumber(5);   // OK
  // var bad = PositiveNumber(-3);  // AssertionError!
}
```

---

## Const Constructors

Create compile-time constant objects:

```dart
class Point {
  final double x;
  final double y;

  // Const constructor - all fields must be final
  const Point(this.x, this.y);
}

void main() {
  // Const objects are created at compile time
  const p1 = Point(0, 0);
  const p2 = Point(0, 0);

  // Same memory location!
  print(identical(p1, p2));  // true

  // Non-const objects
  var p3 = Point(0, 0);
  var p4 = Point(0, 0);
  print(identical(p3, p4));  // false (different objects)
}
```

### Why Use Const?

- Better performance (created once at compile time)
- Required for Flutter's `const` widgets
- Enables object comparison with `identical()`

---

## Factory Constructors

Control object creation - can return existing objects or different types:

```dart
class Logger {
  static final Logger _instance = Logger._internal();

  // Factory constructor
  factory Logger() {
    return _instance;  // Always return the same instance
  }

  // Private constructor
  Logger._internal();

  void log(String message) {
    print('[LOG] $message');
  }
}

void main() {
  var logger1 = Logger();
  var logger2 = Logger();

  // Same object!
  print(identical(logger1, logger2));  // true

  logger1.log('Hello');
  logger2.log('World');
}
```

### Factory for Caching

```dart
class Color {
  final int red;
  final int green;
  final int blue;

  // Cache of created colors
  static final Map<String, Color> _cache = {};

  // Factory: return cached or create new
  factory Color(int r, int g, int b) {
    var key = '$r,$g,$b';
    return _cache.putIfAbsent(key, () => Color._internal(r, g, b));
  }

  // Private constructor
  Color._internal(this.red, this.green, this.blue);

  // Named factory constructors
  factory Color.red() => Color(255, 0, 0);
  factory Color.green() => Color(0, 255, 0);
  factory Color.blue() => Color(0, 0, 255);

  @override
  String toString() => 'Color($red, $green, $blue)';
}

void main() {
  var c1 = Color(255, 0, 0);
  var c2 = Color(255, 0, 0);
  var c3 = Color.red();

  // All same object (cached)!
  print(identical(c1, c2));  // true
  print(identical(c1, c3));  // true
}
```

---

## Redirecting Constructors

One constructor calls another:

```dart
class Point {
  double x;
  double y;

  // Main constructor
  Point(this.x, this.y);

  // Redirecting constructors
  Point.origin() : this(0, 0);
  Point.onXAxis(double x) : this(x, 0);
  Point.onYAxis(double y) : this(0, y);
}
```

---

## Constructor Comparison

| Type | When to Use |
|------|-------------|
| Basic | Standard object creation |
| Named | Multiple ways to create same class |
| Const | Immutable, compile-time objects |
| Factory | Custom creation logic, caching, singletons |
| Redirecting | Convenience constructors |

---

## Practical Example: Product Class

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final DateTime createdAt;

  // Main constructor with named parameters
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.category = 'General',
    this.stock = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Named constructor: from JSON
  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        price = (json['price'] as num).toDouble(),
        category = json['category'] as String? ?? 'General',
        stock = json['stock'] as int? ?? 0,
        createdAt = json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now();

  // Named constructor: copy with modifications
  Product.copyWith(
    Product original, {
    String? name,
    double? price,
    int? stock,
  }) : id = original.id,
       name = name ?? original.name,
       price = price ?? original.price,
       category = original.category,
       stock = stock ?? original.stock,
       createdAt = original.createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'stock': stock,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => 'Product($name, \$$price, stock: $stock)';
}

void main() {
  // Using main constructor
  var product1 = Product(
    id: '001',
    name: 'Laptop',
    price: 999.99,
    category: 'Electronics',
    stock: 10,
  );
  print(product1);

  // Using fromJson
  var json = {'id': '002', 'name': 'Mouse', 'price': 29.99};
  var product2 = Product.fromJson(json);
  print(product2);

  // Using copyWith
  var product3 = Product.copyWith(product1, price: 899.99, stock: 8);
  print(product3);
}
```

---

## Summary

| Constructor Type | Syntax | Purpose |
|-----------------|--------|---------|
| Basic | `Class(params)` | Standard creation |
| Named | `Class.name(params)` | Alternative creation |
| Const | `const Class(params)` | Immutable objects |
| Factory | `factory Class()` | Custom creation |
| Redirecting | `Class.a() : this()` | Reuse other constructor |

---

## Quick Quiz

**Q1:** What's the difference between a regular and const constructor?

<details>
<summary>Answer</summary>

Const constructor creates compile-time constants. All fields must be final, and identical const objects share memory.

</details>

**Q2:** When would you use a factory constructor?

<details>
<summary>Answer</summary>

- Implement singleton pattern (one instance)
- Cache and reuse objects
- Return different subclass types
- Complex creation logic

</details>

**Q3:** What's an initializer list used for?

<details>
<summary>Answer</summary>

Initialize fields before the constructor body runs. Used for:
- Setting final fields that need computation
- Assertions for validation
- Calling super constructor

</details>

---

**Next:** Learn about encapsulation - hiding implementation details.

---

**Continue to:** `03-Encapsulation.md`
