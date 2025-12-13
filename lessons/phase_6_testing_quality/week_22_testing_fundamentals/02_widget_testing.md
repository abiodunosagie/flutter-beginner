# Widget Testing: Testing Your Flutter UI

## What You'll Learn

In this lesson, you'll master widget testing:
- What widget testing is and how it's different from unit testing
- How to find widgets in the widget tree
- Simulating user interactions (taps, scrolls, text input)
- Testing widget state changes
- Testing navigation between screens
- Testing forms and validation
- Golden tests for visual regression
- Best practices for maintainable widget tests

By the end, you'll confidently test any Flutter UI!

## Understanding Widget Testing (Super Simple Explanation)

### What is Widget Testing?

Remember our LEGO castle analogy?
- **Unit Testing** = Testing individual LEGO bricks
- **Widget Testing** = Testing assembled LEGO sections (walls, doors, windows)

**In Flutter:**
- Unit tests check **functions and classes**
- Widget tests check **UI components** (buttons, forms, screens)

### Real Example

Imagine a login screen:

**Without Widget Tests:**
```dart
// You build a login screen
// You manually click the button 100 times
// "Yep, it works!" ✅

// You change some code...
// Button stops working 😱
// Users can't log in!
```

**With Widget Tests:**
```dart
// You write a test
testWidgets('login button should submit form', (tester) async {
  // Create login screen
  await tester.pumpWidget(LoginScreen());

  // Type email and password
  await tester.enterText(find.byKey(Key('email')), 'test@example.com');
  await tester.enterText(find.byKey(Key('password')), 'password123');

  // Tap login button
  await tester.tap(find.text('Login'));

  // Check that it worked
  expect(find.text('Welcome!'), findsOneWidget);
});

// If you break the button, test fails immediately! ❌
```

## Step 1: Setup for Widget Testing

### Your Test File Structure

```
my_app/
├── lib/
│   └── widgets/
│       └── counter_widget.dart
└── test/
    └── widgets/
        └── counter_widget_test.dart
```

### Import Required Packages

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter_widget.dart';
```

**Key difference from unit tests:**
- Unit tests: `import 'package:test/test.dart';`
- Widget tests: `import 'package:flutter_test/flutter_test.dart';`

## Step 2: Your First Widget Test

Let's create a simple counter widget and test it.

### Create the Counter Widget

Create `lib/widgets/counter_widget.dart`:

```dart
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Count:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '$_counter',
                key: const Key('counter_text'),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    key: const Key('decrement_button'),
                    onPressed: _decrement,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    key: const Key('increment_button'),
                    onPressed: _increment,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Notice the `Key` widgets?** They help us find widgets in tests!

### Create the Widget Test

Create `test/widgets/counter_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter_widget.dart';

void main() {
  testWidgets('Counter starts at zero', (WidgetTester tester) async {
    // ARRANGE: Build the widget
    await tester.pumpWidget(const CounterWidget());

    // ASSERT: Check initial state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('Counter increments when + button is tapped', (tester) async {
    // ARRANGE: Build widget
    await tester.pumpWidget(const CounterWidget());

    // ACT: Tap the increment button
    await tester.tap(find.byKey(const Key('increment_button')));

    // Wait for the widget to rebuild
    await tester.pump();

    // ASSERT: Check counter increased
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter decrements when - button is tapped', (tester) async {
    // Build widget
    await tester.pumpWidget(const CounterWidget());

    // Tap decrement button
    await tester.tap(find.byKey(const Key('decrement_button')));
    await tester.pump();

    // Check counter decreased
    expect(find.text('-1'), findsOneWidget);
  });

  testWidgets('Counter can increment multiple times', (tester) async {
    await tester.pumpWidget(const CounterWidget());

    // Tap increment 3 times
    await tester.tap(find.byKey(const Key('increment_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('increment_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('increment_button')));
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
  });
}
```

### Run the Tests

```bash
flutter test test/widgets/counter_widget_test.dart
```

## Step 3: Understanding WidgetTester

`WidgetTester` is your testing robot that:
- 🤖 Builds widgets
- 🤖 Taps buttons
- 🤖 Enters text
- 🤖 Scrolls lists
- 🤖 Checks what's on screen

