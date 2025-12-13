# Week 8, Day 1-2: Stateful Widgets - Making Apps Interactive

## 5-Year-Old Explanation

Imagine you have two types of toys:

**Type 1: A Plastic Dinosaur**
- It just sits there
- It doesn't move or change
- It always looks exactly the same
- (This is like a StatelessWidget!)

**Type 2: A Light-Up Robot**
- You press a button → The lights change color!
- You turn a dial → It makes different sounds!
- It remembers how many times you pressed the button
- It changes and reacts to what you do!
- (This is like a StatefulWidget!)

In Flutter, some widgets are like the plastic dinosaur - they just show something and never change (like a picture or a label). These are called **Stateless Widgets**.

But other widgets are like the robot - they can change, remember things, and react to what you do! When you click a button and a number goes up, or when you type in a text box and letters appear - that's a **Stateful Widget**.

**Real app examples:**
- A "Like" button that changes color when you tap it → Stateful!
- A counter that goes up when you press "+" → Stateful!
- A profile picture that never changes → Stateless!
- Static text that just displays information → Stateless!

State = "The current situation." A stateful widget can remember and change its situation!

---

## StatelessWidget vs StatefulWidget

### StatelessWidget
- **Immutable** - Never changes
- **Static content** - Display only
- Examples: Text, Icon, Card

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Static Text');
  }
}
```

### StatefulWidget
- **Mutable** - Can change over time
- **Interactive** - Responds to user actions
- Examples: Counter, Form, Animation

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;  // Mutable state

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}
```

---

## Creating a StatefulWidget

### Complete Example: Counter

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_counter',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: Icon(Icons.add),
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

---

## Understanding setState()

**setState()** tells Flutter: "The state changed, rebuild the widget!"

```dart
void _updateValue() {
  setState(() {
    // Change state HERE
    _counter++;
    _name = 'New Name';
    _isActive = !_isActive;
  });
}
```

### What Happens
1. You call `setState()`
2. State variables change
3. Flutter calls `build()` again
4. UI updates

### Common Mistake

```dart
// WRONG - Doesn't rebuild UI
void _increment() {
  _counter++;  // Changed but UI doesn't update
}

// CORRECT - Rebuilds UI
void _increment() {
  setState(() {
    _counter++;  // Changed AND UI updates
  });
}
```

---

## Widget Lifecycle

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Called once when widget is created
    print('1. initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called after initState and when dependencies change
    print('2. didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    // Called every time setState() is called
    print('3. build');
    return Container();
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Called when parent rebuilds with new widget
    print('4. didUpdateWidget');
  }

  @override
  void dispose() {
    // Clean up resources
    print('5. dispose');
    super.dispose();
  }
}
```

---

## State Examples

### Example 1: Toggle Switch

```dart
class ToggleScreen extends StatefulWidget {
  @override
  _ToggleScreenState createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  bool _isOn = false;

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toggle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _isOn ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _isOn ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggle,
              child: Text('Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 2: Text Input

```dart
class TextInputScreen extends StatefulWidget {
  @override
  _TextInputScreenState createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  String _name = '';

  void _updateName(String value) {
    setState(() {
      _name = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Input')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: _updateName,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Hello, $_name!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example 3: Multiple States

```dart
class MultiStateScreen extends StatefulWidget {
  @override
  _MultiStateScreenState createState() => _MultiStateScreenState();
}

class _MultiStateScreenState extends State<MultiStateScreen> {
  int _counter = 0;
  String _message = 'Press a button';
  bool _isLoading = false;

  void _increment() {
    setState(() {
      _counter++;
      _message = 'Incremented!';
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
      _message = 'Decremented!';
    });
  }

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
      _message = 'Loading...';
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _message = 'Done!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multiple States')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_counter', style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(fontSize: 20)),
            SizedBox(height: 40),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _decrement,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _increment,
                    child: Icon(Icons.add),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _simulateLoading,
                    child: Text('Load'),
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

---

## Complete Example: Shopping Cart

```dart
class Product {
  String name;
  double price;
  int quantity;

  Product(this.name, this.price, this.quantity);
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Product> _cart = [
    Product('Laptop', 999.99, 1),
    Product('Mouse', 29.99, 2),
    Product('Keyboard', 79.99, 1),
  ];

  void _increaseQuantity(int index) {
    setState(() {
      _cart[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  double _calculateTotal() {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                Product product = _cart[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _decreaseQuantity(index),
                        ),
                        Text('${product.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _increaseQuantity(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
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

---

## Key Takeaways

1. **StatelessWidget** = Immutable, static
2. **StatefulWidget** = Mutable, interactive
3. **setState()** = Update state and rebuild
4. **initState()** = Initialize once
5. **dispose()** = Clean up resources
6. State changes trigger rebuilds

---

## What's Next

- User input widgets
- Forms and validation
- Navigation between screens
