# Progressive Web Apps (PWA) & Advanced Optimization

## What You'll Learn

In this lesson, you'll learn how to:
- Convert your Flutter web app to a Progressive Web App (PWA)
- Add "Install to Home Screen" functionality
- Enable offline support with service workers
- Implement push notifications
- Optimize performance for production
- Lazy load content for faster initial load
- Implement code splitting
- Add loading splash screens
- Optimize for Core Web Vitals

## Understanding Progressive Web Apps (PWA)

A **Progressive Web App** is a web app that behaves like a native app:

**Regular Web App:**
- ❌ Only works online
- ❌ Can't be installed
- ❌ No push notifications
- ❌ No home screen icon

**Progressive Web App:**
- ✅ Works offline
- ✅ Can be installed like a native app
- ✅ Push notifications
- ✅ Home screen icon
- ✅ Full-screen mode
- ✅ Fast loading

**Think of it like this:**
- Regular web app = Restaurant website (you visit in browser)
- PWA = Restaurant app (you install and use like Uber Eats)

## Step 1: Configure Manifest for PWA

The manifest tells browsers your app can be installed.

Update `web/manifest.json`:

```json
{
  "name": "Weather App - Real-time Forecasts",
  "short_name": "Weather App",
  "description": "Get accurate weather forecasts for any city worldwide",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#4A90E2",
  "theme_color": "#4A90E2",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ],
  "shortcuts": [
    {
      "name": "Search Weather",
      "short_name": "Search",
      "description": "Search weather for any city",
      "url": "/search",
      "icons": [
        {
          "src": "icons/search-icon-96.png",
          "sizes": "96x96"
        }
      ]
    }
  ],
  "screenshots": [
    {
      "src": "screenshots/home.png",
      "sizes": "540x720",
      "type": "image/png"
    },
    {
      "src": "screenshots/forecast.png",
      "sizes": "540x720",
      "type": "image/png"
    }
  ]
}
```

**Understanding manifest fields:**

- **name**: Full app name shown during install
- **short_name**: Name shown under icon (max 12 chars)
- **start_url**: Where app opens when launched
- **display**: `standalone` = looks like native app (no browser UI)
- **background_color**: Splash screen background
- **theme_color**: Status bar color on mobile
- **icons**: App icons (need 192x192 and 512x512)
- **shortcuts**: Quick actions (like Android app shortcuts)
- **screenshots**: Shown in install prompt

## Step 2: Create App Icons

### Generate Icons with Online Tool

