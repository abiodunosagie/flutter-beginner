# 13b. Mockito Advanced - Advanced Testing Patterns

## What You'll Learn
Advanced Mockito techniques including verifying interactions, argument matchers, custom matchers, testing async code, and complete integration testing patterns.

---

## The Big Picture

Think of testing like being a detective:
- **Basic Mockito** = Using fake evidence (we learned this)
- **Advanced Mockito** = Being Sherlock Holmes - checking every detail, every clue, every interaction
- **Argument Matchers** = Having flexible search criteria ("any red car" vs "this exact red Ferrari")
- **Verification** = Checking that suspects did what you expected
- **Async Testing** = Solving mysteries that take time to unfold

```
TESTING JOURNEY
================

Level 1: Basic Mocking              Level 2: Advanced Patterns
┌─────────────────┐                ┌──────────────────────┐
│ when/thenReturn │                │ Argument Matchers    │
│ Simple verify   │    ──────>     │ Custom Matchers      │
│ One test case   │                │ Verify Never         │
└─────────────────┘                │ Async Verification   │
                                   │ Integration Tests    │
                                   └──────────────────────┘
```

---

## 1. Argument Matchers - The Flexible Detective

### The Toy Store Analogy

Imagine asking for toys:
- **Exact match**: "I want THIS exact red toy car" (specific argument)
- **Any match**: "I want ANY toy car" (any())
- **Type match**: "I want any RED toy" (color matcher)
- **Custom match**: "I want any toy that costs less than $10" (custom matcher)

### Basic Argument Matchers

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Service we're mocking
abstract class ProductService {
  Future<Product?> getProduct(String id);
  Future<List<Product>> searchProducts(String query, {int page = 1, int limit = 10});
  Future<void> updateProduct(String id, Map<String, dynamic> data);
  Future<void> deleteProduct(String id);
}

@GenerateMocks([ProductService])
void main() {}
```

### Example 1: Basic Argument Matchers

```dart
test('any() matcher - accepts any argument', () {
  final mockService = MockProductService();

  // Setup: Return product for ANY id
  when(mockService.getProduct(any))
      .thenAnswer((_) async => Product(id: '1', name: 'Test Product'));

  // All these work!
  expect(await mockService.getProduct('123'), isNotNull);
  expect(await mockService.getProduct('456'), isNotNull);
  expect(await mockService.getProduct('anything'), isNotNull);
});

test('anyNamed() - for named parameters', () {
  final mockService = MockProductService();

  // Setup: Accept any page and limit
  when(mockService.searchProducts(
    'laptop',
    page: anyNamed('page'),
    limit: anyNamed('limit'),
  )).thenAnswer((_) async => [Product(id: '1', name: 'Laptop')]);

  // All these work!
  expect(await mockService.searchProducts('laptop', page: 1), hasLength(1));
  expect(await mockService.searchProducts('laptop', page: 5), hasLength(1));
  expect(await mockService.searchProducts('laptop', limit: 20), hasLength(1));
});

test('specific value + any() combination', () {
  final mockService = MockProductService();

  // Setup: Only specific query, but any pagination
  when(mockService.searchProducts(
    'laptop',  // Must be 'laptop'
    page: anyNamed('page'),  // Any page
    limit: anyNamed('limit'),  // Any limit
  )).thenAnswer((_) async => [Product(id: '1', name: 'Laptop')]);

  // This works
  expect(await mockService.searchProducts('laptop', page: 1), hasLength(1));

  // This returns null (default) - different query
  expect(await mockService.searchProducts('phone', page: 1), isEmpty);
});
```

### Example 2: Type-Based Matchers

```dart
test('argThat() - custom matching logic', () {
  final mockService = MockProductService();

  // Setup: Only accept IDs that start with 'PROD-'
  when(mockService.getProduct(
    argThat(startsWith('PROD-')),
  )).thenAnswer((_) async => Product(id: 'PROD-1', name: 'Valid Product'));

  // This works
  expect(await mockService.getProduct('PROD-123'), isNotNull);
  expect(await mockService.getProduct('PROD-456'), isNotNull);

  // This doesn't match
  expect(await mockService.getProduct('123'), isNull);
});

