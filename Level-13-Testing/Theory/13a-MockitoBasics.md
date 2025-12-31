# Mockito Basics - Testing with Mocks

## Think of It Like This (5-Year-Old Explanation)

Imagine you're playing "store" with your friends, but your friend who plays the cashier is sick today:

```
┌─────────────────────────────────────┐
│        PRETEND STORE GAME            │
├─────────────────────────────────────┤
│                                     │
│  Real Game (Need Real Friends):     │
│  ┌──────────────┐                  │
│  │  You         │  "I want candy"  │
│  │  (Customer)  │  ────────────→   │
│  └──────────────┘                  │
│                                     │
│  ┌──────────────┐                  │
│  │  Real Friend │  "That's $2"     │
│  │  (Cashier)   │  ←────────────   │
│  └──────────────┘                  │
│                                     │
│  Pretend Game (Friend is sick):    │
│  ┌──────────────┐                  │
│  │  You         │  "I want candy"  │
│  │  (Customer)  │  ────────────→   │
│  └──────────────┘                  │
│                                     │
│  ┌──────────────┐                  │
│  │  Teddy Bear  │  "That's $2"     │
│  │  (Pretend    │  ←────────────   │
│  │   Cashier)   │  (You make the   │
│  └──────────────┘   teddy "talk")  │
│                                     │
│  The teddy bear is a MOCK!          │
│  You control what it says!          │
└─────────────────────────────────────┘
```

Mockito lets you create "pretend" versions of real objects (like databases, APIs, services) so you can test your code without needing the real things. You control what these pretend objects do and say!

## What is Mockito?

Mockito is a popular testing library that helps you create **mock objects**. A mock object is a fake version of a real object that you can control in your tests.

### Why Use Mocks?

```
┌────────────────────────────────────────────────────┐
│          WHY WE NEED MOCKS IN TESTING              │
├────────────────────────────────────────────────────┤
│                                                     │
│  Without Mocks (Testing with Real Services):       │
│  ┌──────────────────────────────────┐             │
│  │  Your Test                        │             │
│  │    ↓                              │             │
│  │  Your Code                        │             │
│  │    ↓                              │             │
│  │  Real Database ← Slow!            │             │
│  │  Real API ← Costs money!          │             │
│  │  Real Auth ← Needs internet!      │             │
│  └──────────────────────────────────┘             │
│                                                     │
│  Problems:                                         │
│  ❌ Tests are slow                                 │
│  ❌ Tests need internet                            │
│  ❌ Tests cost money (API calls)                   │
│  ❌ Tests can fail due to external issues          │
│  ❌ Hard to test error scenarios                   │
│                                                     │
│  With Mocks (Testing with Fake Services):         │
│  ┌──────────────────────────────────┐             │
│  │  Your Test                        │             │
│  │    ↓                              │             │
│  │  Your Code                        │             │
│  │    ↓                              │             │
│  │  Mock Database ← Instant!         │             │
│  │  Mock API ← Free!                 │             │
│  │  Mock Auth ← Always works!        │             │
│  └──────────────────────────────────┘             │
│                                                     │
│  Benefits:                                         │
│  ✓ Tests are fast                                  │
│  ✓ No internet needed                              │
│  ✓ Free to run                                     │
│  ✓ Tests are reliable                              │
│  ✓ Easy to test errors and edge cases              │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Setting Up Mockito

### Step 1: Add Dependencies

Update your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

Then run:

```bash
flutter pub get
```

### Step 2: Understanding Mockito Workflow

```
┌────────────────────────────────────────────────────┐
│           MOCKITO TESTING WORKFLOW                 │
├────────────────────────────────────────────────────┤
│                                                     │
│  1. Create a Class You Want to Mock               │
│     ↓                                               │
│  2. Use @GenerateMocks annotation                  │
│     ↓                                               │
│  3. Run build_runner to generate mock              │
│     ↓                                               │
│  4. Use the generated mock in your tests           │
│     ↓                                               │
│  5. Configure mock behavior (when/thenReturn)      │
│     ↓                                               │
│  6. Verify mock was called correctly               │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Basic Example: Mocking a Simple Service

### Step 1: Create a Service to Test

