# Cloud Firestore: Your Cloud Database

## The Simple Explanation

Firestore is like a giant, smart filing cabinet in the cloud:
- **Collections** = Folders (contain documents)
- **Documents** = Files (contain data)
- **Fields** = Information inside files

```
┌─────────────────────────────────────────────────────────┐
│                 FIRESTORE STRUCTURE                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  📁 users (Collection)                                   │
│  ├── 📄 user_123 (Document)                             │
│  │   ├── name: "John"                                   │
│  │   ├── email: "john@mail.com"                         │
│  │   └── age: 25                                        │
│  │                                                       │
│  └── 📄 user_456 (Document)                             │
│      ├── name: "Jane"                                   │
│      └── email: "jane@mail.com"                         │
│                                                          │
│  📁 tasks (Collection)                                   │
│  ├── 📄 task_001                                        │
│  │   ├── title: "Buy milk"                              │
│  │   └── done: false                                    │
│  │                                                       │
│  └── 📄 task_002                                        │
│      ├── title: "Call mom"                              │
│      └── done: true                                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Enable Firestore

### In Firebase Console:

1. Click **Firestore Database** in the left menu
2. Click **Create database**
3. Choose **Start in test mode** (for learning)
4. Select a location (choose closest to your users)

```
⚠️ TEST MODE WARNING:
Test mode allows anyone to read/write data.
Only use for development!
We'll learn about security rules later.
```

---

## Basic Firestore Operations

### Getting a Reference

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Get Firestore instance
final db = FirebaseFirestore.instance;

// Reference to a collection
final tasksCollection = db.collection('tasks');

// Reference to a specific document
final taskDoc = db.collection('tasks').doc('task_001');
```

---

## CRUD Operations

### CREATE - Add a Document

```dart
// Method 1: Auto-generated ID (recommended)
Future<void> addTask(String title) async {
  await FirebaseFirestore.instance.collection('tasks').add({
    'title': title,
    'completed': false,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// Method 2: Custom ID
Future<void> addTaskWithId(String id, String title) async {
  await FirebaseFirestore.instance.collection('tasks').doc(id).set({
    'title': title,
    'completed': false,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

### READ - Get Documents

```dart
// Get ALL documents in a collection
Future<List<Map<String, dynamic>>> getAllTasks() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('tasks')
      .get();

  return snapshot.docs.map((doc) {
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }).toList();
}

// Get ONE document by ID
Future<Map<String, dynamic>?> getTask(String id) async {
  final doc = await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .get();

  if (doc.exists) {
    return {
      'id': doc.id,
      ...doc.data()!,
    };
  }
  return null;
}
```

### UPDATE - Modify a Document

```dart
// Update specific fields
Future<void> updateTask(String id, String newTitle) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .update({
        'title': newTitle,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}

// Toggle completion
Future<void> toggleTask(String id, bool currentStatus) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .update({
        'completed': !currentStatus,
      });
}
```

### DELETE - Remove a Document

```dart
Future<void> deleteTask(String id) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .delete();
}
```

---

## Real-Time Updates (The Magic!)

The best part of Firestore: **data syncs automatically!**

```dart
// Listen to changes in real-time
Stream<QuerySnapshot> getTasksStream() {
  return FirebaseFirestore.instance
      .collection('tasks')
      .orderBy('createdAt', descending: true)
      .snapshots();
}
```

### Using StreamBuilder

```dart
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Handle loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle empty
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('No tasks yet!'));
        }

        // Show list
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['title']),
              leading: Checkbox(
                value: data['completed'] ?? false,
                onChanged: (value) {
                  doc.reference.update({'completed': value});
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => doc.reference.delete(),
              ),
            );
          },
        );
      },
    );
  }
}
```

```
REAL-TIME MAGIC:

User A adds task          User B sees it instantly!
       │                          │
       ▼                          ▼
   ┌───────┐                 ┌───────┐
   │ Phone │                 │ Phone │
   └───┬───┘                 └───┬───┘
       │                          │
       ▼                          ▼
   ┌──────────────────────────────────┐
   │         ☁️ FIRESTORE             │
   │     (data syncs to everyone)     │
   └──────────────────────────────────┘
```

---

## Queries (Filtering Data)

### Where Clauses

```dart
// Get only incomplete tasks
final incompleteTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .where('completed', isEqualTo: false)
    .get();

// Get tasks with specific user
final userTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .where('userId', isEqualTo: 'user_123')
    .get();

// Get recent tasks (last 7 days)
final recentTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .where('createdAt', isGreaterThan: DateTime.now().subtract(Duration(days: 7)))
    .get();
