# Drift: Type-Safe SQL Database

## What You'll Learn

In this comprehensive lesson, you'll master:
- What Drift is and why it's powerful
- When to use Drift vs SQLite vs Hive
- Setting up Drift in your Flutter app
- Defining tables with Dart classes
- Type-safe queries (no raw SQL strings!)
- Reactive queries that auto-update UI
- Relationships between tables
- Migrations and schema versions
- Transactions and batch operations
- Real-world examples and best practices
- 5 progressive exercises

By the end, you'll have the power of SQL with the safety of Dart types!

## Understanding Drift (Like Teaching a 5-Year-Old)

### What is Drift?

Remember our storage options?

**SharedPreferences = Small Drawer:**
```
📦 Store a few simple things
- Settings: dark mode, language
- Simple key-value pairs
```

**Hive = Magic Toy Chest:**
```
✨ Store lots of objects quickly
- Todos, notes, favorites
- No SQL needed
- Super fast
```

**SQLite = Filing Cabinet:**
```
🗄️ Store organized data with relationships
- Complex queries possible
- But: You write SQL strings (error-prone!)
- Example: "SELECT * FROM users WHERE age > 18"
```

**Drift = Smart Filing Cabinet with Assistant:**
```
🤖 Same power as SQLite, but...
- NO SQL strings! Write Dart code instead
- Compiler checks for errors
- Auto-completion in IDE
- Type-safe (can't make silly mistakes)
- Reactive queries (UI updates automatically!)
```

### The Problem Drift Solves

```dart
// ❌ SQLite: Error-prone SQL strings
final results = await db.rawQuery(
  'SELECT * FROM users WHERE age > ? AND name LIKE ?',
  [18, '%John%'],
);

// Problems:
// - What if you typo 'users' as 'user'? Runtime error! 💥
// - What if column 'age' doesn't exist? Runtime error! 💥
// - No auto-completion
// - No type safety


// ✅ Drift: Type-safe Dart code
final results = await (select(users)
  ..where((u) => u.age.isBiggerThan(18))
  ..where((u) => u.name.like('%John%'))
).get();

// Benefits:
// - Compiler catches errors before running! ✅
// - Auto-completion works! ✅
// - Type-safe! ✅
// - Can't access non-existent columns! ✅
```

### When to Use Each Storage Option

| Feature | SharedPreferences | Hive | SQLite | Drift |
|---------|------------------|------|--------|-------|
| **Setup** | ⭐⭐⭐ Easy | ⭐⭐⭐ Easy | ⭐⭐ Medium | ⭐⭐ Medium |
| **Speed** | ⚡⚡⚡ | ⚡⚡⚡ | ⚡⚡ | ⚡⚡ |
| **Type Safety** | ❌ | ⭐⭐ | ❌ | ⭐⭐⭐ |
| **Relationships** | ❌ | ❌ | ✅ | ✅ |
| **Complex Queries** | ❌ | ⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **Auto-Update UI** | ❌ | ✅ | ❌ | ✅ |
| **Best For** | Settings | Simple objects | Complex data | Complex + Safety |

**Use Drift When:**
- ✅ You need SQL power (relationships, complex queries)
- ✅ You want type safety
- ✅ You want reactive queries (auto-updating UI)
- ✅ Your team prefers Dart over SQL
- ✅ You're building a serious app with complex data

**Use SQLite When:**
- ✅ Your team is expert in SQL
- ✅ You're migrating existing SQL database
- ✅ You need maximum control

**Use Hive When:**
- ✅ Simple data structures
- ✅ Don't need relationships
- ✅ Want maximum speed

## Part 1: Setting Up Drift

### Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Drift for database
  drift: ^2.14.0

  # SQLite for Flutter
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.1
  path: ^1.8.3

dev_dependencies:
  # Code generation
  drift_dev: ^2.14.0
  build_runner: ^2.4.6
```

Run:
```bash
flutter pub get
```

### Step 2: Create Database File

Create `lib/database/database.dart`:

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// This will be generated
part 'database.g.dart';

// Define a table
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

// Database class
@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));

    return NativeDatabase(file);
  });
}
```

### Step 3: Generate Code

Run this command to generate the database code:

```bash
flutter packages pub run build_runner build
```

This creates `database.g.dart` with all the generated code!

**For development** (watches for changes):
```bash
flutter packages pub run build_runner watch
```

