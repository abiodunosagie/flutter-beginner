# Hive: Fast NoSQL Local Database

## What You'll Learn

In this comprehensive lesson, you'll master:
- What Hive is and why it's amazing
- When to use Hive vs SQLite vs SharedPreferences
- Setting up Hive in your Flutter app
- Creating and using Hive boxes
- Type adapters for custom objects
- CRUD operations with Hive
- Lazy boxes for large datasets
- Encryption with HiveAES
- Real-world examples and best practices
- 5 progressive exercises

By the end, you'll know exactly when and how to use Hive for lightning-fast local storage!

## Understanding Hive (Like Teaching a 5-Year-Old)

### What is Hive?

Imagine you have a toy chest in your room:

**SharedPreferences = Small Drawer:**
```
📦 Small drawer on your desk
- Store: A few small things (keys, coins, notes)
- Access: Super fast! Just open drawer
- Limitations: Can't store many things or big toys
```

**SQLite = Filing Cabinet:**
```
🗄️ Big filing cabinet with folders
- Store: Lots of organized documents in folders
- Access: Need to search through folders (slower)
- Power: Can do complex searches ("find all red files from 2023")
```

**Hive = Magic Toy Chest:**
```
✨ Special toy chest with magical organization
- Store: Lots of things (toys, books, games)
- Access: SUPER FAST! Just say "get my red car" and it appears!
- Easy: No folders needed, just throw things in and label them
- Limitations: Can't do complex searches like filing cabinet
```

**In programming terms:**

| Feature | SharedPreferences | SQLite | Hive |
|---------|------------------|--------|------|
| **Speed** | ⚡⚡⚡ Very Fast | ⚡ Moderate | ⚡⚡⚡ Very Fast |
| **Capacity** | Small (KBs) | Large (GBs) | Large (GBs) |
| **Structure** | Key-Value | Tables & SQL | Key-Value + Objects |
| **Setup** | Easy | Medium | Easy |
| **Queries** | Simple | Complex SQL | Simple |
| **Best For** | Settings | Complex data | Objects & Lists |

### Why Hive is Special

```dart
// ❌ SQLite: Write a lot of code
class DatabaseHelper {
  // 50+ lines of code
  // CREATE TABLE statements
  // toMap/fromMap conversions
  // SQL queries
}

// ✅ Hive: Write very little code
final box = await Hive.openBox('users');
box.put('user1', user);  // Done! ✨
```

**Hive Advantages:**
1. **NO SQL REQUIRED** - No CREATE TABLE, no queries
2. **SUPER FAST** - Faster than SQLite for simple operations
3. **EASY TO USE** - Less code, simpler API
4. **TYPE SAFE** - Store actual Dart objects
5. **LAZY LOADING** - Load data only when needed
6. **ENCRYPTION** - Built-in security

**When to Use Hive:**
- ✅ Storing lists of objects (todos, notes, products)
- ✅ Caching API responses
- ✅ Simple CRUD operations
- ✅ When you need speed
- ✅ When you want simple code

**When to Use SQLite Instead:**
- ✅ Complex relationships (users have orders, orders have items)
- ✅ Complex queries (JOIN, GROUP BY, aggregate functions)
- ✅ Need SQL expertise already in your team
- ✅ Existing SQL database you're migrating from

## Part 1: Setting Up Hive

### Step 1: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Hive for local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  # For generating TypeAdapters
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

Run:
```bash
flutter pub get
```

### Step 2: Initialize Hive

In `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Always call this first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters (we'll learn this later)
  // Hive.registerAdapter(PersonAdapter());

  // Open boxes you need
  await Hive.openBox('settings');
  await Hive.openBox('favorites');

  runApp(MyApp());
}
```

**What's happening:**
1. `Hive.initFlutter()` - Sets up Hive for Flutter
2. `registerAdapter()` - Tells Hive how to store custom objects
3. `openBox()` - Opens a "box" (like opening a toy chest)

## Part 2: Basic Hive Operations (Primitive Types)

### Opening a Box

A **Box** is like a container. You can have multiple boxes for different purposes.

```dart
// Open a box (do this once, usually in main())
final box = await Hive.openBox('myBox');

// You can also open multiple boxes
final settingsBox = await Hive.openBox('settings');
final favoritesBox = await Hive.openBox('favorites');
final cacheBox = await Hive.openBox('cache');
```