test('argThat() with complex conditions', () {
  final mockService = MockProductService();

  // Setup: Only accept IDs between 100 and 999
  when(mockService.getProduct(
    argThat(predicate((id) {
      final num = int.tryParse(id as String);
      return num != null && num >= 100 && num < 1000;
    })),
  )).thenAnswer((_) async => Product(id: '100', name: 'Valid Product'));

  // These work (100-999)
  expect(await mockService.getProduct('100'), isNotNull);
  expect(await mockService.getProduct('500'), isNotNull);
  expect(await mockService.getProduct('999'), isNotNull);

  // These don't match
  expect(await mockService.getProduct('50'), isNull);
  expect(await mockService.getProduct('1000'), isNull);
});
```

### Example 3: Capturing Arguments

```dart
test('captureThat() - capture and verify arguments', () {
  final mockService = MockProductService();

  // Call the method multiple times
  mockService.updateProduct('1', {'name': 'New Name'});
  mockService.updateProduct('2', {'price': 99.99});
  mockService.updateProduct('3', {'stock': 10});

  // Capture all the data arguments
  final captured = verify(
    mockService.updateProduct(any, captureThat(isA<Map<String, dynamic>>()))
  ).captured;

  // Verify we captured 3 calls
  expect(captured, hasLength(3));

  // Verify the captured data
  expect(captured[0], {'name': 'New Name'});
  expect(captured[1], {'price': 99.99});
  expect(captured[2], {'stock': 10});
});

test('captureAny - simple capture', () {
  final mockService = MockProductService();

  // Call the method
  mockService.updateProduct('123', {'name': 'Updated Product', 'price': 29.99});

  // Capture both arguments
  final verification = verify(
    mockService.updateProduct(captureAny, captureAny)
  );

  final captured = verification.captured;

  expect(captured[0], '123');  // First argument (id)
  expect(captured[1], {'name': 'Updated Product', 'price': 29.99});  // Second argument (data)
});
```

---

## 2. Advanced Verification - The Detail-Oriented Detective

### The Security Guard Analogy

Imagine a security guard checking a building:
- **verify()** = Did someone enter? ✓
- **verifyNever()** = Did anyone break in? ✗
- **verifyInOrder()** = Did they enter rooms in the right order? 1→2→3
- **verifyNoMoreInteractions()** = Did they touch anything else? No!

### Example 4: Verification Counts

```dart
test('verify exact number of calls', () {
  final mockService = MockProductService();

  // Call multiple times
  mockService.getProduct('1');
  mockService.getProduct('2');
  mockService.getProduct('3');

  // Verify called exactly 3 times
  verify(mockService.getProduct(any)).called(3);
});

test('verify at least / at most', () {
  final mockService = MockProductService();

  // Call 5 times
  for (int i = 0; i < 5; i++) {
    mockService.getProduct('$i');
  }

  // These all pass
  verify(mockService.getProduct(any)).called(greaterThan(3));
  verify(mockService.getProduct(any)).called(greaterThanOrEqualTo(5));
  verify(mockService.getProduct(any)).called(lessThan(10));
});

test('verifyNever - ensure method was NOT called', () {
  final mockService = MockProductService();

  // Only call getProduct
  mockService.getProduct('1');

  // Verify deleteProduct was NEVER called
  verifyNever(mockService.deleteProduct(any));

  // This is important for security tests!
  // "Make sure we never delete anything"
});
```

### Example 5: Order Verification

```dart
abstract class CheckoutService {
  Future<void> validateCart();
  Future<void> calculateTotal();
  Future<void> processPayment();
  Future<void> sendConfirmation();
}

@GenerateMocks([CheckoutService])
void main() {}

