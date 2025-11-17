/// Exercise 2 Solution: SQLite Database - Todo App

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Todo {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  Todo({this.id, required this.title, required this.description, this.completed = false, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description, 'completed': completed ? 1 : 0, 'createdAt': createdAt.toIso8601String()};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(id: map['id'], title: map['title'], description: map['description'], completed: map['completed'] == 1, createdAt: DateTime.parse(map['createdAt']));
  }
}

class TodoDatabase {
  Database? _database;

  Future<void> init() async {
    _database = await openDatabase(join(await getDatabasesPath(), 'todos.db'), version: 1, onCreate: (db, version) {
      return db.execute('CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, completed INTEGER, createdAt TEXT)');
    });
  }

  Future<int> insertTodo(Todo todo) async {
    return await _database!.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database!.query('todos');
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  Future<int> updateTodo(Todo todo) async {
    return await _database!.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    return await _database!.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
