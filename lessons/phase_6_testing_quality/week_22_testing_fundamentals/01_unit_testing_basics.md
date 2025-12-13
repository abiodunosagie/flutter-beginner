# Unit Testing Basics: Testing Your Code Like a Pro

## What You'll Learn

In this lesson, you'll learn:
- What testing is and why it's CRITICAL for professional development
- How to write unit tests for functions and classes
- Testing with the `test` package
- Assertions and matchers
- Test organization (arrange, act, assert)
- Testing edge cases and error conditions
- Test-Driven Development (TDD) basics
- Best practices for writing maintainable tests

By the end, you'll be able to confidently test any Dart code!

## Understanding Testing (Like Explaining to a 5-Year-Old)

### What is Testing?

Imagine you build a LEGO castle. Before showing it to your friends, you want to make sure:
- ✅ The door opens and closes
- ✅ The windows don't fall off
- ✅ The tower doesn't collapse when you touch it

**Testing your code is the same thing!**

You write small checks (tests) to make sure your code:
- ✅ Works correctly
- ✅ Doesn't break when you change things
- ✅ Handles errors properly

### Real-Life Example

**Without Tests:**
```dart
// You write a calculator
int add(int a, int b) {
  return a + b;
}

// You manually check in the app
// add(2, 3) = 5 ✅
// Looks good!

// Later, you accidentally change it
int add(int a, int b) {
  return a - b;  // Oops! Bug!
}

// You don't notice until users complain
// App crashes in production 😱
```

**With Tests:**
```dart
// You write a calculator
int add(int a, int b) {
  return a + b;
}

// You write a test
test('add should return sum of two numbers', () {
  expect(add(2, 3), equals(5));
});

// Later, you accidentally change it
int add(int a, int b) {
  return a - b;  // Bug!
}

// Test fails IMMEDIATELY ❌
// You fix it before deploying 🎉
```

### Types of Testing

Think of testing like quality checks at different stages:

1. **Unit Testing** 🔬
   - Test ONE small piece (function, class)
   - Like testing a single LEGO brick
   - Example: Test the `add()` function

2. **Widget Testing** 🧩
   - Test UI components (buttons, forms)
   - Like testing a LEGO wall section
   - Example: Test that button shows correct text

3. **Integration Testing** 🏰
   - Test complete features (login flow, checkout)
   - Like testing the entire LEGO castle
   - Example: Test user can sign up and log in

**This lesson focuses on Unit Testing - testing individual functions and classes.**

## Step 1: Setting Up Testing

### 1. Check Your pubspec.yaml

Every Flutter project comes with the test package. Open `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  test: ^1.24.0
```

If `test` isn't there, add it and run:

```bash
flutter pub get
```

### 2. Create Test Directory

Your project structure should look like:

```
my_app/
├── lib/
│   └── main.dart
├── test/
│   └── (your tests go here)
└── pubspec.yaml
```

The `test/` folder mirrors your `lib/` folder structure.

### 3. Create Your First Test File

Create `test/calculator_test.dart`:

```dart
import 'package:test/test.dart';

void main() {
  test('my first test', () {
    // This is where your test code goes
    expect(1 + 1, equals(2));
  });
}
```

### 4. Run Tests

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/calculator_test.dart

# Run with verbose output
flutter test --reporter expanded
```

## Step 2: Understanding Test Structure

Every test follows the **Arrange-Act-Assert** pattern:

```dart
test('description of what you're testing', () {
  // ARRANGE: Set up test data
  final calculator = Calculator();
  final a = 5;
  final b = 3;

  // ACT: Perform the action you're testing
  final result = calculator.add(a, b);

  // ASSERT: Check the result is correct
  expect(result, equals(8));
});
```

**Think of it like a science experiment:**
1. **Arrange** = Prepare your materials
2. **Act** = Conduct the experiment
3. **Assert** = Check if results match your hypothesis

## Step 3: Writing Your First Real Tests

Let's create a `Calculator` class and test it thoroughly.

### Create the Calculator Class

Create `lib/calculator.dart`:

```dart
class Calculator {
  /// Adds two numbers
  int add(int a, int b) {
    return a + b;
  }

  /// Subtracts b from a
  int subtract(int a, int b) {
    return a - b;
  }

