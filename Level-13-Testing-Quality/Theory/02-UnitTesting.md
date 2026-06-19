# Unit Testing

## The Big Idea In One Sentence

> A unit test checks one small piece of logic in isolation: call a function, `expect` a result, with no UI involved, grouped with `test()` (and `group()`).

## The Simple Explanation

Unit testing is like checking if each ingredient is good before cooking. You test small pieces individually to make sure they work!

```
┌─────────────────────────────────────────────────────────┐
│                    UNIT TESTING                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Test ONE thing at a time:                               │
│                                                          │
│    ┌───────────┐                                        │
│    │ Function  │                                        │
│    │  add(a,b) │  ← Test this alone                     │
│    └───────────┘                                        │
│                                                          │
│    Input: 2, 3                                          │
│    Expected Output: 5                                    │
│    Actual Output: 5                                      │
│    Result: ✓ PASS                                       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Basic Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('description of what we are testing', () {
    // Arrange - Set up test data
    final a = 2;
    final b = 3;

    // Act - Call the function
    final result = add(a, b);

    // Assert - Check the result
    expect(result, equals(5));
  });
}
```

---

## The AAA Pattern

```
ARRANGE → ACT → ASSERT

┌─────────────────────────────────────────────────────────┐
│                                                          │
│  ARRANGE (Given)                                         │
│  └── Set up the test data and conditions                │
│                                                          │
│  ACT (When)                                              │
│  └── Call the function or method being tested           │
│                                                          │
│  ASSERT (Then)                                           │
│  └── Check that the result is what we expected          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Example

```dart
test('calculates total with tax', () {
  // ARRANGE
  final price = 100.0;
  final taxRate = 0.1;

  // ACT
  final total = calculateTotalWithTax(price, taxRate);

  // ASSERT
  expect(total, 110.0);
});
```

---

## Common Matchers

```dart
// Equality
expect(result, equals(5));
expect(result, 5);  // Same as equals

// Comparison
expect(result, greaterThan(5));
expect(result, lessThan(10));
expect(result, greaterThanOrEqualTo(5));
expect(result, lessThanOrEqualTo(10));
expect(result, inInclusiveRange(5, 10));

// Boolean
expect(result, isTrue);
expect(result, isFalse);

// Null
expect(result, isNull);
expect(result, isNotNull);

// Type
expect(result, isA<String>());
expect(result, isA<int>());

// String
expect(text, contains('hello'));
expect(text, startsWith('Hi'));
expect(text, endsWith('!'));
expect(text, matches(RegExp(r'\d+')));

// Collections
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(5));
expect(list, contains('item'));
expect(list, containsAll(['a', 'b']));
expect(list, orderedEquals(['a', 'b', 'c']));

// Exceptions
expect(() => dangerousFunction(), throwsException);
expect(() => divideByZero(), throwsA(isA<ArgumentError>()));
```

---

## Grouping Tests

```dart
void main() {
  group('Calculator', () {
    test('adds two numbers', () {
      expect(add(2, 3), 5);
    });

    test('subtracts two numbers', () {
      expect(subtract(5, 3), 2);
    });

    test('multiplies two numbers', () {
      expect(multiply(3, 4), 12);
    });

    group('division', () {
      test('divides two numbers', () {
        expect(divide(10, 2), 5);
      });

      test('throws error when dividing by zero', () {
        expect(() => divide(10, 0), throwsArgumentError);
      });
    });
  });
}
```

---

## Setup and Teardown

```dart
void main() {
  late Calculator calculator;

  // Runs once before ALL tests in this group
  setUpAll(() {
    print('Setting up all tests');
  });

  // Runs before EACH test
  setUp(() {
    calculator = Calculator();
  });

  // Runs after EACH test
  tearDown(() {
    calculator.dispose();
  });

  // Runs once after ALL tests
  tearDownAll(() {
    print('All tests complete');
  });

  test('adds numbers', () {
    expect(calculator.add(2, 3), 5);
  });

  test('subtracts numbers', () {
    expect(calculator.subtract(5, 3), 2);
  });
}
```

---

## Testing a Model Class

```dart
// lib/models/user.dart
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

  bool get isAdult => age >= 18;

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

```dart
// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    late User user;

    setUp(() {
      user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        age: 25,
      );
    });

    test('creates user with correct properties', () {
      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.age, 25);
    });

    group('isAdult', () {
      test('returns true for age >= 18', () {
        final adult = User(id: '1', name: 'Adult', email: 'a@b.c', age: 18);
        expect(adult.isAdult, isTrue);
      });

      test('returns false for age < 18', () {
        final child = User(id: '1', name: 'Child', email: 'c@d.e', age: 17);
        expect(child.isAdult, isFalse);
      });
    });

    group('fromJson', () {
      test('creates user from valid JSON', () {
        final json = {
          'id': '456',
          'name': 'Jane',
          'email': 'jane@test.com',
          'age': 30,
        };

        final user = User.fromJson(json);

        expect(user.id, '456');
        expect(user.name, 'Jane');
        expect(user.email, 'jane@test.com');
        expect(user.age, 30);
      });
    });

    group('toJson', () {
      test('converts user to JSON', () {
        final json = user.toJson();

        expect(json['id'], '123');
        expect(json['name'], 'John Doe');
        expect(json['email'], 'john@example.com');
        expect(json['age'], 25);
      });
    });
  });
}
```

