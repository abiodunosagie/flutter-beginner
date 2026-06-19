# Accessibility Patterns: Best Practices for Real Apps

## The Big Idea In One Sentence

> These are ready-made recipes for making real screens (forms, lists, loading states, navigation) accessible, so you announce what changed, label what matters, and keep the experience clear for everyone.

## The Simple Explanation

Imagine you're building different types of furniture for your friends. After building many pieces, you notice patterns that work well:

```
LEARNING FROM EXPERIENCE:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  Pattern 1: Chairs always need 4 legs                    │
│            (Not 3, not 5 - always 4!)                    │
│                                                          │
│  Pattern 2: Tables should be easy to reach                │
│            (Not too high, not too low)                   │
│                                                          │
│  Pattern 3: Doors need handles at the same height        │
│            (So everyone knows where to grab)             │
│                                                          │
│  Result: You build better furniture faster! 😊           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Accessibility Patterns = Proven solutions to common accessibility problems!**

---

## Common UI Patterns

### Pattern 1: Accessible Card

A card that works perfectly with screen readers:

```dart
class AccessibleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const AccessibleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Combine everything into one announcement
      label: '$title. $description',
      button: true,
      hint: 'Double tap to view details',
      onTap: onTap,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Hide icon from screen reader (it's decorative)
                ExcludeSemantics(
                  child: Icon(icon, size: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hide text from screen reader (we combined it above)
                      ExcludeSemantics(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ExcludeSemantics(
                        child: Text(
                          description,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                ExcludeSemantics(
                  child: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Usage:
AccessibleCard(
  icon: Icons.shopping_cart,
  title: 'Shopping Cart',
  description: '3 items',
  onTap: () {
    print('Navigate to cart');
  },
)

// Screen reader announces:
// 🔊 "Shopping Cart. 3 items. Button. Double tap to view details."
```

### Pattern 2: Accessible List

```dart
class AccessibleList extends StatelessWidget {
  final List<String> items;

  const AccessibleList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Announce total count
      label: 'List with ${items.length} items',
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Semantics(
            // Announce position in list
            label: items[index],
            hint: 'Item ${index + 1} of ${items.length}',
            child: ListTile(
              title: ExcludeSemantics(
                child: Text(items[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Screen reader announces each item:
// 🔊 "Apples. Item 1 of 5."
// 🔊 "Bananas. Item 2 of 5."
// 🔊 "Oranges. Item 3 of 5."
```

### Pattern 3: Accessible Dialog

```dart
class AccessibleDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;

  const AccessibleDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Announce it's a dialog
      scopesRoute: true,
      namesRoute: true,
      label: 'Alert dialog',
      child: AlertDialog(
        title: Semantics(
          header: true,
          child: Text(title),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

// Usage:
showDialog(
  context: context,
  builder: (context) => AccessibleDialog(
    title: 'Delete Item',
    message: 'Are you sure you want to delete this item? This action cannot be undone.',
    confirmText: 'Delete',
    cancelText: 'Cancel',
  ),
);

// Screen reader announces:
// 🔊 "Alert dialog. Delete Item. Heading."
// 🔊 "Are you sure you want to delete this item? This action cannot be undone."
// 🔊 "Cancel. Button."
// 🔊 "Delete. Button."
```

---

## Form Patterns

### Pattern 4: Accessible Form Field with Label

```dart
class AccessibleFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AccessibleFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        // Add required indicator accessibly
        suffixIcon: validator != null
            ? Semantics(
                label: 'Required field',
                child: const Icon(Icons.star, size: 8, color: Colors.red),
              )
            : null,
      ),
    );
  }
}

// Usage:
AccessibleFormField(
  label: 'Email',
  hint: 'Enter your email address',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  },
)

// Screen reader announces:
// 🔊 "Email. Enter your email address. Required field. Text field."
```

### Pattern 5: Accessible Checkbox with Description

```dart
class AccessibleCheckbox extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const AccessibleCheckbox({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: description,
      checked: value,
      child: CheckboxListTile(
        title: ExcludeSemantics(child: Text(label)),
        subtitle: description != null
            ? ExcludeSemantics(child: Text(description!))
            : null,
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

// Usage:
AccessibleCheckbox(
  label: 'Remember me',
  description: 'Stay signed in on this device',
  value: rememberMe,
  onChanged: (value) {
    setState(() {
      rememberMe = value ?? false;
    });
  },
)

// Screen reader announces:
// 🔊 "Remember me. Stay signed in on this device. Checked. Checkbox."
```

### Pattern 6: Accessible Radio Group

```dart
class AccessibleRadioGroup<T> extends StatelessWidget {
  final String groupLabel;
  final List<RadioOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;

  const AccessibleRadioGroup({
    super.key,
    required this.groupLabel,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: groupLabel,
      hint: '${options.length} options',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              groupLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...options.map((option) {
            return Semantics(
              label: option.label,
              hint: option.description,
              selected: value == option.value,
              child: RadioListTile<T>(
                title: ExcludeSemantics(child: Text(option.label)),
                subtitle: option.description != null
                    ? ExcludeSemantics(child: Text(option.description!))
                    : null,
                value: option.value,
                groupValue: value,
                onChanged: onChanged,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class RadioOption<T> {
  final String label;
  final String? description;
  final T value;

  const RadioOption({
    required this.label,
    this.description,
    required this.value,
  });
}

// Usage:
AccessibleRadioGroup<String>(
  groupLabel: 'Shipping Method',
  value: selectedShipping,
  onChanged: (value) {
    setState(() {
      selectedShipping = value;
    });
  },
  options: const [
    RadioOption(
      label: 'Standard',
      description: '5-7 business days',
      value: 'standard',
    ),
    RadioOption(
      label: 'Express',
      description: '2-3 business days',
      value: 'express',
    ),
    RadioOption(
      label: 'Overnight',
      description: 'Next day delivery',
      value: 'overnight',
    ),
  ],
)

// Screen reader announces:
// 🔊 "Shipping Method. Heading. 3 options."
// 🔊 "Standard. 5-7 business days. Not selected. Radio button. 1 of 3."
// 🔊 "Express. 2-3 business days. Not selected. Radio button. 2 of 3."
// 🔊 "Overnight. Next day delivery. Selected. Radio button. 3 of 3."
```

---

## Loading and Error Patterns

### Pattern 7: Accessible Loading Indicator

```dart
class AccessibleLoadingIndicator extends StatelessWidget {
  final String message;

  const AccessibleLoadingIndicator({
    super.key,
    this.message = 'Loading',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      liveRegion: true,  // Announce changes immediately
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Screen reader announces immediately:
// 🔊 "Loading"
```

### Pattern 8: Accessible Error Message

```dart
class AccessibleErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AccessibleErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Error. $message',
      liveRegion: true,  // Announce immediately
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: const Icon(Icons.error, color: Colors.red),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ExcludeSemantics(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Screen reader announces:
// 🔊 "Error. Failed to load data"
// 🔊 "Try Again. Button."
```

---

## Navigation Patterns

### Pattern 9: Accessible Bottom Navigation

```dart
class AccessibleBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AccessibleBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Navigation bar',
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            tooltip: 'Go to home screen',  // Screen reader reads this
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Search',
            tooltip: 'Search for items',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            tooltip: 'View your profile',
          ),
        ],
      ),
    );
  }
}

// Screen reader announces:
// 🔊 "Navigation bar"
// 🔊 "Home. Tab 1 of 3. Selected."
// 🔊 "Search. Tab 2 of 3."
// 🔊 "Profile. Tab 3 of 3."
```

### Pattern 10: Accessible Drawer

```dart
class AccessibleDrawer extends StatelessWidget {
  const AccessibleDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Navigation drawer',
      scopesRoute: true,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Semantics(
                header: true,
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            _AccessibleDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _AccessibleDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _AccessibleDrawerItem(
              icon: Icons.help,
              title: 'Help',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessibleDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccessibleDrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      hint: 'Double tap to navigate to $title',
      child: ListTile(
        leading: ExcludeSemantics(child: Icon(icon)),
        title: ExcludeSemantics(child: Text(title)),
        onTap: onTap,
      ),
    );
  }
}
```

---

## Data Display Patterns

### Pattern 11: Accessible Table

```dart
class AccessibleTable extends StatelessWidget {
  const AccessibleTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Product comparison table',
      child: Table(
        border: TableBorder.all(),
        children: [
          // Header row
          TableRow(
            children: [
              _TableHeader('Product'),
              _TableHeader('Price'),
              _TableHeader('Rating'),
            ],
          ),
          // Data rows
          TableRow(
            children: [
              _TableCell('Phone', isHeader: true),
              _TableCell('\$999'),
              _TableCell('4.5 stars'),
            ],
          ),
          TableRow(
            children: [
              _TableCell('Laptop', isHeader: true),
              _TableCell('\$1,499'),
              _TableCell('4.8 stars'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: '$text column',
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ExcludeSemantics(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      header: isHeader,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ExcludeSemantics(child: Text(text)),
      ),
    );
  }
}

// Screen reader announces:
// 🔊 "Product comparison table"
// 🔊 "Product column. Heading."
// 🔊 "Price column. Heading."
// 🔊 "Rating column. Heading."
// 🔊 "Phone. Heading."
// 🔊 "$999"
// 🔊 "4.5 stars"
```

### Pattern 12: Accessible Chart/Graph Alternative

```dart
class AccessibleChart extends StatelessWidget {
  final List<ChartData> data;

  const AccessibleChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    final average = total / data.length;
    final max = data.reduce((a, b) => a.value > b.value ? a : b);
    final min = data.reduce((a, b) => a.value < b.value ? a : b);

    return Column(
      children: [
        // Visual chart
        Semantics(
          image: true,
          label: _generateChartDescription(),
          child: Container(
            height: 200,
            child: _buildChart(),  // Your chart widget
          ),
        ),
        const SizedBox(height: 16),
        // Text alternative for screen readers
        Semantics(
          label: 'Chart data summary',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: ${total.toStringAsFixed(2)}'),
                Text('Average: ${average.toStringAsFixed(2)}'),
                Text('Highest: ${max.label} (${max.value})'),
                Text('Lowest: ${min.label} (${min.value})'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _generateChartDescription() {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    final average = total / data.length;
    return 'Bar chart showing ${data.length} items. '
        'Total: ${total.toStringAsFixed(2)}. '
        'Average: ${average.toStringAsFixed(2)}.';
  }

  Widget _buildChart() {
    // Your chart implementation
    return const Placeholder();
  }
}

class ChartData {
  final String label;
  final double value;

  const ChartData(this.label, this.value);
}

// Screen reader announces:
// 🔊 "Bar chart showing 5 items. Total: 250.00. Average: 50.00. Image."
// 🔊 "Chart data summary"
// 🔊 "Total: 250.00"
// 🔊 "Average: 50.00"
// 🔊 "Highest: January (75)"
// 🔊 "Lowest: March (25)"
```

---

## Complete Example: Accessible Shopping App

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const AccessibleShoppingApp());
}

class AccessibleShoppingApp extends StatelessWidget {
  const AccessibleShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessible Shopping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Ensure minimum contrast
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 99.99,
      rating: 4.5,
      inStock: true,
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 299.99,
      rating: 4.8,
      inStock: true,
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 79.99,
      rating: 4.2,
      inStock: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Semantics(
        label: 'Product list with ${_products.length} items',
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return AccessibleProductCard(
              product: _products[index],
              position: index + 1,
              total: _products.length,
            );
          },
        ),
      ),
    );
  }
}

class AccessibleProductCard extends StatelessWidget {
  final Product product;
  final int position;
  final int total;

  const AccessibleProductCard({
    super.key,
    required this.product,
    required this.position,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Build comprehensive label for screen reader
    final availability = product.inStock ? 'In stock' : 'Out of stock';
    final label = '${product.name}. '
        '\$${product.price}. '
        '${product.rating} stars. '
        '$availability. '
        'Item $position of $total.';

    return Semantics(
      label: label,
      button: true,
      hint: 'Double tap to view product details',
      enabled: product.inStock,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: product.inStock
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: product),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Product image placeholder
                    ExcludeSemantics(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name
                          ExcludeSemantics(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Price
                          ExcludeSemantics(
                            child: Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Rating
                          ExcludeSemantics(
                            child: Row(
                              children: [
                                ...List.generate(5, (index) {
                                  if (index < product.rating.floor()) {
                                    return const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    );
                                  } else if (index < product.rating) {
                                    return const Icon(
                                      Icons.star_half,
                                      size: 16,
                                      color: Colors.amber,
                                    );
                                  } else {
                                    return Icon(
                                      Icons.star_border,
                                      size: 16,
                                      color: Colors.grey[400],
                                    );
                                  }
                                }),
                                const SizedBox(width: 4),
                                Text('${product.rating}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!product.inStock) ...[
                  const SizedBox(height: 8),
                  // Out of stock badge
                  ExcludeSemantics(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: product.inStock
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.inStock,
  });
}
```

---

## Best Practices Checklist

```
┌─────────────────────────────────────────────────────────┐
│        ACCESSIBILITY BEST PRACTICES                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  LABELS:                                                 │
│  ✅ Every interactive element has a label                │
│  ✅ Labels are clear and descriptive                     │
│  ✅ Labels describe purpose, not appearance              │
│  ✅ Icons have tooltips or labels                        │
│                                                          │
│  GROUPING:                                               │
│  ✅ Related content is grouped together                  │
│  ✅ Decorative elements are excluded                     │
│  ✅ Complex widgets have single combined label           │
│  ✅ Lists announce item position (1 of 5)               │
│                                                          │
│  FEEDBACK:                                               │
│  ✅ Loading states announce to screen reader             │
│  ✅ Errors announce immediately (live region)            │
│  ✅ Success messages are announced                       │
│  ✅ State changes are communicated                       │
│                                                          │
│  NAVIGATION:                                             │
│  ✅ Focus order is logical                               │
│  ✅ User can navigate to all content                     │
│  ✅ Navigation is consistent across screens              │
│  ✅ Skip navigation options provided                     │
│                                                          │
│  VISUAL:                                                 │
│  ✅ Touch targets are 48x48 minimum                      │
│  ✅ Text contrast is 4.5:1 minimum                       │
│  ✅ Focus indicators are visible                         │
│  ✅ Text can be resized without breaking                 │
│                                                          │
│  FORMS:                                                  │
│  ✅ Labels are associated with inputs                    │
│  ✅ Required fields are clearly marked                   │
│  ✅ Errors are specific and helpful                      │
│  ✅ Success is confirmed                                 │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│       ACCESSIBILITY PATTERNS SUMMARY                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  KEY PATTERNS:                                           │
│  • Accessible cards - Combine info into one label        │
│  • Accessible lists - Announce position                  │
│  • Accessible forms - Clear labels + validation          │
│  • Accessible navigation - Consistent + clear            │
│  • Accessible feedback - Immediate announcements         │
│                                                          │
│  REMEMBER:                                               │
│  1. Use built-in widgets when possible                   │
│  2. Add semantics to custom widgets                      │
│  3. Group related content                                │
│  4. Provide text alternatives                            │
│  5. Test with real screen readers                        │
│                                                          │
│  RESOURCES:                                              │
│  • Flutter Semantics docs                                │
│  • WCAG 2.1 guidelines                                   │
│  • Material Design accessibility                         │
│  • iOS Human Interface Guidelines                        │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** A form field fails validation. Besides showing red text, what should happen for a screen reader user?

<details>
<summary>Answer</summary>
The error should be announced (associated with the field), so a non-sighted user hears what went wrong, not just sees red.
</details>

**Q2.** A list shows "Loading..." then the items appear. Why announce the change?

<details>
<summary>Answer</summary>
So a screen reader user knows loading finished and content is ready, instead of being stuck on a silent screen.
</details>

**Q3.** Why give buttons clear labels like "Add to cart" instead of just an icon?

<details>
<summary>Answer</summary>
So the screen reader announces a meaningful action, not just "button" or an unhelpful icon name.
</details>

---

## Assignment

### Problem 1: Announce success

After a user adds an item to the cart, in one line describe what an accessible app should do beyond the visual change.

### Problem 2: Label a list item

A product tile shows an image, name, and price. What single combined label would help a screen reader user most?

### Problem 3: Pick the pattern

You have a long form. Name one accessibility practice that makes it easier to complete with a screen reader.

---

## Assignment Answers

### Problem 1: Announce success

Announce it (for example with a semantics live announcement or a clearly labeled SnackBar) so the screen reader says "Added to cart."

### Problem 2: Label a list item

A single semantic label combining all three, like "Red shoes, $40", so the user hears the whole item at once instead of three disconnected pieces.

### Problem 3: Pick the pattern

Any of: clear field labels, announce validation errors on the field, logical focus order, and group related fields so they read together.

---

**Congratulations!** You've mastered accessibility! Your apps are now usable by everyone! 🎉

---

[⬅️ Previous: Accessibility Testing](./09b-AccessibilityTesting.md) | [⬆️ Learning Path](./00-LearningPath.md) | [➡️ Next: Internationalization Basics](./10a-i18nBasics.md)
