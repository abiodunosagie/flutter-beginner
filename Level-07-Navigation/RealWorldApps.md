# Level 7: Real-World Apps Using These Concepts

See how navigation creates the flow of real applications!

---

## Basic Navigation (Push/Pop)

### Moving Between Screens!

**E-commerce (Amazon)**
```dart
// Product list → Product detail
ListTile(
  title: Text(product.name),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  },
)

// Back button automatically appears!
```

**Instagram**
```dart
// Feed → Profile → Followers list → Another profile
// Each push adds to navigation stack
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: id)));
Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: followerId)));
```

---

## Named Routes

### Organizing Complex Navigation!

**Large Apps (Uber)**
```dart
MaterialApp(
  routes: {
    '/': (_) => HomeScreen(),
    '/ride/request': (_) => RequestRideScreen(),
    '/ride/tracking': (_) => RideTrackingScreen(),
    '/ride/receipt': (_) => ReceiptScreen(),
    '/payment/methods': (_) => PaymentMethodsScreen(),
    '/profile': (_) => ProfileScreen(),
    '/history': (_) => RideHistoryScreen(),
  },
)

// Navigate anywhere by name
Navigator.pushNamed(context, '/ride/request');
```

---

## GoRouter (Declarative Navigation)

### Modern Navigation Approach!

**Netflix-style App**
```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'show/:id',
          builder: (_, state) => ShowDetailScreen(
            id: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'player/:id',
          builder: (_, state) => PlayerScreen(
            id: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (_, __) => SearchScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (_, __) => ProfileScreen(),
    ),
  ],
)

// Deep linking works automatically!
// myapp.com/show/12345 → ShowDetailScreen(id: '12345')
```

---

## Bottom Navigation

### Tab-Based Apps!

**Instagram / TikTok**
```dart
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    HomeScreen(),
    SearchScreen(),
    CreateScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

---

## Drawer Navigation

### Side Menu Apps!

**Gmail / Settings Apps**
```dart
Scaffold(
  appBar: AppBar(title: Text('Gmail')),
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Column(
            children: [
              CircleAvatar(child: Icon(Icons.person)),
              Text('user@gmail.com'),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text('Primary'),
          onTap: () => navigateTo(context, '/inbox/primary'),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Social'),
          onTap: () => navigateTo(context, '/inbox/social'),
        ),
        ListTile(
          leading: Icon(Icons.local_offer),
          title: Text('Promotions'),
          onTap: () => navigateTo(context, '/inbox/promotions'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => navigateTo(context, '/settings'),
        ),
      ],
    ),
  ),
  body: EmailListScreen(),
)
```

---

## Authentication Flow

### Protected Routes!

**Any App with Login**
```dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = authProvider.isAuthenticated;
    final isLoggingIn = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoggingIn) {
      return '/login';  // Redirect to login
    }
    if (isLoggedIn && isLoggingIn) {
      return '/';  // Already logged in, go home
    }
    return null;  // No redirect needed
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
  ],
)
```

---

## Passing Data Between Screens

### Every App Does This!

**E-commerce**
```dart
// Pass product to detail screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ProductDetailScreen(product: product),
  ),
);

// Return result from screen
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => AddressPickerScreen()),
);
if (result != null) {
  setDeliveryAddress(result);
}
```

**Chat Apps**
```dart
// Pass conversation to chat screen
GoRouter: /chat/:conversationId

context.go('/chat/${conversation.id}');
```

---

## Real Apps Navigation Patterns

| App | Navigation Pattern |
|-----|-------------------|
| **Instagram** | Bottom tabs + push for profiles/posts |
| **Gmail** | Drawer + tabs for folders |
| **Uber** | Modal sheets + push for ride flow |
| **Netflix** | Tabs + push for show details |
| **WhatsApp** | Top tabs + push for chats |

---

## Deep Linking

### Open App to Specific Screen!

**Sharing Links**
```dart
// Someone shares: myapp.com/product/12345
// App opens directly to that product!

GoRoute(
  path: '/product/:id',
  builder: (_, state) {
    final productId = state.pathParameters['id']!;
    return ProductScreen(id: productId);
  },
)
```

**Notification Taps**
```dart
// User taps notification about new message
// App opens to that conversation
onNotificationTap: (data) {
  context.go('/chat/${data['conversationId']}');
}
```

---

## Modal Sheets

### Overlay Screens!

**Uber Ride Request**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (_) => DraggableScrollableSheet(
    initialChildSize: 0.5,
    minChildSize: 0.25,
    maxChildSize: 0.95,
    builder: (_, controller) => RideOptionsSheet(
      scrollController: controller,
    ),
  ),
);
```

---

## Build It Yourself!

After this level, you could build:

1. **Multi-screen App** - Navigate between 3+ screens
2. **Tab-based App** - Bottom navigation with tabs
3. **Settings App** - Drawer navigation
4. **E-commerce Flow** - Products → Detail → Cart → Checkout
5. **Auth Flow** - Login → Home with redirects

---

**Navigation is the roadmap of your app - users follow it to find what they need!**
