# Test Coverage: Measuring and Improving Your Tests

## What You'll Learn

In this comprehensive lesson, you'll master:
- What test coverage is and why it matters
- Generating coverage reports in Flutter
- Reading and understanding coverage metrics
- Line coverage vs branch coverage
- Identifying untested code
- Strategies to improve coverage
- Coverage goals and when 100% isn't necessary
- Integrating coverage in CI/CD
- Coverage tools and visualizations

By the end, you'll know exactly how well your code is tested!

## Understanding Test Coverage (Super Simple)

### What is Test Coverage?

Imagine you wrote a book with 100 pages:
- You ask a friend to read it
- They only read 60 pages
- **Coverage = 60%** (they covered 60 out of 100 pages)

**Code coverage is the same!**
- You have 100 lines of code
- Your tests execute 60 lines
- **Coverage = 60%** (tests cover 60 out of 100 lines)

### Real Example

```dart
// calculator.dart - 10 lines of code
class Calculator {
  int add(int a, int b) {        // Line 1
    return a + b;                 // Line 2
  }                               // Line 3

  int subtract(int a, int b) {   // Line 4
    return a - b;                 // Line 5
  }                               // Line 6

  int multiply(int a, int b) {   // Line 7
    return a * b;                 // Line 8
  }                               // Line 9
}                                 // Line 10

// calculator_test.dart
test('add works', () {
  final calc = Calculator();
  expect(calc.add(2, 3), equals(5));
});

// Lines executed by test: 1, 2, 3 (creating calculator + calling add)
// Total lines: 10
// Coverage: 30%
```

**To get 100% coverage:**
```dart
test('add works', () {
  expect(calc.add(2, 3), equals(5));
});

test('subtract works', () {
  expect(calc.subtract(5, 3), equals(2));
});

test('multiply works', () {
  expect(calc.multiply(4, 5), equals(20));
});

// Now all 10 lines are executed!
// Coverage: 100% ✅
```

## Step 1: Generating Coverage Reports

### Enable Coverage

Run tests with coverage flag:

```bash
flutter test --coverage
```

This creates a file: `coverage/lcov.info`

### What's in lcov.info?

```
SF:lib/calculator.dart
DA:1,1
DA:2,1
DA:3,0
DA:4,0
DA:5,1
end_of_record
```

**Translation:**
- `SF` = Source File
- `DA:1,1` = Line 1 was executed 1 time
- `DA:3,0` = Line 3 was executed 0 times (NOT tested!)

## Step 2: Visualizing Coverage

### Install LCOV (for HTML reports)

**On macOS:**
```bash
brew install lcov
```

**On Ubuntu/Linux:**
```bash
sudo apt-get install lcov
```

**On Windows:**
Install using Chocolatey:
```bash
choco install lcov
```

### Generate HTML Report

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

You'll see a beautiful HTML report showing:
- ✅ Green = Tested code
- ❌ Red = Untested code
- 📊 Percentage for each file

## Step 3: Understanding Coverage Metrics

### Types of Coverage

#### 1. Line Coverage

**What it measures:** Which lines of code were executed

```dart
int abs(int number) {
  if (number < 0) {        // Line 1: Always executed
    return -number;        // Line 2: Only if number < 0
  }
  return number;           // Line 3: Only if number >= 0
}

// Test 1
test('abs of negative', () {
  expect(abs(-5), equals(5));
});

// Lines executed: 1, 2
// Coverage: 66% (2 out of 3 lines)
```

#### 2. Branch Coverage

**What it measures:** Which decision paths were taken

```dart
int abs(int number) {
  if (number < 0) {       // 2 branches: true or false
    return -number;
  }
  return number;
}

// Test 1: Tests "true" branch
test('abs of negative', () {
  expect(abs(-5), equals(5));
});

// Branch coverage: 50% (only tested negative numbers)

// Test 2: Tests "false" branch
test('abs of positive', () {
  expect(abs(5), equals(5));
});

// Now branch coverage: 100% ✅
```

#### 3. Function Coverage

**What it measures:** Which functions were called

```dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;
}

test('add works', () {
  expect(Calculator().add(2, 3), equals(5));
});

// Function coverage: 33% (1 out of 3 functions tested)
```

## Step 4: Example - Improving Coverage

Let's improve coverage for a real example.

### Create User Class

Create `lib/models/user.dart`:

