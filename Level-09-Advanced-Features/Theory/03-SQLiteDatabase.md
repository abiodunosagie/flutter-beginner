# SQLite Database: Your App's Filing Cabinet

## The Big Idea In One Sentence

> SQLite is a real database living on the phone: data sits in tables (rows and columns), and you do four things to it, Create, Read, Update, Delete (CRUD).

## The Simple Explanation

Remember SharedPreferences is like a sticky note? Well, SQLite is like a **filing cabinet**!

Imagine you're a teacher with 30 students. You need to track:
- Each student's name
- Their age
- Their grades
- Their attendance

A sticky note won't work! You need a filing cabinet with folders!

```
┌─────────────────────────────────────────────────────────┐
│           📁 FILING CABINET (SQLite Database)           │
│                                                          │
│   📂 Folder 1: Students                                  │
│   ┌───────────────────────────────────────────────────┐ │
│   │ ID │  Name   │ Age │ Grade │                      │ │
│   │────│─────────│─────│───────│                      │ │
│   │ 1  │  Alex   │ 10  │  A    │                      │ │
│   │ 2  │  Sarah  │ 11  │  B+   │                      │ │
│   │ 3  │  Mike   │ 10  │  A-   │                      │ │
│   └───────────────────────────────────────────────────┘ │
│                                                          │
│   📂 Folder 2: Subjects                                  │
│   ┌───────────────────────────────────────────────────┐ │
│   │ ID │ Subject │ Teacher    │                       │ │
│   │────│─────────│────────────│                       │ │
│   │ 1  │  Math   │ Mr. Smith  │                       │ │
│   │ 2  │  Science│ Ms. Jones  │                       │ │
│   └───────────────────────────────────────────────────┘ │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## SQLite Vocabulary (Easy Words!)

Let's learn the words with simple comparisons:

| SQLite Word | Simple Explanation | Real-Life Example |
|-------------|-------------------|-------------------|
| **Database** | The whole filing cabinet | Your phone's storage |
| **Table** | One folder in the cabinet | "Students" folder |
| **Row** | One piece of paper (one item) | Info about Alex |
| **Column** | One type of information | "Name" or "Age" |
| **Query** | Asking a question | "Show me all students" |

```
DATABASE (Cabinet)
    │
    ├── TABLE: Students (Folder)
    │       │
    │       ├── COLUMN: id
    │       ├── COLUMN: name
    │       ├── COLUMN: age
    │       │
    │       ├── ROW: {1, "Alex", 10}      ← One student
    │       ├── ROW: {2, "Sarah", 11}     ← Another student
    │       └── ROW: {3, "Mike", 10}      ← Another student
    │
    └── TABLE: Subjects (Another Folder)
            │
            └── ...
```

---

## Why Use SQLite?

### When SharedPreferences is NOT enough:

```
SharedPreferences (Sticky Note):
┌─────────────────────────────┐
│ todo1 = "Buy milk"          │
│ todo2 = "Call mom"          │
│ todo3 = "Do homework"       │
│ ...                         │
│ todo100 = ???               │  ← Getting messy!
└─────────────────────────────┘

SQLite (Filing Cabinet):
┌─────────────────────────────────────┐
│ TODOS TABLE                         │
│ ┌────┬─────────────────┬──────────┐ │
│ │ ID │ Task            │ Done?    │ │
│ ├────┼─────────────────┼──────────┤ │
│ │ 1  │ Buy milk        │ false    │ │
│ │ 2  │ Call mom        │ true     │ │
│ │ 3  │ Do homework     │ false    │ │
│ │... │ ...             │ ...      │ │
│ │100 │ Clean room      │ false    │ │
│ └────┴─────────────────┴──────────┘ │
└─────────────────────────────────────┘
             ↑ Nice and organized!
```

### SQLite is Perfect For:
- ✅ Todo lists
- ✅ Notes
- ✅ Contacts
- ✅ Chat messages
- ✅ Shopping lists
- ✅ Anything with MANY items

---

## Setting Up SQLite

### Step 1: Add the Packages

In your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
```

Then run:
```bash
flutter pub get
```

### Step 2: Import Them

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
```

---

## Creating a Database: Step by Step

Let's create a Todo app database!

### Step 1: Create a Helper Class

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Only ONE instance of the database (Singleton)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get the database (create if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    // Get the path to store the database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Open (or create) the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}
```

### What This Code Does (Simple Explanation)

