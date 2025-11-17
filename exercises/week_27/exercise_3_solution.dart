/// Week 27, Exercise 3: Firestore CRUD - Notes App
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: NotesScreen(),
    );
  }
}

class Note {
  final String? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }
}

class NotesService {
  // In real app: final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  NotesService(this.userId);

  // Mock data for demo
  final List<Note> _mockNotes = [
    Note(id: '1', title: 'Welcome', content: 'This is a demo note app'),
    Note(id: '2', title: 'Flutter', content: 'Building with Flutter and Firestore'),
  ];

  Future<String> addNote(Note note) async {
    // await _db.collection('users').doc(userId).collection('notes').add(note.toMap());
    await Future.delayed(Duration(milliseconds: 500));
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _mockNotes.add(Note(
      id: id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
    ));
    return id;
  }

  Stream<List<Note>> watchNotes() {
    // return _db
    //     .collection('users')
    //     .doc(userId)
    //     .collection('notes')
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => Note.fromMap(doc.id, doc.data())).toList());

    // Mock stream for demo
    return Stream.periodic(Duration(milliseconds: 100), (_) => List<Note>.from(_mockNotes));
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    // await _db.collection('users').doc(userId).collection('notes').doc(noteId).update({
    //   'title': title,
    //   'content': content,
    // });
    await Future.delayed(Duration(milliseconds: 300));
    final index = _mockNotes.indexWhere((n) => n.id == noteId);
    if (index >= 0) {
      _mockNotes[index] = Note(
        id: noteId,
        title: title,
        content: content,
        createdAt: _mockNotes[index].createdAt,
      );
    }
  }

  Future<void> deleteNote(String noteId) async {
    // await _db.collection('users').doc(userId).collection('notes').doc(noteId).delete();
    await Future.delayed(Duration(milliseconds: 300));
    _mockNotes.removeWhere((n) => n.id == noteId);
  }
}

class NotesScreen extends StatelessWidget {
  final String userId = 'demo_user';

  @override
  Widget build(BuildContext context) {
    final notesService = NotesService(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Note>>(
        stream: notesService.watchNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text('Tap + to create your first note'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatDate(note.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(context, notesService, note);
                      } else if (value == 'delete') {
                        _deleteNote(context, notesService, note);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, notesService),
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddDialog(BuildContext context, NotesService service) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                await service.addNote(Note(
                  title: titleController.text,
                  content: contentController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, NotesService service, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                await service.updateNote(
                  note.id!,
                  titleController.text,
                  contentController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(BuildContext context, NotesService service, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await service.deleteNote(note.id!);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
