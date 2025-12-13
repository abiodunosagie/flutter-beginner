# Parameters: Passing Data to Functions

## What Are Parameters?

Parameters are the "inputs" to a function. They let you customize what the function does.

```dart
void greet(String name) {  // name is a parameter
  print('Hello, $name!');
}

void main() {
  greet('Alice');  // 'Alice' is an argument
}
```

**Parameter** = Variable in function declaration
**Argument** = Actual value passed when calling

---

## Types of Parameters

Dart has several types:

1. **Required Positional** - Must provide, in order
2. **Optional Positional** - Can skip
3. **Named** - Specify by name
4. **Required Named** - Named, but required

---

## 1. Required Positional Parameters

The most basic type. Must provide ALL values in ORDER.

```dart
void introduce(String name, int age, String city) {
  print('I am $name, $age years old, from $city');
}

void main() {
  introduce('Alice', 25, 'NYC');  // ✅ All required, in order
  introduce('NYC', 25, 'Alice');  // ❌ Wrong order = wrong output
  introduce('Alice', 25);         // ❌ Error: Missing city
}
```

### When to Use

- When ALL parameters are necessary
- When there are only 1-2 parameters
- When order is obvious

---

## 2. Optional Positional Parameters

Wrap in `[ ]` to make optional. Must provide default values or handle null.

```dart
void greet(String name, [String greeting = 'Hello']) {
  print('$greeting, $name!');
}

void main() {
  greet('Alice');           // Hello, Alice!
  greet('Bob', 'Hi');       // Hi, Bob!
  greet('Charlie', 'Hey');  // Hey, Charlie!
}
```

### Multiple Optional Parameters

```dart
void createProfile(String name, [int? age, String? city]) {
  print('Name: $name');
  if (age != null) print('Age: $age');
  if (city != null) print('City: $city');
}

void main() {
  createProfile('Alice');
  createProfile('Bob', 30);
  createProfile('Charlie', 25, 'NYC');
}
```

### Important Rules

```dart
// ✅ Correct: Required first, then optional
void function(String required, [String? optional]) { }

// ❌ Error: Optional cannot come before required
void function([String? optional], String required) { }
```

---

## 3. Named Parameters

Wrap in `{ }`. Specify by name when calling.

```dart
void createUser({String? name, int? age, String? email}) {
  print('Name: $name');
  print('Age: $age');
  print('Email: $email');
}

void main() {
  createUser(name: 'Alice', age: 25, email: 'alice@email.com');
  createUser(age: 30, name: 'Bob');  // Order doesn't matter!
  createUser(email: 'test@email.com');  // Can skip some
}
```

### With Default Values

```dart
void greet({String name = 'Guest', String greeting = 'Hello'}) {
  print('$greeting, $name!');
}

void main() {
  greet();                        // Hello, Guest!
  greet(name: 'Alice');          // Hello, Alice!
  greet(greeting: 'Hi');         // Hi, Guest!
  greet(name: 'Bob', greeting: 'Hey');  // Hey, Bob!
}
```

### When to Use Named Parameters

- When function has many parameters (3+)
- When parameter meaning isn't obvious
- When most parameters have defaults
- For better readability

---

## 4. Required Named Parameters

Named, but MUST be provided. Use `required` keyword.

```dart
void createAccount({
  required String email,
  required String password,
  String? nickname,
}) {
  print('Creating account for: $email');
}

void main() {
  // ✅ Required ones provided
  createAccount(email: 'test@email.com', password: 'secret123');

  // ✅ With optional nickname
  createAccount(
    email: 'test@email.com',
    password: 'secret123',
    nickname: 'Tester',
  );

  // ❌ Error: email and password are required
  createAccount(nickname: 'Tester');
}
```

---

## Comparison Chart

| Type | Syntax | Required? | Order Matters? |
|------|--------|-----------|----------------|
| Required Positional | `(Type param)` | Yes | Yes |
| Optional Positional | `([Type? param])` | No | Yes |
| Named | `({Type? param})` | No | No |
| Required Named | `({required Type param})` | Yes | No |

---

## Mixing Parameter Types

You CAN mix positional and named:

```dart
void orderFood(
  String item,           // Required positional
  int quantity,          // Required positional
  {
    bool? spicy,         // Named optional
    String? notes,       // Named optional
    required String table,  // Named required
  }
) {
  print('Order: $quantity x $item for table $table');
  if (spicy == true) print('Make it spicy!');
  if (notes != null) print('Note: $notes');
}

void main() {
  orderFood('Pizza', 2, table: 'A5');
  orderFood('Burger', 1, table: 'B3', spicy: true, notes: 'No onions');
}
```

### Rules for Mixing

```dart
// ✅ Correct order: positional first, then named
void function(int a, int b, {String? c, required String d}) { }

// ❌ Cannot mix optional positional and named
void function([int? a], {String? b}) { }  // Error!
```

---

## Default Values

Provide fallback values for optional parameters:

```dart
// Optional positional with default
void greet([String name = 'World']) {
  print('Hello, $name!');
}

// Named with default
void configure({int timeout = 30, bool debug = false}) {
  print('Timeout: $timeout seconds');
  print('Debug mode: $debug');
}

void main() {
  greet();              // Hello, World!
  greet('Alice');       // Hello, Alice!

  configure();          // Uses all defaults
  configure(timeout: 60);  // Override timeout only
}
```

