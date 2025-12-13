# Deep Linking in Flutter

Open specific screens directly from URLs, notifications, or other apps!

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

## Android Setup

### Step 1: Add Intent Filter (AndroidManifest.xml)

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
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

      <!-- HTTP/HTTPS Links (https://myapp.com/...) -->
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="https"/>
        <data android:host="myapp.com"/>
      </intent-filter>

    </activity>
  </application>
</manifest>
```

### Step 2: Test Android Deep Links

```bash
# Test custom scheme
adb shell am start -a android.intent.action.VIEW \
  -d "myapp://product/123" com.example.myapp

# Test https link
adb shell am start -a android.intent.action.VIEW \
  -d "https://myapp.com/product/123" com.example.myapp
```

---

## iOS Setup

### Step 1: Add URL Scheme (Info.plist)

```xml
<!-- ios/Runner/Info.plist -->
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

  <!-- Universal Links (for https://) -->
  <key>FlutterDeepLinkingEnabled</key>
  <true/>
</dict>
```

### Step 2: Associated Domains (for Universal Links)

In Xcode:
1. Select your target
2. Go to "Signing & Capabilities"
3. Add "Associated Domains"
4. Add: `applinks:myapp.com`

### Step 3: Host apple-app-site-association file

On your server at `https://myapp.com/.well-known/apple-app-site-association`:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.example.myapp",
        "paths": ["*"]
      }
    ]
  }
}
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

    // Deep link: myapp://order/123/item/456
    GoRoute(
      path: '/order/:orderId/item/:itemId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        final itemId = state.pathParameters['itemId']!;
        return OrderItemScreen(orderId: orderId, itemId: itemId);
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
          _DeepLinkCard(
            title: 'Order Item',
            link: 'myapp://order/123/item/456',
            onTap: () => context.push('/order/123/item/456'),
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

class OrderItemScreen extends StatelessWidget {
  final String orderId;
  final String itemId;
  const OrderItemScreen({required this.orderId, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Item')),
      body: Center(child: Text('Order: $orderId\nItem: $itemId')),
    );
  }
}
```

---

## Handling Initial Deep Links

### Check Incoming Link on App Start

```dart
final router = GoRouter(
  // This is automatically handled by GoRouter!
  // When app opens via deep link, it navigates there.

  // But you can also manually handle:
  initialLocation: '/',

  // Redirect can process the initial link
  redirect: (context, state) {
    // state.uri contains the deep link path
    print('Incoming path: ${state.uri}');

    // You can add logic here
    // Example: Track analytics for deep link opens
    if (state.uri.path.startsWith('/product/')) {
      analytics.logDeepLinkOpen(state.uri.toString());
    }

    return null;  // No redirect
  },
);
```

---

## Deep Links with Authentication

### Handling "Open Deep Link After Login"

```dart
String? pendingDeepLink;  // Store the deep link

final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = authState.isLoggedIn;
    final isLoggingIn = state.uri.path == '/login';

    // Not logged in?
    if (!isLoggedIn) {
      if (isLoggingIn) return null;

      // Save the intended destination
      pendingDeepLink = state.uri.toString();
      return '/login';
    }

    // Just logged in and have pending deep link?
    if (pendingDeepLink != null && isLoggingIn) {
      final destination = pendingDeepLink;
      pendingDeepLink = null;
      return destination;  // Go to saved deep link
    }

    // Logged in and on login page? Go home
    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [...],
);
```

### Visual Flow

```
User clicks deep link: myapp://order/123
         │
         ▼
Is user logged in? ──NO──> Save "order/123" → Go to /login
         │                        │
        YES                       ▼
         │                  User logs in
         │                        │
         ▼                        ▼
Go to /order/123          Redirect to saved /order/123
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

## Sharing Deep Links

### Generate Shareable Links

```dart
class ShareHelper {
  static String generateProductLink(String productId) {
    return 'https://myapp.com/product/$productId';
  }

  static String generateUserLink(String username) {
    return 'https://myapp.com/user/$username';
  }

  static void shareProduct(BuildContext context, String productId) {
    final link = generateProductLink(productId);
    Share.share('Check out this product: $link');
  }
}

// Use in widget
ElevatedButton(
  onPressed: () => ShareHelper.shareProduct(context, '123'),
  child: Text('Share Product'),
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                  DEEP LINKING CHEAT SHEET                    │
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
│  • HTTPS: https://myapp.com/product/123                     │
│  • Web: https://myapp.web.app/#/product/123                 │
│                                                             │
│  TESTING:                                                   │
│  • iOS: xcrun simctl openurl booted "myapp://..."           │
│  • Android: adb shell am start -d "myapp://..."             │
│  • Web: Just type the URL                                   │
│                                                             │
│  WITH AUTH:                                                 │
│  • Save intended deep link                                  │
│  • Redirect to login                                        │
│  • After login, go to saved link                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← GoRouter Advanced](./05-GoRouterAdvanced.md) | [Next: Bottom Navigation →](./07-BottomNavigation.md)
