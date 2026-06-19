# Performance & Best Practices - Interview Questions

## The Big Idea In One Sentence

> Be able to name the everyday wins (use `const`, `ListView.builder`, keep rebuilds small, hit 60fps) and explain that you always measure with DevTools before optimizing.

Learn how to build fast, efficient Flutter apps - a key interview topic!

---

## Performance Optimization

### Q1: How do you optimize Flutter app performance?

**Answer:**

**Top 10 Performance Tips:**

```dart
// ═══════════════════════════════════════════════════════════
// 1. Use const widgets
// ═══════════════════════════════════════════════════════════

// ❌ Bad - Creates new widget every rebuild
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Title'),           // New widget every time
      Icon(Icons.home),        // New widget every time
    ],
  );
}

// ✅ Good - Reuses same widget
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('Title'),     // Created once, reused
      const Icon(Icons.home),  // Created once, reused
    ],
  );
}

// ═══════════════════════════════════════════════════════════
// 2. Use ListView.builder for long lists
// ═══════════════════════════════════════════════════════════

// ❌ Bad - Creates ALL items at once (memory intensive)
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ Good - Creates items on demand (lazy loading)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ═══════════════════════════════════════════════════════════
// 3. Avoid rebuilding entire tree
// ═══════════════════════════════════════════════════════════

// ❌ Bad - Entire tree rebuilds
class _MyPageState extends State<MyPage> {
  int _counter = 0;

  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(),     // Rebuilds even though it doesn't use _counter!
        Text('$_counter'),
      ],
    );
  }
}

// ✅ Good - Only counter rebuilds
class _MyPageState extends State<MyPage> {
  int _counter = 0;

  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(),  // const = never rebuilds
        Text('$_counter'),        // Only this rebuilds
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 4. Use RepaintBoundary for expensive widgets
// ═══════════════════════════════════════════════════════════

RepaintBoundary(
  child: ExpensiveChart(),  // Isolate repaints to this widget only
)

// ═══════════════════════════════════════════════════════════
// 5. Avoid anonymous functions in build
// ═══════════════════════════════════════════════════════════

// ❌ Bad - New function created every build
ElevatedButton(
  onPressed: () {
    print('Clicked');
  },
  child: Text('Click'),
)

// ✅ Good - Function created once
class _MyWidgetState extends State<MyWidget> {
  void _handleClick() {
    print('Clicked');
  }

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleClick,
      child: Text('Click'),
    );
  }
}
```

**More tips:**
- Cache images
- Use `ListView.builder` instead of `ListView`
- Minimize `build()` method
- Avoid `Opacity` widget (use `AnimatedOpacity`)
- Use `AutomaticKeepAliveClientMixin` for tabs

---

### Q2: What is the difference between ListView and ListView.builder?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// ListView - Builds ALL children at once
// ═══════════════════════════════════════════════════════════

ListView(
  children: [
    ItemWidget(item1),  // All created immediately
    ItemWidget(item2),  // Even if not visible!
    ItemWidget(item3),
    // ... 1000 more items
  ],
)

// Performance:
// ❌ Creates 1000 widgets immediately
// ❌ Uses lots of memory
// ❌ Slow initial load

// ═══════════════════════════════════════════════════════════
// ListView.builder - Builds items on demand (lazy)
// ═══════════════════════════════════════════════════════════

ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);  // Only created when scrolled into view
  },
)

// Performance:
// ✅ Creates only visible items (~10)
// ✅ Low memory usage
// ✅ Fast initial load
```

**Visual:**
```
ListView:
[Item1] [Item2] [Item3] ... [Item1000]  ← All in memory
   ↑       ↑       ↑
  Screen shows only these 3, but all 1000 exist!


ListView.builder:
[Item1] [Item2] [Item3]  ← Only these 3 in memory
   ↑       ↑       ↑
  Creates more as you scroll