### Default Value Rules

Defaults must be:
- Compile-time constants
- Literals (numbers, strings, booleans)
- Const constructors

```dart
// ✅ Valid defaults
void function({
  int count = 0,
  String name = 'default',
  bool flag = true,
  List<int> items = const [],  // const required for collections
}) { }

// ❌ Invalid defaults
void function({
  DateTime date = DateTime.now(),  // Error: not const
  List<int> items = [],  // Error: needs const
}) { }
```

---

## Null Safety with Parameters

### Nullable vs Non-Nullable

```dart
// Non-nullable: Must always have a value
void greet(String name) { }  // name is never null

// Nullable: Can be null
void greet(String? name) {
  if (name != null) {
    print('Hello, $name!');
  } else {
    print('Hello, stranger!');
  }
}
```

### Optional = Nullable (Usually)

```dart
void process([int? value]) {
  // value might be null
  print(value ?? 'No value provided');
}

void configure({int? timeout}) {
  // timeout might be null
  print('Timeout: ${timeout ?? 30}');
}
```

---

## Practical Examples

### Example 1: User Registration

```dart
void registerUser({
  required String email,
  required String password,
  String? username,
  int age = 0,
  bool newsletter = false,
}) {
  print('Email: $email');
  print('Username: ${username ?? email.split('@')[0]}');
  print('Age: ${age > 0 ? age : 'Not provided'}');
  print('Newsletter: ${newsletter ? 'Yes' : 'No'}');
}

void main() {
  registerUser(
    email: 'alice@email.com',
    password: 'secure123',
    newsletter: true,
  );
}
```

### Example 2: HTTP Request

```dart
void makeRequest(
  String url, {
  String method = 'GET',
  Map<String, String>? headers,
  String? body,
  int timeout = 30,
}) {
  print('$method $url');
  print('Timeout: ${timeout}s');
  if (headers != null) print('Headers: $headers');
  if (body != null) print('Body: $body');
}

void main() {
  // Simple GET
  makeRequest('https://api.example.com/users');

  // POST with body
  makeRequest(
    'https://api.example.com/users',
    method: 'POST',
    body: '{"name": "Alice"}',
    headers: {'Content-Type': 'application/json'},
  );
}
```

### Example 3: Drawing Shapes

```dart
void drawRectangle(
  int width,
  int height, {
  String char = '*',
  bool filled = true,
}) {
  for (int row = 0; row < height; row++) {
    String line = '';
    for (int col = 0; col < width; col++) {
      if (filled || row == 0 || row == height - 1 ||
          col == 0 || col == width - 1) {
        line += '$char ';
      } else {
        line += '  ';
      }
    }
    print(line);
  }
}

void main() {
  print('Filled:');
  drawRectangle(5, 3);

  print('\nHollow:');
  drawRectangle(5, 3, filled: false);

  print('\nCustom:');
  drawRectangle(6, 4, char: '#', filled: false);
}
```

---

## Best Practices

### 1. Use Named Parameters for Clarity

```dart
// ❌ What does true mean?
createUser('Alice', 25, true, false, true);

// ✅ Clear what each value means
createUser(
  name: 'Alice',
  age: 25,
  isAdmin: true,
  isActive: false,
  sendWelcomeEmail: true,
);
```

### 2. Keep Required Parameters Minimal

```dart
// ❌ Too many required parameters
void process(int a, int b, int c, int d, int e, int f) { }

// ✅ Better: Required essentials, named options
void process(int id, {int? limit, int? offset, String? filter}) { }
```

### 3. Use Meaningful Defaults

```dart
// ✅ Good defaults
void paginate({int page = 1, int pageSize = 20}) { }
void connect({int timeout = 30, int retries = 3}) { }

// ❌ Unclear defaults
void paginate({int page = 0, int pageSize = 0}) { }  // 0 is meaningless
```

---

## Summary

| Parameter Type | Syntax | Example Call |
|---------------|--------|--------------|
| Required Positional | `(int a)` | `func(5)` |
| Optional Positional | `([int a = 0])` | `func()` or `func(5)` |
| Named | `({int? a})` | `func()` or `func(a: 5)` |
| Required Named | `({required int a})` | `func(a: 5)` |

---

## Quick Quiz

**Q1:** What's wrong?

```dart
void func([int a], int b) { }
```

<details>
<summary>Answer</summary>

Required parameters must come BEFORE optional ones.

```dart
void func(int b, [int? a]) { }
```

</details>

**Q2:** How do you call this function to set only `debug` to true?

```dart
void config({int port = 8080, bool debug = false}) { }
```

<details>
<summary>Answer</summary>

```dart
config(debug: true);  // port uses default 8080
```

</details>

**Q3:** What's the output?

```dart
void greet([String name = 'World']) {
  print('Hello, $name!');
}

void main() {
  greet();
}
```

<details>
<summary>Answer</summary>

`Hello, World!` - uses the default value.

</details>

---

**Next:** Learn about return values and arrow functions.

---

**Continue to:** `03-ReturnValues.md`