```
When you first use the database:

1. "Hey, do I already have a database?"
       │
       ├── YES → "Great, use it!"
       │
       └── NO → "Let me create one!"
                     │
                     ▼
              Creates a file called 'todos.db'
                     │
                     ▼
              Creates a table called 'todos'
              with columns: id, title, description, isDone
                     │
                     ▼
              "Ready to use!"
```

---

## CRUD Operations: The 4 Things You Can Do

CRUD stands for:
- **C**reate (Add new data)
- **R**ead (Get data)
- **U**pdate (Change data)
- **D**elete (Remove data)

Think of it like a notebook:
- **Create** = Write a new page
- **Read** = Look at pages
- **Update** = Erase and rewrite
- **Delete** = Rip out a page

---

## CREATE: Adding New Todos

```dart
// Add this to DatabaseHelper class:

Future<int> createTodo(Todo todo) async {
  final db = await database;

  // Insert the todo into the 'todos' table
  return await db.insert('todos', todo.toMap());
}
```

### How to Use It:

```dart
// Create a new todo
final todo = Todo(
  title: 'Buy groceries',
  description: 'Milk, eggs, bread',
  isDone: false,
);

// Save it to database
final id = await DatabaseHelper.instance.createTodo(todo);
print('Todo saved with id: $id');
```

### What Happens:

```
Before:
┌────────────────────────────────────────┐
│ TODOS TABLE                            │
│ ┌────┬────────────────┬────────┬─────┐ │
│ │ ID │ Title          │ Desc   │Done │ │
│ ├────┼────────────────┼────────┼─────┤ │
│ │    │ (empty)        │        │     │ │
│ └────┴────────────────┴────────┴─────┘ │
└────────────────────────────────────────┘

After createTodo():
┌────────────────────────────────────────┐
│ TODOS TABLE                            │
│ ┌────┬────────────────┬────────┬─────┐ │
│ │ ID │ Title          │ Desc   │Done │ │
│ ├────┼────────────────┼────────┼─────┤ │
│ │ 1  │ Buy groceries  │ Milk...│  0  │ │
│ └────┴────────────────┴────────┴─────┘ │
└────────────────────────────────────────┘
        ↑ New row added!
```

---

## READ: Getting Todos

### Get ALL Todos:

```dart
Future<List<Todo>> getAllTodos() async {
  final db = await database;

  // Get all rows from 'todos' table
  final result = await db.query('todos');

  // Convert to Todo objects
  return result.map((map) => Todo.fromMap(map)).toList();
}
```

### Get ONE Todo:

```dart
Future<Todo?> getTodo(int id) async {
  final db = await database;

  // Get specific todo
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
```

### How to Use It:

```dart
// Get all todos
final todos = await DatabaseHelper.instance.getAllTodos();
for (final todo in todos) {
  print('${todo.title}: ${todo.isDone ? "Done" : "Not done"}');
}

// Get one specific todo
final todo = await DatabaseHelper.instance.getTodo(1);
print(todo?.title);  // "Buy groceries"
```

---

## UPDATE: Changing Todos

```dart
Future<int> updateTodo(Todo todo) async {
  final db = await database;

  return await db.update(
    'todos',
    todo.toMap(),
    where: 'id = ?',
    whereArgs: [todo.id],
  );
}
```

### How to Use It:

```dart
// Get a todo
var todo = await DatabaseHelper.instance.getTodo(1);

// Mark it as done
todo = todo!.copyWith(isDone: true);

// Save the change
await DatabaseHelper.instance.updateTodo(todo);
```

### What Happens:

```
Before:
┌────┬────────────────┬────────┬─────┐
│ ID │ Title          │ Desc   │Done │
├────┼────────────────┼────────┼─────┤
│ 1  │ Buy groceries  │ Milk...│  0  │  ← Not done
└────┴────────────────┴────────┴─────┘

After updateTodo():
┌────┬────────────────┬────────┬─────┐
│ ID │ Title          │ Desc   │Done │
├────┼────────────────┼────────┼─────┤
│ 1  │ Buy groceries  │ Milk...│  1  │  ← Done!
└────┴────────────────┴────────┴─────┘
```

---

## DELETE: Removing Todos

```dart
Future<int> deleteTodo(int id) async {
  final db = await database;

  return await db.delete(
    'todos',
    where: 'id = ?',
    whereArgs: [id],
  );
}
```

### How to Use It:

```dart
// Delete todo with id 1
await DatabaseHelper.instance.deleteTodo(1);
print('Todo deleted!');
```

### What Happens:

