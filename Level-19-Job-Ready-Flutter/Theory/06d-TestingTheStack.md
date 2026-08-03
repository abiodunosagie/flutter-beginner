# Testing The Whole Stack: Blocs, Repositories, Router

## The Big Idea In One Sentence

> Each layer has a matching test tool: `bloc_test` for blocs and cubits, mocks for repositories, a real `GoRouter` with a fake auth object for redirects, and a mock messenger for platform channels.

---

## bloc_test: The Whole API

```yaml
dev_dependencies:
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
```

```dart
blocTest<CounterCubit, int>(
  'emits [1, 2] when increment is called twice',
  build: CounterCubit.new,
  act: (cubit) => cubit..increment()..increment(),
  expect: () => const <int>[1, 2],
);
```

Every parameter, and when you need it:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   setUp:   stub your mocks BEFORE build runs         │
│   build:   create the bloc/cubit, return it          │
│   seed:    start from a given state instead of the   │
│            initial one                               │
│   act:     do the thing under test                   │
│   wait:    give async work time to finish            │
│   skip:    ignore the first N emitted states         │
│   expect:  the list of states you expect, in order   │
│   verify:  extra assertions after act completes      │
│   errors:  expect the bloc to emit errors            │
│   tearDown: clean up                                 │
│                                                      │
│   NOTE: `expect` lists the states AFTER the initial  │
│   one. The initial state is never included.          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```dart
blocTest<CartCubit, CartState>(
  'removing the last item empties the cart',
  build: () => CartCubit(repository),
  seed: () => CartState(items: [itemA]),            // start mid-flow
  act: (cubit) => cubit.remove(itemA.id),
  expect: () => [const CartState(items: [])],
  verify: (cubit) {
    verify(() => repository.saveCart(any())).called(1);
  },
);
```

`seed` is the parameter people miss. Without it you have to replay five actions to reach the state you actually want to test.

### Matching states loosely

When a state carries something unpredictable (a timestamp, a generated id), match by type or by predicate:

```dart
expect: () => [
  isA<SearchLoading>(),
  isA<SearchSuccess>().having((s) => s.results.length, 'result count', 2),
],
```

`.having(selector, description, matcher)` is the cleanest way to assert on one field of a state without writing the whole object.

---

## Testing A Bloc With A Mocked Repository

```dart
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository repository;

  setUp(() {
    repository = MockProductRepository();
  });

  group('ProductsCubit', () {
    blocTest<ProductsCubit, ProductsState>(
      'emits loading then loaded on success',
      setUp: () {
        when(() => repository.getProducts())
            .thenAnswer((_) async => [productA, productB]);
      },
      build: () => ProductsCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProductsLoading(),
        ProductsLoaded([productA, productB]),
      ],
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits loading then failed when the repository throws',
      setUp: () {
        when(() => repository.getProducts())
            .thenThrow(const AppFailure.noConnection());
      },
      build: () => ProductsCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProductsLoading(),
        const ProductsFailed('You appear to be offline.'),
      ],
    );
  });
}
```

Two tests, and the whole happy path plus the whole failure path are locked in. This pair is the single most valuable test you can write for a feature, and it is a great thing to demonstrate live in an interview.

---

## Testing The Repository Itself

The repository's job is mapping, so test the mapping.

```dart
class MockProductApi extends Mock implements ProductApi {}

test('maps a 404 to NotFoundFailure', () async {
  final api = MockProductApi();
  when(() => api.getProduct(any())).thenThrow(
    DioException(
      requestOptions: RequestOptions(path: '/products/9'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/products/9'),
        statusCode: 404,
      ),
    ),
  );

  final repository = ProductRepository(api);

  expect(
    () => repository.getProduct('9'),
    throwsA(isA<NotFoundFailure>()),
  );
});
```

Repeat for a timeout, a connection error, and a 401. Those four tests mean no screen in your app ever shows a raw `DioException` to a user.

---

## Testing go_router Redirects

Build the router from a function that accepts the auth object, then drive it with a real `MaterialApp.router`.

```dart
GoRouter buildRouter(AuthNotifier auth) => GoRouter(
      initialLocation: '/profile',
      refreshListenable: auth,
      redirect: (context, state) {
        final goingToLogin = state.matchedLocation == '/login';
        if (!auth.signedIn && !goingToLogin) return '/login';
        if (auth.signedIn && goingToLogin) return '/profile';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
      ],
    );

void main() {
  testWidgets('a signed out user is sent to login', (tester) async {
    final auth = AuthNotifier();

    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter(auth)));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('signing in moves the user off the login page', (tester) async {
    final auth = AuthNotifier();
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter(auth)));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    auth.setSignedIn(true);          // refreshListenable fires
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
```

The second test proves the `refreshListenable` wiring works, which is the piece most likely to be wrong. Guard logic is cheap to test and expensive to get wrong, so this is high value coverage.

---

## Testing Platform Channels

```dart
TestWidgetsFlutterBinding.ensureInitialized();

const channel = MethodChannel('com.example.myapp/battery');

setUp(() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'getBatteryLevel') return 42;
    return null;
  });
});

tearDown(() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
});
```

Always clear the handler in `tearDown`, or the fake native side leaks into other tests.

---

## Organising A Test Suite

```
test/
├── features/
│   ├── products/
│   │   ├── products_cubit_test.dart
│   │   ├── product_repository_test.dart
│   │   └── products_page_test.dart
│   └── auth/
│       └── ...
├── routing/
│   └── router_test.dart
├── helpers/
│   ├── pump_app.dart          shared widget test scaffolding
│   └── fixtures.dart          sample models used by many tests
└── flutter_test_config.dart   optional global setup
integration_test/
└── app_test.dart
```

