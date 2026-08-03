# Flutter On The Web: What Changes And What Breaks

## The Big Idea In One Sentence

> Web is a real Flutter target, but `dart:io` does not exist there, so you isolate platform code behind **conditional imports** and talk to the browser with `dart:js_interop` and `package:web`.

---

## What Actually Runs In The Browser

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Your Dart code                                     │
│        │                                             │
│        ├─ compiled to JavaScript  (default)          │
│        └─ compiled to WebAssembly (--wasm)           │
│              │                                       │
│              ▼                                       │
│   Flutter engine (CanvasKit / Skwasm) draws every    │
│   pixel onto a canvas, exactly like on mobile.       │
│                                                      │
│   The page is NOT made of HTML elements you can      │
│   style with CSS. That is the single most important  │
│   fact about Flutter web.                            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Consequences you must be able to state in an interview:

- **SEO is limited.** Search engines see a canvas, not text. For a marketing site, use a real web framework; use Flutter web for apps behind a login, internal tools, and dashboards.
- **First load is heavy** compared to a plain web page, because the engine has to download.
- **Everything else is identical.** The same widgets, the same layout engine, the same state management.

The old `--web-renderer html` option is gone in current Flutter. Today you choose between the default JavaScript build and `flutter build web --wasm`, which produces a WebAssembly build with a JavaScript fallback.

---

## What Breaks On Web

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   dart:io          File, Directory, Platform,        │
│                    HttpClient, Process               │
│                    -> not available at all           │
│                                                      │
│   Method channels  no native side exists             │
│                    -> MissingPluginException         │
│                                                      │
│   Plugins          many are mobile only. Check the   │
│                    "Platforms" row on pub.dev        │
│                                                      │
│   Paths            no file system: use IndexedDB,    │
│                    localStorage, or your server      │
│                                                      │
│   CORS             the browser blocks cross origin   │
│                    requests your mobile app made     │
│                    happily                           │
│                                                      │
└──────────────────────────────────────────────────────┘
```

CORS surprises almost everyone once: the same API call that works in the mobile app fails in Chrome with "blocked by CORS policy". The fix is on the **server** (send `Access-Control-Allow-Origin`), not in Dart. Disabling web security in a browser is a debugging hack, never a solution.

---

## Conditional Imports: The Pattern That Solves Everything

You want one interface and three implementations, chosen at compile time.

```
lib/core/storage/
├── token_store.dart          the public interface, imported by the app
├── token_store_stub.dart     unsupported fallback
├── token_store_io.dart       mobile and desktop
└── token_store_web.dart      browser
```

### The public file

```dart
// token_store.dart
import 'token_store_stub.dart'
    if (dart.library.io) 'token_store_io.dart'
    if (dart.library.js_interop) 'token_store_web.dart';

abstract class TokenStore {
  Future<void> save(String token);
  Future<String?> read();

  factory TokenStore() => createTokenStore();
}
```

Read the import as: "import the stub, unless `dart:io` exists, in which case import the io file, unless `dart:js_interop` exists, in which case import the web file." The compiler picks exactly one, so the other file's code never reaches the bundle.

### The three implementations

```dart
// token_store_stub.dart
import 'token_store.dart';

TokenStore createTokenStore() =>
    throw UnsupportedError('No TokenStore for this platform');
```

```dart
// token_store_io.dart
import 'dart:io';
import 'token_store.dart';

TokenStore createTokenStore() => IoTokenStore();

class IoTokenStore implements TokenStore {
  File get _file => File('${Directory.systemTemp.path}/token.txt');

  @override
  Future<void> save(String token) async => _file.writeAsString(token);

  @override
  Future<String?> read() async =>
      _file.existsSync() ? _file.readAsString() : null;
}
```

```dart
// token_store_web.dart
import 'package:web/web.dart' as web;
import 'token_store.dart';

TokenStore createTokenStore() => WebTokenStore();

class WebTokenStore implements TokenStore {
  @override
  Future<void> save(String token) async =>
      web.window.localStorage.setItem('token', token);

  @override
  Future<String?> read() async => web.window.localStorage.getItem('token');
}
```

The rest of the app writes `TokenStore().save(token)` and never knows which one ran. Every file that imports `dart:io` must be behind this pattern, or your web build fails to compile.

> Real world note: for tokens specifically, `flutter_secure_storage` already implements this for you (Keychain, Keystore, and web crypto). Write the pattern yourself when no plugin covers your case.

---

## Talking To JavaScript

Modern Dart uses `dart:js_interop` (the old `dart:html` and `package:js` are retired).

```yaml
dependencies:
  web: ^1.1.1
```

### Browser APIs through package:web

```dart
import 'package:web/web.dart' as web;

void useBrowser() {
  final url = web.window.location.href;
  web.window.localStorage.setItem('theme', 'dark');
  web.document.title = 'My App';
  web.window.open('https://example.com', '_blank');
}
```

### Calling your own JavaScript

```html
<!-- web/index.html, before the flutter bootstrap script -->
<script>
  window.showNativeToast = function (message) {
    alert(message);
  };
  window.getAppVersion = function () {
    return "1.4.2";
  };
