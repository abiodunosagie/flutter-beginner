# StatefulWidget: Real-World Examples

## Think Like a Kid Building Interactive Toys

Imagine building toys that DO things:

```
🎮 Game controller - Press buttons, things happen
🎨 Magic drawing board - Draw and erase
🔦 Flashlight - Turn on and off
⏰ Alarm clock - Counts time, rings
```

All of these remember their state and change when you interact with them. Let's build similar things in Flutter!

---

## Example 1: Advanced Counter

A counter with increment, decrement, and fun features:

```dart
import 'package:flutter/material.dart';

class AdvancedCounter extends StatefulWidget {
  const AdvancedCounter({super.key});

  @override
  State<AdvancedCounter> createState() => _AdvancedCounterState();
}

class _AdvancedCounterState extends State<AdvancedCounter> {
  int _count = 0;
  int _step = 1;  // How much to add/subtract

  void _increment() {
    setState(() {
      _count += _step;
    });
  }

  void _decrement() {
    setState(() {
      _count -= _step;
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  void _setStep(int newStep) {
    setState(() {
      _step = newStep;
    });
  }

  // Get color based on count
  Color _getCountColor() {
    if (_count < 0) return Colors.red;
    if (_count == 0) return Colors.grey;
    if (_count < 10) return Colors.blue;
    return Colors.green;
  }

  // Get emoji based on count
  String _getEmoji() {
    if (_count < 0) return '😢';
    if (_count == 0) return '😐';
    if (_count < 10) return '🙂';
    if (_count < 50) return '😊';
    return '🎉';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Counter'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji
            Text(
              _getEmoji(),
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 20),
            // Count
            Text(
              '$_count',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: _getCountColor(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Step: $_step',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Step selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Step: '),
                _buildStepButton(1),
                _buildStepButton(5),
                _buildStepButton(10),
              ],
            ),
            const SizedBox(height: 20),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  icon: Icons.remove,
                  onPressed: _decrement,
                  color: Colors.red,
                ),
                const SizedBox(width: 15),
                _buildButton(
                  icon: Icons.refresh,
                  onPressed: _reset,
                  color: Colors.grey,
                ),
                const SizedBox(width: 15),
                _buildButton(
                  icon: Icons.add,
                  onPressed: _increment,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: const CircleBorder(),
      ),
      child: Icon(icon, size: 30),
    );
  }

  Widget _buildStepButton(int step) {
    final isSelected = _step == step;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text('$step'),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) _setStep(step);
        },
      ),
    );
  }
}
```

**What's happening?**
- State changes when buttons are pressed
- Color changes based on count value
- Emoji changes to match the mood
- Step size can be adjusted

---

## Example 2: Toggle Switch with Callback

A reusable toggle switch that notifies parent when changed:

```dart
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final String label;
  final bool initialValue;
  final void Function(bool)? onChanged;
  final Color activeColor;

  const ToggleSwitch({
    super.key,
    required this.label,
    this.initialValue = false,
    this.onChanged,
    this.activeColor = Colors.blue,
  });

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  void _toggle(bool value) {
    setState(() {
      _isOn = value;
    });
    // Notify parent
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isOn ? widget.activeColor.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _isOn ? Icons.check_circle : Icons.radio_button_unchecked,
                color: _isOn ? widget.activeColor : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _isOn ? FontWeight.bold : FontWeight.normal,
                  color: _isOn ? widget.activeColor : Colors.black87,
                ),
              ),
            ],
          ),
          Switch(
            value: _isOn,
            onChanged: _toggle,
            activeColor: widget.activeColor,
          ),
        ],
      ),
    );
  }
}

// Usage example:
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleSwitch(
              label: 'Notifications',
              initialValue: true,
              onChanged: (value) => print('Notifications: $value'),
              activeColor: Colors.blue,
            ),
            const SizedBox(height: 12),
            ToggleSwitch(
              label: 'Dark Mode',
              onChanged: (value) => print('Dark Mode: $value'),
              activeColor: Colors.purple,
            ),
            const SizedBox(height: 12),
            ToggleSwitch(
              label: 'Auto-save',
              initialValue: true,
              onChanged: (value) => print('Auto-save: $value'),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 3: Animated Favorite Button

A favorite button with animation and state:

```dart
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool initialValue;
  final void Function(bool)? onChanged;
  final double size;

  const FavoriteButton({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.size = 40,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialValue;

    // Setup animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Animate
    _controller.forward().then((_) => _controller.reverse());

    // Notify parent
    widget.onChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : Colors.grey,
          size: widget.size,
        ),
        onPressed: _toggle,
      ),
    );
  }
}

