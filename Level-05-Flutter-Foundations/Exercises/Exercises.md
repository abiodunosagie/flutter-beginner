# Level 05: Flutter Foundations Exercises

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

# PART 1: BASIC WIDGETS

## Exercise 1.1: Create a Text Widget

**Goal:** Display text on screen.

**Your Task:** Replace "TODO" with a Text widget showing "Hello Flutter"

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: // TODO: Add Text widget with "Hello Flutter"
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
child: const Text('Hello Flutter'),
```

</details>

---

## Exercise 1.2: Style the Text

**Goal:** Make text larger and bold.

**Your Task:** Add TextStyle to make the text size 32 and bold.

```dart
Center(
  child: Text(
    'Hello Flutter',
    // TODO: Add style property with TextStyle
    // - fontSize: 32
    // - fontWeight: FontWeight.bold
  ),
)
```

<details>
<summary>✅ Solution</summary>

```dart
Center(
  child: Text(
    'Hello Flutter',
    style: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

</details>

---

## Exercise 1.3: Add Color to Text

**Goal:** Change text color.

**Your Task:** Make the text blue.

```dart
Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    // TODO: Add color property
  ),
)
```

<details>
<summary>✅ Solution</summary>

```dart
Text(
  'Hello Flutter',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)
```

</details>

---

## Exercise 1.4: Add an Icon

**Goal:** Display an icon.

**Your Task:** Add a star icon below the text.

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('Hello Flutter', style: TextStyle(fontSize: 32)),
    SizedBox(height: 16),
    // TODO: Add Icon widget
    // Use Icons.star with size 50 and color yellow
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('Hello Flutter', style: TextStyle(fontSize: 32)),
    SizedBox(height: 16),
    Icon(
      Icons.star,
      size: 50,
      color: Colors.yellow,
    ),
  ],
)
```

</details>

---

## Exercise 1.5: Complete Widget Challenge

**Goal:** Build a greeting card WITHOUT looking at solutions.

**Your Task:** Create a centered card showing:
- Your name (large, bold)
- "Flutter Developer" (smaller, gray)
- A heart icon (red)

```dart
// TODO: Build it yourself!
// Use Column, Text, Icon, SizedBox
```

<details>
<summary>✅ Solution</summary>

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'John Doe',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'Flutter Developer',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 16),
      Icon(
        Icons.favorite,
        size: 50,
        color: Colors.red,
      ),
    ],
  ),
)
```

</details>

---

# PART 2: LAYOUT WIDGETS

## Exercise 2.1: Create a Row

**Goal:** Arrange items horizontally.

**Your Task:** Put 3 colored boxes in a row.

```dart
// TODO: Create a Row with 3 Container children
// Each Container should be:
// - width: 60, height: 60
// - Different colors (red, green, blue)
```

<details>
<summary>✅ Solution</summary>

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(width: 60, height: 60, color: Colors.red),
    Container(width: 60, height: 60, color: Colors.green),
    Container(width: 60, height: 60, color: Colors.blue),
  ],
)
```

</details>

---

## Exercise 2.2: Add Spacing to Row

**Goal:** Add space between items.

**Your Task:** Use mainAxisAlignment to spread boxes evenly.

```dart
Row(
  // TODO: Add mainAxisAlignment: MainAxisAlignment.spaceEvenly
  children: [
    Container(width: 60, height: 60, color: Colors.red),
    Container(width: 60, height: 60, color: Colors.green),
    Container(width: 60, height: 60, color: Colors.blue),
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(width: 60, height: 60, color: Colors.red),
    Container(width: 60, height: 60, color: Colors.green),
    Container(width: 60, height: 60, color: Colors.blue),
  ],
)
```

</details>

---

## Exercise 2.3: Create a Column

**Goal:** Arrange items vertically.

**Your Task:** Stack 3 boxes vertically, centered.

```dart
// TODO: Create a Column with 3 Container children
// - Use mainAxisAlignment: MainAxisAlignment.center
// - Each box: width 100, height 50, different colors
```

<details>
<summary>✅ Solution</summary>

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(width: 100, height: 50, color: Colors.orange),
    Container(width: 100, height: 50, color: Colors.purple),
    Container(width: 100, height: 50, color: Colors.teal),
  ],
)
```

</details>

---

## Exercise 2.4: Add SizedBox for Spacing

**Goal:** Add gaps between widgets.