```dart
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final bool isPremium;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.isPremium = false,
  });

  bool get isAdult {
    return age >= 18;
  }

  bool get isEligibleForDiscount {
    if (age >= 65) {
      return true;  // Senior discount
    }
    if (age < 18) {
      return true;  // Student discount
    }
    if (isPremium) {
      return true;  // Premium discount
    }
    return false;
  }

  String getGreeting() {
    if (isAdult) {
      return 'Hello, $name';
    } else {
      return 'Hi, $name';
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'isPremium': isPremium,
    };
  }
}
```

### Initial Tests (Low Coverage)

Create `test/models/user_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:my_app/models/user.dart';

void main() {
  group('User', () {
    test('creates user with all fields', () {
      final user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        age: 30,
      );

      expect(user.id, equals('123'));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.age, equals(30));
      expect(user.isPremium, isFalse);
    });
  });
}
```

### Check Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Result:** ~30% coverage (only tested basic constructor!)

### Improve Coverage - Add More Tests

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

    test('creates user with all fields', () {
      expect(user.id, equals('123'));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.age, equals(30));
      expect(user.isPremium, isFalse);
    });

    group('isAdult', () {
      test('returns true for adults', () {
        final adult = User(
          id: '1',
          name: 'Adult',
          email: 'adult@example.com',
          age: 18,
        );

        expect(adult.isAdult, isTrue);
      });

      test('returns false for minors', () {
        final child = User(
          id: '2',
          name: 'Child',
          email: 'child@example.com',
          age: 17,
        );

        expect(child.isAdult, isFalse);
      });
    });

    group('isEligibleForDiscount', () {
      test('returns true for seniors (65+)', () {
        final senior = User(
          id: '3',
          name: 'Senior',
          email: 'senior@example.com',
          age: 65,
        );

        expect(senior.isEligibleForDiscount, isTrue);
      });

      test('returns true for students (under 18)', () {
        final student = User(
          id: '4',
          name: 'Student',
          email: 'student@example.com',
          age: 16,
        );

        expect(student.isEligibleForDiscount, isTrue);
      });

      test('returns true for premium users', () {
        final premium = User(
          id: '5',
          name: 'Premium',
          email: 'premium@example.com',
          age: 30,
          isPremium: true,
        );

        expect(premium.isEligibleForDiscount, isTrue);
      });

      test('returns false for regular adult users', () {
        final regular = User(
          id: '6',
          name: 'Regular',
          email: 'regular@example.com',
          age: 30,
          isPremium: false,
        );

        expect(regular.isEligibleForDiscount, isFalse);
      });
    });

    group('getGreeting', () {
      test('returns "Hello" for adults', () {
        final adult = User(
          id: '7',
          name: 'Jane',
          email: 'jane@example.com',
          age: 25,
        );

        expect(adult.getGreeting(), equals('Hello, Jane'));
      });

      test('returns "Hi" for minors', () {
        final child = User(
          id: '8',
          name: 'Tommy',
          email: 'tommy@example.com',
          age: 12,
        );

        expect(child.getGreeting(), equals('Hi, Tommy'));
      });
    });

    group('JSON serialization', () {
      test('fromJson creates user from valid JSON', () {
        final json = {
          'id': '456',
          'name': 'Alice',
          'email': 'alice@example.com',
          'age': 28,
          'isPremium': true,
        };

        final user = User.fromJson(json);

        expect(user.id, equals('456'));
        expect(user.name, equals('Alice'));
        expect(user.email, equals('alice@example.com'));
        expect(user.age, equals(28));
        expect(user.isPremium, isTrue);
      });

      test('fromJson handles missing isPremium', () {
        final json = {
          'id': '789',
          'name': 'Bob',
          'email': 'bob@example.com',
          'age': 35,
        };

        final user = User.fromJson(json);

        expect(user.isPremium, isFalse);  // Defaults to false
      });

      test('toJson converts user to JSON', () {
        final json = user.toJson();

        expect(json['id'], equals('123'));
        expect(json['name'], equals('John Doe'));
        expect(json['email'], equals('john@example.com'));
        expect(json['age'], equals(30));
        expect(json['isPremium'], isFalse);
      });

      test('round-trip through JSON preserves data', () {
        final json = user.toJson();
        final userFromJson = User.fromJson(json);

        expect(userFromJson.id, equals(user.id));
        expect(userFromJson.name, equals(user.name));
        expect(userFromJson.email, equals(user.email));
        expect(userFromJson.age, equals(user.age));
        expect(userFromJson.isPremium, equals(user.isPremium));
      });
    });
  });
}
```

### Check Coverage Again

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Result:** ~100% coverage! ✅

## Step 5: Coverage Goals and Reality

### What's a Good Coverage Percentage?

**It depends on your project:**

- **70-80%**: Good for most projects
- **80-90%**: Great for critical applications
- **90-100%**: Excellent for libraries/packages
- **100%**: Nice goal, but not always practical

### When 100% Coverage Isn't Necessary

#### 1. Generated Code

```dart
// Auto-generated by json_serializable
// Don't need to test this!
User _$UserFromJson(Map<String, dynamic> json) { ... }
```

**Exclude from coverage:**

Create `coverage_config.yaml`:

```yaml
coverage:
  exclude:
    - "**/*.g.dart"  # Generated files
    - "**/*.freezed.dart"
    - "**/main.dart"  # Often just app entry point
