# Level 09: Common Mistakes

Learn from these common accessibility and i18n errors!

---

## Mistake #1: Missing Semantic Labels

```dart
// ❌ WRONG - Screen reader announces nothing useful
IconButton(
  icon: Icon(Icons.add_shopping_cart),
  onPressed: addToCart,
)

// ✅ RIGHT - Descriptive label
Semantics(
  label: 'Add to cart',
  button: true,
  child: IconButton(
    icon: Icon(Icons.add_shopping_cart),
    onPressed: addToCart,
  ),
)

// Or use tooltip (also adds semantics)
IconButton(
  icon: Icon(Icons.add_shopping_cart),
  tooltip: 'Add to cart',
  onPressed: addToCart,
)
```

---

## Mistake #2: Images Without Alt Text

```dart
// ❌ WRONG - Screen reader skips or says "image"
Image.network(product.imageUrl)

// ✅ RIGHT
Semantics(
  label: 'Photo of ${product.name}',
  image: true,
  child: Image.network(product.imageUrl),
)
```

---

## Mistake #3: Ignoring Text Scaling

```dart
// ❌ WRONG - Fixed font size doesn't scale
Text(
  'Hello',
  style: TextStyle(fontSize: 16),  // Won't respect user's text size setting
)

// ✅ RIGHT - Use theme text styles
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge,
)

// Or scale manually if needed
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16 * MediaQuery.of(context).textScaleFactor,
  ),
)
```

---

## Mistake #4: Low Contrast Colors

```dart
// ❌ WRONG - Light gray on white
Text(
  'Important info',
  style: TextStyle(color: Colors.grey[300]),  // Hard to read!
)

// ✅ RIGHT - Sufficient contrast
Text(
  'Important info',
  style: TextStyle(color: Colors.grey[700]),  // 4.5:1 contrast ratio
)
```

---

## Mistake #5: Not Testing with Screen Reader

```dart
// ❌ WRONG - Assuming it works
Semantics(
  label: 'Add item',  // But there are 10 items, which one?
)

// ✅ RIGHT - Be specific
Semantics(
  label: 'Add ${product.name} to cart, price ${product.formattedPrice}',
)
```

**Tip:** Test with TalkBack (Android) or VoiceOver (iOS) to hear what users hear.

---

## Mistake #6: Hardcoded Strings

```dart
// ❌ WRONG - Can't translate
Text('Add to Cart')
Text('Your cart is empty')
Text('Total: \$${total}')

// ✅ RIGHT - Use localization
Text(AppLocalizations.of(context)!.addToCart)
Text(AppLocalizations.of(context)!.cartEmpty)
Text(AppLocalizations.of(context)!.total(total))
```

---

## Mistake #7: Wrong Plural Handling

```dart
// ❌ WRONG - Doesn't handle plurals
Text('${count} items')  // "1 items" is wrong!

// ✅ RIGHT - Proper pluralization
// In ARB file:
// "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}"

Text(AppLocalizations.of(context)!.itemCount(count))
```

---

## Mistake #8: Not Handling RTL Languages

```dart
// ❌ WRONG - Hardcoded left/right
Padding(
  padding: EdgeInsets.only(left: 16),  // Wrong for Arabic, Hebrew
)

// ✅ RIGHT - Use start/end
Padding(
  padding: EdgeInsetsDirectional.only(start: 16),
)

// Or
Row(
  children: [
    Icon(Icons.arrow_back),  // Use arrow_back_ios for iOS style
    // For RTL: arrow_forward is used automatically with Directionality
  ],
)
```

---

## Mistake #9: Fixed Width for Text

```dart
// ❌ WRONG - Text might not fit in other languages
Container(
  width: 100,  // "Add to Cart" fits, but "Añadir al carrito" doesn't!
  child: Text(localizedText),
)

// ✅ RIGHT - Let text determine size
Container(
  constraints: BoxConstraints(minWidth: 100),
  child: Text(localizedText),
)

// Or use Flexible/Expanded
Row(
  children: [
    Expanded(child: Text(localizedText)),
  ],
)
```

---

## Mistake #10: Not Supporting Dark Mode

```dart
// ❌ WRONG - Hardcoded colors
Container(
  color: Colors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black),
  ),
)

// ✅ RIGHT - Use theme colors
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

---

## Quick Reference: Accessibility Checklist

| Feature | Check |
|---------|-------|
| Images | Have alt text via Semantics |
| Buttons | Have tooltip or semantic label |
| Forms | Labels linked to inputs |
| Colors | 4.5:1 contrast ratio |
| Touch targets | At least 48x48 pixels |
| Focus | Visible focus indicator |
| Text | Scales with user settings |
| Layout | Works in RTL |

---

**Still stuck? Re-read the Theory files or ask for help!**
