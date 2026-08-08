import 'package:flutter/foundation.dart';

import '../models/note.dart';

class NotesController extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  void add(String title, String body) {
    _notes.insert(
      0,
      Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void remove(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