```

#### 2. Simple Getters/Setters

```dart
class User {
  String name;

  String get displayName => name;  // Too simple to test
  set displayName(String value) => name = value;
}
```

#### 3. UI Layout Code

```dart
// Pure UI positioning - hard to test meaningfully
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Column(
      children: [...],
    ),
  );
}
```

#### 4. Error Logging

```dart
try {
  // ...
} catch (e) {
  print('Error: $e');  // Don't need test for this
  rethrow;
}
```

### Focus on Important Code

**High priority (must test):**
- ✅ Business logic
- ✅ Data transformations
- ✅ Validation
- ✅ Calculations
- ✅ API parsing
- ✅ Authentication
- ✅ State management

**Low priority (optional):**
- 🤷 Simple getters
- 🤷 UI layout
- 🤷 Print statements
- 🤷 Generated code

## Step 6: Finding Untested Code

### Use Coverage Report

1. Generate HTML report
2. Look for red lines (untested code)
3. Add tests for important red lines
4. Repeat until satisfied

### Example: Finding Gaps

```dart
class PaymentProcessor {
  double calculateTotal(List<Item> items, String discountCode) {
    double total = items.fold(0, (sum, item) => sum + item.price);

    // This code is RED in coverage (not tested)
    if (discountCode == 'SAVE20') {
      total *= 0.8;  // 20% off
    } else if (discountCode == 'SAVE50') {
      total *= 0.5;  // 50% off
    }

    return total;
  }
}

// Current test (incomplete)
test('calculates total', () {
  final items = [Item(price: 100), Item(price: 50)];
  final total = processor.calculateTotal(items, '');
  expect(total, equals(150));
});

// Coverage shows discount code branches are RED!
// Need to add:

test('applies SAVE20 discount', () {
  final items = [Item(price: 100)];
  final total = processor.calculateTotal(items, 'SAVE20');
  expect(total, equals(80));  // 20% off
});

test('applies SAVE50 discount', () {
  final items = [Item(price: 100)];
  final total = processor.calculateTotal(items, 'SAVE50');
  expect(total, equals(50));  // 50% off
});
```

## Step 7: Strategies to Improve Coverage

### 1. Test All Branches

```dart
// Code with 3 branches
String getStatus(int score) {
  if (score >= 90) return 'Excellent';
  if (score >= 70) return 'Good';
  return 'Needs Improvement';
}

// Test ALL branches
test('excellent score', () {
  expect(getStatus(95), equals('Excellent'));
});

test('good score', () {
  expect(getStatus(80), equals('Good'));
});

test('needs improvement', () {
  expect(getStatus(50), equals('Needs Improvement'));
});

// Test edge cases too!
test('exactly 90', () {
  expect(getStatus(90), equals('Excellent'));
});

test('exactly 70', () {
  expect(getStatus(70), equals('Good'));
});
```

### 2. Test Error Paths

```dart
Future<User> fetchUser(String id) async {
  if (id.isEmpty) {
    throw ArgumentError('ID cannot be empty');
  }

  try {
    final response = await http.get(url);
    return User.fromJson(jsonDecode(response.body));
  } catch (e) {
    throw Exception('Failed to fetch user');
  }
}

// Test success AND failure
test('fetches user successfully', () async {
  // Test happy path
});

test('throws error for empty ID', () {
  expect(() => fetchUser(''), throwsArgumentError);
});

test('throws error on network failure', () async {
  // Mock network error
  expect(() => fetchUser('123'), throwsException);
});
```

### 3. Test Edge Cases

```dart
// Test boundaries
test('minimum value', () {
  expect(validate(0), isTrue);
});

test('maximum value', () {
  expect(validate(100), isTrue);
});

