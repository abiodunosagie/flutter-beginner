# Level 09 Capstone: Polish & Accessibility

## What You're Building

In this level, you'll make ShopEase **accessible to everyone** and add **responsive design** for tablets!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 09 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Making ShopEase Accessible & Responsive                    │
│                                                              │
│   ACCESSIBILITY:                                             │
│   ┌───────────────────────────────────────────────────────┐ │
│   │  Before:                     After:                   │ │
│   │  🔇 Screen reader: ???       🔊 "Add to cart button,  │ │
│   │                                  double tap to add    │ │
│   │  ❌ Tiny buttons              ✅ 48px touch targets   │ │
│   │  ❌ Poor contrast             ✅ 4.5:1 contrast       │ │
│   └───────────────────────────────────────────────────────┘ │
│                                                              │
│   RESPONSIVE:                                                │
│   ┌───────────────────────────────────────────────────────┐ │
│   │                                                       │ │
│   │  📱 Phone        📱 Tablet         💻 Desktop         │ │
│   │  2 columns       3 columns         4 columns + sidebar│ │
│   │                                                       │ │
│   └───────────────────────────────────────────────────────┘ │
│                                                              │
│   INTERNATIONALIZATION:                                      │
│   ┌───────────────────────────────────────────────────────┐ │
│   │  🇺🇸 English      🇪🇸 Español       🇫🇷 Français       │ │
│   │  "Add to Cart"   "Añadir al      "Ajouter au        │ │
│   │                   Carrito"         Panier"           │ │
│   └───────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Add Semantic Labels

```dart
// lib/widgets/product_card.dart

class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Announce as a single element
      container: true,

      // Full description for screen readers
      label: '${product.name}, '
          '\$${product.price.toStringAsFixed(2)}, '
          'rated ${product.rating.rate} out of 5 stars',

      child: Card(
        child: Column(
          children: [
            // Image with description
            Semantics(
              image: true,
              label: 'Image of ${product.name}',
              child: Image.network(product.imageUrl),
            ),

            Text(product.name),

            // Price
            Semantics(
              label: 'Price: \$${product.price.toStringAsFixed(2)}',
              child: Text(product.formattedPrice),
            ),

            // Add to cart button
            Semantics(
              button: true,
              hint: 'Double tap to add ${product.name} to your cart',
              child: ElevatedButton(
                onPressed: () => _addToCart(context),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Task 2: Ensure Touch Target Sizes

```dart
// lib/widgets/quantity_button.dart

class QuantityButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String semanticLabel;

  const QuantityButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            // Minimum 48x48 for accessibility
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}

// Usage
QuantityButton(
  onPressed: () => _decrementQuantity(),
  icon: Icons.remove,
  semanticLabel: 'Decrease quantity',
)
```

### Task 3: Responsive Layout

```dart
// lib/widgets/responsive_grid.dart