// Usage example:
class ProductCard extends StatelessWidget {
  final String title;

  const ProductCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            FavoriteButton(
              onChanged: (isFavorite) {
                print('$title is ${isFavorite ? 'favorited' : 'unfavorited'}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 4: Form with Validation

A login form with real-time validation:

```dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Validation state
  bool _emailValid = false;
  bool _passwordValid = false;

  @override
  void initState() {
    super.initState();

    // Listen to text changes
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _emailValid = email.contains('@') && email.contains('.');
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _passwordValid = password.length >= 6;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Validate
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (!_emailValid) {
      setState(() {
        _errorMessage = 'Please enter a valid email';
      });
      return;
    }

    if (!_passwordValid) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Success!
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _emailValid && _passwordValid && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                suffixIcon: _emailController.text.isNotEmpty
                    ? Icon(
                        _emailValid ? Icons.check_circle : Icons.error,
                        color: _emailValid ? Colors.green : Colors.red,
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            // Password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_passwordController.text.isNotEmpty)
                      Icon(
                        _passwordValid ? Icons.check_circle : Icons.error,
                        color: _passwordValid ? Colors.green : Colors.red,
                      ),
                    IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
                helperText: 'At least 6 characters',
              ),
              obscureText: _obscurePassword,
              enabled: !_isLoading,
            ),
            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Submit button
            ElevatedButton(
              onPressed: canSubmit ? _submit : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Example 5: Loading Data from API

A widget that loads data with loading, error, and success states:

```dart
import 'package:flutter/material.dart';

// Mock user model
class User {
  final String name;
  final String email;

  User(this.name, this.email);
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random success/failure
      if (DateTime.now().second % 3 == 0) {
        throw Exception('Failed to load users');
      }

      // Mock data
      final users = [
        User('Alice Johnson', 'alice@example.com'),
        User('Bob Smith', 'bob@example.com'),
        User('Charlie Brown', 'charlie@example.com'),
        User('Diana Prince', 'diana@example.com'),
        User('Ethan Hunt', 'ethan@example.com'),
      ];

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
            onPressed: _isLoading ? null : _loadUsers,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading users...'),
          ],
        ),
      );
    }

    // Error state
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading users',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state - show list
    if (_users.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.name[0]),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped ${user.name}')),
            );
          },
        );
      },
    );
  }
}
```

---

## Example 6: Timer and Stopwatch

A stopwatch with start, stop, and reset:

```dart
import 'package:flutter/material.dart';
import 'dart:async';

