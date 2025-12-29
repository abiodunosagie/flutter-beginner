# Level 06: State Management Exercises

## How These Exercises Work

Each skill is broken into **small steps**. Complete each step before moving to the next. By the end, you'll combine everything!

```
THE PROGRESSIVE LEARNING PATH:

Step 1: Learn one tiny piece ──────────────► Practice it
Step 2: Learn next tiny piece ─────────────► Practice it
Step 3: Learn next tiny piece ─────────────► Practice it
...
Final: Combine ALL pieces ─────────────────► Build complete app!
```

---

# PART 1: PROVIDER BASICS

## Exercise 1.1: Create a ChangeNotifier

**Goal:** Create your first state class.

**Your Task:** Create a Counter class that holds a count value.

```dart
import 'package:flutter/material.dart';

// TODO: Create a class that extends ChangeNotifier
// It should have:
// - A private int _count = 0
// - A getter for count
// - A method increment() that increases _count

class Counter extends ChangeNotifier {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();  // This tells widgets to rebuild!
  }
}
```

</details>

---

## Exercise 1.2: Use notifyListeners

**Goal:** Understand when to notify listeners.

**Your Task:** Add decrement and reset methods. Call notifyListeners() in each.

```dart
class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  // TODO: Add decrement() - decrease by 1, don't go below 0
  // TODO: Add reset() - set to 0
  // Remember to call notifyListeners()!
}
```

<details>
<summary>✅ Solution</summary>

```dart
void decrement() {
  if (_count > 0) {
    _count--;
    notifyListeners();
  }
}

void reset() {
  _count = 0;
  notifyListeners();
}
```

</details>

---

## Exercise 1.3: Provide the State

**Goal:** Make state available to widgets.

**Your Task:** Wrap the app with ChangeNotifierProvider.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // TODO: Wrap MyApp with ChangeNotifierProvider
    // create: (_) => Counter()
    MyApp(),
  );
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MyApp(),
    ),
  );
}
```

</details>

---

## Exercise 1.4: Read State with context.watch

**Goal:** Display state in a widget.

**Your Task:** Use context.watch to get the counter value.

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get counter using context.watch<Counter>()
    // Display the count value

    return Text(
      '0',  // TODO: Replace with actual count
      style: TextStyle(fontSize: 48),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();

    return Text(
      '${counter.count}',
      style: TextStyle(fontSize: 48),
    );
  }
}
```

</details>

---

## Exercise 1.5: Update State with context.read

**Goal:** Call methods to change state.

**Your Task:** Use context.read to call increment when button is pressed.

```dart
class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Use context.read<Counter>() to call increment()
      },
      child: Text('+'),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();
  },
  child: Text('+'),
)
```

</details>

---

## Exercise 1.6: Provider Counter Challenge

**Goal:** Build a complete counter app WITHOUT looking at solutions.

**Requirements:**
- Display count (large text)
- "+" button to increment
- "-" button to decrement (min 0)
- "Reset" button
- Use Provider for all state

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// State
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

