# SQLite: Powerful Relational Database Storage

## What You'll Learn

In this comprehensive lesson, you'll master:
- What SQLite is and when to use it
- Understanding relational databases (tables, rows, columns)
- Creating database schemas
- CRUD operations (Create, Read, Update, Delete)
- SQL queries and filtering
- Sorting and limiting results
- Database migrations and versioning
- Building a complete Todo app with SQLite
- Building a Notes app with categories
- Best practices for database design

By the end, you'll build powerful apps with complex data storage!

## Understanding SQLite (Like Teaching a 5-Year-Old)

### What is a Database?

Imagine you have a filing cabinet with drawers:

**SharedPreferences** = One small drawer with sticky notes
- "Name: John"
- "Age: 25"
- Simple, quick to access
- But limited space!

**SQLite** = Entire filing cabinet with organized folders
- Drawer 1: "Users" folder with cards for each user
- Drawer 2: "Products" folder with cards for each product
- Drawer 3: "Orders" folder with cards for each order
- Each card has many fields: name, date, price, etc.
- Can search, filter, sort millions of cards!

### Relational Database Concept

Think of it like a spreadsheet:

```
USERS TABLE
+----+---------+------------------+-----+
| id | name    | email            | age |
+----+---------+------------------+-----+
| 1  | John    | john@example.com | 25  |
| 2  | Alice   | alice@ex.com     | 30  |
| 3  | Bob     | bob@example.com  | 22  |
+----+---------+------------------+-----+

POSTS TABLE
+----+----------+---------+------------------+
| id | title    | user_id | content          |
+----+----------+---------+------------------+
| 1  | My Post  | 1       | Hello world!     |
| 2  | News     | 1       | Breaking news... |
| 3  | Update   | 2       | Alice's update   |
+----+----------+---------+------------------+
```

**Relationships:**
- Post #1 belongs to User #1 (John)
- Post #2 belongs to User #1 (John)
- Post #3 belongs to User #2 (Alice)

## Step 1: Setup

### Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
```

Run:

```bash
flutter pub get
```

### Import

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
```

## Step 2: Create Your First Database

### Database Helper Class

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // SQL to create todos table
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
```

**What's happening:**
- `INTEGER PRIMARY KEY AUTOINCREMENT` = Auto-generates unique ID (1, 2, 3...)
- `TEXT NOT NULL` = Must have text, can't be empty
- `INTEGER NOT NULL DEFAULT 0` = Defaults to 0 if not provided
- SQLite stores booleans as 0 (false) or 1 (true)

## Step 3: Create Model Class

```dart
class Todo {
  final int? id;  // Nullable because DB auto-generates it
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  // Convert Todo to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,  // Convert bool to int
      'createdAt': createdAt.toIso8601String(),  // Convert DateTime to String
    };
  }

  // Create Todo from Map (database row)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] == 1,  // Convert int to bool
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Create copy with changes
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

## Step 4: CRUD Operations

### Create (Insert)

```dart
class TodoDatabase {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insert a new todo
  Future<int> insertTodo(Todo todo) async {
    final db = await _dbHelper.database;

    // Insert and return the generated ID
    final id = await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  // Insert multiple todos
  Future<void> insertTodos(List<Todo> todos) async {
    final db = await _dbHelper.database;

    final batch = db.batch();

    for (final todo in todos) {
      batch.insert('todos', todo.toMap());
    }

    await batch.commit();
  }
}

// Usage
final todoDb = TodoDatabase();

final newTodo = Todo(
  title: 'Buy groceries',
  description: 'Milk, eggs, bread',
  isCompleted: false,
  createdAt: DateTime.now(),
);

final id = await todoDb.insertTodo(newTodo);
print('Inserted todo with ID: $id');
```

### Read (Query)

