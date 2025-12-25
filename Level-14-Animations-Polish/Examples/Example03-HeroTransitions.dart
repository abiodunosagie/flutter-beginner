// ============================================
// EXAMPLE 03: HERO TRANSITIONS
// Smooth shared element animations between screens
// ============================================

/*
  Hero animations create a visual connection between screens
  by animating a widget from its position on one screen to
  its position on another screen.

  KEY RULES:
  1. Wrap widgets with Hero on BOTH screens
  2. Use the SAME tag on both screens
  3. Tags must be UNIQUE per screen

  NOTE: Copy this code into a real Flutter project to run it.
*/

// ============================================
// COMPLETE HERO EXAMPLE - PHOTO GALLERY
// ============================================

/*
import 'package:flutter/material.dart';

void main() => runApp(const HeroGalleryApp());

class HeroGalleryApp extends StatelessWidget {
  const HeroGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GalleryScreen(),
    );
  }
}

// --- Photo Model ---
class Photo {
  final String id;
  final String url;
  final String title;
  final String description;

  const Photo({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
  });
}

// --- Sample Data ---
const List<Photo> samplePhotos = [
  Photo(
    id: '1',
    url: 'https://picsum.photos/id/10/400/400',
    title: 'Forest Trail',
    description: 'A beautiful path through the forest.',
  ),
  Photo(
    id: '2',
    url: 'https://picsum.photos/id/15/400/400',
    title: 'Mountain Peak',
    description: 'Stunning view from the top.',
  ),
  Photo(
    id: '3',
    url: 'https://picsum.photos/id/20/400/400',
    title: 'Ocean Sunset',
    description: 'Golden hour at the beach.',
  ),
  Photo(
    id: '4',
    url: 'https://picsum.photos/id/25/400/400',
    title: 'City Lights',
    description: 'Urban landscape at night.',
  ),
];

// --- Gallery Screen (Source) ---
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: samplePhotos.length,
        itemBuilder: (context, index) {
          final photo = samplePhotos[index];
          return PhotoCard(photo: photo);
        },
      ),
    );
  }
}

// --- Photo Card Widget ---
class PhotoCard extends StatelessWidget {
  final Photo photo;

  const PhotoCard({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
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
            // HERO for the image
            Hero(
              tag: 'photo-${photo.id}',
              child: Image.network(
                photo.url,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                // HERO for the title
                child: Hero(
                  tag: 'title-${photo.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      photo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
  }
}

// --- Photo Detail Screen (Destination) ---
class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),

              // Expanded image with Hero
              Expanded(
                child: Center(
                  child: Hero(
                    tag: 'photo-${photo.id}',
                    child: Image.network(
                      photo.url,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),

              // Title and description
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HERO for the title
                    Hero(
                      tag: 'title-${photo.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          photo.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      photo.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

// ============================================
// HERO WITH CUSTOM FLIGHT ANIMATION
// ============================================

/*
class CustomFlightHero extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const CustomFlightHero({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      // Custom flight animation
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
                  20 * (1 - animation.value),  // Morphs from round to square
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20 * animation.value,
                    spreadRadius: 5 * animation.value,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20 * (1 - animation.value)),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            );
          },
        );
      },
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
*/

// ============================================
// HERO WITH PLACEHOLDER
// ============================================

/*
class PlaceholderHero extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const PlaceholderHero({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      // What to show where the hero was
      placeholderBuilder: (context, heroSize, child) {
        return Container(
          width: heroSize.width,
          height: heroSize.height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.image, color: Colors.grey),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
*/

// ============================================
// PRODUCT CARD HERO EXAMPLE
// ============================================

/*
class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductDetailScreen(
              id: id,
              name: name,
              imageUrl: imageUrl,
              price: price,
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Hero
            Hero(
              tag: 'product-image-$id',
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Hero
                  Hero(
                    tag: 'product-name-$id',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Price Hero
                  Hero(
                    tag: 'product-price-$id',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '\$$price',
                        style: const TextStyle(color: Colors.green),
                      ),
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

class ProductDetailScreen extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // Image Hero
              background: Hero(
                tag: 'product-image-$id',
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Hero
                  Hero(
                    tag: 'product-name-$id',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price Hero
                  Hero(
                    tag: 'product-price-$id',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Product description goes here...'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

// ============================================
// VISUAL SUMMARY
// ============================================
/*
  ┌─────────────────────────────────────────────────────────────┐
  │              HERO TRANSITION EXAMPLES                        │
  ├─────────────────────────────────────────────────────────────┤
  │                                                              │
  │  BASIC HERO:                                                 │
  │  Source: Hero(tag: 'photo-1', child: smallImage)            │
  │  Dest:   Hero(tag: 'photo-1', child: largeImage)            │
  │  → Flutter animates between them automatically!             │
  │                                                              │
  │  MULTIPLE HEROES:                                            │
  │  • 'product-image-$id'  → Image expands                     │
  │  • 'product-name-$id'   → Title resizes                     │
  │  • 'product-price-$id'  → Price moves                       │
  │                                                              │
  │  CUSTOM FLIGHT:                                              │
  │  flightShuttleBuilder: (context, animation, ...) {          │
  │    return AnimatedBuilder(                                  │
  │      animation: animation,                                   │
  │      builder: (context, child) {                            │
  │        // Custom animation during flight                    │
  │      },                                                      │
  │    );                                                        │
  │  }                                                           │
  │                                                              │
  │  PLACEHOLDER:                                                │
  │  placeholderBuilder: (context, size, child) {               │
  │    return Container(color: Colors.grey);                    │
  │  }                                                           │
  │                                                              │
  │  TIPS:                                                       │
  │  1. Tags MUST match exactly on both screens                 │
  │  2. Tags MUST be unique per screen                          │
  │  3. Wrap text in Material for smooth transitions            │
  │  4. Use PageRouteBuilder for custom page animations         │
  │                                                              │
  └─────────────────────────────────────────────────────────────┘
*/