### Storing Primitive Types

Hive can store these types directly (no adapter needed):
- `int`, `double`, `bool`, `String`
- `List`, `Map`
- `DateTime`, `BigInt`, `Uint8List`

```dart
final box = await Hive.openBox('myBox');

// Store different types
box.put('name', 'John Doe');           // String
box.put('age', 30);                     // int
box.put('height', 5.9);                 // double
box.put('isStudent', true);             // bool
box.put('hobbies', ['reading', 'gaming']); // List
box.put('scores', {'math': 95, 'english': 88}); // Map

print('All stored! ✅');
```

### Reading Data

```dart
// Read values
final name = box.get('name');           // 'John Doe'
final age = box.get('age');             // 30
final height = box.get('height');       // 5.9

// With default value if key doesn't exist
final country = box.get('country', defaultValue: 'USA');

// Type-safe reading
final hobbies = box.get('hobbies') as List<String>;
```

### Updating Data

```dart
// Update is same as put
box.put('age', 31);  // Updates age from 30 to 31

print('Updated age: ${box.get('age')}');  // 31
```

### Deleting Data

```dart
// Delete single item
box.delete('age');

// Delete multiple items
box.deleteAll(['name', 'height']);

// Clear entire box
box.clear();
```

### Checking if Key Exists

```dart
if (box.containsKey('name')) {
  print('Name exists: ${box.get('name')}');
} else {
  print('Name not found');
}
```

### Complete Example: Settings Manager

```dart
class SettingsManager {
  static const String boxName = 'settings';
  late Box box;

  // Initialize
  Future<void> init() async {
    box = await Hive.openBox(boxName);
  }

  // Dark mode
  bool get isDarkMode => box.get('dark_mode', defaultValue: false);
  Future<void> setDarkMode(bool value) async {
    await box.put('dark_mode', value);
  }

  // Font size
  double get fontSize => box.get('font_size', defaultValue: 16.0);
  Future<void> setFontSize(double value) async {
    await box.put('font_size', value);
  }

  // Language
  String get language => box.get('language', defaultValue: 'en');
  Future<void> setLanguage(String value) async {
    await box.put('language', value);
  }

  // Notifications enabled
  bool get notificationsEnabled =>
      box.get('notifications', defaultValue: true);
  Future<void> setNotifications(bool value) async {
    await box.put('notifications', value);
  }

  // Clear all settings
  Future<void> resetToDefaults() async {
    await box.clear();
  }
}

// Using it in a widget:
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settings = SettingsManager();

  @override
  void initState() {
    super.initState();
    settings.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: (value) {
              setState(() {
                settings.setDarkMode(value);
              });
            },
          ),
          ListTile(
            title: Text('Font Size'),
            subtitle: Slider(
              value: settings.fontSize,
              min: 12,
              max: 24,
              divisions: 12,
              label: settings.fontSize.toString(),
              onChanged: (value) {
                setState(() {
                  settings.setFontSize(value);
                });
              },
            ),
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              setState(() {
                settings.setNotifications(value);
              });
            },
          ),
          ListTile(
            title: Text('Reset to Defaults'),
            trailing: Icon(Icons.restore),
            onTap: () {
              setState(() {
                settings.resetToDefaults();
              });
            },
          ),
        ],
      ),
    );
  }
}
```

## Part 3: Storing Custom Objects (Type Adapters)

### The Problem

```dart
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}

final box = await Hive.openBox('people');

// ❌ This won't work!
box.put('person1', Person('John', 30));
// Error: Hive doesn't know how to store Person objects
```

### The Solution: Type Adapters

A **Type Adapter** teaches Hive how to convert your object to/from bytes.

**Two Ways to Create Adapters:**
1. **Manual** - Write adapter yourself (more control)
2. **Code Generation** - Let Hive generate it (easier)

### Method 1: Manual Type Adapter

