# Level 13 Capstone: Testing ShopEase

## What You're Building

In this level, you'll add **comprehensive tests** to ShopEase - unit tests, widget tests, and integration tests!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 13 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Testing Pyramid for ShopEase                               │
│                                                              │
│                        ╱╲                                    │
│                       ╱  ╲                                   │
│                      ╱ E2E╲     Integration Tests            │
│                     ╱──────╲    (Full user flows)            │
│                    ╱        ╲                                │
│                   ╱  Widget  ╲   Widget Tests                │
│                  ╱────────────╲  (UI components)             │
│                 ╱              ╲                             │
│                ╱     Unit       ╲  Unit Tests                │
│               ╱──────────────────╲ (Business logic)          │
│                                                              │
│   Goal: 80%+ code coverage                                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Unit Tests for Cart

```dart
// test/models/cart_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shopease/models/cart.dart';
import 'package:shopease/models/product.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Product tshirt;
    late Product jeans;

    setUp(() {
      cart = Cart();
      tshirt = Product(
        id: 1,
        title: 'T-Shirt',
        price: 29.99,
        description: 'A nice t-shirt',
        category: 'clothing',
        image: 'https://example.com/tshirt.jpg',
        rating: Rating(rate: 4.5, count: 100),
      );
      jeans = Product(
        id: 2,
        title: 'Jeans',
        price: 79.99,
        description: 'Blue jeans',
        category: 'clothing',
        image: 'https://example.com/jeans.jpg',
        rating: Rating(rate: 4.0, count: 50),
      );
    });

    test('starts empty', () {
      expect(cart.isEmpty, true);
      expect(cart.itemCount, 0);
      expect(cart.total, 0);
    });

    test('addItem adds product to cart', () {
      cart.addItem(tshirt);

      expect(cart.itemCount, 1);
      expect(cart.items.first.product, tshirt);
      expect(cart.items.first.quantity, 1);
    });

    test('addItem with quantity adds correct amount', () {
      cart.addItem(tshirt, 3);

      expect(cart.items.first.quantity, 3);
      expect(cart.totalQuantity, 3);
    });

    test('addItem same product increases quantity', () {
      cart.addItem(tshirt);
      cart.addItem(tshirt);

      expect(cart.itemCount, 1); // Still one item type
      expect(cart.items.first.quantity, 2);
    });

    test('removeItem removes product from cart', () {
      cart.addItem(tshirt);
      cart.addItem(jeans);

      cart.removeItem(tshirt.id.toString());

      expect(cart.itemCount, 1);
      expect(cart.containsProduct(tshirt.id.toString()), false);
    });

    test('updateQuantity changes item quantity', () {
      cart.addItem(tshirt);

      cart.updateQuantity(tshirt.id.toString(), 5);

      expect(cart.items.first.quantity, 5);
    });

    test('updateQuantity to 0 removes item', () {
      cart.addItem(tshirt);

      cart.updateQuantity(tshirt.id.toString(), 0);

      expect(cart.isEmpty, true);
    });

    test('subtotal calculates correctly', () {
      cart.addItem(tshirt, 2); // 29.99 * 2 = 59.98
      cart.addItem(jeans, 1);  // 79.99

      expect(cart.subtotal, closeTo(139.97, 0.01));
    });

    test('tax is 8% of subtotal', () {
      cart.addItem(tshirt); // 29.99

      expect(cart.tax, closeTo(2.40, 0.01)); // 29.99 * 0.08
    });

    test('shipping is free over $50', () {
      cart.addItem(jeans); // 79.99 > 50

      expect(cart.shipping, 0);
    });

    test('shipping is $5.99 under $50', () {
      cart.addItem(tshirt); // 29.99 < 50

      expect(cart.shipping, 5.99);
    });

    test('total includes subtotal, tax, and shipping', () {
      cart.addItem(tshirt); // 29.99
      // Tax: 2.40
      // Shipping: 5.99
      // Total: 38.38

      expect(cart.total, closeTo(38.38, 0.01));
    });

    test('clear removes all items', () {
      cart.addItem(tshirt);
      cart.addItem(jeans);

      cart.clear();

      expect(cart.isEmpty, true);
    });
  });
}
```

### Task 2: Unit Tests for API Service with Mocking

```dart
// test/services/api_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:shopease/services/api_service.dart';

@GenerateMocks([Dio])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService', () {
    late MockDio mockDio;
    late ApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = ApiService(dio: mockDio);
    });

    group('getProducts', () {
      test('returns list of products on success', () async {
        // Arrange
        when(mockDio.get('/products')).thenAnswer((_) async => Response(
          data: [
            {
              'id': 1,
              'title': 'Test Product',
              'price': 29.99,
              'description': 'A test product',
              'category': 'test',
              'image': 'https://example.com/image.jpg',
              'rating': {'rate': 4.5, 'count': 100},
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        ));

        // Act
        final products = await apiService.getProducts();

        // Assert
        expect(products.length, 1);
        expect(products.first.title, 'Test Product');
        expect(products.first.price, 29.99);
      });

      test('throws ApiException on network error', () async {
        // Arrange
        when(mockDio.get('/products')).thenThrow(DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/products'),
        ));

        // Act & Assert
        expect(
          () => apiService.getProducts(),
          throwsA(isA<ApiException>()),
        );
      });

      test('throws ApiException on 500 error', () async {
        // Arrange
        when(mockDio.get('/products')).thenThrow(DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/products'),
          ),
          requestOptions: RequestOptions(path: '/products'),
        ));

        // Act & Assert
        expect(
          () => apiService.getProducts(),
          throwsA(isA<ApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            500,
          )),
        );
      });
    });

    group('getProduct', () {
      test('returns single product by id', () async {
        // Arrange
        when(mockDio.get('/products/1')).thenAnswer((_) async => Response(
          data: {
            'id': 1,
            'title': 'Test Product',
            'price': 29.99,
            'description': 'A test product',
            'category': 'test',
            'image': 'https://example.com/image.jpg',
            'rating': {'rate': 4.5, 'count': 100},
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products/1'),
        ));

        // Act
        final product = await apiService.getProduct(1);

        // Assert
        expect(product.id, 1);
        expect(product.title, 'Test Product');
      });

      test('throws ApiException when product not found', () async {
        // Arrange
        when(mockDio.get('/products/999')).thenThrow(DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/products/999'),
          ),
          requestOptions: RequestOptions(path: '/products/999'),
        ));

        // Act & Assert
        expect(
          () => apiService.getProduct(999),
          throwsA(isA<ApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            404,
          )),
        );
      });
    });
  });
}
```

