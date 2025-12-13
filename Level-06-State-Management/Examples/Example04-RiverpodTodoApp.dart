// Example 04: Riverpod Todo App
// A complete todo app using Riverpod with advanced patterns

// pubspec.yaml dependencies:
// flutter_riverpod: ^2.4.9

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

class Todo {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    this.completed = false,
    required this.createdAt,
  });

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt,
    );
  }
}

enum TodoFilter { all, completed, pending }

// ═══════════════════════════════════════════════════════════════
// PROVIDERS
// ═══════════════════════════════════════════════════════════════

/// Main todos list - using StateNotifier for complex operations
class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void add(String title) {
    if (title.trim().isEmpty) return;

    state = [
      ...state,
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now(),
      ),
    ];
  }

  void toggle(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  }

  void delete(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void edit(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(title: newTitle.trim());
      }
      return todo;
    }).toList();
  }

  void clearCompleted() {
    state = state.where((todo) => !todo.completed).toList();
  }

  void markAllComplete() {
    state = state.map((todo) => todo.copyWith(completed: true)).toList();
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

/// Current filter - simple StateProvider
final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

/// Filtered todos - computed from todos and filter
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(filterProvider);

  switch (filter) {
    case TodoFilter.completed:
      return todos.where((t) => t.completed).toList();
    case TodoFilter.pending:
      return todos.where((t) => !t.completed).toList();
    case TodoFilter.all:
    default:
      return todos;
  }
});

/// Stats - computed from todos
final todoStatsProvider = Provider<Map<String, int>>((ref) {
  final todos = ref.watch(todosProvider);
  return {
    'total': todos.length,
    'completed': todos.where((t) => t.completed).length,
    'pending': todos.where((t) => !t.completed).length,
  };
});

/// Progress percentage
final progressProvider = Provider<double>((ref) {
  final stats = ref.watch(todoStatsProvider);
  final total = stats['total'] ?? 0;
  final completed = stats['completed'] ?? 0;

  if (total == 0) return 0.0;
  return completed / total;
});

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN PAGE
// ═══════════════════════════════════════════════════════════════

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  ref.read(todosProvider.notifier).clearCompleted();
                  break;
                case 'complete_all':
                  ref.read(todosProvider.notifier).markAllComplete();
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'complete_all',
                child: Text('Mark all complete'),
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
          const _StatsSection(),
          const _FilterSection(),
          const Expanded(child: _TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
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
                ref.read(todosProvider.notifier).add(value);
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
                  ref.read(todosProvider.notifier).add(controller.text);
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
// STATS SECTION (uses computed providers)
// ═══════════════════════════════════════════════════════════════

class _StatsSection extends ConsumerWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using computed providers!
    final stats = ref.watch(todoStatsProvider);
    final progress = ref.watch(progressProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: stats['total']!,
                color: Colors.blue,
              ),
              _StatItem(
                label: 'Done',
                value: stats['completed']!,
                color: Colors.green,
              ),
              _StatItem(
                label: 'Pending',
                value: stats['pending']!,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% completed',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FILTER SECTION
// ═══════════════════════════════════════════════════════════════

class _FilterSection extends ConsumerWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(filterProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: TodoFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
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
              selectedColor: Colors.teal,
              onSelected: (_) {
                ref.read(filterProvider.notifier).state = filter;
              },
            ),
          );
        }).toList(),
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
// TODO LIST (uses filtered todos provider)
// ═══════════════════════════════════════════════════════════════

class _TodoList extends ConsumerWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using the computed filtered todos provider!
    final todos = ref.watch(filteredTodosProvider);
    final filter = ref.watch(filterProvider);

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
              filter == TodoFilter.all
                  ? 'No todos yet!\nTap + to add one.'
                  : 'No ${filter.name} todos.',
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
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO ITEM
// ═══════════════════════════════════════════════════════════════

class _TodoItem extends ConsumerWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ref.read(todosProvider.notifier).delete(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${todo.title}"')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (_) {
              ref.read(todosProvider.notifier).toggle(todo.id);
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
            onPressed: () => _showEditDialog(context, ref),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
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
                  ref.read(todosProvider.notifier).edit(todo.id, controller.text);
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
 * 1. StateNotifierProvider
 *    - Complex state with methods
 *    - TodosNotifier handles all CRUD operations
 *    - Immutable state updates
 *
 * 2. Computed Providers
 *    - filteredTodosProvider depends on todos + filter
 *    - todoStatsProvider computes counts
 *    - progressProvider derives from stats
 *    - Auto-updates when dependencies change!
 *
 * 3. ConsumerWidget
 *    - Used throughout for accessing providers
 *    - Clean separation of concerns
 *
 * 4. Provider Dependencies
 *    - filteredTodosProvider watches both todosProvider and filterProvider
 *    - Changes in either trigger updates
 *
 * 5. ref.watch vs ref.read Pattern
 *    - watch in build() for displaying
 *    - read in callbacks for actions
 *
 * ═══════════════════════════════════════════════════════════════
 * BENEFITS OF RIVERPOD SHOWN:
 * ═══════════════════════════════════════════════════════════════
 *
 * • Providers defined globally (no BuildContext needed for definition)
 * • Computed values are automatic and efficient
 * • Type-safe - compile-time errors, not runtime
 * • Easy to test (just create a ProviderContainer)
 * • Clear dependency graph
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add search functionality with a searchProvider
 * 2. Add sorting (by date, by name, by completion)
 * 3. Add categories/tags
 * 4. Persist to local storage using a repository pattern
 * 5. Add due dates with overdue highlighting
 *
 */
