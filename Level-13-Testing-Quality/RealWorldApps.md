# Level 13: Real-World Apps Using These Concepts

See how testing ensures quality in production applications!

---

## Unit Testing

### Testing Business Logic!

**E-commerce Cart (Amazon, Shopify)**
```dart
group('ShoppingCart', () {
  late ShoppingCart cart;
  late Product testProduct;

  setUp(() {
    cart = ShoppingCart();
    testProduct = Product(id: '1', name: 'iPhone', price: 999.0);
  });

  test('calculates correct total with discount', () {
    cart.addItem(testProduct, quantity: 2);
    cart.applyDiscount(10);  // 10% off

    expect(cart.subtotal, equals(1998.0));
    expect(cart.discount, equals(199.8));
    expect(cart.total, equals(1798.2));
  });

  test('prevents negative quantities', () {
    cart.addItem(testProduct);

    expect(
      () => cart.updateQuantity(testProduct.id, -1),
      throwsA(isA<InvalidQuantityException>()),
    );
  });

  test('calculates shipping correctly', () {
    cart.addItem(testProduct);
    cart.setShippingAddress(Address(country: 'US', state: 'CA'));

    expect(cart.shippingCost, equals(9.99));  // Standard US shipping
  });
});
```

**Banking App**
```dart
group('TransferService', () {
  test('prevents transfer exceeding balance', () async {
    final account = Account(balance: 100.0);

    expect(
      () => transferService.transfer(account, 150.0, targetAccount),
      throwsA(isA<InsufficientFundsException>()),
    );
  });

  test('deducts correct amount including fees', () async {
    final account = Account(balance: 100.0);
    await transferService.transfer(account, 50.0, targetAccount);

    expect(account.balance, equals(48.50));  // $50 + $1.50 fee
  });
});
```

---

## Widget Testing

### Testing UI Components!

**Login Form**
```dart
testWidgets('shows error for invalid email', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));

  await tester.enterText(
    find.byKey(Key('email_field')),
    'invalid-email',
  );
  await tester.enterText(
    find.byKey(Key('password_field')),
    'password123',
  );
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pump();

  expect(find.text('Please enter a valid email'), findsOneWidget);
});

testWidgets('shows loading state during login', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));

  await tester.enterText(find.byKey(Key('email_field')), 'test@email.com');
  await tester.enterText(find.byKey(Key('password_field')), 'password123');
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pump();

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Login'), findsNothing);
});
```

**Product Card**
```dart
testWidgets('ProductCard displays product info', (tester) async {
  final product = Product(
    name: 'iPhone 15',
    price: 999.0,
    imageUrl: 'https://example.com/iphone.jpg',
    rating: 4.5,
  );

  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: ProductCard(product: product))),
  );

  expect(find.text('iPhone 15'), findsOneWidget);
  expect(find.text('\$999.00'), findsOneWidget);
  expect(find.byIcon(Icons.star), findsNWidgets(4));  // 4 full stars
  expect(find.byIcon(Icons.star_half), findsOneWidget);  // 1 half star
});
```

---

## Integration Testing

### Testing Complete Flows!

**Checkout Flow**
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete checkout flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Add item to cart
    await tester.tap(find.text('Add to Cart').first);
    await tester.pumpAndSettle();

    // Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Proceed to checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    // Fill shipping info
    await tester.enterText(find.byKey(Key('address_field')), '123 Main St');
    await tester.enterText(find.byKey(Key('city_field')), 'San Francisco');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Fill payment info
    await tester.enterText(find.byKey(Key('card_field')), '4242424242424242');
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    // Verify success
    expect(find.text('Order Confirmed!'), findsOneWidget);
  });
}
```

---

## Mocking

### Isolating Tests!

**API Testing**
```dart
class MockApiService extends Mock implements ApiService {}

group('ProductRepository', () {
  late MockApiService mockApi;
  late ProductRepository repository;

  setUp(() {
    mockApi = MockApiService();
    repository = ProductRepository(api: mockApi);
  });

  test('returns products from API', () async {
    when(() => mockApi.getProducts()).thenAnswer(
      (_) async => [
        Product(id: '1', name: 'Product 1'),
        Product(id: '2', name: 'Product 2'),
      ],
    );

    final products = await repository.getProducts();

    expect(products.length, equals(2));
    verify(() => mockApi.getProducts()).called(1);
  });

  test('returns cached products on network error', () async {
    // First call succeeds
    when(() => mockApi.getProducts()).thenAnswer(
      (_) async => [Product(id: '1', name: 'Product 1')],
    );
    await repository.getProducts();

    // Second call fails
    when(() => mockApi.getProducts()).thenThrow(NetworkException());

    final products = await repository.getProducts();

    expect(products.length, equals(1));  // Returns cached
  });
});
```

---

## Test Coverage

### How Much is Tested!

**Coverage Report**
```
lib/features/auth/
  login_service.dart           95.2%
  registration_service.dart    88.7%
  password_reset_service.dart  92.3%

lib/features/cart/
  cart_provider.dart           98.1%
  cart_repository.dart         94.5%

lib/features/checkout/
  checkout_service.dart        85.4%
  payment_processor.dart       91.2%

Overall Coverage: 91.3%
```

---

## Real Apps Testing Practices

| Company | Testing Practice |
|---------|-----------------|
| **Google** | 80%+ code coverage required |
| **Netflix** | Chaos engineering + unit tests |
| **Spotify** | Automated regression testing |
| **Airbnb** | Visual regression tests |
| **Uber** | Integration tests for every flow |

---

## Golden Tests

### Visual Regression Testing!

**Catching UI Changes**
```dart
testWidgets('ProductCard matches golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProductCard(product: testProduct),
    ),
  );

  await expectLater(
    find.byType(ProductCard),
    matchesGoldenFile('goldens/product_card.png'),
  );
});
```

---

## Accessibility Testing

### Inclusive Apps!

```dart
testWidgets('screens are accessible', (tester) async {
  await tester.pumpWidget(MaterialApp(home: HomeScreen()));

  // Check semantic labels exist
  expect(
    tester.getSemantics(find.byType(Image)).first.label,
    isNotEmpty,
  );

  // Check tap targets are large enough (48x48 minimum)
  final buttonSize = tester.getSize(find.byType(IconButton).first);
  expect(buttonSize.width, greaterThanOrEqualTo(48));
  expect(buttonSize.height, greaterThanOrEqualTo(48));
});
```

---

## Test Automation

### CI/CD Pipeline!

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

---

## Build It Yourself!

After this level, you could:

1. **Add unit tests** to your capstone project
2. **Write widget tests** for your custom widgets
3. **Create integration tests** for key user flows
4. **Set up CI/CD** with GitHub Actions
5. **Achieve 80%+ coverage** on business logic

---

## Testing Best Practices

| Practice | Why It Matters |
|----------|---------------|
| **Test behavior, not implementation** | Tests don't break on refactors |
| **Use descriptive test names** | Easy to understand failures |
| **One assertion per test** | Pinpoints exact failure |
| **Mock external dependencies** | Fast, reliable tests |
| **Run tests on every commit** | Catch bugs early |

---

**Testing gives you confidence - ship features without fear of breaking things!**
