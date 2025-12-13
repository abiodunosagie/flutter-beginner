/// Exercise 3 Solution: Hive NoSQL - Notes App

import 'package:hive/hive.dart';
import 'dart:convert';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  List<String> tags;

  Note({String? id, required this.title, required this.content, required this.createdAt, this.tags = const []})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content, 'createdAt': createdAt.toIso8601String(), 'tags': tags};
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(id: json['id'], title: json['title'], content: json['content'], createdAt: DateTime.parse(json['createdAt']), tags: List<String>.from(json['tags']));
  }
}

class NotesRepository {
  late Box<String> _notesBox;

  Future<void> init() async {
    _notesBox = await Hive.openBox<String>('notes');
  }

  Future<void> addNote(Note note) async {
    await _notesBox.put(note.id, jsonEncode(note.toJson()));
  }

  List<Note> getAllNotes() {
    return _notesBox.values.map((json) => Note.fromJson(jsonDecode(json))).toList();
  }

  Future<void> updateNote(Note note) async {
    await _notesBox.put(note.id, jsonEncode(note.toJson()));
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  List<Note> searchNotes(String query) {
    final allNotes = getAllNotes();
    return allNotes.where((note) => note.title.toLowerCase().contains(query.toLowerCase()) || note.content.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
