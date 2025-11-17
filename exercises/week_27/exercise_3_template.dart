/// Week 27, Exercise 3: Firestore CRUD - Notes App
///
/// INTERMEDIATE LEVEL
///
/// Create a notes app with Firestore:
/// 1. Add cloud_firestore package
/// 2. Create Note model with toMap/fromFirestore methods
/// 3. Implement CREATE - add new notes
/// 4. Implement READ - fetch and display notes in real-time
/// 5. Implement UPDATE - edit existing notes
/// 6. Implement DELETE - remove notes
/// 7. Use StreamBuilder for real-time updates
/// 8. Handle loading and error states
///
/// Learning objectives:
/// - CRUD operations with Firestore
/// - Real-time data with StreamBuilder
/// - Data modeling for Firestore

import 'package:flutter/material.dart';
// TODO: Add cloud_firestore to pubspec.yaml
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // TODO: Initialize Firebase
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: NotesScreen(),
    );
  }
}

// TODO: Create Note model class
// class Note {
//   final String? id;
//   final String title;
//   final String content;
//   final DateTime createdAt;
//
//   Note({
//     this.id,
//     required this.title,
//     required this.content,
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();
//
//   Map<String, dynamic> toMap() {
//     // TODO: Convert Note to Map for Firestore
//   }
//
//   factory Note.fromFirestore(DocumentSnapshot doc) {
//     // TODO: Create Note from Firestore document
//   }
// }

// TODO: Create NotesService class
// class NotesService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final String userId;
//
//   NotesService(this.userId);
//
//   CollectionReference get _notesRef =>
//       _db.collection('users').doc(userId).collection('notes');
//
//   // TODO: CREATE - Add note
//   Future<String> addNote(Note note) async {}
//
//   // TODO: READ - Watch notes (Stream)
//   Stream<List<Note>> watchNotes() {}
//
//   // TODO: UPDATE - Update note
//   Future<void> updateNote(String noteId, String title, String content) async {}
//
//   // TODO: DELETE - Delete note
//   Future<void> deleteNote(String noteId) async {}
// }

class NotesScreen extends StatelessWidget {
  // For demo, use a dummy user ID
  final String userId = 'demo_user';

  @override
  Widget build(BuildContext context) {
    // TODO: Create NotesService instance

    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: StreamBuilder(
        // TODO: Use StreamBuilder with notesService.watchNotes()
        stream: null,
        builder: (context, snapshot) {
          // TODO: Handle loading state

          // TODO: Handle error state

          // TODO: Handle empty state

          // TODO: Display notes in ListView
          return Center(child: Text('Add TODO'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show add note dialog
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// TODO: Create AddNoteDialog widget
// - Show dialog with title and content fields
// - Save note to Firestore on submit

// TODO: Create EditNoteDialog widget
// - Pre-fill with existing note data
// - Update note in Firestore on submit
