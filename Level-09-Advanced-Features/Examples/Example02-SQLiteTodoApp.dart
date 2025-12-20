// Example 02: SQLite Todo App
// A complete todo app that saves data to SQLite database

// pubspec.yaml dependencies:
// sqflite: ^2.3.0
// path: ^1.8.3

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ═══════════════════════════════════════════════════════════════
// TODO MODEL
// ═══════════════════════════════════════════════════════════════

class Todo {
  final int? id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime createdAt;

  const Todo({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
    required this.createdAt,
  });

  // Convert Todo to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Todo from database Map
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isDone: (map['isDone'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Create a copy with some fields changed
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DATABASE HELPER (Singleton Pattern)
// ═══════════════════════════════════════════════════════════════

class DatabaseHelper {
  // Private constructor
  DatabaseHelper._init();

  // Single instance
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Database reference
  static Database? _database;

  // Get the database (create if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
    print('Database created!');
  }

  // ─────────────────────────────────────────────────────────────
  // CRUD OPERATIONS
  // ─────────────────────────────────────────────────────────────

  // CREATE: Add a new todo
  Future<int> createTodo(Todo todo) async {
    final db = await database;
    final id = await db.insert('todos', todo.toMap());
    print('Todo created with id: $id');
    return id;
  }

  // READ: Get all todos
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final result = await db.query(
      'todos',
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // READ: Get pending todos only
  Future<List<Todo>> getPendingTodos() async {
    final db = await database;
    final result = await db.query(
      'todos',
      where: 'isDone = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // READ: Get completed todos only
  Future<List<Todo>> getCompletedTodos() async {
    final db = await database;
    final result = await db.query(
      'todos',
      where: 'isDone = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // READ: Get a single todo by id
  Future<Todo?> getTodo(int id) async {
    final db = await database;
    final result = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Todo.fromMap(result.first);
    }
    return null;
  }

  // UPDATE: Update a todo
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // UPDATE: Toggle todo completion
  Future<int> toggleTodo(int id) async {
    final db = await database;
    final todo = await getTodo(id);
    if (todo != null) {
      return await db.update(
        'todos',
        {'isDone': todo.isDone ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  // DELETE: Delete a todo
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE: Delete all completed todos
  Future<int> deleteCompletedTodos() async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'isDone = ?',
      whereArgs: [1],
    );
  }

  // SEARCH: Find todos by title
  Future<List<Todo>> searchTodos(String query) async {
    final db = await database;
    final result = await db.query(
      'todos',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO LIST PAGE
// ═══════════════════════════════════════════════════════════════

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todos = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'pending', 'completed'

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // Load todos based on current filter
  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);

    List<Todo> todos;
    switch (_filter) {
      case 'pending':
        todos = await DatabaseHelper.instance.getPendingTodos();
        break;
      case 'completed':
        todos = await DatabaseHelper.instance.getCompletedTodos();
        break;
      default:
        todos = await DatabaseHelper.instance.getAllTodos();
    }

    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  // Add new todo
  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (result != null) {
      final todo = Todo(
        title: result['title']!,
        description: result['description'],
        createdAt: DateTime.now(),
      );
      await DatabaseHelper.instance.createTodo(todo);
      _loadTodos();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todo added!')),
        );
      }
    }
  }

  // Toggle todo completion
  Future<void> _toggleTodo(Todo todo) async {
    await DatabaseHelper.instance.toggleTodo(todo.id!);
    _loadTodos();
  }

  // Delete todo
  Future<void> _deleteTodo(Todo todo) async {
    await DatabaseHelper.instance.deleteTodo(todo.id!);
    _loadTodos();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted: ${todo.title}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              // Re-add the deleted todo
              await DatabaseHelper.instance.createTodo(todo);
              _loadTodos();
            },
          ),
        ),
      );
    }
  }

  // Delete all completed todos
  Future<void> _deleteCompleted() async {
    final count = await DatabaseHelper.instance.deleteCompletedTodos();
    _loadTodos();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted $count completed todos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'deleteCompleted') {
                _deleteCompleted();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'deleteCompleted',
                child: Text('Delete completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filter == 'all',
                  onSelected: (selected) {
                    setState(() => _filter = 'all');
                    _loadTodos();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pending'),
                  selected: _filter == 'pending',
                  onSelected: (selected) {
                    setState(() => _filter = 'pending');
                    _loadTodos();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Completed'),
                  selected: _filter == 'completed',
                  onSelected: (selected) {
                    setState(() => _filter = 'completed');
                    _loadTodos();
                  },
                ),
              ],
            ),
          ),

          // Todo list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No todos yet!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Tap + to add one'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _todos.length,
                        itemBuilder: (context, index) {
                          final todo = _todos[index];
                          return TodoTile(
                            todo: todo,
                            onToggle: () => _toggleTodo(todo),
                            onDelete: () => _deleteTodo(todo),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO TILE WIDGET
// ═══════════════════════════════════════════════════════════════

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : null,
          ),
        ),
        subtitle: todo.description != null && todo.description!.isNotEmpty
            ? Text(
                todo.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text(
          _formatDate(todo.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return '${date.month}/${date.day}';
  }
}

// ═══════════════════════════════════════════════════════════════
// ADD TODO DIALOG
// ═══════════════════════════════════════════════════════════════

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descriptionController.text,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. SQLite Database Setup
 *    - Singleton pattern for database helper
 *    - Database initialization and table creation
 *    - Path management for database file
 *
 * 2. CRUD Operations
 *    - CREATE: createTodo()
 *    - READ: getAllTodos(), getTodo(), getPendingTodos()
 *    - UPDATE: updateTodo(), toggleTodo()
 *    - DELETE: deleteTodo(), deleteCompletedTodos()
 *
 * 3. Model Class
 *    - toMap() for database insertion
 *    - fromMap() factory for database reads
 *    - copyWith() for immutable updates
 *
 * 4. Filtering
 *    - Using WHERE clause to filter data
 *    - ORDER BY for sorting
 *
 * 5. Search
 *    - Using LIKE for text search
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add priority levels (high, medium, low)
 * 2. Add due dates with reminders
 * 3. Add categories/tags
 * 4. Add search functionality to the UI
 * 5. Add sorting options (by date, by title, by priority)
 *
 */
