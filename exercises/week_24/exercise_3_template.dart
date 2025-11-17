/// Exercise 3: Hive NoSQL - Notes App
/// Create a Notes app using Hive for fast NoSQL storage

// TODO: Define Note model with HiveObject
// TODO: Create NotesRepository with CRUD operations
// TODO: Implement search and filter functionality

class Note {
  String? id;
  String title;
  String content;
  DateTime createdAt;
  List<String> tags;

  Note({this.id, required this.title, required this.content, required this.createdAt, this.tags = const []});
}

class NotesRepository {
  Future<void> init() async => throw UnimplementedError();
  Future<void> addNote(Note note) async => throw UnimplementedError();
  List<Note> getAllNotes() => throw UnimplementedError();
  Future<void> updateNote(Note note) async => throw UnimplementedError();
  Future<void> deleteNote(String id) async => throw UnimplementedError();
  List<Note> searchNotes(String query) => throw UnimplementedError();
}
