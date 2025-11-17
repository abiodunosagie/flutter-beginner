// Week 12, Exercise 4: Notes App with Hive (Full CRUD)
// Difficulty: Intermediate-Advanced
//
// Instructions:
// 1. Create Note model with: id, title, content, createdAt, updatedAt
// 2. Use Hive to persist notes
// 3. Create NotesNotifier with full CRUD operations:
//    - createNote, readNotes, updateNote, deleteNote
// 4. Build UI with:
//    - List of notes with search/filter
//    - Add note screen
//    - Edit note screen
//    - Delete confirmation dialog
// 5. Implement search functionality
// 6. Show creation and update timestamps
//
// Learning objectives:
// - Full CRUD with Hive
// - Navigation between screens
// - Search/filter functionality
// - Complex state management with persistence
//
// TODO: Import necessary packages

void main() async {
  // TODO: Initialize Hive
  // TODO: Open notes box
  // TODO: Run app
}

// TODO: Create Note model
class Note {
  // Fields: id, title, content, createdAt, updatedAt
  // TODO: Add toJson and fromJson methods
}

// TODO: Create NotesNotifier
class NotesNotifier extends StateNotifier<List<Note>> {
  // TODO: Use Hive box
  // TODO: Implement CRUD methods
}

// TODO: Create searchProvider for filtering notes

// TODO: Create providers

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: NotesListScreen(),
    );
  }
}

// TODO: Create NotesListScreen with search
// TODO: Create AddNoteScreen
// TODO: Create EditNoteScreen
