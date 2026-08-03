# Integration Testing: The Whole App, For Real

## The Big Idea In One Sentence

> An integration test runs your **real app** on a real device or emulator and drives it like a user, so it catches the things unit and widget tests structurally cannot.

---

## The Pyramid, And Where This Sits

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│                    ╱╲                                │
│                   ╱  ╲   INTEGRATION                 │
│                  ╱    ╲  few, slow (seconds each),   │
│                 ╱      ╲ real device, highest        │
│                ╱________╲ confidence                 │
│               ╱          ╲                           │
│              ╱   WIDGET   ╲ some, fast (ms),         │
│             ╱              ╲ one screen at a time    │
│            ╱________________╲                        │
│           ╱                  ╲                       │
│          ╱       UNIT         ╲ many, instant,       │
│         ╱                      ╲ pure logic          │
│        ╱________________________╲                    │
│                                                      │
│   Rough shape: many unit, some widget, a handful of  │
│   integration tests covering the flows that make     │
│   money (sign up, checkout, the core action).        │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Setup

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

Integration tests live in `integration_test/` at the project root, **not** in `test/`.

```
myapp/
├── lib/
├── test/                       unit + widget tests
└── integration_test/
    ├── app_test.dart
    └── checkout_flow_test.dart
```

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end', () {
    testWidgets('a user can sign in and see their dashboard', (tester) async {
      app.main();                       // the REAL app
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'password123');
      await tester.tap(find.byKey(const Key('sign_in')));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

The only structural differences from a widget test: `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` at the top, and you launch the real `app.main()` instead of a single widget.

---

## Running Them

```bash
# On a connected device or a running emulator
flutter test integration_test/app_test.dart

# Everything in the folder
flutter test integration_test

# On a specific device
flutter test integration_test/app_test.dart -d emulator-5554

# On Chrome (needs chromedriver running on port 4444)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome
```

They need a device. That is the point, and it is also why you keep them few: each one costs seconds, not milliseconds.

---

## A Realistic Flow Test

```dart
testWidgets('a user can buy an item', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Browse
  await tester.tap(find.byKey(const Key('tab_shop')));
  await tester.pumpAndSettle();

  // Open the first product
  await tester.tap(find.byType(ProductCard).first);
  await tester.pumpAndSettle();

  // Add to cart
  await tester.tap(find.byKey(const Key('add_to_cart')));
  await tester.pumpAndSettle();

  expect(find.text('1'), findsOneWidget);          // the badge

  // Checkout
  await tester.tap(find.byKey(const Key('cart_button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('checkout')));
  await tester.pumpAndSettle();

  // Pay with the test card
  await tester.enterText(find.byKey(const Key('card_number')), '4242424242424242');
  await tester.tap(find.byKey(const Key('pay')));

  // A network call: settle can time out, so wait deliberately
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();

  expect(find.text('Order confirmed'), findsOneWidget);
});
```

Notice the keys everywhere. Integration tests are the strongest argument for putting `Key`s on interactive widgets as you build them: the alternative is a test that breaks every time a label changes.

---

## Real Backend Or Fake Backend?

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   AGAINST A STAGING BACKEND                          │
│   + tests the real contract, end to end              │
│   - slow, flaky, needs test data and a reset,        │
│     fails when staging is down                       │
│                                                      │
│   AGAINST A FAKE BACKEND (recommended default)       │
│   + fast and deterministic                           │
│   + you can force a 500 or a timeout on demand       │
│   - does not catch a backend contract change         │
│                                                      │
│   Common answer: fakes for the main suite in CI,     │
│   plus a very small "smoke" suite against staging    │
│   run nightly.                                       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Swapping the backend is easy if you built the app the way Part 2 described:

```dart
// lib/main.dart
Future<void> main({ApiClient? apiOverride}) async {
  final api = apiOverride ?? ApiClient(buildDio());
  runApp(App(repository: ProductRepository(api)));
}

// integration_test/app_test.dart
app.main(apiOverride: FakeApiClient());
```

Injection is not academic. It is what makes an end to end test runnable in CI.

---

## Performance Measurement

Integration tests can also record how fast your app runs:

```dart
testWidgets('the feed scrolls at 60fps', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  final binding = IntegrationTestWidgetsFlutterBinding.instance;

  await binding.traceAction(
    () async {
      await tester.fling(find.byType(ListView), const Offset(0, -500), 3000);
      await tester.pumpAndSettle();
    },
    reportKey: 'scrolling_timeline',
  );
});
```

The timeline output can be turned into frame build times, so a pull request that makes scrolling slower fails CI rather than shipping.

---

## Screenshots

```dart
testWidgets('capture the dashboard', (tester) async {
  final binding = IntegrationTestWidgetsFlutterBinding.instance;

  app.main();
  await tester.pumpAndSettle();

  await binding.convertFlutterSurfaceToImage();   // Android needs this
  await tester.pumpAndSettle();
  await binding.takeScreenshot('dashboard');
});
```

Teams use this to generate store screenshots for every locale automatically, instead of taking hundreds by hand.

---

## Making Them Reliable

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Use Keys, never labels, for interaction          │
│   • Reset state between tests (fresh install, or a   │
│     "clear storage" call in setUp)                   │
│   • Never depend on test ORDER                       │
│   • Prefer a fake backend so results are             │
│     deterministic                                    │
│   • Replace pumpAndSettle with pump(Duration) around │
│     indefinite spinners                              │
│   • Keep them few: the flows that lose money if      │
│     they break                                       │
│   • A flaky test that people re-run is worse than    │
│     no test: fix it or delete it                     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Running In CI

```yaml
# .github/workflows/test.yml (the important steps)
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.38.4'

- run: flutter pub get
- run: flutter analyze
- run: flutter test --coverage             # unit + widget: no device needed

- uses: reactivecircus/android-emulator-runner@v2
  with:
    api-level: 34
    script: flutter test integration_test   # integration: needs the emulator
```

Unit and widget tests run on every push because they are fast. Integration tests usually run on the main branch or nightly because they need an emulator and take minutes.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • integration_test/ folder, real app.main()        │
│   • IntegrationTestWidgetsFlutterBinding first line  │
│   • flutter test integration_test, with a device     │
│   • Keys everywhere, no label based finders          │
│   • Inject a fake backend for determinism            │
│   • traceAction for performance, takeScreenshot for  │
│     store images                                     │
│   • Few tests, covering the flows that matter        │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What are the two structural differences between a widget test and an integration test?

<details>
<summary>Answer</summary>
An integration test calls `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` and launches the real `app.main()`, and it runs on an actual device or emulator rather than in a headless fake screen.
</details>

**Q2.** Why do integration tests belong in `integration_test/` rather than `test/`?

<details>
<summary>Answer</summary>
`flutter test` runs everything in `test/` headlessly on the host, where integration tests would fail. Keeping them in their own folder lets the fast suite run on every push and the device suite run separately.
</details>

**Q3.** Should integration tests hit your real backend?

<details>
<summary>Answer</summary>
Usually not for the main suite. Inject a fake so tests are fast and deterministic, and keep a very small smoke suite against staging to catch contract changes.
</details>

---

## Assignment

### Problem 1: Write the skeleton

Write the first six lines of an integration test file for an app whose entry point is `lib/main.dart`.

### Problem 2: Diagnose the flake

Your checkout test passes locally and fails in CI roughly half the time, always at the payment step. Give two likely causes and a fix for each.

### Problem 3: Pick the tests

You have time for exactly three integration tests in a food delivery app. Which flows?

### Problem 4: Make it injectable

Show the change to `main()` that lets an integration test supply a fake API.

---

## Assignment Answers

### Problem 1: Write the skeleton

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // tests go here
}
```

### Problem 2: Diagnose the flake

1. It waits on a real network call whose timing varies. Fix: inject a fake API so the response is instant and deterministic.
2. `pumpAndSettle` races with an indefinite spinner or an animation. Fix: pump a specific duration around that step, then settle, and assert on a stable key rather than a transient one.

(Another common cause: leftover state from a previous run, fixed by clearing storage in `setUp`.)

### Problem 3: Pick the tests

1. Sign up or sign in, because nobody can use the app without it.
2. Search, add to cart, and place an order, because that is the revenue path.
3. Track an order and see its live status, because it is the most used screen after ordering and it touches real time updates.

### Problem 4: Make it injectable

```dart
// lib/main.dart
Future<void> main({ApiClient? apiOverride}) async {
  final api = apiOverride ?? ApiClient(buildDio());
  runApp(App(repository: ProductRepository(api)));
}

// integration_test/app_test.dart
app.main(apiOverride: FakeApiClient());
```

---

## Navigation

⬅️ **Previous:** [Widget Testing](06b-WidgetTesting.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Testing The Whole Stack](06d-TestingTheStack.md)
