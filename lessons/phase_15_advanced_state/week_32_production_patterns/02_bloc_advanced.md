# BLoC Advanced Patterns

## Complex Event/State Handling

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}
class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

// States
abstract class TodoState {}

class TodoInitial extends TodoState {}
class TodoLoading extends TodoState {}
class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);
}
class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}

// BLoC
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentTodos = (state as TodoLoaded).todos;
      final newTodo = Todo(title: event.title);
      emit(TodoLoaded([...currentTodos, newTodo]));

      try {
        await repository.addTodo(newTodo);
      } catch (e) {
        emit(TodoLoaded(currentTodos));  // Revert on error
      }
    }
  }
}
```

Master BLoC patterns! 🚀