</script>
```

```dart
import 'dart:js_interop';

@JS('showNativeToast')
external void showNativeToast(String message);

@JS('getAppVersion')
external String getAppVersion();

void demo() {
  showNativeToast('Saved');
  print(getAppVersion());
}
```

Rules for `dart:js_interop`: the function must be declared `external`, only interop compatible types cross (`String`, `num`, `bool`, `JSObject`, `JSArray`, `JSPromise`), and a JavaScript `Promise` becomes a `JSPromise` you convert with `.toDart` to get a Dart `Future`.

Every file using `dart:js_interop` must sit behind a conditional import, or your Android and iOS builds break instead.

---

## URLs, Refresh, And Hosting

```dart
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();     // /products/42 instead of /#/products/42
  runApp(const App());
}
```

Clean URLs need one server side rule: serve `index.html` for any path the server does not recognise, otherwise a refresh on `/products/42` returns 404.

```
# Nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "rewrites": [{ "source": "**", "destination": "/index.html" }]
  }
}
```

If the app is served from a subfolder, set the base href:

```bash
flutter build web --base-href /myapp/
```

---

## Making It A PWA

`flutter create` already produces `web/manifest.json` and a service worker. Edit the manifest so an installed app looks like yours:

```json
{
  "name": "My App",
  "short_name": "MyApp",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#0F1115",
  "theme_color": "#0F1115",
  "icons": [
    { "src": "icons/Icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icons/Icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

```bash
flutter build web --pwa-strategy offline-first   # the default
flutter build web --pwa-strategy none            # disable the service worker
```

---

## Performance On Web

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Build in release: flutter build web              │
│     (debug web is dramatically slower, never judge   │
│      performance from `flutter run -d chrome`)       │
│   • Try --wasm and measure; it is usually faster     │
│   • Compress assets, and prefer web friendly image   │
│     formats                                          │
│   • Defer heavy work; the first frame competes with  │
│     the engine download                              │
│   • Keep an eye on build/web total size              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Running locally:

```bash
flutter run -d chrome                 # development
flutter build web && cd build/web && python3 -m http.server 8000   # release check
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Flutter web paints a canvas, so no CSS, no SEO   │
│   • dart:io and method channels do not exist         │
│   • Conditional imports pick io / web / stub         │
│   • dart:js_interop + package:web for browser APIs   │
│   • CORS is fixed on the server, never in Dart       │
│   • usePathUrlStrategy + a server rewrite            │
│   • --wasm is the modern build option;               │
│     --web-renderer is gone                           │
│   • Judge performance from a release build only      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why can a Flutter web app not be styled with CSS?

<details>
<summary>Answer</summary>
Flutter renders its own pixels onto a canvas rather than producing HTML elements, so there are no DOM nodes for CSS to target.
</details>

**Q2.** How do you write one class that stores a token in a file on mobile and in localStorage on web?

<details>
<summary>Answer</summary>
A conditional import: one public file that imports a stub `if (dart.library.io) io_file` `if (dart.library.js_interop) web_file`, with each implementation providing the same factory function.
</details>

**Q3.** Your API works on Android but the browser blocks it. Where is the fix?

<details>
<summary>Answer</summary>
On the server. It must send the appropriate `Access-Control-Allow-Origin` headers. Nothing in Dart can bypass a browser's CORS policy.
</details>

---

## Assignment

### Problem 1: Find the web breakage

```dart
import 'dart:io';

Future<void> cache(String json) async {
  final dir = Directory.systemTemp;
  await File('${dir.path}/cache.json').writeAsString(json);
}
```

Why does this break the web build, and what is the fix in one sentence?

### Problem 2: Write the conditional import

Write the import line for a public `share_service.dart` that uses `share_io.dart` on mobile and `share_web.dart` on web.

### Problem 3: Deployment bug

Navigating in your deployed web app works, but refreshing any deep page shows the host's 404. Name the fix.

### Problem 4: Choose the target

For each, would you ship Flutter web: a public marketing site, an internal admin dashboard, a customer support console, a blog?

---

## Assignment Answers

### Problem 1: Find the web breakage

`dart:io` does not exist on web, so the file fails to compile for that target. Move it behind a conditional import so the web build gets a `localStorage` or IndexedDB implementation instead.

### Problem 2: Write the conditional import

```dart
import 'share_stub.dart'
    if (dart.library.io) 'share_io.dart'
    if (dart.library.js_interop) 'share_web.dart';
```

### Problem 3: Deployment bug

Configure the host to rewrite all unmatched paths to `/index.html` (`try_files ... /index.html` on Nginx, a `**` rewrite on Firebase Hosting), so the Flutter app boots and go_router handles the path.

### Problem 4: Choose the target

- Marketing site: no. SEO and first load matter most there.
- Internal admin dashboard: yes. Behind a login, SEO irrelevant, and you reuse the mobile codebase.
- Customer support console: yes, same reasons.
- Blog: no. Content sites need indexable HTML.

---

## Navigation

⬅️ **Previous:** [Event Channels and Pigeon](04c-EventChannelsAndPigeon.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The Code Generation Workflow](05a-CodeGenerationWorkflow.md)
