# Unit Testing: Proving The Logic Works

## The Big Idea In One Sentence

> A unit test runs one piece of Dart with no Flutter, no network, and no device, and it either passes in milliseconds or tells you exactly what broke.

---

## The Shape Of Every Test

```dart
// test/cart_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/cart.dart';

void main() {
  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart();          // fresh for EVERY test
    });

    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.total, 0);
    });

    test('adding an item increases the total', () {
      // Arrange
      const item = Item(name: 'Shoe', price: 50);

      // Act
      cart.add(item);

      // Assert
      expect(cart.items, hasLength(1));
      expect(cart.total, 50);
    });
  });
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   ARRANGE   set up the world                         │
│   ACT       do the one thing you are testing         │
│   ASSERT    check exactly what should have changed   │
│                                                      │
│   One behaviour per test. A test named               │
│   "test everything" is a test nobody can debug.      │
│                                                      │
│   Test NAMES are documentation. Write them as        │
│   sentences: "returns an empty list when the query   │
│   is blank".                                         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

`setUp` runs before each test, `tearDown` after each, and `setUpAll`/`tearDownAll` run once for the whole group. Prefer `setUp`: shared mutable state between tests is the classic source of "passes alone, fails in the suite".

---

## Running Them

```bash
flutter test                          # everything
flutter test test/cart_test.dart      # one file
flutter test --name "increases"       # tests whose name matches
flutter test --coverage               # writes coverage/lcov.info
```

Turn coverage into a readable report:

```bash
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

Coverage is a smoke detector, not a goal. 100 percent coverage with weak assertions proves nothing; 70 percent covering all the money-related logic is worth much more.

---

## Matchers Worth Memorising

```dart
expect(value, 42);                       // ==
expect(value, equals(42));               // the same, explicit
expect(list, [1, 2, 3]);                 // deep equality for collections
expect(list, hasLength(3));
expect(list, contains(2));
expect(list, isEmpty);
expect(name, isNotNull);
expect(name, isA<String>());
expect(price, greaterThan(0));
expect(price, closeTo(19.99, 0.001));    // doubles: never use ==
expect(text, startsWith('Hello'));
expect(map, containsPair('id', 7));

// Exceptions
expect(() => cart.remove('nope'), throwsA(isA<ItemNotFoundException>()));
expect(() => Age(-1), throwsArgumentError);

// Futures
await expectLater(future, completes);
await expectLater(future, throwsA(isA<TimeoutException>()));

// Streams
await expectLater(stream, emitsInOrder([1, 2, 3, emitsDone]));
```

`closeTo` for doubles is the one people learn the hard way: `0.1 + 0.2 == 0.3` is false in every language with binary floating point.

---

## Testing Async Code

```dart
test('fetches the user', () async {
  final user = await repository.getUser('1');    // await, and mark the test async
  expect(user.name, 'Ada');
});

test('throws when the id is unknown', () async {
  await expectLater(
    repository.getUser('nope'),
    throwsA(isA<NotFoundFailure>()),
  );
});
```

Forgetting `async`/`await` makes a test pass while the assertion never runs. If a test passes suspiciously fast and you did not await anything, check that first.

For code that depends on time, use `fakeAsync` instead of real delays:

```dart
import 'package:fake_async/fake_async.dart';

test('debounce waits 300ms', () {
  fakeAsync((async) {
    var calls = 0;
    final debouncer = Debouncer(const Duration(milliseconds: 300));

    debouncer.run(() => calls++);
    debouncer.run(() => calls++);
    async.elapse(const Duration(milliseconds: 299));
    expect(calls, 0);

    async.elapse(const Duration(milliseconds: 1));
    expect(calls, 1);
  });
});
```

A suite that sleeps for real seconds is a suite people stop running.

---

## Test Doubles: Fake, Mock, Stub

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   FAKE   a real working implementation, simplified   │
│          (an in-memory repository)                   │
│          -> best default. Simple, no library.        │
│                                                      │
│   STUB   returns canned answers                      │
│          "when asked for user 1, return Ada"         │
│                                                      │
│   MOCK   a stub that also RECORDS calls, so you can  │
│          assert "save() was called exactly once"     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### A fake, hand written

```dart
class FakeUserRepository implements UserRepository {
  FakeUserRepository(this._users);

  final Map<String, User> _users;

  @override
  Future<User> getUser(String id) async {
    final user = _users[id];
    if (user == null) throw const AppFailure.notFound();
    return user;
  }
}
```

No package, no magic, and it works for most tests.

### mocktail, when you need call verification

```yaml
dev_dependencies:
  mocktail: ^1.0.5
```