```
Before:
┌────┬────────────────┬────────┬─────┐
│ ID │ Title          │ Desc   │Done │
├────┼────────────────┼────────┼─────┤
│ 1  │ Buy groceries  │ Milk...│  1  │
│ 2  │ Call mom       │ Today  │  0  │
│ 3  │ Do homework    │ Math   │  0  │
└────┴────────────────┴────────┴─────┘

After deleteTodo(1):
┌────┬────────────────┬────────┬─────┐
│ ID │ Title          │ Desc   │Done │
├────┼────────────────┼────────┼─────┤
│ 2  │ Call mom       │ Today  │  0  │
│ 3  │ Do homework    │ Math   │  0  │
└────┴────────────────┴────────┴─────┘
        ↑ Row 1 is gone!
```

---

## Complete Todo Class

```dart
class Todo {
  final int? id;
  final String title;
  final String? description;
  final bool isDone;

  const Todo({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
  });

  // Convert Todo to Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,  // SQLite uses 0/1 for bool
    };
  }

  // Convert Map to Todo (from database)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isDone: (map['isDone'] as int) == 1,  // 1 = true, 0 = false
    );
  }

  // Create copy with changes
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
```

---

## Putting It All Together

### Complete Database Helper:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CREATE
  Future<int> createTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap());
  }

  // READ all
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final result = await db.query('todos');
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // READ one
  Future<Todo?> getTodo(int id) async {
    final db = await database;
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

  // UPDATE
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // DELETE
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
```

---

## Using It in a Widget

```dart
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await DatabaseHelper.instance.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo(String title) async {
    final todo = Todo(title: title);
    await DatabaseHelper.instance.createTodo(todo);
    _loadTodos();  // Refresh the list
  }

  Future<void> _toggleTodo(Todo todo) async {
    final updated = todo.copyWith(isDone: !todo.isDone);
    await DatabaseHelper.instance.updateTodo(updated);
    _loadTodos();  // Refresh the list
  }

  Future<void> _deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    _loadTodos();  // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todos')),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (_) => _toggleTodo(todo),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone
                  ? TextDecoration.lineThrough
                  : null,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTodo(todo.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo('New Todo ${_todos.length + 1}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                   SQLITE SUMMARY                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: A filing cabinet for organized data               │
│                                                          │
│  VOCABULARY:                                             │
│  • Database = Filing cabinet                             │
│  • Table = Folder                                        │
│  • Row = One piece of paper                              │
│  • Column = Type of information                          │
│                                                          │
│  CRUD OPERATIONS:                                        │
│  • Create = Add new data                                 │
│  • Read = Get data                                       │
│  • Update = Change data                                  │
│  • Delete = Remove data                                  │
│                                                          │
│  WHEN TO USE:                                            │
│  • Many items (lists)                                    │
│  • Need to search data                                   │
│  • Organized/related data                                │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What is a "table" in SQLite?

<details>
<summary>Answer</summary>

A table is like a **folder** in a filing cabinet. It holds related information organized in rows and columns. For example, a "todos" table holds all your todo items.

</details>

**Q2:** What does CRUD stand for?

<details>
<summary>Answer</summary>

- **C**reate - Add new data
- **R**ead - Get data
- **U**pdate - Change data
- **D**elete - Remove data

</details>

**Q3:** When should you use SQLite instead of SharedPreferences?

<details>
<summary>Answer</summary>

Use SQLite when you have:
- Many items (like a list of todos)
- Need to search through data
- Data that's organized with multiple fields
- Related data that connects together

Use SharedPreferences for simple things like settings (dark mode: true/false).

</details>

---

## Assignment

### Problem 1: Name the CRUD

For each action on a todo table, name the CRUD operation:
1. Save a brand new todo.
2. Mark a todo as done.
3. Remove a todo.
4. Show all todos.

### Problem 2: Table or sticky note?

You need to store 300 contacts and search them by name. SQLite or SharedPreferences? Why?

### Problem 3: Vocabulary

Match the database word to the everyday word: table, row, column.

---

## Assignment Answers

### Problem 1: Name the CRUD

1. **Create** (insert).
2. **Update**.
3. **Delete**.
4. **Read** (query).

### Problem 2: Table or sticky note?

**SQLite.** It is built for many records and lets you search/filter (e.g. by name). SharedPreferences is only for a few simple values.

### Problem 3: Vocabulary

- table = a sheet/spreadsheet (one kind of thing, like "todos")
- row = one record (one todo)
- column = one field (like "title" or "isDone")

---

**Next:** Let's learn about Forms and Validation!

---

**Continue to:** `04-FormsAndValidation.md`
