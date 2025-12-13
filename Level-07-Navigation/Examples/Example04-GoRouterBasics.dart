// Example 04: GoRouter Basics
// Modern declarative routing in Flutter

// pubspec.yaml dependencies:
// go_router: ^14.0.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

class Book {
  final String id;
  final String title;
  final String author;
  final String emoji;
  final String description;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.emoji,
    required this.description,
  });
}

// Sample books
final books = [
  const Book(
    id: '1',
    title: 'The Flutter Way',
    author: 'Jane Developer',
    emoji: '📱',
    description: 'Master Flutter development with practical examples.',
  ),
  const Book(
    id: '2',
    title: 'Dart Fundamentals',
    author: 'John Coder',
    emoji: '🎯',
    description: 'Learn Dart from scratch with clear explanations.',
  ),
  const Book(
    id: '3',
    title: 'State Management',
    author: 'Sarah Smith',
    emoji: '🔄',
    description: 'Deep dive into state management patterns.',
  ),
  const Book(
    id: '4',
    title: 'Navigation Patterns',
    author: 'Mike Routes',
    emoji: '🧭',
    description: 'Everything about navigation in Flutter apps.',
  ),
];

// Helper to find book by ID
Book? findBookById(String id) {
  try {
    return books.firstWhere((b) => b.id == id);
  } catch (e) {
    return null;
  }
}

