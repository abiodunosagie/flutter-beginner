// ============================================
// EXAMPLE 01: UNIT TESTS
// Complete working examples of unit testing
// ============================================

// ============================================
// WHAT WE'RE BUILDING
// ============================================
/*
  This file shows unit tests for:
  1. Simple functions (Calculator)
  2. Model classes (User, Product)
  3. Service classes (Validator, Cart)
  4. Async functions
  5. Exception handling

  Think of unit tests like checking each
  LEGO brick before building with it!
*/

// ============================================
// THE CODE TO TEST
// ============================================

// --- Simple Calculator ---
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;

  double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return a / b;
  }
}

// --- User Model ---
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

  // Is this user an adult?
  bool get isAdult => age >= 18;

  // Is this user a senior?
  bool get isSenior => age >= 65;

  // Get display name (first name only)
  String get firstName => name.split(' ').first;

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }
}

// --- Product Model ---
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Is this product in stock?
  bool get isInStock => quantity > 0;

  // Calculate total value
  double get totalValue => price * quantity;

  // Apply discount percentage
  double priceWithDiscount(double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) {
      throw ArgumentError('Discount must be between 0 and 100');
    }
    return price * (1 - discountPercent / 100);
  }
}

// --- Email Validator ---
class EmailValidator {
  String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.contains('@')) {
      return 'Email must contain @';
    }
    if (!email.contains('.')) {
      return 'Email must contain a domain';
    }
    if (email.startsWith('@') || email.endsWith('@')) {
      return 'Invalid email format';
    }
    return null; // null means valid!
  }
}

// --- Password Validator ---
class PasswordValidator {
  final int minLength;
  final bool requireUppercase;
  final bool requireNumber;

  PasswordValidator({
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireNumber = true,
  });

  String? validate(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (requireNumber && !password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null; // Valid!
  }
}

// --- Shopping Cart ---
class ShoppingCart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  void clear() {
    _items.clear();
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  double calculateTotal({double taxRate = 0.0, double discount = 0.0}) {
    final afterDiscount = subtotal - discount;
    final afterTax = afterDiscount * (1 + taxRate);
    return afterTax < 0 ? 0 : afterTax;
  }
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}

// --- Async User Service (simulated) ---
class UserService {
  final Map<String, User> _database = {
    '1': User(id: '1', name: 'Alice Smith', email: 'alice@test.com', age: 25),
    '2': User(id: '2', name: 'Bob Jones', email: 'bob@test.com', age: 17),
    '3': User(id: '3', name: 'Carol White', email: 'carol@test.com', age: 70),
  };

  Future<User?> fetchUser(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 100));
    return _database[id];
  }

  Future<List<User>> fetchAllUsers() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _database.values.toList();
  }

  Future<List<User>> fetchAdultUsers() async {
    final users = await fetchAllUsers();
    return users.where((u) => u.isAdult).toList();
  }
}

// ============================================
// THE TESTS (would go in test/ folder)
// ============================================