1. Go to [https://www.pwabuilder.com/imageGenerator](https://www.pwabuilder.com/imageGenerator)
2. Upload your logo (1024x1024px)
3. Download generated icons
4. Place in `web/icons/` folder

### Or Create Manually

Create icons in these sizes:
- 72x72
- 96x96
- 128x128
- 144x144
- 152x152
- 192x192
- 384x384
- 512x512

Save as PNG in `web/icons/` folder.

## Step 3: Service Worker for Offline Support

Flutter automatically generates a service worker, but we can customize it.

Create `web/custom_service_worker.js`:

```javascript
'use strict';

// Cache version - increment when you want to force cache update
const CACHE_VERSION = 'v1.0.0';
const CACHE_NAME = `weather-app-${CACHE_VERSION}`;

// Files to cache for offline use
const CACHE_FILES = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/flutter.js',
  '/manifest.json',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
];

// Install event - cache essential files
self.addEventListener('install', (event) => {
  console.log('Service Worker: Installing...');

  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Service Worker: Caching files');
      return cache.addAll(CACHE_FILES);
    })
  );

  // Force the service worker to become active
  self.skipWaiting();
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('Service Worker: Activating...');

  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Service Worker: Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );

  // Take control of all pages immediately
  self.clients.claim();
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
  const { request } = event;

  // Skip cross-origin requests
  if (!request.url.startsWith(self.location.origin)) {
    return;
  }

  event.respondWith(
    caches.match(request).then((cachedResponse) => {
      // Return cached version if available
      if (cachedResponse) {
        return cachedResponse;
      }

      // Otherwise, fetch from network
      return fetch(request).then((response) => {
        // Don't cache if not a success response
        if (!response || response.status !== 200) {
          return response;
        }

        // Clone the response
        const responseToCache = response.clone();

        // Add to cache for next time
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(request, responseToCache);
        });

        return response;
      });
    })
  );
});

// Background sync for offline actions
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-weather') {
    event.waitUntil(syncWeatherData());
  }
});

async function syncWeatherData() {
  // Sync any pending weather searches when back online
  console.log('Syncing weather data...');
  // Implementation would go here
}
```

### Register Service Worker

Update `web/index.html`:

```html
<script>
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
      navigator.serviceWorker
        .register('/custom_service_worker.js')
        .then((registration) => {
          console.log('Service Worker registered:', registration);
        })
        .catch((error) => {
          console.log('Service Worker registration failed:', error);
        });
    });
  }
</script>
```

## Step 4: Add Install Prompt

Create `lib/widgets/install_prompt.dart`:

```dart
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class InstallPrompt extends StatefulWidget {
  const InstallPrompt({Key? key}) : super(key: key);

  @override
  State<InstallPrompt> createState() => _InstallPromptState();
}

class _InstallPromptState extends State<InstallPrompt> {
  bool _showPrompt = false;
  bool _isInstallable = false;

  @override
  void initState() {
    super.initState();
    _checkInstallability();
  }

  void _checkInstallability() {
    // Check if app is already installed
    final displayMode = html.window.matchMedia('(display-mode: standalone)').matches;

    if (displayMode) {
      // App is already installed
      setState(() => _showPrompt = false);
      return;
    }

    // Listen for beforeinstallprompt event
    html.window.addEventListener('beforeinstallprompt', (event) {
      event.preventDefault();
      setState(() {
        _isInstallable = true;
        _showPrompt = true;
      });

      // Store the event for later use
      js.context['deferredPrompt'] = event;
    });
  }

  Future<void> _installApp() async {
    final deferredPrompt = js.context['deferredPrompt'];

    if (deferredPrompt != null) {
      // Show install prompt
      deferredPrompt.callMethod('prompt', []);

      // Wait for user response
      final choiceResult = await deferredPrompt.callMethod('userChoice', []);

      if (choiceResult['outcome'] == 'accepted') {
        print('User accepted install');
      } else {
        print('User dismissed install');
      }

      // Clear the deferred prompt
      js.context['deferredPrompt'] = null;
      setState(() => _showPrompt = false);
    }
  }

  void _dismissPrompt() {
    setState(() => _showPrompt = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showPrompt || !_isInstallable) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Install Weather App',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get quick access and offline support',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _dismissPrompt,
                child: const Text('Not now'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _installApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Install'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

Add to your main page:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Your main content
        YourMainContent(),

        // Install prompt
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: InstallPrompt(),
        ),
      ],
    ),
  );
}
```

## Step 5: Performance Optimization

### 1. Code Splitting

Split your app into chunks that load on demand.

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      // Lazy load routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const HomePage(),
            );
          case '/settings':
            // Lazy load settings page
            return MaterialPageRoute(
              builder: (_) => _loadSettingsPage(),
            );
          default:
            return null;
        }
      },
    );
  }

  Widget _loadSettingsPage() {
    // This widget is only loaded when user navigates to settings
    return FutureBuilder(
      future: _importSettingsPage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<Widget> _importSettingsPage() async {
    // Simulate dynamic import
    await Future.delayed(const Duration(milliseconds: 100));
    return const SettingsPage();
  }
}
```

### 2. Image Optimization

Create `lib/widgets/optimized_image.dart`:

```dart
import 'package:flutter/material.dart';

class OptimizedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OptimizedImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      // Enable caching
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      // Show placeholder while loading
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      // Show error icon if image fails to load
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
    );
  }
}
```

### 3. Lazy Loading Lists

For long lists (like forecast items):

```dart
class ForecastList extends StatelessWidget {
  final List<ForecastItem> forecasts;

  const ForecastList({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Only build visible items
      itemCount: forecasts.length,
      itemBuilder: (context, index) {
        return ForecastCard(forecast: forecasts[index]);
      },
      // Add physics for better scrolling
      physics: const BouncingScrollPhysics(),
    );
  }
}
```

### 4. Debounce Search Input

Prevent API calls on every keystroke:

```dart
import 'dart:async';

class SearchField extends StatefulWidget {
  final Function(String) onSearch;

  const SearchField({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounce?.cancel();

    // Start new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Only search after user stops typing for 500ms
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      decoration: const InputDecoration(
        hintText: 'Search city...',
      ),
    );
  }
}
```

### 5. Memoization for Expensive Calculations

```dart
import 'package:flutter/foundation.dart';

class WeatherCalculations {
  // Cache expensive calculations
  static final Map<String, double> _cache = {};

  static double calculateHeatIndex(double temp, int humidity) {
    final key = '$temp-$humidity';

    // Return cached value if available
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    // Perform expensive calculation
    final heatIndex = _performComplexCalculation(temp, humidity);

    // Store in cache
    _cache[key] = heatIndex;

    return heatIndex;
  }

  static double _performComplexCalculation(double temp, int humidity) {
    // Complex formula here
    return temp + (humidity * 0.1);
  }
}
```

## Step 6: Loading Splash Screen

Create an animated splash screen while app loads.

Update `web/index.html`:

```html
<body>
  <div id="loading-splash" style="
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #4A90E2 0%, #50C9FF 100%);
  ">
    <div style="text-align: center;">
      <!-- App logo -->
      <img src="icons/Icon-192.png" alt="Logo" style="width: 120px; height: 120px; margin-bottom: 24px;">

      <!-- App name -->
      <h1 style="color: white; font-size: 32px; margin: 0 0 16px 0;">Weather App</h1>

      <!-- Loading spinner -->
      <div class="spinner" style="
        border: 4px solid rgba(255, 255, 255, 0.3);
        border-top: 4px solid white;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        animation: spin 1s linear infinite;
        margin: 0 auto;
      "></div>
    </div>
  </div>

  <style>
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>

  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp().then(function() {
              // Hide splash screen when app is ready
              document.getElementById('loading-splash').remove();
            });
          });
        }
      });
    });
  </script>