test('verifyInOrder - ensure correct sequence', () {
  final mockCheckout = MockCheckoutService();

  // Simulate checkout process
  mockCheckout.validateCart();
  mockCheckout.calculateTotal();
  mockCheckout.processPayment();
  mockCheckout.sendConfirmation();

  // Verify they happened in THIS order
  verifyInOrder([
    mockCheckout.validateCart(),
    mockCheckout.calculateTotal(),
    mockCheckout.processPayment(),
    mockCheckout.sendConfirmation(),
  ]);
});

test('verifyInOrder - detect wrong order', () {
  final mockCheckout = MockCheckoutService();

  // Wrong order! Processed payment BEFORE validating
  mockCheckout.processPayment();  // ❌ Too early!
  mockCheckout.validateCart();

  // This will FAIL
  expect(
    () => verifyInOrder([
      mockCheckout.validateCart(),
      mockCheckout.processPayment(),
    ]),
    throwsA(isA<TestFailure>()),
  );
});
```

### Example 6: No More Interactions

```dart
test('verifyNoMoreInteractions - nothing else called', () {
  final mockService = MockProductService();

  // Call some methods
  mockService.getProduct('1');
  mockService.searchProducts('laptop');

  // Verify these were called
  verify(mockService.getProduct('1'));
  verify(mockService.searchProducts('laptop'));

  // Verify NOTHING ELSE was called
  verifyNoMoreInteractions(mockService);
});

test('verifyNoMoreInteractions - catches extra calls', () {
  final mockService = MockProductService();

  // Call methods
  mockService.getProduct('1');
  mockService.deleteProduct('999');  // 👀 Extra call!

  // Verify expected call
  verify(mockService.getProduct('1'));

  // This FAILS - we didn't verify deleteProduct!
  expect(
    () => verifyNoMoreInteractions(mockService),
    throwsA(isA<TestFailure>()),
  );
});
```

---

## 3. Testing Async Code - The Patient Detective

### The Pizza Delivery Analogy

Testing async is like tracking a pizza delivery:
- **Future** = Pizza is coming, but not here yet
- **await** = Wait at the door until pizza arrives
- **thenAnswer** = What happens when pizza arrives
- **Completer** = You control exactly when pizza arrives

### Example 7: Testing Futures

```dart
test('async test - wait for future to complete', () async {
  final mockService = MockProductService();

  // Setup async response
  when(mockService.getProduct('1')).thenAnswer(
    (_) async => Product(id: '1', name: 'Async Product'),
  );

  // MUST await!
  final product = await mockService.getProduct('1');

  expect(product?.name, 'Async Product');
});

test('thenAnswer with delay - simulate network', () async {
  final mockService = MockProductService();

  // Simulate 2-second network delay
  when(mockService.getProduct('1')).thenAnswer((_) async {
    await Future.delayed(Duration(seconds: 2));
    return Product(id: '1', name: 'Slow Product');
  });

  final stopwatch = Stopwatch()..start();
  final product = await mockService.getProduct('1');
  stopwatch.stop();

  expect(product?.name, 'Slow Product');
  expect(stopwatch.elapsedMilliseconds, greaterThan(2000));
});
```

### Example 8: Testing Error Handling

```dart
test('thenThrow - simulate errors', () async {
  final mockService = MockProductService();

  // Setup to throw error
  when(mockService.getProduct('invalid')).thenThrow(
    Exception('Product not found'),
  );

  // Expect error
  expect(
    () => mockService.getProduct('invalid'),
    throwsA(isA<Exception>()),
  );
});

test('async error handling with try-catch', () async {
  final mockService = MockProductService();

  // Setup async error
  when(mockService.getProduct('404')).thenAnswer(
    (_) async => throw NotFoundException('Product 404 not found'),
  );

  // Test error handling
  String errorMessage = '';
  try {
    await mockService.getProduct('404');
  } catch (e) {
    errorMessage = e.toString();
  }

  expect(errorMessage, contains('Product 404 not found'));
});

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}
```

### Example 9: Testing Streams

```dart
abstract class RealtimeService {
  Stream<Product> watchProduct(String id);
  Stream<List<Product>> watchProducts();
}