class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;

  const ResponsiveProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on width
        final width = constraints.maxWidth;
        int columns;
        double childAspectRatio;

        if (width < 600) {
          // Phone
          columns = 2;
          childAspectRatio = 0.7;
        } else if (width < 900) {
          // Small tablet
          columns = 3;
          childAspectRatio = 0.75;
        } else if (width < 1200) {
          // Large tablet
          columns = 4;
          childAspectRatio = 0.8;
        } else {
          // Desktop
          columns = 5;
          childAspectRatio = 0.85;
        }

        return GridView.builder(
          padding: EdgeInsets.all(width < 600 ? 8 : 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: width < 600 ? 8 : 16,
            mainAxisSpacing: width < 600 ? 8 : 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}
```

### Task 4: Tablet Layout with Sidebar

```dart
// lib/screens/home/home_screen.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    if (isTablet) {
      return _TabletLayout();
    } else {
      return _PhoneLayout();
    }
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar for categories
          SizedBox(
            width: 250,
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<ProductsProvider>(
                      builder: (context, provider, _) {
                        return ListView.builder(
                          itemCount: provider.categories.length,
                          itemBuilder: (context, index) {
                            final category = provider.categories[index];
                            return ListTile(
                              selected: category == provider.selectedCategory,
                              title: Text(category.capitalize()),
                              onTap: () => provider.selectCategory(category),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchBar(),
                ),

                // Product grid
                Expanded(
                  child: Consumer<ProductsProvider>(
                    builder: (context, provider, _) {
                      return ResponsiveProductGrid(products: provider.products);
                    },
                  ),
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

### Task 5: Internationalization Setup

```dart
// lib/l10n/app_en.arb
{
  "appTitle": "ShopEase",
  "home": "Home",
  "search": "Search",
  "cart": "Cart",
  "profile": "Profile",
  "addToCart": "Add to Cart",
  "removeFromCart": "Remove",
  "checkout": "Checkout",
  "subtotal": "Subtotal",
  "tax": "Tax",
  "total": "Total",
  "emptyCart": "Your cart is empty",
  "emptyCartMessage": "Add some products to get started!",
  "productCount": "{count, plural, =0{No products} =1{1 product} other{{count} products}}",
  "@productCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  "priceFormat": "${price}",
  "@priceFormat": {
    "placeholders": {
      "price": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "$"
        }
      }
    }
  }
}

// lib/l10n/app_es.arb
{
  "appTitle": "ShopEase",
  "home": "Inicio",
  "search": "Buscar",
  "cart": "Carrito",
  "profile": "Perfil",
  "addToCart": "Añadir al Carrito",
  "removeFromCart": "Eliminar",
  "checkout": "Pagar",
  "subtotal": "Subtotal",
  "tax": "Impuesto",
  "total": "Total",
  "emptyCart": "Tu carrito está vacío",
  "emptyCartMessage": "¡Añade algunos productos para comenzar!",
  "productCount": "{count, plural, =0{Sin productos} =1{1 producto} other{{count} productos}}"
}
```

### Task 6: Language Switcher

```dart
// lib/providers/locale_provider.dart

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}

// lib/screens/settings/language_screen.dart

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.language)),
      body: ListView(
        children: [
          _LanguageTile(
            title: 'English',
            locale: const Locale('en'),
            isSelected: localeProvider.locale.languageCode == 'en',
          ),
          _LanguageTile(
            title: 'Español',
            locale: const Locale('es'),
            isSelected: localeProvider.locale.languageCode == 'es',
          ),
          _LanguageTile(
            title: 'Français',
            locale: const Locale('fr'),
            isSelected: localeProvider.locale.languageCode == 'fr',
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final Locale locale;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        context.read<LocaleProvider>().setLocale(locale);
      },
    );
  }
}
```

---

## Accessibility Checklist

```
SEMANTIC LABELS:
✅ All images have descriptions
✅ All buttons have labels
✅ All icons have semantic meaning
✅ Form fields have labels

TOUCH TARGETS:
✅ All buttons are 48x48dp minimum
✅ Links have adequate spacing
✅ Icons are easily tappable

VISUAL:
✅ Text contrast is 4.5:1 minimum
✅ Focus indicators are visible
✅ Errors are announced

NAVIGATION:
✅ Logical focus order
✅ Skip links where needed
✅ Back button works correctly
```

---

## Testing Accessibility

```bash
# Run Flutter accessibility tests
flutter test --enable-semantics

# Test with TalkBack (Android)
Settings → Accessibility → TalkBack → On

# Test with VoiceOver (iOS)
Settings → Accessibility → VoiceOver → On
```

---

## Success Criteria

- [ ] Screen reader announces all elements correctly
- [ ] All buttons are 48x48dp minimum
- [ ] Responsive layout works on phone/tablet/desktop
- [ ] Category sidebar shows on tablets
- [ ] Language can be changed
- [ ] Dates and numbers format correctly per locale
- [ ] RTL languages display correctly
- [ ] No accessibility warnings in console

---

## Files to Create

```
shopease/
└── lib/
    ├── l10n/
    │   ├── app_en.arb           ◄── Create
    │   ├── app_es.arb           ◄── Create
    │   └── app_fr.arb           ◄── Create
    │
    ├── providers/
    │   └── locale_provider.dart  ◄── Create
    │
    ├── widgets/
    │   └── responsive_grid.dart  ◄── Create
    │
    └── screens/
        └── settings/
            └── language_screen.dart ◄── Create
```

---

**Your ShopEase app is now accessible and responsive!**
