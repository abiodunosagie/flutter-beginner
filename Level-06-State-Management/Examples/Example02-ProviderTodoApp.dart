// Example 02: Provider Todo App
// A complete todo app demonstrating Provider patterns

// pubspec.yaml dependencies:
// provider: ^6.1.1

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

/// Todo item model
class Todo {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create a copy with some fields changed
  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt,
    );
  }
}

/// Filter options for the todo list
enum TodoFilter { all, completed, pending }

// ═══════════════════════════════════════════════════════════════
// PROVIDER (State Management)
// ═══════════════════════════════════════════════════════════════

class TodoProvider extends ChangeNotifier {
  // Private state
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  // Getters
  List<Todo> get todos => List.unmodifiable(_todos);
  TodoFilter get filter => _filter;

  /// Get filtered todos based on current filter
  List<Todo> get filteredTodos {
    switch (_filter) {
      case TodoFilter.completed:
        return _todos.where((t) => t.completed).toList();
      case TodoFilter.pending:
        return _todos.where((t) => !t.completed).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  /// Count getters
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.completed).length;
  int get pendingCount => _todos.where((t) => !t.completed).length;

  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (_todos.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  // ─────────────────────────────────────────────────────────
  // METHODS
  // ─────────────────────────────────────────────────────────

  /// Add a new todo
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _todos.add(todo);
    notifyListeners();
  }

  /// Toggle todo completion status
  void toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        completed: !_todos[index].completed,
      );
      notifyListeners();
    }
  }

  /// Delete a todo
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Edit todo title
  void editTodo(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(title: newTitle.trim());
      notifyListeners();
    }
  }

  /// Set the filter
  void setFilter(TodoFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  /// Clear all completed todos
  void clearCompleted() {
    _todos.removeWhere((t) => t.completed);
    notifyListeners();
  }

  /// Mark all as completed
  void markAllCompleted() {
    for (var i = 0; i < _todos.length; i++) {
      if (!_todos[i].completed) {
        _todos[i] = _todos[i].copyWith(completed: true);
      }
    }
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN PAGE
// ═══════════════════════════════════════════════════════════════

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  context.read<TodoProvider>().clearCompleted();
                  break;
                case 'complete_all':
                  context.read<TodoProvider>().markAllCompleted();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'complete_all',
                child: Text('Mark all completed'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Section
          const _ProgressSection(),

          // Filter Section
          const _FilterSection(),

          // Todo List
          const Expanded(child: _TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'What needs to be done?',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<TodoProvider>().addTodo(value);
                Navigator.pop(dialogContext);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<TodoProvider>().addTodo(controller.text);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROGRESS SECTION
// ═══════════════════════════════════════════════════════════════

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    label: 'Total',
                    count: provider.totalCount,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    label: 'Done',
                    count: provider.completedCount,
                    color: Colors.green,
                  ),
                  _StatCard(
                    label: 'Pending',
                    count: provider.pendingCount,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: provider.progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    provider.progress == 1.0 ? Colors.green : Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(provider.progress * 100).toInt()}% completed',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FILTER SECTION
// ═══════════════════════════════════════════════════════════════

class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: TodoFilter.values.map((filter) {
              final isSelected = provider.filter == filter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(
                    _filterLabel(filter),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.indigo,
                  onSelected: (_) {
                    context.read<TodoProvider>().setFilter(filter);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _filterLabel(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.all:
        return 'All';
      case TodoFilter.completed:
        return 'Completed';
      case TodoFilter.pending:
        return 'Pending';
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO LIST
// ═══════════════════════════════════════════════════════════════

class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final todos = provider.filteredTodos;

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.filter == TodoFilter.all
                      ? 'No todos yet!\nTap + to add one.'
                      : 'No ${provider.filter.name} todos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _TodoItem(todo: todo);
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO ITEM
// ═══════════════════════════════════════════════════════════════

class _TodoItem extends StatelessWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TodoProvider>().deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${todo.title}"'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Note: For proper undo, you'd need to store deleted items
                // This is simplified for the example
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (_) {
              context.read<TodoProvider>().toggleTodo(todo.id);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.completed ? TextDecoration.lineThrough : null,
              color: todo.completed ? Colors.grey : null,
            ),
          ),
          subtitle: Text(
            _formatDate(todo.createdAt),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditDialog(context, todo),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final controller = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<TodoProvider>().editTodo(todo.id, controller.text);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Complex State Management
 *    - Multiple state variables (_todos, _filter)
 *    - Computed properties (filteredTodos, progress)
 *
 * 2. List Operations
 *    - Add, edit, delete items
 *    - Filtering lists
 *    - Returning unmodifiable lists
 *
 * 3. Consumer Widget
 *    - Rebuilds only when state changes
 *    - Used throughout for reactive UI
 *
 * 4. context.read<T>()
 *    - Used in callbacks (onPressed, etc.)
 *    - Doesn't trigger rebuilds
 *
 * 5. UI Patterns
 *    - Progress indicators
 *    - Filter chips
 *    - Dismissible for swipe-to-delete
 *    - Dialogs for input
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add priority levels (high, medium, low)
 * 2. Add due dates with reminders
 * 3. Add categories/tags
 * 4. Implement proper undo for delete
 * 5. Persist todos to local storage
 * 6. Add search functionality
 *
 */