**Your Task:** Add 16 pixels of space between each box.

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(width: 100, height: 50, color: Colors.orange),
    // TODO: Add SizedBox(height: 16)
    Container(width: 100, height: 50, color: Colors.purple),
    // TODO: Add SizedBox(height: 16)
    Container(width: 100, height: 50, color: Colors.teal),
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(width: 100, height: 50, color: Colors.orange),
    SizedBox(height: 16),
    Container(width: 100, height: 50, color: Colors.purple),
    SizedBox(height: 16),
    Container(width: 100, height: 50, color: Colors.teal),
  ],
)
```

</details>

---

## Exercise 2.5: Use Padding

**Goal:** Add space around a widget.

**Your Task:** Add 20 pixels of padding around the Container.

```dart
// TODO: Wrap Container in Padding widget
// Use EdgeInsets.all(20)

Container(
  width: 100,
  height: 100,
  color: Colors.blue,
)
```

<details>
<summary>✅ Solution</summary>

```dart
Padding(
  padding: EdgeInsets.all(20),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
  ),
)
```

</details>

---

## Exercise 2.6: Use Expanded

**Goal:** Make widgets fill available space.

**Your Task:** Make boxes fill the row width with ratios 2:1:1.

```dart
Row(
  children: [
    // TODO: First box should take 2x space (flex: 2)
    Container(height: 60, color: Colors.red),

    // TODO: Second box should take 1x space (flex: 1)
    Container(height: 60, color: Colors.green),

    // TODO: Third box should take 1x space (flex: 1)
    Container(height: 60, color: Colors.blue),
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(height: 60, color: Colors.red),
    ),
    Expanded(
      flex: 1,
      child: Container(height: 60, color: Colors.green),
    ),
    Expanded(
      flex: 1,
      child: Container(height: 60, color: Colors.blue),
    ),
  ],
)
```

</details>

---

## Exercise 2.7: Layout Challenge

**Goal:** Build a profile card layout WITHOUT looking at solutions.

**Your Task:** Create this layout:
```
┌─────────────────────────────────────┐
│  [Avatar]    Name                   │
│              @username              │
└─────────────────────────────────────┘
```

Use: Row, Column, Container (for avatar), Text, Padding

<details>
<summary>✅ Solution</summary>

```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Row(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@johndoe',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ],
  ),
)
```

</details>

---

# PART 3: STATEFUL WIDGETS

## Exercise 3.1: Create StatefulWidget

**Goal:** Understand the structure of a StatefulWidget.

**Your Task:** Convert this StatelessWidget to StatefulWidget.

```dart
// Convert this:
class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('0');
  }
}

// TODO: Rewrite as StatefulWidget
```

<details>
<summary>✅ Solution</summary>

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Text('0');
  }
}
```

</details>

---

## Exercise 3.2: Add State Variable

**Goal:** Store data in state.

**Your Task:** Add a count variable to the state.

```dart
class _CounterState extends State<Counter> {
  // TODO: Add int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Text('0');  // TODO: Change to show _count
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Text('$_count');
  }
}
```

</details>

---

## Exercise 3.3: Add a Button

**Goal:** Add a clickable button.

**Your Task:** Add an ElevatedButton that prints "Clicked!" when pressed.

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('$_count', style: TextStyle(fontSize: 48)),
    SizedBox(height: 16),
    // TODO: Add ElevatedButton
    // onPressed should print "Clicked!"
    // child should be Text('+')
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('$_count', style: TextStyle(fontSize: 48)),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: () {
        print('Clicked!');
      },
      child: Text('+'),
    ),
  ],
)
```

</details>

---

## Exercise 3.4: Use setState

**Goal:** Update UI when state changes.

**Your Task:** Make the button increment _count using setState.

```dart
ElevatedButton(
  onPressed: () {
    // TODO: Use setState to increment _count
    // setState(() {
    //   _count++;
    // });
  },
  child: Text('+'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    setState(() {
      _count++;
    });
  },
  child: Text('+'),
)
```

</details>

---

## Exercise 3.5: Add Decrement Button

**Goal:** Add another button to decrease count.

**Your Task:** Add a "-" button that decreases _count, but doesn't go below 0.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // TODO: Add decrement button
    // Don't allow count to go below 0

    SizedBox(width: 20),
    Text('$_count', style: TextStyle(fontSize: 48)),
    SizedBox(width: 20),

    ElevatedButton(
      onPressed: () {
        setState(() {
          _count++;
        });
      },
      child: Text('+'),
    ),
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: () {
        setState(() {
          if (_count > 0) {
            _count--;
          }
        });
      },
      child: Text('-'),
    ),
    SizedBox(width: 20),
    Text('$_count', style: TextStyle(fontSize: 48)),
    SizedBox(width: 20),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _count++;
        });
      },
      child: Text('+'),
    ),
  ],
)
```

