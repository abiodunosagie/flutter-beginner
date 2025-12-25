// ============================================
// EXAMPLE 01: CLEAN ARCHITECTURE PROJECT
// Complete example of a professional Flutter app
// ============================================

/*
  This file demonstrates a complete Clean Architecture
  implementation for a simple "Notes" feature.

  FOLDER STRUCTURE:
  lib/
  ├── core/
  │   ├── error/
  │   │   ├── exceptions.dart
  │   │   └── failures.dart
  │   └── usecases/
  │       └── usecase.dart
  │
  ├── features/
  │   └── notes/
  │       ├── data/
  │       │   ├── datasources/
  │       │   │   └── notes_local_datasource.dart
  │       │   ├── models/
  │       │   │   └── note_model.dart
  │       │   └── repositories/
  │       │       └── notes_repository_impl.dart
  │       │
  │       ├── domain/
  │       │   ├── entities/
  │       │   │   └── note.dart
  │       │   ├── repositories/
  │       │   │   └── notes_repository.dart
  │       │   └── usecases/
  │       │       ├── get_all_notes.dart
  │       │       ├── get_note.dart
  │       │       ├── add_note.dart
  │       │       └── delete_note.dart
  │       │
  │       └── presentation/
  │           ├── controllers/
  │           │   └── notes_controller.dart
  │           ├── pages/
  │           │   ├── notes_list_page.dart
  │           │   └── note_detail_page.dart
  │           └── widgets/
  │               └── note_card.dart
  │
  └── injection_container.dart

  NOTE: Copy these into separate files in a real project!
*/

// ============================================
// CORE - ERROR HANDLING
// ============================================

// core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}

// core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Something went wrong']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Could not load data']) : super(message);
}

// ============================================
// CORE - USE CASE BASE
// ============================================

// core/usecases/usecase.dart
/*
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
*/

// ============================================
// DOMAIN LAYER - ENTITY
// ============================================

// features/notes/domain/entities/note.dart
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Business logic methods
  bool get isEmpty => title.isEmpty && content.isEmpty;
  bool get isRecent =>
      DateTime.now().difference(createdAt).inDays < 7;

  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// ============================================
// DOMAIN LAYER - REPOSITORY INTERFACE
// ============================================

// features/notes/domain/repositories/notes_repository.dart
/*
import 'package:dartz/dartz.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getAllNotes();
  Future<Either<Failure, Note>> getNote(String id);
  Future<Either<Failure, Note>> addNote(Note note);
  Future<Either<Failure, Note>> updateNote(Note note);
  Future<Either<Failure, void>> deleteNote(String id);
}
*/

// ============================================
// DOMAIN LAYER - USE CASES
// ============================================

// features/notes/domain/usecases/get_all_notes.dart
/*
class GetAllNotesUseCase implements UseCase<List<Note>, NoParams> {
  final NotesRepository repository;

  GetAllNotesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) {
    return repository.getAllNotes();
  }
}
*/

// features/notes/domain/usecases/get_note.dart
/*
class GetNoteUseCase implements UseCase<Note, String> {
  final NotesRepository repository;

  GetNoteUseCase(this.repository);

  @override
  Future<Either<Failure, Note>> call(String id) {
    return repository.getNote(id);
  }
}
*/

// features/notes/domain/usecases/add_note.dart
/*
class AddNoteParams {
  final String title;
  final String content;

  AddNoteParams({required this.title, required this.content});
}

class AddNoteUseCase implements UseCase<Note, AddNoteParams> {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  @override
  Future<Either<Failure, Note>> call(AddNoteParams params) {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.title,
      content: params.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return repository.addNote(note);
  }
}
*/

// features/notes/domain/usecases/delete_note.dart
/*
class DeleteNoteUseCase implements UseCase<void, String> {
  final NotesRepository repository;

  DeleteNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteNote(id);
  }
}
*/

// ============================================
// DATA LAYER - MODEL
// ============================================

// features/notes/data/models/note_model.dart
/*
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON (for API/database)
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  // Convert to Entity
  Note toEntity() => Note(
    id: id,
    title: title,
    content: content,
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );

  // Create from Entity
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt.toIso8601String(),
      updatedAt: note.updatedAt.toIso8601String(),
    );
  }
}
*/

// ============================================
// DATA LAYER - DATA SOURCE
// ============================================

// features/notes/data/datasources/notes_local_datasource.dart
/*
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel> getNote(String id);
  Future<void> cacheNote(NoteModel note);
  Future<void> cacheNotes(List<NoteModel> notes);
  Future<void> deleteNote(String id);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedNotesKey = 'CACHED_NOTES';

  NotesLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final jsonString = sharedPreferences.getString(cachedNotesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => NoteModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<NoteModel> getNote(String id) async {
    final notes = await getAllNotes();
    final note = notes.firstWhere(
      (n) => n.id == id,
      orElse: () => throw CacheException('Note not found'),
    );
    return note;
  }

  @override
  Future<void> cacheNote(NoteModel note) async {
    final notes = await getAllNotes();
    final index = notes.indexWhere((n) => n.id == note.id);

    if (index >= 0) {
      notes[index] = note;
    } else {
      notes.add(note);
    }

    await cacheNotes(notes);
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    final jsonList = notes.map((n) => n.toJson()).toList();
    await sharedPreferences.setString(cachedNotesKey, jsonEncode(jsonList));
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = await getAllNotes();
    notes.removeWhere((n) => n.id == id);
    await cacheNotes(notes);
  }
}
*/

