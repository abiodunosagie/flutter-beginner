# Hero Animations: Magical Transitions Between Screens

## What You'll Learn

In this comprehensive lesson, you'll master:
- What Hero animations are and why they're amazing
- Creating basic Hero transitions
- Customizing Hero animations
- Hero animations with different shapes
- Radial Hero animations
- Troubleshooting Hero animations
- Real-world examples (image galleries, product details)
- Best practices and performance tips
- 5 progressive exercises

By the end, you'll create stunning transitions that guide users through your app!

## Understanding Hero Animations (Like Teaching a 5-Year-Old)

### What is a Hero Animation?

Imagine watching a superhero movie:

**Without Hero Animation:**
```
Scene 1: Superman standing in city 🦸
*Scene cuts abruptly*
Scene 2: Superman flying in sky 🦸‍♂️

Viewer: "Wait, how did he get there?" 😕
```

**With Hero Animation:**
```
Scene 1: Superman standing in city 🦸
*Camera follows Superman smoothly as he flies up*
Scene 2: Superman now flying in sky 🦸‍♂️

Viewer: "Ah, I see the journey!" 😊
```

**In Flutter:**
- You tap a thumbnail image
- The image "flies" from thumbnail to full screen
- Smooth, guided transition
- User understands the connection!

### Real-Life Examples

**Photo Gallery:**
```
Grid View:  📸 📸 📸
            📸 📸 📸

*Tap one photo*

Photo "flies" from grid → Full screen ✨
```

**Product List:**
```
List: [Product Card 1]
      [Product Card 2]
      [Product Card 3]

*Tap Product 2*

Card "morphs" into detailed product page ✨
```

**Profile Avatar:**
```
Small avatar in corner → Large profile picture ✨
```

## Part 1: Basic Hero Animation

### Simple Example

```dart
// Screen 1: List of items
class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hero Animation')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Hero(
              tag: 'hero-$index',  // MUST be unique!
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('${index + 1}'),
              ),
            ),
            title: Text('Item ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(index: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen 2: Detail view
class DetailScreen extends StatelessWidget {
  final int index;

  DetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Hero(
          tag: 'hero-$index',  // SAME tag as first screen!
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**What happens:**
1. User taps item in list
2. CircleAvatar smoothly "flies" from list to center
3. Grows from small to large
4. When user goes back, reverses smoothly!

**Key Points:**
- Both screens need `Hero` widget
- **SAME tag** on both screens
- Tag must be **unique** (no duplicates on same screen)
- Flutter handles everything else automatically! ✨

## Part 2: Hero with Images

### Image Gallery Example

```dart
class ImageGallery extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
    'https://picsum.photos/200/300?random=6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery')),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageDetailScreen(
                    imageUrl: imageUrls[index],
                    tag: 'image-$index',
                  ),
                ),
              );
            },
            child: Hero(
              tag: 'image-$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  ImageDetailScreen({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
```

**Result:**
- Tap thumbnail → Image flies to full screen
- Maintains aspect ratio during transition
- Smooth and beautiful! ✨

## Part 3: Customizing Hero Animations

### Custom Flight Path

```dart
class CustomHeroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Hero')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomHeroDetailScreen(),
              ),
            );
          },
          child: Hero(
            tag: 'custom-hero',
            // Custom flight behavior
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return ScaleTransition(
                scale: animation,
                child: RotationTransition(
                  turns: animation,
                  child: Material(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.star,
                      size: 100,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              );
            },
            child: Icon(Icons.star, size: 50, color: Colors.yellow),
          ),
        ),
      ),
    );
  }
}

class CustomHeroDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Hero(
          tag: 'custom-hero',
          child: Icon(Icons.star, size: 200, color: Colors.yellow),
        ),
      ),
    );
  }
}
```

### Custom Animation Curve

```dart
Hero(
  tag: 'my-hero',
  createRectTween: (begin, end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  },
  child: YourWidget(),
)
```

## Part 4: Shape-Morphing Heroes

### Circle to Square

```dart
class ShapeMorphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shape Morph')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SquareScreen(),
              ),
            );
          },
          child: Hero(
            tag: 'shape',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SquareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Square')),
      body: Center(
        child: Hero(
          tag: 'shape',
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
```

**Magic:** Flutter automatically morphs circle → rounded square!

## Part 5: Radial Hero Animation

Perfect for expanding cards!

```dart
class ProductCard extends StatelessWidget {
  final String productName;
  final String imageUrl;

  ProductCard({required this.productName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ProductDetailScreen(
                  productName: productName,
                  imageUrl: imageUrl,
                );
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'product-image-$productName',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(
                productName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productName;
  final String imageUrl;

  ProductDetailScreen({required this.productName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-image-$productName',
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
```

## Part 6: Multiple Heroes in One Transition

```dart
class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileDetailScreen(),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'profile-avatar',
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=1',
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'profile-name',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'profile-email',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'john@example.com',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          SizedBox(height: 40),
          Hero(
            tag: 'profile-avatar',
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=1',
              ),
            ),
          ),
          SizedBox(height: 24),
          Hero(
            tag: 'profile-name',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Hero(
            tag: 'profile-email',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'john@example.com',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Bio: Software developer passionate about creating beautiful apps.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Result:** Avatar, name, and email all animate to new positions simultaneously!

## Part 7: Troubleshooting Hero Animations

### Common Issues

**Issue 1: "There are multiple heroes that share the same tag"**
```dart
// ❌ BAD: Duplicate tags
ListView(
  children: [
    Hero(tag: 'hero', child: Widget1()),
    Hero(tag: 'hero', child: Widget2()),  // DUPLICATE!
  ],
)

// ✅ GOOD: Unique tags
ListView.builder(
  itemBuilder: (context, index) {
    return Hero(
      tag: 'hero-$index',  // Each is unique
      child: WidgetN(),
    );
  },
)
```

**Issue 2: Hero animation looks janky**
```dart
// ✅ Wrap text in Material to prevent errors
Hero(
  tag: 'text',
  child: Material(
    color: Colors.transparent,
    child: Text('Hello'),
  ),
)
```

**Issue 3: Background color flashes**
```dart
// ✅ Set backgroundColor on Hero
Hero(
  tag: 'image',
  child: Image.network(url),
  backgroundColor: Colors.transparent,
)
```

## Part 8: Best Practices

### 1. Always Wrap Text in Material

```dart
// ✅ GOOD
Hero(
  tag: 'title',
  child: Material(
    color: Colors.transparent,
    child: Text('Title'),
  ),
)
```

### 2. Use Unique Tags

```dart
// ✅ GOOD: Include unique identifier
Hero(
  tag: 'product-${product.id}',
  child: ProductImage(),
)
```

### 3. Match Widget Types

```dart
// ✅ GOOD: Both are Images
// Screen 1
Hero(tag: 'img', child: Image.network(url))

// Screen 2
Hero(tag: 'img', child: Image.network(url))


// ⚠️ WORKS but may look weird
// Screen 1
Hero(tag: 'img', child: Image.network(url))

// Screen 2
Hero(tag: 'img', child: Icon(Icons.image))
```

### 4. Handle Transparent Backgrounds

```dart
Hero(
  tag: 'icon',
  child: Material(
    color: Colors.transparent,
    child: Icon(Icons.star),
  ),
)
```

## Exercises

### Exercise 1: Simple Photo Gallery (Beginner)

Create a photo gallery with Hero transitions.

**Requirements:**
- Grid of 6 thumbnail images
- Tap thumbnail to view full screen
- Hero animation from thumbnail to full screen
- Back button to return

### Exercise 2: Contact List (Beginner-Intermediate)

Build a contact list with Hero animations.

**Requirements:**
- List of contacts with avatar and name
- Both avatar AND name animate to detail screen
- Detail screen shows large avatar, name, phone, email
- Multiple Hero widgets in one transition

### Exercise 3: Product Catalog (Intermediate)

Create a product catalog with Hero animations.

**Requirements:**
- Grid of product cards (image, name, price)
- Tap to view product details
- Product image expands to fill app bar
- Name and price also animate
- Add to cart button on detail screen

### Exercise 4: Social Media Profile (Intermediate-Advanced)

Build a social profile viewer with Hero animations.

**Requirements:**
- Feed shows posts with small profile picture
- Tap profile picture to view full profile
- Profile picture expands
- Username animates
- Custom flight path (arc animation)
- Stats counter animates in

### Exercise 5: Custom Hero Flight (Advanced)

Create custom Hero animation with rotation and scaling.

**Requirements:**
- Small icon in corner
- Tap to expand to center
- Icon rotates 360° during flight
- Scale changes with custom curve
- Different animation going back
- Use flightShuttleBuilder

## What You've Learned

✅ What Hero animations are and why they're powerful
✅ Creating basic Hero transitions
✅ Hero with images
✅ Customizing Hero flight paths
✅ Shape-morphing animations
✅ Multiple Heroes in one transition
✅ Troubleshooting common issues
✅ Best practices for smooth animations
✅ Real-world examples (galleries, profiles, products)

## Next Steps

In the next lesson, we'll explore **Custom Animations with CustomPainter** - drawing your own animations from scratch!

You're creating magical transitions! 🚀
