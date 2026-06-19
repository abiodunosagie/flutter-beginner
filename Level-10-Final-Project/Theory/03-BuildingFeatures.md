# Building Features: Step by Step

## The Big Idea In One Sentence

> Build one feature at a time from the bottom up (model → data → logic → UI), get it fully working, then move to the next, instead of half-building everything at once.

## The Simple Explanation

Building an app is like building with LEGO blocks:

```
Don't try to build this all at once:
┌─────────────────────────────────────┐
│          🏰 CASTLE                  │
│     (1000 pieces, very complex)     │
└─────────────────────────────────────┘

Instead, build piece by piece:
┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐
│ 🧱  │  │ 🧱  │  │ 🧱  │  │ 🧱  │
│Wall │→ │Door │→ │Tower│→ │Flag │
└─────┘  └─────┘  └─────┘  └─────┘
   1        2        3        4
```

**Build one small piece at a time. Test it. Then move on.**

---

## The Feature Development Cycle

```
┌─────────────────────────────────────────────────────────┐
│              FEATURE DEVELOPMENT CYCLE                   │
└─────────────────────────────────────────────────────────┘

     ┌──────────┐
     │  1. PLAN │ ← What exactly will this do?
     └────┬─────┘
          │
          ▼
     ┌──────────┐
     │ 2. BUILD │ ← Write the code
     └────┬─────┘
          │
          ▼
     ┌──────────┐
     │  3. TEST │ ← Does it work?
     └────┬─────┘
          │
          ▼
     ┌──────────┐
     │  4. FIX  │ ← Fix any bugs
     └────┬─────┘
          │
          ▼
     ┌──────────┐
     │ 5. NEXT  │ ← Move to next feature
     └──────────┘
```

---

## Example: Building "Add Task" Feature

Let's build a complete feature step by step.

### Step 1: Plan the Feature

```
FEATURE: Add a new task

USER STORY:
"As a user, I want to add a task so I can remember what to do."

WHAT IT NEEDS:
├── A button to open the add form
├── A form with title field
├── Optional description field
├── A save button
└── Go back to list after saving

ACCEPTANCE CRITERIA:
✓ Can enter a task title
✓ Title is required (can't be empty)
✓ Can optionally add description
✓ Task saves to database
✓ Returns to home screen after saving
✓ New task appears in list
```

### Step 2: Build the Model

First, create the data structure:

```dart
// models/task.dart

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Copy with changes (for updates)
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (from database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
```

### Step 3: Build the Service

Create the database operations:

```dart
// services/task_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskService {
  static Database? _database;

  // Get or create database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            is_completed INTEGER DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE - Add new task
  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  // READ - Get all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'created_at DESC');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // UPDATE - Update a task
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE - Remove a task
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
```

### Step 4: Build the Provider

Create state management:

```dart
// providers/task_provider.dart

import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed properties
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;

  // Load all tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _service.getAllTasks();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new task
  Future<bool> addTask(String title, String? description) async {
    try {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      await _service.addTask(task);
      _tasks.insert(0, task); // Add to beginning of list
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add task: $e';
      notifyListeners();
      return false;
    }
  }

  // Toggle task completion
  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updated = task.copyWith(isCompleted: !task.isCompleted);

    try {
      await _service.updateTask(updated);
      _tasks[index] = updated;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update task: $e';
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _service.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete task: $e';
      notifyListeners();
    }
  }
}
```

### Step 5: Build the UI - Add Task Screen

```dart
// screens/add_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Save task
    final provider = context.read<TaskProvider>();
    final success = await provider.addTask(
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added!'),
          backgroundColor: Colors.green,
        ),
      );
      // Go back to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'What do you need to do?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add more details...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTask,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 6: Test the Feature

```
TESTING CHECKLIST:

□ Can open add task screen
□ Title field accepts input
□ Empty title shows error
□ Short title (< 3 chars) shows error
□ Description is optional
□ Save button saves task
□ Shows loading indicator while saving
□ Shows success message after save
□ Returns to home screen
□ New task appears in list
□ Task persists after app restart
```

---

## Feature Building Tips

### Tip 1: Start with the Happy Path

```
HAPPY PATH:
The ideal scenario where everything works perfectly.

Example for Add Task:
1. User opens form ✓
2. User types title ✓
3. User taps save ✓
4. Task is saved ✓
5. User returns to list ✓

Build this first. Then handle edge cases:
- What if title is empty?
- What if database fails?
- What if user taps back?
```

### Tip 2: Build Vertically

```
DON'T BUILD LIKE THIS (Horizontal):
┌──────┬──────┬──────┬──────┐
│ All  │ All  │ All  │ All  │
│Models│Services│Providers│ UI │
│      │      │      │      │
└──────┴──────┴──────┴──────┘
(Building all layers for all features at once)

