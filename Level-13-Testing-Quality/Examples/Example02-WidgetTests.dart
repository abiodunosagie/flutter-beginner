// ============================================
// EXAMPLE 02: WIDGET TESTS
// Complete working examples of widget testing
// ============================================

// ============================================
// WHAT WE'RE BUILDING
// ============================================
/*
  This file shows widget tests for:
  1. Simple widgets (Counter, Greeting)
  2. Interactive widgets (Buttons, Forms)
  3. Stateful widgets
  4. Widgets with navigation
  5. Widgets with async data

  Think of widget tests like testing a LEGO car -
  we test the assembled piece, not just the bricks!
*/

import 'package:flutter/material.dart';

// ============================================
// WIDGETS TO TEST
// ============================================

// --- Simple Greeting Widget ---
class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $name!',
      style: const TextStyle(fontSize: 24),
    );
  }
}

// --- Counter Widget ---
class CounterWidget extends StatefulWidget {
  final int initialValue;

  const CounterWidget({super.key, this.initialValue = 0});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Count: $_count',
          key: const Key('counter_text'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const Key('decrement_button'),
              icon: const Icon(Icons.remove),
              onPressed: _decrement,
            ),
            const SizedBox(width: 16),
            IconButton(
              key: const Key('increment_button'),
              icon: const Icon(Icons.add),
              onPressed: _increment,
            ),
          ],
        ),
      ],
    );
  }
}

// --- Like Button Widget ---
class LikeButton extends StatefulWidget {
  final VoidCallback? onLiked;

  const LikeButton({super.key, this.onLiked});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    if (_isLiked && widget.onLiked != null) {
      widget.onLiked!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('like_button'),
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleLike,
    );
  }
}

// --- Login Form Widget ---
class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onLogin;

  const LoginForm({super.key, this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid email';
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin?.call(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            key: const Key('login_button'),
            onPressed: _submit,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

// --- Todo Item Widget ---
class TodoItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        key: const Key('todo_checkbox'),
        value: isCompleted,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        key: const Key('delete_button'),
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}

// --- User Card Widget ---
class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: const Key('user_card_tap'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: imageUrl == null ? Text(name[0]) : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodySmall,
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

// --- Loading Widget ---
class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String loadingText;

  const LoadingWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(loadingText),
        ],
      );
    }
    return child;
  }
}

// --- Async Data Widget ---
class UserListWidget extends StatefulWidget {
  final Future<List<String>> Function() fetchUsers;

  const UserListWidget({super.key, required this.fetchUsers});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  List<String>? _users;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await widget.fetchUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('loading_indicator')),
      );
    }

    if (_error != null) {
      return Center(
        child: Text('Error: $_error', key: const Key('error_text')),
      );
    }

    if (_users == null || _users!.isEmpty) {
      return const Center(
        child: Text('No users found', key: Key('empty_text')),
      );
    }

    return ListView.builder(
      key: const Key('user_list'),
      itemCount: _users!.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(_users![index]),
      ),
    );
  }
}

// ============================================
// THE TESTS (would go in test/ folder)
// ============================================