### Key WidgetTester Methods

#### 1. `pumpWidget()` - Build a Widget

```dart
// Build a widget in the test environment
await tester.pumpWidget(MyWidget());

// Wrap in MaterialApp if needed
await tester.pumpWidget(
  MaterialApp(
    home: MyWidget(),
  ),
);
```

**Think of it as:** "Put this widget on the screen"

#### 2. `pump()` - Rebuild Widgets

```dart
await tester.tap(find.text('Submit'));

// This triggers setState(), but widget hasn't rebuilt yet!
// Must call pump() to rebuild

await tester.pump();  // Now the widget rebuilds
```

**Think of it as:** "Refresh the screen"

#### 3. `pumpAndSettle()` - Wait for All Animations

```dart
// Tap button that triggers an animation
await tester.tap(find.text('Animate'));

// Wait for ALL animations to complete
await tester.pumpAndSettle();

// Now we can check the final state
expect(find.text('Animation Done'), findsOneWidget);
```

**Think of it as:** "Wait until everything stops moving"

#### 4. `tap()` - Tap a Widget

```dart
// Tap by text
await tester.tap(find.text('Login'));

// Tap by key
await tester.tap(find.byKey(Key('submit_button')));

// Tap by icon
await tester.tap(find.byIcon(Icons.add));
```

#### 5. `enterText()` - Type Into Text Fields

```dart
// Enter text into a TextField
await tester.enterText(
  find.byKey(Key('email_field')),
  'test@example.com',
);

await tester.pump();  // Rebuild to show text
```

#### 6. `drag()` - Swipe/Drag Widgets

```dart
// Swipe down (refresh)
await tester.drag(
  find.byType(ListView),
  const Offset(0, 300),  // dx=0, dy=300 (down)
);
await tester.pumpAndSettle();

// Swipe left (dismiss)
await tester.drag(
  find.text('Item'),
  const Offset(-300, 0),  // dx=-300, dy=0 (left)
);
```

## Step 4: Finding Widgets

The `find` object helps you locate widgets. Think of it as a search function.

### Common Finders

```dart
// Find by text
find.text('Login')
find.text('Welcome Back!')

// Find by key
find.byKey(Key('submit_button'))
find.byKey(Key('email_field'))

// Find by widget type
find.byType(TextField)
find.byType(ElevatedButton)
find.byType(ListView)

// Find by icon
find.byIcon(Icons.add)
find.byIcon(Icons.home)

// Find descendants (widget inside another)
find.descendant(
  of: find.byType(AppBar),
  matching: find.text('Settings'),
)

// Find ancestors (parent of widget)
find.ancestor(
  of: find.text('Submit'),
  matching: find.byType(Form),
)

// Find by widget instance
final myWidget = MyWidget();
find.byWidget(myWidget)
```

### Finder Matchers

```dart
// Check widget exists
expect(find.text('Login'), findsOneWidget);

// Check widget doesn't exist
expect(find.text('Error'), findsNothing);

// Check multiple widgets exist
expect(find.byType(TextField), findsNWidgets(3));

// Check at least one exists
expect(find.text('Item'), findsWidgets);

// Check at least N exist
expect(find.byType(ListTile), findsAtLeastNWidgets(5));
```

## Step 5: Testing Forms and Input

Let's test a login form comprehensively.

### Create Login Form

Create `lib/widgets/login_form.dart`:

```dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onLogin;

  const LoginForm({Key? key, this.onLogin}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onLogin?.call(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const Key('email_field'),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('password_field'),
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      key: const Key('error_message'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('login_button'),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              key: Key('loading_indicator'),
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Test the Login Form

Create `test/widgets/login_form_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/login_form.dart';