### Step 4: Use the Database

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(database: database),
    );
  }
}
```

## Part 2: Defining Tables

### Basic Table Definition

```dart
class Users extends Table {
  // Primary key (auto-increment)
  IntColumn get id => integer().autoIncrement()();

  // Required text
  TextColumn get name => text()();

  // Optional text (nullable)
  TextColumn get email => text().nullable()();

  // Integer with default
  IntColumn get age => integer().withDefault(const Constant(0))();

  // Boolean
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // DateTime
  DateTimeColumn get createdAt => dateTime()();

  // Real number (double)
  RealColumn get balance => real()();
}
```

### Column Constraints

```dart
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Length constraints
  TextColumn get name => text().withLength(min: 1, max: 100)();

  // Unique constraint
  TextColumn get sku => text().unique()();

  // Not null (default is not null)
  TextColumn get description => text()();

  // Nullable
  TextColumn get notes => text().nullable()();

  // Default value
  RealColumn get price => real().withDefault(const Constant(0.0))();

  // Check constraint
  IntColumn get stock => integer()
      .check(stock.isBiggerOrEqualValue(0))();

  // Custom column name in database
  TextColumn get categoryName =>
      text().named('category')();
}
```

### Custom Table Names

```dart
// Table name in database will be 'user_profiles'
@TableIndex(name: 'user_profiles', columns: {#email})
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();

  @override
  String? get tableName => 'user_profiles';
}
```

### Enums in Tables

```dart
// Define enum
enum TaskPriority { low, medium, high }

// Use in table
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  // Store as integer (0, 1, 2)
  IntColumn get priority => intEnum<TaskPriority>()();

  // Or store as text ('low', 'medium', 'high')
  TextColumn get priorityText => textEnum<TaskPriority>()();
}
```

## Part 3: CRUD Operations (Type-Safe!)

### CREATE: Inserting Data

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Insert one todo
  Future<int> addTodo(String title, String? description) async {
    return await database.into(database.todos).insert(
      TodosCompanion.insert(
        title: title,
        description: Value(description),  // Wrap nullable in Value()
        createdAt: DateTime.now(),
      ),
    );
  }

  // Insert with all fields
  Future<int> addTodoComplete({
    required String title,
    String? description,
    bool isCompleted = false,
  }) async {
    return await database.into(database.todos).insert(
      TodosCompanion.insert(
        title: title,
        description: Value(description),
        isCompleted: Value(isCompleted),
        createdAt: DateTime.now(),
      ),
    );
  }

  // Insert multiple todos
  Future<void> addMultipleTodos(List<String> titles) async {
    await database.batch((batch) {
      batch.insertAll(
        database.todos,
        titles.map(
          (title) => TodosCompanion.insert(
            title: title,
            createdAt: DateTime.now(),
          ),
        ),
      );
    });
  }
}
```

**Understanding Companions:**
- `TodosCompanion` is generated for inserting/updating
- Required fields use direct values: `title: 'My Todo'`
- Optional fields wrap in `Value()`: `description: Value('Details')`
- Auto-increment fields don't need to be specified