</details>

---

## Exercise 3.6: Counter Challenge

**Goal:** Build a complete counter WITHOUT looking at solutions.

**Requirements:**
- Display count in large text
- "+" button to increment
- "-" button to decrement (min 0)
- "Reset" button to set to 0
- Change text color to red when 0, green when positive

<details>
<summary>✅ Solution</summary>

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_count',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: _count == 0 ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_count > 0) _count--;
                    });
                  },
                  child: Text('-', style: TextStyle(fontSize: 24)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _count++;
                    });
                  },
                  child: Text('+', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _count = 0;
                });
              },
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

# PART 4: LISTS

## Exercise 4.1: Create a ListView

**Goal:** Display a scrollable list.

**Your Task:** Create a ListView with 3 items.

```dart
// TODO: Create ListView with 3 ListTile children
// Each ListTile should have:
// - leading: Icon
// - title: Text
// - subtitle: Text
```

<details>
<summary>✅ Solution</summary>

```dart
ListView(
  children: [
    ListTile(
      leading: Icon(Icons.star),
      title: Text('Item 1'),
      subtitle: Text('Description 1'),
    ),
    ListTile(
      leading: Icon(Icons.star),
      title: Text('Item 2'),
      subtitle: Text('Description 2'),
    ),
    ListTile(
      leading: Icon(Icons.star),
      title: Text('Item 3'),
      subtitle: Text('Description 3'),
    ),
  ],
)
```

</details>

---

## Exercise 4.2: Use ListView.builder

**Goal:** Create list from data.

**Your Task:** Use ListView.builder with a list of strings.

```dart
final items = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];

// TODO: Create ListView.builder
// - itemCount: items.length
// - itemBuilder returns ListTile with item name
```

<details>
<summary>✅ Solution</summary>

```dart
final items = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];

ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

</details>

---

## Exercise 4.3: Add Item to List

**Goal:** Add items dynamically.

**Your Task:** Add "New Item" to the list when button is pressed.

```dart
class _MyListState extends State<MyList> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  void _addItem() {
    // TODO: Use setState to add 'New Item' to _items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My List')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_items[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
void _addItem() {
  setState(() {
    _items.add('New Item ${_items.length + 1}');
  });
}
```

</details>

---

## Exercise 4.4: Delete Item from List

**Goal:** Remove items from list.

**Your Task:** Add delete button to each item.

```dart
ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(_items[index]),
      // TODO: Add trailing IconButton to delete this item
      // Use Icons.delete
      // onPressed should remove item at this index
    );
  },
)
```

<details>
<summary>✅ Solution</summary>

```dart
ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(_items[index]),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _items.removeAt(index);
          });
        },
      ),
    );
  },
)
```

</details>

---

## Exercise 4.5: List Challenge

**Goal:** Build a simple todo list WITHOUT looking at solutions.

**Requirements:**
- TextField to enter new task
- "Add" button to add task to list
- List shows all tasks
- Each task has delete button
- Show total count of tasks

<details>
<summary>✅ Solution</summary>

```dart
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _tasks = [];
  final _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a task',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Total tasks: ${_tasks.length}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
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

# PART 5: USER INPUT

## Exercise 5.1: Create a TextField

**Goal:** Accept text input.

**Your Task:** Add a basic TextField.

```dart
Column(
  children: [
    // TODO: Add TextField with decoration
    // hintText: 'Enter your name'
  ],
)
```

<details>
<summary>✅ Solution</summary>

```dart
Column(
  children: [
    TextField(
      decoration: InputDecoration(
        hintText: 'Enter your name',
      ),
    ),
  ],
)
```

</details>

---

## Exercise 5.2: Use TextEditingController

**Goal:** Read text from TextField.

**Your Task:** Show the entered text below the TextField.

```dart
class _MyFormState extends State<MyForm> {
  // TODO: Create TextEditingController

  // TODO: Dispose controller in dispose()

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          // TODO: Connect controller
          decoration: InputDecoration(hintText: 'Enter text'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Print controller.text
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter text'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            print('Entered: ${_controller.text}');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

</details>

---

## Exercise 5.3: Add TextField Border

**Goal:** Style the TextField.

**Your Task:** Add an outlined border to the TextField.

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Enter email',
    // TODO: Add border: OutlineInputBorder()
    // TODO: Add prefixIcon: Icon(Icons.email)
  ),
)
```

