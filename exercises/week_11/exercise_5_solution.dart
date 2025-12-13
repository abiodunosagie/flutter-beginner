// Week 11, Exercise 5: Todo App with Bloc and Async Operations
// Difficulty: Advanced
// Solution

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

void main() {
  runApp(MyApp());
}

// Todo model
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// TodoEvent abstract class and concrete events
abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}

class ClearCompleted extends TodoEvent {}

// TodoState abstract class and concrete states
abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded(this.todos);

  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get activeCount => todos.length - completedCount;

  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);

  @override
  List<Object> get props => [message];
}

// TodoBloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<Todo> _todos = [];

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ClearCompleted>(_onClearCompleted);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Load some sample todos
      _todos = [
        Todo(id: '1', title: 'Learn Flutter', isCompleted: true),
        Todo(id: '2', title: 'Learn Bloc', isCompleted: false),
        Todo(id: '3', title: 'Build an app', isCompleted: false),
      ];

      emit(TodoLoaded(_todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) async {
    if (event.title.trim().isEmpty) return;

    emit(TodoLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      final newTodo = Todo(
        id: DateTime.now().toString(),
        title: event.title.trim(),
      );

      _todos = [..._todos, newTodo];
      emit(TodoLoaded(_todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodo event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));

      _todos = _todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(isCompleted: !todo.isCompleted);
        }
        return todo;
      }).toList();

      emit(TodoLoaded(_todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));

      _todos = _todos.where((todo) => todo.id != event.id).toList();
      emit(TodoLoaded(_todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onClearCompleted(
    ClearCompleted event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      _todos = _todos.where((todo) => !todo.isCompleted).toList();
      emit(TodoLoaded(_todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Bloc Advanced',
      home: BlocProvider(
        create: (context) => TodoBloc()..add(LoadTodos()),
        child: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Bloc'),
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoaded && state.completedCount > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(ClearCompleted());
                  },
                  child: Text(
                    'Clear Completed',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            return Center(
              child: Text('Press the button to load todos'),
            );
          } else if (state is TodoLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(LoadTodos());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is TodoLoaded) {
            return Column(
              children: [
                // Input section
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter a new todo',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            context.read<TodoBloc>().add(AddTodo(value));
                            _controller.clear();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TodoBloc>().add(AddTodo(_controller.text));
                          _controller.clear();
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // Statistics
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem('Total', state.totalCount, Colors.blue),
                      _StatItem('Active', state.activeCount, Colors.orange),
                      _StatItem('Completed', state.completedCount, Colors.green),
                    ],
                  ),
                ),

                // Todo list
                Expanded(
                  child: state.todos.isEmpty
                      ? Center(
                          child: Text(
                            'No todos yet!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.todos.length,
                          itemBuilder: (context, index) {
                            final todo = state.todos[index];

                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (_) {
                                    context.read<TodoBloc>().add(ToggleTodo(todo.id));
                                  },
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: todo.isCompleted ? Colors.grey : Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    context.read<TodoBloc>().add(DeleteTodo(todo.id));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
