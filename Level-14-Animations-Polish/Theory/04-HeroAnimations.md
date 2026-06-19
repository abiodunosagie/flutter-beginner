# Hero Animations

## The Big Idea In One Sentence

> A Hero animation makes one element fly smoothly between two screens: wrap the same widget in a `Hero` with the same `tag` on both screens, and Flutter animates it across the transition.

## The Simple Explanation

Hero animations make an element "fly" from one screen to another. It's like a character teleporting between locations but we see the journey!

```
┌─────────────────────────────────────────────────────────────┐
│                  HERO ANIMATION                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SCREEN A                              SCREEN B              │
│  ┌────────────┐                       ┌────────────┐        │
│  │            │                       │            │        │
│  │  ┌──┐      │       ~~~~>          │  ┌──────┐  │        │
│  │  │🖼│      │    Image flies        │  │      │  │        │
│  │  └──┘      │    across screens     │  │  🖼  │  │        │
│  │  Title     │                       │  │      │  │        │
│  └────────────┘                       │  └──────┘  │        │
│                                       │  Title     │        │
│                                       └────────────┘        │
│                                                              │
│  The image smoothly transforms from small to large!         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Basic Hero Setup

```dart
// STEP 1: On the source screen, wrap the widget with Hero

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [...];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Hero(
            // The tag MUST match on both screens!
            tag: 'product-image-${product.id}',
            child: Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
            ),
          ),
        );
      },
    );
  }
}

// STEP 2: On the destination screen, use the SAME tag

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            // SAME tag as source screen!
            tag: 'product-image-${product.id}',
            child: Image.network(
              product.imageUrl,
              width: 300,
              height: 300,
            ),
          ),
          Text(product.name),
          Text(product.description),
        ],
      ),
    );
  }
}
```

```
HERO RULES:
1. Both screens need a Hero widget
2. Both Heroes must have the SAME tag
3. The tag must be UNIQUE on each screen
4. Flutter handles the animation automatically!
```

---

## Understanding Hero Tags

```dart
// Tags identify which widgets should animate together

// ✅ GOOD: Unique tag per item
Hero(tag: 'product-${product.id}', child: ...)
Hero(tag: 'avatar-${user.id}', child: ...)
Hero(tag: 'thumbnail-${photo.id}', child: ...)

// ❌ BAD: Non-unique tags cause errors
Hero(tag: 'image', child: ...)  // All items have same tag!

// ✅ GOOD: String tags
Hero(tag: 'profile-picture', child: ...)

// ✅ GOOD: Object tags (must implement == and hashCode)
Hero(tag: product, child: ...)  // If Product has proper equality
```

---

## Hero with Different Widgets

The child widgets don't have to be identical - Hero animates the transition:

```dart
// Source: Small circular avatar
Hero(
  tag: 'user-avatar',
  child: CircleAvatar(
    radius: 25,
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
)

// Destination: Large rectangular image
Hero(
  tag: 'user-avatar',
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.network(
      user.avatarUrl,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    ),
  ),
)

// Hero will smoothly morph from circle to rounded rectangle!
```

---

## Customizing Hero Transitions

### Custom Flight Shape

```dart
Hero(
  tag: 'my-hero',
  // Control the shape during flight
  flightShuttleBuilder: (
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20 * (1 - animation.value),  // Animate border radius
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20 * animation.value,  // Animate shadow
              ),
            ],
          ),
          child: child,
        );
      },
      child: Image.network(imageUrl),
    );
  },
  child: Image.network(imageUrl),
)
```

### Placeholder During Flight

```dart
Hero(
  tag: 'my-hero',
  // What to show in the original position while flying
  placeholderBuilder: (context, heroSize, child) {
    return Container(
      width: heroSize.width,
      height: heroSize.height,
      color: Colors.grey[300],  // Placeholder color
    );
  },
  child: Image.network(imageUrl),
)
```

---

## Hero with Text

Text can be tricky because styles change. Use `Material` to fix:

```dart
// Without Material: Text might look broken during animation
Hero(
  tag: 'product-title-${product.id}',
  child: Text(
    product.name,
    style: TextStyle(fontSize: 16),
  ),
)

// ✅ With Material: Smooth text transition
Hero(
  tag: 'product-title-${product.id}',
  child: Material(
    color: Colors.transparent,
    child: Text(
      product.name,
      style: TextStyle(fontSize: 16),
    ),
  ),
)
```

---

## Complete Example: Photo Gallery

```dart
// --- Photo Model ---
class Photo {
  final String id;
  final String url;
  final String title;

  Photo({required this.id, required this.url, required this.title});
}

