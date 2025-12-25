# Level 13: Testing & Quality Exercises

## Exercise Overview

Practice what you've learned about testing! Start with simple unit tests and work your way up to integration tests.

```
DIFFICULTY LEVELS:
🟢 Beginner     - Basic concepts
🟡 Intermediate - Multiple concepts
🔴 Advanced     - Complex scenarios
```

---

## 🟢 Exercise 1: Basic Unit Tests

### Your Task
Write unit tests for this `StringHelper` class:

```dart
class StringHelper {
  // Capitalizes the first letter of a string
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Counts words in a string
  int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  // Reverses a string
  String reverse(String text) {
    return text.split('').reversed.join('');
  }

  // Checks if string is a palindrome
  bool isPalindrome(String text) {
    final cleaned = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }
}
```

### Write Tests For:
- [ ] `capitalize` with normal string
- [ ] `capitalize` with empty string
- [ ] `capitalize` with already capitalized string
- [ ] `countWords` with multiple words
- [ ] `countWords` with empty string
- [ ] `countWords` with extra spaces
- [ ] `reverse` with normal string
- [ ] `isPalindrome` with "racecar"
- [ ] `isPalindrome` with "A man a plan a canal Panama"
- [ ] `isPalindrome` with non-palindrome

### Hints
```dart
// Test file: test/string_helper_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  late StringHelper helper;

  setUp(() {
    helper = StringHelper();
  });

  group('capitalize', () {
    test('capitalizes first letter of word', () {
      expect(helper.capitalize('hello'), equals('Hello'));
    });

    // Add more tests...
  });
}
```

---

## 🟢 Exercise 2: Testing a Model

### Your Task
Write comprehensive tests for this `Product` model:

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final int stockQuantity;
  final double? discountPercent;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
    this.discountPercent,
  });

  bool get isInStock => stockQuantity > 0;

  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;

  bool get hasDiscount => discountPercent != null && discountPercent! > 0;

  double get finalPrice {
    if (!hasDiscount) return price;
    return price * (1 - discountPercent! / 100);
  }

  double get savings {
    if (!hasDiscount) return 0;
    return price - finalPrice;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'],
      discountPercent: json['discount_percent']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock_quantity': stockQuantity,
      'discount_percent': discountPercent,
    };
  }
}
```

### Test Scenarios:
- [ ] Product creation with all fields
- [ ] `isInStock` returns true when quantity > 0
- [ ] `isInStock` returns false when quantity is 0
- [ ] `isLowStock` for quantities 1-5
- [ ] `isLowStock` is false for quantity 0 and > 5
- [ ] `hasDiscount` with and without discount
- [ ] `finalPrice` with 20% discount
- [ ] `finalPrice` with no discount
- [ ] `savings` calculation
- [ ] `fromJson` parsing
- [ ] `toJson` serialization

---

## 🟡 Exercise 3: Testing a Service

### Your Task
Write tests for this `AuthService` class, including testing exceptions:

```dart
class AuthService {
  final Map<String, String> _users = {
    'alice@test.com': 'password123',
    'bob@test.com': 'securepass456',
  };

  String? _currentUser;

  String? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    if (_users[email] == password) {
      _currentUser = email;
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Invalid email');
    }
    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters');
    }
    if (_users.containsKey(email)) {
      throw StateError('User already exists');
    }

    _users[email] = password;
    _currentUser = email;
    return true;
  }
}
```

### Test Scenarios:
- [ ] Successful login with valid credentials
- [ ] Failed login with wrong password
- [ ] Login throws error for empty email
- [ ] Login throws error for empty password
- [ ] `isLoggedIn` is true after login
- [ ] `currentUser` returns email after login
- [ ] `logout` clears current user
- [ ] Register with valid email and password
- [ ] Register throws for invalid email
- [ ] Register throws for short password
- [ ] Register throws for existing user

### Hints for Async Tests
```dart
test('login succeeds with valid credentials', () async {
  final result = await authService.login('alice@test.com', 'password123');
  expect(result, isTrue);
});