### READ: Querying Data

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Get all todos
  Future<List<Todo>> getAllTodos() async {
    return await database.select(database.todos).get();
  }

  // Get by ID
  Future<Todo?> getTodoById(int id) async {
    return await (database.select(database.todos)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  // Get incomplete todos
  Future<List<Todo>> getIncompleteTodos() async {
    return await (database.select(database.todos)
      ..where((t) => t.isCompleted.equals(false)))
      .get();
  }

  // Search by title
  Future<List<Todo>> searchTodos(String query) async {
    return await (database.select(database.todos)
      ..where((t) => t.title.like('%$query%')))
      .get();
  }

  // Get recent todos (created in last 7 days)
  Future<List<Todo>> getRecentTodos() async {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));

    return await (database.select(database.todos)
      ..where((t) => t.createdAt.isBiggerOrEqualValue(weekAgo))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .get();
  }

  // Get todos with limit
  Future<List<Todo>> getTodosPage({int limit = 10, int offset = 0}) async {
    return await (database.select(database.todos)
      ..limit(limit, offset: offset))
      .get();
  }

  // Count todos
  Future<int> countTodos() async {
    final countExp = database.todos.id.count();

    final query = database.selectOnly(database.todos)
      ..addColumns([countExp]);

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  // Count incomplete todos
  Future<int> countIncompleteTodos() async {
    final countExp = database.todos.id.count();

    final query = database.selectOnly(database.todos)
      ..addColumns([countExp])
      ..where(database.todos.isCompleted.equals(false));

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
```

**Query Operators:**
```dart
// Comparison
..where((t) => t.age.equals(18))
..where((t) => t.age.isBiggerThan(18))
..where((t) => t.age.isSmallerThan(65))
..where((t) => t.age.isBiggerOrEqualValue(18))

// Text
..where((t) => t.name.like('%John%'))          // Contains
..where((t) => t.name.like('John%'))           // Starts with
..where((t) => t.email.isNotNull())

// Boolean
..where((t) => t.isActive.equals(true))
..where((t) => t.isActive)  // Shorthand

// Multiple conditions (AND)
..where((t) =>
    t.age.isBiggerThan(18) & t.isActive.equals(true))

// Multiple conditions (OR)
..where((t) =>
    t.name.like('%John%') | t.name.like('%Jane%'))

// Ordering
..orderBy([(t) => OrderingTerm.asc(t.name)])   // A-Z
..orderBy([(t) => OrderingTerm.desc(t.createdAt)])  // Newest first

// Limit and offset
..limit(10)           // First 10
..limit(10, offset: 20)  // Skip 20, get next 10
```

### UPDATE: Modifying Data

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Update single todo
  Future<bool> updateTodo(int id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    return await (database.update(database.todos)
      ..where((t) => t.id.equals(id)))
      .write(
        TodosCompanion(
          title: Value(title ?? ''),
          description: Value(description),
          isCompleted: Value(isCompleted ?? false),
        ),
      );
  }

  // Toggle completion
  Future<void> toggleTodo(int id) async {
    final todo = await getTodoById(id);
    if (todo != null) {
      await (database.update(database.todos)
        ..where((t) => t.id.equals(id)))
        .write(
          TodosCompanion(
            isCompleted: Value(!todo.isCompleted),
          ),
        );
    }
  }

  // Mark all as completed
  Future<int> markAllCompleted() async {
    return await database.update(database.todos).write(
      const TodosCompanion(
        isCompleted: Value(true),
      ),
    );
  }

  // Update specific todos
  Future<int> completeOldTodos() async {
    final monthAgo = DateTime.now().subtract(Duration(days: 30));

    return await (database.update(database.todos)
      ..where((t) => t.createdAt.isSmallerThanValue(monthAgo)))
      .write(
        const TodosCompanion(
          isCompleted: Value(true),
        ),
      );
  }
}
```

### DELETE: Removing Data

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Delete by ID
  Future<int> deleteTodo(int id) async {
    return await (database.delete(database.todos)
      ..where((t) => t.id.equals(id)))
      .go();
  }

  // Delete completed todos
  Future<int> deleteCompleted() async {
    return await (database.delete(database.todos)
      ..where((t) => t.isCompleted.equals(true)))
      .go();
  }

  // Delete old todos
  Future<int> deleteOldTodos(int days) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));

    return await (database.delete(database.todos)
      ..where((t) => t.createdAt.isSmallerThanValue(cutoffDate)))
      .go();
  }

  // Delete all todos
  Future<int> deleteAllTodos() async {
    return await database.delete(database.todos).go();
  }
}
```

## Part 4: Reactive Queries (Auto-Updating UI!)

The **BEST** feature of Drift - queries that automatically update your UI!

### Using watch() Instead of get()

```dart
// ❌ Regular query (one-time)
Future<List<Todo>> getAllTodos() async {
  return await database.select(database.todos).get();
}

// ✅ Reactive query (updates automatically!)
Stream<List<Todo>> watchAllTodos() {
  return database.select(database.todos).watch();
}
```

### Complete Example: Auto-Updating Todo List

```dart
class TodoScreen extends StatelessWidget {
  final AppDatabase database;

  TodoScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todos')),
      body: StreamBuilder<List<Todo>>(
        // Watch for changes!
        stream: database.select(database.todos).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!;

          if (todos.isEmpty) {
            return Center(
              child: Text('No todos yet! Tap + to add one.'),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                leading: Checkbox(
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
                subtitle: todo.description != null
                    ? Text(todo.description!)
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTodo(todo.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleTodo(int id) async {
    final todo = await (database.select(database.todos)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

    if (todo != null) {
      await (database.update(database.todos)
        ..where((t) => t.id.equals(id)))
        .write(
          TodosCompanion(
            isCompleted: Value(!todo.isCompleted),
          ),
        );
    }
    // UI updates automatically! No setState needed! ✨
  }

  Future<void> _deleteTodo(int id) async {
    await (database.delete(database.todos)
      ..where((t) => t.id.equals(id)))
      .go();
    // UI updates automatically! ✨
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await database.into(database.todos).insert(
                  TodosCompanion.insert(
                    title: titleController.text,
                    description: Value(descController.text.isEmpty
                        ? null
                        : descController.text),
                    createdAt: DateTime.now(),
                  ),
                );

                Navigator.pop(context);
                // UI updates automatically! ✨
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

**Magic!** No `setState()`, no manual refreshes. The StreamBuilder automatically rebuilds when data changes!

### Multiple Reactive Queries

```dart
class TodoStatsScreen extends StatelessWidget {
  final AppDatabase database;

  TodoStatsScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo Statistics')),
      body: Column(
        children: [
          // Watch total count
          StreamBuilder<int>(
            stream: _watchTotalCount(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text('Total Todos'),
                trailing: Text('${snapshot.data ?? 0}'),
              );
            },
          ),

          // Watch completed count
          StreamBuilder<int>(
            stream: _watchCompletedCount(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text('Completed'),
                trailing: Text('${snapshot.data ?? 0}'),
              );
            },
          ),

          // Watch incomplete count
          StreamBuilder<int>(
            stream: _watchIncompleteCount(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text('Remaining'),
                trailing: Text('${snapshot.data ?? 0}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<int> _watchTotalCount() {
    final countExp = database.todos.id.count();

    return (database.selectOnly(database.todos)
      ..addColumns([countExp]))
      .map((row) => row.read(countExp) ?? 0)
      .watchSingle();
  }

  Stream<int> _watchCompletedCount() {
    final countExp = database.todos.id.count();

    return (database.selectOnly(database.todos)
      ..addColumns([countExp])
      ..where(database.todos.isCompleted.equals(true)))
      .map((row) => row.read(countExp) ?? 0)
      .watchSingle();
  }

  Stream<int> _watchIncompleteCount() {
    final countExp = database.todos.id.count();

    return (database.selectOnly(database.todos)
      ..addColumns([countExp])
      ..where(database.todos.isCompleted.equals(false)))
      .map((row) => row.read(countExp) ?? 0)
      .watchSingle();
  }
}
```

## Part 5: Relationships Between Tables

### One-to-Many Relationship

Example: Categories and Todos (one category has many todos)

```dart
// Category table
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get color => text()();  // Hex color
}

// Todo table with foreign key
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // Foreign key to categories
  IntColumn get categoryId => integer()
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.setNull)();

  DateTimeColumn get createdAt => dateTime()();
}

// Database with both tables
@DriftDatabase(tables: [Categories, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
```

**Foreign Key Options:**
- `onDelete: KeyAction.setNull` - Set to null when category deleted
- `onDelete: KeyAction.cascade` - Delete todos when category deleted
- `onDelete: KeyAction.restrict` - Prevent deleting category if has todos

### Querying with Joins

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Get todos with category info
  Stream<List<TodoWithCategory>> watchTodosWithCategories() {
    final query = database.select(database.todos).join([
      leftOuterJoin(
        database.categories,
        database.categories.id.equalsExp(database.todos.categoryId),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TodoWithCategory(
          todo: row.readTable(database.todos),
          category: row.readTableOrNull(database.categories),
        );
      }).toList();
    });
  }

  // Get todos for specific category
  Stream<List<Todo>> watchTodosByCategory(int categoryId) {
    return (database.select(database.todos)
      ..where((t) => t.categoryId.equals(categoryId)))
      .watch();
  }

  // Count todos per category
  Future<Map<String, int>> getTodosCountByCategory() async {
    final query = database.selectOnly(database.categories).join([
      leftOuterJoin(
        database.todos,
        database.todos.categoryId.equalsExp(database.categories.id),
      ),
    ]);

    final countExp = database.todos.id.count();

    query
      ..addColumns([database.categories.name, countExp])
      ..groupBy([database.categories.id]);

    final results = await query.get();

    return Map.fromEntries(
      results.map((row) {
        final categoryName = row.read(database.categories.name) ?? 'Unknown';
        final count = row.read(countExp) ?? 0;
        return MapEntry(categoryName, count);
      }),
    );
  }
}

// Helper class
class TodoWithCategory {
  final Todo todo;
  final Category? category;

  TodoWithCategory({required this.todo, this.category});
}
```

### Using in UI

```dart
class TodosWithCategoriesScreen extends StatelessWidget {
  final AppDatabase database;
  final TodoService todoService;

  TodosWithCategoriesScreen({required this.database})
      : todoService = TodoService(database);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todos by Category')),
      body: StreamBuilder<List<TodoWithCategory>>(
        stream: todoService.watchTodosWithCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final todosWithCategories = snapshot.data!;

          return ListView.builder(
            itemCount: todosWithCategories.length,
            itemBuilder: (context, index) {
              final item = todosWithCategories[index];
              final todo = item.todo;
              final category = item.category;

              return ListTile(
                title: Text(todo.title),
                subtitle: Text(category?.name ?? 'No Category'),
                leading: category != null
                    ? CircleAvatar(
                        backgroundColor: Color(
                          int.parse(category.color.replaceAll('#', '0xFF')),
                        ),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
```

## Part 6: Migrations and Schema Versions

### Simple Migration (Adding Column)

```dart
@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Version 1: Original schema
  // Version 2: Added 'priority' column

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Create all tables
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // Migrating from version 1 to 2
          await m.addColumn(todos, todos.priority);
        }
      },
    );
  }
}

// Updated table
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  // NEW COLUMN (added in version 2)
  IntColumn get priority => integer()
      .withDefault(const Constant(1))();  // Default for existing rows
}
```

### Complex Migration (Multiple Versions)

```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migrate from 1 to 2
      if (from < 2) {
        await m.addColumn(todos, todos.priority);
      }

      // Migrate from 2 to 3
      if (from < 3) {
        await m.createTable(categories);
        await m.addColumn(todos, todos.categoryId);
      }

      // Migrate from 3 to 4
      if (from < 4) {
        await m.addColumn(todos, todos.dueDate);
      }
    },
    beforeOpen: (details) async {
      // Enable foreign keys
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
```

## Part 7: Transactions

Transactions ensure multiple operations succeed or fail together.

```dart
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  // Transfer todos from one category to another
  Future<void> moveTodosToCategory({
    required int fromCategoryId,
    required int toCategoryId,
  }) async {
    await database.transaction(() async {
      // Update all todos
      await (database.update(database.todos)
        ..where((t) => t.categoryId.equals(fromCategoryId)))
        .write(
          TodosCompanion(
            categoryId: Value(toCategoryId),
          ),
        );

      // Delete old category
      await (database.delete(database.categories)
        ..where((c) => c.id.equals(fromCategoryId)))
        .go();

      // If any operation fails, ALL operations rollback!
    });
  }

  // Archive completed todos
  Future<void> archiveCompletedTodos() async {
    await database.transaction(() async {
      // Get completed todos
      final completed = await (database.select(database.todos)
        ..where((t) => t.isCompleted.equals(true)))
        .get();

      // Insert into archive table
      for (var todo in completed) {
        await database.into(database.archivedTodos).insert(
          ArchivedTodosCompanion.insert(
            title: todo.title,
            description: Value(todo.description),
            completedAt: DateTime.now(),
          ),
        );
      }

      // Delete from todos
      await (database.delete(database.todos)
        ..where((t) => t.isCompleted.equals(true)))
        .go();
    });
  }
}
```

## Part 8: Best Practices

### 1. Use Dependency Injection

```dart
// ✅ Good: Pass database to widgets
class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(database: database),
    );
  }
}

// Or use Provider
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();

  runApp(
    Provider.value(
      value: database,
      child: MyApp(),
    ),
  );
}

// Access in widgets
class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    // Use database...
  }
}
```

### 2. Create Service Classes

```dart
// ✅ Good: Separate database logic
class TodoService {
  final AppDatabase database;