@GenerateMocks([RealtimeService])
void main() {}

test('Stream testing - multiple events', () async {
  final mockService = MockRealtimeService();

  // Setup stream that emits 3 products
  when(mockService.watchProduct('1')).thenAnswer((_) {
    return Stream.fromIterable([
      Product(id: '1', name: 'Product v1'),
      Product(id: '1', name: 'Product v2'),
      Product(id: '1', name: 'Product v3'),
    ]);
  });

  // Collect all events
  final products = await mockService.watchProduct('1').toList();

  expect(products, hasLength(3));
  expect(products[0].name, 'Product v1');
  expect(products[1].name, 'Product v2');
  expect(products[2].name, 'Product v3');
});

test('Stream testing - listen to events', () async {
  final mockService = MockRealtimeService();

  // Setup stream controller for manual control
  final controller = StreamController<Product>();
  when(mockService.watchProduct('1')).thenAnswer((_) => controller.stream);

  // Listen to stream
  final receivedProducts = <Product>[];
  mockService.watchProduct('1').listen(receivedProducts.add);

  // Emit events
  controller.add(Product(id: '1', name: 'First'));
  await Future.delayed(Duration(milliseconds: 10));
  controller.add(Product(id: '1', name: 'Second'));
  await Future.delayed(Duration(milliseconds: 10));

  // Verify received
  expect(receivedProducts, hasLength(2));
  expect(receivedProducts[0].name, 'First');
  expect(receivedProducts[1].name, 'Second');

  await controller.close();
});
```

---

## 4. Custom Matchers - The Specialized Detective

### Example 10: Creating Custom Matchers

```dart
// Custom matcher: Check if product is valid
Matcher isValidProduct() {
  return predicate<Product>((product) {
    return product.id.isNotEmpty &&
           product.name.isNotEmpty &&
           product.price >= 0;
  }, 'is a valid product');
}

// Custom matcher: Check if product is in stock
Matcher isInStock() {
  return predicate<Product>((product) {
    return product.stock > 0;
  }, 'is in stock');
}

// Custom matcher: Check price range
Matcher hasPriceBetween(double min, double max) {
  return predicate<Product>((product) {
    return product.price >= min && product.price <= max;
  }, 'has price between $min and $max');
}

test('using custom matchers', () async {
  final mockService = MockProductService();

  when(mockService.getProduct('1')).thenAnswer((_) async {
    return Product(
      id: '1',
      name: 'Gaming Laptop',
      price: 999.99,
      stock: 5,
    );
  });

  final product = await mockService.getProduct('1');

  // Use custom matchers
  expect(product, isValidProduct());
  expect(product, isInStock());
  expect(product, hasPriceBetween(500, 1500));
});
```

---

## 5. Complete Integration Test Example

### The Shopping Cart System

Let's test a complete shopping cart with multiple dependencies.

```dart
// Models
class Product {
  final String id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock = 0,
  });
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem(this.product, this.quantity);

  double get total => product.price * quantity;
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
  });
}

// Services
abstract class ProductService {
  Future<Product?> getProduct(String id);
  Future<bool> checkStock(String productId, int quantity);
  Future<void> decrementStock(String productId, int quantity);
}

abstract class PaymentService {
  Future<bool> processPayment(double amount);
  Future<String> getTransactionId();
}

abstract class NotificationService {
  Future<void> sendOrderConfirmation(String orderId);
  Future<void> sendLowStockAlert(String productId);
}

// The main service we're testing
class CheckoutService {
  final ProductService productService;
  final PaymentService paymentService;
  final NotificationService notificationService;

  CheckoutService({
    required this.productService,
    required this.paymentService,
    required this.notificationService,
  });

  Future<Order?> checkout(List<CartItem> items) async {
    // Step 1: Validate stock for all items
    for (final item in items) {
      final hasStock = await productService.checkStock(
        item.product.id,
        item.quantity,
      );

      if (!hasStock) {
        throw Exception('Insufficient stock for ${item.product.name}');
      }
    }

    // Step 2: Calculate total
    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );

    // Step 3: Process payment
    final paymentSuccess = await paymentService.processPayment(total);
    if (!paymentSuccess) {
      throw Exception('Payment failed');
    }

    // Step 4: Decrement stock
    for (final item in items) {
      await productService.decrementStock(
        item.product.id,
        item.quantity,
      );

      // Check if stock is low
      final product = await productService.getProduct(item.product.id);
      if (product != null && product.stock < 5) {
        await notificationService.sendLowStockAlert(item.product.id);
      }
    }

    // Step 5: Create order
    final transactionId = await paymentService.getTransactionId();
    final order = Order(
      id: transactionId,
      items: items,
      total: total,
      createdAt: DateTime.now(),
    );

    // Step 6: Send confirmation
    await notificationService.sendOrderConfirmation(order.id);

    return order;
  }
}

// Generate mocks
@GenerateMocks([ProductService, PaymentService, NotificationService])
void main() {}
```

### Complete Integration Tests

```dart
void main() {
  group('CheckoutService Integration Tests', () {
    late CheckoutService checkoutService;
    late MockProductService mockProductService;
    late MockPaymentService mockPaymentService;
    late MockNotificationService mockNotificationService;

    setUp(() {
      mockProductService = MockProductService();
      mockPaymentService = MockPaymentService();
      mockNotificationService = MockNotificationService();

      checkoutService = CheckoutService(
        productService: mockProductService,
        paymentService: mockPaymentService,
        notificationService: mockNotificationService,
      );
    });

    test('successful checkout - single item', () async {
      // Setup product
      final product = Product(
        id: '1',
        name: 'Laptop',
        price: 999.99,
        stock: 10,
      );

      final cartItems = [CartItem(product, 2)];

      // Mock all dependencies
      when(mockProductService.checkStock('1', 2))
          .thenAnswer((_) async => true);

      when(mockPaymentService.processPayment(1999.98))
          .thenAnswer((_) async => true);

      when(mockProductService.decrementStock('1', 2))
          .thenAnswer((_) async => null);

      when(mockProductService.getProduct('1'))
          .thenAnswer((_) async => product.copyWith(stock: 8));

      when(mockPaymentService.getTransactionId())
          .thenAnswer((_) async => 'TXN-12345');

      when(mockNotificationService.sendOrderConfirmation('TXN-12345'))
          .thenAnswer((_) async => null);

      // Execute checkout
      final order = await checkoutService.checkout(cartItems);

      // Verify result
      expect(order, isNotNull);
      expect(order!.id, 'TXN-12345');
      expect(order.total, 1999.98);
      expect(order.items, hasLength(1));

      // Verify all services were called correctly
      verify(mockProductService.checkStock('1', 2)).called(1);
      verify(mockPaymentService.processPayment(1999.98)).called(1);
      verify(mockProductService.decrementStock('1', 2)).called(1);
      verify(mockNotificationService.sendOrderConfirmation('TXN-12345')).called(1);

      // Verify low stock alert was NOT sent (stock: 8 >= 5)
      verifyNever(mockNotificationService.sendLowStockAlert(any));
    });

    test('successful checkout - multiple items', () async {
      // Setup products
      final laptop = Product(id: '1', name: 'Laptop', price: 999.99, stock: 10);
      final mouse = Product(id: '2', name: 'Mouse', price: 29.99, stock: 50);
      final keyboard = Product(id: '3', name: 'Keyboard', price: 79.99, stock: 3);

      final cartItems = [
        CartItem(laptop, 1),
        CartItem(mouse, 2),
        CartItem(keyboard, 1),
      ];

      final total = 999.99 + (29.99 * 2) + 79.99; // 1139.96

      // Mock stock checks
      when(mockProductService.checkStock('1', 1)).thenAnswer((_) async => true);
      when(mockProductService.checkStock('2', 2)).thenAnswer((_) async => true);
      when(mockProductService.checkStock('3', 1)).thenAnswer((_) async => true);

      // Mock payment
      when(mockPaymentService.processPayment(total))
          .thenAnswer((_) async => true);

      // Mock stock decrements
      when(mockProductService.decrementStock(any, any))
          .thenAnswer((_) async => null);

      // Mock product lookups after decrement
      when(mockProductService.getProduct('1'))
          .thenAnswer((_) async => laptop.copyWith(stock: 9));
      when(mockProductService.getProduct('2'))
          .thenAnswer((_) async => mouse.copyWith(stock: 48));
      when(mockProductService.getProduct('3'))
          .thenAnswer((_) async => keyboard.copyWith(stock: 2)); // Low stock!

      // Mock transaction and notification
      when(mockPaymentService.getTransactionId())
          .thenAnswer((_) async => 'TXN-67890');
      when(mockNotificationService.sendOrderConfirmation(any))
          .thenAnswer((_) async => null);
      when(mockNotificationService.sendLowStockAlert(any))
          .thenAnswer((_) async => null);

      // Execute checkout
      final order = await checkoutService.checkout(cartItems);

      // Verify result
      expect(order, isNotNull);
      expect(order!.total, total);
      expect(order.items, hasLength(3));

      // Verify services called in correct order
      verifyInOrder([
        // Stock checks
        mockProductService.checkStock('1', 1),
        mockProductService.checkStock('2', 2),
        mockProductService.checkStock('3', 1),
        // Payment
        mockPaymentService.processPayment(total),
        // Stock decrements
        mockProductService.decrementStock('1', 1),
        mockProductService.getProduct('1'),
        mockProductService.decrementStock('2', 2),
        mockProductService.getProduct('2'),
        mockProductService.decrementStock('3', 1),
        mockProductService.getProduct('3'),
        // Notifications
        mockPaymentService.getTransactionId(),
        mockNotificationService.sendOrderConfirmation('TXN-67890'),
      ]);

      // Verify low stock alert was sent for keyboard only
      verify(mockNotificationService.sendLowStockAlert('3')).called(1);
      verifyNever(mockNotificationService.sendLowStockAlert('1'));
      verifyNever(mockNotificationService.sendLowStockAlert('2'));
    });

    test('checkout fails - insufficient stock', () async {
      final product = Product(id: '1', name: 'Laptop', price: 999.99, stock: 1);
      final cartItems = [CartItem(product, 5)]; // Want 5, only 1 available

      // Mock stock check to return false
      when(mockProductService.checkStock('1', 5))
          .thenAnswer((_) async => false);

      // Execute and expect error
      expect(
        () => checkoutService.checkout(cartItems),
        throwsA(isA<Exception>()),
      );

      // Verify stock was checked
      verify(mockProductService.checkStock('1', 5)).called(1);

      // Verify payment was NEVER attempted
      verifyNever(mockPaymentService.processPayment(any));
      verifyNever(mockProductService.decrementStock(any, any));
      verifyNever(mockNotificationService.sendOrderConfirmation(any));
    });

    test('checkout fails - payment declined', () async {
      final product = Product(id: '1', name: 'Laptop', price: 999.99, stock: 10);
      final cartItems = [CartItem(product, 1)];

      // Mock stock check succeeds
      when(mockProductService.checkStock('1', 1))
          .thenAnswer((_) async => true);

      // Mock payment FAILS
      when(mockPaymentService.processPayment(999.99))
          .thenAnswer((_) async => false);

      // Execute and expect error
      expect(
        () => checkoutService.checkout(cartItems),
        throwsA(isA<Exception>()),
      );

      // Verify stock was checked
      verify(mockProductService.checkStock('1', 1)).called(1);

      // Verify payment was attempted
      verify(mockPaymentService.processPayment(999.99)).called(1);

      // Verify stock was NOT decremented (payment failed!)
      verifyNever(mockProductService.decrementStock(any, any));
      verifyNever(mockNotificationService.sendOrderConfirmation(any));
    });

    test('verify no unexpected interactions', () async {
      final product = Product(id: '1', name: 'Laptop', price: 999.99, stock: 10);
      final cartItems = [CartItem(product, 1)];

      // Setup mocks
      when(mockProductService.checkStock('1', 1))
          .thenAnswer((_) async => true);
      when(mockPaymentService.processPayment(999.99))
          .thenAnswer((_) async => true);
      when(mockProductService.decrementStock('1', 1))
          .thenAnswer((_) async => null);
      when(mockProductService.getProduct('1'))
          .thenAnswer((_) async => product.copyWith(stock: 9));
      when(mockPaymentService.getTransactionId())
          .thenAnswer((_) async => 'TXN-12345');
      when(mockNotificationService.sendOrderConfirmation('TXN-12345'))
          .thenAnswer((_) async => null);

      // Execute
      await checkoutService.checkout(cartItems);

      // Verify expected interactions
      verify(mockProductService.checkStock('1', 1));
      verify(mockPaymentService.processPayment(999.99));
      verify(mockProductService.decrementStock('1', 1));
      verify(mockProductService.getProduct('1'));
      verify(mockPaymentService.getTransactionId());
      verify(mockNotificationService.sendOrderConfirmation('TXN-12345'));

      // Verify NO other interactions
      verifyNoMoreInteractions(mockProductService);
      verifyNoMoreInteractions(mockPaymentService);
      verifyNoMoreInteractions(mockNotificationService);
    });
  });
}