// --- Gallery Screen (Source) ---
class GalleryScreen extends StatelessWidget {
  final List<Photo> photos = [
    Photo(id: '1', url: 'https://picsum.photos/200', title: 'Beach'),
    Photo(id: '2', url: 'https://picsum.photos/201', title: 'Mountain'),
    Photo(id: '3', url: 'https://picsum.photos/202', title: 'City'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhotoDetailScreen(photo: photo),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero for the image
                  Hero(
                    tag: 'photo-${photo.id}',
                    child: Image.network(
                      photo.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Hero for the title
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Hero(
                      tag: 'title-${photo.id}',
                      child: Material(
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            photo.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- Photo Detail Screen (Destination) ---
class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hero image - expanded
              Hero(
                tag: 'photo-${photo.id}',
                child: Image.network(
                  photo.url,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),
              // Hero title - larger
              Hero(
                tag: 'title-${photo.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    photo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Custom Page Transitions with Hero

Make the page transition complement the Hero:

```dart
// Custom fade transition
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return PhotoDetailScreen(photo: photo);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  ),
);

// Custom slide + fade transition
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return DetailScreen();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 0.1), end: Offset.zero);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  ),
);
```

---

## Hero Animation Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│            HERO ANIMATION BEST PRACTICES                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DO:                                                         │
│  ✓ Use unique tags (include item ID)                        │
│  ✓ Wrap text in Material widget                             │
│  ✓ Keep Hero children relatively simple                     │
│  ✓ Use ClipRRect for rounded corners                        │
│  ✓ Test on real devices (animations may differ)             │
│                                                              │
│  DON'T:                                                      │
│  ✗ Use the same tag for multiple items on screen            │
│  ✗ Put too much content inside Hero                         │
│  ✗ Animate Hero with very different aspect ratios           │
│  ✗ Forget to match tags exactly                             │
│                                                              │
│  PERFORMANCE TIPS:                                           │
│  • Cache network images (cached_network_image package)      │
│  • Use smaller images on list screens                       │
│  • Avoid heavy widgets inside Hero                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Hero Problems

```dart
// PROBLEM 1: Duplicate tags
// Error: "There are multiple heroes that share the same tag"
// FIX: Make tags unique per item
Hero(tag: 'avatar')           // ❌ Same tag for all
Hero(tag: 'avatar-${user.id}') // ✅ Unique per user

// PROBLEM 2: Hero only on one screen
// Nothing animates
// FIX: Add Hero widget on BOTH screens with same tag

// PROBLEM 3: Text looks broken during animation
// FIX: Wrap in Material widget
Hero(
  tag: 'text',
  child: Material(
    color: Colors.transparent,
    child: Text('Hello'),
  ),
)

// PROBLEM 4: Widget disappears during animation
// FIX: Check that both widgets have proper constraints/size
// Make sure images are loaded before navigating
```

---

## Advanced: Nested Heroes

Be careful with multiple Heroes on the same screen:

```dart
// Product card with multiple Hero elements
class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Image Hero
          Hero(
            tag: 'product-image-${product.id}',
            child: Image.network(product.imageUrl),
          ),
          // Title Hero
          Hero(
            tag: 'product-title-${product.id}',
            child: Material(
              color: Colors.transparent,
              child: Text(product.name),
            ),
          ),
          // Price Hero
          Hero(
            tag: 'product-price-${product.id}',
            child: Material(
              color: Colors.transparent,
              child: Text('\$${product.price}'),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│             HERO ANIMATIONS SUMMARY                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BASIC SETUP:                                                │
│  1. Wrap widget with Hero on source screen                  │
│  2. Wrap widget with Hero on destination screen             │
│  3. Use SAME tag on both                                    │
│  4. Flutter animates automatically!                          │
│                                                              │
│  KEY PROPERTIES:                                             │
│  ├── tag - Required, must match on both screens             │
│  ├── child - The widget to animate                          │
│  ├── flightShuttleBuilder - Custom flight appearance        │
│  └── placeholderBuilder - What shows in original spot       │
│                                                              │
│  TIPS:                                                       │
│  ├── Use unique tags: 'item-${id}'                          │
│  ├── Wrap text in Material                                  │
│  ├── Keep Hero children simple                              │
│  └── Use PageRouteBuilder for custom transitions            │
│                                                              │
│  COMMON USES:                                                │
│  ├── Photo galleries → Full screen view                     │
│  ├── Product lists → Product details                        │
│  ├── Profile cards → Profile pages                          │
│  └── Avatar icons → User profiles                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What must match for a Hero animation to work across two screens?

<details>
<summary>Answer</summary>
The `tag` on the `Hero` widget must be the same on both screens.
</details>

**Q2.** What does a Hero animation look like to the user?

<details>
<summary>Answer</summary>
The element (like a photo) smoothly flies and grows/shrinks from its spot on screen A to its spot on screen B.
</details>

**Q3.** A common bug: two Heroes on the same screen share a tag. What happens?

<details>
<summary>Answer</summary>
Flutter throws an error, because tags must be unique on a given screen.
</details>

---

## Assignment

### Problem 1: Wire a Hero

A product image appears on a list screen and a details screen. What do you wrap it in, and what must be equal?

### Problem 2: Unique tags

For a list of 10 products, how do you keep each Hero tag unique?

### Problem 3: When to use

Name a good real-world use for a Hero animation.

---

## Assignment Answers

### Problem 1: Wire a Hero

Wrap the image in a `Hero` on both screens, and make the `tag` the same on both (e.g. `Hero(tag: product.id, child: Image(...))`).

### Problem 2: Unique tags

Use something unique per item as the tag, like the product's id, so no two Heroes on a screen share a tag.

### Problem 3: When to use

Tapping a thumbnail in a list to open a full-screen detail, where the image flies into place. (Also profile avatars, gallery photos.)

---

**Next:** `05-PolishMicrointeractions.md` - Making your app feel polished