<details>
<summary>✅ Solution</summary>

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Enter email',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
  ),
)
```

</details>

---

## Exercise 5.4: Create Password Field

**Goal:** Hide password text.

**Your Task:** Create a password TextField.

```dart
// TODO: Create TextField for password
// - obscureText: true
// - Add lock icon
// - hintText: 'Enter password'
```

<details>
<summary>✅ Solution</summary>

```dart
TextField(
  obscureText: true,
  decoration: InputDecoration(
    hintText: 'Enter password',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
  ),
)
```

</details>

---

## Exercise 5.5: Simple Validation

**Goal:** Check if input is valid.

**Your Task:** Show error if name is less than 3 characters.

```dart
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();
  String? _errorText;

  void _submit() {
    // TODO: Check if text length < 3
    // If yes: set _errorText = 'Name must be at least 3 characters'
    // If no: set _errorText = null and print "Valid!"
    // Remember to use setState!
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(),
            errorText: _errorText,  // Shows error below field
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
void _submit() {
  setState(() {
    if (_controller.text.length < 3) {
      _errorText = 'Name must be at least 3 characters';
    } else {
      _errorText = null;
      print('Valid: ${_controller.text}');
    }
  });
}
```

</details>

---

## Exercise 5.6: Form Challenge

**Goal:** Build a login form WITHOUT looking at solutions.

**Requirements:**
- Email field (with email icon)
- Password field (hidden text, with lock icon)
- Login button
- Validate email contains "@"
- Validate password is at least 6 characters
- Show errors if invalid
- Print "Login successful!" if valid

<details>
<summary>✅ Solution</summary>

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  void _login() {
    setState(() {
      // Validate email
      if (!_emailController.text.contains('@')) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }

      // Validate password
      if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      // If both valid
      if (_emailError == null && _passwordError == null) {
        print('Login successful!');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                errorText: _passwordError,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
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

# PART 6: FINAL PROJECT

## Build a Profile Card App

**Goal:** Combine EVERYTHING you learned!

**Requirements:**
1. App with Scaffold and AppBar
2. Profile section with:
   - CircleAvatar (use Container with BoxDecoration)
   - Name (large, bold)
   - Bio (smaller, gray)
3. Stats Row showing: Posts, Followers, Following
4. "Edit Profile" button
5. When Edit is pressed, show form to change name
6. Save button updates the displayed name

**Build it step by step:**

### Step 1: Create the basic structure
```dart
class ProfileApp extends StatefulWidget { ... }
```

### Step 2: Add the profile display widgets
```dart
// CircleAvatar, name Text, bio Text
```

### Step 3: Add the stats Row
```dart
// Three columns for Posts, Followers, Following
```

### Step 4: Add Edit button and form
```dart
// Button that shows/hides TextField
// Save button that updates name
```

---

**Try to build this WITHOUT looking at the solution!**

<details>
<summary>✅ Complete Solution</summary>

```dart
import 'package:flutter/material.dart';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  bool _isEditing = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = _name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _controller.text = _name;
      }
    });
  }

  void _saveName() {
    setState(() {
      _name = _controller.text;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),

            // Name (or edit field)
            if (_isEditing) ...[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _saveName,
                child: Text('Save'),
              ),
            ] else ...[
              Text(
                _name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            SizedBox(height: 8),

            // Bio
            Text(
              'Flutter Developer | Coffee Lover',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Posts', '42'),
                _buildStat('Followers', '1.2K'),
                _buildStat('Following', '500'),
              ],
            ),
            SizedBox(height: 24),

            // Edit Button
            if (!_isEditing)
              OutlinedButton(
                onPressed: _toggleEdit,
                child: Text('Edit Profile'),
              ),
            if (_isEditing)
              TextButton(
                onPressed: _toggleEdit,
                child: Text('Cancel'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
```

</details>

---

## Congratulations!

You've completed all the Flutter Foundations exercises!

**What you learned:**
- ✅ Basic widgets (Text, Icon, Container)
- ✅ Layout widgets (Row, Column, Padding, Expanded)
- ✅ StatefulWidget and setState
- ✅ Lists with ListView.builder
- ✅ User input with TextField
- ✅ Basic form validation
- ✅ Building complete apps

**Next Steps:**
1. Practice by building more apps
2. Try the bonus challenges
3. Move on to Level 06: State Management

---

[← Back to Level 05 README](../README.md) | [Level 06: State Management →](../../Level-06-State-Management/README.md)