// Helper extension for copying products with new stock
extension ProductCopy on Product {
  Product copyWith({int? stock}) {
    return Product(
      id: id,
      name: name,
      price: price,
      stock: stock ?? this.stock,
    );
  }
}
```

---

## 6. Testing Best Practices

### Practice 1: Clear Test Names

```dart
// ❌ Bad: Vague test name
test('test product', () {
  // What are we testing?
});

// ✅ Good: Descriptive test name
test('checkout() throws exception when product is out of stock', () {
  // Clear what we're testing!
});

// ✅ Good: BDD-style naming
test('GIVEN insufficient stock WHEN checkout THEN throws exception', () {
  // Follows Given-When-Then pattern
});
```

### Practice 2: Arrange-Act-Assert Pattern

```dart
test('checkout calculates correct total for multiple items', () {
  // ARRANGE - Setup test data and mocks
  final mockService = MockProductService();
  final product1 = Product(id: '1', name: 'A', price: 10.0);
  final product2 = Product(id: '2', name: 'B', price: 20.0);
  final items = [CartItem(product1, 2), CartItem(product2, 1)];

  when(mockService.checkStock(any, any)).thenAnswer((_) async => true);
  when(mockPaymentService.processPayment(any)).thenAnswer((_) async => true);
  // ... other mocks

  // ACT - Execute the code under test
  final order = await checkoutService.checkout(items);

  // ASSERT - Verify results
  expect(order.total, 40.0); // 2 * 10 + 1 * 20
});
```

### Practice 3: One Assertion Per Test (when possible)

```dart
// ❌ Bad: Too many things in one test
test('checkout does everything correctly', () {
  // ... setup
  final order = await checkoutService.checkout(items);

  expect(order, isNotNull);
  expect(order.id, isNotEmpty);
  expect(order.total, greaterThan(0));
  expect(order.items, isNotEmpty);
  verify(mockPaymentService.processPayment(any));
  verify(mockNotificationService.sendOrderConfirmation(any));
  // Too much! Hard to know what failed
});

