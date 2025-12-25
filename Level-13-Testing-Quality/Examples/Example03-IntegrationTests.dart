// ============================================
// EXAMPLE 03: INTEGRATION TESTS
// Complete working examples of integration testing
// ============================================

// ============================================
// WHAT WE'RE BUILDING
// ============================================
/*
  This file shows integration tests for:
  1. Complete user flows
  2. Multi-screen navigation
  3. Form submission flows
  4. State persistence across screens

  Think of integration tests like testing a whole
  LEGO castle - all the pieces working together!

  IMPORTANT: Integration tests run on a real device
  or emulator, testing the actual app!
*/

// ============================================
// PROJECT STRUCTURE FOR INTEGRATION TESTS
// ============================================
/*
  your_project/
  ├── lib/
  │   └── main.dart
  ├── test/                    ← Unit & Widget tests
  │   └── ...
  └── integration_test/        ← Integration tests go HERE!
      └── app_test.dart        ← Main integration test file
*/

// ============================================
// SETUP: pubspec.yaml
// ============================================
/*
  dev_dependencies:
    flutter_test:
      sdk: flutter
    integration_test:
      sdk: flutter
*/

// ============================================
// EXAMPLE APP TO TEST
// ============================================

/*
// lib/main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

// --- Todo Model ---
class Todo {
  final String id;
  final String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// --- Todo List Screen ---
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toString(),
        title: title,
      ));
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
      ),
      body: _todos.isEmpty
          ? const Center(
              key: Key('empty_message'),
              child: Text('No todos yet! Add one.'),
            )
          : ListView.builder(
              key: const Key('todo_list'),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  key: Key('todo_${todo.id}'),
                  leading: Checkbox(
                    key: Key('checkbox_${todo.id}'),
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodo(todo.id),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    key: Key('delete_${todo.id}'),
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTodo(todo.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoDetailScreen(todo: todo),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_button'),
        onPressed: () async {
          final title = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTodoScreen(),
            ),
          );
          if (title != null && title.isNotEmpty) {
            _addTodo(title);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- Add Todo Screen ---
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('todo_input'),
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'What needs to be done?',
                hintText: 'Enter todo title',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('save_button'),
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Todo Detail Screen ---
class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              key: const Key('detail_title'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              todo.isCompleted ? 'Status: Completed' : 'Status: Pending',
              key: const Key('detail_status'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
*/

// ============================================
// INTEGRATION TESTS
// ============================================

