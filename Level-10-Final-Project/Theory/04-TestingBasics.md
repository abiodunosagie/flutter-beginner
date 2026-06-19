# Testing Basics: Making Sure It Works

## The Big Idea In One Sentence

> A test is code that checks your code: you give it an input, run your function, and `expect` a result, so the computer catches bugs for you instead of you clicking through the app every time.

## The Simple Explanation

Imagine you're building a paper airplane. Would you throw it without checking if it's ready?

```
WITHOUT TESTING:                  WITH TESTING:
┌─────────────────┐              ┌─────────────────┐
│ Build airplane  │              │ Build airplane  │
│       ↓         │              │       ↓         │
│ Throw it!       │              │ Check wings ✓   │
│       ↓         │              │ Check nose ✓    │
│ It crashes 💥   │              │ Test small throw│
│       ↓         │              │       ↓         │
│ Start over      │              │ Throw it! ✈️    │
│                 │              │       ↓         │
│                 │              │ It flies! 🎉    │
└─────────────────┘              └─────────────────┘
```

**Testing is checking if your app works before users try it!**

---

## Types of Testing

Think of testing like checking a car:

```
┌─────────────────────────────────────────────────────────┐
│                   TYPES OF TESTS                         │
└─────────────────────────────────────────────────────────┘

UNIT TESTS (Check each part)
├── Does the engine start?
├── Do the brakes work?
└── Do the lights turn on?

WIDGET TESTS (Check combinations)
├── Does the steering move the wheels?
└── Does the brake pedal stop the car?

INTEGRATION TESTS (Check everything together)
└── Can someone drive the car from A to B?
```

---

## Unit Tests

**What:** Test one small piece of code at a time
**Where:** `test/` folder
**File naming:** `something_test.dart`

### Example: Testing a Task Model

```dart
// test/models/task_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';

void main() {
  // Group related tests together
  group('Task Model', () {

    // Test 1: Creating a task
    test('creates a task with required fields', () {
      final task = Task(
        id: '1',
        title: 'Buy groceries',
        createdAt: DateTime(2024, 1, 15),
      );

      expect(task.id, '1');
      expect(task.title, 'Buy groceries');
      expect(task.isCompleted, false); // Default value
      expect(task.description, null);  // Optional field
    });

    // Test 2: Converting to Map
    test('converts to Map correctly', () {
      final task = Task(
        id: '1',
        title: 'Test task',
        description: 'A description',
        isCompleted: true,
        createdAt: DateTime(2024, 1, 15),
      );

      final map = task.toMap();

      expect(map['id'], '1');
      expect(map['title'], 'Test task');
      expect(map['description'], 'A description');
      expect(map['is_completed'], 1); // true = 1
    });

    // Test 3: Creating from Map
    test('creates from Map correctly', () {
      final map = {
        'id': '1',
        'title': 'From map',
        'description': null,
        'is_completed': 0,
        'created_at': '2024-01-15T00:00:00.000',
      };

      final task = Task.fromMap(map);

      expect(task.id, '1');
      expect(task.title, 'From map');
      expect(task.isCompleted, false); // 0 = false
    });

    // Test 4: copyWith method
    test('copyWith creates new task with updated fields', () {
      final original = Task(
        id: '1',
        title: 'Original',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 15),
      );

      final updated = original.copyWith(isCompleted: true);

      expect(original.isCompleted, false); // Original unchanged
      expect(updated.isCompleted, true);   // New has change
      expect(updated.title, 'Original');   // Other fields same
    });
  });
}
```

### Running Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/task_test.dart

# Run with verbose output
flutter test --verbose
```

---

## Testing Providers

Providers manage your app's state. Test them too!

```dart
// test/providers/task_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/providers/task_provider.dart';
import 'package:my_app/models/task.dart';

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;

    // This runs before each test
    setUp(() {
      provider = TaskProvider();
    });

    test('starts with empty task list', () {
      expect(provider.tasks, isEmpty);
      expect(provider.totalTasks, 0);
    });

    test('adds a task correctly', () async {
      await provider.addTask('New task', null);

      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.title, 'New task');
    });

    test('toggles task completion', () async {
      // Add a task first
      await provider.addTask('Test task', null);
      final taskId = provider.tasks.first.id;

      // Toggle completion
      await provider.toggleTask(taskId);

      expect(provider.tasks.first.isCompleted, true);

      // Toggle again
      await provider.toggleTask(taskId);

      expect(provider.tasks.first.isCompleted, false);
    });

    test('deletes a task correctly', () async {
      // Add a task
      await provider.addTask('To delete', null);
      expect(provider.tasks.length, 1);

      // Delete it
      final taskId = provider.tasks.first.id;
      await provider.deleteTask(taskId);

      expect(provider.tasks, isEmpty);
    });

    test('calculates completed tasks correctly', () async {
      // Add multiple tasks
      await provider.addTask('Task 1', null);
      await provider.addTask('Task 2', null);
      await provider.addTask('Task 3', null);

      expect(provider.completedTasks, 0);
      expect(provider.pendingTasks, 3);

      // Complete one task
      await provider.toggleTask(provider.tasks.first.id);

      expect(provider.completedTasks, 1);
      expect(provider.pendingTasks, 2);
    });
  });
}
```

---

## Widget Tests

**What:** Test how widgets look and behave
**Why:** Make sure buttons work, text displays, etc.

### Example: Testing a Task Tile Widget

```dart
// test/widgets/task_tile_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/widgets/task_tile.dart';

