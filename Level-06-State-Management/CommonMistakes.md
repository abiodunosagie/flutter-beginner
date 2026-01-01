# Level 06: Common Mistakes

Learn from these common state management errors!

---

## Mistake #1: Using `read` When You Need `watch`

```dart
// ❌ WRONG - UI won't update
@override
Widget build(BuildContext context) {
  final count = context.read<Counter>().count;  // read = one-time
  return Text('Count: $count');  // Never updates!
}

// ✅ RIGHT - Use watch to rebuild
@override
Widget build(BuildContext context) {
  final count = context.watch<Counter>().count;  // watch = reactive
  return Text('Count: $count');  // Updates when count changes
}
```

**Remember:**
- `read` = use in callbacks (onPressed, etc.)
- `watch` = use in build method for display

---

## Mistake #2: Using `watch` in Callbacks

```dart
// ❌ WRONG - watch in callback
ElevatedButton(
  onPressed: () {
    context.watch<Cart>().addItem(product);  // Don't use watch here!
  },
)

// ✅ RIGHT - Use read in callbacks
ElevatedButton(
  onPressed: () {
    context.read<Cart>().addItem(product);
  },
)
```

---

## Mistake #3: Forgetting `notifyListeners()`

```dart
// ❌ WRONG - Widgets don't know about change
class CartProvider extends ChangeNotifier {
  final List<Item> _items = [];

  void addItem(Item item) {
    _items.add(item);
    // Forgot notifyListeners()!
  }
}

// ✅ RIGHT
void addItem(Item item) {
  _items.add(item);
  notifyListeners();  // Tell widgets to rebuild
}
```

---

## Mistake #4: Provider Not Found

```dart
// ❌ WRONG - Provider not above in tree
MaterialApp(
  home: Scaffold(
    body: Consumer<Cart>(  // Error: Could not find Provider<Cart>
      builder: (_, cart, __) => Text('${cart.itemCount}'),
    ),
  ),
)

// ✅ RIGHT - Provider wraps the consumer
ChangeNotifierProvider(
  create: (_) => Cart(),
  child: MaterialApp(
    home: Scaffold(
      body: Consumer<Cart>(
        builder: (_, cart, __) => Text('${cart.itemCount}'),
      ),
    ),
  ),
)
```

---

## Mistake #5: Creating Provider in Build

```dart
// ❌ WRONG - New provider every build
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => Cart(),  // Created every rebuild!
    child: MyWidget(),
  );
}

// ✅ RIGHT - Create once in parent or main
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Cart(),
      child: MyApp(),
    ),
  );
}
```

---

## Mistake #6: Exposing Internal List

```dart
// ❌ WRONG - List can be modified directly
class CartProvider extends ChangeNotifier {
  final List<Item> items = [];  // Public, mutable
}

// External code can do:
cart.items.add(item);  // Bypasses notifyListeners!

// ✅ RIGHT - Return unmodifiable copy
class CartProvider extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }
}
```

---

## Mistake #7: Watching Too Much Data

```dart
// ❌ WRONG - Rebuilds on ANY cart change
@override
Widget build(BuildContext context) {
  final cart = context.watch<Cart>();  // Watches entire cart
  return Text('Items: ${cart.itemCount}');
}

// ✅ RIGHT - Only watch what you need
@override
Widget build(BuildContext context) {
  final count = context.select<Cart, int>((c) => c.itemCount);
  return Text('Items: $count');  // Only rebuilds when count changes
}
```

---

## Mistake #8: Multiple Providers Not Registered

```dart
// ❌ WRONG - Only one provider
ChangeNotifierProvider(
  create: (_) => Cart(),
  child: ChangeNotifierProvider(  // Nesting is messy
    create: (_) => User(),
    child: MyApp(),
  ),
)

// ✅ RIGHT - Use MultiProvider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => User()),
    ChangeNotifierProvider(create: (_) => Products()),
  ],
  child: MyApp(),
)
```

---

## Mistake #9: State in Wrong Place

```dart
// ❌ WRONG - Form input in global provider
class FormProvider extends ChangeNotifier {
  String email = '';
  String password = '';
  // This is too granular for provider!
}

// ✅ RIGHT - Local state for form, provider for shared data
class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    // Only save to provider when submitting
    context.read<UserProvider>().login(
      _emailController.text,
      _passwordController.text,
    );
  }
}
```

---

## Mistake #10: Not Disposing Controllers

```dart
// ❌ WRONG - Memory leak
class _FormState extends State<Form> {
  final controller = TextEditingController();
  // Never disposed!
}

// ✅ RIGHT
class _FormState extends State<Form> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

---

## Quick Reference: When to Use What

| Method | When to Use |
|--------|-------------|
| `context.watch<T>()` | In build, need reactive updates |
| `context.read<T>()` | In callbacks, one-time access |
| `context.select<T, R>()` | In build, only specific value |
| `Consumer<T>` | Limit rebuild scope |
| `Provider.of<T>(context)` | Legacy, prefer watch/read |

---

**Still stuck? Re-read the Theory files or ask for help!**