The single most useful helper in any Flutter codebase:

```dart
// test/helpers/pump_app.dart
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<BlocProvider> providers = const [],
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: providers,
        child: MaterialApp(home: widget),
      ),
    );
  }
}

// every widget test becomes one line
await tester.pumpApp(const CartPage(), providers: [BlocProvider.value(value: cubit)]);
```

Mirror `lib/` in `test/`: for `lib/features/cart/cart_cubit.dart` write `test/features/cart/cart_cubit_test.dart`. Anyone can then find the test for any file without searching.

---

## What Good Coverage Looks Like

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   ALWAYS TEST                                        │
│   • every cubit/bloc: happy path AND failure path    │
│   • repository error mapping                         │
│   • router guards                                    │
│   • pure logic: pricing, validation, permissions     │
│   • any bug you fix (a regression test)              │
│                                                      │
│   USUALLY TEST                                       │
│   • screens with conditional rendering               │
│   • forms and their validation                       │
│   • responsive breakpoint switches                   │
│                                                      │
│   RARELY WORTH IT                                    │
│   • pure layout widgets with no logic                │
│   • generated code                                   │
│   • one line getters                                 │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Exclude generated files from the coverage number so it reflects your code:

```bash
flutter test --coverage
lcov --remove coverage/lcov.info \
  '*.g.dart' '*.freezed.dart' '*/generated/*' \
  -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
```

---

## The Testing Answer For Friday

> **Q: How do you test a Flutter app?**
>
> "Three layers. Unit tests for pure logic and for repositories, where I mock the API client and assert that each transport error maps to the right domain failure. `bloc_test` for every cubit and bloc, always with a happy path and a failure path, using `seed` when I need to start mid-flow and `.having` when a state carries values I cannot predict. Widget tests for screens, with the bloc mocked and dependencies provided by a shared `pumpApp` helper, plus golden tests for anything visually delicate. Then a handful of integration tests on a device for the flows that lose money if they break, running against a fake backend so CI is deterministic. Unit and widget tests run on every push; integration tests run nightly on an emulator."

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • bloc_test: setUp, build, seed, act, wait, skip,  │
│     expect, verify                                   │
│   • expect() excludes the initial state              │
│   • isA<T>().having(...) for unpredictable values    │
│   • Mock the repository for bloc tests, mock the     │
│     API for repository tests                         │
│   • Test router redirects with a real GoRouter and   │
│     a fake auth notifier                             │
│   • Clear mock channel handlers in tearDown          │
│   • Mirror lib/ in test/, share a pumpApp helper     │
│   • Strip generated files from coverage              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Does `expect:` in `blocTest` include the initial state?

<details>
<summary>Answer</summary>
No. It lists only the states emitted after the initial one. Including the initial state is a common cause of a confusing failure.
</details>

**Q2.** What does `seed:` do and why is it useful?

<details>
<summary>Answer</summary>
It starts the bloc from a given state instead of its initial one, so you can test a mid-flow behaviour (removing the last cart item, loading page three) without replaying every earlier action.
</details>

**Q3.** How do you assert on a state that contains a generated id?

<details>
<summary>Answer</summary>
Match by type and field: `isA<OrderPlaced>().having((s) => s.total, 'total', 49.99)`, so the unpredictable id is not part of the assertion.
</details>

---

## Assignment

### Problem 1: Write the pair

Write the two `blocTest` cases for a `LoginCubit` that emits `LoginInProgress` then either `LoginSucceeded` or `LoginFailed`.

### Problem 2: Choose the parameter

Which `blocTest` parameter for each: stub a mock before the bloc is built, start from a half filled cart, wait for a debounce, assert that the repository was called.

### Problem 3: Test the guard

Write the test proving that an admin only route redirects a normal user away.

### Problem 4: Clean the number

Your coverage says 91 percent but half of it is `.g.dart` files. What do you run?

---

## Assignment Answers

### Problem 1: Write the pair

```dart
blocTest<LoginCubit, LoginState>(
  'emits in progress then succeeded on valid credentials',
  setUp: () {
    when(() => auth.signIn(any(), any())).thenAnswer((_) async => user);
  },
  build: () => LoginCubit(auth),
  act: (cubit) => cubit.submit('a@b.com', 'secret'),
  expect: () => [const LoginInProgress(), LoginSucceeded(user)],
);

blocTest<LoginCubit, LoginState>(
  'emits in progress then failed on bad credentials',
  setUp: () {
    when(() => auth.signIn(any(), any()))
        .thenThrow(const AppFailure.unauthorised());
  },
  build: () => LoginCubit(auth),
  act: (cubit) => cubit.submit('a@b.com', 'wrong'),
  expect: () => [const LoginInProgress(), const LoginFailed('Please sign in again.')],
);
```

### Problem 2: Choose the parameter

- Stub a mock before build: `setUp`
- Start from a half filled cart: `seed`
- Wait for a debounce: `wait`
- Assert the repository was called: `verify`

### Problem 3: Test the guard

```dart
testWidgets('a normal user cannot reach /admin', (tester) async {
  final auth = AuthNotifier()..setUser(normalUser);
  final router = buildRouter(auth);

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  router.go('/admin');
  await tester.pumpAndSettle();

  expect(find.byType(AdminPage), findsNothing);
  expect(find.byType(ForbiddenPage), findsOneWidget);
});
```

### Problem 4: Clean the number

```bash
lcov --remove coverage/lcov.info '*.g.dart' '*.freezed.dart' -o coverage/lcov.info
```

Then regenerate the HTML report. The number now reflects code you actually wrote.

---

## Navigation

⬅️ **Previous:** [Integration Testing](06c-IntegrationTesting.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Interview Questions](../InterviewQuestions.md)