/*
// integration_test/app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  // REQUIRED: Initialize the integration test binding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Todo App Integration Tests', () {
    // ========================================
    // TEST 1: App starts correctly
    // ========================================
    testWidgets('app starts and shows empty state', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify empty state is shown
      expect(find.byKey(const Key('empty_message')), findsOneWidget);
      expect(find.text('No todos yet! Add one.'), findsOneWidget);

      // Verify FAB is present
      expect(find.byKey(const Key('add_button')), findsOneWidget);
    });

    // ========================================
    // TEST 2: Add a new todo
    // ========================================
    testWidgets('can add a new todo', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap the add button
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Verify we're on the Add Todo screen
      expect(find.text('Add Todo'), findsOneWidget);

      // Enter todo title
      await tester.enterText(
        find.byKey(const Key('todo_input')),
        'Buy groceries',
      );
      await tester.pumpAndSettle();

      // Tap save
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // Verify we're back on the list screen
      expect(find.text('My Todos'), findsOneWidget);

      // Verify the todo appears in the list
      expect(find.text('Buy groceries'), findsOneWidget);

      // Verify empty state is gone
      expect(find.byKey(const Key('empty_message')), findsNothing);
    });

    // ========================================
    // TEST 3: Complete a todo
    // ========================================
    testWidgets('can mark todo as completed', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // First add a todo
      await _addTodo(tester, 'Exercise');

      // Find the checkbox (it will have a dynamic key based on ID)
      // For simplicity, find by type since there's only one
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      // Verify it starts unchecked
      Checkbox checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isFalse);

      // Tap to complete
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Verify it's now checked
      checkboxWidget = tester.widget(checkbox);
      expect(checkboxWidget.value, isTrue);
    });

    // ========================================
    // TEST 4: Delete a todo
    // ========================================
    testWidgets('can delete a todo', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a todo
      await _addTodo(tester, 'Clean room');
      expect(find.text('Clean room'), findsOneWidget);

      // Find and tap delete button
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify todo is gone
      expect(find.text('Clean room'), findsNothing);

      // Verify empty state is back
      expect(find.byKey(const Key('empty_message')), findsOneWidget);
    });

    // ========================================
    // TEST 5: Navigate to detail screen
    // ========================================
    testWidgets('can navigate to todo details', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a todo
      await _addTodo(tester, 'Read book');

      // Tap on the todo item (not checkbox or delete)
      await tester.tap(find.text('Read book'));
      await tester.pumpAndSettle();

      // Verify we're on detail screen
      expect(find.text('Todo Details'), findsOneWidget);
      expect(find.byKey(const Key('detail_title')), findsOneWidget);
      expect(find.text('Read book'), findsOneWidget);
      expect(find.text('Status: Pending'), findsOneWidget);

      // Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on list
      expect(find.text('My Todos'), findsOneWidget);
    });

    // ========================================
    // TEST 6: Complete user journey
    // ========================================
    testWidgets('complete user journey: add, complete, delete', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // STEP 1: Start with empty state
      expect(find.byKey(const Key('empty_message')), findsOneWidget);

      // STEP 2: Add first todo
      await _addTodo(tester, 'Morning workout');
      expect(find.text('Morning workout'), findsOneWidget);
      expect(find.byKey(const Key('empty_message')), findsNothing);

      // STEP 3: Add second todo
      await _addTodo(tester, 'Read 30 minutes');
      expect(find.text('Read 30 minutes'), findsOneWidget);

      // STEP 4: Add third todo
      await _addTodo(tester, 'Call mom');
      expect(find.text('Call mom'), findsOneWidget);

      // Verify we have 3 todos
      expect(find.byType(ListTile), findsNWidgets(3));

      // STEP 5: Complete the first todo
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();

      // STEP 6: Delete the second todo
      final deleteButtons = find.byIcon(Icons.delete);
      await tester.tap(deleteButtons.at(1));
      await tester.pumpAndSettle();

      // Verify only 2 todos remain
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Read 30 minutes'), findsNothing);

      // STEP 7: Verify first todo shows completed styling
      // (We would check for line-through decoration if accessible)
    });

    // ========================================
    // TEST 7: Empty input handling
    // ========================================
    testWidgets('handles empty input gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go to add screen
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Don't enter anything, just save
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // Should be back on list screen with no todos added
      expect(find.text('My Todos'), findsOneWidget);
      expect(find.byKey(const Key('empty_message')), findsOneWidget);
    });

    // ========================================
    // TEST 8: Multiple rapid actions
    // ========================================
    testWidgets('handles multiple rapid additions', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add 5 todos quickly
      for (int i = 1; i <= 5; i++) {
        await _addTodo(tester, 'Todo item $i');
      }

      // Verify all 5 are present
      expect(find.byType(ListTile), findsNWidgets(5));
      expect(find.text('Todo item 1'), findsOneWidget);
      expect(find.text('Todo item 5'), findsOneWidget);
    });
  });
}

// ============================================
// HELPER FUNCTIONS
// ============================================

/// Adds a todo with the given title
Future<void> _addTodo(WidgetTester tester, String title) async {
  // Tap add button
  await tester.tap(find.byKey(const Key('add_button')));
  await tester.pumpAndSettle();

  // Enter title
  await tester.enterText(find.byKey(const Key('todo_input')), title);
  await tester.pumpAndSettle();

  // Save
  await tester.tap(find.byKey(const Key('save_button')));
  await tester.pumpAndSettle();
}
*/

// ============================================
// RUNNING INTEGRATION TESTS
// ============================================
/*
  # Run on connected device or emulator:
  flutter test integration_test/app_test.dart

  # Run with specific device:
  flutter test integration_test/app_test.dart -d <device_id>

  # Run all integration tests:
  flutter test integration_test/

  # Run with verbose output:
  flutter test integration_test/app_test.dart --verbose

  # Common device IDs:
  # - chrome (web)
  # - macos (macOS desktop)
  # - linux (Linux desktop)
  # - windows (Windows desktop)
  # - <emulator_id> (Android/iOS simulator)
*/