```dart
class TodoDatabase {
  // Get all todos
  Future<List<Todo>> getAllTodos() async {
    final db = await _dbHelper.database;

    // Query all rows
    final List<Map<String, dynamic>> maps = await db.query('todos');

    // Convert each map to Todo
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Get todo by ID
  Future<Todo?> getTodoById(int id) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  // Get completed todos only
  Future<List<Todo>> getCompletedTodos() async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Get todos with search
  Future<List<Todo>> searchTodos(String query) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'todos',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Get todos ordered by date
  Future<List<Todo>> getTodosSortedByDate() async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'todos',
      orderBy: 'createdAt DESC',  // Newest first
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Get limited number of todos
  Future<List<Todo>> getRecentTodos({int limit = 10}) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'todos',
      orderBy: 'createdAt DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }
}

// Usage
final todos = await todoDb.getAllTodos();
print('Found ${todos.length} todos');

final searchResults = await todoDb.searchTodos('grocery');
print('Found ${searchResults.length} matching todos');
```

### Update

```dart
class TodoDatabase {
  // Update a todo
  Future<int> updateTodo(Todo todo) async {
    final db = await _dbHelper.database;

    // Returns number of rows updated
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Toggle completed status
  Future<int> toggleTodoComplete(int id) async {
    final db = await _dbHelper.database;

    // Get current todo
    final todo = await getTodoById(id);
    if (todo == null) return 0;

    // Toggle completion
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);

    return await updateTodo(updated);
  }

  // Mark all as completed
  Future<int> markAllCompleted() async {
    final db = await _dbHelper.database;

    return await db.update(
      'todos',
      {'isCompleted': 1},
    );
  }
}

// Usage
final todo = await todoDb.getTodoById(1);
final updated = todo!.copyWith(title: 'Updated title');
await todoDb.updateTodo(updated);

// Or toggle completion
await todoDb.toggleTodoComplete(1);
```

### Delete

```dart
class TodoDatabase {
  // Delete todo by ID
  Future<int> deleteTodo(int id) async {
    final db = await _dbHelper.database;

    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all completed todos
  Future<int> deleteCompletedTodos() async {
    final db = await _dbHelper.database;

    return await db.delete(
      'todos',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }

  // Delete all todos
  Future<int> deleteAllTodos() async {
    final db = await _dbHelper.database;

    return await db.delete('todos');
  }

  // Delete old todos (older than 30 days)
  Future<int> deleteOldTodos() async {
    final db = await _dbHelper.database;

    final thirtyDaysAgo = DateTime.now()
        .subtract(Duration(days: 30))
        .toIso8601String();

    return await db.delete(
      'todos',
      where: 'createdAt < ?',
      whereArgs: [thirtyDaysAgo],
    );
  }
}

// Usage
await todoDb.deleteTodo(1);
print('Todo deleted');

final deleted = await todoDb.deleteCompletedTodos();
print('Deleted $deleted completed todos');
```

## Step 5: Complex Queries

### Counting

```dart
Future<int> getTodoCount() async {
  final db = await _dbHelper.database;

  final result = await db.rawQuery('SELECT COUNT(*) as count FROM todos');

  return Sqflite.firstIntValue(result) ?? 0;
}

Future<int> getCompletedCount() async {
  final db = await _dbHelper.database;

  final result = await db.rawQuery(
    'SELECT COUNT(*) as count FROM todos WHERE isCompleted = 1',
  );

  return Sqflite.firstIntValue(result) ?? 0;
}
```

### Custom SQL Queries

```dart
Future<List<Todo>> getCustomTodos() async {
  final db = await _dbHelper.database;

  // Raw SQL query
  final maps = await db.rawQuery('''
    SELECT * FROM todos
    WHERE isCompleted = 0
    AND createdAt > ?
    ORDER BY createdAt DESC
    LIMIT 20
  ''', [DateTime.now().subtract(Duration(days: 7)).toIso8601String()]);

  return List.generate(maps.length, (i) {
    return Todo.fromMap(maps[i]);
  });
}
```

## Step 6: Database Migrations

When you need to change your database structure:

