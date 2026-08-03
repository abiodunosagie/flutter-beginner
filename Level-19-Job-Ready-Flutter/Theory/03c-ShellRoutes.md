# Shell Routes: Bottom Bars That Keep Their Place

## The Big Idea In One Sentence

> A **ShellRoute** wraps its child routes in shared UI (a bottom bar, a rail, a header), and a **StatefulShellRoute** goes further by giving every tab its own navigation history that survives switching.

---

## The Problem They Solve

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   WITHOUT A SHELL                                    │
│   Every page draws its own bottom bar. Switching     │
│   tabs pushes a whole new page, so the bar flashes,  │
│   animates, and the back stack fills with tabs.      │
│                                                      │
│   WITH ShellRoute                                    │
│   The bar is drawn ONCE, above the changing child.   │
│   Only the content area swaps.                       │
│                                                      │
│   WITH StatefulShellRoute                            │
│   Same, plus each tab remembers where it was.        │
│   Feed scrolled to post 40, open a profile inside    │
│   it, switch to Chat, come back: still on that       │
│   profile, still scrolled. Like Instagram.           │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## ShellRoute: Shared UI, One History

```dart
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/feed',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(path: '/feed', builder: (context, state) => const FeedPage()),
        GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
      ],
    ),
    // Outside the shell: full screen, no bottom bar
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginPage(),
    ),
  ],
);

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = switch (location) {
      final p when p.startsWith('/search') => 1,
      final p when p.startsWith('/profile') => 2,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => switch (i) {
          0 => context.go('/feed'),
          1 => context.go('/search'),
          _ => context.go('/profile'),
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

Two details that matter:

- `parentNavigatorKey: _rootNavigatorKey` on `/login` pushes it **above** the shell, so the bottom bar is not visible on the login screen. Use the same trick for full screen dialogs, media viewers, and onboarding.
- `GoRouterState.of(context).uri.path` is how the shell knows which tab is selected. Deriving the index from the URL (instead of storing it in local state) means a deep link selects the right tab automatically.

---

## StatefulShellRoute: A History Per Tab

```dart
final router = GoRouter(
  initialLocation: '/feed',
  routes: [
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
                  path: 'post/:id',
                  builder: (context, state) =>
                      PostPage(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the tab you are already on returns it to its root
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   THE THREE PIECES                                   │
│                                                      │
│   StatefulShellRoute.indexedStack                    │
│      keeps every branch alive in an IndexedStack     │
│                                                      │
│   StatefulShellBranch                                │
│      one tab, with its own Navigator and history     │
│                                                      │
│   navigationShell.goBranch(index)                    │
│      switch tabs without touching the URL by hand    │
│                                                      │
│   initialLocation: index == currentIndex             │
│      the standard "tap the active tab to go home"    │
│      behaviour every user expects                    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Because branches live in an `IndexedStack`, all tabs stay in memory. That is what preserves scroll position, but it also means all tabs are built. If a tab is very heavy, keep its expensive work behind a lazy loading state rather than trying to defeat the shell.

---

## ShellRoute or StatefulShellRoute?

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   ShellRoute                                         │
│   • one shared history                               │
│   • lighter, simpler                                 │
│   • good for: a web style layout with a header,      │
│     an admin dashboard, tabs with no deep sub pages  │
│                                                      │
│   StatefulShellRoute                                 │
│   • one history PER TAB, state preserved             │
│   • the standard for social/consumer apps            │
│   • good for: bottom bar apps where each tab has     │
│     its own drill down                               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

If the interviewer asks "how would you build Instagram's bottom bar", the answer is `StatefulShellRoute.indexedStack` with one `StatefulShellBranch` per tab, plus `goBranch(index, initialLocation: index == currentIndex)`.

---

## Adaptive Shell: Bar On Phones, Rail On Tablets

The shell is one widget, so responsiveness is a single change:

```dart
class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (!isWide) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: _bar(context),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 840,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) =>
                navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Feed')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Search')),
              NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context) => NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) =>
            navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      );
}
```

Part 1's adaptive navigation and Part 3's shell routes are the same idea meeting in one widget. That combination is exactly what a "strong widget composition and responsive UI, plus go_router" job description is describing.

---

## No Animation When Switching Tabs

Tab switches should feel instant, not slide. Use `NoTransitionPage` inside a branch:

```dart
GoRoute(
  path: '/feed',
  pageBuilder: (context, state) =>
      const NoTransitionPage(child: FeedPage()),
)
```

---

## Common Shell Mistakes

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. Bottom bar shows on the login screen            │
│      -> the route is inside the shell.               │
│      Move it out, or set parentNavigatorKey.         │
│                                                      │
│   2. Tab index resets on deep link                   │
│      -> the index is stored in local state.          │
│      Derive it from the URL or use currentIndex.     │
│                                                      │
│   3. Tapping the active tab does nothing             │
│      -> missing initialLocation:                     │
│         index == navigationShell.currentIndex        │
│                                                      │
│   4. Detail pages appear UNDER the bottom bar        │
│      when they should be full screen                 │
│      -> add parentNavigatorKey: _rootNavigatorKey    │
│         to that GoRoute.                             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • ShellRoute wraps children in shared UI           │
│   • StatefulShellRoute keeps a history per tab       │
│   • branches = tabs, goBranch(i) switches            │
│   • initialLocation: i == currentIndex resets a tab  │
│   • parentNavigatorKey escapes the shell             │
│   • Derive the selected tab from the URL             │
│   • NoTransitionPage for instant tab switching       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does `StatefulShellRoute` give you that `ShellRoute` does not?

<details>
<summary>Answer</summary>
A separate `Navigator` and history for each branch, so each tab keeps its own stack, scroll position, and state when you switch away and back.
</details>

**Q2.** How do you make a page appear full screen without the bottom bar?

<details>
<summary>Answer</summary>
Declare it outside the shell, or set `parentNavigatorKey: _rootNavigatorKey` on that `GoRoute` so it is pushed onto the root navigator, above the shell.
</details>

**Q3.** What does `initialLocation: index == navigationShell.currentIndex` do?

<details>
<summary>Answer</summary>
It makes tapping the tab you are already on reset that branch to its root route, which is the behaviour users expect from a bottom bar.
</details>

---

## Assignment

### Problem 1: Choose the shell

An admin dashboard with a fixed sidebar, where each section is a single page with no drill down. Which shell, and why?

### Problem 2: Fix the bar

The login screen is showing the bottom navigation bar. What is wrong?

### Problem 3: Write the tab handler

Write the `onDestinationSelected` callback for a `StatefulShellRoute` that also resets the tab when it is tapped twice.

### Problem 4: Structure it

A chat app has Chats, Calls, and Settings. Opening a conversation from Chats must keep the bar, but a video call must be full screen. Sketch the route structure.

---

## Assignment Answers

### Problem 1: Choose the shell

`ShellRoute`. There is no per section drill down, so per tab history buys nothing, and `ShellRoute` is simpler and keeps less in memory.

### Problem 2: Fix the bar

The login route is declared inside the shell's `routes`. Move it to the top level of the router, or give it `parentNavigatorKey: _rootNavigatorKey`, so it renders above the shell.

### Problem 3: Write the tab handler

```dart
onDestinationSelected: (index) => navigationShell.goBranch(
  index,
  initialLocation: index == navigationShell.currentIndex,
),
```

### Problem 4: Structure it

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, shell) => ScaffoldWithNav(navigationShell: shell),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/chats', builder: ..., routes: [
        GoRoute(path: ':id', builder: ...),        // inside the shell, bar stays
      ]),
    ]),
    StatefulShellBranch(routes: [GoRoute(path: '/calls', builder: ...)]),
    StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: ...)]),
  ],
),
GoRoute(
  path: '/call/:id',
  parentNavigatorKey: _rootNavigatorKey,           // full screen, no bar
  builder: ...,
),
```

---

## Navigation

⬅️ **Previous:** [Routes and Parameters](03b-RoutesAndParameters.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Redirects, Guards, and Deep Links](03d-RedirectsAndGuards.md)