test('login throws for empty email', () {
  expect(
    () => authService.login('', 'password'),
    throwsA(isA<ArgumentError>()),
  );
});
```

---

## 🟡 Exercise 4: Widget Tests

### Your Task
Write widget tests for this `RatingWidget`:

```dart
class RatingWidget extends StatefulWidget {
  final int maxRating;
  final int initialRating;
  final Function(int)? onRatingChanged;

  const RatingWidget({
    super.key,
    this.maxRating = 5,
    this.initialRating = 0,
    this.onRatingChanged,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _setRating(int rating) {
    setState(() => _currentRating = rating);
    widget.onRatingChanged?.call(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final starNumber = index + 1;
        return IconButton(
          key: Key('star_$starNumber'),
          icon: Icon(
            starNumber <= _currentRating
                ? Icons.star
                : Icons.star_border,
            color: starNumber <= _currentRating
                ? Colors.amber
                : Colors.grey,
          ),
          onPressed: () => _setRating(starNumber),
        );
      }),
    );
  }
}
```

### Test Scenarios:
- [ ] Displays correct number of stars (default 5)
- [ ] Displays custom max rating (e.g., 10 stars)
- [ ] Shows initial rating filled
- [ ] Tapping star updates rating
- [ ] Calls onRatingChanged callback
- [ ] Stars below rating are filled
- [ ] Stars above rating are empty

### Widget Test Template
```dart
testWidgets('displays 5 stars by default', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: RatingWidget(),
      ),
    ),
  );

  // Find all stars
  expect(find.byType(IconButton), findsNWidgets(5));
});
```

---

## 🟡 Exercise 5: Form Widget Tests

### Your Task
Write tests for this `ContactForm`:

```dart
class ContactForm extends StatefulWidget {
  final Function(String name, String email, String message)? onSubmit;

  const ContactForm({super.key, this.onSubmit});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name too short';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) return 'Message is required';
    if (value.length < 10) return 'Message too short (min 10 chars)';
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit?.call(
        _nameController.text,
        _emailController.text,
        _messageController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('name_field'),
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: _validateName,
          ),
          TextFormField(
            key: const Key('email_field'),
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: _validateEmail,
          ),
          TextFormField(
            key: const Key('message_field'),
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Message'),
            validator: _validateMessage,
            maxLines: 3,
          ),
          ElevatedButton(
            key: const Key('submit_button'),
            onPressed: _submit,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
```

### Test Scenarios:
- [ ] All form fields are visible
- [ ] Name validation shows error when empty
- [ ] Name validation shows error when too short
- [ ] Email validation shows error when empty
- [ ] Email validation shows error for invalid email
- [ ] Message validation shows error when empty
- [ ] Message validation shows error when too short
- [ ] Form submits with valid data
- [ ] onSubmit receives correct values

---

## 🔴 Exercise 6: Mocking Dependencies

### Your Task
Create a mock for this `WeatherService` and test the `WeatherScreen`:

```dart
// Abstract class to mock
abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
}

class Weather {
  final String city;
  final double temperature;
  final String condition;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
  });
}

// Widget that uses the repository
class WeatherScreen extends StatefulWidget {
  final WeatherRepository repository;
  final String city;

  const WeatherScreen({
    super.key,
    required this.repository,
    required this.city,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? _weather;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await widget.repository.getWeather(widget.city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('loading')),
      );
    }

    if (_error != null) {
      return Center(
        child: Text('Error: $_error', key: const Key('error')),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_weather!.city, key: const Key('city')),
          Text('${_weather!.temperature}°C', key: const Key('temp')),
          Text(_weather!.condition, key: const Key('condition')),
        ],
      ),
    );
  }
}
```

### Create Mock and Test:
```dart
// Create a mock implementation
class MockWeatherRepository implements WeatherRepository {
  Weather? weatherToReturn;
  Exception? exceptionToThrow;