</body>
```

## Step 7: Core Web Vitals Optimization

Google ranks websites based on Core Web Vitals. Optimize for:

### 1. Largest Contentful Paint (LCP)
**Goal:** < 2.5 seconds

```dart
// Preload critical resources
void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Preload critical data
  await _preloadCriticalData();

  runApp(const MyApp());
}

Future<void> _preloadCriticalData() async {
  // Preload fonts, images, or data here
  await Future.wait([
    _loadFonts(),
    _loadImages(),
  ]);
}
```

### 2. First Input Delay (FID)
**Goal:** < 100 milliseconds

```dart
// Use async operations to avoid blocking UI
Future<void> _processHeavyTask() async {
  // Run heavy computation in isolate
  await compute(_heavyComputation, data);
}

int _heavyComputation(dynamic data) {
  // Process data here
  return result;
}
```

### 3. Cumulative Layout Shift (CLS)
**Goal:** < 0.1

```dart
// Always specify image sizes
OptimizedImage(
  url: imageUrl,
  width: 200,  // Prevent layout shift
  height: 200,
  fit: BoxFit.cover,
)

// Reserve space for dynamic content
Container(
  height: 100,  // Reserve space
  child: FutureBuilder(
    future: fetchData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return DataWidget(snapshot.data);
      }
      return Placeholder();  // Same height as actual content
    },
  ),
)
```

## Step 8: Test Your PWA

### Chrome DevTools Audit

1. Open your deployed app in Chrome
2. Press F12 (open DevTools)
3. Go to "Lighthouse" tab
4. Select "Progressive Web App"
5. Click "Generate report"

**Target scores:**
- Performance: >90
- Accessibility: >90
- Best Practices: >90
- SEO: >90
- PWA: 100

### Test Installation

1. Open app in Chrome
2. Look for install icon in address bar
3. Click to install
4. App opens in standalone window
5. Appears in Start Menu / App Launcher

### Test Offline

1. Open app
2. Open DevTools → Network tab
3. Select "Offline"
4. Refresh page
5. App should still work (show cached data)

## Step 9: Build and Deploy Optimized PWA

Build with all optimizations:

```bash
flutter build web \
  --release \
  --web-renderer canvaskit \
  --tree-shake-icons \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --source-maps
```

**Flags explained:**
- `--release`: Production mode (minified, optimized)
- `--web-renderer canvaskit`: Better graphics performance
- `--tree-shake-icons`: Remove unused icons (smaller bundle)
- `--dart-define`: Custom build variables
- `--source-maps`: Generate source maps for debugging

Deploy to your chosen platform (see previous lesson).

## Exercises

### Exercise 1: Test PWA Score
Run Lighthouse audit and achieve 100 PWA score.

### Exercise 2: Add Install Prompt
Implement the install prompt and test on mobile device.

### Exercise 3: Test Offline
Make your weather app show cached data when offline.

### Exercise 4: Optimize Images
Convert all PNG icons to WebP format (50-80% smaller).

### Exercise 5: Add Loading Skeleton
Create a skeleton screen that shows while data loads.

**Hint:**
```dart
class WeatherSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      // Animated shimmer effect
    );
  }
}
```

## What You've Learned

✅ Converting Flutter web apps to PWAs
✅ Configuring manifest.json for installation
✅ Implementing service workers for offline support
✅ Adding install prompts
✅ Performance optimization techniques
✅ Code splitting and lazy loading
✅ Image optimization strategies
✅ Core Web Vitals optimization
✅ Creating loading splash screens
✅ Testing PWAs with Lighthouse

## Optimization Checklist

### ✅ PWA Features
- [ ] Manifest.json configured
- [ ] Icons in all required sizes
- [ ] Service worker registered
- [ ] Install prompt implemented
- [ ] Offline fallback page

### ✅ Performance
- [ ] Code splitting enabled
- [ ] Images optimized (WebP format)
- [ ] Lazy loading implemented
- [ ] Debounced search input
- [ ] Memoized expensive calculations

### ✅ Loading Experience
- [ ] Splash screen added
- [ ] Loading skeletons for content
- [ ] Progressive image loading
- [ ] Smooth animations (60 FPS)

### ✅ Core Web Vitals
- [ ] LCP < 2.5s
- [ ] FID < 100ms
- [ ] CLS < 0.1
- [ ] All images have dimensions
- [ ] No layout shifts

## Congratulations! 🎉

You've mastered Flutter Web development!

**You can now:**
- Build beautiful, responsive web apps with Flutter
- Create custom components without packages
- Integrate APIs and handle data
- Deploy to multiple platforms
- Optimize for performance
- Create Progressive Web Apps

**Next Steps:**
- Build your own projects
- Contribute to open source
- Share your knowledge
- Keep learning!

You're ready to build amazing web apps with Flutter! 🚀
