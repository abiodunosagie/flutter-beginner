// Example 04: go_router with a stateful shell, an auth guard, and deep links.
//
// Shows: StatefulShellRoute.indexedStack (per tab history), refreshListenable,
// a redirect that remembers where the user was going, path and query
// parameters, extra, a full screen route outside the shell, and errorBuilder.
//
// pubspec.yaml:
//   dependencies:
//     go_router: ^17.3.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const RouterApp());

// ---------------------------------------------------------------------------
// Auth: a ChangeNotifier, so the router can re-run redirect when it changes.
// ---------------------------------------------------------------------------

enum AuthStatus { unknown, signedIn, signedOut }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;

  AuthStatus get status => _status;

  Future<void> checkSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  void signIn() {
    _status = AuthStatus.signedIn;
    notifyListeners();
  }

  void signOut() {
    _status = AuthStatus.signedOut;
    notifyListeners();
  }
}

final auth = AuthNotifier();

// ---------------------------------------------------------------------------
// Router: built ONCE, outside build().
// ---------------------------------------------------------------------------

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/feed',
  debugLogDiagnostics: true,
  refreshListenable: auth,
  redirect: (context, state) {
    final location = state.matchedLocation;

    // While the session check runs, hold on the splash so the login screen
    // does not flash for half a second.
    if (auth.status == AuthStatus.unknown) {
      return location == '/splash' ? null : '/splash';
    }

    final onLogin = location == '/login';

    if (auth.status == AuthStatus.signedOut) {
      if (onLogin) return null;
      final from = Uri.encodeComponent(state.uri.toString());
      return '/login?from=$from';
    }

    if (onLogin || location == '/splash') return '/feed';
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Not found')),
    body: Center(child: Text('No page at ${state.uri}')),
  ),
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(
        from: state.uri.queryParameters['from'],
      ),
    ),

    // Full screen, deliberately OUTSIDE the shell, so no bottom bar shows.
    GoRoute(
      path: '/media/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          MediaPage(id: state.pathParameters['id']!),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedPage(),
              routes: [
                GoRoute(
                  // /feed/post/7?highlight=comments
                  path: 'post/:id',
                  builder: (context, state) => PostPage(
                    id: state.pathParameters['id']!,
                    highlight: state.uri.queryParameters['highlight'],
                    // extra is an optimisation only: it is null on a deep link
                    preloaded: state.extra as String?,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class RouterApp extends StatefulWidget {
  const RouterApp({super.key});

  @override
  State<RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<RouterApp> {
  @override
  void initState() {
    super.initState();
    auth.checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'go_router demo',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}

// ---------------------------------------------------------------------------
// Shell: adaptive, and the selected tab comes from the shell, not local state.
// ---------------------------------------------------------------------------

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) => navigationShell.goBranch(
        index,
        // Tapping the tab you are on returns that tab to its root.
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (!isWide) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Feed'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 840,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home_outlined), label: Text('Feed')),
              NavigationRailDestination(
                  icon: Icon(Icons.search), label: Text('Search')),
              NavigationRailDestination(
                  icon: Icon(Icons.person_outline), label: Text('Profile')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pages
// ---------------------------------------------------------------------------

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.from});

  final String? from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (from != null) Text('You will return to ${Uri.decodeComponent(from!)}'),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('sign_in'),
              onPressed: () {
                auth.signIn();
                // The redirect sends signed in users off /login automatically,
                // but honouring ?from= is the nicer experience.
                final target = from == null ? null : Uri.decodeComponent(from!);
                if (target != null) context.go(target);
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, i) => ListTile(
          key: ValueKey('post_$i'),
          title: Text('Post $i'),
          subtitle: const Text('Tap to open, then switch tabs and come back'),
          onTap: () => context.go(
            '/feed/post/$i?highlight=comments',
            extra: 'Preloaded body for post $i',
          ),
        ),
      ),
    );
  }
}

class PostPage extends StatelessWidget {
  const PostPage({
    super.key,
    required this.id,
    this.highlight,
    this.preloaded,
  });

  final String id;
  final String? highlight;
  final String? preloaded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post $id')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('highlight: ${highlight ?? 'none'}'),
            const SizedBox(height: 8),
            // extra is missing on a deep link, so we always have a fallback.
            Text(preloaded ?? 'Loading body for post $id from the server...'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push('/media/$id'),
              child: const Text('Open full screen media'),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaPage extends StatelessWidget {
  const MediaPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Text(
              'Media $id (no bottom bar here)',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: const Center(child: Text('Search keeps its own history')),
      );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: FilledButton(
          onPressed: auth.signOut, // redirect sends the user to /login
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
