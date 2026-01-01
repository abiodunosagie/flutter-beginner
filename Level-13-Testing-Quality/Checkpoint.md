# Level 13 Checkpoint: Testing & Quality

Before moving to Level 14, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Test Types
Match the test type to its purpose:

| Test Type | Purpose |
|-----------|---------|
| Unit test | ___ |
| Widget test | ___ |
| Integration test | ___ |

<details>
<summary>Check Answers</summary>

| Test Type | Purpose |
|-----------|---------|
| Unit test | Test single functions/classes in isolation |
| Widget test | Test individual widgets render correctly |
| Integration test | Test complete features/flows on real device |

</details>

---

### 2. Unit Test Structure
What does each part do?

```dart
void main() {
  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    tearDown(() {
      cart.clear();
    });

    test('adds item correctly', () {
      cart.addItem(product);
      expect(cart.itemCount, equals(1));
    });
  });
}
```

<details>
<summary>Check Answer</summary>

- **group**: Organizes related tests together
- **setUp**: Runs before EACH test (fresh cart each time)
- **tearDown**: Runs after EACH test (cleanup)
- **test**: Individual test case
- **expect**: Asserts expected outcome

</details>

---

### 3. Common Matchers
What does each matcher check?

```dart
expect(value, equals(5));
expect(list, contains('item'));
expect(value, isNull);
expect(value, isNotNull);
expect(number, greaterThan(10));
expect(() => func(), throwsException);
expect(list, hasLength(3));
```

<details>
<summary>Check Answers</summary>

- `equals(5)`: Value equals 5
- `contains('item')`: List contains 'item'
- `isNull`: Value is null
- `isNotNull`: Value is not null
- `greaterThan(10)`: Number > 10
- `throwsException`: Function throws an exception
- `hasLength(3)`: Collection has 3 items

</details>

---

### 4. Widget Testing
What does this test verify?

```dart
testWidgets('ProductCard displays product info', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProductCard(product: testProduct),
    ),
  );

  expect(find.text('Test Product'), findsOneWidget);
  expect(find.text('\$29.99'), findsOneWidget);
  expect(find.byType(Image), findsOneWidget);

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  expect(find.text('Added!'), findsOneWidget);
});
```

<details>
<summary>Check Answer</summary>

This test verifies:
1. ProductCard renders with MaterialApp wrapper
2. Product name "Test Product" appears
3. Price "$29.99" appears
4. An Image widget exists
5. Tapping the button changes text to "Added!"

Key methods:
- `pumpWidget`: Builds the widget
- `find.text`: Finds widgets with specific text
- `tap`: Simulates tap gesture
- `pump`: Processes pending frames

</details>

---

### 5. Mocking
Why and how do you mock dependencies?

```dart
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late ProductsProvider provider;

  setUp(() {
    mockApi = MockApiService();
    provider = ProductsProvider(api: mockApi);
  });

  test('loads products from API', () async {
    when(() => mockApi.getProducts()).thenAnswer(
      (_) async => [testProduct],
    );

    await provider.loadProducts();

    expect(provider.products.length, 1);
    verify(() => mockApi.getProducts()).called(1);
  });
}
```

<details>
<summary>Check Answer</summary>

**Why mock:**
- Test in isolation (no real API calls)
- Control exact responses
- Test error scenarios
- Faster tests

**How:**
- `Mock implements ApiService`: Create fake implementation
- `when().thenAnswer()`: Define fake behavior
- `verify().called()`: Confirm mock was called

</details>

---

### 6. Test Coverage
What does this output mean?

```
lib/models/product.dart        100.0%
lib/services/api_service.dart   75.0%
lib/providers/cart_provider.dart 90.0%
lib/screens/home_screen.dart    45.0%

Overall: 72.5%
```

<details>
<summary>Check Answer</summary>

- **product.dart 100%**: All code paths tested
- **api_service.dart 75%**: Some branches/errors not tested
- **cart_provider.dart 90%**: Almost complete
- **home_screen.dart 45%**: Needs more widget tests

**72.5% overall**: Good start, aim for 80%+ for critical code.

Low coverage areas need attention - especially business logic.

</details>

---

## Hands-On Check

### Task 1: Write Unit Tests
Test this Cart class:

```dart
class Cart {
  final List<CartItem> _items = [];

  void addItem(Product product, [int quantity = 1]);
  void removeItem(String productId);
  void updateQuantity(String productId, int quantity);
  void clear();

  int get itemCount;
  double get total;
}
```

<details>
<summary>Example Solution</summary>

