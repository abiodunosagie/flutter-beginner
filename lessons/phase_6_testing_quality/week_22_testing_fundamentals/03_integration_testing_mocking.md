# Integration Testing & Mocking: Testing Complete App Flows

## What You'll Learn

In this comprehensive lesson, you'll master:
- What integration testing is and when to use it
- Setting up integration tests
- Testing complete user journeys (sign up → login → use app)
- Testing with real device/emulator
- Performance profiling during tests
- What mocking is and why it's essential
- Mocking API calls with Mockito
- Mocking dependencies and services
- Testing error scenarios
- Best practices for integration tests

By the end, you'll test entire app flows like a professional!

## Understanding Integration Testing (Super Simple)

### The Testing Pyramid

```
        /\
       /  \  Integration Tests (Few)
      /____\
     /      \
    / Widget \ (More)
   /  Tests  \
  /___________\
 /             \
/  Unit Tests  \ (Many)
/_______________ \
```

**Think of building a car:**
- **Unit Tests** = Test individual parts (engine, brakes, steering wheel)
- **Widget Tests** = Test assemblies (dashboard, seat assembly)
- **Integration Tests** = Test the WHOLE car driving down the road!

### Real Example

**Unit Test:**
```dart
test('login validates email', () {
  expect(validateEmail('test@example.com'), isTrue);
});
```

**Widget Test:**
```dart
testWidgets('login form shows error for invalid email', (tester) async {
  await tester.enterText(find.byKey(Key('email')), 'invalid');
  await tester.tap(find.text('Login'));
  expect(find.text('Invalid email'), findsOneWidget);
});
```

**Integration Test:**
```dart
// Test ENTIRE user flow:
// 1. User opens app
// 2. Enters email and password
// 3. Taps login button
// 4. App calls API
// 5. User sees home screen
// 6. User can navigate and use features
```

## Step 1: Setting Up Integration Tests

### 1. Add Dependencies

Update `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

Run:

```bash
flutter pub get
```

### 2. Create Test Directory Structure

```
my_app/
├── lib/
├── test/              # Unit and widget tests
└── integration_test/  # Integration tests
    ├── app_test.dart
    └── user_journey_test.dart
```

### 3. Create Integration Test Driver

Create `integration_test/test_driver.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

This driver runs integration tests on a real device or emulator.

## Step 2: Your First Integration Test

Let's create a simple app and test a complete user flow.

### Create a Simple Counter App

Create `lib/main.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        actions: [
          IconButton(
            key: const Key('reset_button'),
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              '$_counter',
              key: const Key('counter_text'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_button'),
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Create Integration Test

Create `integration_test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  // This line enables integration test extensions
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Counter App Integration Tests', () {
    testWidgets('complete user journey', (tester) async {
      // STEP 1: Launch the app
      app.main();
      await tester.pumpAndSettle();

      // STEP 2: Verify app loaded correctly
      expect(find.text('Counter App'), findsOneWidget);
      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // STEP 3: Increment counter multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pumpAndSettle();
      }

      // STEP 4: Verify counter increased
      expect(find.text('5'), findsOneWidget);

      // STEP 5: Reset counter
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pumpAndSettle();

      // STEP 6: Verify counter reset
      expect(find.text('0'), findsOneWidget);

      // STEP 7: Increment again to ensure it works after reset
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('counter persists during navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Increment counter
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      // Note: In a real app, you'd navigate away and back
      // For this simple example, we'll just verify the count remains
    });
  });
}
```

### Run Integration Test

```bash
# Run on connected device or emulator
flutter test integration_test/app_test.dart

# Run with specific device
flutter test integration_test/app_test.dart -d <device_id>