// ═══════════════════════════════════════════════════════════════
// ROUTER CONFIGURATION
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true, // Enable for debugging

  routes: [
    // ─────────────────────────────────────────
    // HOME ROUTE
    // ─────────────────────────────────────────
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // ─────────────────────────────────────────
    // BOOKS LIST ROUTE
    // ─────────────────────────────────────────
    GoRoute(
      path: '/books',
      name: 'books',
      builder: (context, state) => const BooksScreen(),
    ),

    // ─────────────────────────────────────────
    // BOOK DETAIL ROUTE (with path parameter)
    // ─────────────────────────────────────────
    GoRoute(
      path: '/book/:id',
      name: 'book-detail',
      builder: (context, state) {
        // Get path parameter
        final bookId = state.pathParameters['id']!;

        // Try to get book from extra (if passed), otherwise find by ID
        final book = state.extra as Book? ?? findBookById(bookId);

        return BookDetailScreen(
          bookId: bookId,
          book: book,
        );
      },
    ),

    // ─────────────────────────────────────────
    // SEARCH ROUTE (with query parameters)
    // ─────────────────────────────────────────
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) {
        // Get query parameters
        final query = state.uri.queryParameters['q'] ?? '';
        final category = state.uri.queryParameters['category'];

        return SearchScreen(
          initialQuery: query,
          category: category,
        );
      },
    ),

    // ─────────────────────────────────────────
    // PROFILE ROUTE
    // ─────────────────────────────────────────
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // ─────────────────────────────────────────
    // SETTINGS ROUTE
    // ─────────────────────────────────────────
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],

  // ─────────────────────────────────────────
  // ERROR PAGE (404)
  // ─────────────────────────────────────────
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error.toString());
  },
);

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      // Use the router!
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME SCREEN
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate with query parameters
              context.push('/search?q=flutter&category=mobile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📚', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              const Text(
                'Book Store',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Using GoRouter for navigation',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // Navigate using context.push (adds to stack)
              _NavButton(
                icon: Icons.library_books,
                label: 'Browse Books',
                onPressed: () {
                  context.push('/books');
                },
              ),
              const SizedBox(height: 12),

              // Navigate using context.go (replaces stack)
              _NavButton(
                icon: Icons.search,
                label: 'Search',
                onPressed: () {
                  context.push('/search');
                },
              ),
              const SizedBox(height: 12),

              // Navigate by name
              _NavButton(
                icon: Icons.person,
                label: 'Profile',
                onPressed: () {
                  context.pushNamed('profile');
                },
              ),
              const SizedBox(height: 12),

              // Direct to book with ID
              _NavButton(
                icon: Icons.book,
                label: 'Go to Book #2',
                onPressed: () {
                  context.push('/book/2');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/settings'),
        child: const Icon(Icons.settings),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOOKS LIST SCREEN
// ═══════════════════════════════════════════════════════════════

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(book.emoji, style: const TextStyle(fontSize: 24)),
              ),
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // ─────────────────────────────────────────
                // Navigate with path parameter AND extra data
                // ─────────────────────────────────────────
                context.push('/book/${book.id}', extra: book);
              },
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOOK DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════

class BookDetailScreen extends StatelessWidget {
  final String bookId;
  final Book? book;

  const BookDetailScreen({
    super.key,
    required this.bookId,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📖❓', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 20),
              Text('Book #$bookId not found'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/books'),
                child: const Text('Browse Books'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book!.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book cover
            Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(book!.emoji, style: const TextStyle(fontSize: 80)),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              book!.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Author
            Text(
              'by ${book!.author}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),

            // ID Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: $bookId',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(book!.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Navigation info
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Route Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Path: ${GoRouterState.of(context).uri.path}'),
                    Text('Full URI: ${GoRouterState.of(context).uri}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added "${book!.title}" to cart!')),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SEARCH SCREEN (with query parameters)
// ═══════════════════════════════════════════════════════════════

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  final String? category;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
    this.category,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    // Update URL without query
                    context.go('/search');
                  },
                ),
              ),
              onSubmitted: (value) {
                // Update URL with query
                context.go('/search?q=$value');
              },
            ),
            const SizedBox(height: 16),

            // Show current query info
            if (widget.initialQuery.isNotEmpty || widget.category != null)
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.initialQuery.isNotEmpty)
                        Text('Query: "${widget.initialQuery}"'),
                      if (widget.category != null)
                        Text('Category: ${widget.category}'),
                      Text(
                        'URL: ${GoRouterState.of(context).uri}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Quick search suggestions
            const Text('Quick Searches:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SearchChip(label: 'Flutter', query: 'flutter'),
                _SearchChip(label: 'Dart', query: 'dart'),
                _SearchChip(label: 'State', query: 'state'),
                _SearchChip(label: 'Navigation', query: 'navigation'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final String query;

  const _SearchChip({required this.label, required this.query});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        context.go('/search?q=$query');
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Text('👤', style: TextStyle(fontSize: 50)),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Reader',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('john.reader@example.com', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 30),

            // Navigation examples
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Go Home (replace)'),
              subtitle: const Text('Uses context.go()'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/'),  // Replaces stack!
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ═══════════════════════════════════════════════════════════════

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.notifications), title: Text('Notifications')),
          ListTile(leading: Icon(Icons.dark_mode), title: Text('Dark Mode')),
          ListTile(leading: Icon(Icons.language), title: Text('Language')),
          ListTile(leading: Icon(Icons.info), title: Text('About')),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ERROR SCREEN
// ═══════════════════════════════════════════════════════════════

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(error, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. GoRouter Setup
 *    - MaterialApp.router + routerConfig
 *    - Define routes with GoRoute
 *
 * 2. Navigation Methods
 *    - context.push('/path') - Add to stack
 *    - context.go('/path') - Replace stack
 *    - context.pop() - Go back
 *    - context.pushNamed('name') - Use route name
 *
 * 3. Path Parameters
 *    - path: '/book/:id'
 *    - Access: state.pathParameters['id']
 *
 * 4. Query Parameters
 *    - path: '/search?q=flutter&category=mobile'
 *    - Access: state.uri.queryParameters['q']
 *
 * 5. Extra Data
 *    - context.push('/path', extra: object)
 *    - Access: state.extra as Type
 *
 * 6. Error Handling
 *    - errorBuilder for 404 pages
 *
 * 7. Current Route Info
 *    - GoRouterState.of(context).uri
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a "reviews" nested route: /book/:id/reviews
 * 2. Implement authentication redirect
 * 3. Add custom page transitions
 * 4. Create a reading list feature
 *
 */
