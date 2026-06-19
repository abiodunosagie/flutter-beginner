# Level 13 Exercises: Testing & Quality

Welcome! These exercises teach you how to write tests for your Flutter apps. Each part builds your testing skills step-by-step!

**How these exercises work:**
- Each PART focuses on ONE type of testing
- Within each part, exercises build on each other step-by-step
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll be writing tests like a pro!

---

## PART 1: Basic Unit Tests

Learn to write simple unit tests for functions.

### Exercise 1.1: Test a Simple Function

**Goal:** Write your first unit test.

**Your Task:** Test this capitalize function.

```dart
// lib/string_helper.dart
class StringHelper {
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
```

```dart
// test/string_helper_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('capitalize makes first letter uppercase', () {
    final helper = StringHelper();
    // TODO: Call helper.capitalize('hello')
    // TODO: Use expect() to check it equals 'Hello'
  });
}
```

<details>
<summary>✅ Solution</summary>

```dart
test('capitalize makes first letter uppercase', () {
  final helper = StringHelper();
  final result = helper.capitalize('hello');
  expect(result, equals('Hello'));
});
```

**What it does:**
- Calls the function with input
- Checks the output matches expected value
- Test passes if expectation is met
</details>

---

### Exercise 1.2: Test Edge Cases

**Goal:** Test what happens with unusual inputs.

**Your Task:** Test capitalize with empty string.

```dart
test('capitalize handles empty string', () {
  final helper = StringHelper();
  // TODO: Test with empty string ''
  // TODO: Expect it to return ''
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('capitalize handles empty string', () {
  final helper = StringHelper();
  final result = helper.capitalize('');
  expect(result, equals(''));
});
```
</details>

---

### Exercise 1.3: Group Related Tests

**Goal:** Organize tests using group().

**Your Task:** Group all capitalize tests together.

```dart
void main() {
  late StringHelper helper;

  setUp(() {
    // TODO: Create new StringHelper before each test
  });

  group('capitalize', () {
    // TODO: Move your capitalize tests here
  });
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  late StringHelper helper;

  setUp(() {
    helper = StringHelper();
  });

  group('capitalize', () {
    test('makes first letter uppercase', () {
      expect(helper.capitalize('hello'), equals('Hello'));
    });

    test('handles empty string', () {
      expect(helper.capitalize(''), equals(''));
    });

    test('leaves already capitalized unchanged', () {
      expect(helper.capitalize('Hello'), equals('Hello'));
    });
  });
}
```
</details>

---

### Exercise 1.4: Test Multiple Cases

**Goal:** Write tests for another function.

**Your Task:** Test this countWords function.

```dart
int countWords(String text) {
  if (text.trim().isEmpty) return 0;
  return text.trim().split(RegExp(r'\s+')).length;
}
```

```dart
group('countWords', () {
  // TODO: Test "hello world" returns 2
  // TODO: Test empty string returns 0
  // TODO: Test "  hello   world  " returns 2 (extra spaces)
});
```

<details>
<summary>✅ Solution</summary>

```dart
group('countWords', () {
  test('counts words in simple sentence', () {
    expect(helper.countWords('hello world'), equals(2));
  });

  test('returns 0 for empty string', () {
    expect(helper.countWords(''), equals(0));
  });

  test('handles extra spaces', () {
    expect(helper.countWords('  hello   world  '), equals(2));
  });

  test('counts single word', () {
    expect(helper.countWords('hello'), equals(1));
  });
});
```
</details>

---

### Exercise 1.5: Unit Testing Challenge

**Goal:** Write complete tests - NO scaffolding!

**Your Task:** Test this isPalindrome function.

```dart
bool isPalindrome(String text) {
  final cleaned = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  return cleaned == cleaned.split('').reversed.join('');
}
```

**Test Cases to Write:**
1. "racecar" returns true
2. "hello" returns false
3. "A man a plan a canal Panama" returns true
4. Empty string returns true
5. "Madam" returns true (case insensitive)

Try writing all tests on your own!

<details>
<summary>✅ Solution</summary>

