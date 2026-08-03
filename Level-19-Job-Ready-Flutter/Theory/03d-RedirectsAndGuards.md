# Redirects, Guards, and Deep Links

## The Big Idea In One Sentence

> One `redirect` function decides who is allowed where, `refreshListenable` tells the router to re-run it when auth changes, and deep links are just the router receiving a URL it already knows how to handle.

---

## The Auth Guard, Done Properly

```dart
final router = GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier,        // re-run redirect when this notifies
  redirect: (BuildContext context, GoRouterState state) {
    final status = authNotifier.status;
    final location = state.matchedLocation;

    // While we do not know yet, hold the user on the splash screen
    if (status == AuthStatus.unknown) {
      return location == '/splash' ? null : '/splash';
    }

    final loggingIn = location == '/login' || location == '/signup';

    if (status == AuthStatus.signedOut) {
      // Remember where they wanted to go, so we can send them back after login
      return loggingIn ? null : '/login?from=${Uri.encodeComponent(state.uri.toString())}';
    }

    // Signed in but sitting on a login/splash page: move them along
    if (loggingIn || location == '/splash') {
      return '/home';
    }

    return null;   // null means "no redirect, carry on"
  },
  routes: [...],
);
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   THE FOUR RULES OF redirect                         │
│                                                      │
│   1. return null  = allow the navigation             │
│   2. return path  = go there instead                 │
│   3. It runs on EVERY navigation, and again after    │
│      refreshListenable notifies                      │
│   4. It must eventually return null, or you get      │
│      "Too many redirects"                            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The `unknown` status is the piece juniors forget. On a cold start you do not yet know whether the stored token is valid, so without an `unknown` state the app flashes the login screen for half a second before jumping to home. Holding on `/splash` until the check completes removes that flash.

---

## refreshListenable: Making Auth Changes Take Effect

`redirect` is not magic. It runs when a navigation happens. If the user's token expires while they are sitting on a screen, nothing navigates and nothing re-runs. `refreshListenable` fixes that: when the listenable notifies, go_router re-runs `redirect` for the current location.

### The simple version: a ChangeNotifier

```dart
enum AuthStatus { unknown, signedIn, signedOut }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  Future<void> checkSession() async {
    final token = await secureStorage.read('token');
    _status = token == null ? AuthStatus.signedOut : AuthStatus.signedIn;
    notifyListeners();          // router re-runs redirect
  }

  Future<void> signOut() async {
    await secureStorage.delete('token');
    _status = AuthStatus.signedOut;
    notifyListeners();          // every private screen is now redirected away
  }
}
```

### The bloc version: bridging a stream to a Listenable

When auth lives in a bloc, wrap its stream:

```dart
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Wiring:
final router = GoRouter(
  refreshListenable: GoRouterRefreshStream(authBloc.stream),
  redirect: (context, state) {
    final authState = authBloc.state;
    // ... same logic as above, reading authState
  },
  routes: [...],
);
```

This little class appears in the official go_router examples and in most production apps. Knowing why it exists (the router needs a `Listenable`, blocs expose a `Stream`) is a solid interview moment.

---

## Route Level Redirects

Global `redirect` handles auth. Per route `redirect` handles route specific rules.

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = context.read<AuthNotifier>().user;
    return user?.isAdmin == true ? null : '/forbidden';
  },
  builder: (context, state) => const AdminPage(),
)
```

Order of execution: the top level `redirect` runs first, then route level redirects from the outermost matching route inward. Keep each one small and single purpose.

---

## Sending The User Back After Login

```dart
// Login page reads where they were headed
final from = GoRouterState.of(context).uri.queryParameters['from'];

// After a successful login
context.go(from ?? '/home');
```

Small touch, big impression: a user who taps a shared link to `/products/42` while signed out lands on login, signs in, and arrives at the product instead of a generic home screen.

---

## Handling Unknown Routes

```dart
final router = GoRouter(
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Not found')),
    body: Center(child: Text('No page at ${state.uri}')),
  ),
  routes: [...],
);
```

Use `errorPageBuilder` instead if you need a custom transition. Always ship one: without it, a typo in a deep link shows a red error screen in release mode.

---

## Deep Links: The Platform Side

The router already understands `/products/42`. Deep linking is just telling the operating system to hand your app that path.

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<activity android:name=".MainActivity" ...>
  <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />

  <!-- Custom scheme: myapp://products/42 -->
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="myapp" />
  </intent-filter>

  <!-- App Links: https://myapp.com/products/42 opens the app directly -->
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="myapp.com" />
  </intent-filter>
</activity>
```

App Links also need a file served at `https://myapp.com/.well-known/assetlinks.json` containing your app's SHA-256 signing fingerprint.

### iOS (`ios/Runner/Info.plist`)