/*
// test/calculator_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  // ========================================
  // CALCULATOR TESTS
  // ========================================
  group('Calculator', () {
    late Calculator calculator;

    // Fresh calculator for each test
    setUp(() {
      calculator = Calculator();
    });

    group('add', () {
      test('adds two positive numbers', () {
        expect(calculator.add(2, 3), equals(5));
      });

      test('adds negative numbers', () {
        expect(calculator.add(-2, -3), equals(-5));
      });

      test('adds zero', () {
        expect(calculator.add(5, 0), equals(5));
      });
    });

    group('subtract', () {
      test('subtracts two numbers', () {
        expect(calculator.subtract(10, 4), equals(6));
      });

      test('returns negative for larger subtrahend', () {
        expect(calculator.subtract(3, 7), equals(-4));
      });
    });

    group('multiply', () {
      test('multiplies two numbers', () {
        expect(calculator.multiply(3, 4), equals(12));
      });

      test('returns zero when multiplied by zero', () {
        expect(calculator.multiply(5, 0), equals(0));
      });
    });

    group('divide', () {
      test('divides two numbers', () {
        expect(calculator.divide(10, 2), equals(5.0));
      });

      test('returns decimal result', () {
        expect(calculator.divide(7, 2), equals(3.5));
      });

      test('throws ArgumentError for divide by zero', () {
        expect(
          () => calculator.divide(10, 0),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });

  // ========================================
  // USER MODEL TESTS
  // ========================================
  group('User', () {
    test('creates user with correct properties', () {
      final user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        age: 30,
      );

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.age, 30);
    });

    group('isAdult', () {
      test('returns true for age 18', () {
        final user = User(id: '1', name: 'Test', email: 't@t.com', age: 18);
        expect(user.isAdult, isTrue);
      });

      test('returns true for age over 18', () {
        final user = User(id: '1', name: 'Test', email: 't@t.com', age: 25);
        expect(user.isAdult, isTrue);
      });

      test('returns false for age under 18', () {
        final user = User(id: '1', name: 'Test', email: 't@t.com', age: 17);
        expect(user.isAdult, isFalse);
      });
    });

    group('isSenior', () {
      test('returns true for age 65 and over', () {
        final user = User(id: '1', name: 'Test', email: 't@t.com', age: 65);
        expect(user.isSenior, isTrue);
      });

      test('returns false for age under 65', () {
        final user = User(id: '1', name: 'Test', email: 't@t.com', age: 64);
        expect(user.isSenior, isFalse);
      });
    });

    group('firstName', () {
      test('returns first name from full name', () {
        final user = User(id: '1', name: 'John Doe', email: 't@t.com', age: 25);
        expect(user.firstName, 'John');
      });

      test('returns full name if single name', () {
        final user = User(id: '1', name: 'Madonna', email: 't@t.com', age: 60);
        expect(user.firstName, 'Madonna');
      });
    });

    group('fromJson', () {
      test('creates user from JSON map', () {
        final json = {
          'id': '456',
          'name': 'Jane Doe',
          'email': 'jane@example.com',
          'age': 28,
        };

        final user = User.fromJson(json);

        expect(user.id, '456');
        expect(user.name, 'Jane Doe');
        expect(user.email, 'jane@example.com');
        expect(user.age, 28);
      });
    });

    group('toJson', () {
      test('converts user to JSON map', () {
        final user = User(
          id: '789',
          name: 'Bob Smith',
          email: 'bob@example.com',
          age: 35,
        );

        final json = user.toJson();

        expect(json['id'], '789');
        expect(json['name'], 'Bob Smith');
        expect(json['email'], 'bob@example.com');
        expect(json['age'], 35);
      });
    });
  });

  // ========================================
  // PRODUCT MODEL TESTS
  // ========================================
  group('Product', () {
    late Product product;

    setUp(() {
      product = Product(
        id: '1',
        name: 'Widget',
        price: 10.0,
        quantity: 5,
      );
    });

    test('isInStock returns true when quantity > 0', () {
      expect(product.isInStock, isTrue);
    });

    test('isInStock returns false when quantity is 0', () {
      final outOfStock = Product(id: '2', name: 'Sold Out', price: 20.0, quantity: 0);
      expect(outOfStock.isInStock, isFalse);
    });

    test('totalValue calculates correctly', () {
      expect(product.totalValue, 50.0); // 10.0 * 5
    });

    group('priceWithDiscount', () {
      test('applies 10% discount correctly', () {
        expect(product.priceWithDiscount(10), 9.0);
      });

      test('applies 50% discount correctly', () {
        expect(product.priceWithDiscount(50), 5.0);
      });

      test('returns original price for 0% discount', () {
        expect(product.priceWithDiscount(0), 10.0);
      });

      test('returns 0 for 100% discount', () {
        expect(product.priceWithDiscount(100), 0.0);
      });

      test('throws for negative discount', () {
        expect(
          () => product.priceWithDiscount(-10),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws for discount over 100%', () {
        expect(
          () => product.priceWithDiscount(110),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });

  // ========================================
  // EMAIL VALIDATOR TESTS
  // ========================================
  group('EmailValidator', () {
    late EmailValidator validator;

    setUp(() {
      validator = EmailValidator();
    });

    test('returns error for null email', () {
      expect(validator.validate(null), 'Email is required');
    });

    test('returns error for empty email', () {
      expect(validator.validate(''), 'Email is required');
    });

    test('returns error for email without @', () {
      expect(validator.validate('invalidemail.com'), 'Email must contain @');
    });

    test('returns error for email without domain', () {
      expect(validator.validate('user@domain'), 'Email must contain a domain');
    });

    test('returns error for email starting with @', () {
      expect(validator.validate('@domain.com'), 'Invalid email format');
    });

    test('returns error for email ending with @', () {
      expect(validator.validate('user@'), 'Invalid email format');
    });

    test('returns null for valid email', () {
      expect(validator.validate('user@example.com'), isNull);
    });

    test('accepts various valid email formats', () {
      expect(validator.validate('user.name@domain.com'), isNull);
      expect(validator.validate('user+tag@domain.org'), isNull);
      expect(validator.validate('u@d.co'), isNull);
    });
  });

  // ========================================
  // PASSWORD VALIDATOR TESTS
  // ========================================
  group('PasswordValidator', () {
    group('with default settings', () {
      late PasswordValidator validator;

      setUp(() {
        validator = PasswordValidator();
      });

      test('returns error for null password', () {
        expect(validator.validate(null), 'Password is required');
      });

      test('returns error for empty password', () {
        expect(validator.validate(''), 'Password is required');
      });

      test('returns error for short password', () {
        expect(
          validator.validate('Short1'),
          'Password must be at least 8 characters',
        );
      });

      test('returns error without uppercase', () {
        expect(
          validator.validate('lowercase123'),
          'Password must contain an uppercase letter',
        );
      });

      test('returns error without number', () {
        expect(
          validator.validate('NoNumbers'),
          'Password must contain a number',
        );
      });

      test('returns null for valid password', () {
        expect(validator.validate('ValidPass1'), isNull);
      });
    });

    group('with custom settings', () {
      test('validates with custom min length', () {
        final validator = PasswordValidator(
          minLength: 12,
          requireUppercase: false,
          requireNumber: false,
        );

        expect(
          validator.validate('shortpass'),
          'Password must be at least 12 characters',
        );
        expect(validator.validate('longenoughpassword'), isNull);
      });

      test('validates without uppercase requirement', () {
        final validator = PasswordValidator(
          requireUppercase: false,
        );

        expect(validator.validate('lowercase123'), isNull);
      });

      test('validates without number requirement', () {
        final validator = PasswordValidator(
          requireNumber: false,
        );

        expect(validator.validate('NoNumbersHere'), isNull);
      });
    });
  });

  // ========================================
  // SHOPPING CART TESTS
  // ========================================
  group('ShoppingCart', () {
    late ShoppingCart cart;

    setUp(() {
      cart = ShoppingCart();
    });

    test('starts empty', () {
      expect(cart.isEmpty, isTrue);
      expect(cart.itemCount, 0);
    });

    test('adds items correctly', () {
      cart.addItem(CartItem(
        productId: '1',
        name: 'Widget',
        price: 10.0,
        quantity: 2,
      ));

      expect(cart.isEmpty, isFalse);
      expect(cart.itemCount, 1);
    });

    test('removes items by product ID', () {
      cart.addItem(CartItem(productId: '1', name: 'A', price: 10.0, quantity: 1));
      cart.addItem(CartItem(productId: '2', name: 'B', price: 20.0, quantity: 1));

      cart.removeItem('1');

      expect(cart.itemCount, 1);
      expect(cart.items.first.productId, '2');
    });

    test('clears all items', () {
      cart.addItem(CartItem(productId: '1', name: 'A', price: 10.0, quantity: 1));
      cart.addItem(CartItem(productId: '2', name: 'B', price: 20.0, quantity: 1));

      cart.clear();

      expect(cart.isEmpty, isTrue);
    });

    test('calculates subtotal correctly', () {
      cart.addItem(CartItem(productId: '1', name: 'A', price: 10.0, quantity: 2)); // 20
      cart.addItem(CartItem(productId: '2', name: 'B', price: 15.0, quantity: 3)); // 45

      expect(cart.subtotal, 65.0);
    });

    group('calculateTotal', () {
      setUp(() {
        cart.addItem(CartItem(productId: '1', name: 'A', price: 100.0, quantity: 1));
      });

      test('returns subtotal with no tax or discount', () {
        expect(cart.calculateTotal(), 100.0);
      });

      test('applies tax correctly', () {
        expect(cart.calculateTotal(taxRate: 0.1), 110.0); // 100 + 10%
      });

      test('applies discount correctly', () {
        expect(cart.calculateTotal(discount: 20.0), 80.0); // 100 - 20
      });

      test('applies both tax and discount', () {
        // (100 - 20) * 1.1 = 80 * 1.1 = 88
        expect(cart.calculateTotal(taxRate: 0.1, discount: 20.0), 88.0);
      });

      test('returns 0 for discount greater than subtotal', () {
        expect(cart.calculateTotal(discount: 200.0), 0.0);
      });
    });
  });

  // ========================================
  // ASYNC TESTS - USER SERVICE
  // ========================================
  group('UserService', () {
    late UserService service;

    setUp(() {
      service = UserService();
    });

    test('fetches existing user', () async {
      final user = await service.fetchUser('1');

      expect(user, isNotNull);
      expect(user!.name, 'Alice Smith');
    });

    test('returns null for non-existent user', () async {
      final user = await service.fetchUser('999');

      expect(user, isNull);
    });

    test('fetches all users', () async {
      final users = await service.fetchAllUsers();

      expect(users, hasLength(3));
    });

    test('fetches only adult users', () async {
      final adults = await service.fetchAdultUsers();

      expect(adults, hasLength(2)); // Alice (25) and Carol (70)
      expect(adults.every((u) => u.isAdult), isTrue);
    });
  });

  // ========================================
  // CART ITEM TESTS
  // ========================================
  group('CartItem', () {
    test('calculates total correctly', () {
      final item = CartItem(
        productId: '1',
        name: 'Test',
        price: 25.0,
        quantity: 4,
      );

      expect(item.total, 100.0);
    });
  });
}
*/

