# Deep Linking: Handle URLs from Web and Mobile

## What You'll Learn

- Setting up deep links
- Handling web URLs
- Mobile app links (Android & iOS)
- Testing deep links
- Best practices

## Understanding Deep Links

**Regular Navigation:**
```
User opens app → Always starts at home screen
```

**Deep Links:**
```
User clicks: myapp.com/product/123
App opens directly to: Product #123 screen! ✨
```

## Setup for Flutter Web

Already works! GoRouter handles web URLs automatically.

```dart
// User visits: myapp.com/product/123
// GoRouter automatically navigates to product screen
```

## Android Setup

### 1. Add Intent Filter

**android/app/src/main/AndroidManifest.xml:**

```xml
<activity
    android:name=".MainActivity"
    ...>
    
    <!-- Existing intent filters -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- Add deep link intent filter -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        
        <!-- Your app's URL scheme -->
        <data
            android:scheme="https"
            android:host="myapp.com" />
    </intent-filter>
    
</activity>
```

### 2. Test Android Deep Links

```bash
# Test deep link
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://myapp.com/product/123" \
  com.yourcompany.yourapp
```

## iOS Setup

### 1. Add Associated Domains

**ios/Runner/Runner.entitlements:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:myapp.com</string>
    </array>
</dict>
</plist>
```

### 2. Add URL Types (for custom schemes)

**ios/Runner/Info.plist:**

```xml
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
```

## Complete Deep Link Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Deep Link Demo',
    );
  }
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      
      // Product deep link: myapp.com/product/123
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductScreen(productId: id);
        },
      ),
      
      // User profile: myapp.com/user/john
      GoRoute(
        path: '/user/:username',
        name: 'user',
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return UserProfileScreen(username: username);
        },
      ),
      
      // Article with query params: myapp.com/article/123?ref=email
      GoRoute(
        path: '/article/:id',
        name: 'article',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final ref = state.uri.queryParameters['ref'];
          
          // Track referral
          if (ref != null) {
            print('Referred from: $ref');
          }
          
          return ArticleScreen(articleId: id);
        },
      ),
    ],
    
    // Handle unknown routes
    errorBuilder: (context, state) => NotFoundScreen(),
  );
}
```

## Custom URL Schemes

```dart
// Custom scheme: myapp://product/123

// Add to routes
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductScreen(productId: id);
  },
)

// Works with both:
// - https://myapp.com/product/123
// - myapp://product/123
```

## Testing Deep Links

### Web
Simply visit the URL in browser:
```
http://localhost:8080/product/123
```

### Android
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://myapp.com/product/123" \
  com.yourcompany.yourapp
```

### iOS (Simulator)
```bash
xcrun simctl openurl booted "https://myapp.com/product/123"
```

### iOS (Device)
Use Notes app or Safari to click links

## Handling Deep Link Data

```dart
class ProductScreen extends StatelessWidget {
  final String productId;

  ProductScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: FutureBuilder(
        future: _loadProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Product not found'));
          }
          
          final product = snapshot.data;
          return ProductDetails(product: product);
        },
      ),
    );
  }
  
  Future<Product> _loadProduct(String id) async {
    // Load from API or database
    return await api.getProduct(id);
  }
}
```

## Best Practices

✅ Test all deep link routes
✅ Handle invalid parameters gracefully
✅ Show loading states while fetching data
✅ Implement proper error screens
✅ Track deep link analytics
✅ Test on both Android and iOS
✅ Document all deep link URLs

## Exercises

### Exercise 1: Product Links (Beginner)
Implement product deep links with ID parameter

### Exercise 2: Share Feature (Intermediate)
Add share buttons that create deep links

### Exercise 3: Marketing Campaign (Advanced)
Track referrals from email/social with query params

You're handling deep links like a pro! 🚀