test('just below minimum', () {
  expect(validate(-1), isFalse);
});

test('just above maximum', () {
  expect(validate(101), isFalse);
});

// Test empty/null
test('empty list', () {
  expect(process([]), isEmpty);
});

test('null value', () {
  expect(process(null), equals(defaultValue));
});

// Test special characters
test('special characters in name', () {
  expect(validate("O'Brien"), isTrue);
  expect(validate("José"), isTrue);
});
```

## Step 8: Excluding Files from Coverage

### Create `test/coverage_helper_test.dart`:

```dart
// Ignore this file in test results
@Tags(['no-ci'])

import 'package:my_app/models/user.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/widgets/custom_button.dart';
// Import all files you want in coverage

void main() {
  // This file doesn't run tests
  // It just imports files to include in coverage
}
```

### Update Package Configuration

Add to `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/generated/**"
```

## Step 9: CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests with coverage
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | sed 's/%//')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage is below 80%: $COVERAGE%"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info
```

### Codecov Badge

Add to `README.md`:

```markdown
[![codecov](https://codecov.io/gh/username/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/username/repo)
```

## Step 10: Coverage Tools

### 1. VS Code Extension

Install "Coverage Gutters" extension:
- Shows coverage in editor
- Green gutter = tested
- Red gutter = not tested
- Run command: "Coverage Gutters: Display Coverage"

### 2. LCOV Viewer (Online)

Upload `lcov.info` to online viewers:
- [https://htmlpreview.github.io/](https://htmlpreview.github.io/)
- Visualize coverage without installing anything

### 3. Coverage Diff

See coverage changes between commits:

```bash
# Save baseline coverage
flutter test --coverage
cp coverage/lcov.info coverage/baseline.lcov

# Make changes...

# Generate new coverage
flutter test --coverage

# Compare
lcov --diff coverage/baseline.lcov coverage/lcov.info -o coverage/diff.info
```

## Exercises

### Exercise 1: Achieve 90% Coverage
Create a `StringUtils` class with these methods:
- `isPalindrome(String text)`
- `reverse(String text)`
- `countVowels(String text)`
- `capitalize(String text)`
- `truncate(String text, int maxLength)`

Write tests to achieve 90%+ coverage.

### Exercise 2: Find and Fix Coverage Gaps
Given this code, write tests to achieve 100% coverage:

```dart
class Calculator {
  double calculate(double a, double b, String operator) {
    switch (operator) {
      case '+': return a + b;
      case '-': return a - b;
      case '*': return a * b;
      case '/':
        if (b == 0) throw ArgumentError('Division by zero');
        return a / b;
      default:
        throw ArgumentError('Unknown operator: $operator');
    }
  }
}
```

### Exercise 3: Test Error Paths
Write tests for all error scenarios in this validation code:

```dart
class Validator {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@')) {
      return 'Invalid email format';
    }
    if (email.length < 5) {
      return 'Email too short';
    }
    final parts = email.split('@');
    if (parts[1].length < 3) {
      return 'Invalid domain';
    }
    return null;  // Valid
  }
}
```

### Exercise 4: Improve Real Code Coverage
Take your Weather App from earlier lessons and:
1. Generate coverage report
2. Identify untested code
3. Write tests to improve coverage to 80%+

### Exercise 5: Set Up CI/CD
Create a GitHub Actions workflow that:
1. Runs tests on every push
2. Generates coverage report
3. Fails if coverage drops below 75%
4. Uploads coverage to Codecov

## What You've Learned

✅ What test coverage is and how to measure it
✅ Generating and visualizing coverage reports
✅ Understanding line coverage, branch coverage, function coverage
✅ Strategies to improve coverage
✅ When 100% coverage isn't necessary
✅ Finding and fixing coverage gaps
✅ Excluding files from coverage
✅ Integrating coverage in CI/CD
✅ Using coverage tools and extensions

## Summary: Complete Testing Mastery

You've now learned:
1. **Unit Testing** - Testing individual functions and classes
2. **Widget Testing** - Testing UI components
3. **Integration Testing** - Testing complete app flows
4. **Mocking** - Simulating dependencies
5. **Test Coverage** - Measuring test quality

**You're now a testing expert!** 🎉

## Next Phase

In Phase 7, we'll dive deep into:
- **Advanced Async Programming**
- Streams and StreamControllers
- Futures vs Streams
- Isolates for parallel processing
- Complex async patterns

Ready to level up! 🚀