BUILD LIKE THIS (Vertical):
┌──────┐
│Add   │ ← Complete this feature first
│Task  │
│(all  │
│layers)│
└──────┘
   ↓
┌──────┐
│View  │ ← Then this feature
│Tasks │
│(all  │
│layers)│
└──────┘
   ↓
(Continue with more features...)
```

### Tip 3: One Thing at a Time

```dart
// ❌ BAD: Trying to do everything at once
class TaskScreen extends StatefulWidget {
  // 500 lines of code doing:
  // - List tasks
  // - Add tasks
  // - Edit tasks
  // - Delete tasks
  // - Filter tasks
  // - Sort tasks
  // - Search tasks
  // ALL IN ONE FILE!
}

// ✅ GOOD: Separate concerns
class TaskListScreen { }      // Just lists tasks
class AddTaskScreen { }       // Just adds tasks
class EditTaskScreen { }      // Just edits tasks
class TaskFilterWidget { }    // Just filters
class TaskSearchWidget { }    // Just searches
```

---

## Common Feature Patterns

### Pattern 1: List Screen

```dart
// A screen that shows a list of items

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          // Handle loading
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          // Handle empty
          if (provider.items.isEmpty) {
            return const Center(child: Text('No items yet'));
          }

          // Show list
          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              return ItemTile(item: provider.items[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Pattern 2: Form Screen

```dart
// A screen with a form to create/edit something

class ItemFormScreen extends StatefulWidget {
  final Item? item; // null = create, not null = edit

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isSaving = false;

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.item?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Save logic here...

    if (mounted) Navigator.pop(context);
  }
}
```

### Pattern 3: Detail Screen

```dart
// A screen that shows details of one item

class ItemDetailScreen extends StatelessWidget {
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          final item = provider.getItemById(itemId);
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(item.description ?? 'No description'),
              // More details...
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ItemProvider>().deleteItem(itemId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

---

## Connecting Features Together

```
┌─────────────────────────────────────────────────────────┐
│                 NAVIGATION FLOW                          │
└─────────────────────────────────────────────────────────┘

┌──────────────┐
│  Home/List   │ ←─────────────────────┐
│   Screen     │                       │
└──────┬───────┘                       │
       │                               │
       │ Tap item                      │ Back button
       ▼                               │
┌──────────────┐                       │
│   Detail     │───────────────────────┤
│   Screen     │                       │
└──────┬───────┘                       │
       │                               │
       │ Tap edit                      │ Save/Cancel
       ▼                               │
┌──────────────┐                       │
│    Edit      │───────────────────────┘
│   Screen     │
└──────────────┘


┌──────────────┐     Tap +       ┌──────────────┐
│  Home/List   │ ───────────────→│     Add      │
│   Screen     │ ←───────────────│   Screen     │
└──────────────┘   Save/Cancel   └──────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│            BUILDING FEATURES SUMMARY                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. PLAN first - know what you're building              │
│                                                          │
│  2. Build VERTICALLY - complete one feature             │
│     before starting the next                            │
│                                                          │
│  3. Follow the LAYERS:                                  │
│     Model → Service → Provider → UI                     │
│                                                          │
│  4. TEST each feature before moving on                  │
│                                                          │
│  5. Use common PATTERNS:                                │
│     - List Screen                                       │
│     - Form Screen                                       │
│     - Detail Screen                                     │
│                                                          │
│  6. Connect features with NAVIGATION                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why build one feature fully before starting the next?

<details>
<summary>Answer</summary>
So you always have something working, you can test as you go, and you do not end up with many half-finished pieces that all break together.
</details>

**Q2.** In what order do the layers of a feature usually come together?

<details>
<summary>Answer</summary>
Bottom up: model, then data access (repository/service), then logic/state (controller), then the UI.
</details>

**Q3.** What should you do right after a feature works?

<details>
<summary>Answer</summary>
Test it (and commit it) before moving on, so you lock in working code.
</details>

---

## Assignment

You are adding a "favorites" feature to a recipe app.

### Problem 1: Order the steps

Put these in build order: build the favorites screen, add an `isFavorite` field to the `Recipe` model, write the save/load in the repository.

### Problem 2: One at a time

Why not build favorites, search, and sharing all at the same time?

### Problem 3: Done means what?

Name two things that make a feature truly "done", not just "looks done".

---

## Assignment Answers

### Problem 1: Order the steps

1. Add `isFavorite` to the `Recipe` model.
2. Write save/load in the repository.
3. Build the favorites screen (UI) last, on top of the working data.

### Problem 2: One at a time

Building them together means nothing fully works and bugs tangle across features. One at a time keeps the app always runnable and bugs isolated.

### Problem 3: Done means what?

Any two: it works for the happy path AND error cases, it is tested, the code is committed, and the UI handles loading/empty/error states.

---

**Next:** `04-TestingBasics.md` - Making sure your app works correctly