```dart
import 'package:hive/hive.dart';

// 1. Add @HiveType annotation with unique typeId
@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String email;

  Person({
    required this.name,
    required this.age,
    required this.email,
  });
}

// 2. Create the adapter manually
class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0;  // Must match @HiveType typeId

  @override
  Person read(BinaryReader reader) {
    // Read fields in order
    final name = reader.readString();
    final age = reader.readInt();
    final email = reader.readString();

    return Person(name: name, age: age, email: email);
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    // Write fields in order
    writer.writeString(obj.name);
    writer.writeInt(obj.age);
    writer.writeString(obj.email);
  }
}

// 3. Register adapter
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(PersonAdapter());

  await Hive.openBox<Person>('people');

  runApp(MyApp());
}

// 4. Use it!
final box = Hive.box<Person>('people');
box.put('john', Person(name: 'John', age: 30, email: 'john@example.com'));

final john = box.get('john');
print('${john.name} is ${john.age} years old');
```

### Method 2: Code Generation (Recommended)

**Much easier!** Let Hive generate the adapter for you.

**Step 1:** Add annotations to your class

```dart
import 'package:hive/hive.dart';

part 'person.g.dart';  // Generated file

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String email;

  Person({
    required this.name,
    required this.age,
    required this.email,
  });
}
```

**Step 2:** Run code generation

```bash
flutter packages pub run build_runner build
```

This creates `person.g.dart` with the adapter code!

**Step 3:** Register and use

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register generated adapter
  Hive.registerAdapter(PersonAdapter());

  await Hive.openBox<Person>('people');

  runApp(MyApp());
}
```

### Important Rules for Type Adapters

1. **Unique typeId**: Each class needs unique typeId (0, 1, 2, 3...)
2. **Don't reuse typeIds**: Once used, never change or reuse
3. **Order matters**: Don't change order of @HiveField numbers
4. **Adding fields**: Always add new fields with new numbers at the end

```dart
// ❌ BAD: Changed field order
@HiveType(typeId: 0)
class Person {
  @HiveField(1)  // Was 0 before - BAD!
  String name;

  @HiveField(0)  // Was 1 before - BAD!
  int age;
}

// ✅ GOOD: Add new fields at the end
@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)  // New field with new number
  String? phone;
}
```

## Part 4: Complete CRUD Example with Custom Objects

### Creating the Model

```dart
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  int priority;  // 1 = Low, 2 = Medium, 3 = High

  Todo({
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.priority = 1,
  });
}
```

### Creating the Service

```dart
class TodoService {
  static const String boxName = 'todos';
  late Box<Todo> box;

  // Initialize
  Future<void> init() async {
    box = await Hive.openBox<Todo>(boxName);
  }

  // CREATE: Add new todo
  Future<void> addTodo(Todo todo) async {
    await box.add(todo);
    // Can also use key: await box.put('todo_${DateTime.now()}', todo);
  }

  // READ: Get all todos
  List<Todo> getAllTodos() {
    return box.values.toList();
  }

  // READ: Get by index
  Todo? getTodoAt(int index) {
    if (index >= 0 && index < box.length) {
      return box.getAt(index);
    }
    return null;
  }

  // READ: Get incomplete todos
  List<Todo> getIncompleteTodos() {
    return box.values.where((todo) => !todo.isCompleted).toList();
  }

  // READ: Get high priority todos
  List<Todo> getHighPriorityTodos() {
    return box.values.where((todo) => todo.priority == 3).toList();
  }

