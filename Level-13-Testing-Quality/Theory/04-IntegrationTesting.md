# Integration Testing

## The Big Idea In One Sentence

> An integration test drives the whole real app like a robot user, tapping through a complete flow (log in, add an item, see it appear), to prove the pieces work together.

## The Simple Explanation

Integration testing is like test-driving a car. You don't just check if the engine works alone - you drive the whole car to make sure everything works together!

```
┌─────────────────────────────────────────────────────────┐
│                INTEGRATION TESTING                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Test the COMPLETE user experience:                      │
│                                                          │
│  1. User opens app                                       │
│         ↓                                                │
│  2. User sees login screen                               │
│         ↓                                                │
│  3. User enters credentials                              │
│         ↓                                                │
│  4. User taps login button                               │
│         ↓                                                │
│  5. User sees home screen                                │
│         ↓                                                │
│  ✓ Test passes!                                          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### 1. Create Integration Test Folder

```
your_app/
├── lib/
├── test/               ← Unit & Widget tests
└── integration_test/   ← Integration tests (create this)
    └── app_test.dart
```

### 2. Add Dependency

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

### 3. Create Test File

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete app test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Your test here
  });
}
```

---

## Basic Integration Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Test', () {
    testWidgets('counter increments', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the counter text
      expect(find.text('0'), findsOneWidget);

      // Tap the increment button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify counter increased
      expect(find.text('1'), findsOneWidget);
    });
  });
}
```

---

## Running Integration Tests

```bash
# Run on connected device/emulator
flutter test integration_test/app_test.dart

# Run on specific device
flutter test integration_test/app_test.dart -d <device_id>

# Run all integration tests
flutter test integration_test/
```

---

## Testing Login Flow

```dart
// integration_test/login_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow', () {
    testWidgets('user can log in successfully', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Should see login screen
      expect(find.text('Login'), findsOneWidget);

      // Enter email
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Should navigate to home screen
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('shows error for invalid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter wrong credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'wrong@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('Invalid credentials'), findsOneWidget);

      // Should stay on login screen
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
```

---

## Testing Navigation

```dart
testWidgets('navigates between screens', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Start on home screen
  expect(find.text('Home'), findsOneWidget);

  // Navigate to settings
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  expect(find.text('Settings'), findsOneWidget);
  expect(find.text('Home'), findsNothing);

  // Navigate back
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();

  expect(find.text('Home'), findsOneWidget);
});
```

---

## Testing a Complete User Journey

```dart
// integration_test/shopping_flow_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can complete a purchase', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Step 1: Browse products
    expect(find.text('Products'), findsOneWidget);

    // Step 2: Add item to cart
    await tester.tap(find.byKey(const Key('product_1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // Verify cart badge shows 1
    expect(find.text('1'), findsOneWidget);

    // Step 3: Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Product 1'), findsOneWidget);

    // Step 4: Proceed to checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    // Step 5: Fill shipping info
    await tester.enterText(
      find.byKey(const Key('address_field')),
      '123 Main St',
    );
    await tester.pumpAndSettle();

    // Step 6: Complete purchase
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    // Step 7: Verify success
    expect(find.text('Order Confirmed!'), findsOneWidget);
    expect(find.text('Thank you for your purchase'), findsOneWidget);
  });
}
```

---

## Helper Functions

```dart
// integration_test/helpers/test_helpers.dart

Future<void> login(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byKey(const Key('email_field')), email);
  await tester.enterText(find.byKey(const Key('password_field')), password);
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();
}

Future<void> logout(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
}

Future<void> navigateTo(WidgetTester tester, String screenName) async {
  await tester.tap(find.text(screenName));
  await tester.pumpAndSettle();
}
```

```dart
// Using helpers
testWidgets('user profile updates correctly', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  await login(tester, 'user@test.com', 'password');

  await navigateTo(tester, 'Profile');

  expect(find.text('user@test.com'), findsOneWidget);
});
```

---

## Screenshots During Tests

```dart
testWidgets('capture screenshots', (tester) async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app.main();
  await tester.pumpAndSettle();

  // Take screenshot
  await binding.takeScreenshot('home_screen');

  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  await binding.takeScreenshot('settings_screen');
});
```

---

## Testing with Mock Data

```dart
// Set up test environment
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Use mock API
    GetIt.instance.registerSingleton<ApiService>(MockApiService());
  });

  tearDownAll(() {
    GetIt.instance.reset();
  });

  testWidgets('displays mock data', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Mock data should be displayed
    expect(find.text('Mock Product'), findsOneWidget);
  });
}
```

---

## Best Practices

```
┌─────────────────────────────────────────────────────────┐
│          INTEGRATION TEST BEST PRACTICES                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. TEST CRITICAL PATHS                                  │
│     Focus on important user journeys:                    │
│     - Login/signup                                       │
│     - Core feature usage                                 │
│     - Checkout/payment                                   │
│                                                          │
│  2. USE MEANINGFUL KEYS                                  │
│     Key('login_button') not Key('btn1')                 │
│                                                          │
│  3. WAIT FOR ANIMATIONS                                  │
│     Always use pumpAndSettle() after actions            │
│                                                          │
│  4. CLEAN UP STATE                                       │
│     Reset database/storage between tests                 │
│                                                          │
│  5. RUN ON REAL DEVICES                                  │
│     Emulators are good, but test on real hardware       │
│                                                          │
│  6. KEEP TESTS INDEPENDENT                               │
│     Each test should work on its own                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           INTEGRATION TESTING SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  LOCATION: integration_test/ folder                      │
│                                                          │
│  SETUP:                                                  │
│  IntegrationTestWidgetsFlutterBinding.ensureInitialized()│
│  app.main();                                             │
│  await tester.pumpAndSettle();                          │
│                                                          │
│  RUN:                                                    │
│  flutter test integration_test/                          │
│                                                          │
│  USE FOR:                                                │
│  ├── Login/logout flows                                 │
│  ├── Navigation between screens                         │
│  ├── Complete user journeys                             │
│  └── End-to-end feature testing                         │
│                                                          │
│  REMEMBER:                                               │
│  ├── Runs on real device/emulator                       │
│  ├── Slower than unit/widget tests                      │
│  ├── Tests the complete app                             │
│  └── Great for critical paths                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** How is an integration test different from a widget test?

<details>
<summary>Answer</summary>
A widget test checks one widget in isolation; an integration test runs the whole app and tests a full user flow across screens.
</details>

**Q2.** What kind of bug do integration tests catch that unit/widget tests might miss?

<details>
<summary>Answer</summary>
Bugs where pieces work alone but break together, like navigation between screens or data not flowing from login to home.
</details>

**Q3.** Why are integration tests slower?

<details>
<summary>Answer</summary>
They run the real app end to end (often on a device/emulator), which takes much longer than testing a single function or widget.
</details>

---

## Assignment

### Problem 1: Pick the test

You want to verify "user logs in, lands on home, sees their name." Which test type?

### Problem 2: Trade-off

Name one downside of integration tests compared to unit tests.

### Problem 3: The pyramid

Should you have more unit tests or more integration tests? Why?

---

## Assignment Answers

### Problem 1: Pick the test

An **integration test** (it spans multiple screens and the full flow).

### Problem 2: Trade-off

They are slower and more fragile (more moving parts) than fast, focused unit tests.

### Problem 3: The pyramid

More **unit tests**. They are fast and cheap, so you write many; integration tests are slower, so you write fewer for the most important flows. (This is the "testing pyramid.")

---

**Next:** `05-TestDrivenDevelopment.md` - Writing tests first
