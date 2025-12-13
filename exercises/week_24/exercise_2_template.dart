/// Exercise 2: SQLite Database - Todo App
/// Create a Todo database with full CRUD operations using sqflite

import 'package:sqflite/sqflite.dart';

class Todo {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  Todo({this.id, required this.title, required this.description, this.completed = false, required this.createdAt});

  Map<String, dynamic> toMap() => throw UnimplementedError();
  factory Todo.fromMap(Map<String, dynamic> map) => throw UnimplementedError();
}

class TodoDatabase {
  Database? _database;

  Future<void> init() async => throw UnimplementedError();
  Future<int> insertTodo(Todo todo) async => throw UnimplementedError();
  Future<List<Todo>> getTodos() async => throw UnimplementedError();
  Future<int> updateTodo(Todo todo) async => throw UnimplementedError();
  Future<int> deleteTodo(int id) async => throw UnimplementedError();
}
