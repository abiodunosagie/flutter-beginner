# Accessibility (a11y)

## Minimum bar

- Semantic labels on icon-only buttons  
- Sufficient contrast  
- Text scale (Dynamic Type / font scale) does not break layout  
- Tap targets ≥ 48dp  

```dart
IconButton(
  tooltip: 'Open cart',
  onPressed: onOpenCart,
  icon: const Icon(Icons.shopping_cart),
);
// Prefer Semantics / tooltip / label

Semantics(
  button: true,
  label: 'Add ${product.name} to cart',
  child: ...
);
```

## Test

- TalkBack / VoiceOver smoke pass on main flows  
- Large font size