---

## Testing a Service Class

```dart
// lib/services/validator_service.dart
class ValidatorService {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@')) {
      return 'Invalid email format';
    }
    if (!email.contains('.')) {
      return 'Invalid email format';
    }
    return null; // Valid
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null; // Valid
  }
}
```

```dart
// test/services/validator_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/validator_service.dart';

void main() {
  late ValidatorService validator;

  setUp(() {
    validator = ValidatorService();
  });

  group('validateEmail', () {
    test('returns error for null email', () {
      expect(validator.validateEmail(null), 'Email is required');
    });

    test('returns error for empty email', () {
      expect(validator.validateEmail(''), 'Email is required');
    });

    test('returns error for email without @', () {
      expect(validator.validateEmail('invalid'), 'Invalid email format');
    });

    test('returns error for email without .', () {
      expect(validator.validateEmail('user@domain'), 'Invalid email format');
    });

    test('returns null for valid email', () {
      expect(validator.validateEmail('user@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('returns error for null password', () {
      expect(validator.validatePassword(null), 'Password is required');
    });

    test('returns error for empty password', () {
      expect(validator.validatePassword(''), 'Password is required');
    });

    test('returns error for short password', () {
      expect(
        validator.validatePassword('Short1'),
        'Password must be at least 8 characters',
      );
    });

    test('returns error for password without uppercase', () {
      expect(
        validator.validatePassword('lowercase123'),
        'Password must contain an uppercase letter',
      );
    });

    test('returns error for password without number', () {
      expect(
        validator.validatePassword('NoNumbers'),
        'Password must contain a number',
      );
    });

    test('returns null for valid password', () {
      expect(validator.validatePassword('ValidPass123'), isNull);
    });
  });
}
```

---

## Async Testing

```dart
// Testing async functions
test('fetches user data', () async {
  final service = UserService();

  final user = await service.fetchUser('123');

  expect(user.id, '123');
  expect(user.name, isNotEmpty);
});

// Testing with timeout
test('completes within timeout', () async {
  final result = await slowOperation();
  expect(result, isNotNull);
}, timeout: Timeout(Duration(seconds: 5)));
```

---

## Testing Exceptions

```dart
test('throws exception for invalid input', () {
  expect(
    () => divide(10, 0),
    throwsA(isA<ArgumentError>()),
  );
});

test('throws exception with specific message', () {
  expect(
    () => divide(10, 0),
    throwsA(
      predicate<ArgumentError>(
        (e) => e.message == 'Cannot divide by zero',
      ),
    ),
  );
});
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/models/user_test.dart

# Run tests matching pattern
flutter test --name "validateEmail"

# Run with verbose output
flutter test --reporter expanded

# Run with coverage
flutter test --coverage
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              UNIT TESTING SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  STRUCTURE:                                              │
│  test('description', () {                               │
│    // Arrange                                            │
│    // Act                                                │
│    // Assert                                             │
│  });                                                     │
│                                                          │
│  COMMON MATCHERS:                                        │
│  ├── equals(value)                                      │
│  ├── isTrue / isFalse                                   │
│  ├── isNull / isNotNull                                 │
│  ├── throwsException                                    │
│  └── contains / hasLength                               │
│                                                          │
│  ORGANIZATION:                                           │
│  ├── group() - Group related tests                      │
│  ├── setUp() - Before each test                         │
│  └── tearDown() - After each test                       │
│                                                          │
│  COMMANDS:                                               │
│  flutter test                                            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does a unit test test, and what does it NOT involve?

<details>
<summary>Answer</summary>
It tests one piece of logic (a function/class). It does not involve the UI/widgets.
</details>

**Q2.** What do `test()` and `expect()` each do?

<details>
<summary>Answer</summary>
`test('name', () { ... })` defines a single test; `expect(actual, expected)` checks the result inside it.
</details>

**Q3.** What is `group()` for?

<details>
<summary>Answer</summary>
To bundle related tests under one name, keeping the output organized.
</details>

---

## Assignment

### Problem 1: Write a unit test

For `bool isEven(int n) => n % 2 == 0;`, write a test that checks `isEven(4)` is `true`.

### Problem 2: Add a case

Write a second `expect` (in the same test) checking `isEven(3)` is `false`.

### Problem 3: Group them

What would you wrap multiple `isEven` tests in to organize them?

---

## Assignment Answers

### Problem 1: Write a unit test

```dart
test('isEven returns true for even numbers', () {
  expect(isEven(4), true);
});
```

### Problem 2: Add a case

```dart
expect(isEven(3), false);
```

### Problem 3: Group them

A `group('isEven', () { ... })` block containing the related tests.

---

**Next:** `03-WidgetTesting.md` - Testing UI components