```dart
group('isPalindrome', () {
  test('returns true for racecar', () {
    expect(helper.isPalindrome('racecar'), isTrue);
  });

  test('returns false for hello', () {
    expect(helper.isPalindrome('hello'), isFalse);
  });

  test('ignores spaces and punctuation', () {
    expect(helper.isPalindrome('A man a plan a canal Panama'), isTrue);
  });

  test('returns true for empty string', () {
    expect(helper.isPalindrome(''), isTrue);
  });

  test('is case insensitive', () {
    expect(helper.isPalindrome('Madam'), isTrue);
  });
});
```
</details>

---

## PART 2: Testing Models

Learn to test data classes with getters and JSON.

### Exercise 2.1: Test Model Creation

**Goal:** Test creating a model instance.

**Your Task:** Test Product creation.

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  bool get isInStock => stockQuantity > 0;
}
```

```dart
test('creates product with all fields', () {
  // TODO: Create a Product
  // TODO: Verify all fields are set correctly
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('creates product with all fields', () {
  final product = Product(
    id: '1',
    name: 'Laptop',
    price: 999.99,
    stockQuantity: 5,
  );

  expect(product.id, equals('1'));
  expect(product.name, equals('Laptop'));
  expect(product.price, equals(999.99));
  expect(product.stockQuantity, equals(5));
});
```
</details>

---

### Exercise 2.2: Test Computed Properties

**Goal:** Test getter methods.

**Your Task:** Test isInStock getter.

```dart
test('isInStock returns true when quantity > 0', () {
  // TODO: Create product with stockQuantity: 5
  // TODO: Expect isInStock to be true
});

test('isInStock returns false when quantity is 0', () {
  // TODO: Create product with stockQuantity: 0
  // TODO: Expect isInStock to be false
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('isInStock returns true when quantity > 0', () {
  final product = Product(
    id: '1',
    name: 'Laptop',
    price: 999.99,
    stockQuantity: 5,
  );
  expect(product.isInStock, isTrue);
});

test('isInStock returns false when quantity is 0', () {
  final product = Product(
    id: '1',
    name: 'Laptop',
    price: 999.99,
    stockQuantity: 0,
  );
  expect(product.isInStock, isFalse);
});
```
</details>

---

### Exercise 2.3: Test JSON Serialization

**Goal:** Test fromJson and toJson methods.

**Your Task:** Test JSON conversion.

```dart
// Add to Product class:
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    name: json['name'],
    price: (json['price'] as num).toDouble(),
    stockQuantity: json['stock_quantity'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'price': price,
    'stock_quantity': stockQuantity,
  };
}
```

```dart
test('fromJson creates product correctly', () {
  final json = {
    'id': '1',
    'name': 'Laptop',
    'price': 999.99,
    'stock_quantity': 5,
  };

  // TODO: Create product from JSON
  // TODO: Verify all fields
});

test('toJson converts product correctly', () {
  // TODO: Create a product
  // TODO: Convert to JSON
  // TODO: Verify JSON structure
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('fromJson creates product correctly', () {
  final json = {
    'id': '1',
    'name': 'Laptop',
    'price': 999.99,
    'stock_quantity': 5,
  };

  final product = Product.fromJson(json);

  expect(product.id, equals('1'));
  expect(product.name, equals('Laptop'));
  expect(product.price, equals(999.99));
  expect(product.stockQuantity, equals(5));
});

test('toJson converts product correctly', () {
  final product = Product(
    id: '1',
    name: 'Laptop',
    price: 999.99,
    stockQuantity: 5,
  );

  final json = product.toJson();

  expect(json['id'], equals('1'));
  expect(json['name'], equals('Laptop'));
  expect(json['price'], equals(999.99));
  expect(json['stock_quantity'], equals(5));
});
```
</details>

---

### Exercise 2.4: Model Testing Challenge

**Goal:** Test complex model logic - NO scaffolding!

**Your Task:** Add and test these Product features:

```dart
// Add to Product class:
final double? discountPercent;

bool get hasDiscount => discountPercent != null && discountPercent! > 0;

double get finalPrice {
  if (!hasDiscount) return price;
  return price * (1 - discountPercent! / 100);
}

double get savings {
  if (!hasDiscount) return 0;
  return price - finalPrice;
}
```

**Tests to Write:**
1. hasDiscount is true with 20% discount
2. hasDiscount is false with null discount
3. finalPrice with 20% discount on $100
4. finalPrice with no discount
5. savings calculation with discount

Try writing all tests on your own!

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product discount', () {
    test('hasDiscount is true with a 20% discount', () {
      final p = Product(price: 100, discountPercent: 20);
      expect(p.hasDiscount, true);
    });

    test('hasDiscount is false with null discount', () {
      final p = Product(price: 100);
      expect(p.hasDiscount, false);
    });

    test('finalPrice applies a 20% discount on \$100', () {
      final p = Product(price: 100, discountPercent: 20);
      expect(p.finalPrice, 80);
    });

    test('finalPrice equals price when there is no discount', () {
      final p = Product(price: 100);
      expect(p.finalPrice, 100);
    });

    test('savings is the difference when discounted', () {
      final p = Product(price: 100, discountPercent: 20);
      expect(p.savings, 20);
    });
  });
}
```

Each test creates a `Product`, calls one getter, and checks the result with `expect`. Testing the no-discount path (tests 2 and 4) matters as much as the discount path: that is where the `null` check in `hasDiscount`/`finalPrice` is verified.

</details>

---

## PART 3: Testing Async Functions

Learn to test async/await code.

### Exercise 3.1: Test Simple Async Function

**Goal:** Write your first async test.

**Your Task:** Test this async login function.

```dart
class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 100));
    return email == 'test@example.com' && password == 'password123';
  }
}
```

```dart
test('login succeeds with correct credentials', () async {
  final auth = AuthService();
  // TODO: Await auth.login() with correct credentials
  // TODO: Expect result to be true
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('login succeeds with correct credentials', () async {
  final auth = AuthService();
  final result = await auth.login('test@example.com', 'password123');
  expect(result, isTrue);
});
```

**Key Points:**
- Test function must be `async`
- Use `await` when calling async functions
- Rest is the same as normal tests
</details>

---

### Exercise 3.2: Test Exceptions

**Goal:** Test that functions throw errors correctly.

**Your Task:** Test exception throwing.

```dart
Future<bool> login(String email, String password) async {
  if (email.isEmpty) {
    throw ArgumentError('Email cannot be empty');
  }
  // ... rest of login logic
}
```

```dart
test('login throws when email is empty', () {
  final auth = AuthService();
  // TODO: Use expect with throwsA matcher
  // TODO: Check for ArgumentError
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('login throws when email is empty', () {
  final auth = AuthService();
  expect(
    () => auth.login('', 'password'),
    throwsA(isA<ArgumentError>()),
  );
});
```

**What it does:**
- Wraps the async call in a function
- `throwsA` matcher expects an exception
- `isA<ArgumentError>()` checks the exception type
</details>

---

### Exercise 3.3: Test State Changes

**Goal:** Test that state updates correctly after async operations.

**Your Task:** Test this auth service state.

```dart
class AuthService {
  String? _currentUser;
  String? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (email == 'test@example.com' && password == 'password123') {
      _currentUser = email;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }
}
```

```dart
test('currentUser is set after successful login', () async {
  // TODO: Login successfully
  // TODO: Check currentUser is not null
  // TODO: Check isLoggedIn is true
});

test('logout clears currentUser', () async {
  // TODO: Login first
  // TODO: Then logout
  // TODO: Check currentUser is null
  // TODO: Check isLoggedIn is false
});
```

<details>
<summary>✅ Solution</summary>

```dart
test('currentUser is set after successful login', () async {
  final auth = AuthService();
  await auth.login('test@example.com', 'password123');

  expect(auth.currentUser, equals('test@example.com'));
  expect(auth.isLoggedIn, isTrue);
});

test('logout clears currentUser', () async {
  final auth = AuthService();
  await auth.login('test@example.com', 'password123');
  auth.logout();

  expect(auth.currentUser, isNull);
  expect(auth.isLoggedIn, isFalse);
});
```
</details>

---

### Exercise 3.4: Async Testing Challenge

**Goal:** Test complete auth service - NO scaffolding!

**Tests to Write:**
1. Register with valid email and password
2. Register throws for invalid email (no @)
3. Register throws for short password (< 8 chars)
4. Register throws for existing user
5. User is logged in after successful register

Try writing all tests on your own!

<details>
<summary>✅ Solution</summary>

A small self-contained `AuthService` and its tests. Note the `async`/`await` and `throwsA` for the error cases:

```dart
import 'package:flutter_test/flutter_test.dart';

class AuthService {
  final _users = <String>{};
  bool isLoggedIn = false;

  Future<void> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 10)); // pretend network
    if (!email.contains('@')) throw ArgumentError('Invalid email');
    if (password.length < 8) throw ArgumentError('Password too short');
    if (_users.contains(email)) throw StateError('User already exists');
    _users.add(email);
    isLoggedIn = true;
  }
}

void main() {
  late AuthService auth;
  setUp(() => auth = AuthService());

  test('registers with valid email and password', () async {
    await auth.register('a@b.com', 'password123');
    expect(auth.isLoggedIn, true);
  });

  test('throws for invalid email', () {
    expect(() => auth.register('bad-email', 'password123'),
        throwsA(isA<ArgumentError>()));
  });

  test('throws for short password', () {
    expect(() => auth.register('a@b.com', 'short'),
        throwsA(isA<ArgumentError>()));
  });

  test('throws for existing user', () async {
    await auth.register('a@b.com', 'password123');
    expect(() => auth.register('a@b.com', 'password123'),
        throwsA(isA<StateError>()));
  });

  test('user is logged in after successful register', () async {
    expect(auth.isLoggedIn, false);
    await auth.register('a@b.com', 'password123');
    expect(auth.isLoggedIn, true);
  });
}
```

Key async-testing points: make the test function `async` and `await` the call for the happy path, but for the error cases pass the call as a closure to `expect(() => ..., throwsA(...))` so the test framework catches the thrown error.

</details>

---

## PART 4: Widget Tests

Learn to test Flutter widgets.

### Exercise 4.1: Find Widgets in Test

**Goal:** Test that widgets are displayed.

**Your Task:** Test this simple widget.

```dart
class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}
```

```dart
testWidgets('displays greeting text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GreetingWidget(name: 'Alice'),
      ),
    ),
  );

  // TODO: Use find.text() to find the greeting
  // TODO: Use expect with findsOneWidget
});
```

<details>
<summary>✅ Solution</summary>

```dart
testWidgets('displays greeting text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GreetingWidget(name: 'Alice'),
      ),
    ),
  );

  expect(find.text('Hello, Alice!'), findsOneWidget);
});
```

**Key Points:**
- Wrap widget in MaterialApp
- Use `tester.pumpWidget` to render
- Use `find` to locate widgets
- Use matchers like `findsOneWidget`
</details>

---

### Exercise 4.2: Test User Interactions

**Goal:** Test tapping buttons.

**Your Task:** Test this counter widget.

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count', key: Key('count_text')),
        ElevatedButton(
          key: Key('increment_button'),
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

```dart
testWidgets('tapping button increments counter', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: CounterWidget())),
  );

  // TODO: Verify initial count is 0
  // TODO: Tap the increment button
  // TODO: Call tester.pump() to rebuild
  // TODO: Verify count is now 1
});
```

<details>
<summary>✅ Solution</summary>

```dart
testWidgets('tapping button increments counter', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: CounterWidget())),
  );

  // Verify initial state
  expect(find.text('Count: 0'), findsOneWidget);

  // Tap button
  await tester.tap(find.byKey(Key('increment_button')));
  await tester.pump();

  // Verify new state
  expect(find.text('Count: 1'), findsOneWidget);
});
```

**What it does:**
- Uses keys to find specific widgets
- `tester.tap()` simulates user tap
- `tester.pump()` rebuilds the widget
- Checks that state updated
</details>

---

### Exercise 4.3: Test Form Input

**Goal:** Test entering text in a TextField.

**Your Task:** Test this simple form.

```dart
class NameForm extends StatefulWidget {
  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _controller = TextEditingController();
  String _submitted = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: Key('name_field'),
          controller: _controller,
        ),
        ElevatedButton(
          key: Key('submit_button'),
          onPressed: () {
            setState(() => _submitted = _controller.text);
          },
          child: Text('Submit'),
        ),
        Text('Submitted: $_submitted', key: Key('result_text')),
      ],
    );
  }
}
```

```dart
testWidgets('submitting form shows entered text', (tester) async {
  // TODO: Pump the widget
  // TODO: Enter text in the TextField
  // TODO: Tap submit button
  // TODO: Verify submitted text is displayed
});
```

<details>
<summary>✅ Solution</summary>

```dart
testWidgets('submitting form shows entered text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: NameForm())),
  );

  // Enter text
  await tester.enterText(find.byKey(Key('name_field')), 'Alice');
  await tester.pump();

  // Submit
  await tester.tap(find.byKey(Key('submit_button')));
  await tester.pump();

  // Verify
  expect(find.text('Submitted: Alice'), findsOneWidget);
});
```
</details>

---

### Exercise 4.4: Widget Testing Challenge

**Goal:** Test a rating widget - NO scaffolding!

**Your Task:** Test this widget completely.

```dart
class RatingWidget extends StatefulWidget {
  final Function(int)? onRatingChanged;

  const RatingWidget({this.onRatingChanged});

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        return IconButton(
          key: Key('star_$starNumber'),
          icon: Icon(
            starNumber <= _rating ? Icons.star : Icons.star_border,
          ),
          onPressed: () {
            setState(() => _rating = starNumber);
            widget.onRatingChanged?.call(starNumber);
          },
        );
      }),
    );
  }
}
```

**Tests to Write:**
1. Displays 5 stars initially
2. All stars are empty initially
3. Tapping star 3 fills stars 1, 2, 3
4. Calls onRatingChanged callback with correct value

Try writing all tests on your own!

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('displays 5 stars initially', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RatingWidget()));
    expect(find.byType(IconButton), findsNWidgets(5));
  });

  testWidgets('all stars are empty initially', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RatingWidget()));
    expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('tapping star 3 fills stars 1, 2, 3', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RatingWidget()));
    await tester.tap(find.byKey(const Key('star_3')));
    await tester.pump(); // rebuild after setState
    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });

  testWidgets('calls onRatingChanged with the tapped value', (tester) async {
    int? reported;
    await tester.pumpWidget(MaterialApp(
      home: RatingWidget(onRatingChanged: (v) => reported = v),
    ));
    await tester.tap(find.byKey(const Key('star_4')));
    await tester.pump();
    expect(reported, 4);
  });
}
```

The widget exposes `Key('star_N')` on each star, which makes it easy to tap an exact star. After a tap you must call `tester.pump()` so the `setState` rebuild happens before you check the icons. The callback test captures the reported value in a local variable.

</details>

---

## FINAL PROJECT: Test a Complete Feature

**Goal:** Write comprehensive tests for a Todo app!

**Your Task:** Test this todo feature completely - NO help!

### Requirements:

**Unit Tests:**
- Todo model creation
- Todo fromJson/toJson
- isCompleted getter
- Toggle complete status

**Widget Tests:**
- TodoList displays all todos
- Tapping checkbox toggles completion
- Add todo form validation
- Submit adds todo to list

**Integration Test:**
- Complete user flow: add → view → complete → delete

### Build comprehensive tests using everything you learned!

---

## Submission Checklist

Before moving to the next level:

- [ ] Completed all PART 1 exercises (Unit Tests)
- [ ] Completed all PART 2 exercises (Model Tests)
- [ ] Completed all PART 3 exercises (Async Tests)
- [ ] Completed all PART 4 exercises (Widget Tests)
- [ ] Completed the Final Project
- [ ] All tests pass when running `flutter test`
- [ ] Tests are well organized with groups
- [ ] Edge cases are covered
- [ ] Both success and failure paths tested

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/my_test.dart

# Run with coverage
flutter test --coverage

# Watch mode (re-runs on file change)
flutter test --watch
```

---

## Need Help?

Review the theory files about testing in the Theory folder!

---

**You're writing code that works AND proves it works!** ✅
