# Practical Coding Questions - Interview Challenges

## The Big Idea In One Sentence

> Coding rounds test how you think, not just the final answer, so talk through your plan, write clean Dart, handle edge cases, and explain trade-offs as you go.

Real coding problems you might face in Flutter interviews!

---

## Problem 1: Build a Counter App

### Question:
"Build a simple counter app with increment, decrement, and reset buttons."

### Solution:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Icon(Icons.add),
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

**Key points interviewers look for:**
- Proper StatefulWidget usage
- setState() called correctly
- Clean code structure
- Proper widget naming

---

## Problem 2: Fetch and Display Data from API

### Question:
"Fetch a list of users from an API and display them in a list."

### Solution:

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UserListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Model
// ═══════════════════════════════════════════════════════════

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Screen
// ═══════════════════════════════════════════════════════════

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User>? _users;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final users = jsonList.map((json) => User.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            _users = users;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUsers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_users == null || _users!.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: _users!.length,
      itemBuilder: (context, index) {
        final user = _users![index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.name[0]),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
```

**Key points:**
- Async/await usage
- Error handling
- Loading states
- `mounted` check before setState
- ListView.builder for performance
- Model class with fromJson

---

## Problem 3: Form Validation

### Question:
"Create a login form with email and password validation."

### Solution:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: _validatePassword,
              ),
              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Key points:**
- GlobalKey<FormState> for form validation
- TextEditingController disposal
- Form validators
- Loading state handling
- Password visibility toggle

---

## Problem 4: Navigation Between Screens

### Question:
"Create two screens and navigate between them, passing data."

### Solution:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FirstScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// First Screen
// ═══════════════════════════════════════════════════════════

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to First Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate and wait for result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondScreen(
                      message: 'Hello from First Screen!',
                    ),
                  ),
                );

                // Handle returned data
                if (result != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Returned: $result')),
                  );
                }
              },
              child: const Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Second Screen
// ═══════════════════════════════════════════════════════════

class SecondScreen extends StatelessWidget {
  final String message;

  const SecondScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Second Screen'),
            const SizedBox(height: 20),
            Text(
              'Received: $message',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Return data to previous screen
                Navigator.pop(context, 'Data from Second Screen');
              },
              child: const Text('Go Back with Data'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Key points:**
- Navigator.push and pop
- Passing data through constructor
- Returning data with pop
- Checking context.mounted before using context

---

## Problem 5: Build a Todo List

### Question:
"Create a todo list where users can add and delete items."

### Solution:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool completed;

  Todo({required this.title, this.completed = false});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _todos.add(Todo(title: _controller.text.trim()));
      _controller.clear();
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].completed = !_todos[index].completed;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter todo',
            ),
            autofocus: true,
            onSubmitted: (_) {
              _addTodo();
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTodo();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet!\nTap + to add one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (_) => _toggleTodo(index),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Key points:**
- List management (add, remove, update)
- ListView.builder
- Dialog usage
- TextField handling
- State management with setState

---

## Problem 6: Responsive Layout

### Question:
"Create a layout that shows different UI for phone vs tablet."

### Solution:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ResponsiveScreen(),
    );
  }
}

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Layout'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we're on mobile or tablet/desktop
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          } else {
            return _buildTabletLayout();
          }
        },
      ),
    );
  }

  // Mobile layout - vertical
  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard('Item 1', Colors.red),
        const SizedBox(height: 16),
        _buildCard('Item 2', Colors.green),
        const SizedBox(height: 16),
        _buildCard('Item 3', Colors.blue),
        const SizedBox(height: 16),
        _buildCard('Item 4', Colors.orange),
      ],
    );
  }

  // Tablet layout - grid
  Widget _buildTabletLayout() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildCard('Item 1', Colors.red),
        _buildCard('Item 2', Colors.green),
        _buildCard('Item 3', Colors.blue),
        _buildCard('Item 4', Colors.orange),
      ],
    );
  }

  Widget _buildCard(String title, Color color) {
    return Card(
      color: color,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

**Alternative with MediaQuery:**

```dart
class ResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
    );
  }
}
```

**Key points:**
- LayoutBuilder for responsive design
- MediaQuery for screen size
- Different layouts for different sizes
- Breakpoint (600px) for mobile/tablet

---

## Quick Coding Challenges

### Challenge 1: Reverse a String

```dart
String reverseString(String input) {
  // Method 1: Using split, reverse, join
  return input.split('').reversed.join('');

  // Method 2: Manual loop
  // String reversed = '';
  // for (int i = input.length - 1; i >= 0; i--) {
  //   reversed += input[i];
  // }
  // return reversed;
}