// ============================================
// DATA LAYER - REPOSITORY IMPLEMENTATION
// ============================================

// features/notes/data/repositories/notes_repository_impl.dart
/*
import 'package:dartz/dartz.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final models = await localDataSource.getAllNotes();
      final notes = models.map((m) => m.toEntity()).toList();
      // Sort by most recent first
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return Right(notes);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> getNote(String id) async {
    try {
      final model = await localDataSource.getNote(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> addNote(Note note) async {
    try {
      final model = NoteModel.fromEntity(note);
      await localDataSource.cacheNote(model);
      return Right(note);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final model = NoteModel.fromEntity(note);
      await localDataSource.cacheNote(model);
      return Right(note);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
*/

// ============================================
// PRESENTATION LAYER - CONTROLLER
// ============================================

// features/notes/presentation/controllers/notes_controller.dart
/*
import 'package:flutter/foundation.dart';

enum NotesStatus { initial, loading, success, error }

class NotesController extends ChangeNotifier {
  final GetAllNotesUseCase getAllNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesController({
    required this.getAllNotesUseCase,
    required this.addNoteUseCase,
    required this.deleteNoteUseCase,
  });

  NotesStatus _status = NotesStatus.initial;
  List<Note> _notes = [];
  String? _errorMessage;

  NotesStatus get status => _status;
  List<Note> get notes => _notes;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes() async {
    _status = NotesStatus.loading;
    notifyListeners();

    final result = await getAllNotesUseCase(NoParams());

    result.fold(
      (failure) {
        _status = NotesStatus.error;
        _errorMessage = failure.message;
      },
      (notes) {
        _status = NotesStatus.success;
        _notes = notes;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  Future<bool> addNote(String title, String content) async {
    final result = await addNoteUseCase(
      AddNoteParams(title: title, content: content),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (note) {
        _notes.insert(0, note);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteNote(String id) async {
    final result = await deleteNoteUseCase(id);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _notes.removeWhere((n) => n.id == id);
        notifyListeners();
        return true;
      },
    );
  }
}
*/

// ============================================
// PRESENTATION LAYER - PAGES
// ============================================

// features/notes/presentation/pages/notes_list_page.dart
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  @override
  void initState() {
    super.initState();
    // Load notes when page opens
    Future.microtask(() {
      context.read<NotesController>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: Consumer<NotesController>(
        builder: (context, controller, child) {
          switch (controller.status) {
            case NotesStatus.initial:
            case NotesStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case NotesStatus.error:
              return _ErrorView(
                message: controller.errorMessage ?? 'Unknown error',
                onRetry: controller.loadNotes,
              );

            case NotesStatus.success:
              if (controller.notes.isEmpty) {
                return const _EmptyView();
              }
              return _NotesList(notes: controller.notes);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddNoteSheet(),
    );
  }
}

class _NotesList extends StatelessWidget {
  final List<Note> notes;

  const _NotesList({required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(note: notes[index]);
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          const Text('Tap + to create your first note'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
*/

// ============================================
// PRESENTATION LAYER - WIDGETS
// ============================================

// features/notes/presentation/widgets/note_card.dart
/*
class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<NotesController>().deleteNote(note.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(
            note.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                _formatDate(note.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoteDetailPage(note: note),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
*/

// ============================================
// DEPENDENCY INJECTION
// ============================================

// injection_container.dart
/*
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //! Data sources
  sl.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSourceImpl(sl()),
  );

  //! Repository
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(sl()),
  );

  //! Use cases
  sl.registerLazySingleton(() => GetAllNotesUseCase(sl()));
  sl.registerLazySingleton(() => GetNoteUseCase(sl()));
  sl.registerLazySingleton(() => AddNoteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(sl()));

  //! Controller
  sl.registerFactory(
    () => NotesController(
      getAllNotesUseCase: sl(),
      addNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
    ),
  );
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<NotesController>(),
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const NotesListPage(),
      ),
    );
  }
}
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │            CLEAN ARCHITECTURE STRUCTURE                     │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  PRESENTATION LAYER:                                         │
  │  ├── NotesListPage, NoteDetailPage (UI)                     │
  │  ├── NoteCard, AddNoteSheet (Widgets)                       │
  │  └── NotesController (State Management)                     │
  │                      │                                       │
  │                      ▼                                       │
  │  DOMAIN LAYER:                                               │
  │  ├── Note (Entity - pure business object)                  │
  │  ├── NotesRepository (Interface/Contract)                  │
  │  └── Use Cases (GetAllNotes, AddNote, DeleteNote)          │
  │                      │                                       │
  │                      ▼                                       │
  │  DATA LAYER:                                                 │
  │  ├── NoteModel (JSON serialization)                        │
  │  ├── NotesLocalDataSource (SharedPreferences)              │
  │  └── NotesRepositoryImpl (Implementation)                  │
  │                                                              │
  │  DEPENDENCY INJECTION:                                       │
  │  └── GetIt service locator wires everything together       │
  │                                                              │
  │  KEY BENEFITS:                                               │
  │  ✅ Testable: Mock any layer independently                  │
  │  ✅ Maintainable: Clear separation of concerns              │
  │  ✅ Scalable: Easy to add features                          │
  │  ✅ Flexible: Swap implementations easily                   │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