```

**Memory tip:** `ListView.builder` = Netflix (loads as you watch), `ListView` = Downloads all episodes first

---

### Q3: What is RepaintBoundary and when to use it?

**Answer:**

`RepaintBoundary` isolates widget repainting - only repaints the widget inside, not the whole screen.

```dart
// Without RepaintBoundary:
class _MyPageState extends State<MyPage> {
  int _counter = 0;

  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveChart(),      // Repaints every time _counter changes!
        Text('$_counter'),
      ],
    );
  }
}

// Entire screen repaints:
// ┌─────────────────────┐
// │ ExpensiveChart      │ ← Repainted (slow!)
// │ (unchanged!)        │
// ├─────────────────────┤
// │ Counter: 5 → 6      │ ← Changed
// └─────────────────────┘


// With RepaintBoundary:
class _MyPageState extends State<MyPage> {
  int _counter = 0;

  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: ExpensiveChart(),  // NOT repainted!
        ),
        Text('$_counter'),
      ],
    );
  }
}

// Only counter repaints:
// ┌─────────────────────┐
// │ ExpensiveChart      │ ← Not repainted (fast!)
// │ (cached)            │
// ├─────────────────────┤
// │ Counter: 5 → 6      │ ← Only this repaints
// └─────────────────────┘
```

**When to use:**
- Complex charts/graphs
- Custom paintings
- Animations that don't affect siblings
- Heavy widgets that rarely change

**When NOT to use:**
- Simple widgets (Text, Icon)
- Widgets that change often
- Everywhere (adds overhead)

---

### Q4: How do you profile a Flutter app?

**Answer:**

**Using Flutter DevTools:**

```bash
# 1. Run app in profile mode
flutter run --profile

# 2. Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**What to check:**

```
1. Performance Tab
   ─────────────
   • Frame rendering time (should be < 16ms for 60fps)
   • Identify slow build() methods
   • Find expensive operations

2. Memory Tab
   ──────────
   • Memory leaks
   • Objects not being disposed
   • Memory spikes

3. Network Tab
   ───────────
   • API response times
   • Large payloads
   • Failed requests
```

**Common issues to look for:**

```dart
// 1. Slow build methods
Widget build(BuildContext context) {
  // ❌ Heavy computation in build
  final data = heavyCalculation();  // This runs every rebuild!

  // ✅ Compute once, cache result
  // Or use FutureBuilder
}

// 2. Memory leaks
class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen(...);
  }

  // ❌ Memory leak - subscription never cancelled
  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }

  // ✅ Proper cleanup
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

---

## Best Practices

### Q5: What are Flutter best practices for project structure?

**Answer:**

```
lib/
├── main.dart
├── app/
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   └── strings.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── errors/
│       └── exceptions.dart
├── data/
│   ├── models/
│   │   └── user.dart
│   ├── repositories/
│   │   └── user_repository.dart
│   └── api/
│       └── api_service.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── widgets/
│   │   │   └── login_form.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   └── home/
│       ├── screens/
│       ├── widgets/
│       └── providers/
└── shared/
    └── widgets/
        ├── custom_button.dart
        └── loading_indicator.dart
```

**Key principles:**
- Feature-first structure
- Separate data layer
- Shared widgets folder
- Clear naming conventions

---

### Q6: What are naming conventions in Flutter?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// Files: lowercase_with_underscores.dart
// ═══════════════════════════════════════════════════════════

// ✅ Good
user_profile_screen.dart
api_service.dart

// ❌ Bad
UserProfileScreen.dart
ApiService.dart

// ═══════════════════════════════════════════════════════════
// Classes: UpperCamelCase
// ═══════════════════════════════════════════════════════════

class UserProfile {}
class ApiService {}

// ═══════════════════════════════════════════════════════════
// Variables & Methods: lowerCamelCase
// ═══════════════════════════════════════════════════════════

int userCount = 0;
void fetchUserData() {}

// ═══════════════════════════════════════════════════════════
// Constants: lowerCamelCase
// ═══════════════════════════════════════════════════════════

const double maxWidth = 500;
const String apiKey = 'abc123';

// ═══════════════════════════════════════════════════════════
// Private members: Start with _
// ═══════════════════════════════════════════════════════════

int _privateCounter = 0;
void _privateMethod() {}

// ═══════════════════════════════════════════════════════════
// Widget naming
// ═══════════════════════════════════════════════════════════

// Screens: [Feature]Screen
class LoginScreen extends StatelessWidget {}
class HomeScreen extends StatelessWidget {}

// Widgets: Descriptive names
class UserCard extends StatelessWidget {}
class CustomButton extends StatelessWidget {}

// State classes: _[Widget]State
class _LoginScreenState extends State<LoginScreen> {}
```