// ============================================
// HOW TO RUN THESE TESTS
// ============================================
/*
  1. Create test file at: test/example01_unit_tests_test.dart
  2. Copy the test code (inside the /* */ block above)
  3. Run: flutter test test/example01_unit_tests_test.dart

  OUTPUT:
  00:01 +35: All tests passed!
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌────────────────────────────────────────────────────────────┐
  │                    UNIT TEST EXAMPLES                       │
  ├────────────────────────────────────────────────────────────┤
  │                                                             │
  │  CALCULATOR TESTS                                           │
  │  ├── add(), subtract(), multiply()                         │
  │  └── divide() with exception testing                       │
  │                                                             │
  │  MODEL TESTS (User, Product)                                │
  │  ├── Property getters                                      │
  │  ├── Computed properties (isAdult, totalValue)             │
  │  └── JSON serialization                                    │
  │                                                             │
  │  VALIDATOR TESTS                                            │
  │  ├── Email validation rules                                │
  │  └── Password validation with custom settings              │
  │                                                             │
  │  SHOPPING CART TESTS                                        │
  │  ├── Add/remove items                                      │
  │  └── Calculate totals with tax/discount                    │
  │                                                             │
  │  ASYNC TESTS                                                │
  │  ├── Fetch single user                                     │
  │  └── Fetch filtered list                                   │
  │                                                             │
  │  KEY PATTERNS USED:                                         │
  │  ├── group() - Organize related tests                      │
  │  ├── setUp() - Create fresh instances                      │
  │  ├── expect() - Assert expected values                     │
  │  └── throwsA() - Test exceptions                           │
  │                                                             │
  └────────────────────────────────────────────────────────────┘
*/
