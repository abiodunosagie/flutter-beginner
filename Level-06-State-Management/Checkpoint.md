# Level 06 Checkpoint: State Management

Before moving to Level 07, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Provider Basics
What does each line do?

```dart
// In main.dart
ChangeNotifierProvider(
  create: (_) => CartProvider(),
  child: MyApp(),
)

// In a widget
context.watch<CartProvider>()
context.read<CartProvider>()
context.select<CartProvider, int>((cart) => cart.itemCount)
```

<details>
<summary>Check Answers</summary>

- `ChangeNotifierProvider`: Creates and provides CartProvider to widget tree
- `context.watch`: Gets provider AND rebuilds when it changes
- `context.read`: Gets provider once, NO rebuilds (use in callbacks)
- `context.select`: Only rebuilds when selected value changes

</details>

---

### 2. ChangeNotifier
What's missing in this provider?

```dart
class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    // What's missing here?
  }
}
```

<details>
<summary>Check Answer</summary>

Missing `notifyListeners()` - without it, widgets won't rebuild!

```dart
void increment() {
  _count++;
  notifyListeners();  // ← This tells widgets to rebuild
}
```

</details>

---

### 3. Consumer Widget
When would you use Consumer vs context.watch?

```dart
// Option A
Consumer<CartProvider>(
  builder: (context, cart, child) {
    return Text('Items: ${cart.itemCount}');
  },
)

// Option B
Text('Items: ${context.watch<CartProvider>().itemCount}')
```

<details>
<summary>Check Answer</summary>

Both work, but:

- **Consumer**: Better when only part of a widget needs the provider
- **context.watch**: Simpler, rebuilds entire widget

```dart
// Consumer is better here - only Badge rebuilds
Scaffold(
  appBar: AppBar(
    actions: [
      Consumer<CartProvider>(
        builder: (_, cart, child) => Badge(
          label: Text('${cart.itemCount}'),
          child: child,  // IconButton doesn't rebuild!
        ),
        child: IconButton(icon: Icon(Icons.cart), onPressed: () {}),
      ),
    ],
  ),
  body: ExpensiveWidget(),  // This doesn't rebuild
)
```

</details>

---

### 4. Multiple Providers
How do you provide multiple providers?

```dart
// Fill in the blank
_____(
  providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: MyApp(),
)
```

<details>
<summary>Check Answer</summary>

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: MyApp(),
)
```

</details>

---

### 5. State vs Props
When should state live in a provider vs in the widget?

| Scenario | Provider or Widget State? |
|----------|---------------------------|
| User's login status | ___ |
| Text field input | ___ |
| Shopping cart items | ___ |
| Form validation errors | ___ |
| Selected tab index | ___ |
| User preferences | ___ |

<details>
<summary>Check Answers</summary>

| Scenario | Answer |
|----------|--------|
| User's login status | **Provider** - needed across app |
| Text field input | **Widget** - local, temporary |
| Shopping cart items | **Provider** - needed across app |
| Form validation errors | **Widget** - local to form |
| Selected tab index | **Widget** (usually) - local UI state |
| User preferences | **Provider** - persisted, shared |

**Rule of thumb**: If multiple widgets need it, use Provider.

</details>

---

### 6. Common Mistakes
What's wrong with this code?

```dart
@override
Widget build(BuildContext context) {
  final cart = context.read<CartProvider>();

  return ElevatedButton(
    onPressed: () {
      context.read<CartProvider>().addItem(product);
    },
    child: Text('Items: ${cart.itemCount}'),
  );
}
```

<details>
<summary>Check Answer</summary>

Problem: Using `context.read` for displaying data means it won't update!

```dart
@override
Widget build(BuildContext context) {
  // Use watch for data you display
  final cart = context.watch<CartProvider>();

  return ElevatedButton(
    // read is fine in callbacks
    onPressed: () {
      context.read<CartProvider>().addItem(product);
    },
    child: Text('Items: ${cart.itemCount}'),  // Now this updates!
  );
}
```

**Rule**:
- `watch` in build = reactive (rebuilds)
- `read` in callbacks = one-time access

</details>

---

## Hands-On Check

### Task 1: Create a CartProvider
Create a cart provider with add, remove, and clear:

```dart
class CartProvider extends ChangeNotifier {
  // Implement:
  // - List of cart items
  // - Add item method
  // - Remove item method
  // - Clear method
  // - Total price getter
  // - Item count getter
}
```

<details>
<summary>Example Solution</summary>

```dart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(
    0,
    (sum, item) => sum + item.product.price * item.quantity,
  );

  void addItem(Product product, [int quantity = 1]) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

