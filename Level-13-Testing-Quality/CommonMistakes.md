# Level 13: Common Mistakes

Learn from these common testing errors!

---

## Mistake #1: Not Wrapping Widget in MaterialApp

```dart
// ❌ WRONG - Missing scaffold/theme
testWidgets('shows button', (tester) async {
  await tester.pumpWidget(MyButton());  // Error: No Material ancestor!
});

// ✅ RIGHT
testWidgets('shows button', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MyButton(),
      ),
    ),
  );
});
```

---

## Mistake #2: Forgetting to pump()

```dart
// ❌ WRONG - UI not updated
testWidgets('button tap changes text', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.tap(find.byType(ElevatedButton));
  // No pump after tap!
  expect(find.text('Tapped!'), findsOneWidget);  // Fails!
});

// ✅ RIGHT
testWidgets('button tap changes text', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();  // Process the rebuild
  expect(find.text('Tapped!'), findsOneWidget);
});
```

---

## Mistake #3: Using pump() Instead of pumpAndSettle()

```dart
// ❌ WRONG - Animation not complete
testWidgets('dialog appears', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.tap(find.text('Show Dialog'));
  await tester.pump();  // Dialog might still be animating
  expect(find.byType(AlertDialog), findsOneWidget);  // Might fail!
});

// ✅ RIGHT
testWidgets('dialog appears', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.tap(find.text('Show Dialog'));
  await tester.pumpAndSettle();  // Wait for animations
  expect(find.byType(AlertDialog), findsOneWidget);
});
```

---

## Mistake #4: Wrong Finder

```dart
// ❌ WRONG - finds both "Add" and "Add to Cart"
expect(find.text('Add'), findsOneWidget);  // Might find 2!

// ✅ RIGHT - Be specific
expect(find.text('Add to Cart'), findsOneWidget);

// Or use widgetWithText
expect(
  find.widgetWithText(ElevatedButton, 'Add'),
  findsOneWidget,
);
```

---

## Mistake #5: Testing Implementation, Not Behavior

```dart
// ❌ WRONG - Testing internal state
test('adds item', () {
  cart.addItem(product);
  expect(cart._items.length, 1);  // Testing private field!
});

// ✅ RIGHT - Test observable behavior
test('adds item', () {
  cart.addItem(product);
  expect(cart.itemCount, 1);  // Test public API
  expect(cart.contains(product), true);
});
```

---

## Mistake #6: Not Mocking Dependencies

```dart
// ❌ WRONG - Makes real API calls
test('loads products', () async {
  final provider = ProductsProvider();  // Uses real API!
  await provider.loadProducts();
  expect(provider.products.isNotEmpty, true);  // Flaky!
});

// ✅ RIGHT - Mock the API
test('loads products', () async {
  final mockApi = MockApiService();
  when(() => mockApi.getProducts()).thenAnswer((_) async => [testProduct]);

  final provider = ProductsProvider(api: mockApi);
  await provider.loadProducts();

  expect(provider.products.length, 1);
  verify(() => mockApi.getProducts()).called(1);
});
```

---

## Mistake #7: Missing setUp/tearDown

```dart
// ❌ WRONG - Tests affect each other
test('adds item', () {
  cart.addItem(product1);
  expect(cart.itemCount, 1);
});

test('adds another item', () {
  cart.addItem(product2);
  expect(cart.itemCount, 1);  // Fails! Cart still has item from previous test
});

// ✅ RIGHT
late Cart cart;

setUp(() {
  cart = Cart();  // Fresh cart for each test
});

test('adds item', () {
  cart.addItem(product1);
  expect(cart.itemCount, 1);
});

test('adds another item', () {
  cart.addItem(product2);
  expect(cart.itemCount, 1);  // Works!
});
```

---

## Mistake #8: Async Test Without async/await

```dart
// ❌ WRONG - Test completes before async operation
test('loads data', () {
  provider.loadData();  // Missing await!
  expect(provider.data, isNotEmpty);  // Fails - not loaded yet
});

// ✅ RIGHT
test('loads data', () async {
  await provider.loadData();
  expect(provider.data, isNotEmpty);
});
```

---

## Mistake #9: Not Testing Error Cases

```dart
// ❌ WRONG - Only happy path
test('login works', () async {
  await auth.login('user@email.com', 'password');
  expect(auth.isLoggedIn, true);
});

// ✅ RIGHT - Also test errors
test('login works', () async {
  await auth.login('user@email.com', 'password');
  expect(auth.isLoggedIn, true);
});

test('login fails with wrong password', () async {
  expect(
    () => auth.login('user@email.com', 'wrong'),
    throwsA(isA<AuthException>()),
  );
});

test('login fails with invalid email', () async {
  expect(
    () => auth.login('invalid', 'password'),
    throwsA(isA<AuthException>()),
  );
});
```

---

## Mistake #10: Tests Not Isolated

```dart
// ❌ WRONG - Depends on global state
test('increments counter', () {
  globalCounter++;  // Affects other tests!
  expect(globalCounter, 1);
});

// ✅ RIGHT - Each test is independent
test('increments counter', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, 1);
});
```

---

## Quick Reference: Testing Methods

| Method | When to Use |
|--------|-------------|
| `pump()` | After actions that cause rebuild |
| `pumpAndSettle()` | After actions with animations |
| `find.text()` | Find by exact text |
| `find.byType()` | Find by widget type |
| `find.byKey()` | Find by Key |
| `expect()` | Assert expected outcome |
| `when().thenReturn()` | Mock sync method |
| `when().thenAnswer()` | Mock async method |
| `verify().called(n)` | Verify mock was called |

---

**Still stuck? Re-read the Theory files or ask for help!**