# Run all integration tests
flutter test integration_test
```

## Step 3: Understanding Mocking

**Mocking** = Creating fake versions of things for testing

### Why Mock?

**Problem: Testing with Real API**

```dart
testWidgets('user can log in', (tester) async {
  // This test calls REAL API
  await loginService.login('test@example.com', 'password');

  // ❌ Problems:
  // 1. Needs internet connection
  // 2. Slow (network calls)
  // 3. Fails if server is down
  // 4. Costs money (API calls)
  // 5. Can't test error scenarios easily
});
```

**Solution: Mock the API**

```dart
testWidgets('user can log in', (tester) async {
  // Create FAKE API that returns success
  final mockApi = MockLoginService();
  when(mockApi.login(any, any)).thenAnswer((_) async => User());

  // ✅ Benefits:
  // 1. Works offline
  // 2. Fast (no network)
  // 3. Always works
  // 4. Free
  // 5. Can simulate any scenario!
});
```

### What Can You Mock?

- ✅ API calls (HTTP requests)
- ✅ Database queries
- ✅ File system operations
- ✅ GPS/location services
- ✅ Camera
- ✅ Time/dates
- ✅ Random number generators
- ✅ Third-party services (payment, analytics)

## Step 4: Mocking with Mockito

### Create a Service to Mock

Create `lib/services/auth_service.dart`:

```dart
class AuthService {
  Future<User> login(String email, String password) async {
    // In real app, this would call an API
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@example.com' && password == 'password123') {
      return User(
        id: '123',
        name: 'John Doe',
        email: email,
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> isLoggedIn() async {
    // Check if user has valid token
    return false;
  }
}

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
```

### Create Mock Class

Create `test/mocks/mock_auth_service.dart`:

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:my_app/services/auth_service.dart';

// This annotation tells Mockito to generate a mock class
@GenerateMocks([AuthService])
void main() {}
```

### Generate Mock

Run this command to generate the mock class:

```bash
flutter pub run build_runner build
```

This creates `test/mocks/mock_auth_service.mocks.dart`.

### Use Mock in Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/services/auth_service.dart';
import 'mocks/mock_auth_service.mocks.dart';

void main() {
  group('AuthService', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    test('successful login returns user', () async {
      // ARRANGE: Set up mock to return success
      final expectedUser = User(
        id: '123',
        name: 'John Doe',
        email: 'test@example.com',
      );

      when(mockAuthService.login('test@example.com', 'password123'))
          .thenAnswer((_) async => expectedUser);

      // ACT: Call the mocked method
      final result = await mockAuthService.login(
        'test@example.com',
        'password123',
      );

      // ASSERT: Check result
      expect(result.id, equals('123'));
      expect(result.name, equals('John Doe'));

      // VERIFY: Method was called exactly once
      verify(mockAuthService.login('test@example.com', 'password123'))
          .called(1);
    });

    test('failed login throws exception', () async {
      // ARRANGE: Set up mock to throw error
      when(mockAuthService.login(any, any))
          .thenThrow(Exception('Invalid credentials'));

      // ACT & ASSERT: Check exception is thrown
      expect(
        () => mockAuthService.login('wrong@example.com', 'wrong'),
        throwsA(isA<Exception>()),
      );
    });

    test('can simulate network delay', () async {
      // ARRANGE: Simulate slow network
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(seconds: 3));
          return User(id: '1', name: 'Test', email: 'test@example.com');
        },
      );

      final stopwatch = Stopwatch()..start();

      // ACT
      await mockAuthService.login('test@example.com', 'password');

      stopwatch.stop();

      // ASSERT: Check it took time
      expect(stopwatch.elapsed.inSeconds, greaterThanOrEqualTo(3));
    });

    test('logout is called', () async {
      // ARRANGE
      when(mockAuthService.logout()).thenAnswer((_) async {});

      // ACT
      await mockAuthService.logout();

      // VERIFY
      verify(mockAuthService.logout()).called(1);
    });

    test('can check if user is logged in', () async {
      // ARRANGE: User is logged in
      when(mockAuthService.isLoggedIn()).thenAnswer((_) async => true);

      // ACT
      final result = await mockAuthService.isLoggedIn();

      // ASSERT
      expect(result, isTrue);
    });

    test('login not called if not needed', () async {
      // Don't call login

      // VERIFY: login was never called
      verifyNever(mockAuthService.login(any, any));
    });

    test('can verify order of calls', () async {
      // ARRANGE
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async => User(id: '1', name: 'Test', email: 'test@example.com'),
      );
      when(mockAuthService.isLoggedIn()).thenAnswer((_) async => true);
      when(mockAuthService.logout()).thenAnswer((_) async {});

      // ACT: Call methods in specific order
      await mockAuthService.login('test@example.com', 'password');
      await mockAuthService.isLoggedIn();
      await mockAuthService.logout();

      // VERIFY: Check order
      verifyInOrder([
        mockAuthService.login('test@example.com', 'password'),
        mockAuthService.isLoggedIn(),
        mockAuthService.logout(),
      ]);
    });
  });
}
```

## Step 5: Mockito Cheat Sheet

### Basic Mocking

```dart
// Create mock
final mockService = MockMyService();

