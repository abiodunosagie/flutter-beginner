# Week 13, Day 3-4: Data Models - Type-Safe JSON

## The Problem with `Map<String, dynamic>`

Yesterday you learned to parse JSON like this:

```dart
Map<String, dynamic> user = jsonDecode(jsonString);
print(user['name']);
print(user['aeg']);  // TYPO! But Dart doesn't know until runtime
```

**Problems:**
1. ❌ **Typos** - `user['aeg']` instead of `user['age']` - no error until runtime
2. ❌ **No autocomplete** - Your editor can't help you
3. ❌ **Type confusion** - Is it an int? String? Who knows?
4. ❌ **Hard to maintain** - What fields does this object even have?

**Solution:** **Data Models** (also called Model Classes)

---

## What is a Data Model?

A **model** is a Dart class that represents your JSON structure.

Instead of:
```dart
Map<String, dynamic> user = {...};
print(user['name']);  // Could typo this
```

You write:
```dart
User user = User.fromJson(...);
print(user.name);  // Autocomplete! Type-safe!
```

**Benefits:**
- ✅ Autocomplete in your editor
- ✅ Type safety (Dart knows what type everything is)
- ✅ No typos
- ✅ Clear structure
- ✅ Easier to maintain

---

## Creating Your First Model

### Step 1: Look at the JSON

```json
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com",
  "age": 25
}
```

### Step 2: Create a Class

```dart
class User {
  final int id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
}
```

**What this does:**
- Creates a User class with 4 properties
- All properties are `final` (immutable - good practice)
- Constructor requires all fields

### Step 3: Add `fromJson` Method

This converts JSON Map to User object:

```dart
class User {
  final int id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }
}
```

**What's happening:**
- `factory` keyword creates a factory constructor
- Takes a `Map<String, dynamic>` (parsed JSON)
- Extracts each field
- Returns a new User object

### Step 4: Add `toJson` Method

This converts User object back to JSON Map:

```dart
class User {
  final int id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }
}
```

---

## Using Your Model

### Complete Example

```dart
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }
}

void main() {
  // JSON string from API
  String jsonString = '''
  {
    "id": 1,
    "name": "Alice",
    "email": "alice@example.com",
    "age": 25
  }
  ''';

  // Parse JSON to Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Create User from JSON
  User user = User.fromJson(jsonMap);

  // Now access with type safety!
  print('ID: ${user.id}');       // Autocomplete works!
  print('Name: ${user.name}');   // Type-safe
  print('Email: ${user.email}');
  print('Age: ${user.age}');

  // Convert back to JSON
  Map<String, dynamic> userMap = user.toJson();
  String backToJson = jsonEncode(userMap);
  print(backToJson);
}
```

---

## Handling Nullable Fields

Real APIs often have optional fields:

```json
{
  "id": 1,
  "name": "Bob",
  "email": "bob@example.com",
  "phone": null
}
```

**Model with nullable field:**

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;  // ← Nullable (might be null)

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,  // ← Not required
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],  // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
```

**Using it:**
```dart
User user = User.fromJson(jsonMap);

// Check if phone exists
if (user.phone != null) {
  print('Phone: ${user.phone}');
} else {
  print('No phone number');
}
```

---

## Lists of Objects

APIs often return arrays. Let's model a list of users:

```json
[
  {"id": 1, "name": "Alice", "age": 25},
  {"id": 2, "name": "Bob", "age": 30},
  {"id": 3, "name": "Charlie", "age": 35}
]
```

**Parsing:**

```dart
void main() {
  String jsonString = '''
  [
    {"id": 1, "name": "Alice", "age": 25},
    {"id": 2, "name": "Bob", "age": 30},
    {"id": 3, "name": "Charlie", "age": 35}
  ]
  ''';

  // Parse JSON array
  List<dynamic> jsonList = jsonDecode(jsonString);

  // Convert each item to User object
  List<User> users = jsonList.map((json) => User.fromJson(json)).toList();

  // Now you have a typed list!
  for (User user in users) {
    print('${user.name} is ${user.age} years old');
  }
}
```

**Breaking down the conversion:**
```dart
// Long way
List<User> users = [];
for (var json in jsonList) {
  users.add(User.fromJson(json));
}

// Short way (using map)
List<User> users = jsonList.map((json) => User.fromJson(json)).toList();
```

---

## Nested Objects

JSON often has objects inside objects:

```json
{
  "id": 1,
  "name": "Alice",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "zip": "10001"
  }
}
```

**Create models for both:**

```dart
class Address {
  final String street;
  final String city;
  final String zip;

  Address({
    required this.street,
    required this.city,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zip': zip,
    };
  }
}

class User {
  final int id;
  final String name;
  final Address address;  // ← Nested object