class Stopwatch extends StatefulWidget {
  const Stopwatch({super.key});

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stop() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer display
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo, width: 2),
              ),
              child: Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning) ...[
                  ElevatedButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: _stop,
                    icon: const Icon(Icons.pause),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
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

## Common Patterns

### Pattern 1: Input Tracking

Track user input and show character count:

```dart
class _CharacterCounterState extends State<CharacterCounter> {
  final _controller = TextEditingController();
  int _charCount = 0;
  static const int _maxChars = 100;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _maxChars - _charCount;
    final isOverLimit = remaining < 0;

    return Column(
      children: [
        TextField(
          controller: _controller,
          maxLength: _maxChars,
          decoration: InputDecoration(
            labelText: 'Enter text',
            helperText: '$remaining characters remaining',
            helperStyle: TextStyle(
              color: isOverLimit ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
```

### Pattern 2: Multi-Selection

Select multiple items from a list:

```dart
class _MultiSelectState extends State<MultiSelect> {
  final List<String> _items = ['Apple', 'Banana', 'Cherry', 'Date'];
  final Set<String> _selected = {};

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._items.map((item) {
          final isSelected = _selected.contains(item);
          return CheckboxListTile(
            title: Text(item),
            value: isSelected,
            onChanged: (value) => _toggle(item),
          );
        }),
        Text('Selected: ${_selected.join(', ')}'),
      ],
    );
  }
}
```

### Pattern 3: Pagination

Load more items as user scrolls:

```dart
class _PaginatedListState extends State<PaginatedList> {
  final _scrollController = ScrollController();
  List<String> _items = [];
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _items.addAll(
        List.generate(10, (i) => 'Item ${_page * 10 + i}'),
      );
      _page++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + 1,
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        return ListTile(title: Text(_items[index]));
      },
    );
  }
}
```

---

## Common Mistakes and Fixes

### Mistake 1: Calling setState After Dispose

```dart
// ❌ WRONG: Can crash
Future<void> loadData() async {
  final data = await api.fetch();
  setState(() {  // Widget might be disposed!
    items = data;
  });
}

// ✅ RIGHT: Check if mounted
Future<void> loadData() async {
  final data = await api.fetch();
  if (mounted) {  // Only if still in tree
    setState(() {
      items = data;
    });
  }
}
```

### Mistake 2: Not Disposing Controllers

```dart
// ❌ WRONG: Memory leak
class _MyState extends State<MyWidget> {
  final _controller = TextEditingController();
  // Never disposed! Leaks memory
}

// ✅ RIGHT: Always dispose
class _MyState extends State<MyWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();  // Clean up!
    super.dispose();
  }
}
```

### Mistake 3: Heavy Work in setState

```dart
// ❌ WRONG: UI freezes
void processData() {
  setState(() {
    // This blocks UI!
    for (var i = 0; i < 1000000; i++) {
      compute(i);
    }
  });
}

// ✅ RIGHT: Compute first, then setState
void processData() {
  final result = expensiveComputation();
  setState(() {
    data = result;  // Quick update
  });
}
```

### Mistake 4: Forgetting Initial State

```dart
// ❌ WRONG: Doesn't respect initialValue
class _ToggleState extends State<Toggle> {
  bool value = false;  // Always false!
}

// ✅ RIGHT: Use initialValue from widget
class _ToggleState extends State<Toggle> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;  // Use prop!
  }
}
```

---

## Accessing Widget Properties

Remember: Use `widget.propertyName` to access properties from the widget:

```dart
class Greeting extends StatefulWidget {
  final String name;      // Property on widget
  final Color color;

  const Greeting({
    super.key,
    required this.name,
    this.color = Colors.blue,
  });

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  int tapCount = 0;       // Property on state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => tapCount++),
      child: Text(
        'Hello, ${widget.name}! Tapped $tapCount times',
        //        ^^^^^^^^^^^  ^^^^^^
        //        From widget  From state
        style: TextStyle(color: widget.color),
        //                      ^^^^^^^^^^^^
        //                      From widget
      ),
    );
  }
}
```

---

## Tips for StatefulWidget

### Tip 1: Keep State Minimal

```dart
// ❌ Don't store derived values
class _BadState extends State<MyWidget> {
  int count = 0;
  String label = 'Count: 0';  // Derived from count!
}

// ✅ Compute in build instead
class _GoodState extends State<MyWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final label = 'Count: $count';  // Computed
    return Text(label);
  }
}
```

### Tip 2: Extract Methods

```dart
// ✅ Clean and readable
class _CounterState extends State<Counter> {
  int count = 0;

  void _increment() => setState(() => count++);
  void _decrement() => setState(() => count--);
  void _reset() => setState(() => count = 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: _decrement, icon: Icon(Icons.remove)),
        Text('$count'),
        IconButton(onPressed: _increment, icon: Icon(Icons.add)),
      ],
    );
  }
}
```

### Tip 3: Use Late for Non-Null Fields

```dart
class _MyState extends State<MyWidget> {
  late String title;  // Will be initialized in initState

  @override
  void initState() {
    super.initState();
    title = widget.defaultTitle;  // Safe!
  }
}
```

### Tip 4: Extract Reusable Widgets

```dart
// ✅ Extract common patterns
Widget _buildActionButton({
  required IconData icon,
  required VoidCallback onPressed,
  required Color color,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color),
    child: Icon(icon),
  );
}
```

---

## Summary

| Pattern | Use Case |
|---------|----------|
| Boolean toggle | On/off switches, checkboxes |
| List manipulation | Todo lists, shopping carts |
| Loading states | API calls, data fetching |
| Form validation | Login, registration forms |
| Timers | Stopwatches, countdowns |
| Input tracking | Character counts, search |
| Multi-selection | Filters, tags |
| Pagination | Infinite scroll |

**Key Takeaways:**
- Always dispose controllers and timers
- Check `mounted` before setState after async
- Keep state minimal - derive what you can
- Extract methods for clarity
- Use `widget.property` for parent properties
- Initialize state properly in initState()

---

## Practice Challenges

### Challenge 1: Todo List
Create a todo list app with:
- Add new todos
- Mark as complete
- Delete todos
- Show count of completed vs total

### Challenge 2: Color Picker
Build a color picker with:
- RGB sliders (0-255)
- Live preview of color
- Show hex code
- Copy button

### Challenge 3: Quiz App
Create a quiz with:
- Multiple questions
- Score tracking
- Timer per question
- Results screen

---

**Next:** Learn about the Layout System and how to position widgets!

---

**Navigation:**
- **Previous:** [04b-Lifecycle.md](04b-Lifecycle.md) - Widget Lifecycle Methods
- **Next:** [05-LayoutSystem.md](05-LayoutSystem.md) - Layout System
- **Up:** [Level 05 Theory](../README.md)