void main() {
  group('LoginForm', () {
    testWidgets('should display email and password fields', (tester) async {
      await tester.pumpWidget(const LoginForm());

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('should show error when email is empty', (tester) async {
      await tester.pumpWidget(const LoginForm());

      // Tap login without entering email
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Check error message appears
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.pumpWidget(const LoginForm());

      // Enter invalid email
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'notanemail',
      );

      // Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('should show error when password is empty', (tester) async {
      await tester.pumpWidget(const LoginForm());

      // Enter valid email but no password
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', (tester) async {
      await tester.pumpWidget(const LoginForm());

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        '123',  // Too short
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should call onLogin with valid credentials', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        LoginForm(
          onLogin: (email, password) async {
            submittedEmail = email;
            submittedPassword = password;
          },
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Wait for async operation
      await tester.pump(const Duration(seconds: 1));

      // Check callback was called with correct values
      expect(submittedEmail, equals('test@example.com'));
      expect(submittedPassword, equals('password123'));
    });

    testWidgets('should show loading indicator during login', (tester) async {
      await tester.pumpWidget(
        LoginForm(
          onLogin: (email, password) async {
            // Simulate slow network
            await Future.delayed(const Duration(seconds: 2));
          },
        ),
      );

      // Enter credentials
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

      // Loading indicator should appear
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);

      // Wait for login to complete
      await tester.pumpAndSettle();

      // Loading indicator should disappear
      expect(find.byKey(const Key('loading_indicator')), findsNothing);
    });

    testWidgets('should disable button during login', (tester) async {
      await tester.pumpWidget(
        LoginForm(
          onLogin: (email, password) async {
            await Future.delayed(const Duration(seconds: 2));
          },
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

      // Try to tap again (should be disabled)
      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('login_button')),
      );
      expect(button.onPressed, isNull);  // Button is disabled
    });

    testWidgets('should show error message on login failure', (tester) async {
      await tester.pumpWidget(
        LoginForm(
          onLogin: (email, password) async {
            throw Exception('Invalid credentials');
          },
        ),
      );

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Wait for error
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('Exception: Invalid credentials'),
        findsOneWidget,
      );
    });
  });
}
```

## Step 6: Testing Navigation

Let's test navigation between screens.

### Create Two Screens

Create `lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home!'),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('go_to_details'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DetailsScreen(message: 'Hello!'),
                  ),
                );
              },
              child: const Text('Go to Details'),
            ),
          ],
        ),
      ),
    );
  }
}
```

Create `lib/screens/details_screen.dart`:

```dart
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String message;

  const DetailsScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              key: const Key('message_text'),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('go_back'),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Test Navigation

Create `test/screens/navigation_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/details_screen.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('should navigate to details screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify we're on home screen
      expect(find.text('Welcome to Home!'), findsOneWidget);

      // Tap button to navigate
      await tester.tap(find.byKey(const Key('go_to_details')));
      await tester.pumpAndSettle();  // Wait for navigation animation

      // Verify we're on details screen
      expect(find.text('Details'), findsOneWidget);
      expect(find.byKey(const Key('message_text')), findsOneWidget);
    });

    testWidgets('should pass data to details screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.tap(find.byKey(const Key('go_to_details')));
      await tester.pumpAndSettle();

      // Check message was passed correctly
      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('should navigate back to home', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Go to details
      await tester.tap(find.byKey(const Key('go_to_details')));
      await tester.pumpAndSettle();

      // Go back
      await tester.tap(find.byKey(const Key('go_back')));
      await tester.pumpAndSettle();

      // Verify we're back on home screen
      expect(find.text('Welcome to Home!'), findsOneWidget);
      expect(find.text('Details'), findsNothing);
    });

    testWidgets('should navigate back using back button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.tap(find.byKey(const Key('go_to_details')));
      await tester.pumpAndSettle();

      // Tap system back button (< icon in AppBar)
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Home!'), findsOneWidget);
    });
  });
}
```

## Step 7: Testing Lists and Scrolling

Create `lib/widgets/todo_list.dart`:

```dart
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final List<String> todos;

  const TodoList({
    Key? key,
    required this.todos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Todos')),
        body: ListView.builder(
          key: const Key('todo_list'),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              key: Key('todo_$index'),
              title: Text(todos[index]),
            );
          },
        ),
      ),
    );
  }
}
```

Test it:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/todo_list.dart';