// ✅ Good: Focused tests
test('checkout returns non-null order', () {
  final order = await checkoutService.checkout(items);
  expect(order, isNotNull);
});

test('checkout generates transaction ID', () {
  final order = await checkoutService.checkout(items);
  expect(order.id, isNotEmpty);
});

test('checkout sends order confirmation', () {
  await checkoutService.checkout(items);
  verify(mockNotificationService.sendOrderConfirmation(any));
});
```

### Practice 4: Reset Mocks Between Tests

```dart
group('CheckoutService', () {
  late MockProductService mockProductService;

  setUp(() {
    // Create fresh mock for each test
    mockProductService = MockProductService();
  });

  tearDown(() {
    // Optional: Verify no unexpected calls
    // reset(mockProductService); // Not usually needed with setUp
  });

  test('test 1', () {
    // Uses fresh mock
  });

  test('test 2', () {
    // Uses fresh mock (not affected by test 1)
  });
});
```

---

## 7. Common Pitfalls and Solutions

### Pitfall 1: Mixing any() with Specific Values

```dart
// ❌ Wrong: Can't mix any() with specific values directly
when(mockService.updateProduct(any, {'name': 'Test'}))
    .thenAnswer((_) async => null);

// ✅ Correct: Use all matchers or all specific
when(mockService.updateProduct(any, any))
    .thenAnswer((_) async => null);