  // UPDATE: Toggle completion
  Future<void> toggleTodo(int index) async {
    final todo = box.getAt(index);
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      await todo.save();  // HiveObject has save() method!
    }
  }

  // UPDATE: Edit todo
  Future<void> updateTodo(int index, Todo newTodo) async {
    await box.putAt(index, newTodo);
  }

  // DELETE: Delete todo
  Future<void> deleteTodo(int index) async {
    await box.deleteAt(index);
  }

  // DELETE: Delete all completed
  Future<void> deleteCompleted() async {
    final completedKeys = <dynamic>[];

    for (var i = 0; i < box.length; i++) {
      final todo = box.getAt(i);
      if (todo != null && todo.isCompleted) {
        completedKeys.add(box.keyAt(i));
      }
    }

    await box.deleteAll(completedKeys);
  }

  // UTILITY: Count todos
  int get totalCount => box.length;

  int get completedCount =>
      box.values.where((todo) => todo.isCompleted).length;

  int get incompleteCount =>
      box.values.where((todo) => !todo.isCompleted).length;
}
```

### Creating the UI

```dart
class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final todoService = TodoService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    await todoService.init();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Todos (${todoService.totalCount})'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              setState(() {
                todoService.deleteCompleted();
              });
            },
            tooltip: 'Delete Completed',
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: todoService.box.listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text('No todos yet! Tap + to add one.'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todo = box.getAt(index)!;

              return Dismissible(
                key: Key(todo.key.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  todoService.deleteTodo(index);
                },
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) {
                      setState(() {
                        todoService.toggleTodo(index);
                      });
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (todo.description != null)
                        Text(todo.description!),
                      SizedBox(height: 4),
                      Text(
                        'Created: ${_formatDate(todo.createdAt)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: _getPriorityChip(todo.priority),
                  onTap: () => _showEditDialog(index, todo),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _getPriorityChip(int priority) {
    Color color;
    String label;

    switch (priority) {
      case 3:
        color = Colors.red;
        label = 'High';
        break;
      case 2:
        color = Colors.orange;
        label = 'Med';
        break;
      default:
        color = Colors.green;
        label = 'Low';
    }

    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    int selectedPriority = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Low')),
                  DropdownMenuItem(value: 2, child: Text('Medium')),
                  DropdownMenuItem(value: 3, child: Text('High')),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    selectedPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final todo = Todo(
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    createdAt: DateTime.now(),
                    priority: selectedPriority,
                  );

                  setState(() {
                    todoService.addTodo(todo);
                  });

                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(int index, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description);
    int selectedPriority = todo.priority;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Low')),
                  DropdownMenuItem(value: 2, child: Text('Medium')),
                  DropdownMenuItem(value: 3, child: Text('High')),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    selectedPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final updatedTodo = Todo(
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    createdAt: todo.createdAt,
                    priority: selectedPriority,
                    isCompleted: todo.isCompleted,
                  );

                  setState(() {
                    todoService.updateTodo(index, updatedTodo);
                  });

                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Part 5: Lazy Boxes (For Large Data)

### The Problem

```dart
// Regular box loads ALL data into memory
final box = await Hive.openBox('bigData');

// If you have 10,000 items, ALL loaded into memory! 😱
// This can slow down app startup
```

### The Solution: Lazy Boxes

**Lazy Box** = Only loads data when you actually use it

```dart
// Open lazy box
final lazyBox = await Hive.openLazyBox('bigData');

// Data is NOT in memory yet
// Only loaded when you call get()
final item = await lazyBox.get('key');  // Loads ONLY this item
```

### When to Use Lazy Boxes

✅ **Use Lazy Box when:**
- You have lots of data (1000+ items)
- You don't need all data at once
- App startup time is important
- You're storing large objects (images, documents)

❌ **Use Regular Box when:**
- You have small amount of data
- You need fast access to all data
- You're iterating through all items frequently

### Example: Image Cache

```dart
class ImageCacheService {
  late LazyBox<Uint8List> imageBox;

  Future<void> init() async {
    imageBox = await Hive.openLazyBox<Uint8List>('imageCache');
  }

  // Save image
  Future<void> cacheImage(String url, Uint8List imageData) async {
    await imageBox.put(url, imageData);
  }

  // Get image
  Future<Uint8List?> getImage(String url) async {
    return await imageBox.get(url);
  }

  // Check if cached
  bool isCached(String url) {
    return imageBox.containsKey(url);
  }

  // Clear old cache (keep only recent 100 images)
  Future<void> cleanOldCache() async {
    if (imageBox.length > 100) {
      final keysToDelete = imageBox.keys.take(imageBox.length - 100);
      await imageBox.deleteAll(keysToDelete);
    }
  }
}
```

## Part 6: Encryption with HiveAES

### Encrypting Sensitive Data

If you're storing passwords, tokens, or sensitive data, **ALWAYS encrypt**!

```dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Generate encryption key
  final key = Hive.generateSecureKey();

  // Store key securely (use flutter_secure_storage in real app)
  // For demo, we'll just use it directly

  // Open encrypted box
  final encryptedBox = await Hive.openBox(
    'secrets',
    encryptionCipher: HiveAesCipher(key),
  );

  // Use normally - encryption happens automatically!
  encryptedBox.put('password', 'superSecret123');
  encryptedBox.put('apiKey', 'abc-def-ghi-123');

  print('Data encrypted and stored! ✅');

  runApp(MyApp());
}
```

### Secure Key Storage

**DON'T** hardcode the key in your code!

```dart
// ❌ BAD: Key is visible in code
final key = [1, 2, 3, 4, 5, ...];

// ✅ GOOD: Store key securely
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();
  static const _keyName = 'hive_encryption_key';

  Future<List<int>> getEncryptionKey() async {
    final keyString = await _storage.read(key: _keyName);

    if (keyString == null) {
      // First time - generate and save key
      final key = Hive.generateSecureKey();
      await _storage.write(
        key: _keyName,
        value: base64Encode(key),
      );
      return key;
    }

    // Key exists - decode and return
    return base64Decode(keyString);
  }
}

// Using it:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final secureStorage = SecureStorageService();
  final key = await secureStorage.getEncryptionKey();

  await Hive.openBox(
    'secrets',
    encryptionCipher: HiveAesCipher(key),
  );

  runApp(MyApp());
}
```

## Part 7: ValueListenableBuilder (Auto-Updates!)

One of the BEST features of Hive - **automatic UI updates**!

```dart
// ❌ Without ValueListenableBuilder: Manual updates
class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final box = Hive.box('todos');

  void addTodo() {
    box.add('New todo');
    setState(() {});  // Have to call setState manually!
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: box.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(box.getAt(index)));
      },
    );
  }
}


// ✅ With ValueListenableBuilder: Auto updates!
class TodoScreen extends StatelessWidget {
  final box = Hive.box('todos');

  void addTodo() {
    box.add('New todo');
    // No setState needed! UI updates automatically! ✨
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(box.getAt(index)));
          },
        );
      },
    );
  }
}
```

**Magic!** The UI rebuilds automatically when box changes!

### Listen to Specific Keys

```dart
// Only rebuild when specific keys change
ValueListenableBuilder(
  valueListenable: box.listenable(keys: ['username', 'email']),
  builder: (context, box, _) {
    return Column(
      children: [
        Text('Username: ${box.get('username')}'),
        Text('Email: ${box.get('email')}'),
      ],
    );
  },
)
```

## Part 8: Best Practices

### 1. Close Boxes When Done

```dart
// Close specific box
await box.close();

// Close all boxes
await Hive.close();

// Usually in app cleanup or logout
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Hive.close();  // Close all boxes
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App going to background - optional close
      // Hive.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
```

### 2. Use Lazy Boxes for Large Data

```dart
// ❌ Bad for large data
final box = await Hive.openBox('bigData');  // Loads all into memory

// ✅ Good for large data
final lazyBox = await Hive.openLazyBox('bigData');  // Loads on demand
```

### 3. Organize Boxes by Purpose

```dart
// ✅ Good organization
await Hive.openBox('settings');      // App settings
await Hive.openBox('userCache');     // User data cache
await Hive.openBox('favorites');     // User favorites
await Hive.openBox<Todo>('todos');   // Typed box for todos

// ❌ Bad: Everything in one box
await Hive.openBox('everything');    // Hard to manage!
```

### 4. Use Type-Safe Boxes

```dart
// ❌ Not type-safe
final box = await Hive.openBox('data');
box.put('user', user);  // Could put anything!

// ✅ Type-safe
final box = await Hive.openBox<User>('users');
box.put('user', user);  // Only accepts User objects!
```

### 5. Compact Boxes Regularly

Over time, deleted items leave "holes" in the database file.

```dart
// Compact to reclaim space
await box.compact();

// Do this periodically, like on app start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final box = await Hive.openBox('myBox');

  // Compact if box is large and has many deletions
  if (box.length > 1000) {
    await box.compact();
  }

  runApp(MyApp());
}
```

### 6. Handle Errors

```dart
Future<void> saveData() async {
  try {
    final box = Hive.box('myBox');
    await box.put('key', 'value');
  } catch (e) {
    print('Error saving data: $e');
    // Handle error (show snackbar, retry, etc.)
  }
}
```

### 7. Migrations (Changing Structure)

```dart
// Old version
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;
}

// New version (added email)
@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)  // New field
  String? email;  // Make nullable for old data
}

// Migration function
Future<void> migrateUsers() async {
  final box = Hive.box<User>('users');

  for (var user in box.values) {
    if (user.email == null) {
      user.email = 'default@example.com';
      await user.save();
    }
  }
}
```

## Exercises

### Exercise 1: Favorites System (Beginner)

Create a favorites system where users can favorite items and view them later.

**Requirements:**
- List of items (movies, books, or products)
- Heart icon to favorite/unfavorite
- Separate screen showing only favorites
- Persist favorites using Hive

**Hints:**
```dart
// Store list of favorite IDs
final favBox = await Hive.openBox('favorites');
favBox.put('movieIds', [1, 5, 8, 12]);

// Check if favorited
final favIds = favBox.get('movieIds', defaultValue: []);
final isFavorited = favIds.contains(movieId);
```

### Exercise 2: Notes App with Categories (Beginner-Intermediate)

Build a notes app with categories.

**Requirements:**
- Create notes with title, content, and category
- Categories: Personal, Work, Ideas, Other
- Filter notes by category
- Search notes by title
- Delete notes
- Use TypeAdapter for Note model

**Model:**
```dart
@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime createdAt;
}
```

### Exercise 3: Shopping List with Quantities (Intermediate)

Create a shopping list app with item quantities.

**Requirements:**
- Add items with name, quantity, and unit (kg, pcs, liters)
- Increase/decrease quantity with + and - buttons
- Mark items as purchased (checkbox)
- Show total items count
- Clear all purchased items
- Persist using Hive

**Model:**
```dart
@HiveType(typeId: 0)
class ShoppingItem {
  @HiveField(0)
  String name;

  @HiveField(1)
  double quantity;

  @HiveField(2)
  String unit;  // 'kg', 'pcs', 'liters'

  @HiveField(3)
  bool isPurchased;
}
```

### Exercise 4: Expense Tracker with Categories (Intermediate-Advanced)

Build an expense tracker with multiple categories and statistics.

**Requirements:**
- Add expenses with amount, category, date, and note
- Categories: Food, Transport, Entertainment, Bills, Other
- Show total expenses
- Show expenses by category (pie chart or percentages)
- Filter by date range
- Edit and delete expenses
- Use lazy box if > 100 expenses

**Models:**
```dart
@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String category;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String? note;
}

// Statistics helper
class ExpenseStats {
  final box = Hive.box<Expense>('expenses');

  double get totalExpenses {
    return box.values.fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final Map<String, double> result = {};

    for (var expense in box.values) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }

    return result;
  }
}
```

### Exercise 5: Offline-First Blog Reader (Advanced)

Create a blog reader app that caches articles for offline reading.

**Requirements:**
- Fetch articles from API
- Cache articles in Hive
- Show cached articles when offline
- Sync with API when online
- Mark articles as read
- Favorite articles
- Search cached articles
- Delete old articles (keep only recent 50)

**Models:**
```dart
@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String author;

  @HiveField(4)
  DateTime publishedAt;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  bool isFavorited;
}

class ArticleService {
  final apiBox = Hive.lazyBox<Article>('articles');

  Future<List<Article>> getArticles() async {
    try {
      // Try fetching from API
      final articles = await fetchFromAPI();

      // Cache articles
      for (var article in articles) {
        await apiBox.put(article.id, article);
      }

      return articles;
    } catch (e) {
      // Offline - return cached articles
      final cachedArticles = <Article>[];
      for (var key in apiBox.keys) {
        final article = await apiBox.get(key);
        if (article != null) cachedArticles.add(article);
      }
      return cachedArticles;
    }
  }

  Future<void> cleanOldArticles() async {
    if (apiBox.length > 50) {
      final keysToDelete = apiBox.keys.skip(50);
      await apiBox.deleteAll(keysToDelete);
    }
  }
}
```

## What You've Learned

✅ What Hive is and when to use it vs SQLite/SharedPreferences
✅ Setting up Hive in Flutter
✅ Basic CRUD operations with primitive types
✅ Creating custom Type Adapters (manual and code generation)
✅ Complete CRUD with custom objects
✅ Lazy boxes for large datasets
✅ Encryption with HiveAES
✅ ValueListenableBuilder for automatic UI updates
✅ Best practices (closing boxes, compacting, migrations)
✅ Real-world examples (todos, settings, caching)

## Next Steps

In the next lesson, we'll explore:
- **Drift (formerly Moor)** - Type-safe SQL database
- Reactive queries that auto-update
- Migrations and relationships
- Combining the power of SQL with Dart's type safety

You're mastering local storage! 🚀