  TodoService(this.database);

  Stream<List<Todo>> watchAllTodos() {
    return database.select(database.todos).watch();
  }

  Future<void> addTodo(String title) async {
    await database.into(database.todos).insert(
      TodosCompanion.insert(
        title: title,
        createdAt: DateTime.now(),
      ),
    );
  }

  // More methods...
}
```

### 3. Close Database Properly

```dart
class MyApp extends StatefulWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.database.close();  // Close database
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
```

### 4. Use Indexes for Performance

```dart
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {email},  // Unique index on email
  ];
}

// Or use custom indexes
@TableIndex(name: 'users_email_idx', columns: {#email})
class Users extends Table {
  // ...
}
```

## Exercises

### Exercise 1: Notes App with Folders (Beginner-Intermediate)

Create a notes app with folders/categories.

**Requirements:**
- Folders table (name, color)
- Notes table (title, content, folderId, createdAt)
- CRUD operations for both
- Reactive queries (auto-updating UI)
- Move note to different folder
- Delete folder (ask what to do with notes: delete or move to "Uncategorized")

### Exercise 2: Expense Tracker with Categories (Intermediate)

Build an expense tracker with categories and statistics.

**Requirements:**
- Categories table (name, icon, color, budget)
- Expenses table (amount, categoryId, date, description)
- Add/edit/delete expenses
- Show total expenses by category
- Show budget vs actual spending
- Filter by date range
- Reactive queries for statistics

**Hints:**
```dart
// Calculate total by category
Future<Map<String, double>> getTotalByCategory() async {
  final query = database.selectOnly(database.categories).join([
    innerJoin(
      database.expenses,
      database.expenses.categoryId.equalsExp(database.categories.id),
    ),
  ]);

  final sumExp = database.expenses.amount.sum();

  query
    ..addColumns([database.categories.name, sumExp])
    ..groupBy([database.categories.id]);

  final results = await query.get();

  return Map.fromEntries(
    results.map((row) {
      final name = row.read(database.categories.name)!;
      final total = row.read(sumExp) ?? 0.0;
      return MapEntry(name, total);
    }),
  );
}
```

### Exercise 3: Task Manager with Subtasks (Intermediate-Advanced)

Create a task manager with parent tasks and subtasks.

**Requirements:**
- Tasks table with self-referencing foreign key (parentId)
- Task can have multiple subtasks
- Complete parent task only if all subtasks complete
- Priority levels (Low, Medium, High)
- Due dates
- Reactive query showing task tree structure

**Model:**
```dart
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer()();

  // Self-reference for subtasks
  IntColumn get parentId => integer()
      .nullable()
      .references(Tasks, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### Exercise 4: Shopping List with Stores (Advanced)

Build a shopping list with multiple stores and item prices.

**Requirements:**
- Stores table (name, location)
- Items table (name, category)
- ShoppingListItems table (itemId, storeId, quantity, price, isPurchased)
- Add items to shopping list for specific store
- Show total price per store
- Mark items as purchased
- Statistics: most expensive items, total spent per store
- Reactive queries

**Relationships:**
- Store ➜ ShoppingListItems (one-to-many)
- Item ➜ ShoppingListItems (one-to-many)

### Exercise 5: Habit Tracker with Streaks (Advanced)

Create a habit tracker with streak calculation.

**Requirements:**
- Habits table (name, targetFrequency, icon, color)
- HabitLogs table (habitId, completedAt, notes)
- Track daily habits
- Calculate current streak (consecutive days)
- Calculate longest streak
- Monthly completion rate
- Reactive widgets showing streaks
- Reminder notifications

**Complex Queries:**
```dart
// Calculate current streak
Future<int> getCurrentStreak(int habitId) async {
  final logs = await (database.select(database.habitLogs)
    ..where((l) => l.habitId.equals(habitId))
    ..orderBy([(l) => OrderingTerm.desc(l.completedAt)]))
    .get();

  if (logs.isEmpty) return 0;

  int streak = 0;
  DateTime expectedDate = DateTime.now();

  for (var log in logs) {
    final logDate = DateTime(
      log.completedAt.year,
      log.completedAt.month,
      log.completedAt.day,
    );

    final expected = DateTime(
      expectedDate.year,
      expectedDate.month,
      expectedDate.day,
    );

    if (logDate == expected) {
      streak++;
      expectedDate = expectedDate.subtract(Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
}
```

## What You've Learned

✅ What Drift is and when to use it
✅ Setting up Drift with code generation
✅ Defining tables with constraints
✅ Type-safe CRUD operations (no SQL strings!)
✅ Reactive queries with watch() for auto-updating UI
✅ Relationships between tables (one-to-many, joins)
✅ Database migrations and schema versions
✅ Transactions for atomic operations
✅ Best practices (dependency injection, service classes, indexes)
✅ Complex queries (aggregations, grouping, filtering)

## What's Next

Congratulations! You now know **four different storage solutions**:
1. **SharedPreferences** - Simple key-value (settings)
2. **SQLite** - Raw SQL (maximum control)
3. **Hive** - Fast NoSQL (simple objects)
4. **Drift** - Type-safe SQL (complex + safety)

In the next phase, you'll learn about **Offline-First Architecture** - building apps that work perfectly even without internet!

You're mastering local data storage! 🚀