```dart
void main() {
  group('Cart', () {
    late Cart cart;
    late Product testProduct;

    setUp(() {
      cart = Cart();
      testProduct = Product(
        id: '1',
        name: 'Test Product',
        price: 10.0,
        imageUrl: '',
      );
    });

    group('addItem', () {
      test('adds new item to empty cart', () {
        cart.addItem(testProduct);

        expect(cart.itemCount, 1);
        expect(cart.items.first.product.id, '1');
      });

      test('increases quantity for existing item', () {
        cart.addItem(testProduct);
        cart.addItem(testProduct);

        expect(cart.itemCount, 2);
        expect(cart.items.length, 1); // Same product
      });

      test('adds multiple items with quantity', () {
        cart.addItem(testProduct, 3);

        expect(cart.itemCount, 3);
      });
    });

    group('removeItem', () {
      test('removes item from cart', () {
        cart.addItem(testProduct);
        cart.removeItem('1');

        expect(cart.itemCount, 0);
      });

      test('does nothing for non-existent item', () {
        cart.addItem(testProduct);
        cart.removeItem('999');

        expect(cart.itemCount, 1);
      });
    });

    group('updateQuantity', () {
      test('updates item quantity', () {
        cart.addItem(testProduct);
        cart.updateQuantity('1', 5);

        expect(cart.itemCount, 5);
      });

      test('removes item when quantity is 0', () {
        cart.addItem(testProduct);
        cart.updateQuantity('1', 0);

        expect(cart.itemCount, 0);
      });
    });

    group('total', () {
      test('calculates total correctly', () {
        cart.addItem(testProduct, 3); // 3 x $10 = $30

        expect(cart.total, 30.0);
      });

      test('returns 0 for empty cart', () {
        expect(cart.total, 0.0);
      });
    });

    group('clear', () {
      test('removes all items', () {
        cart.addItem(testProduct, 5);
        cart.clear();

        expect(cart.itemCount, 0);
        expect(cart.total, 0.0);
      });
    });
  });
}
```

</details>

---

### Task 2: Write Widget Test
Test the AddToCartButton widget:

```dart
class AddToCartButton extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  // Shows "Add to Cart" normally
  // Shows "Added!" after tap
}
```

<details>
<summary>Example Solution</summary>

```dart
void main() {
  testWidgets('AddToCartButton shows correct states', (tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddToCartButton(
            product: testProduct,
            onPressed: () => wasPressed = true,
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);

    // Tap button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // After tap
    expect(wasPressed, isTrue);
  });

  testWidgets('AddToCartButton shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddToCartButton(
            product: testProduct,
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Add to Cart'), findsNothing);
  });
}
```

</details>

---

### Task 3: Mock API Service
Test ProductsProvider with mocked API:

```dart
class ProductsProvider extends ChangeNotifier {
  final ApiService api;

  Future<void> loadProducts();
  // Should handle success and error cases
}
```

<details>
<summary>Example Solution</summary>

```dart
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;
  late ProductsProvider provider;

  setUp(() {
    mockApi = MockApiService();
    provider = ProductsProvider(api: mockApi);
  });

  group('ProductsProvider', () {
    test('loads products successfully', () async {
      final products = [
        Product(id: '1', name: 'Product 1', price: 10.0, imageUrl: ''),
        Product(id: '2', name: 'Product 2', price: 20.0, imageUrl: ''),
      ];

      when(() => mockApi.getProducts()).thenAnswer((_) async => products);

      await provider.loadProducts();

      expect(provider.products.length, 2);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      verify(() => mockApi.getProducts()).called(1);
    });

    test('handles API error', () async {
      when(() => mockApi.getProducts()).thenThrow(
        ApiException('Network error'),
      );

      await provider.loadProducts();

      expect(provider.products, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, 'Network error');
    });

    test('sets loading state during fetch', () async {
      when(() => mockApi.getProducts()).thenAnswer(
        (_) => Future.delayed(Duration(seconds: 1), () => []),
      );

      final future = provider.loadProducts();
      expect(provider.isLoading, true);

      await future;
      expect(provider.isLoading, false);
    });
  });
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Unit test | _________________ |
| Widget test | _________________ |
| Integration test | _________________ |
| Mock | _________________ |
| Stub | _________________ |
| Test coverage | _________________ |
| Matcher | _________________ |
| Finder | _________________ |

---

## Ready for Level 14?

### I can confidently:
- [ ] Write unit tests for functions and classes
- [ ] Use group, setUp, tearDown, test
- [ ] Use common matchers (equals, contains, throws, etc.)
- [ ] Write widget tests with testWidgets
- [ ] Use finders (find.text, find.byType, etc.)
- [ ] Simulate user interactions (tap, enterText, scroll)
- [ ] Create mocks with mocktail or mockito
- [ ] Set up mock responses with when/thenAnswer
- [ ] Verify mock calls with verify
- [ ] Run tests and check coverage

### Capstone Progress:
- [ ] Unit tests for Cart and Product models
- [ ] Widget tests for ProductCard and CartItemTile
- [ ] Mocked API tests for providers
- [ ] 70%+ test coverage on business logic

---

## If You're Stuck

**Common issues at this level:**

1. **"Widget not found" in tests**
   - Wrap widget in MaterialApp
   - Call pump() after actions
   - Check widget is actually rendered

2. **Async tests failing**
   - Use async/await properly
   - Use pumpAndSettle() for animations
   - Use pump(Duration) for timers

3. **Mocks not working**
   - Extend Mock, implement interface
   - Set up when() before calling method
   - Use thenAnswer for async, thenReturn for sync

4. **Coverage not increasing**
   - Test error branches
   - Test edge cases (empty, null, max values)
   - Test all public methods

---

**Ready to level up? Head to Level 14: Animations & Polish!**
