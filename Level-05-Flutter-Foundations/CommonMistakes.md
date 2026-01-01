# Level 05: Common Mistakes

Learn from these common Flutter widget errors!

---

## Mistake #1: Using StatefulWidget When Stateless Would Work

```dart
// ❌ WRONG - No state to manage
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.product.name);  // Just displays data
  }
}

// ✅ RIGHT - Use StatelessWidget
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Text(product.name);
  }
}
```

---

## Mistake #2: Forgetting `setState()`

```dart
// ❌ WRONG - UI doesn't update
class Counter extends StatefulWidget { ... }

class _CounterState extends State<Counter> {
  int count = 0;

  void increment() {
    count++;  // Changed, but UI doesn't know!
  }
}

// ✅ RIGHT
void increment() {
  setState(() {
    count++;
  });
}
```

---

## Mistake #3: Calling setState After Dispose

```dart
// ❌ WRONG - Widget might be gone
Future<void> loadData() async {
  final data = await api.fetch();
  setState(() {  // Error if widget disposed!
    this.data = data;
  });
}

// ✅ RIGHT - Check if mounted
Future<void> loadData() async {
  final data = await api.fetch();
  if (mounted) {  // Check first
    setState(() {
      this.data = data;
    });
  }
}
```

---

## Mistake #4: ListView Inside Column Without Constraints

```dart
// ❌ WRONG - Unbounded height error
Column(
  children: [
    Text('Header'),
    ListView(  // Error: Vertical viewport given unbounded height
      children: items,
    ),
  ],
)

// ✅ RIGHT - Wrap in Expanded
Column(
  children: [
    Text('Header'),
    Expanded(
      child: ListView(
        children: items,
      ),
    ),
  ],
)
```

---

## Mistake #5: Not Using `const` Constructors

```dart
// ❌ WRONG - Rebuilds every time
Container(
  padding: EdgeInsets.all(16),  // New instance each build
  child: Text('Hello'),         // New instance each build
)

// ✅ RIGHT - Use const
Container(
  padding: const EdgeInsets.all(16),
  child: const Text('Hello'),
)
```

**Benefit:** const widgets don't rebuild, improving performance.

---

## Mistake #6: Wrong Key Usage

```dart
// ❌ WRONG - Using index as key for reorderable list
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: Key(index.toString()),  // Wrong!
      title: Text(items[index]),
    );
  },
)

// ✅ RIGHT - Use unique identifier
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      key: Key(items[index].id),  // Unique ID
      title: Text(items[index].name),
    );
  },
)
```

---

## Mistake #7: Infinite Loop in Build

```dart
// ❌ WRONG - setState in build causes infinite loop
@override
Widget build(BuildContext context) {
  loadData();  // Calls setState, triggers build, calls loadData...
  return Container();
}

// ✅ RIGHT - Load in initState
@override
void initState() {
  super.initState();
  loadData();
}
```

---

## Mistake #8: Not Handling Null Image

```dart
// ❌ WRONG - Crashes if imageUrl is null or empty
Image.network(product.imageUrl)

// ✅ RIGHT - Handle errors
Image.network(
  product.imageUrl,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image);
  },
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator();
  },
)
```

---

## Mistake #9: Text Overflow

```dart
// ❌ WRONG - Long text overflows
Row(
  children: [
    Text(reallyLongProductName),  // Overflows!
    Icon(Icons.arrow_forward),
  ],
)

// ✅ RIGHT - Handle overflow
Row(
  children: [
    Expanded(
      child: Text(
        reallyLongProductName,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.arrow_forward),
  ],
)
```

---

## Mistake #10: Using Wrong Context

```dart
// ❌ WRONG - Context is from above Scaffold
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: ElevatedButton(
      onPressed: () {
        Scaffold.of(context).showBottomSheet(...);  // Error!
      },
    ),
  );
}

// ✅ RIGHT - Use Builder or ScaffoldMessenger
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(...);
  },
)
```

---

## Quick Reference: Widget Types

| Situation | Use |
|-----------|-----|
| Display-only, no changes | `StatelessWidget` |
| Has internal state | `StatefulWidget` |
| Layout children horizontally | `Row` |
| Layout children vertically | `Column` |
| Scrollable list | `ListView` |
| Overlay widgets | `Stack` |
| Take remaining space | `Expanded` |
| Fixed space | `SizedBox` |
| Styling container | `Container` |

---

**Still stuck? Re-read the Theory files or ask for help!**
