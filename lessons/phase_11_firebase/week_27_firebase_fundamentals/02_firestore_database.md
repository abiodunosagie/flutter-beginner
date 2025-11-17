# Firestore Database: Complete CRUD Guide

## What You'll Learn

- Firestore setup and structure
- CRUD operations (Create, Read, Update, Delete)
- Real-time listeners
- Queries and filtering
- Pagination
- Transactions and batch writes
- Security rules
- Best practices

## Setup

```yaml
dependencies:
  cloud_firestore: ^4.13.6
```

## Firestore Structure

```
users (collection)
  ├─ userId1 (document)
  │   ├─ name: "John Doe"
  │   ├─ email: "john@example.com"
  │   └─ posts (subcollection)
  │       ├─ postId1 (document)
  │       │   ├─ title: "My First Post"
  │       │   └─ content: "Hello World"
  │       └─ postId2 (document)
  └─ userId2 (document)
```

## CREATE - Adding Documents

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add document with auto-generated ID
  Future<String> addUser(String name, String email) async {
    final docRef = await _db.collection('users').add({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Add document with specific ID
  Future<void> setUser(String userId, String name, String email) async {
    await _db.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Add with merge (update if exists, create if not)
  Future<void> setUserMerge(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(
      data,
      SetOptions(merge: true),
    );
  }
}
```

## READ - Fetching Documents

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get single document
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  // Get all documents in collection
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snapshot = await _db.collection('users').get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Real-time listener (Stream)
  Stream<List<Map<String, dynamic>>> watchUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    });
  }

  // Listen to single document
  Stream<Map<String, dynamic>?> watchUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    });
  }
}
```

## UPDATE - Modifying Documents

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Update specific fields
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _db.collection('users').doc(userId).update(updates);
  }

  // Update single field
  Future<void> updateUserName(String userId, String newName) async {
    await _db.collection('users').doc(userId).update({
      'name': newName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Increment counter
  Future<void> incrementLikes(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  // Add to array
  Future<void> addTag(String postId, String tag) async {
    await _db.collection('posts').doc(postId).update({
      'tags': FieldValue.arrayUnion([tag]),
    });
  }

  // Remove from array
  Future<void> removeTag(String postId, String tag) async {
    await _db.collection('posts').doc(postId).update({
      'tags': FieldValue.arrayRemove([tag]),
    });
  }
}
```

## DELETE - Removing Documents

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Delete document
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  // Delete field
  Future<void> deleteUserEmail(String userId) async {
    await _db.collection('users').doc(userId).update({
      'email': FieldValue.delete(),
    });
  }

  // Delete collection (must delete all documents)
  Future<void> deleteCollection(String collectionPath) async {
    final snapshot = await _db.collection(collectionPath).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
```

## Queries & Filtering

```dart
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simple where query
  Future<List<Map<String, dynamic>>> getUsersByName(String name) async {
    final snapshot = await _db
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Multiple conditions
  Future<List<Map<String, dynamic>>> getActiveAdults() async {
    final snapshot = await _db
        .collection('users')
        .where('age', isGreaterThanOrEqualTo: 18)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Ordering
  Future<List<Map<String, dynamic>>> getUsersOrderedByAge() async {
    final snapshot = await _db
        .collection('users')
        .orderBy('age', descending: true)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Limit results
  Future<List<Map<String, dynamic>>> getTopUsers(int limit) async {
    final snapshot = await _db
        .collection('users')
        .orderBy('points', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Pagination
  Future<List<Map<String, dynamic>>> getUsersPage({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async {
    var query = _db.collection('users')
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'doc': doc,  // Save for next page
      ...doc.data(),
    }).toList();
  }
}
```

## Real-World Example: Todo App

```dart
class Todo {
  final String? id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'],
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class TodoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  TodoService(this.userId);

  CollectionReference get _todosRef =>
      _db.collection('users').doc(userId).collection('todos');

  // CREATE
  Future<String> addTodo(Todo todo) async {
    final docRef = await _todosRef.add(todo.toMap());
    return docRef.id;
  }

  // READ
  Stream<List<Todo>> watchTodos() {
    return _todosRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromFirestore(doc))
          .toList();
    });
  }

  // UPDATE
  Future<void> toggleTodo(String todoId, bool isCompleted) async {
    await _todosRef.doc(todoId).update({
      'isCompleted': isCompleted,
    });
  }

  // DELETE
  Future<void> deleteTodo(String todoId) async {
    await _todosRef.doc(todoId).delete();
  }

  // Get completed count
  Future<int> getCompletedCount() async {
    final snapshot = await _todosRef
        .where('isCompleted', isEqualTo: true)
        .get();
    return snapshot.size;
  }
}

// UI
class TodoListScreen extends StatelessWidget {
  final String userId;

  TodoListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final todoService = TodoService(userId);

    return Scaffold(
      appBar: AppBar(title: Text('My Todos')),
      body: StreamBuilder<List<Todo>>(
        stream: todoService.watchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No todos yet!'));
          }

          final todos = snapshot.data!;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    todoService.toggleTodo(todo.id!, value!);
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => todoService.deleteTodo(todo.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, todoService),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, TodoService todoService) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter todo'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                todoService.addTodo(Todo(title: controller.text));
                Navigator.pop(context);
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

## Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Todos subcollection
      match /todos/{todoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Public posts (anyone can read, only owner can write)
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
                               resource.data.authorId == request.auth.uid;
    }
  }
}
```

## Best Practices

✅ Use StreamBuilder for real-time data
✅ Handle loading and error states
✅ Create model classes with toMap/fromFirestore
✅ Use subcollections for hierarchical data
✅ Implement pagination for large datasets
✅ Set proper security rules
✅ Use FieldValue.serverTimestamp() for timestamps
✅ Batch writes when updating multiple documents

## Exercises

### Exercise 1: Notes App (Beginner)
CRUD for notes with Firestore

### Exercise 2: Social Posts (Intermediate)
Posts with likes, comments, real-time updates

### Exercise 3: Chat App (Advanced)
Real-time chat with Firestore

You're mastering Firebase! 🚀
