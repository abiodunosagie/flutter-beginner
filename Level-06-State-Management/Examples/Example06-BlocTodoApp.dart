// Example 06: BLoC Todo App
// A complete todo app demonstrating BLoC pattern

// pubspec.yaml dependencies:
// flutter_bloc: ^8.1.3
// bloc: ^8.1.2
// equatable: ^2.0.5

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

class Todo extends Equatable {
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

  @override
  List<Object?> get props => [id, title, completed, createdAt];
}

enum TodoFilter { all, completed, pending }

// ═══════════════════════════════════════════════════════════════
// EVENTS - What can happen in the todo app
// ═══════════════════════════════════════════════════════════════

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Add a new todo
class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);

  @override
  List<Object?> get props => [title];
}

/// Toggle completion status
class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

/// Delete a todo
class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

/// Edit todo title
class EditTodo extends TodoEvent {
  final String id;
  final String newTitle;
  EditTodo(this.id, this.newTitle);

  @override
  List<Object?> get props => [id, newTitle];
}

/// Change filter
class ChangeFilter extends TodoEvent {
  final TodoFilter filter;
  ChangeFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Clear completed todos
class ClearCompleted extends TodoEvent {}

/// Mark all as completed
class MarkAllComplete extends TodoEvent {}

// ═══════════════════════════════════════════════════════════════
// STATE - The current state of todos
// ═══════════════════════════════════════════════════════════════

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
  });

  /// Get filtered todos based on current filter
  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.completed:
        return todos.where((t) => t.completed).toList();
      case TodoFilter.pending:
        return todos.where((t) => !t.completed).toList();
      case TodoFilter.all:
      default:
        return todos;
    }
  }

  /// Computed stats
  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.completed).length;
  int get pendingCount => todos.where((t) => !t.completed).length;
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [todos, filter];
}

// ═══════════════════════════════════════════════════════════════
// BLOC - The business logic
// ═══════════════════════════════════════════════════════════════

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    // Register all event handlers
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<EditTodo>(_onEditTodo);
    on<ChangeFilter>(_onChangeFilter);
    on<ClearCompleted>(_onClearCompleted);
    on<MarkAllComplete>(_onMarkAllComplete);
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    if (event.title.trim().isEmpty) return;

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title.trim(),
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(todos: [...state.todos, todo]));
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.where((t) => t.id != event.id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  void _onEditTodo(EditTodo event, Emitter<TodoState> emit) {
    if (event.newTitle.trim().isEmpty) return;

    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(title: event.newTitle.trim());
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onChangeFilter(ChangeFilter event, Emitter<TodoState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onClearCompleted(ClearCompleted event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.where((t) => !t.completed).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  void _onMarkAllComplete(MarkAllComplete event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      return todo.copyWith(completed: true);
    }).toList();
    emit(state.copyWith(todos: updatedTodos));
  }
}

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    BlocProvider(
      create: (_) => TodoBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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
        title: const Text('BLoC Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  context.read<TodoBloc>().add(ClearCompleted());
                  break;
                case 'complete_all':
                  context.read<TodoBloc>().add(MarkAllComplete());
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
                context.read<TodoBloc>().add(AddTodo(value));
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
                  context.read<TodoBloc>().add(AddTodo(controller.text));
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
// STATS SECTION
// ═══════════════════════════════════════════════════════════════

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder with buildWhen for optimization
    return BlocBuilder<TodoBloc, TodoState>(
      // Only rebuild when these values change
      buildWhen: (previous, current) =>
          previous.totalCount != current.totalCount ||
          previous.completedCount != current.completedCount,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepOrange.shade50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Total',
                    value: state.totalCount,
                    color: Colors.blue,
                  ),
                  _StatItem(
                    label: 'Done',
                    value: state.completedCount,
                    color: Colors.green,
                  ),
                  _StatItem(
                    label: 'Pending',
                    value: state.pendingCount,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: state.progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    state.progress == 1.0 ? Colors.green : Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(state.progress * 100).toInt()}% completed',
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

class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      // Only rebuild when filter changes
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: TodoFilter.values.map((filter) {
              final isSelected = state.filter == filter;
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
                  selectedColor: Colors.deepOrange,
                  onSelected: (_) {
                    context.read<TodoBloc>().add(ChangeFilter(filter));
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
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
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final todos = state.filteredTodos;

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
                  state.filter == TodoFilter.all
                      ? 'No todos yet!\nTap + to add one.'
                      : 'No ${state.filter.name} todos.',
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
        context.read<TodoBloc>().add(DeleteTodo(todo.id));
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
              context.read<TodoBloc>().add(ToggleTodo(todo.id));
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
                  context.read<TodoBloc>().add(EditTodo(todo.id, controller.text));
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
 * 1. Equatable
 *    - Events and States extend Equatable
 *    - Provides value equality
 *    - Prevents unnecessary rebuilds
 *
 * 2. Complex State
 *    - TodoState contains list and filter
 *    - Computed properties (filteredTodos, progress)
 *    - copyWith for immutable updates
 *
 * 3. Multiple Events
 *    - Each action is an event
 *    - Events can carry data
 *    - Clear intent for each action
 *
 * 4. buildWhen
 *    - Optimize rebuilds
 *    - Only rebuild when specific parts change
 *    - Better performance
 *
 * 5. Event-Driven Architecture
 *    - Clear separation: UI -> Event -> BLoC -> State -> UI
 *    - Predictable flow
 *    - Easy to test and debug
 *
 * ═══════════════════════════════════════════════════════════════
 * BLOC VS PROVIDER/RIVERPOD:
 * ═══════════════════════════════════════════════════════════════
 *
 * BLoC strengths shown:
 * • Every action is explicit (events)
 * • Easy to trace what happened
 * • Clear structure for complex logic
 * • buildWhen for optimization
 *
 * BLoC trade-offs:
 * • More boilerplate (events, state classes)
 * • More files typically needed
 * • Steeper learning curve
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add priority levels (high, medium, low)
 * 2. Add search functionality
 * 3. Add undo for delete
 * 4. Persist to local storage
 * 5. Add categories/tags
 * 6. Add due dates with reminders
 *
 */