---

### Q7: How do you handle errors in Flutter?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// 1. Try-Catch for synchronous code
// ═══════════════════════════════════════════════════════════

void divide(int a, int b) {
  try {
    final result = a ~/ b;
    print(result);
  } catch (e) {
    print('Error: Cannot divide by zero');
  }
}

// ═══════════════════════════════════════════════════════════
// 2. Try-Catch for async code
// ═══════════════════════════════════════════════════════════

Future<void> fetchUser() async {
  try {
    final user = await apiService.getUser();
    print(user.name);
  } on NetworkException {
    print('Network error');
  } on ServerException {
    print('Server error');
  } catch (e) {
    print('Unknown error: $e');
  } finally {
    print('Cleanup');
  }
}

// ═══════════════════════════════════════════════════════════
// 3. Global error handling
// ═══════════════════════════════════════════════════════════

void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    print('Flutter Error: ${details.exception}');
    // Send to crash reporting service
  };

  // Catch async errors
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    print('Async Error: $error');
  });
}

// ═══════════════════════════════════════════════════════════
// 4. Custom error widgets
// ═══════════════════════════════════════════════════════════

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text(message),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 5. Result pattern (no exceptions)
// ═══════════════════════════════════════════════════════════

class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
}

Future<Result<User>> fetchUser() async {
  try {
    final user = await apiService.getUser();
    return Result.success(user);
  } catch (e) {
    return Result.failure(e.toString());
  }
}

// Usage
final result = await fetchUser();
if (result.isSuccess) {
  print('User: ${result.data!.name}');
} else {
  print('Error: ${result.error}');
}
```

---

### Q8: How do you handle null safety in Flutter?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// Nullable vs Non-nullable
// ═══════════════════════════════════════════════════════════

String name = 'John';    // Non-nullable (cannot be null)
String? email;           // Nullable (can be null)

// ═══════════════════════════════════════════════════════════
// Null checks
// ═══════════════════════════════════════════════════════════

// 1. If null check
if (email != null) {
  print(email.length);  // Safe: email is promoted to non-nullable
}

// 2. Null-aware operator ?.
print(email?.length);   // Returns null if email is null

// 3. Null coalescing ??
String displayEmail = email ?? 'No email';  // Use 'No email' if null

// 4. Null assertion ! (dangerous)
print(email!.length);   // ⚠️ Crashes if email is null!

// ═══════════════════════════════════════════════════════════
// Late variables
// ═══════════════════════════════════════════════════════════

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;  // Will initialize later

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, ...);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════
// Required parameters
// ═══════════════════════════════════════════════════════════

class User {
  final String name;
  final String? email;  // Optional

  User({
    required this.name,  // Must provide
    this.email,          // Optional
  });
}

// Usage
final user1 = User(name: 'John');               // ✅ OK
final user2 = User(name: 'Jane', email: '...');  // ✅ OK
final user3 = User(email: '...');               // ❌ Error: name required
```

---

## Security

### Q9: How do you secure API keys in Flutter?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// ❌ NEVER store keys in code
// ═══════════════════════════════════════════════════════════

