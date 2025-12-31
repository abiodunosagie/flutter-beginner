# Deep Linking Basics

Learn how to open specific screens directly from URLs!

---

## What is Deep Linking?

### Think of it Like This

Imagine your app is a building:
- **Regular Link:** Takes you to the lobby (home screen)
- **Deep Link:** Takes you directly to Room 304 (specific screen)

```
┌─────────────────────────────────────────────────────────────┐
│                    DEEP LINKING                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  REGULAR APP OPEN:                                          │
│  User taps app icon → Home Screen                           │
│                                                             │
│  DEEP LINK:                                                 │
│  User taps link "myapp://product/123"                       │
│       ↓                                                     │
│  App opens directly to Product #123 screen                  │
│                                                             │
│  EXAMPLES:                                                  │
│  • Click email link → Open order details                    │
│  • Click notification → Open chat message                   │
│  • Scan QR code → Open product page                         │
│  • Share link → Friend opens same screen                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Types of Deep Links

```
┌─────────────────────────────────────────────────────────────┐
│                    DEEP LINK TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. CUSTOM SCHEME:                                          │
│     myapp://products/123                                    │
│     yourapp://settings/profile                              │
│     Works: Mobile only                                      │
│                                                             │
│  2. HTTP/HTTPS (Universal Links / App Links):               │
│     https://myapp.com/products/123                          │
│     https://yoursite.com/user/john                          │
│     Works: Mobile + Web                                     │
│                                                             │
│  3. WEB URLS (Flutter Web):                                 │
│     https://myapp.web.app/#/products/123                    │
│     Works: Web browsers                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## GoRouter Deep Linking (Automatic!)

### The Good News

GoRouter handles deep links automatically! Your routes ARE your deep links.

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductScreen(id: id);
      },
    ),
    GoRoute(
      path: '/user/:username',
      builder: (context, state) {
        final username = state.pathParameters['username']!;
        return UserScreen(username: username);
      },
    ),
  ],
);

// These deep links work automatically:
// myapp://product/123 → ProductScreen(id: '123')
// myapp://user/john → UserScreen(username: 'john')
```

---

## Setting Up URL Schemes

### Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
  <application>
    <activity>
      <!-- Add inside your main activity -->

      <!-- Custom Scheme (myapp://...) -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="myapp"/>
      </intent-filter>

    </activity>
  </application>
</manifest>
```

### iOS Setup

Add to `ios/Runner/Info.plist`:

```xml
<dict>
  <!-- Custom URL Scheme -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>myapp</string>
      </array>
    </dict>
  </array>

  <!-- Enable deep linking -->
  <key>FlutterDeepLinkingEnabled</key>
  <true/>
</dict>
```

---

## Complete Deep Link Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

// ═══════════════════════════════════════════════════════════════
// ROUTER WITH DEEP LINK SUPPORT
// ═══════════════════════════════════════════════════════════════

final router = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),

    // Deep link: myapp://products
    GoRoute(
      path: '/products',
      builder: (context, state) => ProductListScreen(),
    ),

    // Deep link: myapp://product/123
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(id: id);
      },
    ),

    // Deep link: myapp://user/john
    GoRoute(
      path: '/user/:username',
      builder: (context, state) {
        final username = state.pathParameters['username']!;
        return UserProfileScreen(username: username);
      },
    ),

    // Deep link with query params: myapp://search?q=flutter
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return SearchScreen(initialQuery: query);
      },
    ),
  ],

  // Handle unknown deep links
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page Not Found'),
            Text('Path: ${state.uri.path}'),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Deep Link Demo',
      routerConfig: router,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREENS
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Try these deep links:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          _DeepLinkCard(
            title: 'Products List',
            link: 'myapp://products',
            onTap: () => context.push('/products'),
          ),
          _DeepLinkCard(
            title: 'Product #123',
            link: 'myapp://product/123',
            onTap: () => context.push('/product/123'),
          ),
          _DeepLinkCard(
            title: 'User Profile',
            link: 'myapp://user/john',
            onTap: () => context.push('/user/john'),
          ),
          _DeepLinkCard(
            title: 'Search for "flutter"',
            link: 'myapp://search?q=flutter',
            onTap: () => context.push('/search?q=flutter'),
          ),
        ],
      ),
    );
  }
}

class _DeepLinkCard extends StatelessWidget {
  final String title;
  final String link;
  final VoidCallback onTap;

  const _DeepLinkCard({
    required this.title,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(link, style: TextStyle(fontFamily: 'monospace')),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Center(child: Text('Product List\nDeep link: /products')),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String id;
  const ProductDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Center(child: Text('Product Detail\nID: $id\nDeep link: /product/$id')),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String username;
  const UserProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('@$username')),
      body: Center(child: Text('User Profile\nUsername: $username')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final String initialQuery;
  const SearchScreen({this.initialQuery = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('Search\nQuery: $initialQuery')),
    );
  }
}
```

---

## Testing Deep Links

### iOS Simulator

```bash
# Open deep link in simulator
xcrun simctl openurl booted "myapp://product/123"
xcrun simctl openurl booted "https://myapp.com/product/123"
```

### Android Emulator

```bash
# Open deep link in emulator
adb shell am start -a android.intent.action.VIEW \
  -d "myapp://product/123" com.example.myapp
```

### Flutter Web

Just navigate to the URL in your browser!
```
http://localhost:8080/#/product/123
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              DEEP LINK BASICS CHEAT SHEET                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GOROUTER: Routes ARE deep links (automatic!)               │
│                                                             │
│  SETUP:                                                     │
│  • Android: Add intent-filter in AndroidManifest.xml        │
│  • iOS: Add URL scheme in Info.plist                        │
│  • Web: Just works!                                         │
│                                                             │
│  LINK FORMATS:                                              │
│  • Custom: myapp://product/123                              │
│  • HTTPS: https://myapp.com/product/123 (needs setup)       │
│  • Web: https://myapp.web.app/#/product/123                 │
│                                                             │
│  TESTING:                                                   │
│  • iOS: xcrun simctl openurl booted "myapp://..."           │
│  • Android: adb shell am start -d "myapp://..."             │
│  • Web: Just type the URL                                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Now that you know deep link basics, let's set up Universal Links and App Links for production apps!

**Continue to:** [Platform Links →](06b-PlatformLinks.md)

---

## Navigation

⬅️ **Previous:** [Query Parameters](05c-QueryParams.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Platform Links](06b-PlatformLinks.md)
