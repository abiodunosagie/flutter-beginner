# Level 05 Capstone: Basic UI Screens

## What You're Building

Time to bring ShopEase to life! In this level, you'll create the **core UI components** and **basic screens**.

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 05 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase UI (First Screens!)                               │
│                                                              │
│   ┌─────────────────┐  ┌─────────────────┐                  │
│   │   Product Card  │  │  Product Grid   │                  │
│   │   ┌─────────┐   │  │  ┌───┐ ┌───┐   │                  │
│   │   │  Image  │   │  │  │ P │ │ P │   │                  │
│   │   ├─────────┤   │  │  └───┘ └───┘   │                  │
│   │   │  Name   │   │  │  ┌───┐ ┌───┐   │                  │
│   │   │  Price  │   │  │  │ P │ │ P │   │                  │
│   │   │ ⭐ 4.5  │   │  │  └───┘ └───┘   │                  │
│   │   └─────────┘   │  └─────────────────┘                  │
│   └─────────────────┘                                        │
│                                                              │
│   ┌─────────────────┐  ┌─────────────────┐                  │
│   │   Cart Item     │  │  Home Screen    │                  │
│   │  ┌────┬──────┐  │  │  ┌───────────┐  │                  │
│   │  │Img │Name  │  │  │  │  Search   │  │                  │
│   │  │    │$29.99│  │  │  ├───────────┤  │                  │
│   │  │    │ -1+  │  │  │  │Categories │  │                  │
│   │  └────┴──────┘  │  │  │ Products  │  │                  │
│   └─────────────────┘  └─────────────────┘                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: ProductCard Widget

```dart
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  // Displays:
  // - Product image
  // - Name (max 2 lines)
  // - Price (formatted)
  // - Rating stars
  // - "Add to Cart" button
}
```

### Task 2: CartItemTile Widget

```dart
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  // Displays:
  // - Product thumbnail
  // - Name and price
  // - Quantity controls (- / + buttons)
  // - Remove button
  // - Line total
}
```

### Task 3: CategoryChip Widget

```dart
class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  // Displays:
  // - Category name
  // - Selected/unselected style
}
```

### Task 4: Home Screen Layout

```dart
class HomeScreen extends StatelessWidget {
  // Structure:
  // - AppBar with logo and cart icon
  // - Search bar
  // - Horizontal category chips
  // - "Featured Products" section
  // - Product grid
}
```

---

## Starter Code

```dart
// lib/widgets/product_card.dart
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                // TODO: Add error and loading builders
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Text(
                    product.formattedPrice,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Rating
                  // TODO: Add rating stars

                  // Add to Cart button
                  // TODO: Add button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Categories
          // TODO: Add horizontal category list

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 10, // TODO: Use actual product count
              itemBuilder: (context, index) {
                // TODO: Return ProductCard
                return const Placeholder();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Visual Reference

```
┌────────────────────────────────────────┐
│  🛍️ ShopEase                      🛒  │
├────────────────────────────────────────┤
│  ┌──────────────────────────────────┐  │
│  │ 🔍  Search products...           │  │
│  └──────────────────────────────────┘  │
│                                        │
│  [All] [Clothing] [Electronics] [Home] │
│                                        │
│  ┌───────────┐  ┌───────────┐          │
│  │   ┌───┐   │  │   ┌───┐   │          │
│  │   │ 📷│   │  │   │ 📷│   │          │
│  │   └───┘   │  │   └───┘   │          │
│  │ T-Shirt   │  │ Sneakers  │          │
│  │ $29.99    │  │ $89.99    │          │
│  │ ⭐⭐⭐⭐☆  │  │ ⭐⭐⭐⭐⭐ │          │
│  │ [Add 🛒]  │  │ [Add 🛒]  │          │
│  └───────────┘  └───────────┘          │
│                                        │
│  ┌───────────┐  ┌───────────┐          │
│  │   ┌───┐   │  │   ┌───┐   │          │
│  │   │ 📷│   │  │   │ 📷│   │          │
│  │   └───┘   │  │   └───┘   │          │
│  │ Headphones│  │ Watch     │          │
│  │ $149.99   │  │ $299.99   │          │
│  │ ⭐⭐⭐⭐⭐ │  │ ⭐⭐⭐⭐☆  │          │
│  │ [Add 🛒]  │  │ [Add 🛒]  │          │
│  └───────────┘  └───────────┘          │
└────────────────────────────────────────┘
```

---

## Success Criteria

- [ ] ProductCard displays all info correctly
- [ ] Images load with placeholder/error states
- [ ] Rating shows correct number of stars
- [ ] CartItemTile quantity buttons work
- [ ] HomeScreen has working search bar
- [ ] Category chips are scrollable
- [ ] Grid adapts to screen size

---

## Bonus Challenge

- [ ] Add skeleton loading state for products
- [ ] Add "Sale" badge for discounted items
- [ ] Add pull-to-refresh on product grid
- [ ] Add hero animation on product image

---

## Files to Create

```
shopease/
└── lib/
    ├── models/         (from Levels 01-04)
    │
    ├── widgets/        ◄── Create folder
    │   ├── product_card.dart
    │   ├── cart_item_tile.dart
    │   ├── category_chip.dart
    │   ├── rating_stars.dart
    │   └── search_bar.dart
    │
    └── screens/        ◄── Create folder
        └── home/
            └── home_screen.dart
```

---

**Your ShopEase app is visible now!**