// ============================================
// BEST PRACTICES FOR INTEGRATION TESTS
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │           INTEGRATION TEST BEST PRACTICES                    │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  1. USE KEYS                                                 │
  │     - Always add Keys to widgets you need to find           │
  │     - Makes tests more reliable than finding by text        │
  │                                                              │
  │  2. USE pumpAndSettle()                                      │
  │     - Waits for all animations to complete                  │
  │     - Essential after navigation and state changes          │
  │                                                              │
  │  3. TEST REAL USER FLOWS                                     │
  │     - Focus on end-to-end journeys                          │
  │     - Test what users actually do                           │
  │                                                              │
  │  4. KEEP TESTS INDEPENDENT                                   │
  │     - Each test should start fresh                          │
  │     - Don't rely on state from previous tests               │
  │                                                              │
  │  5. USE HELPER FUNCTIONS                                     │
  │     - Extract common actions (like _addTodo)                │
  │     - Makes tests more readable                             │
  │                                                              │
  │  6. TEST EDGE CASES                                          │
  │     - Empty inputs                                           │
  │     - Rapid actions                                          │
  │     - Network failures (if applicable)                       │
  │                                                              │
  │  7. DON'T OVERDO IT                                          │
  │     - Integration tests are slow                            │
  │     - Test critical paths, not every detail                 │
  │     - Leave detail testing to unit/widget tests             │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/

// ============================================
// COMMON INTEGRATION TEST PATTERNS
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │             COMMON TESTING PATTERNS                          │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  NAVIGATION TESTING                                          │
  │  ────────────────                                            │
  │  // Navigate forward                                         │
  │  await tester.tap(find.text('Details'));                    │
  │  await tester.pumpAndSettle();                              │
  │  expect(find.text('Detail Screen'), findsOneWidget);        │
  │                                                              │
  │  // Navigate back                                            │
  │  await tester.tap(find.byType(BackButton));                 │
  │  await tester.pumpAndSettle();                              │
  │                                                              │
  │  SCROLLING                                                   │
  │  ─────────                                                   │
  │  // Scroll down                                              │
  │  await tester.drag(                                         │
  │    find.byType(ListView),                                   │
  │    const Offset(0, -300), // Negative = scroll down         │
  │  );                                                          │
  │  await tester.pumpAndSettle();                              │
  │                                                              │
  │  // Scroll until visible                                     │
  │  await tester.scrollUntilVisible(                           │
  │    find.text('Item 50'),                                    │
  │    500, // scroll delta                                     │
  │  );                                                          │
  │                                                              │
  │  WAITING FOR ASYNC OPERATIONS                                │
  │  ────────────────────────────                                │
  │  // Wait for loading to complete                            │
  │  await tester.pumpAndSettle(                                │
  │    const Duration(seconds: 5),                              │
  │  );                                                          │
  │                                                              │
  │  // Or pump specific duration                               │
  │  await tester.pump(const Duration(seconds: 2));             │
  │                                                              │
  │  FINDING WIDGETS IN LISTS                                    │
  │  ────────────────────────                                    │
  │  // Find first item                                          │
  │  find.byType(ListTile).first                                │
  │                                                              │
  │  // Find specific item                                       │
  │  find.byType(ListTile).at(2)                                │
  │                                                              │
  │  // Find by ancestor                                         │
  │  find.descendant(                                           │
  │    of: find.byKey(Key('todo_item')),                        │
  │    matching: find.byType(Checkbox),                         │
  │  );                                                          │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │             INTEGRATION TEST EXAMPLES                        │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  TESTS COVERED:                                              │
  │  ├── App startup and empty state                            │
  │  ├── Adding new items                                       │
  │  ├── Completing items (checkbox toggle)                     │
  │  ├── Deleting items                                         │
  │  ├── Navigation between screens                             │
  │  ├── Complete user journeys                                 │
  │  ├── Edge cases (empty input)                               │
  │  └── Stress testing (rapid actions)                         │
  │                                                              │
  │  KEY TECHNIQUES:                                             │
  │  ├── IntegrationTestWidgetsFlutterBinding                   │
  │  ├── pumpAndSettle() for animations                         │
  │  ├── Using Keys for reliable widget finding                 │
  │  ├── Helper functions for common actions                    │
  │  └── Testing full user flows                                │
  │                                                              │
  │  REMEMBER:                                                   │
  │  • Integration tests go in integration_test/ folder         │
  │  • They run on real devices/emulators                       │
  │  • They're slower than unit/widget tests                    │
  │  • Use them for critical user journeys                      │
  │                                                              │
  │  COMMAND:                                                    │
  │  flutter test integration_test/app_test.dart                │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
