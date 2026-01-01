# Level 05 Checkpoint: Flutter Foundations

Before moving to Level 06, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Widget Types
Identify each as Stateless or Stateful:

```dart
// Widget A - displays static text
class WelcomeMessage extends ___ {
  @override
  Widget build(BuildContext context) {
    return Text('Hello World');
  }
}

// Widget B - has a counter that changes
class Counter extends ___ {
  @override
  State<Counter> createState() => _CounterState();
}
```

<details>
<summary>Check Answers</summary>

- Widget A: `StatelessWidget` - no internal state, just displays data
- Widget B: `StatefulWidget` - has internal state that changes

</details>

---

### 2. Widget Tree
What's wrong with this widget tree?

```dart
Column(
  children: [
    Text('Hello'),
    Row(
      children: [
        Expanded(child: Text('A')),
        Expanded(child: Text('B')),
      ],
    ),
    ListView(  // 🔴 Problem here!
      children: [
        Text('Item 1'),
        Text('Item 2'),
      ],
    ),
  ],
)
```

<details>
<summary>Check Answer</summary>

`ListView` inside `Column` causes an infinite height error.

**Fixes:**
1. Wrap ListView in `Expanded` or `SizedBox` with fixed height
2. Use `shrinkWrap: true` on ListView (but less performant)

```dart
Expanded(
  child: ListView(...),
)
```

</details>

---

### 3. Layout Widgets
Match the widget to its purpose:

| Widget | Purpose |
|--------|---------|
| Row | ___ |
| Column | ___ |
| Stack | ___ |
| Container | ___ |
| Padding | ___ |
| SizedBox | ___ |

<details>
<summary>Check Answers</summary>

| Widget | Purpose |
|--------|---------|
| Row | Horizontal layout |
| Column | Vertical layout |
| Stack | Overlapping widgets (z-axis) |
| Container | Box with padding, margin, decoration |
| Padding | Just adds padding around child |
| SizedBox | Fixed size or spacing |

</details>

---

### 4. BuildContext
What does `BuildContext` provide?

```dart
@override
Widget build(BuildContext context) {
  // What can I access through context?
  var theme = Theme.of(context);
  var screenWidth = MediaQuery.of(context).size.width;
  var navigator = Navigator.of(context);
}
```

<details>
<summary>Check Answer</summary>

`BuildContext` provides access to:
- **Theme**: Colors, text styles, etc.
- **MediaQuery**: Screen size, orientation, padding
- **Navigator**: For page navigation
- **Inherited Widgets**: Data passed down the tree
- **Scaffold**: SnackBars, Drawers, etc.

It's your connection to the widget tree and its data.

</details>

---

### 5. Stateful Widget Lifecycle
Put these in order (1-5):

```dart
___ build()
___ createState()
___ dispose()
___ initState()
___ setState()  // (when called)
```

<details>
<summary>Check Answer</summary>

1. `createState()` - Creates the State object
2. `initState()` - Initialize state, called once
3. `build()` - Build the widget tree
4. `setState()` - Triggers rebuild when state changes
5. `dispose()` - Cleanup when widget is removed

</details>

---

### 6. Images
What's the difference?

```dart
// Option A
Image.asset('assets/logo.png')

// Option B
Image.network('https://example.com/logo.png')

// Option C
Image.memory(bytes)
```

<details>
<summary>Check Answers</summary>

- **Image.asset**: Loads from app's assets folder (bundled with app)
- **Image.network**: Loads from a URL (requires internet)
- **Image.memory**: Loads from raw bytes in memory

Use `Image.asset` for bundled images, `Image.network` for remote images.

</details>

---

## Hands-On Check

### Task 1: Create a Stateless Widget
Create a `ProductCard` that displays product info:

```dart
// Should show:
// - Product image
// - Name
// - Price
// - Rating stars
```

<details>
<summary>Example Solution</summary>

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(product.formattedPrice),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < product.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
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

### Task 2: Create a Stateful Widget
Create a quantity selector with + and - buttons:

```dart
// Shows: [ - ] 1 [ + ]
// - button decreases (min 1)
// + button increases
```

<details>
<summary>Example Solution</summary>

```dart
class QuantitySelector extends StatefulWidget {
  final void Function(int) onChanged;

  const QuantitySelector({super.key, required this.onChanged});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int _quantity = 1;

  void _decrease() {
    if (_quantity > 1) {
      setState(() => _quantity--);
      widget.onChanged(_quantity);
    }
  }

  void _increase() {
    setState(() => _quantity++);
    widget.onChanged(_quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _decrease,
          icon: const Icon(Icons.remove),
        ),
        Text('$_quantity'),
        IconButton(
          onPressed: _increase,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

</details>

---

### Task 3: Create a Layout
Build this layout:

```
┌────────────────────────────┐
│  [Image]                   │
│                            │
│  Product Name              │
│  $29.99                    │
│                            │
│  [ Add to Cart Button ]    │
└────────────────────────────┘
```

<details>
<summary>Example Solution</summary>

```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Image.network(
        product.imageUrl,
        height: 200,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              product.formattedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Widget | _________________ |
| StatelessWidget | _________________ |
| StatefulWidget | _________________ |
| BuildContext | _________________ |
| setState | _________________ |
| Widget tree | _________________ |

---

## Ready for Level 06?

### I can confidently:
- [ ] Create StatelessWidgets
- [ ] Create StatefulWidgets with setState
- [ ] Use Row, Column, Stack for layouts
- [ ] Apply padding, margins, and decoration
- [ ] Load images from assets and network
- [ ] Use ListView and GridView
- [ ] Access Theme and MediaQuery via context
- [ ] Handle basic user input (buttons, text fields)

### Capstone Progress:
- [ ] I created ProductCard widget
- [ ] I created CartItemTile widget
- [ ] I created basic HomeScreen layout
- [ ] My UI responds to user interaction (taps, buttons)

---

## If You're Stuck

**Common issues at this level:**

1. **"setState called during build"**
   - Don't call setState inside build()
   - Move state changes to event handlers

2. **Layout overflow errors**
   - Use Expanded or Flexible in Row/Column
   - Use SingleChildScrollView for scrollable content
   - Give ListView a bounded height

3. **Image not loading**
   - Check pubspec.yaml assets declaration
   - Network images need internet permission
   - Use placeholder/error builder

4. **Widget not updating**
   - Make sure you're calling setState
   - Check if you're updating the right variable
   - Verify you're using the state variable in build

---

**Ready to level up? Head to Level 06: State Management!**