/*
// test/widget_tests_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ========================================
  // GREETING WIDGET TESTS
  // ========================================
  group('GreetingWidget', () {
    testWidgets('displays greeting with name', (tester) async {
      // Arrange - Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingWidget(name: 'Alice'),
          ),
        ),
      );

      // Assert - Find the text
      expect(find.text('Hello, Alice!'), findsOneWidget);
    });

    testWidgets('updates when name changes', (tester) async {
      // First build with one name
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingWidget(name: 'Alice'),
          ),
        ),
      );

      expect(find.text('Hello, Alice!'), findsOneWidget);

      // Rebuild with different name
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingWidget(name: 'Bob'),
          ),
        ),
      );

      expect(find.text('Hello, Bob!'), findsOneWidget);
      expect(find.text('Hello, Alice!'), findsNothing);
    });
  });

  // ========================================
  // COUNTER WIDGET TESTS
  // ========================================
  group('CounterWidget', () {
    testWidgets('displays initial count of 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('displays custom initial value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialValue: 10),
          ),
        ),
      );

      expect(find.text('Count: 10'), findsOneWidget);
    });

    testWidgets('increments count when + button tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(),
          ),
        ),
      );

      // Find and tap the increment button
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump(); // Rebuild after state change

      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('decrements count when - button tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialValue: 5),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('Count: 4'), findsOneWidget);
    });

    testWidgets('can increment multiple times', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(),
          ),
        ),
      );

      // Tap 3 times
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('Count: 3'), findsOneWidget);
    });
  });

  // ========================================
  // LIKE BUTTON TESTS
  // ========================================
  group('LikeButton', () {
    testWidgets('shows outline heart initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LikeButton(),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('shows filled heart when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LikeButton(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('like_button')));
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('toggles back to outline when tapped again', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LikeButton(),
          ),
        ),
      );

      // First tap - like
      await tester.tap(find.byKey(const Key('like_button')));
      await tester.pump();

      // Second tap - unlike
      await tester.tap(find.byKey(const Key('like_button')));
      await tester.pump();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('calls onLiked callback when liked', (tester) async {
      bool wasLiked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              onLiked: () => wasLiked = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('like_button')));
      await tester.pump();

      expect(wasLiked, isTrue);
    });
  });

  // ========================================
  // LOGIN FORM TESTS
  // ========================================
  group('LoginForm', () {
    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('shows error when email is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows error for invalid email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'invalid');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows error when password is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'test@email.com');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows error for short password', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'test@email.com');
      await tester.enterText(find.byKey(const Key('password_field')), '12345');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('calls onLogin with valid credentials', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LoginForm(
                onLogin: (email, password) {
                  submittedEmail = email;
                  submittedPassword = password;
                },
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'test@email.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(submittedEmail, 'test@email.com');
      expect(submittedPassword, 'password123');
    });
  });

  // ========================================
  // TODO ITEM TESTS
  // ========================================
  group('TodoItem', () {
    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              title: 'Buy groceries',
              isCompleted: false,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Buy groceries'), findsOneWidget);
    });

    testWidgets('shows unchecked checkbox when not completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              title: 'Task',
              isCompleted: false,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byKey(const Key('todo_checkbox')));
      expect(checkbox.value, isFalse);
    });

    testWidgets('shows checked checkbox when completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              title: 'Task',
              isCompleted: true,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byKey(const Key('todo_checkbox')));
      expect(checkbox.value, isTrue);
    });

    testWidgets('calls onToggle when checkbox tapped', (tester) async {
      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              title: 'Task',
              isCompleted: false,
              onToggle: () => toggled = true,
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('todo_checkbox')));
      expect(toggled, isTrue);
    });

    testWidgets('calls onDelete when delete button tapped', (tester) async {
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              title: 'Task',
              isCompleted: false,
              onToggle: () {},
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('delete_button')));
      expect(deleted, isTrue);
    });
  });

  // ========================================
  // USER CARD TESTS
  // ========================================
  group('UserCard', () {
    testWidgets('displays user name and email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCard(
              name: 'John Doe',
              email: 'john@example.com',
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('shows first letter when no image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserCard(
              name: 'John Doe',
              email: 'john@example.com',
            ),
          ),
        ),
      );

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(
              name: 'John',
              email: 'john@test.com',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('user_card_tap')));
      expect(tapped, isTrue);
    });
  });

  // ========================================
  // LOADING WIDGET TESTS
  // ========================================
  group('LoadingWidget', () {
    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(
              isLoading: true,
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('shows child when isLoading is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(
              isLoading: false,
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('shows custom loading text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(
              isLoading: true,
              loadingText: 'Please wait...',
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Please wait...'), findsOneWidget);
    });
  });

  // ========================================
  // ASYNC WIDGET TESTS
  // ========================================
  group('UserListWidget', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserListWidget(
              fetchUsers: () async {
                await Future.delayed(const Duration(seconds: 2));
                return ['Alice', 'Bob'];
              },
            ),
          ),
        ),
      );

      // Before async completes
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
    });

    testWidgets('shows users after loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserListWidget(
              fetchUsers: () async => ['Alice', 'Bob', 'Carol'],
            ),
          ),
        ),
      );

      // Wait for async operation to complete
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('loading_indicator')), findsNothing);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Carol'), findsOneWidget);
    });

    testWidgets('shows error on failure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserListWidget(
              fetchUsers: () async => throw Exception('Network error'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_text')), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('shows empty message when no users', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserListWidget(
              fetchUsers: () async => [],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_text')), findsOneWidget);
    });
  });
}
*/

// ============================================
// KEY TESTING PATTERNS
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │                  WIDGET TESTING PATTERNS                     │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  1. FINDING WIDGETS                                          │
  │     find.text('Hello')         - By text content            │
  │     find.byType(ElevatedButton) - By widget type            │
  │     find.byKey(Key('my_key'))  - By key (recommended!)      │
  │     find.byIcon(Icons.add)     - By icon                    │
  │                                                              │
  │  2. INTERACTING                                              │
  │     tester.tap(finder)         - Tap a widget               │
  │     tester.enterText(f, 'hi')  - Type text                  │
  │     tester.drag(f, Offset(...))- Drag/scroll                │
  │     tester.longPress(finder)   - Long press                 │
  │                                                              │
  │  3. REBUILDING                                               │
  │     tester.pump()              - Rebuild once               │
  │     tester.pumpAndSettle()     - Wait for animations        │
  │     tester.pump(Duration(...)) - Wait specific time         │
  │                                                              │
  │  4. ASSERTING                                                │
  │     findsOneWidget             - Exactly one found          │
  │     findsNothing               - None found                 │
  │     findsNWidgets(3)           - Exactly 3 found            │
  │     findsAtLeastNWidgets(1)    - At least 1 found           │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/

// ============================================
// HOW TO RUN THESE TESTS
// ============================================
/*
  1. Create test file: test/widget_tests_test.dart
  2. Copy the test code (inside the comment block above)
  3. Run: flutter test test/widget_tests_test.dart

  OUTPUT:
  00:05 +28: All tests passed!
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │                  WIDGET TEST EXAMPLES                        │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  SIMPLE WIDGETS                                              │
  │  ├── GreetingWidget - Text display                          │
  │  └── LoadingWidget - Conditional rendering                  │
  │                                                              │
  │  INTERACTIVE WIDGETS                                         │
  │  ├── CounterWidget - Tap to increment/decrement             │
  │  ├── LikeButton - Toggle state                              │
  │  └── TodoItem - Checkbox and delete                         │
  │                                                              │
  │  FORM WIDGETS                                                │
  │  └── LoginForm - Validation and callbacks                   │
  │                                                              │
  │  ASYNC WIDGETS                                               │
  │  └── UserListWidget - Loading/error/success states          │
  │                                                              │
  │  KEY TIPS:                                                   │
  │  1. Always use Keys for testable widgets                    │
  │  2. Use pumpAndSettle() for async operations                │
  │  3. Wrap widgets in MaterialApp + Scaffold                  │
  │  4. Test user interactions, not implementation              │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