// App
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MaterialApp(
        home: CounterPage(),
      ),
    ),
  );
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();

    return Scaffold(
      appBar: AppBar(title: Text('Provider Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${counter.count}',
              style: TextStyle(fontSize: 72),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<Counter>().decrement(),
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().increment(),
                  child: Text('+'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => context.read<Counter>().reset(),
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

</details>

---

# PART 2: PROVIDER WITH COMPLEX STATE

## Exercise 2.1: Create a Model Class

**Goal:** Define a data model for your state.

**Your Task:** Create a Product model.

```dart
// TODO: Create Product class with:
// - id (String)
// - name (String)
// - price (double)
// - All required in constructor

class Product {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
```

</details>

---

## Exercise 2.2: State with a List

**Goal:** Manage a list of items in state.

**Your Task:** Create CartProvider that holds a list of products.

```dart
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  // TODO: Add getter for items (return unmodifiable list)
  // TODO: Add getter for itemCount
  // TODO: Add getter for totalPrice

  List<Product> get items => ???
  int get itemCount => ???
  double get totalPrice => ???
}
```

<details>
<summary>✅ Solution</summary>

```dart
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);
}
```

</details>

---

## Exercise 2.3: Add Item to List

**Goal:** Add items to state.

**Your Task:** Add a method to add products to the cart.

```dart
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  // ... getters ...

  // TODO: Add addItem method
  // - Takes a Product
  // - Adds to _items
  // - Calls notifyListeners()

  void addItem(Product product) {
    // Your code here...
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
void addItem(Product product) {
  _items.add(product);
  notifyListeners();
}
```

</details>

---

## Exercise 2.4: Remove Item from List

**Goal:** Remove items from state.

**Your Task:** Add a method to remove products from the cart.

```dart
// TODO: Add removeItem method
// - Takes product id (String)
// - Removes from _items
// - Calls notifyListeners()

void removeItem(String id) {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
void removeItem(String id) {
  _items.removeWhere((item) => item.id == id);
  notifyListeners();
}
```

</details>

---

## Exercise 2.5: Clear All Items

**Goal:** Reset list state.

**Your Task:** Add a method to clear the entire cart.

```dart
// TODO: Add clearCart method
// - Clears all items from _items
// - Calls notifyListeners()

void clearCart() {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
void clearCart() {
  _items.clear();
  notifyListeners();
}
```

</details>

---

## Exercise 2.6: Shopping Cart Challenge

**Goal:** Build a complete shopping cart WITHOUT looking at solutions.

**Requirements:**
- List of products to choose from
- "Add to Cart" button for each product
- Cart page showing all added items
- Remove item from cart
- Show total price
- Clear cart button

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

// Sample data
final products = [
  Product(id: '1', name: 'Apple', price: 1.00),
  Product(id: '2', name: 'Banana', price: 0.50),
  Product(id: '3', name: 'Orange', price: 0.75),
];

// State
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// App
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(home: ShopPage()),
    ),
  );
}

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.itemCount}'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: ElevatedButton(
              onPressed: () => context.read<CartProvider>().addItem(product),
              child: Text('Add'),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? Center(child: Text('Cart is empty'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              context.read<CartProvider>().removeItem(item.id),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () => context.read<CartProvider>().clearCart(),
                  child: Text('Clear Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

</details>

---

# PART 3: MULTIPLE PROVIDERS

## Exercise 3.1: Create Second Provider

**Goal:** Manage multiple pieces of state.

**Your Task:** Create a ThemeProvider alongside existing state.

```dart
// TODO: Create ThemeProvider
// - _isDarkMode (bool, default false)
// - getter isDarkMode
// - toggleTheme() method

class ThemeProvider extends ChangeNotifier {
  // Your code here...
}
```

<details>
<summary>✅ Solution</summary>

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
```

</details>

---

## Exercise 3.2: Use MultiProvider

**Goal:** Provide multiple states to the app.

**Your Task:** Wrap app with MultiProvider.

```dart
void main() {
  runApp(
    // TODO: Use MultiProvider with:
    // - ChangeNotifierProvider for Counter
    // - ChangeNotifierProvider for ThemeProvider
    MyApp(),
  );
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

</details>

---

## Exercise 3.3: Access Multiple Providers

**Goal:** Use multiple providers in one widget.

**Your Task:** Read from both providers in the same widget.

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch Counter
    // TODO: Watch ThemeProvider
    // Display count and show different color based on theme

    return Text('Count: ???');
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    final theme = context.watch<ThemeProvider>();

    return Text(
      'Count: ${counter.count}',
      style: TextStyle(
        color: theme.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
```

</details>

---

## Exercise 3.4: Theme Switcher Challenge

**Goal:** Build an app with theme switching WITHOUT looking at solutions.

**Requirements:**
- Counter with +/- buttons
- Toggle switch for dark/light mode
- App theme changes when toggled
- Use MultiProvider

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      theme: themeProvider.theme,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme + Counter'),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${counter.count}',
              style: TextStyle(fontSize: 72),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<Counter>().decrement(),
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => context.read<Counter>().increment(),
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

</details>

---

# PART 4: ASYNC STATE (LOADING & ERRORS)

## Exercise 4.1: Add Loading State

**Goal:** Track when data is loading.

**Your Task:** Add loading flag to provider.

```dart
class DataProvider extends ChangeNotifier {
  List<String> _items = [];
  bool _isLoading = false;

  List<String> get items => _items;
  bool get isLoading => _isLoading;

  // TODO: Create fetchData() that:
  // 1. Sets _isLoading = true, notifyListeners()
  // 2. Waits 2 seconds (simulate API)
  // 3. Sets _items = ['Item 1', 'Item 2', 'Item 3']
  // 4. Sets _isLoading = false, notifyListeners()

  Future<void> fetchData() async {
    // Your code here...
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> fetchData() async {
  _isLoading = true;
  notifyListeners();

  await Future.delayed(Duration(seconds: 2));

  _items = ['Item 1', 'Item 2', 'Item 3'];
  _isLoading = false;
  notifyListeners();
}
```

</details>

---

## Exercise 4.2: Display Loading State

**Goal:** Show loading indicator in UI.

**Your Task:** Display CircularProgressIndicator when loading.

```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();

    // TODO: If loading, show CircularProgressIndicator
    // Otherwise, show ListView of items

    return Scaffold(
      body: ???,
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();

    return Scaffold(
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(provider.items[index]));
              },
            ),
    );
  }
}
```

</details>

---

## Exercise 4.3: Add Error State

**Goal:** Handle and display errors.

**Your Task:** Add error handling to provider.

```dart
class DataProvider extends ChangeNotifier {
  List<String> _items = [];
  bool _isLoading = false;
  String? _error;  // TODO: Add this

  List<String> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;  // TODO: Add getter

  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;  // Clear previous error
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));

      // Simulate random failure
      if (DateTime.now().second % 2 == 0) {
        throw Exception('Failed to load data');
      }

      _items = ['Item 1', 'Item 2', 'Item 3'];
    } catch (e) {
      // TODO: Set _error to error message
    } finally {
      // TODO: Set _isLoading to false
      // TODO: Call notifyListeners()
    }
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> fetchData() async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    await Future.delayed(Duration(seconds: 2));

    if (DateTime.now().second % 2 == 0) {
      throw Exception('Failed to load data');
    }

    _items = ['Item 1', 'Item 2', 'Item 3'];
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

</details>

---

## Exercise 4.4: Display Error State

**Goal:** Show error with retry button.

**Your Task:** Handle all three states: loading, error, data.

```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();

    // TODO: Handle 3 cases:
    // 1. If loading: show CircularProgressIndicator
    // 2. If error: show error message with Retry button
    // 3. Otherwise: show list

    return Scaffold(
      body: ???,
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class DataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();

    Widget body;

    if (provider.isLoading) {
      body = Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${provider.error}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<DataProvider>().fetchData(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(provider.items[index]));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Data')),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<DataProvider>().fetchData(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

</details>

---

# PART 5: FINAL PROJECT

## Build a Todo App with Provider

**Goal:** Combine EVERYTHING you learned!

**Requirements:**
1. Todo model (id, title, isCompleted)
2. TodoProvider with:
   - List of todos
   - Add todo
   - Toggle completion
   - Delete todo
   - Filter (all/active/completed)
3. Loading state when "fetching" todos
4. Error handling
5. Dark/light theme toggle

**Build it step by step:**

### Step 1: Create Todo model
### Step 2: Create TodoProvider with list operations
### Step 3: Add loading/error states
### Step 4: Create ThemeProvider
### Step 5: Build the UI

---

**Try to build this WITHOUT looking at the solution!**

<details>
<summary>✅ Complete Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
class Todo {
  final String id;
  final String title;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

enum TodoFilter { all, active, completed }

// Providers
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;
  TodoFilter _filter = TodoFilter.all;

  List<Todo> get todos {
    switch (_filter) {
      case TodoFilter.active:
        return _todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((t) => t.isCompleted).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  TodoFilter get filter => _filter;
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;

  Future<void> fetchTodos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 1));
      _todos = [
        Todo(id: '1', title: 'Learn Flutter'),
        Todo(id: '2', title: 'Build an app'),
        Todo(id: '3', title: 'Master Provider'),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
    notifyListeners();
  }

  void toggleTodo(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeData get theme => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// App
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<ThemeProvider>().theme,
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoProvider>().fetchTodos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      context.read<TodoProvider>().addTodo(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos (${todoProvider.completedCount}/${todoProvider.totalCount})'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add todo input
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a todo...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: Text('Add'),
                ),
              ],
            ),
          ),

          // Filter chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: todoProvider.filter == TodoFilter.all,
                  onSelected: (_) =>
                      context.read<TodoProvider>().setFilter(TodoFilter.all),
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Active'),
                  selected: todoProvider.filter == TodoFilter.active,
                  onSelected: (_) =>
                      context.read<TodoProvider>().setFilter(TodoFilter.active),
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Completed'),
                  selected: todoProvider.filter == TodoFilter.completed,
                  onSelected: (_) =>
                      context.read<TodoProvider>().setFilter(TodoFilter.completed),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Todo list
          Expanded(
            child: todoProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : todoProvider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${todoProvider.error}'),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<TodoProvider>().fetchTodos(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: todoProvider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todos[index];
                          return ListTile(
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (_) =>
                                  context.read<TodoProvider>().toggleTodo(todo.id),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  context.read<TodoProvider>().deleteTodo(todo.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
```

</details>

---

## Congratulations!

You've completed all the Provider exercises!

**What you learned:**
- ✅ Creating ChangeNotifier classes
- ✅ Using notifyListeners() to update UI
- ✅ Providing state with ChangeNotifierProvider
- ✅ Reading state with context.watch and context.read
- ✅ Managing lists in state
- ✅ Using MultiProvider for multiple states
- ✅ Handling loading and error states
- ✅ Building complete apps with Provider

**Next Steps:**
1. Try Riverpod for more advanced state management
2. Try BLoC for event-driven state
3. Move on to Level 07: Navigation

---

[← Back to Level 06 README](../README.md) | [Level 07: Navigation →](../../Level-07-Navigation/README.md)