  /// Multiplies two numbers
  int multiply(int a, int b) {
    return a * b;
  }

  /// Divides a by b
  /// Throws ArgumentError if b is zero
  double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return a / b;
  }

  /// Checks if a number is even
  bool isEven(int number) {
    return number % 2 == 0;
  }

  /// Calculates factorial
  int factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Cannot calculate factorial of negative number');
    }
    if (n == 0 || n == 1) {
      return 1;
    }
    return n * factorial(n - 1);
  }
}
```

### Create Comprehensive Tests

Create `test/calculator_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:my_app/calculator.dart';

void main() {
  // Group related tests together
  group('Calculator', () {
    // Create a calculator instance for all tests
    late Calculator calculator;

    // setUp runs before EACH test
    setUp(() {
      calculator = Calculator();
    });

    // Test addition
    group('add', () {
      test('should return sum of two positive numbers', () {
        // Arrange
        final a = 5;
        final b = 3;

        // Act
        final result = calculator.add(a, b);

        // Assert
        expect(result, equals(8));
      });

      test('should return sum of negative numbers', () {
        expect(calculator.add(-5, -3), equals(-8));
      });

      test('should return sum of positive and negative', () {
        expect(calculator.add(10, -3), equals(7));
      });

      test('should handle zero', () {
        expect(calculator.add(0, 5), equals(5));
        expect(calculator.add(5, 0), equals(5));
      });

      test('should handle large numbers', () {
        expect(calculator.add(1000000, 2000000), equals(3000000));
      });
    });

    // Test subtraction
    group('subtract', () {
      test('should return difference of two numbers', () {
        expect(calculator.subtract(10, 3), equals(7));
      });

      test('should handle negative results', () {
        expect(calculator.subtract(3, 10), equals(-7));
      });

      test('should subtract zero', () {
        expect(calculator.subtract(5, 0), equals(5));
      });
    });

    // Test multiplication
    group('multiply', () {
      test('should return product of two numbers', () {
        expect(calculator.multiply(4, 5), equals(20));
      });

      test('should multiply by zero', () {
        expect(calculator.multiply(5, 0), equals(0));
      });

      test('should multiply negative numbers', () {
        expect(calculator.multiply(-4, 5), equals(-20));
        expect(calculator.multiply(-4, -5), equals(20));
      });
    });

    // Test division
    group('divide', () {
      test('should return quotient of two numbers', () {
        expect(calculator.divide(10, 2), equals(5.0));
      });

      test('should return decimal results', () {
        expect(calculator.divide(7, 2), equals(3.5));
      });

      test('should throw error when dividing by zero', () {
        // Test that an error is thrown
        expect(
          () => calculator.divide(10, 0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw error with correct message', () {
        expect(
          () => calculator.divide(10, 0),
          throwsA(
            predicate((e) =>
                e is ArgumentError &&
                e.message == 'Cannot divide by zero'),
          ),
        );
      });
    });

    // Test isEven
    group('isEven', () {
      test('should return true for even numbers', () {
        expect(calculator.isEven(2), isTrue);
        expect(calculator.isEven(4), isTrue);
        expect(calculator.isEven(100), isTrue);
      });

      test('should return false for odd numbers', () {
        expect(calculator.isEven(1), isFalse);
        expect(calculator.isEven(3), isFalse);
        expect(calculator.isEven(99), isFalse);
      });

      test('should handle zero', () {
        expect(calculator.isEven(0), isTrue);
      });

      test('should handle negative numbers', () {
        expect(calculator.isEven(-2), isTrue);
        expect(calculator.isEven(-3), isFalse);
      });
    });

    // Test factorial
    group('factorial', () {
      test('should calculate factorial of positive numbers', () {
        expect(calculator.factorial(0), equals(1));
        expect(calculator.factorial(1), equals(1));
        expect(calculator.factorial(5), equals(120));
        expect(calculator.factorial(6), equals(720));
      });

      test('should throw error for negative numbers', () {
        expect(
          () => calculator.factorial(-1),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
```

**What's happening here?**

1. **`group()`** - Organizes related tests together
2. **`setUp()`** - Runs before each test (creates fresh calculator)
3. **`test()`** - Individual test case
4. **`expect()`** - Check if result matches expected value
5. **Matchers** - `equals()`, `isTrue`, `isFalse`, `throwsA()`

## Step 4: Understanding Matchers

Matchers are how you check results. Think of them as "check if..." statements.

### Common Matchers

```dart
// Equality
expect(result, equals(10));
expect(result, 10);  // Shorthand

// Boolean
expect(isValid, isTrue);
expect(isValid, isFalse);

// Null
expect(value, isNull);
expect(value, isNotNull);

// Type checking
expect(result, isA<String>());
expect(result, isA<int>());

// Numeric comparisons
expect(age, greaterThan(18));
expect(score, lessThan(100));
expect(percentage, greaterThanOrEqualTo(0));
expect(percentage, lessThanOrEqualTo(100));
expect(value, inRange(0, 100));

// Strings
expect(message, contains('error'));
expect(email, startsWith('user@'));
expect(filename, endsWith('.txt'));
expect(text, matches(RegExp(r'\d{3}-\d{3}-\d{4}')));  // Phone pattern

// Collections
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(5));
expect(list, contains(42));
expect(list, containsAll([1, 2, 3]));

// Exceptions
expect(() => someFunction(), throwsException);
expect(() => someFunction(), throwsA(isA<ArgumentError>()));
expect(() => someFunction(), throwsArgumentError);

// Custom matchers
expect(result, predicate((value) => value > 0, 'is positive'));
```

### Combining Matchers

```dart
// AND
expect(value, allOf([greaterThan(0), lessThan(100)]));

// OR
expect(value, anyOf([equals(0), equals(1)]));

// NOT
expect(value, isNot(equals(0)));
```

## Step 5: Testing Classes with State

Let's test a more complex class with state.

Create `lib/counter.dart`:

```dart
class Counter {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
  }

  void decrement() {
    _value--;
  }

  void reset() {
    _value = 0;
  }

  void incrementBy(int amount) {
    if (amount < 0) {
      throw ArgumentError('Amount must be positive');
    }
    _value += amount;
  }
}
```

Create `test/counter_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:my_app/counter.dart';

void main() {
  group('Counter', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    test('should start at zero', () {
      expect(counter.value, equals(0));
    });

    test('should increment by one', () {
      counter.increment();
      expect(counter.value, equals(1));

      counter.increment();
      expect(counter.value, equals(2));
    });

    test('should decrement by one', () {
      counter.increment();
      counter.increment();
      counter.decrement();

      expect(counter.value, equals(1));
    });

    test('should allow negative values', () {
      counter.decrement();
      expect(counter.value, equals(-1));
    });

    test('should reset to zero', () {
      counter.increment();
      counter.increment();
      counter.increment();

      counter.reset();

      expect(counter.value, equals(0));
    });

    test('should increment by specified amount', () {
      counter.incrementBy(5);
      expect(counter.value, equals(5));

      counter.incrementBy(3);
      expect(counter.value, equals(8));
    });

    test('should throw error for negative increment', () {
      expect(
        () => counter.incrementBy(-5),
        throwsArgumentError,
      );
    });
  });
}
```

## Step 6: Testing Models with JSON

Let's test a data model with JSON serialization.

Create `lib/models/user.dart`:

```dart
class User {
  final String id;
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
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.age == age;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        age.hashCode;
  }
}
```

Create `test/models/user_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    late User user;

    setUp(() {
      user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        age: 30,
      );
    });

    test('should create user with all properties', () {
      expect(user.id, equals('123'));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.age, equals(30));
    });

    group('fromJson', () {
      test('should create user from valid JSON', () {
        final json = {
          'id': '456',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'age': 25,
        };

        final user = User.fromJson(json);

        expect(user.id, equals('456'));
        expect(user.name, equals('Jane Smith'));
        expect(user.email, equals('jane@example.com'));
        expect(user.age, equals(25));
      });

      test('should throw error for missing fields', () {
        final json = {
          'id': '789',
          'name': 'Bob',
          // Missing email and age
        };

        expect(
          () => User.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw error for wrong types', () {
        final json = {
          'id': '789',
          'name': 'Bob',
          'email': 'bob@example.com',
          'age': 'thirty',  // Should be int
        };

        expect(
          () => User.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('should convert user to JSON', () {
        final json = user.toJson();

        expect(json['id'], equals('123'));
        expect(json['name'], equals('John Doe'));
        expect(json['email'], equals('john@example.com'));
        expect(json['age'], equals(30));
      });

      test('should produce serializable JSON', () {
        final json = user.toJson();

        // All values should be primitives
        expect(json['id'], isA<String>());
        expect(json['name'], isA<String>());
        expect(json['email'], isA<String>());
        expect(json['age'], isA<int>());
      });
    });

    group('equality', () {
      test('should be equal to user with same values', () {
        final user2 = User(
          id: '123',
          name: 'John Doe',
          email: 'john@example.com',
          age: 30,
        );

        expect(user, equals(user2));
      });

      test('should not be equal to user with different id', () {
        final user2 = User(
          id: '999',
          name: 'John Doe',
          email: 'john@example.com',
          age: 30,
        );

        expect(user, isNot(equals(user2)));
      });
    });

    test('should round-trip through JSON', () {
      // Convert to JSON and back
      final json = user.toJson();
      final userFromJson = User.fromJson(json);

      // Should be equal to original
      expect(userFromJson, equals(user));
    });
  });
}
```

## Step 7: Testing Edge Cases

**Edge cases** are unusual situations your code might encounter. Always test them!

```dart
group('Edge Cases', () {
  test('empty string', () {
    expect(processText(''), isEmpty);
  });

  test('very long string', () {
    final longString = 'a' * 10000;
    expect(() => processText(longString), returnsNormally);
  });

  test('special characters', () {
    expect(processText('!@#\$%^&*()'), isNotEmpty);
  });

  test('null handling', () {
    expect(processText(null), equals('default'));
  });

  test('boundary values', () {
    expect(calculateAge(0), equals(0));
    expect(calculateAge(150), greaterThan(0));
  });

  test('concurrent modifications', () {
    final list = [1, 2, 3];
    // Test that modifying while iterating doesn't crash
    expect(() {
      for (var item in list) {
        if (item == 2) list.remove(item);
      }
    }, throwsConcurrentModificationError);
  });
});
```

## Step 8: Test Organization Best Practices

### 1. Mirror Directory Structure

```
lib/
├── models/
│   └── user.dart
├── services/
│   └── api_service.dart
└── utils/
    └── validator.dart

test/
├── models/
│   └── user_test.dart
├── services/
│   └── api_service_test.dart
└── utils/
    └── validator_test.dart
```

### 2. Use Descriptive Test Names

```dart
// ❌ Bad
test('test1', () { ... });
test('works', () { ... });

// ✅ Good
test('should return user when ID exists', () { ... });
test('should throw error when ID is invalid', () { ... });
```

### 3. One Assertion Per Test (Usually)

```dart
// ❌ Bad - testing too many things
test('user operations', () {
  expect(user.name, equals('John'));
  expect(user.age, greaterThan(18));
  expect(user.email, contains('@'));
  expect(user.isActive, isTrue);
});

// ✅ Good - focused tests
test('should have correct name', () {
  expect(user.name, equals('John'));
});

test('should be adult', () {
  expect(user.age, greaterThan(18));
});

test('should have valid email', () {
  expect(user.email, contains('@'));
});

test('should be active by default', () {
  expect(user.isActive, isTrue);
});
```

### 4. Use setUp and tearDown

```dart
group('Database Tests', () {
  late Database db;

  // Runs BEFORE each test
  setUp(() {
    db = Database();
    db.connect();
  });

  // Runs AFTER each test
  tearDown(() {
    db.disconnect();
    db.clearData();
  });

  test('should insert data', () {
    db.insert('key', 'value');
    expect(db.get('key'), equals('value'));
  });

  test('should delete data', () {
    db.insert('key', 'value');
    db.delete('key');
    expect(db.get('key'), isNull);
  });
});
```

### 5. Use setUpAll and tearDownAll for Expensive Setup

```dart
group('API Tests', () {
  // Runs ONCE before all tests in this group
  setUpAll(() {
    startMockServer();
  });

  // Runs ONCE after all tests in this group
  tearDownAll(() {
    stopMockServer();
  });

  test('test 1', () { ... });
  test('test 2', () { ... });
});
```

## Step 9: Running and Debugging Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/calculator_test.dart
```

### Run Tests with Name Pattern

```bash
# Run only tests containing "add"
flutter test --name add
```

### Run with Verbose Output

```bash
flutter test --reporter expanded
```

### Run with Coverage

```bash
flutter test --coverage
```

### Debug Tests in VS Code

1. Add breakpoint in test
2. Click "Debug" above `test()` function
3. Step through code

## Step 10: Test-Driven Development (TDD)

**TDD** means writing tests BEFORE writing code. Here's how:

### The Red-Green-Refactor Cycle

**Step 1: RED - Write a failing test**

```dart
test('should calculate circle area', () {
  final calculator = ShapeCalculator();
  expect(calculator.circleArea(5), equals(78.54));
});

// Test fails because circleArea doesn't exist yet ❌
```

**Step 2: GREEN - Write minimum code to pass**

```dart
class ShapeCalculator {
  double circleArea(double radius) {
    return 3.14159 * radius * radius;
  }
}

// Test passes ✅
```

**Step 3: REFACTOR - Improve code**

```dart
import 'dart:math';

class ShapeCalculator {
  double circleArea(double radius) {
    return pi * radius * radius;
  }
}

// Test still passes ✅
// Code is cleaner
```

### TDD Example: Building a Validator

**1. Write test first:**

```dart
test('should validate email format', () {
  final validator = EmailValidator();
  expect(validator.isValid('test@example.com'), isTrue);
});

// Fails - EmailValidator doesn't exist ❌
```

**2. Implement:**

```dart
class EmailValidator {
  bool isValid(String email) {
    return email.contains('@');
  }
}

// Passes ✅
```

**3. Add more tests:**

```dart
test('should reject email without @', () {
  expect(validator.isValid('notanemail'), isFalse);
});

test('should reject empty email', () {
  expect(validator.isValid(''), isFalse);
});

test('should validate complex email', () {
  expect(validator.isValid('user.name+tag@example.co.uk'), isTrue);
});
```

**4. Improve implementation:**

```dart
class EmailValidator {
  bool isValid(String email) {
    if (email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }
}
```

## Exercises

### Exercise 1: Test a Shopping Cart

Create a `ShoppingCart` class with tests:

```dart
class ShoppingCart {
  final List<CartItem> _items = [];

  void addItem(CartItem item) { }
  void removeItem(String productId) { }
  double getTotal() { }
  int getItemCount() { }
  void clear() { }
}
```

Write tests for:
- Adding items
- Removing items
- Calculating total
- Handling empty cart
- Duplicate items

### Exercise 2: Test a Temperature Converter

```dart
class TemperatureConverter {
  double celsiusToFahrenheit(double celsius) { }
  double fahrenheitToCelsius(double fahrenheit) { }
  double celsiusToKelvin(double celsius) { }
}
```

Test with:
- Normal values
- Zero
- Negative values
- Boundary values (absolute zero)

### Exercise 3: Test a Password Validator

```dart
class PasswordValidator {
  bool isStrong(String password) {
    // Must be at least 8 characters
    // Must contain uppercase, lowercase, number, special char
  }
}
```

Test various password combinations.

### Exercise 4: Test String Utilities

```dart
class StringUtils {
  bool isPalindrome(String text) { }
  String reverse(String text) { }
  int countVowels(String text) { }
  String capitalize(String text) { }
}
```

### Exercise 5: Use TDD to Build a Grade Calculator

Write tests first, then implement:

```dart
class GradeCalculator {
  String getLetterGrade(int score) {
    // 90-100: A
    // 80-89: B
    // 70-79: C
    // 60-69: D
    // 0-59: F
  }
}
```

## What You've Learned

✅ Why testing is critical for professional development
✅ How to structure tests (Arrange-Act-Assert)
✅ Writing unit tests with the `test` package
✅ Using matchers to check results
✅ Testing edge cases and error conditions
✅ Organizing tests with `group`, `setUp`, `tearDown`
✅ Test-Driven Development (TDD) workflow
✅ Best practices for maintainable tests

## Next Steps

In the next lesson, we'll cover:
- **Widget Testing** - Test your UI components
- **Finding widgets** with `find`
- **Interacting with widgets** (tap, enter text)
- **Testing widget state changes**
- **Golden tests** for visual regression

You're now ready to write production-quality code with confidence! 🎉