```dart
// lib/services/user_service.dart

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

class UserService {
  // This would normally make a real API call
  Future<User> getUser(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate API response
    return User(
      id: id,
      name: 'John Doe',
      email: 'john@example.com',
    );
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      User(id: '1', name: 'John', email: 'john@example.com'),
      User(id: '2', name: 'Jane', email: 'jane@example.com'),
    ];
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Update user
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }
}
```

### Step 2: Create a Widget That Uses the Service

```dart
// lib/screens/user_profile_screen.dart

import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  final UserService userService;
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userService,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await widget.userService.getUser(widget.userId);
      setState(() {
        _user = user;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    if (_user == null) {
      return const Center(child: Text('No user found'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${_user!.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Email: ${_user!.email}'),
          const SizedBox(height: 8),
          Text('ID: ${_user!.id}'),
        ],
      ),
    );
  }
}
```

### Step 3: Create Test File with Mock

```dart
// test/screens/user_profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:your_app/services/user_service.dart';
import 'package:your_app/screens/user_profile_screen.dart';

// This annotation tells Mockito to generate a mock class for UserService
@GenerateMocks([UserService])
import 'user_profile_screen_test.mocks.dart';

void main() {
  // We'll add tests here
}
```

### Step 4: Generate Mock Classes

Run this command:

```bash
flutter pub run build_runner build
```

This creates a file called `user_profile_screen_test.mocks.dart` with a `MockUserService` class.

```
┌────────────────────────────────────────────────────┐
│        WHAT build_runner GENERATES                 │
├────────────────────────────────────────────────────┤
│                                                     │
│  Input: @GenerateMocks([UserService])             │
│                                                     │
│  Output: MockUserService class                     │
│  ┌──────────────────────────────────┐             │
│  │ class MockUserService             │             │
│  │   extends Mock                    │             │
│  │   implements UserService {        │             │
│  │                                   │             │
│  │   // All methods from UserService │             │
│  │   // but you control their output │             │
│  │ }                                 │             │
│  └──────────────────────────────────┘             │
│                                                     │
│  You don't write this by hand!                     │
│  Mockito generates it for you!                     │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Step 5: Write Tests Using the Mock

```dart
// test/screens/user_profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:your_app/services/user_service.dart';
import 'package:your_app/screens/user_profile_screen.dart';

@GenerateMocks([UserService])
import 'user_profile_screen_test.mocks.dart';

void main() {
  // Create a mock instance
  late MockUserService mockUserService;

  setUp(() {
    // Create fresh mock for each test
    mockUserService = MockUserService();
  });

  testWidgets('displays loading indicator while fetching user',
      (WidgetTester tester) async {
    // Arrange: Configure the mock to return a user after a delay
    when(mockUserService.getUser('123'))
        .thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return User(id: '123', name: 'John', email: 'john@example.com');
    });

    // Act: Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileScreen(
          userService: mockUserService,
          userId: '123',
        ),
      ),
    );

    // Assert: Loading indicator should be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the async operation to complete
    await tester.pumpAndSettle();

    // Assert: Loading indicator should be gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('displays user data when loaded successfully',
      (WidgetTester tester) async {
    // Arrange: Configure mock to return a user
    when(mockUserService.getUser('123'))
        .thenAnswer((_) async => User(
          id: '123',
          name: 'John Doe',
          email: 'john@example.com',
        ));

    // Act: Build widget and wait for loading to complete
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileScreen(
          userService: mockUserService,
          userId: '123',
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert: User data should be displayed
    expect(find.text('Name: John Doe'), findsOneWidget);
    expect(find.text('Email: john@example.com'), findsOneWidget);
    expect(find.text('ID: 123'), findsOneWidget);
  });

  testWidgets('displays error when user fetch fails',
      (WidgetTester tester) async {
    // Arrange: Configure mock to throw an error
    when(mockUserService.getUser('123'))
        .thenThrow(Exception('Network error'));

    // Act: Build widget and wait for loading
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileScreen(
          userService: mockUserService,
          userId: '123',
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert: Error message should be displayed
    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.textContaining('Network error'), findsOneWidget);
  });

  testWidgets('calls getUser with correct userId',
      (WidgetTester tester) async {
    // Arrange
    when(mockUserService.getUser(any))
        .thenAnswer((_) async => User(
          id: '456',
          name: 'Jane',
          email: 'jane@example.com',
        ));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileScreen(
          userService: mockUserService,
          userId: '456',
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert: Verify the service was called with correct ID
    verify(mockUserService.getUser('456')).called(1);
  });
}
```

## Understanding when() and thenReturn()

The `when()` and `thenReturn()` pattern is the core of Mockito:

```dart
// Basic pattern
when(mock.method()).thenReturn(value);