```

### Ordering

```dart
// Order by creation date (newest first)
final orderedTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .orderBy('createdAt', descending: true)
    .get();

// Order by title (alphabetically)
final alphabeticalTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .orderBy('title')
    .get();
```

### Limiting Results

```dart
// Get only first 10 tasks
final limitedTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .limit(10)
    .get();

// Combine: incomplete tasks, newest first, limit 5
final query = await FirebaseFirestore.instance
    .collection('tasks')
    .where('completed', isEqualTo: false)
    .orderBy('createdAt', descending: true)
    .limit(5)
    .get();
```

---

## Complete Firestore Service

```dart
// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _tasksCollection => _db.collection('tasks');

  // CREATE
  Future<String> addTask({
    required String title,
    required String userId,
    String? description,
  }) async {
    final docRef = await _tasksCollection.add({
      'title': title,
      'description': description,
      'completed': false,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Stream for real-time updates
  Stream<List<Task>> getTasksStream(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Task.fromFirestore(doc);
          }).toList();
        });
  }

  // READ - One-time fetch
  Future<List<Task>> getTasks(String userId) async {
    final snapshot = await _tasksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return Task.fromFirestore(doc);
    }).toList();
  }

  // UPDATE
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _tasksCollection.doc(taskId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Toggle completion
  Future<void> toggleTask(String taskId, bool currentStatus) async {
    await _tasksCollection.doc(taskId).update({
      'completed': !currentStatus,
    });
  }

  // DELETE
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
```

---

## Task Model with Firestore

```dart
// models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final String userId;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.userId,
    required this.createdAt,
  });

  // Create from Firestore document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      completed: data['completed'] ?? false,
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy with changes
  Task copyWith({
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      userId: userId,
      createdAt: createdAt,
    );
  }
}
```

---

## Data Types in Firestore

```dart
// Firestore supports these types:
await collection.add({
  'string': 'Hello',              // String
  'number': 42,                   // Number (int)
  'decimal': 3.14,                // Number (double)
  'boolean': true,                // Boolean
  'timestamp': Timestamp.now(),   // Timestamp
  'geopoint': GeoPoint(37.7, -122.4), // GeoPoint
  'array': ['a', 'b', 'c'],       // Array
  'map': {'key': 'value'},        // Map
  'null': null,                   // Null
  'reference': doc.reference,     // DocumentReference
});

// Special values
await collection.add({
  'serverTime': FieldValue.serverTimestamp(), // Server timestamp
  'increment': FieldValue.increment(1),       // Increment number
  'arrayAdd': FieldValue.arrayUnion(['x']),   // Add to array
  'arrayRemove': FieldValue.arrayRemove(['x']), // Remove from array
});
```

---

## Security Rules (Important!)

After testing, secure your database:

```javascript
// In Firebase Console > Firestore > Rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own tasks
    match /tasks/{taskId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;

      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId;
    }

    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

---

## Common Patterns

### User-Specific Data

```dart
// Store user ID with each document
final userId = FirebaseAuth.instance.currentUser!.uid;

await FirebaseFirestore.instance.collection('tasks').add({
  'title': 'My task',
  'userId': userId,  // Associate with user
  'createdAt': FieldValue.serverTimestamp(),
});

// Query only user's data
final myTasks = await FirebaseFirestore.instance
    .collection('tasks')
    .where('userId', isEqualTo: userId)
    .get();
```

### Subcollections

```dart
// Organize data under users
// users/{userId}/tasks/{taskId}

final userId = FirebaseAuth.instance.currentUser!.uid;

// Add task to user's subcollection
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('tasks')
    .add({
      'title': 'My task',
      'createdAt': FieldValue.serverTimestamp(),
    });
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│               FIRESTORE SUMMARY                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  STRUCTURE                                               │
│  Collection → Document → Fields                          │
│                                                          │
│  CRUD OPERATIONS                                         │
│  ├── Create: collection.add() or doc.set()              │
│  ├── Read:   collection.get() or doc.get()              │
│  ├── Update: doc.update()                               │
│  └── Delete: doc.delete()                               │
│                                                          │
│  REAL-TIME                                               │
│  collection.snapshots() → Stream of changes             │
│  Use StreamBuilder in UI                                 │
│                                                          │
│  QUERIES                                                 │
│  ├── .where() - filter                                  │
│  ├── .orderBy() - sort                                  │
│  └── .limit() - limit results                           │
│                                                          │
│  SPECIAL VALUES                                          │
│  └── FieldValue.serverTimestamp()                       │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** `04-FirebaseStorage.md` - Uploading and downloading files
