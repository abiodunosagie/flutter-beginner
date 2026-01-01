# Level 10: Common Mistakes

Learn from these common integration errors!

---

## Mistake #1: Not Testing the Complete Flow

```dart
// ❌ WRONG - Only testing individual features
// "Add to cart works!" ✓
// "Checkout form works!" ✓
// But together? Never tested!

// ✅ RIGHT - Test end-to-end
// 1. Browse products
// 2. Add to cart
// 3. View cart
// 4. Modify quantity
// 5. Checkout
// 6. See confirmation
```

**Test the WHOLE user journey, not just pieces.**

---

## Mistake #2: Inconsistent State Across Screens

```dart
// ❌ WRONG - Cart count different on different screens
// HomeScreen shows: 3 items
// CartScreen shows: 2 items
// Because they're using different state!

// ✅ RIGHT - Single source of truth
// Both screens use the same CartProvider
context.watch<CartProvider>().itemCount
```

---

## Mistake #3: No Error Recovery

```dart
// ❌ WRONG - User stuck on error
if (error != null) {
  return Text('Error: $error');  // No way out!
}

// ✅ RIGHT - Provide retry option
if (error != null) {
  return Column(
    children: [
      Text('Error: $error'),
      ElevatedButton(
        onPressed: retry,
        child: Text('Try Again'),
      ),
    ],
  );
}
```

---

## Mistake #4: Missing Empty States

```dart
// ❌ WRONG - Empty screen is confusing
ListView.builder(
  itemCount: items.length,  // If 0, shows nothing!
  itemBuilder: ...,
)

// ✅ RIGHT - Show helpful empty state
if (items.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.shopping_cart_outlined, size: 64),
        Text('Your cart is empty'),
        ElevatedButton(
          onPressed: () => context.go('/'),
          child: Text('Start Shopping'),
        ),
      ],
    ),
  );
}
return ListView.builder(...);
```

---

## Mistake #5: Navigation State Lost

```dart
// ❌ WRONG - Deep link loses cart data
// User adds items → navigates away → refreshes
// Cart is empty!

// ✅ RIGHT - Persist important state
// Option 1: Save to local storage
// Option 2: Save to backend
// Option 3: Use URL state for shareable data
```

---

## Mistake #6: Form Data Lost on Navigation

```dart
// ❌ WRONG - Checkout form resets if user goes back
@override
Widget build(BuildContext context) {
  return Form(
    child: TextFormField(...),  // Loses data on pop
  );
}

// ✅ RIGHT - Save form state to provider
@override
void dispose() {
  // Save draft before disposing
  context.read<CheckoutProvider>().saveDraft(
    name: nameController.text,
    address: addressController.text,
  );
  super.dispose();
}
```

---

## Mistake #7: Inconsistent Error Messages

```dart
// ❌ WRONG - Different styles everywhere
// Screen 1: Shows SnackBar
// Screen 2: Shows Dialog
// Screen 3: Shows inline Text

// ✅ RIGHT - Consistent error handling
class ErrorHandler {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
      ),
    );
  }
}
```

---

## Mistake #8: Not Handling Loading Globally

```dart
// ❌ WRONG - Each screen has different loading UI
// HomeScreen: Big spinner
// CartScreen: Shimmer
// CheckoutScreen: Nothing

// ✅ RIGHT - Consistent loading patterns
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black26,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
```

---

## Mistake #9: Ignoring Edge Cases

```dart
// ❌ WRONG - Only happy path tested
void addToCart(Product product) {
  cart.add(product);  // What if product is out of stock?
}

// ✅ RIGHT - Handle edge cases
void addToCart(Product product) {
  if (!product.isInStock) {
    showError('Product is out of stock');
    return;
  }
  if (cart.hasReachedLimit) {
    showError('Cart is full');
    return;
  }
  cart.add(product);
}
```

---

## Mistake #10: No Offline Handling

```dart
// ❌ WRONG - App crashes without internet
final products = await api.getProducts();  // Throws if offline

// ✅ RIGHT - Graceful offline handling
Future<List<Product>> getProducts() async {
  try {
    final products = await api.getProducts();
    await cache.save(products);  // Cache for offline
    return products;
  } catch (e) {
    final cached = await cache.get();
    if (cached != null) {
      return cached;  // Use cached data
    }
    rethrow;  // Only throw if no cache
  }
}
```

---

## Integration Checklist

| Area | Check |
|------|-------|
| State | Consistent across all screens |
| Navigation | All routes work, deep links work |
| Errors | Shown consistently, with recovery |
| Loading | Consistent indicators |
| Empty states | All lists have empty state |
| Edge cases | Out of stock, invalid input, etc. |
| Offline | Graceful degradation |
| Performance | No jank, quick load times |

---

**Still stuck? Re-read the Theory files or ask for help!**