// Examples:

// 1. Return a simple value
when(mockUserService.getUser('123'))
    .thenReturn(User(id: '123', name: 'John', email: 'john@example.com'));

// 2. Return different values for different inputs
when(mockUserService.getUser('123'))
    .thenReturn(User(id: '123', name: 'John', email: 'john@example.com'));
when(mockUserService.getUser('456'))
    .thenReturn(User(id: '456', name: 'Jane', email: 'jane@example.com'));

// 3. Return a Future (for async methods)
when(mockUserService.getUser('123'))
    .thenAnswer((_) async => User(id: '123', name: 'John', email: 'john@example.com'));

// 4. Throw an exception
when(mockUserService.getUser('123'))
    .thenThrow(Exception('User not found'));

// 5. Match any argument
when(mockUserService.getUser(any))
    .thenReturn(User(id: 'any', name: 'Any User', email: 'any@example.com'));

// 6. Return different values on successive calls
when(mockUserService.getUser('123'))
    .thenReturn(User(id: '123', name: 'John V1', email: 'john@example.com'))
    .thenReturn(User(id: '123', name: 'John V2', email: 'john@example.com'));
```

### Visual Explanation

```
┌────────────────────────────────────────────────────┐
│           HOW when/thenReturn WORKS                │
├────────────────────────────────────────────────────┤
│                                                     │
│  Your Test:                                        │
│  ┌──────────────────────────────────┐             │
│  │ when(mock.getUser('123'))        │             │
│  │   .thenReturn(john)              │             │
│  └──────────────────────────────────┘             │
│         ↓                                           │
│  Mockito remembers this rule                       │
│         ↓                                           │
│  Your Code Runs:                                   │
│  ┌──────────────────────────────────┐             │
│  │ user = mock.getUser('123')       │             │
│  └──────────────────────────────────┘             │
│         ↓                                           │
│  Mockito checks: "Do I have a rule                 │
│  for getUser('123')?"                              │
│         ↓                                           │
│  Yes! Return 'john'                                │
│         ↓                                           │
│  Your code receives: User{name: 'John'}           │
│                                                     │
│  It's like a robot following instructions:         │
│  "When someone asks for user 123, give them John"  │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Understanding verify()

The `verify()` method checks if a mock method was called:

```dart
// Basic verification
verify(mock.method()).called(1);  // Called exactly once

// Examples:

// 1. Verify method was called once
verify(mockUserService.getUser('123')).called(1);

// 2. Verify method was never called
verifyNever(mockUserService.deleteUser(any));

// 3. Verify method was called at least once
verify(mockUserService.getUser(any)).called(greaterThan(0));

// 4. Verify method was called exactly N times
verify(mockUserService.getAllUsers()).called(3);

// 5. Verify method was called with specific argument
verify(mockUserService.getUser('123')).called(1);

// 6. Verify method was called with any argument
verify(mockUserService.getUser(any)).called(1);

// 7. Verify order of calls
verifyInOrder([
  mockUserService.getUser('123'),
  mockUserService.updateUser(any),
  mockUserService.deleteUser('123'),
]);

// 8. Verify no more interactions
verifyNoMoreInteractions(mockUserService);
```

### Visual Explanation