void main() {
  group('TaskTile Widget', () {

    // Create a test task
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test description',
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    testWidgets('displays task title', (tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(task: testTask),
          ),
        ),
      );

      // Find the title text
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('displays description when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(task: testTask),
          ),
        ),
      );

      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('shows unchecked checkbox for incomplete task', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(task: testTask),
          ),
        ),
      );

      // Find checkbox
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('shows checked checkbox for complete task', (tester) async {
      final completedTask = testTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(task: completedTask),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('calls onComplete when checkbox tapped', (tester) async {
      bool wasCompleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: testTask,
              onComplete: () => wasCompleted = true,
            ),
          ),
        ),
      );

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(wasCompleted, true);
    });

    testWidgets('calls onTap when tile tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskTile(
              task: testTask,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      // Tap the tile
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(wasTapped, true);
    });
  });
}
```

---

## Testing Form Validation

```dart
// test/screens/add_task_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/add_task_screen.dart';
import 'package:my_app/providers/task_provider.dart';

void main() {
  group('AddTaskScreen', () {

    testWidgets('shows error when title is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => TaskProvider(),
            child: const AddTaskScreen(),
          ),
        ),
      );

      // Tap save button without entering title
      await tester.tap(find.text('Save Task'));
      await tester.pump();

      // Should show error message
      expect(find.text('Please enter a task title'), findsOneWidget);
    });

    testWidgets('shows error when title too short', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => TaskProvider(),
            child: const AddTaskScreen(),
          ),
        ),
      );

      // Enter short title
      await tester.enterText(find.byType(TextFormField).first, 'Hi');
      await tester.tap(find.text('Save Task'));
      await tester.pump();

      expect(find.text('Title must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('accepts valid title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => TaskProvider(),
            child: const AddTaskScreen(),
          ),
        ),
      );

      // Enter valid title
      await tester.enterText(find.byType(TextFormField).first, 'Valid Task Title');
      await tester.tap(find.text('Save Task'));
      await tester.pumpAndSettle();

      // No error should be shown
      expect(find.text('Please enter a task title'), findsNothing);
    });
  });
}
```

---

## Common Test Matchers

```dart
// EQUALITY
expect(value, 5);                    // Exactly 5
expect(value, equals(5));            // Same as above

// COMPARISON
expect(value, greaterThan(5));       // > 5
expect(value, lessThan(10));         // < 10
expect(value, greaterThanOrEqualTo(5)); // >= 5

// STRINGS
expect(text, contains('hello'));     // Contains substring
expect(text, startsWith('Hi'));      // Starts with
expect(text, endsWith('!'));         // Ends with

// LISTS
expect(list, isEmpty);               // Empty list
expect(list, isNotEmpty);            // Has items
expect(list, hasLength(3));          // Exactly 3 items
expect(list, contains('item'));      // Contains item

// NULL
expect(value, isNull);               // Is null
expect(value, isNotNull);            // Is not null

// TYPES
expect(value, isA<String>());        // Is a String
expect(value, isA<int>());           // Is an int

// WIDGETS
expect(find.text('Hello'), findsOneWidget);      // Found once
expect(find.text('Hello'), findsNothing);        // Not found
expect(find.text('Hello'), findsNWidgets(2));    // Found N times
expect(find.byType(Button), findsWidgets);       // Found at least one
```

---

## Finding Widgets in Tests

```dart
// BY TEXT
find.text('Hello World')             // Exact text match
find.textContaining('Hello')         // Contains text

// BY TYPE
find.byType(ElevatedButton)          // Find by widget type
find.byType(TextField)

// BY KEY
find.byKey(Key('save_button'))       // Find by key

// BY ICON
find.byIcon(Icons.add)               // Find by icon

// BY WIDGET
find.widgetWithText(ElevatedButton, 'Save')  // Widget with text