</details>

---

### Task 2: Use Provider in Widget
Create an Add to Cart button that:
- Shows "Add to Cart" if not in cart
- Shows "In Cart ✓" if already in cart
- Toggles on tap

```dart
class AddToCartButton extends StatelessWidget {
  final Product product;

  // Implement using context.watch and context.read
}
```

<details>
<summary>Example Solution</summary>

```dart
class AddToCartButton extends StatelessWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Watch to rebuild when cart changes
    final isInCart = context.select<CartProvider, bool>(
      (cart) => cart.items.any((item) => item.product.id == product.id),
    );

    return ElevatedButton.icon(
      onPressed: () {
        // Read in callback - no rebuild needed
        final cart = context.read<CartProvider>();

        if (isInCart) {
          cart.removeItem(product.id);
        } else {
          cart.addItem(product);
        }
      },
      icon: Icon(isInCart ? Icons.check : Icons.add_shopping_cart),
      label: Text(isInCart ? 'In Cart ✓' : 'Add to Cart'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isInCart ? Colors.green : null,
      ),
    );
  }
}
```

</details>

---

### Task 3: Cart Badge
Create a cart icon with badge showing item count:

```dart
// Should show:
// - Cart icon
// - Badge with number if items > 0
// - No badge if cart is empty
```

<details>
<summary>Example Solution</summary>

```dart
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild when count changes
    final itemCount = context.select<CartProvider, int>(
      (cart) => cart.itemCount,
    );

    return Badge(
      isLabelVisible: itemCount > 0,
      label: Text(itemCount > 99 ? '99+' : '$itemCount'),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () => Navigator.pushNamed(context, '/cart'),
      ),
    );
  }
}
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| State Management | _________________ |
| ChangeNotifier | _________________ |
| Provider | _________________ |
| notifyListeners() | _________________ |
| watch vs read | _________________ |
| Consumer | _________________ |

---

## Ready for Level 07?

### I can confidently:
- [ ] Create a ChangeNotifier provider
- [ ] Provide it with ChangeNotifierProvider
- [ ] Use context.watch for reactive UI
- [ ] Use context.read in callbacks
- [ ] Use context.select for specific values
- [ ] Use Consumer for targeted rebuilds
- [ ] Use MultiProvider for multiple providers
- [ ] Avoid common mistakes (read vs watch)

### Capstone Progress:
- [ ] I created CartProvider
- [ ] I created UserProvider
- [ ] I created ProductsProvider
- [ ] Cart updates reflect across all screens
- [ ] Cart badge shows correct count

---

## If You're Stuck

**Common issues at this level:**

1. **"ProviderNotFoundException"**
   - Make sure provider is above the widget in the tree
   - Check that you're using the correct type

2. **Widget not updating**
   - Are you using `watch` not `read`?
   - Did you call `notifyListeners()`?
   - Is the provider correctly set up?

3. **Too many rebuilds**
   - Use `context.select` for specific values
   - Use Consumer to limit rebuild scope
   - Don't watch in parent if child needs it

4. **Circular dependency**
   - Providers shouldn't directly depend on each other
   - Use ProxyProvider if needed

---

**Ready to level up? Head to Level 07: Navigation!**
