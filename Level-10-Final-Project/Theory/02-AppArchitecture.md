# App Architecture: Organizing Your Code

## The Simple Explanation

Imagine your bedroom:

**Messy Room (Bad Code):**
```
Clothes on the floor
Books under the bed
Shoes everywhere
Can't find anything!
```

**Organized Room (Good Code):**
```
Clothes in the closet
Books on the shelf
Shoes by the door
Find anything instantly!
```

**App architecture is just organizing your code so you can find things!**

---

## Why Does Organization Matter?

```
WITHOUT ORGANIZATION:                WITH ORGANIZATION:
┌─────────────────────┐             ┌─────────────────────┐
│  lib/               │             │  lib/               │
│  ├── main.dart      │             │  ├── main.dart      │
│  │   (3000 lines!)  │             │  ├── models/        │
│  │                  │             │  │   └── task.dart  │
│  │   - UI code      │             │  ├── services/      │
│  │   - Database     │             │  │   └── db.dart    │
│  │   - API calls    │             │  ├── screens/       │
│  │   - Navigation   │             │  │   └── home.dart  │
│  │   - Everything!  │             │  └── widgets/       │
│  │                  │             │      └── button.dart│
│  └── 😵 Nightmare!  │             │                     │
│                     │             │  😊 Easy to find!   │
└─────────────────────┘             └─────────────────────┘
```

---

## The Layers of an App

Think of your app like a cake with layers:

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│                    🎂 THE APP CAKE                       │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│   Layer 1: UI (What users see)                          │
│   ═══════════════════════════════════════════════       │
│   Screens, Widgets, Buttons, Text                       │
│                                                          │
│   Layer 2: State (What the app remembers)               │
│   ═══════════════════════════════════════════════       │
│   Providers, BLoCs, Controllers                         │
│                                                          │
│   Layer 3: Logic (How things work)                      │
│   ═══════════════════════════════════════════════       │
│   Services, Helpers, Utilities                          │
│                                                          │
│   Layer 4: Data (Where info lives)                      │
│   ═══════════════════════════════════════════════       │
│   Models, Database, API                                 │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Folder Structure Explained

### The Full Structure

```
lib/
│
├── main.dart                 # App starts here
├── app.dart                  # MaterialApp configuration
│
├── config/                   # 📋 Settings & Constants
│   ├── routes.dart          # Navigation routes
│   ├── theme.dart           # Colors, fonts, styles
│   └── constants.dart       # Fixed values
│
├── models/                   # 📦 Data Containers
│   ├── task.dart            # Task class
│   ├── user.dart            # User class
│   └── category.dart        # Category class
│
├── services/                 # ⚙️ Business Logic
│   ├── database_service.dart    # SQLite operations
│   ├── api_service.dart         # API calls
│   ├── auth_service.dart        # Login/logout
│   └── storage_service.dart     # Local storage
│
├── providers/                # 🔄 State Management
│   ├── task_provider.dart   # Task state
│   ├── user_provider.dart   # User state
│   └── theme_provider.dart  # Theme state
│
├── screens/                  # 📱 Full Pages
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/         # Widgets only for home
│   │       ├── task_list.dart
│   │       └── filter_bar.dart
│   ├── task/
│   │   ├── add_task_screen.dart
│   │   ├── edit_task_screen.dart
│   │   └── task_detail_screen.dart
│   └── settings/
│       └── settings_screen.dart
│
├── widgets/                  # 🧩 Reusable Pieces
│   ├── common/
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   └── empty_state.dart
│   ├── task_tile.dart
│   ├── category_chip.dart
│   └── custom_button.dart
│
└── utils/                    # 🔧 Helper Functions
    ├── validators.dart      # Form validation
    ├── formatters.dart      # Date/text formatting
    └── extensions.dart      # Dart extensions
```

---

## What Goes Where?

### 1. Models - Data Containers

