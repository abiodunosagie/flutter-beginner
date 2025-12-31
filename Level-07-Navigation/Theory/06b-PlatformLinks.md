# Platform-Specific Deep Links

Learn about Universal Links (iOS) and App Links (Android) for production apps!

---

## What are Platform Links?

### Universal Links vs App Links

```
┌─────────────────────────────────────────────────────────────┐
│              PLATFORM LINKS COMPARISON                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CUSTOM SCHEME (myapp://):                                  │
│  ────────────────────────                                   │
│  ✅ Easy to set up                                          │
│  ❌ Shows "Open with..." dialog                             │
│  ❌ Works only in apps, not universal                       │
│                                                             │
│  UNIVERSAL/APP LINKS (https://):                            │
│  ───────────────────────────────                            │
│  ✅ Opens app directly (no dialog)                          │
│  ✅ Falls back to website if app not installed              │
│  ✅ More professional                                       │
│  ❌ Requires domain and server setup                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## iOS Universal Links

### What are Universal Links?

Links like `https://myapp.com/product/123` that open your app automatically.

### Step 1: Enable Associated Domains in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Associated Domains"
6. Add: `applinks:myapp.com`

### Step 2: Create apple-app-site-association File

Host this at `https://myapp.com/.well-known/apple-app-site-association`:

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

**Important:**
- Replace `TEAMID` with your Apple Team ID
- Replace `com.example.myapp` with your bundle ID
- File must be served over HTTPS
- No `.json` extension!

### Step 3: Update Info.plist

```xml
<dict>
  <key>FlutterDeepLinkingEnabled</key>
  <true/>
</dict>
```

---

## Android App Links

### What are App Links?

Same concept as Universal Links but for Android.

### Step 1: Update AndroidManifest.xml

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
  <application>
    <activity>

      <!-- App Links (HTTPS) -->
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

### Step 2: Create assetlinks.json File

Host this at `https://myapp.com/.well-known/assetlinks.json`:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.myapp",
      "sha256_cert_fingerprints": [
        "YOUR_SHA256_FINGERPRINT_HERE"
      ]
    }
  }
]
```

### Step 3: Get SHA256 Fingerprint

```bash
# For debug key
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android

# For release key
keytool -list -v -keystore /path/to/your/release.keystore \
  -alias your_alias
```

Copy the SHA256 fingerprint (with colons) into the JSON file.

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

## Handling Initial Deep Links

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
      // analytics.logDeepLinkOpen(state.uri.toString());
    }

    return null;  // No redirect
  },
);
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

  // Using share_plus package
  static void shareProduct(String productId) {
    final link = generateProductLink(productId);
    Share.share('Check out this product: $link');
  }
}

// Use in widget
ElevatedButton(
  onPressed: () => ShareHelper.shareProduct('123'),
  child: Text('Share Product'),
)
```

---

## Verification Checklist

### iOS Universal Links

- [ ] Domain is HTTPS
- [ ] apple-app-site-association file is at `/.well-known/apple-app-site-association`
- [ ] File returns `Content-Type: application/json`
- [ ] TEAMID and bundle ID are correct
- [ ] Associated Domains added in Xcode
- [ ] FlutterDeepLinkingEnabled in Info.plist

Test:
```bash
# Verify file is accessible
curl https://myapp.com/.well-known/apple-app-site-association
```

### Android App Links

- [ ] Domain is HTTPS
- [ ] assetlinks.json file is at `/.well-known/assetlinks.json`
- [ ] Package name matches your app
- [ ] SHA256 fingerprint is correct
- [ ] android:autoVerify="true" in intent-filter

Test:
```bash
# Verify file is accessible
curl https://myapp.com/.well-known/assetlinks.json

# Test the link
adb shell am start -a android.intent.action.VIEW \
  -d "https://myapp.com/product/123" com.example.myapp
```

---

## Troubleshooting

### iOS

**Universal Links not working?**
1. Uninstall app completely
2. Reinstall from TestFlight or App Store (not Xcode)
3. Wait a few minutes for Apple to cache the association file
4. Test by long-pressing link in Notes app

**Still not working?**
- Check Apple's CDN: `https://app-site-association.cdn-apple.com/a/v1/myapp.com`
- Verify JSON syntax with online validator
- Check Xcode console for errors

### Android

**App Links not opening app?**
1. Clear app data
2. Reinstall app
3. Verify digital asset links

**Verify setup:**
```bash
adb shell pm get-app-links com.example.myapp
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              PLATFORM LINKS CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  iOS UNIVERSAL LINKS:                                       │
│  1. Add Associated Domains in Xcode                         │
│  2. Host apple-app-site-association file                    │
│  3. Enable FlutterDeepLinkingEnabled                        │
│                                                             │
│  ANDROID APP LINKS:                                         │
│  1. Add intent-filter with android:autoVerify="true"        │
│  2. Host assetlinks.json file                               │
│  3. Include SHA256 fingerprint                              │
│                                                             │
│  BOTH NEED:                                                 │
│  • HTTPS domain                                             │
│  • Files in /.well-known/ directory                         │
│  • Correct package/bundle IDs                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Continue Learning

Excellent! You now understand deep linking completely. Next, let's learn about bottom navigation!

**Continue to:** [BottomNavigationBar →](07a-BottomNavBar.md)

---

## Navigation

⬅️ **Previous:** [Deep Link Basics](06a-DeepLinkBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [BottomNavigationBar](07a-BottomNavBar.md)