### Task 3: Widget Tests

```dart
// test/widgets/product_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopease/models/product.dart';
import 'package:shopease/providers/cart_provider.dart';
import 'package:shopease/widgets/product_card.dart';

void main() {
  group('ProductCard', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        id: 1,
        title: 'Test T-Shirt',
        price: 29.99,
        description: 'A comfortable cotton t-shirt',
        category: 'clothing',
        image: 'https://fakestoreapi.com/img/test.jpg',
        rating: Rating(rate: 4.5, count: 120),
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );
    }

    testWidgets('displays product name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test T-Shirt'), findsOneWidget);
    });

    testWidgets('displays formatted price', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('\$29.99'), findsOneWidget);
    });

    testWidgets('displays rating', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('shows Add to Cart button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('tapping Add to Cart adds product', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Button should change to "In Cart"
      expect(find.text('In Cart'), findsOneWidget);
    });

    testWidgets('card is tappable', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => CartProvider(),
          child: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });
  });
}
```

### Task 4: Widget Tests for Cart Screen

```dart
// test/screens/cart_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shopease/providers/cart_provider.dart';
import 'package:shopease/screens/cart/cart_screen.dart';

void main() {
  group('CartScreen', () {
    Widget createWidgetUnderTest({CartProvider? cartProvider}) {
      return MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => cartProvider ?? CartProvider(),
          child: const CartScreen(),
        ),
      );
    }

    testWidgets('shows empty state when cart is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('shows cart items when cart has items', (tester) async {
      final cartProvider = CartProvider();
      cartProvider.addToCart(Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'Test',
        category: 'test',
        image: 'https://example.com/img.jpg',
        rating: Rating(rate: 4.0, count: 10),
      ));

      await tester.pumpWidget(createWidgetUnderTest(cartProvider: cartProvider));

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
    });

    testWidgets('shows correct totals', (tester) async {
      final cartProvider = CartProvider();
      cartProvider.addToCart(Product(
        id: 1,
        title: 'Test Product',
        price: 100.00,
        description: 'Test',
        category: 'test',
        image: 'https://example.com/img.jpg',
        rating: Rating(rate: 4.0, count: 10),
      ));

      await tester.pumpWidget(createWidgetUnderTest(cartProvider: cartProvider));

      expect(find.textContaining('Subtotal'), findsOneWidget);
      expect(find.textContaining('Tax'), findsOneWidget);
      expect(find.textContaining('Total'), findsOneWidget);
    });

    testWidgets('quantity buttons work', (tester) async {
      final cartProvider = CartProvider();
      cartProvider.addToCart(Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'Test',
        category: 'test',
        image: 'https://example.com/img.jpg',
        rating: Rating(rate: 4.0, count: 10),
      ));

      await tester.pumpWidget(createWidgetUnderTest(cartProvider: cartProvider));

      // Find and tap the increment button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(cartProvider.items.first.quantity, 2);
    });
  });
}
```

### Task 5: Integration Test

```dart
// integration_test/app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shopease/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete purchase flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify products are displayed
      expect(find.byType(GridView), findsOneWidget);

      // Tap first product
      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();

      // Verify product detail screen
      expect(find.text('Add to Cart'), findsOneWidget);

      // Add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Verify item in cart
      expect(find.byType(CartItemTile), findsOneWidget);

      // Verify checkout button
      expect(find.text('Checkout'), findsOneWidget);

      // Tap checkout
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();

      // Should redirect to login (since not authenticated)
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
```

---

## Running Tests

```bash
# Run all unit and widget tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run integration tests
flutter test integration_test/app_test.dart

# Run specific test file
flutter test test/models/cart_test.dart

# Run tests with verbose output
flutter test --reporter expanded
```

---

## Success Criteria

- [ ] Cart unit tests pass (10+ tests)
- [ ] API service tests with mocking pass
- [ ] ProductCard widget tests pass
- [ ] CartScreen widget tests pass
- [ ] Integration test completes purchase flow
- [ ] Code coverage > 80%
- [ ] All tests run in CI (GitHub Actions)

---

## Test File Structure

```
shopease/
└── test/
    ├── models/
    │   ├── cart_test.dart       ◄── Create
    │   ├── product_test.dart    ◄── Create
    │   └── order_test.dart      ◄── Create
    │
    ├── services/
    │   └── api_service_test.dart ◄── Create
    │
    ├── providers/
    │   ├── cart_provider_test.dart ◄── Create
    │   └── user_provider_test.dart ◄── Create
    │
    ├── widgets/
    │   ├── product_card_test.dart  ◄── Create
    │   └── cart_item_tile_test.dart ◄── Create
    │
    └── screens/
        ├── home_screen_test.dart  ◄── Create
        └── cart_screen_test.dart  ◄── Create

└── integration_test/
    └── app_test.dart             ◄── Create
```

---

**Your ShopEase app is now well-tested!**