**What:** Classes that hold data
**Example:** Task, User, Product

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

  // Convert to/from JSON for storage
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'is_completed': isCompleted ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    isCompleted: map['is_completed'] == 1,
    createdAt: DateTime.parse(map['created_at']),
  );
}
```

### 2. Services - Business Logic

**What:** Classes that DO things (database, API, etc.)
**Example:** DatabaseService, ApiService

```dart
// services/database_service.dart
class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Setup database
  }

  // CRUD Operations
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
```

### 3. Providers - State Management

**What:** Classes that manage app state and notify UI
**Example:** TaskProvider, UserProvider

```dart
// providers/task_provider.dart
class TaskProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all active tasks
  List<Task> get activeTasks =>
    _tasks.where((t) => !t.isCompleted).toList();

  // Get completed tasks
  List<Task> get completedTasks =>
    _tasks.where((t) => t.isCompleted).toList();

  // Load tasks from database
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _db.getAllTasks();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add new task
  Future<void> addTask(Task task) async {
    await _db.insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  // Toggle completion
  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updated = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
        createdAt: task.createdAt,
      );
      await _db.updateTask(updated);
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    await _db.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
```

### 4. Screens - Full Pages

**What:** Complete pages the user sees
**Example:** HomeScreen, SettingsScreen

```dart
// screens/home/home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const LoadingWidget();
          }

          if (taskProvider.error != null) {
            return ErrorWidget(message: taskProvider.error!);
          }

          if (taskProvider.tasks.isEmpty) {
            return const EmptyStateWidget(
              message: 'No tasks yet!',
              icon: Icons.check_circle_outline,
            );
          }

          return TaskList(tasks: taskProvider.tasks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 5. Widgets - Reusable Pieces

**What:** Small UI components used in multiple places
**Example:** TaskTile, LoadingWidget

```dart
// widgets/task_tile.dart
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onComplete?.call(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : null,
          ),
        ),
        subtitle: task.description != null
          ? Text(task.description!)
          : null,
        onTap: onTap,
      ),
    );
  }
}
```

---

## Data Flow

How data moves through your app:

```
┌─────────────────────────────────────────────────────────┐
│                     DATA FLOW                            │
└─────────────────────────────────────────────────────────┘

User taps "Add Task"
        │
        ▼
┌───────────────┐
│    Screen     │  UI layer - shows the form
└───────┬───────┘
        │ User fills form and taps Save
        ▼
┌───────────────┐
│   Provider    │  Creates Task object
└───────┬───────┘
        │ Calls service to save
        ▼
┌───────────────┐
│   Service     │  Writes to database
└───────┬───────┘
        │ Success!
        ▼
┌───────────────┐
│   Provider    │  Updates task list
└───────┬───────┘
        │ notifyListeners()
        ▼
┌───────────────┐
│    Screen     │  Rebuilds with new task
└───────────────┘
        │
        ▼
    User sees new task! 🎉
```

---

## Rules to Follow

### 1. One Job Per Class

```dart
// ❌ BAD: Class does too much
class TaskManager {
  void saveToDatabase() { }
  void callApi() { }
  Widget buildUI() { }
  void validateForm() { }
}

// ✅ GOOD: Each class has one job
class DatabaseService {  // Saves data
  void save() { }
}

class ApiService {  // Calls API
  void fetch() { }
}

class TaskProvider {  // Manages state
  void addTask() { }
}
```

### 2. Widgets Don't Call Database

```dart
// ❌ BAD: Widget talks to database directly
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final tasks = db.getAllTasks();  // NO!
  }
}

// ✅ GOOD: Widget uses Provider
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;  // YES!
  }
}
```

### 3. Keep Screens Simple

```dart
// ❌ BAD: Too much logic in screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 200 lines of business logic here...
    // Then finally some UI
  }
}

// ✅ GOOD: Screen just arranges widgets
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: const TaskList(),
      fab: const AddTaskButton(),
    );
  }
}
```

---

## File Naming Conventions

```
Files and folders: snake_case
├── task_provider.dart       ✅
├── TaskProvider.dart        ❌
├── taskprovider.dart        ❌

Classes: PascalCase
class TaskProvider { }       ✅
class taskProvider { }       ❌
class task_provider { }      ❌

Variables and functions: camelCase
void loadTasks() { }         ✅
void LoadTasks() { }         ❌
void load_tasks() { }        ❌
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              ARCHITECTURE SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  models/    → Data structures (Task, User)              │
│                                                          │
│  services/  → Business logic (Database, API)            │
│                                                          │
│  providers/ → State management (TaskProvider)           │
│                                                          │
│  screens/   → Full pages (HomeScreen)                   │
│                                                          │
│  widgets/   → Reusable UI pieces (TaskTile)             │
│                                                          │
│  utils/     → Helper functions (validators)             │
│                                                          │
│  config/    → App settings (theme, routes)              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** `03-BuildingFeatures.md` - Step-by-step feature development