```
┌────────────────────────────────────────────────────┐
│              HOW verify() WORKS                    │
├────────────────────────────────────────────────────┤
│                                                     │
│  Your Code Runs:                                   │
│  ┌──────────────────────────────────┐             │
│  │ mock.getUser('123')   ← Call 1   │             │
│  │ mock.getAllUsers()    ← Call 2   │             │
│  │ mock.getUser('456')   ← Call 3   │             │
│  └──────────────────────────────────┘             │
│         ↓                                           │
│  Mockito records all calls                         │
│  ┌──────────────────────────────────┐             │
│  │ Call Log:                         │             │
│  │ 1. getUser('123')                │             │
│  │ 2. getAllUsers()                 │             │
│  │ 3. getUser('456')                │             │
│  └──────────────────────────────────┘             │
│         ↓                                           │
│  Your Test Checks:                                 │
│  verify(mock.getUser('123')).called(1)            │
│         ↓                                           │
│  Mockito searches call log...                      │
│  Found 1 call to getUser('123') ✓                 │
│                                                     │
│  It's like checking a security camera log!         │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Complete Testing Example: Shopping Cart

Let's build a complete example with a shopping cart.

### Step 1: Create Repository Interface

```dart
// lib/repositories/product_repository.dart

class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

abstract class ProductRepository {
  Future<Product> getProduct(String id);
  Future<List<Product>> getAllProducts();
  Future<bool> isProductInStock(String id);
}

// Real implementation (would connect to database/API)
class RealProductRepository implements ProductRepository {
  @override
  Future<Product> getProduct(String id) async {
    // Would make real API call
    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getAllProducts() async {
    // Would make real API call
    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError();
  }

  @override
  Future<bool> isProductInStock(String id) async {
    // Would check real inventory
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError();
  }
}
```

### Step 2: Create Cart Service

```dart
// lib/services/cart_service.dart

import '../repositories/product_repository.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartService {
  final ProductRepository productRepository;
  final List<CartItem> _items = [];

  CartService({required this.productRepository});

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> addProduct(String productId) async {
    // Check if product exists and is in stock
    final product = await productRepository.getProduct(productId);
    final inStock = await productRepository.isProductInStock(productId);

    if (!inStock) {
      throw Exception('Product is out of stock');
    }

    // Check if already in cart
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      _items[index].quantity = quantity;
    }
  }

  void clear() {
    _items.clear();
  }
}
```

### Step 3: Create Tests

```dart
// test/services/cart_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:your_app/repositories/product_repository.dart';
import 'package:your_app/services/cart_service.dart';

@GenerateMocks([ProductRepository])
import 'cart_service_test.mocks.dart';

void main() {
  late MockProductRepository mockRepository;
  late CartService cartService;

  setUp(() {
    mockRepository = MockProductRepository();
    cartService = CartService(productRepository: mockRepository);
  });

  group('CartService', () {
    test('starts with empty cart', () {
      expect(cartService.items, isEmpty);
      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('adds product to cart successfully', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 9.99,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => true);

      // Act
      await cartService.addProduct('1');

      // Assert
      expect(cartService.itemCount, 1);
      expect(cartService.items.first.product.id, '1');
      expect(cartService.items.first.quantity, 1);
      expect(cartService.totalPrice, 9.99);

      // Verify repository methods were called
      verify(mockRepository.getProduct('1')).called(1);
      verify(mockRepository.isProductInStock('1')).called(1);
    });

    test('increases quantity when adding same product twice', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 9.99,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => true);

      // Act
      await cartService.addProduct('1');
      await cartService.addProduct('1');

      // Assert
      expect(cartService.itemCount, 1);  // Still only 1 unique item
      expect(cartService.items.first.quantity, 2);  // But quantity is 2
      expect(cartService.totalPrice, 19.98);  // 9.99 * 2

      verify(mockRepository.getProduct('1')).called(2);
    });

    test('throws exception when product is out of stock', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 9.99,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => false);  // Out of stock!

      // Act & Assert
      expect(
        () => cartService.addProduct('1'),
        throwsException,
      );

      // Cart should remain empty
      expect(cartService.itemCount, 0);
    });

    test('removes product from cart', () async {
      // Arrange: Add a product first
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 9.99,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => true);

      await cartService.addProduct('1');
      expect(cartService.itemCount, 1);

      // Act: Remove it
      cartService.removeProduct('1');

      // Assert
      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('updates product quantity', () async {
      // Arrange: Add a product
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 10.0,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => true);

      await cartService.addProduct('1');

      // Act: Update quantity
      cartService.updateQuantity('1', 5);

      // Assert
      expect(cartService.items.first.quantity, 5);
      expect(cartService.totalPrice, 50.0);
    });

    test('removes product when quantity set to 0', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 9.99,
      );

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock('1'))
          .thenAnswer((_) async => true);

      await cartService.addProduct('1');

      // Act
      cartService.updateQuantity('1', 0);

      // Assert
      expect(cartService.itemCount, 0);
    });

    test('calculates total price correctly with multiple products', () async {
      // Arrange
      final product1 = Product(id: '1', name: 'Product 1', price: 10.0);
      final product2 = Product(id: '2', name: 'Product 2', price: 20.0);

      when(mockRepository.getProduct('1'))
          .thenAnswer((_) async => product1);
      when(mockRepository.getProduct('2'))
          .thenAnswer((_) async => product2);
      when(mockRepository.isProductInStock(any))
          .thenAnswer((_) async => true);

      // Act
      await cartService.addProduct('1');
      await cartService.addProduct('2');
      await cartService.addProduct('1');  // Add product 1 again

      // Assert
      // Product 1: 10.0 * 2 = 20.0
      // Product 2: 20.0 * 1 = 20.0
      // Total: 40.0
      expect(cartService.totalPrice, 40.0);
      expect(cartService.itemCount, 2);
    });

    test('clears all items from cart', () async {
      // Arrange: Add some products
      final product = Product(id: '1', name: 'Product', price: 10.0);

      when(mockRepository.getProduct(any))
          .thenAnswer((_) async => product);
      when(mockRepository.isProductInStock(any))
          .thenAnswer((_) async => true);

      await cartService.addProduct('1');
      await cartService.addProduct('1');

      expect(cartService.itemCount, 1);

      // Act
      cartService.clear();

      // Assert
      expect(cartService.itemCount, 0);
      expect(cartService.totalPrice, 0.0);
      expect(cartService.items, isEmpty);
    });
  });
}
```

## Common Mockito Patterns

### Pattern 1: Argument Matchers

```dart
// Match any argument
when(mock.getUser(any)).thenReturn(user);

