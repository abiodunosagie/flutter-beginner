# Widget Testing

## The Simple Explanation

Widget testing is like checking if a button looks right AND works when pressed, without running the whole app!

```
┌─────────────────────────────────────────────────────────┐
│                   WIDGET TESTING                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Test your UI in isolation:                              │
│                                                          │
│  ┌─────────────────────────────────┐                    │
│  │  Counter: 0        [+]          │ ← Widget to test   │
│  └─────────────────────────────────┘                    │
│                                                          │
│  Questions we can answer:                                │
│  ✓ Does it display "Counter: 0"?                        │
│  ✓ Is there a [+] button?                               │
│  ✓ When [+] is tapped, does it show "Counter: 1"?       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Basic Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments when button is tapped', (tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: CounterScreen(),
    ));

    // Verify initial state
    expect(find.text('0'), findsOneWidget);

    // Tap the button
    await tester.tap(find.byIcon(Icons.add));

    // Rebuild the widget
    await tester.pump();

    // Verify the counter increased
    expect(find.text('1'), findsOneWidget);
  });
}
```

---

## Key Concepts

### 1. pumpWidget - Build the Widget

```dart
await tester.pumpWidget(
  const MaterialApp(
    home: MyWidget(),
  ),
);

// Always wrap in MaterialApp for proper rendering!
```

### 2. pump - Rebuild After Changes

```dart
// After an action that changes state
await tester.tap(find.byType(ElevatedButton));

// Rebuild the widget to see changes
await tester.pump();

// For animations, use:
await tester.pumpAndSettle(); // Waits for all animations
```

### 3. find - Locate Widgets

```dart
// By text
find.text('Hello World')
find.textContaining('Hello')

// By type
find.byType(ElevatedButton)
find.byType(TextField)

// By icon
find.byIcon(Icons.add)
find.byIcon(Icons.delete)

// By key
find.byKey(const Key('submit_button'))

// By widget predicate
find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Hello')

// Descendants
find.descendant(
  of: find.byType(Card),
  matching: find.text('Title'),
)

// Ancestors
find.ancestor(
  of: find.text('Submit'),
  matching: find.byType(Form),
)
```

### 4. Matchers for Finders

```dart
// Found exactly once
expect(find.text('Hello'), findsOneWidget);

// Not found
expect(find.text('Goodbye'), findsNothing);

// Found multiple times
expect(find.byType(ListTile), findsNWidgets(5));

// Found at least once
expect(find.byType(Text), findsWidgets);
```

---

## Interacting with Widgets

### Tap

```dart
await tester.tap(find.byType(ElevatedButton));
await tester.pump();
```

### Enter Text

```dart
await tester.enterText(find.byType(TextField), 'Hello');
await tester.pump();
```

### Scroll

```dart
await tester.drag(find.byType(ListView), const Offset(0, -300));
await tester.pump();
```

### Long Press

```dart
await tester.longPress(find.byKey(const Key('item_1')));
await tester.pump();
```

### Swipe/Fling

```dart
await tester.fling(find.byType(Dismissible), const Offset(-500, 0), 1000);
await tester.pumpAndSettle();
```

---

## Testing a Simple Widget

```dart
// lib/widgets/greeting_widget.dart
class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}
```

```dart
// test/widgets/greeting_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/greeting_widget.dart';

void main() {
  testWidgets('displays greeting with name', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: GreetingWidget(name: 'John'),
      ),
    ));

    expect(find.text('Hello, John!'), findsOneWidget);
  });

  testWidgets('updates when name changes', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: GreetingWidget(name: 'John'),
      ),
    ));

    expect(find.text('Hello, John!'), findsOneWidget);

    // Rebuild with different name
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: GreetingWidget(name: 'Jane'),
      ),
    ));

    expect(find.text('Hello, Jane!'), findsOneWidget);
    expect(find.text('Hello, John!'), findsNothing);
  });
}
```

---

## Testing a Stateful Widget

```dart
// lib/widgets/counter_widget.dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $_count', key: const Key('count_text')),
        ElevatedButton(
          key: const Key('increment_button'),
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
        ElevatedButton(
          key: const Key('decrement_button'),
          onPressed: () => setState(() => _count--),
          child: const Text('Decrement'),
        ),
      ],
    );
  }
}
```

```dart
// test/widgets/counter_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter_widget.dart';

void main() {
  group('CounterWidget', () {
    testWidgets('displays initial count of 0', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CounterWidget()),
      ));

      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('increments count when increment button is tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CounterWidget()),
      ));

      // Initial count
      expect(find.text('Count: 0'), findsOneWidget);

      // Tap increment button
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      // Count increased
      expect(find.text('Count: 1'), findsOneWidget);

      // Tap again
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('Count: 2'), findsOneWidget);
    });

    testWidgets('decrements count when decrement button is tapped', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CounterWidget()),
      ));

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('Count: -1'), findsOneWidget);
    });
  });
}
```

---

## Testing Forms

```dart
// lib/screens/login_screen.dart
class LoginScreen extends StatefulWidget {
  final Function(String email, String password) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('email_field'),
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Email required' : null,
          ),
          TextFormField(
            key: const Key('password_field'),
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Password required' : null,
          ),
          ElevatedButton(
            key: const Key('login_button'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onLogin(
                  _emailController.text,
                  _passwordController.text,
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

```dart
// test/screens/login_screen_test.dart
void main() {
  group('LoginScreen', () {
    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginScreen(onLogin: (_, __) {}),
        ),
      ));

      // Tap login without entering anything
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Check for validation errors
      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('calls onLogin with correct values', (tester) async {
      String? capturedEmail;
      String? capturedPassword;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginScreen(
            onLogin: (email, password) {
              capturedEmail = email;
              capturedPassword = password;
            },
          ),
        ),
      ));

      // Enter email
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verify callback was called with correct values
      expect(capturedEmail, 'test@example.com');
      expect(capturedPassword, 'password123');
    });
  });
}
```

---

## Testing with Provider

```dart
testWidgets('displays user name from provider', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => UserProvider()..setUser(User(name: 'John')),
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    ),
  );

  expect(find.text('John'), findsOneWidget);
});
```

---

## Golden Tests (Visual Snapshot)

```dart
testWidgets('matches golden file', (tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: MyBeautifulWidget(),
  ));

  await expectLater(
    find.byType(MyBeautifulWidget),
    matchesGoldenFile('goldens/my_beautiful_widget.png'),
  );
});

// Run: flutter test --update-goldens
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│             WIDGET TESTING SUMMARY                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  SETUP:                                                  │
│  testWidgets('description', (tester) async {            │
│    await tester.pumpWidget(MaterialApp(...));           │
│  });                                                     │
│                                                          │
│  BUILD:                                                  │
│  pumpWidget()     - Initial build                        │
│  pump()           - Rebuild after changes               │
│  pumpAndSettle()  - Wait for animations                 │
│                                                          │
│  FIND:                                                   │
│  find.text()      - By text content                     │
│  find.byType()    - By widget type                      │
│  find.byKey()     - By Key                              │
│  find.byIcon()    - By icon                             │
│                                                          │
│  INTERACT:                                               │
│  tester.tap()     - Tap widget                          │
│  tester.enterText() - Type in TextField                 │
│  tester.drag()    - Scroll/swipe                        │
│                                                          │
│  VERIFY:                                                 │
│  findsOneWidget   - Found exactly once                  │
│  findsNothing     - Not found                           │
│  findsNWidgets(n) - Found n times                       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** `04-IntegrationTesting.md` - Testing complete user flows
