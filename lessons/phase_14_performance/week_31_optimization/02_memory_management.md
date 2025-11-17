# Memory Management: Avoiding Leaks

## Common Memory Leaks

### 1. Not Disposing Controllers

```dart
// ❌ BAD
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  // Missing dispose() - MEMORY LEAK!

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}

// ✅ GOOD
class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();  // Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

## Using DevTools to Find Leaks

1. Run app in profile mode
2. Open DevTools → Memory
3. Take snapshot
4. Navigate through app
5. Take another snapshot
6. Compare: Look for growing objects

Master memory management! 🚀