// DESCENDANTS
find.descendant(
  of: find.byType(Card),
  matching: find.text('Title'),
)
```

---

## Test Setup and Teardown

```dart
void main() {
  // Runs once before all tests
  setUpAll(() {
    print('Starting all tests');
  });

  // Runs before EACH test
  setUp(() {
    print('Before a test');
  });

  // Runs after EACH test
  tearDown(() {
    print('After a test');
  });

  // Runs once after all tests
  tearDownAll(() {
    print('Finished all tests');
  });

  test('my test', () {
    // Test code
  });
}
```

---

## Testing Checklist

```
BEFORE RELEASING YOUR APP:

MODEL TESTS
□ Create model with required fields
□ Create model with optional fields
□ Convert to Map/JSON
□ Create from Map/JSON
□ copyWith works correctly

PROVIDER TESTS
□ Initial state is correct
□ Add items works
□ Update items works
□ Delete items works
□ Computed properties update

WIDGET TESTS
□ Displays correct text
□ Shows correct icons
□ Buttons are tappable
□ Forms validate correctly
□ Error messages show
□ Loading states work

SCREEN TESTS
□ Navigation works
□ Data displays correctly
□ User actions work
□ Error handling works
```

---

## Common Testing Mistakes

### Mistake 1: Not Testing Edge Cases

```dart
// ❌ Only tests happy path
test('adds task', () {
  provider.addTask('Valid task');
  expect(provider.tasks.length, 1);
});

// ✅ Also tests edge cases
test('adds task with valid title', () {
  provider.addTask('Valid task');
  expect(provider.tasks.length, 1);
});

test('rejects empty title', () {
  final result = provider.addTask('');
  expect(result, false);
  expect(provider.tasks.length, 0);
});

test('rejects very long title', () {
  final longTitle = 'a' * 1000;
  final result = provider.addTask(longTitle);
  expect(result, false);
});
```

### Mistake 2: Tests Depend on Each Other

```dart
// ❌ BAD: Second test depends on first
test('adds task', () {
  provider.addTask('Task 1');
});

test('has one task', () {
  expect(provider.tasks.length, 1); // Will fail if first test doesn't run!
});

// ✅ GOOD: Each test is independent
test('adds task', () {
  final provider = TaskProvider();
  provider.addTask('Task 1');
  expect(provider.tasks.length, 1);
});

test('starts empty', () {
  final provider = TaskProvider();
  expect(provider.tasks.length, 0);
});
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│               TESTING BASICS SUMMARY                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  UNIT TESTS                                              │
│  └── Test individual functions and classes              │
│                                                          │
│  WIDGET TESTS                                            │
│  └── Test UI components in isolation                    │
│                                                          │
│  INTEGRATION TESTS                                       │
│  └── Test complete user flows                           │
│                                                          │
│  KEY COMMANDS                                            │
│  ├── flutter test              (run all tests)          │
│  └── flutter test --coverage   (with coverage report)   │
│                                                          │
│  BEST PRACTICES                                          │
│  ├── Test one thing per test                            │
│  ├── Tests should be independent                        │
│  ├── Test edge cases, not just happy path              │
│  └── Run tests before every release                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does `expect(actual, expected)` do in a test?

<details>
<summary>Answer</summary>
It checks that `actual` matches `expected`. If not, the test fails and tells you something broke.
</details>

**Q2.** Why write tests instead of just clicking through the app?

<details>
<summary>Answer</summary>
Tests run instantly and automatically every time, catching bugs you would miss or get tired of checking by hand.
</details>

**Q3.** What is a "unit test" testing?

<details>
<summary>Answer</summary>
One small piece (a unit) of logic in isolation, like a single function or method, without the UI.
</details>

---

## Assignment

### Problem 1: Write a tiny test

You have `int add(int a, int b) => a + b;`. Write a `test` that checks `add(2, 3)` equals `5`.

### Problem 2: Read a failure

A test says `Expected: 5, Actual: 6`. What does that tell you?

### Problem 3: What to test first

For a calculator app, name one piece of logic worth a unit test.

---

## Assignment Answers

### Problem 1: Write a tiny test

```dart
test('add returns the sum', () {
  expect(add(2, 3), 5);
});
```

### Problem 2: Read a failure

Your code returned 6 when it should return 5, so there is a bug in the function (or the test's expectation is wrong). Either way, something does not match and needs fixing.

### Problem 3: What to test first

The math/logic: for example, that adding, subtracting, or computing a total returns the right number. (Pure logic is the easiest and most valuable to unit test.)

---

**Next:** `05-PolishAndFinish.md` - Making your app look professional