// ✅ Or use argThat for specific conditions
when(mockService.updateProduct(
  any,
  argThat(equals({'name': 'Test'})),
)).thenAnswer((_) async => null);
```

### Pitfall 2: Forgetting await

```dart
// ❌ Wrong: Forgot await
test('async test', () {
  final result = mockService.getData(); // Future<Data>, not Data!
  expect(result.name, 'Test'); // ERROR: Future has no 'name'
});

// ✅ Correct: Remember async/await
test('async test', () async {
  final result = await mockService.getData();
  expect(result.name, 'Test');
});
```

### Pitfall 3: Not Verifying All Expected Calls

```dart
// ❌ Incomplete: Forgot to verify all calls
test('checkout process', () async {
  await checkoutService.checkout(items);

  verify(mockPaymentService.processPayment(any));
  // Forgot to verify stock check!
  // Forgot to verify notification!
});

// ✅ Complete: Verify all expected interactions
test('checkout process', () async {
  await checkoutService.checkout(items);

  verify(mockProductService.checkStock(any, any));
  verify(mockPaymentService.processPayment(any));
  verify(mockNotificationService.sendOrderConfirmation(any));
});
```

---

## Quick Reference

### Argument Matchers

```dart
any                                  // Any value
anyNamed('paramName')               // Any named parameter
argThat(matcher)                    // Custom matcher
captureThat(matcher)                // Capture matching argument
captureAny                          // Capture any argument
```

### Verification

```dart
verify(mock.method())                          // Called at least once
verify(mock.method()).called(3)                // Called exactly 3 times
verify(mock.method()).called(greaterThan(2))   // Called more than 2 times
verifyNever(mock.method())                     // Never called
verifyInOrder([...])                           // Called in specific order
verifyNoMoreInteractions(mock)                 // No other calls made
```

### Async Testing

```dart
when(mock.method()).thenAnswer((_) async => value)
when(mock.method()).thenThrow(Exception('error'))
when(mock.method()).thenAnswer((_) => Stream.fromIterable([...]))
```

---

## Practice Exercise

Create tests for this service:

```dart
class OrderService {
  final ProductService productService;
  final PaymentService paymentService;
  final ShippingService shippingService;
  final EmailService emailService;

  Future<Order> createOrder(List<CartItem> items, Address address) async {
    // 1. Validate all items in stock
    // 2. Calculate total
    // 3. Process payment
    // 4. Calculate shipping cost
    // 5. Create order
    // 6. Send confirmation email
    // 7. Return order
  }
}
```

Test scenarios:
1. Successful order creation
2. Out of stock error
3. Payment failure
4. Verify correct order of operations
5. Verify email sent with correct order ID

---

## What's Next?

You now know advanced Mockito patterns! Next topics:

- **Widget Testing** - Testing UI components
- **Integration Testing** - Testing complete app flows
- **Golden Tests** - Testing visual appearance

---

## Navigation

- Previous: [13a. Mockito Basics](13a-MockitoBasics.md)
- Next: [Widget Testing Basics](../README.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 25 minutes**

**Remember**: Advanced testing is like being Sherlock Holmes - verify everything, check the order, capture the clues, and never assume anything! Test thoroughly, and bugs will have nowhere to hide.