// Match specific type
when(mock.updateUser(any as User)).thenReturn(user);

// Match with custom matcher
when(mock.getUser(argThat(startsWith('user_'))))
    .thenReturn(user);

// Capture arguments
final captured = verify(mock.getUser(captureAny)).captured;
expect(captured.first, 'user_123');
```

### Pattern 2: Answer with Arguments

```dart
// Use the argument passed to the method
when(mock.getUser(any)).thenAnswer((invocation) {
  final userId = invocation.positionalArguments[0] as String;
  return Future.value(User(id: userId, name: 'User $userId', email: 'user@example.com'));
});
```

### Pattern 3: Sequence of Returns

```dart
// Return different values on successive calls
when(mock.getRandomNumber())
    .thenReturn(1)
    .thenReturn(2)
    .thenReturn(3);

expect(mock.getRandomNumber(), 1);
expect(mock.getRandomNumber(), 2);
expect(mock.getRandomNumber(), 3);
```

### Pattern 4: Reset Mocks

```dart
test('test 1', () {
  when(mock.getValue()).thenReturn(1);
  expect(mock.getValue(), 1);
});

test('test 2', () {
  // Mock is automatically reset between tests in setUp
  // But you can manually reset:
  reset(mock);

  when(mock.getValue()).thenReturn(2);
  expect(mock.getValue(), 2);
});
```

## Summary

Mockito helps you test code without real dependencies:

1. **Setup**: Add mockito and build_runner dependencies
2. **Generate**: Use @GenerateMocks annotation and run build_runner
3. **Configure**: Use when/thenReturn to set up mock behavior
4. **Test**: Write tests using the mock
5. **Verify**: Use verify() to check methods were called correctly

Mocks are like pretend toys - they look like the real thing, but you control exactly what they do!

## What's Next?

In the next guide, we'll explore advanced Mockito patterns like stubbing complex scenarios and testing edge cases.

---

**Previous:** [10c-LocalizationAdvanced.md](../../Level-09-Advanced-Features/Theory/10c-LocalizationAdvanced.md)
**Next:** [13b-MockitoAdvanced.md](./13b-MockitoAdvanced.md)
**Related:** [13-Testing-Basics.md](./13-Testing-Basics.md)
