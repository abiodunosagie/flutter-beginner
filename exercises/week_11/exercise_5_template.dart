// Week 11, Exercise 5: Todo App with Bloc and Async Operations
// Difficulty: Advanced
//
// Instructions:
// 1. Create Todo model
// 2. Create TodoEvent classes: LoadTodos, AddTodo, ToggleTodo, DeleteTodo, ClearCompleted
// 3. Create TodoState classes: TodoInitial, TodoLoading, TodoLoaded, TodoError
// 4. Create TodoBloc with async operations (simulate API delay)
// 5. Implement event handlers with loading states
// 6. Build UI that handles all states (initial, loading, loaded, error)
// 7. Add statistics display (total, active, completed)
//
// Learning objectives:
// - Async operations in Bloc
// - Multiple state types
// - Loading and error states
// - Complex event handling
//
// TODO: Import necessary packages

void main() {
  runApp(MyApp());
}

// TODO: Create Todo model

// TODO: Create TodoEvent abstract class and concrete events
abstract class TodoEvent {}

// TODO: Create TodoState abstract class and concrete states
abstract class TodoState extends Equatable {}

// TODO: Create TodoBloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  // Initialize with TodoInitial
  // TODO: Register event handlers
  // TODO: Implement handlers with async/await and delays
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
    // TODO: Use BlocBuilder to handle different states
    // TODO: Show loading spinner for TodoLoading
    // TODO: Show error message for TodoError
    // TODO: Show todo list for TodoLoaded
    // TODO: Add statistics section

    return Scaffold(
      appBar: AppBar(title: Text('Todo Bloc')),
      body: Container(),
    );
  }
}