print(reverseString('hello'));  // olleh
```

---

### Challenge 2: Find Duplicates in List

```dart
List<int> findDuplicates(List<int> numbers) {
  final Set<int> seen = {};
  final Set<int> duplicates = {};

  for (final num in numbers) {
    if (seen.contains(num)) {
      duplicates.add(num);
    } else {
      seen.add(num);
    }
  }

  return duplicates.toList();
}

print(findDuplicates([1, 2, 3, 2, 4, 5, 1]));  // [2, 1]
```

---

### Challenge 3: Fibonacci Sequence

```dart
List<int> fibonacci(int n) {
  if (n <= 0) return [];
  if (n == 1) return [0];

  List<int> sequence = [0, 1];

  for (int i = 2; i < n; i++) {
    sequence.add(sequence[i - 1] + sequence[i - 2]);
  }

  return sequence;
}

print(fibonacci(7));  // [0, 1, 1, 2, 3, 5, 8]
```

---

### Challenge 4: Check if String is Palindrome

```dart
bool isPalindrome(String input) {
  final cleaned = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  return cleaned == cleaned.split('').reversed.join('');
}

print(isPalindrome('A man, a plan, a canal: Panama'));  // true
print(isPalindrome('hello'));  // false
```

---

## Common Interview Tips

### What Interviewers Look For:

```
1. Code Quality
   ✅ Clean, readable code
   ✅ Proper naming conventions
   ✅ Comments where needed

2. Best Practices
   ✅ Proper widget usage
   ✅ State management
   ✅ Resource cleanup (dispose)
   ✅ Error handling

3. Performance
   ✅ const widgets
   ✅ ListView.builder
   ✅ Avoiding rebuilds

4. Problem Solving
   ✅ Understanding requirements
   ✅ Breaking down problem
   ✅ Testing edge cases

5. Communication
   ✅ Explaining your approach
   ✅ Asking clarifying questions
   ✅ Discussing trade-offs
```

---

## Summary

**Practice these patterns:**
- StatefulWidget with setState
- API integration with error handling
- Form validation
- Navigation with data
- List management
- Responsive layouts

**Remember:**
- Always dispose controllers
- Check `mounted` before async setState
- Use proper error handling
- Write clean, readable code
- Explain your thinking out loud

**Before interview:**
- Review these examples
- Practice on DartPad
- Understand the "why" not just "how"
- Be ready to explain trade-offs

---

## Assignment

Try these on your own, then check the approach.

### Problem 1: Reverse words

Write a Dart function that reverses the order of words in a sentence ("hello world" becomes "world hello").

### Problem 2: Count occurrences

Given a `List<String>`, return a `Map<String, int>` of how many times each item appears.

### Problem 3: Talk it through

In an interview, what should you do before writing any code?

---

## Assignment Answers

### Problem 1: Reverse words

```dart
String reverseWords(String s) => s.split(' ').reversed.join(' ');
```

### Problem 2: Count occurrences

```dart
Map<String, int> counts(List<String> items) {
  final map = <String, int>{};
  for (final item in items) {
    map[item] = (map[item] ?? 0) + 1;
  }
  return map;
}
```

### Problem 3: Talk it through

Clarify the requirements and edge cases, state your plan out loud, then code it, and finally test it with an example. Communicating your thinking matters as much as the solution.

---

**You're ready! Good luck with your Flutter interview! 🚀**
