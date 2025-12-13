// Example 05: Bottom Navigation with GoRouter
// Tab-based navigation with state preservation

// pubspec.yaml dependencies:
// go_router: ^14.0.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ═══════════════════════════════════════════════════════════════
// ROUTER CONFIGURATION WITH SHELL ROUTE
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    // StatefulShellRoute preserves state for each tab!
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // ─────────────────────────────────────────
        // HOME TAB BRANCH
        // ─────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeTab(),
              routes: [
                // Nested route inside home tab
                GoRoute(
                  path: 'featured/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return FeaturedDetailScreen(id: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // ─────────────────────────────────────────
        // SEARCH TAB BRANCH
        // ─────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchTab(),
              routes: [
                GoRoute(
                  path: 'results',
                  builder: (context, state) {
                    final query = state.uri.queryParameters['q'] ?? '';
                    return SearchResultsScreen(query: query);
                  },
                ),
              ],
            ),
          ],
        ),

        // ─────────────────────────────────────────
        // FAVORITES TAB BRANCH
        // ─────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesTab(),
            ),
          ],
        ),

        // ─────────────────────────────────────────
        // PROFILE TAB BRANCH
        // ─────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileTab(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ─────────────────────────────────────────
    // ROUTES OUTSIDE SHELL (No bottom nav)
    // ─────────────────────────────────────────
    GoRoute(
      path: '/item/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ItemDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
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
      title: 'Bottom Nav Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN SCAFFOLD WITH BOTTOM NAV
// ═══════════════════════════════════════════════════════════════

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // goBranch navigates to the branch's current location
          // If already on this branch, it returns to the root
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HOME TAB
// ═══════════════════════════════════════════════════════════════

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // This counter demonstrates state preservation!
  int _viewCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // State preservation demo
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'State Preservation Demo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Views: $_viewCount'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _viewCount++);
                    },
                    child: const Text('Increment'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Switch tabs and come back - the count is preserved!',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Featured items
          const Text(
            'Featured',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(3, (index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Featured Item ${index + 1}'),
                subtitle: const Text('Tap to view details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to nested route (stays in tab)
                  context.push('/home/featured/${index + 1}');
                },
              ),
            );
          }),

          const SizedBox(height: 16),

          // Full screen item
          ElevatedButton.icon(
            onPressed: () {
              // Navigate outside shell (no bottom nav)
              context.push('/item/full-screen');
            },
            icon: const Icon(Icons.fullscreen),
            label: const Text('Open Full Screen Item'),
          ),
        ],
      ),
    );
  }
}

class FeaturedDetailScreen extends StatelessWidget {
  final String id;

  const FeaturedDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Featured #$id'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('⭐', style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              'Featured Item #$id',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('This screen is INSIDE the home tab branch'),
            const Text('Bottom nav is still visible!'),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SEARCH TAB
// ═══════════════════════════════════════════════════════════════

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _controller = TextEditingController();
  final _searches = <String>[];

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
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _searches.insert(0, _controller.text);
                      });
                      context.push('/search/results?q=${_controller.text}');
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _searches.insert(0, value);
                  });
                  context.push('/search/results?q=$value');
                }
              },
            ),
            const SizedBox(height: 20),

            if (_searches.isNotEmpty) ...[
              const Text(
                'Recent Searches',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _searches.take(5).map((search) {
                  return ActionChip(
                    label: Text(search),
                    onPressed: () {
                      _controller.text = search;
                      context.push('/search/results?q=$search');
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Recent searches are preserved when switching tabs!',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results: "$query"'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.article),
              title: Text('Result ${index + 1} for "$query"'),
              subtitle: Text('This is search result ${index + 1}'),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FAVORITES TAB
// ═══════════════════════════════════════════════════════════════

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final _favorites = <String>['Item A', 'Item B', 'Item C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No favorites yet'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(_favorites[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          _favorites.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _favorites.add('Item ${_favorites.length + 1}');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROFILE TAB
// ═══════════════════════════════════════════════════════════════

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.purple,
            child: Text('👤', style: TextStyle(fontSize: 50)),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'john.doe@example.com',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/edit'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: 'Phone')),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.notifications), title: Text('Notifications')),
          ListTile(leading: Icon(Icons.dark_mode), title: Text('Dark Mode')),
          ListTile(leading: Icon(Icons.language), title: Text('Language')),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS OUTSIDE SHELL (No bottom nav)
// ═══════════════════════════════════════════════════════════════

class ItemDetailScreen extends StatelessWidget {
  final String id;

  const ItemDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item: $id'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📱', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              'Item Detail: $id',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('This screen is OUTSIDE the shell'),
            const Text('No bottom navigation bar!'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/home'),
          child: const Text('Login'),
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
 * 1. StatefulShellRoute.indexedStack
 *    - Preserves state for each tab
 *    - Each branch maintains its navigation stack
 *
 * 2. StatefulShellBranch
 *    - Defines routes for each tab
 *    - Can have nested routes
 *
 * 3. StatefulNavigationShell
 *    - Provides currentIndex for selected tab
 *    - goBranch() to navigate between tabs
 *
 * 4. Routes Inside vs Outside Shell
 *    - Inside: Bottom nav visible
 *    - Outside: Full screen, no bottom nav
 *
 * 5. State Preservation
 *    - Counter state preserved when switching tabs
 *    - Search history maintained
 *    - Favorites list persists
 *
 * ═══════════════════════════════════════════════════════════════
 * TAB BEHAVIOR:
 * ═══════════════════════════════════════════════════════════════
 *
 *   Home tab: Home → Featured Detail
 *   Switch to Search tab
 *   Switch back to Home tab
 *   Result: Still on Featured Detail! (state preserved)
 *
 *   Tap Home tab again while on Featured Detail:
 *   Result: Goes back to Home root (initialLocation: true)
 *
 */