```dart
class DatabaseHelper {
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,  // ← Increment version!
      onCreate: _createDB,
      onUpgrade: _upgradeDB,  // ← Handle upgrades
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Version 2 schema
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        category TEXT DEFAULT 'general',
        priority INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns for version 2
      await db.execute('ALTER TABLE todos ADD COLUMN category TEXT DEFAULT "general"');
      await db.execute('ALTER TABLE todos ADD COLUMN priority INTEGER DEFAULT 0');
    }

    // Future migrations
    if (oldVersion < 3) {
      // Add features for version 3
    }
  }
}
```

## Step 7: Complete Todo App Example

```dart
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoDatabase _todoDb = TodoDatabase();
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);

    _todos = await _todoDb.getAllTodos();

    setState(() => _isLoading = false);
  }

  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AddTodoDialog(),
    );

    if (result != null) {
      final todo = Todo(
        title: result['title']!,
        description: result['description'],
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _todoDb.insertTodo(todo);
      await _loadTodos();
    }
  }

  Future<void> _toggleComplete(Todo todo) async {
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await _todoDb.updateTodo(updated);
    await _loadTodos();
  }

  Future<void> _deleteTodo(Todo todo) async {
    await _todoDb.deleteTodo(todo.id!);
    await _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await _todoDb.deleteCompletedTodos();
              await _loadTodos();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? const Center(child: Text('No todos yet!'))
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];

                    return Dismissible(
                      key: Key(todo.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteTodo(todo),
                      child: CheckboxListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: todo.description != null
                            ? Text(todo.description!)
                            : null,
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleComplete(todo),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Step 8: Best Practices

### 1. Use Transactions for Multiple Operations

```dart
Future<void> updateMultipleTodos(List<Todo> todos) async {
  final db = await _dbHelper.database;

  await db.transaction((txn) async {
    for (final todo in todos) {
      await txn.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    }
  });
}
```

### 2. Use Batch Operations for Better Performance

```dart
Future<void> insertManyTodos(List<Todo> todos) async {
  final db = await _dbHelper.database;

  final batch = db.batch();

  for (final todo in todos) {
    batch.insert('todos', todo.toMap());
  }

  await batch.commit(noResult: true);
}
```

### 3. Close Database When Done

```dart
@override
void dispose() {
  DatabaseHelper.instance.close();
  super.dispose();
}
```

## Progressive Exercises

### Exercise 1: Simple Notes App (Beginner)
**Goal:** Basic CRUD with SQLite

Create a notes app with:
- Create table: id, title, content, createdAt
- Add note
- View all notes
- Edit note
- Delete note

### Exercise 2: Categories (Beginner-Intermediate)
**Goal:** Add categorization

Enhance Exercise 1 with:
- Add category column
- Filter notes by category
- Count notes per category
- Delete category (and all its notes)

### Exercise 3: Search and Sort (Intermediate)
**Goal:** Complex queries

Add to Exercise 2:
- Search notes by title/content
- Sort by date (newest/oldest)
- Sort by title (A-Z)
- Combined filters (category AND search)

### Exercise 4: Two-Table Relationship (Advanced)
**Goal:** Master relationships

Create a blog app with two tables:
- Users table (id, name, email)
- Posts table (id, title, content, userId)
- Show posts with author names
- Get all posts by specific user
- Delete user and all their posts (CASCADE)

### Exercise 5: Full-Featured App (Advanced)
**Goal:** Production-ready database

Build expense tracker:
- Categories table
- Expenses table (with categoryId)
- Migrations (add new columns)
- Export data to JSON
- Import data from JSON
- Statistics (total by category, monthly totals)

**Hint for relationships:**
```sql
CREATE TABLE expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount REAL NOT NULL,
  category_id INTEGER NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories (id)
)
```

## What You've Learned

✅ Understanding relational databases
✅ Creating database schemas
✅ CRUD operations (Create, Read, Update, Delete)
✅ Complex SQL queries
✅ Database migrations
✅ Building complete apps with SQLite
✅ Best practices for performance
✅ Batch operations and transactions

## Next Steps

In the next lesson, we'll cover:
- **Hive** - Fast, NoSQL database
- No SQL needed!
- Type-safe storage
- Faster than SQLite for simple data
- Perfect for Flutter

You've mastered SQL databases! 🎉