// Set return value
when(mockService.getData()).thenReturn('data');

// Set async return value
when(mockService.fetchData()).thenAnswer((_) async => 'data');

// Throw error
when(mockService.getData()).thenThrow(Exception('Error'));

// Different returns for multiple calls
when(mockService.getData())
    .thenReturn('first')
    .thenReturn('second')
    .thenReturn('third');
```

### Argument Matchers

```dart
// Match any argument
when(mockService.login(any, any)).thenReturn(User());

// Match specific value
when(mockService.login('test@example.com', any)).thenReturn(User());

// Capture arguments
final captured = verify(mockService.login(captureAny, captureAny)).captured;
expect(captured[0], equals('test@example.com'));
expect(captured[1], equals('password123'));
```

### Verification

```dart
// Verify method was called
verify(mockService.getData()).called(1);

// Verify called specific number of times
verify(mockService.getData()).called(3);

// Verify never called
verifyNever(mockService.getData());

// Verify no unexpected interactions
verifyNoMoreInteractions(mockService);

// Verify call order
verifyInOrder([
  mockService.first(),
  mockService.second(),
]);
```

## Step 6: Complete Integration Test with Mocking

Let's create a full login flow with mocked API.

### Create Login Screen

Create `lib/screens/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({
    Key? key,
    required this.authService,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await widget.authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: user),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              key: const Key('email_field'),
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('password_field'),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                key: const Key('error_message'),
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('login_button'),
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

Create `lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.name}!',
              key: const Key('welcome_message'),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${user.email}',
              key: const Key('user_email'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Create Integration Test with Mock

Create `integration_test/login_flow_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:my_app/services/auth_service.dart';
import 'package:my_app/screens/login_screen.dart';

// Generate mock
@GenerateMocks([AuthService])
import 'login_flow_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('successful login journey', (tester) async {
      // ARRANGE: Mock successful login
      final expectedUser = User(
        id: '123',
        name: 'John Doe',
        email: 'test@example.com',
      );

      when(mockAuthService.login('test@example.com', 'password123'))
          .thenAnswer((_) async => expectedUser);

      // STEP 1: Launch app
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authService: mockAuthService),
        ),
      );

      // STEP 2: Verify login screen loaded
      expect(find.text('Login'), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);

      // STEP 3: Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      await tester.pump();

      // STEP 4: Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // STEP 5: Verify navigation to home screen
      expect(find.text('Welcome, John Doe!'), findsOneWidget);
      expect(find.byKey(const Key('welcome_message')), findsOneWidget);
      expect(find.text('Email: test@example.com'), findsOneWidget);

      // VERIFY: Login was called with correct credentials
      verify(mockAuthService.login('test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('failed login shows error', (tester) async {
      // ARRANGE: Mock failed login
      when(mockAuthService.login(any, any))
          .thenThrow(Exception('Invalid credentials'));

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authService: mockAuthService),
        ),
      );

      // STEP 1: Enter wrong credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'wrong@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );

      // STEP 2: Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Wait for error to appear
      await tester.pump(const Duration(seconds: 1));

      // STEP 3: Verify error message shown
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Home'), findsNothing);  // Still on login screen

      // VERIFY: Login was attempted
      verify(mockAuthService.login('wrong@example.com', 'wrongpassword'))
          .called(1);
    });

    testWidgets('login button disabled while loading', (tester) async {
      // ARRANGE: Mock slow login
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(seconds: 3));
          return User(id: '1', name: 'Test', email: 'test@example.com');
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authService: mockAuthService),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Check button is disabled (onPressed is null)
      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('login_button')),
      );
      expect(button.onPressed, isNull);

      // Check loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('empty email shows validation error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authService: mockAuthService),
        ),
      );

      // Try to login without entering email
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verify login service was NOT called
      verifyNever(mockAuthService.login(any, any));
    });
  });
}
```

## Step 7: Testing Different Scenarios with Mocks

### Test Network Errors

```dart
test('handles network timeout', () async {
  when(mockApiService.getData())
      .thenThrow(TimeoutException('Request timed out'));

  expect(
    () => mockApiService.getData(),
    throwsA(isA<TimeoutException>()),
  );
});