```xml
<key>FlutterDeepLinkingEnabled</key>
<true/>

<!-- Custom scheme -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>myapp</string></array>
  </dict>
</array>
```

Universal Links additionally need the Associated Domains capability (`applinks:myapp.com`) in Xcode and an `apple-app-site-association` file on your server.

### Testing without a server

```bash
# Android
adb shell am start -a android.intent.action.VIEW \
  -d "myapp://products/42" com.example.myapp

# iOS simulator
xcrun simctl openurl booted "myapp://products/42"
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Custom scheme (myapp://)                           │
│   • easy, works immediately, no server needed        │
│   • ugly, and any app can claim the same scheme      │
│                                                      │
│   App Links / Universal Links (https://)             │
│   • verified: only YOUR app can open your domain     │
│   • falls back to the website if the app is missing  │
│   • needs a file hosted on your domain               │
│                                                      │
│   Ship both. Use https links in emails and social,   │
│   custom schemes for internal testing.               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Web: Clean URLs

By default Flutter web uses hash URLs (`myapp.com/#/products/42`). To get clean paths:

```yaml
# pubspec.yaml: flutter_web_plugins ships with the SDK, but you must declare it
dependencies:
  flutter_web_plugins:
    sdk: flutter
```

```dart
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();     // myapp.com/products/42
  runApp(const App());
}
```

Your host must then serve `index.html` for every path, or a refresh on `/products/42` returns a 404. On Firebase Hosting that is a rewrite to `/index.html`; on Nginx it is `try_files $uri /index.html`.

---

## Testing Redirects

Redirect logic is pure and easy to test, which makes it a great thing to show:

```dart
testWidgets('signed out user is sent to login', (tester) async {
  final auth = AuthNotifier()..setStatus(AuthStatus.signedOut);
  final router = buildRouter(auth);

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  router.go('/profile');
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsOneWidget);
});
```

Build the router from a function that takes the auth object, exactly so tests can hand it a fake.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • redirect returns null (allow) or a path (send)   │
│   • Have an `unknown` auth status to avoid a flash   │
│   • refreshListenable re-runs redirect on auth change│
│   • Bridge a bloc stream with GoRouterRefreshStream  │
│   • Keep the intended path in ?from= and return there│
│   • Always provide errorBuilder                      │
│   • Deep links: custom scheme + App/Universal Links  │
│   • usePathUrlStrategy() plus a server rewrite       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does returning `null` from `redirect` mean?

<details>
<summary>Answer</summary>
"No redirect needed, allow this navigation to proceed."
</details>

**Q2.** The token expires while the user is reading a screen. Why does `redirect` alone not kick them out, and what fixes it?

<details>
<summary>Answer</summary>
`redirect` only runs when a navigation happens, and nothing is navigating. `refreshListenable` fixes it: when the auth object notifies, go_router re-evaluates the current location and applies the redirect.
</details>

**Q3.** Why do you need an `unknown` auth status?

<details>
<summary>Answer</summary>
On a cold start the stored session has not been checked yet. Without `unknown`, the user counts as signed out for a moment and sees the login screen flash before being sent to home.
</details>

---

## Assignment

### Problem 1: Write the guard

Write a `redirect` for an app where `/`, `/about`, and `/login` are public, and everything else needs a signed in user.

### Problem 2: Diagnose

The app logs "Too many redirects" and freezes. Name the most likely cause.

### Problem 3: Return to intent

A signed out user taps a link to `/orders/77`. Show the two lines that get them to `/orders/77` after they log in.

### Problem 4: Web refresh 404

Your Flutter web app works when navigating, but refreshing `/products/42` shows a 404 from the server. What are the two required fixes?

---

## Assignment Answers

### Problem 1: Write the guard

```dart
redirect: (context, state) {
  const publicPaths = {'/', '/about', '/login'};
  final isPublic = publicPaths.contains(state.matchedLocation);
  final signedIn = auth.status == AuthStatus.signedIn;

  if (!signedIn && !isPublic) return '/login';
  if (signedIn && state.matchedLocation == '/login') return '/';
  return null;
},
```

### Problem 2: Diagnose

A redirect that never returns `null`: usually a rule that sends signed out users to `/login` without excluding `/login` itself, so `/login` redirects to `/login` forever.

### Problem 3: Return to intent

```dart
// in redirect
return '/login?from=${Uri.encodeComponent(state.uri.toString())}';

// after a successful login
context.go(GoRouterState.of(context).uri.queryParameters['from'] ?? '/');
```

### Problem 4: Web refresh 404

1. Call `usePathUrlStrategy()` before `runApp`, so URLs are real paths.
2. Configure the host to rewrite all unknown paths to `/index.html`, so a direct request for `/products/42` still serves the app.

---

## Navigation

⬅️ **Previous:** [Shell Routes](03c-ShellRoutes.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Platform Aware Code](04a-PlatformAwareCode.md)