  User({
    required this.id,
    required this.name,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      address: Address.fromJson(json['address']),  // ← Parse nested
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address.toJson(),  // ← Convert nested
    };
  }
}
```

**Using it:**
```dart
User user = User.fromJson(jsonMap);
print('${user.name} lives in ${user.address.city}');
```

---

## Arrays Inside Objects

Real-world example: A post with comments:

```json
{
  "id": 101,
  "author": "Alice",
  "content": "Learning Flutter!",
  "comments": [
    {"user": "Bob", "text": "Great!"},
    {"user": "Charlie", "text": "Nice!"}
  ]
}
```

**Models:**

```dart
class Comment {
  final String user;
  final String text;

  Comment({required this.user, required this.text});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user, 'text': text};
  }
}

class Post {
  final int id;
  final String author;
  final String content;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Parse comments array
    List<Comment> commentsList = (json['comments'] as List)
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();

    return Post(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      comments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}
```

**Using it:**
```dart
Post post = Post.fromJson(jsonMap);

print('${post.author}: ${post.content}');
print('Comments:');
for (Comment comment in post.comments) {
  print('  ${comment.user}: ${comment.text}');
}
```

---

## Adding Helper Methods

Models can have useful methods:

```dart
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int age;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
  });

  // Helper: Get full name
  String get fullName => '$firstName $lastName';

  // Helper: Check if adult
  bool get isAdult => age >= 18;

  // Helper: Get email domain
  String get emailDomain => email.split('@')[1];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
    };
  }
}

// Usage
User user = User.fromJson(jsonMap);
print(user.fullName);      // Alice Smith
print(user.isAdult);       // true
print(user.emailDomain);   // example.com
```

---

## Best Practices

### 1. Use `final` for Properties

```dart
class User {
  final String name;  // ✓ Can't be changed after creation
  // String name;     // ✗ Can be changed (usually not what you want)
}
```

### 2. Handle Missing Fields Safely

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] ?? 0,           // Default to 0 if missing
    name: json['name'] ?? '',      // Default to empty string
    age: json['age'] ?? 0,
  );
}
```

### 3. Add toString() for Debugging

```dart
class User {
  // ... properties and methods ...

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, age: $age)';
  }
}

// Usage
print(user);  // User(id: 1, name: Alice, email: alice@example.com, age: 25)
```

### 4. One Model Per File

Keep your code organized:
```
lib/
  models/
    user.dart
    post.dart
    comment.dart
    address.dart
```

---

## Exercises

### Exercise 1: Product Model

Create a model for this JSON:

```json
{
  "id": 101,
  "name": "Laptop",
  "price": 999.99,
  "inStock": true
}
```

<details>
<summary>Solution</summary>

```dart
class Product {
  final int id;
  final String name;
  final double price;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      inStock: json['inStock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'inStock': inStock,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: \$$price, inStock: $inStock)';
  }
}
```
</details>

---

### Exercise 2: Book with Author

Create models for this nested JSON:

```json
{
  "id": 1,
  "title": "1984",
  "author": {
    "name": "George Orwell",
    "country": "UK"
  },
  "year": 1949
}
```

<details>
<summary>Solution</summary>

```dart
class Author {
  final String name;
  final String country;

  Author({required this.name, required this.country});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'country': country};
  }
}

class Book {
  final int id;
  final String title;
  final Author author;
  final int year;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: Author.fromJson(json['author']),
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author.toJson(),
      'year': year,
    };
  }
}
```
</details>

---

### Exercise 3: Parse List of Products

Use the Product model from Exercise 1 to parse this:

```json
[
  {"id": 1, "name": "Laptop", "price": 999.99, "inStock": true},
  {"id": 2, "name": "Mouse", "price": 25.00, "inStock": true},
  {"id": 3, "name": "Monitor", "price": 299.99, "inStock": false}
]
```

Print only products that are in stock.

<details>
<summary>Solution</summary>

```dart
void main() {
  String jsonString = '''
  [
    {"id": 1, "name": "Laptop", "price": 999.99, "inStock": true},
    {"id": 2, "name": "Mouse", "price": 25.00, "inStock": true},
    {"id": 3, "name": "Monitor", "price": 299.99, "inStock": false}
  ]
  ''';

  List<dynamic> jsonList = jsonDecode(jsonString);
  List<Product> products = jsonList.map((json) => Product.fromJson(json)).toList();

  print('Products in stock:');
  for (Product product in products) {
    if (product.inStock) {
      print('- ${product.name}: \$${product.price}');
    }
  }
}
```
</details>

---

## Key Takeaways

1. **Models = Type-safe JSON**
2. **`fromJson()` converts Map to object**
3. **`toJson()` converts object to Map**
4. **Use `final` for immutable properties**
5. **Nullable fields use `?` and aren't required**
6. **Nested objects need nested models**
7. **Lists use `.map()` to convert**

---

## What's Next?

Now you can parse JSON professionally! Tomorrow:
- **HTTP requests** - Getting data from real APIs
- **GET, POST, PUT, DELETE** methods
- **Error handling** for network requests

You're ready for real API integration! 🚀