  @override
  Future<Weather> getWeather(String city) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return weatherToReturn!;
  }
}
```

### Test Scenarios:
- [ ] Shows loading indicator initially
- [ ] Displays weather data after loading
- [ ] Shows error message on failure
- [ ] Displays correct city name
- [ ] Displays temperature
- [ ] Displays weather condition

---

## 🔴 Exercise 7: Integration Test Challenge

### Your Task
Write integration tests for a Notes app with these screens:

1. **Notes List Screen** - Shows all notes
2. **Add Note Screen** - Form to add new note
3. **Note Detail Screen** - Shows note content

### Test These User Journeys:
- [ ] App starts with empty state
- [ ] User can add a new note
- [ ] Note appears in list after adding
- [ ] User can tap note to see details
- [ ] User can delete a note
- [ ] Multiple notes can be added
- [ ] User can edit a note (bonus)

### Integration Test Structure:
```dart
// integration_test/notes_app_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notes App', () {
    testWidgets('complete user journey', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Verify empty state
      // ...

      // 2. Add first note
      // ...

      // 3. Verify note in list
      // ...

      // 4. View note details
      // ...

      // 5. Delete note
      // ...
    });
  });
}
```

---

## 🔴 Exercise 8: Test-Driven Development (TDD)

### Your Challenge
Use TDD to build a `ShoppingCart` class from scratch.

### Requirements:
1. Can add items to cart
2. Can remove items from cart
3. Can update item quantity
4. Calculates subtotal
5. Applies discount codes
6. Calculates tax
7. Calculates final total

### TDD Process:
```
1. Write a failing test
2. Write minimum code to pass
3. Refactor
4. Repeat!
```

### Start with this test:
```dart
void main() {
  group('ShoppingCart', () {
    test('starts with zero items', () {
      final cart = ShoppingCart();
      expect(cart.itemCount, equals(0));
    });

    // Now implement ShoppingCart to pass this test
    // Then write the next test!
  });
}
```

### Tests to Write (in order):
1. Cart starts empty (itemCount = 0)
2. Can add an item
3. Item count increases when adding
4. Can add multiple items
5. Subtotal is sum of item prices
6. Can remove an item
7. Can update quantity
8. Applying discount reduces total
9. Tax is calculated on discounted price
10. Final total = subtotal - discount + tax

---

## Solutions Checklist

After completing each exercise, verify:

```
UNIT TESTS:
✓ Tests are organized with group()
✓ Each test has a clear description
✓ AAA pattern is followed (Arrange, Act, Assert)
✓ Edge cases are covered
✓ Exceptions are tested where appropriate

WIDGET TESTS:
✓ Widgets wrapped in MaterialApp
✓ Keys used for finding widgets
✓ pumpAndSettle() used after interactions
✓ Both visual and interactive elements tested

INTEGRATION TESTS:
✓ IntegrationTestWidgetsFlutterBinding initialized
✓ Full user flows tested
✓ Navigation tested
✓ State persists correctly across screens
```

---

## Running Your Tests

```bash
# Run all unit/widget tests
flutter test

# Run specific test file
flutter test test/string_helper_test.dart

# Run with coverage report
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run with verbose output
flutter test --reporter expanded
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                 TESTING EXERCISES COMPLETE                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SKILLS PRACTICED:                                           │
│  ✓ Writing unit tests for functions and classes             │
│  ✓ Testing models with JSON serialization                   │
│  ✓ Testing async services                                   │
│  ✓ Testing exceptions                                        │
│  ✓ Writing widget tests                                      │
│  ✓ Testing form validation                                   │
│  ✓ Mocking dependencies                                      │
│  ✓ Writing integration tests                                 │
│  ✓ Test-Driven Development (TDD)                            │
│                                                              │
│  TESTING PYRAMID APPLIED:                                    │
│  └── Many unit tests (Exercises 1-3)                        │
│  └── Some widget tests (Exercises 4-6)                      │
│  └── Few integration tests (Exercise 7)                     │
│                                                              │
│  KEY TAKEAWAYS:                                              │
│  • Start with unit tests - they're fast and focused         │
│  • Use widget tests for UI components                       │
│  • Save integration tests for critical user flows           │
│  • TDD helps design better code                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Great job!** Testing is a skill that improves with practice. The more you write tests, the better your code becomes!
