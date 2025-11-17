// Week 11, Exercise 2: Todo App with Riverpod StateNotifierProvider
// Difficulty: Beginner-Intermediate
//
// Instructions:
// 1. Create a Todo model class with id, title, and isCompleted
// 2. Create a TodosNotifier extending StateNotifier<List<Todo>>
// 3. Implement methods: addTodo, toggleTodo, deleteTodo
// 4. Create a StateNotifierProvider for TodosNotifier
// 5. Build a UI that displays todos and allows adding/toggling/deleting
//
// Learning objectives:
// - Understanding StateNotifier
// - Working with complex state
// - Immutable state updates
//
// TODO: Import necessary packages

void main() {
  // TODO: Wrap with ProviderScope
  runApp(MyApp());
}

// TODO: Create Todo model class
class Todo {
  // Add fields: id, title, isCompleted
  // Add constructor
  // Add copyWith method for immutability
}

// TODO: Create TodosNotifier extending StateNotifier<List<Todo>>
class TodosNotifier extends StateNotifier<List<Todo>> {
  // Initialize with empty list
  // TODO: Add methods:
  // - addTodo(String title)
  // - toggleTodo(String id)
  // - deleteTodo(String id)
}

// TODO: Create StateNotifierProvider
// final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>(...);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App with Riverpod',
      home: TodoScreen(),
    );
  }
}

// TODO: Convert to ConsumerWidget
class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Watch the todos provider
    // TODO: Build UI with:
    // - TextField to add new todos
    // - ListView to display todos
    // - Checkbox to toggle completion
    // - Delete button for each todo

    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          // TODO: Add input section
          // TODO: Add todo list
        ],
      ),
    );
  }
}