```dart
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;

  setUp(() => repository = MockUserRepository());

  test('returns the user the repository provides', () async {
    when(() => repository.getUser(any()))
        .thenAnswer((_) async => const User(id: '1', name: 'Ada'));

    final service = ProfileService(repository);
    final result = await service.load('1');

    expect(result.name, 'Ada');
    verify(() => repository.getUser('1')).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('surfaces repository failures', () async {
    when(() => repository.getUser(any()))
        .thenThrow(const AppFailure.notFound());

    final service = ProfileService(repository);

    expect(() => service.load('1'), throwsA(isA<NotFoundFailure>()));
  });
}
```

Cheat sheet:

```dart
when(() => repo.get()).thenReturn(value);            // sync
when(() => repo.get()).thenAnswer((_) async => v);   // async
when(() => repo.get()).thenThrow(error);
verify(() => repo.save(any())).called(1);
verifyNever(() => repo.delete(any()));
registerFallbackValue(FakeUser());                   // for any() of a custom type
```

`mocktail` needs no code generation. `mockito` does the same job with `@GenerateMocks` plus `build_runner`, and both are common in job adverts. If a codebase already uses one, use that one.

---

## What To Actually Test

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   TEST                          SKIP                 │
│   ────                          ────                 │
│   business rules                getters that return  │
│   (pricing, discounts,          a field              │
│    validation, permissions)                          │
│                                                      │
│   edge cases                    the framework itself │
│   (empty, null, zero,           (Flutter's own       │
│    negative, huge, unicode)      widgets are tested) │
│                                                      │
│   error paths                   generated code       │
│   (timeout, 401, malformed)                          │
│                                                      │
│   bugs you just fixed           third party packages │
│   (write the test FIRST, so                          │
│    it can never come back)                           │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The regression rule is the one that pays off most: every bug report becomes a failing test, then a fix. That is how a codebase stops repeating its mistakes, and it is a great thing to say in an interview.

---

## Testing A Cubit Without bloc_test

```dart
test('emits loading then loaded', () async {
  final cubit = ProfileCubit(FakeUserRepository({'1': ada}));

  expectLater(
    cubit.stream,
    emitsInOrder([
      isA<ProfileLoading>(),
      isA<ProfileLoaded>(),
    ]),
  );

  await cubit.load('1');
  await cubit.close();
});
```

`bloc_test` (next lessons) wraps this pattern, but knowing the raw version proves you understand that a cubit is just a stream.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Arrange, Act, Assert; one behaviour per test     │
│   • setUp for a fresh object per test                │
│   • Name tests as sentences                          │
│   • closeTo for doubles, expectLater for futures     │
│   • fakeAsync instead of real delays                 │
│   • Fakes first, mocktail when you must verify calls │
│   • Test rules, edge cases, error paths, regressions │
│   • Coverage is a signal, not a target               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why put object creation in `setUp` instead of above `main`?

<details>
<summary>Answer</summary>
So every test gets a fresh instance. Shared mutable state leaks results between tests and causes failures that depend on test order.
</details>

**Q2.** What is the difference between a fake and a mock?

<details>
<summary>Answer</summary>
A fake is a simplified but real implementation (an in-memory repository). A mock returns canned answers and records the calls made, so you can verify interactions.
</details>

**Q3.** A test passes instantly but the assertion is never checked. What is the likely cause?

<details>
<summary>Answer</summary>
A missing `await` (or a missing `async` on the test), so the future had not completed when the test finished.
</details>

---

## Assignment

### Problem 1: Write the test

`Discount.apply(price, percent)` should throw for a percent above 100. Write the test.

### Problem 2: Fix the flake

```dart
final cart = Cart();

test('a', () => cart.add(item));
test('b', () => expect(cart.items, isEmpty));
```

Why does `b` fail, and how do you fix it?

### Problem 3: Choose the double

You are testing that `AuthService.logout()` clears the token. Fake or mock, and why?

### Problem 4: Time travel

A session expires after 30 minutes. How do you test that without waiting 30 minutes?

---

## Assignment Answers

### Problem 1: Write the test

```dart
test('throws when the percent is above 100', () {
  expect(() => Discount.apply(100, 120), throwsArgumentError);
});
```

### Problem 2: Fix the flake

`cart` is shared, so test `a` mutates the object test `b` inspects, and the result depends on order. Create it in `setUp`:

```dart
late Cart cart;
setUp(() => cart = Cart());
```

### Problem 3: Choose the double

A mock, because the behaviour under test is an interaction: you want to `verify(() => storage.delete('token')).called(1)`. A fake would let you assert the resulting state instead, which is also acceptable, but the mock states the intent directly.

### Problem 4: Time travel

Wrap the test in `fakeAsync` and call `async.elapse(const Duration(minutes: 30))`, or inject a clock (`DateTime Function() now`) so the test can supply a later time.

---

## Navigation

⬅️ **Previous:** [Retrofit API Clients](05d-Retrofit.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Widget Testing](06b-WidgetTesting.md)