void main() {
  group('TodoList', () {
    testWidgets('should display all todos', (tester) async {
      final todos = ['Buy milk', 'Walk dog', 'Write code'];

      await tester.pumpWidget(TodoList(todos: todos));

      for (final todo in todos) {
        expect(find.text(todo), findsOneWidget);
      }
    });

    testWidgets('should display empty list', (tester) async {
      await tester.pumpWidget(const TodoList(todos: []));

      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('should scroll to see all items', (tester) async {
      // Create 50 todos
      final todos = List.generate(50, (i) => 'Todo $i');

      await tester.pumpWidget(TodoList(todos: todos));

      // First item should be visible
      expect(find.text('Todo 0'), findsOneWidget);

      // Last item should NOT be visible yet
      expect(find.text('Todo 49'), findsNothing);

      // Scroll down
      await tester.drag(
        find.byKey(const Key('todo_list')),
        const Offset(0, -5000),  // Scroll up (negative Y)
      );
      await tester.pumpAndSettle();

      // Now last item should be visible
      expect(find.text('Todo 49'), findsOneWidget);
    });

    testWidgets('should find item using scrollUntilVisible', (tester) async {
      final todos = List.generate(100, (i) => 'Todo $i');

      await tester.pumpWidget(TodoList(todos: todos));

      // Scroll until we find item 75
      await tester.scrollUntilVisible(
        find.text('Todo 75'),
        500,  // Scroll 500 pixels at a time
        scrollable: find.byType(Scrollable),
      );

      expect(find.text('Todo 75'), findsOneWidget);
    });
  });
}
```

## Step 8: Golden Tests (Visual Regression)

Golden tests take screenshots of widgets and compare them to saved images.

```dart
testWidgets('login form matches golden file', (tester) async {
  await tester.pumpWidget(const LoginForm());

  await expectLater(
    find.byType(LoginForm),
    matchesGoldenFile('goldens/login_form.png'),
  );
});
```

Run with:

```bash
flutter test --update-goldens  # First time: saves screenshots
flutter test                    # Later: compares to saved
```

## Step 9: Best Practices

### 1. Use Keys for Important Widgets

```dart
// In widget
TextField(
  key: const Key('email_field'),  // ✅ Easy to find
  ...
)

// In test
find.byKey(const Key('email_field'))
```

### 2. Test User Flows, Not Implementation

```dart
// ❌ Bad - testing implementation
test('should call setState when increment pressed', ...)

// ✅ Good - testing behavior
test('should show incremented value when + button tapped', ...)
```

### 3. Always pump() After Interactions

```dart
await tester.tap(find.text('Submit'));
await tester.pump();  // ✅ Don't forget!

expect(find.text('Success'), findsOneWidget);
```

### 4. Use pumpAndSettle() for Animations

```dart
await tester.tap(find.text('Animate'));
await tester.pumpAndSettle();  // Wait for all animations

expect(find.text('Done'), findsOneWidget);
```

### 5. Clean Up Resources

```dart
testWidgets('...', (tester) async {
  final controller = TextEditingController();

  await tester.pumpWidget(
    TextField(controller: controller),
  );

  // ... tests ...

  controller.dispose();  // ✅ Clean up
});
```

## Exercises

### Exercise 1: Test a Registration Form
Create and test a form with:
- Name field (required, min 2 chars)
- Email field (required, valid format)
- Password field (required, min 8 chars)
- Confirm password field (must match password)
- Submit button

### Exercise 2: Test a Settings Screen
Create toggles for:
- Dark mode
- Notifications
- Auto-save

Test that toggling updates state correctly.

### Exercise 3: Test a Shopping Cart
- Add items
- Remove items
- Update quantity
- Calculate total
- Show empty state

### Exercise 4: Test Search Functionality
- Enter search query
- Display results
- Show "no results" message
- Clear search

### Exercise 5: Test Infinite Scroll
- Load initial items
- Scroll to bottom
- Load more items
- Show loading indicator

## What You've Learned

✅ How widget testing differs from unit testing
✅ Using WidgetTester to interact with widgets
✅ Finding widgets with various finders
✅ Testing forms and validation
✅ Testing navigation between screens
✅ Testing lists and scrolling
✅ Golden tests for visual regression
✅ Best practices for maintainable widget tests

## Next Steps

In the next lesson, we'll cover:
- **Integration Testing** - Test complete app flows
- **Testing with real data**
- **Testing network calls**
- **End-to-end testing**

You can now confidently test any Flutter UI! 🎉