test('handles no internet connection', () async {
  when(mockApiService.getData())
      .thenThrow(SocketException('No internet'));

  // Your app should handle this gracefully
});
```

### Test Pagination

```dart
test('loads more data on scroll', () async {
  when(mockApiService.getProducts(page: 1))
      .thenAnswer((_) async => [Product1, Product2]);

  when(mockApiService.getProducts(page: 2))
      .thenAnswer((_) async => [Product3, Product4]);

  // First page
  final page1 = await mockApiService.getProducts(page: 1);
  expect(page1.length, equals(2));

  // Second page
  final page2 = await mockApiService.getProducts(page: 2);
  expect(page2.length, equals(2));

  verify(mockApiService.getProducts(page: 1)).called(1);
  verify(mockApiService.getProducts(page: 2)).called(1);
});
```

### Test Caching

```dart
test('returns cached data on second call', () async {
  when(mockCacheService.get('user_data'))
      .thenReturn(null)  // First call: no cache
      .thenReturn(userData);  // Second call: cached data

  // First call: no cache
  final firstResult = mockCacheService.get('user_data');
  expect(firstResult, isNull);

  // Second call: has cache
  final secondResult = mockCacheService.get('user_data');
  expect(secondResult, isNotNull);
});
```

## Step 8: Performance Testing in Integration Tests

```dart
testWidgets('app loads in under 3 seconds', (tester) async {
  final stopwatch = Stopwatch()..start();

  app.main();
  await tester.pumpAndSettle();

  stopwatch.stop();

  expect(stopwatch.elapsed.inSeconds, lessThan(3));
});

testWidgets('scrolling is smooth', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Measure scroll performance
  final timeline = await tester.binding.traceAction(() async {
    await tester.fling(
      find.byType(ListView),
      const Offset(0, -500),
      1000,
    );
    await tester.pumpAndSettle();
  });

  // Check for frame drops
  final summary = TimelineSummary.summarize(timeline);
  expect(summary.countFrames(), greaterThan(0));
});
```

## Step 9: Best Practices

### 1. Don't Over-Mock

```dart
// ❌ Bad: Mocking simple classes
final mockString = MockString();  // No!

// ✅ Good: Mock external dependencies
final mockApiService = MockApiService();  // Yes!
final mockDatabase = MockDatabase();  // Yes!
```

### 2. Test Behavior, Not Implementation

```dart
// ❌ Bad
test('calls setState', () { ... });

// ✅ Good
test('updates counter when button tapped', () { ... });
```

### 3. Keep Tests Independent

```dart
// ❌ Bad: Tests depend on each other
test('test 1', () {
  globalState = 5;  // Sets global state
});

test('test 2', () {
  expect(globalState, equals(5));  // Depends on test 1!
});

// ✅ Good: Each test is independent
setUp(() {
  state = initialState();  // Fresh state for each test
});
```

### 4. Use Descriptive Test Names

```dart
// ❌ Bad
test('works', () { ... });

// ✅ Good
test('user can login with valid credentials and sees home screen', () { ... });
```

## Exercises

### Exercise 1: Test Shopping Cart Flow
- Add items to cart
- Update quantities
- Remove items
- Apply discount code
- Checkout

### Exercise 2: Mock Weather API
- Mock successful API call
- Mock API error
- Mock slow network
- Test caching

### Exercise 3: Test User Registration
- Enter details
- Validate form
- Submit
- Handle success/error
- Navigate to home

### Exercise 4: Test Search Flow
- Enter search query
- Display results
- Handle no results
- Clear search
- Test pagination

### Exercise 5: Test File Upload
- Mock file picker
- Mock upload service
- Test progress indicator
- Handle upload errors

## What You've Learned

✅ What integration testing is and when to use it
✅ Setting up integration tests
✅ Testing complete user journeys
✅ What mocking is and why it's essential
✅ Mocking with Mockito
✅ Verifying method calls
✅ Testing error scenarios
✅ Performance testing
✅ Best practices for integration tests

## Next Steps

In the next lesson, we'll cover:
- **Test Coverage** - Measuring how much code is tested
- **Generating coverage reports**
- **Identifying untested code**
- **Improving coverage**

You're now a testing expert! 🎉
