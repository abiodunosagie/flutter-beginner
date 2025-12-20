// Example 02: Firestore CRUD Operations
// Create, Read, Update, Delete with Cloud Firestore

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore CRUD Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TASK MODEL
// ═══════════════════════════════════════════════════════════════

class Task {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// ═══════════════════════════════════════════════════════════════
// FIRESTORE SERVICE
// ═══════════════════════════════════════════════════════════════

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Reference to tasks collection
  CollectionReference get _tasksRef => _db.collection('tasks');

  // CREATE - Add a new task
  Future<String> addTask(String title, String? description) async {
    final docRef = await _tasksRef.add({
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // READ - Get all tasks as a stream (real-time)
  Stream<List<Task>> getTasksStream() {
    return _tasksRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    });
  }

  // READ - Get all tasks (one-time)
  Future<List<Task>> getTasks() async {
    final snapshot = await _tasksRef.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
  }

  // UPDATE - Update a task
  Future<void> updateTask(String id, {String? title, String? description}) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _tasksRef.doc(id).update(data);
  }

  // UPDATE - Toggle completion
  Future<void> toggleTask(String id, bool currentStatus) async {
    await _tasksRef.doc(id).update({
      'completed': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE - Remove a task
  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}

// ═══════════════════════════════════════════════════════════════
// TASK LIST SCREEN
// ═══════════════════════════════════════════════════════════════

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Task>>(
        // Real-time stream - UI updates automatically!
        stream: _firestoreService.getTasksStream(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          // Empty state
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first task',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Task list
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onToggle: () => _firestoreService.toggleTask(
                  task.id,
                  task.completed,
                ),
                onEdit: () => _showEditDialog(task),
                onDelete: () => _confirmDelete(task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add more details...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              await _firestoreService.addTask(
                title,
                descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task added!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(
      text: task.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              await _firestoreService.updateTask(
                task.id,
                title: title,
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task updated!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _firestoreService.deleteTask(task.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Task deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        // Recreate the task
                        _firestoreService.addTask(
                          task.title,
                          task.description,
                        );
                      },
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TASK CARD WIDGET
// ═══════════════════════════════════════════════════════════════

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : null,
          ),
        ),
        subtitle: task.description != null
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: task.completed ? Colors.grey : Colors.grey[600],
                ),
              )
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. CRUD Operations
 *    - CREATE: collection.add()
 *    - READ: collection.get() or collection.snapshots()
 *    - UPDATE: doc.update()
 *    - DELETE: doc.delete()
 *
 * 2. Real-time Updates
 *    - Using snapshots() for automatic updates
 *    - StreamBuilder to reflect changes
 *
 * 3. Data Conversion
 *    - Task.fromFirestore() - Convert document to model
 *    - task.toMap() - Convert model to Firestore data
 *
 * 4. Timestamps
 *    - FieldValue.serverTimestamp() for server time
 *    - Timestamp.fromDate() for local dates
 *
 * 5. Ordering & Queries
 *    - orderBy() to sort results
 *
 * ═══════════════════════════════════════════════════════════════
 * FIRESTORE STRUCTURE:
 * ═══════════════════════════════════════════════════════════════
 *
 * tasks (Collection)
 * ├── {taskId} (Document)
 * │   ├── title: "Buy groceries"
 * │   ├── description: "Milk, eggs, bread"
 * │   ├── completed: false
 * │   ├── createdAt: Timestamp
 * │   └── updatedAt: Timestamp (optional)
 *
 * ═══════════════════════════════════════════════════════════════
 */
