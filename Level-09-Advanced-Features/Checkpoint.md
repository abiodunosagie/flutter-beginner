# Level 09 Checkpoint: Advanced Features

Before moving to Level 10, make sure you can answer these questions and complete these tasks.

---

## Quick Quiz

### 1. Accessibility Basics
What does this code do for accessibility?

```dart
Semantics(
  label: 'Add product to cart',
  button: true,
  child: IconButton(
    icon: Icon(Icons.add_shopping_cart),
    onPressed: addToCart,
  ),
)
```

<details>
<summary>Check Answer</summary>

- **label**: Screen readers announce "Add product to cart"
- **button**: Tells assistive technology this is a button
- This helps visually impaired users understand and interact with the button

</details>

---

### 2. Semantic Properties
Match the property to its purpose:

| Property | Purpose |
|----------|---------|
| label | ___ |
| hint | ___ |
| button | ___ |
| image | ___ |
| excludeSemantics | ___ |

<details>
<summary>Check Answers</summary>

| Property | Purpose |
|----------|---------|
| label | Main description read aloud |
| hint | Additional action instruction |
| button | Marks as tappable button |
| image | Marks as image |
| excludeSemantics | Hides from screen readers |

</details>

---

### 3. Internationalization (i18n)
What's the purpose of each file?

```
lib/
└── l10n/
    ├── app_en.arb
    ├── app_es.arb
    └── app_fr.arb
```

<details>
<summary>Check Answer</summary>

- **ARB files**: Application Resource Bundle - contain translations
- **app_en.arb**: English translations
- **app_es.arb**: Spanish translations
- **app_fr.arb**: French translations

Each file contains key-value pairs mapping string IDs to translated text.

</details>

---

### 4. Using Translations
How do you use translated strings?

```dart
// In ARB file:
{
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}

// In Dart code:
Text(???)
```

<details>
<summary>Check Answer</summary>

```dart
// Import generated localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Use in widget
Text(AppLocalizations.of(context)!.welcomeMessage('John'))

// Or with extension
Text(context.l10n.welcomeMessage('John'))
```

</details>

---

### 5. Responsive Design
What does this code do?

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 1200) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

<details>
<summary>Check Answer</summary>

This creates a responsive layout that adapts based on available width:
- Under 600px → Mobile layout (phone)
- 600-1200px → Tablet layout
- Over 1200px → Desktop layout

`LayoutBuilder` gives you the parent's constraints to make decisions.

</details>

---

### 6. MediaQuery
What information does MediaQuery provide?

```dart
final mediaQuery = MediaQuery.of(context);
// What can you access?
```

<details>
<summary>Check Answer</summary>

```dart
mediaQuery.size              // Screen dimensions
mediaQuery.size.width        // Screen width
mediaQuery.size.height       // Screen height
mediaQuery.orientation       // Portrait or Landscape
mediaQuery.padding           // Safe area insets
mediaQuery.viewInsets        // Keyboard height
mediaQuery.textScaleFactor   // User's text size preference
mediaQuery.platformBrightness // System dark/light mode
mediaQuery.accessibleNavigation // Accessibility settings
```

</details>

---

## Hands-On Check

### Task 1: Make Widget Accessible
Add accessibility to this product card:

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  // Add:
  // - Semantic label for screen readers
  // - Image alternative text
  // - Button semantics for add to cart
}
```

<details>
<summary>Example Solution</summary>

```dart
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${product.name}, ${product.formattedPrice}',
      child: Card(
        child: Column(
          children: [
            Semantics(
              image: true,
              label: 'Product image for ${product.name}',
              excludeSemantics: true,
              child: Image.network(product.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(product.name),
                  Text(product.formattedPrice),
                  Semantics(
                    button: true,
                    label: 'Add ${product.name} to cart',
                    hint: 'Double tap to add',
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
      ),
    );
  }
}
```

</details>

---

### Task 2: Create Responsive Grid
Create a product grid that shows:
- 1 column on phones
- 2 columns on tablets
- 3-4 columns on desktop

```dart
class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;

  // Implement responsive grid
}
```

<details>
<summary>Example Solution</summary>

```dart
class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;

  const ResponsiveProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount;
        double childAspectRatio;

        if (width < 600) {
          // Phone - 1 column, tall cards
          crossAxisCount = 1;
          childAspectRatio = 1.2;
        } else if (width < 900) {
          // Tablet - 2 columns
          crossAxisCount = 2;
          childAspectRatio = 0.8;
        } else if (width < 1200) {
          // Small desktop - 3 columns
          crossAxisCount = 3;
          childAspectRatio = 0.75;
        } else {
          // Large desktop - 4 columns
          crossAxisCount = 4;
          childAspectRatio = 0.7;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => ProductCard(product: products[index]),
        );
      },
    );
  }
}
```

</details>

---

### Task 3: Set Up Localization
Create ARB files for English and Spanish:

```dart
// Create app_en.arb and app_es.arb for:
// - App title
// - Add to cart button
// - Cart empty message
// - Welcome message with name placeholder
```

<details>
<summary>Example Solution</summary>

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "ShopEase",
  "addToCart": "Add to Cart",
  "cartEmpty": "Your cart is empty",
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}

// lib/l10n/app_es.arb
{
  "@@locale": "es",
  "appTitle": "ShopEase",
  "addToCart": "Agregar al Carrito",
  "cartEmpty": "Tu carrito está vacío",
  "welcomeMessage": "¡Bienvenido, {name}!",
  "itemCount": "{count, plural, =0{Sin artículos} =1{1 artículo} other{{count} artículos}}"
}
```

```yaml
# pubspec.yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
```

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

</details>

---

## Vocabulary Check

Can you explain these terms in your own words?

| Term | Your Explanation |
|------|------------------|
| Accessibility | _________________ |
| Screen reader | _________________ |
| Semantic widget | _________________ |
| Internationalization (i18n) | _________________ |
| Localization (l10n) | _________________ |
| ARB file | _________________ |
| Responsive design | _________________ |
| Breakpoint | _________________ |

---

## Ready for Level 10?

### I can confidently:
- [ ] Add semantic labels to widgets
- [ ] Make images accessible with alt text
- [ ] Test with screen readers (TalkBack/VoiceOver)
- [ ] Set up Flutter localization
- [ ] Create ARB translation files
- [ ] Use placeholders in translations
- [ ] Handle pluralization in translations
- [ ] Create responsive layouts with LayoutBuilder
- [ ] Use MediaQuery for screen information

### Capstone Progress:
- [ ] All interactive elements have semantic labels
- [ ] Images have alternative text
- [ ] App supports at least 2 languages
- [ ] Layout adapts to different screen sizes
- [ ] Tested with accessibility tools

---

## If You're Stuck

**Common issues at this level:**

1. **Semantics not announced**
   - Check that you're using correct properties
   - Test with actual screen reader, not just visual debugger

2. **Translations not generating**
   - Run `flutter gen-l10n`
   - Check l10n.yaml configuration
   - Ensure pubspec.yaml has `generate: true`

3. **Layout not responding to size**
   - LayoutBuilder only works within constraints
   - Check parent widget isn't unbounded
   - Use MediaQuery for screen-level decisions

4. **Text not scaling properly**
   - Don't hardcode text sizes
   - Use Theme.of(context).textTheme
   - Test with large text accessibility setting

---

**Ready to level up? Head to Level 10: Final Project!**