// ❌ BAD - Visible in code
const apiKey = 'sk_live_abc123xyz';

// ═══════════════════════════════════════════════════════════
// ✅ Use environment variables
// ═══════════════════════════════════════════════════════════

// 1. Create .env file (add to .gitignore)
// .env
// API_KEY=sk_live_abc123xyz

// 2. Use flutter_dotenv package
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// 3. Access keys
final apiKey = dotenv.env['API_KEY'];

// ═══════════════════════════════════════════════════════════
// ✅ Use dart-define (compile-time)
// ═══════════════════════════════════════════════════════════

// Run with:
// flutter run --dart-define=API_KEY=your_key_here

// Access in code:
const apiKey = String.fromEnvironment('API_KEY');

// ═══════════════════════════════════════════════════════════
// ✅ Store sensitive keys on backend
// ═══════════════════════════════════════════════════════════

// BEST: Never put sensitive keys in app
// Instead: App → Your Backend → Third-party API
```

**Best practices:**
- Never commit keys to git
- Use backend proxy for sensitive operations
- Rotate keys regularly
- Different keys for dev/prod

---

### Q10: What are common security mistakes in Flutter?

**Answer:**

```dart
// ═══════════════════════════════════════════════════════════
// 1. SQL Injection (if using local database)
// ═══════════════════════════════════════════════════════════

// ❌ Bad - SQL injection vulnerable
final query = "SELECT * FROM users WHERE name = '$userName'";
db.rawQuery(query);

// ✅ Good - Use parameterized queries
db.query('users', where: 'name = ?', whereArgs: [userName]);

// ═══════════════════════════════════════════════════════════
// 2. Insecure HTTP (not HTTPS)
// ═══════════════════════════════════════════════════════════

// ❌ Bad - Unencrypted
const apiUrl = 'http://api.example.com';

// ✅ Good - Encrypted
const apiUrl = 'https://api.example.com';

// ═══════════════════════════════════════════════════════════
// 3. Storing sensitive data in SharedPreferences
// ═══════════════════════════════════════════════════════════

// ❌ Bad - Not encrypted
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('password', password);

// ✅ Good - Use flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'password', value: password);

// ═══════════════════════════════════════════════════════════
// 4. Not validating user input
// ═══════════════════════════════════════════════════════════

// ❌ Bad - No validation
void submitForm() {
  sendToAPI(emailController.text);
}

// ✅ Good - Validate first
void submitForm() {
  if (isValidEmail(emailController.text)) {
    sendToAPI(emailController.text);
  } else {
    showError('Invalid email');
  }
}
```

---

## Summary

**Performance:**
- Use `const` widgets
- `ListView.builder` for lists
- Cache expensive computations
- Profile with DevTools

**Best Practices:**
- Feature-first structure
- Clear naming conventions
- Proper error handling
- Always clean up resources (dispose)

**Security:**
- Never hardcode API keys
- Use HTTPS
- Encrypt sensitive data
- Validate user input

**Quick Checklist:**
```
✅ All StatefulWidgets have dispose()?
✅ Using const where possible?
✅ ListView.builder for long lists?
✅ No secrets in code?
✅ All async operations check mounted?
✅ Proper error handling?
```

---

## Assignment

Answer each out loud, then check.

### Problem 1: const

Why does using `const` widgets help performance?

### Problem 2: Long lists

Why `ListView.builder` over a `ListView` with all children?

### Problem 3: Optimize order

Before optimizing, what should you always do first?

---

## Assignment Answers

### Problem 1: const

`const` widgets are built once and reused, so Flutter can skip rebuilding them on each frame.

### Problem 2: Long lists

`ListView.builder` builds only visible items lazily, saving memory and build time versus building every item up front.

### Problem 3: Optimize order

Measure/profile first (with DevTools) to find the real bottleneck, so you optimize what is actually slow.

---

**Continue to:** `06-PracticalCoding.md`
