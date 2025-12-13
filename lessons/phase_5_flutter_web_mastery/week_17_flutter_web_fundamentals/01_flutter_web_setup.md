# Week 17, Day 1-2: Flutter Web - Setup and Fundamentals

## What is Flutter Web?

**Flutter Web** = Build beautiful, responsive websites using Flutter (same code as mobile!).

**Real-world analogy:**
- **Traditional web:** HTML + CSS + JavaScript
- **Flutter Web:** Dart code that compiles to optimized web code
- Same as learning one language to speak to everyone!

**What makes Flutter Web special:**
- ✓ Write once, run on **mobile + web + desktop**
- ✓ Beautiful, consistent UI
- ✓ Fast performance
- ✓ No need to learn HTML/CSS/JavaScript separately
- ✓ Share code between platforms

**What Flutter Web is BEST for:**
- 📊 Dashboards and admin panels
- 🌐 Landing pages and portfolios
- 📝 Web apps (like Google Docs)
- 🛍️ E-commerce sites
- 📱 Progressive Web Apps (PWAs)

**What Flutter Web is NOT ideal for:**
- ❌ SEO-heavy blogs (use Next.js instead)
- ❌ Simple static sites (use HTML/CSS instead)
- ❌ Heavy text content sites

---

## How Flutter Web Works

### Traditional Web Stack

```
HTML (Structure)
  ↓
CSS (Styling)
  ↓
JavaScript (Interactivity)
  ↓
Browser renders
```

### Flutter Web Stack

```
Dart Code (Everything!)
  ↓
Flutter compiles to:
  - HTML Canvas (or HTML elements)
  - JavaScript
  ↓
Browser renders
```

**Two rendering modes:**

1. **CanvasKit** (Default)
   - Uses WebGL and Canvas
   - Best performance
   - Pixel-perfect rendering
   - Larger download size (~2MB)
   - **Best for:** Dashboards, web apps

2. **HTML Renderer**
   - Uses HTML/CSS/SVG
   - Smaller download size
   - Better text selection
   - **Best for:** Text-heavy sites

---

## Setting Up Flutter Web

### Step 1: Check Flutter Version

Flutter web is stable since Flutter 2.0+.

```bash
flutter --version
```

You should see:
```
Flutter 3.x.x • channel stable
```

### Step 2: Enable Web Support

```bash
flutter config --enable-web
```

Output:
```
Setting "enable-web" value to "true".
```

### Step 3: Verify Web is Available

```bash
flutter devices
```

You should see:
```
Chrome (web) • chrome • web-javascript • Google Chrome
Edge (web)   • edge   • web-javascript • Microsoft Edge
```

### Step 4: Create a New Project with Web

```bash
flutter create my_web_app
cd my_web_app
```

Check the `web/` folder exists:
```
my_web_app/
├── android/
├── ios/
├── lib/
├── web/          ← Web-specific files
│   ├── index.html
│   ├── manifest.json
│   └── icons/
└── pubspec.yaml
```

### Step 5: Run on Web

```bash
flutter run -d chrome
```

Or in VS Code:
1. Press `F5`
2. Select **Chrome** as device
3. App opens in browser!

---

## Project Structure for Web

```
my_web_app/
├── web/
│   ├── index.html           # Main HTML file
│   ├── manifest.json        # PWA configuration
│   ├── favicon.png          # Website icon
│   └── icons/               # App icons (different sizes)
│       ├── Icon-192.png
│       └── Icon-512.png
├── lib/
│   └── main.dart            # Same as mobile!
└── pubspec.yaml
```

---

## Understanding web/index.html

**index.html** is the entry point for your web app.

```html
<!DOCTYPE html>
<html>
<head>
  <!-- Title in browser tab -->
  <title>My Flutter Web App</title>

  <!-- Character encoding -->
  <meta charset="UTF-8">

  <!-- Responsive viewport -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- App description (for SEO) -->
  <meta name="description" content="A beautiful Flutter web app">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <!-- PWA manifest -->
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <!-- Loading indicator (shown before app loads) -->
  <div id="loading">
    <style>
      #loading {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        font-family: sans-serif;
      }
    </style>
    <h2>Loading...</h2>
  </div>

  <!-- Flutter app loads here -->
  <script src="flutter.js" defer></script>
  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
</body>
</html>
```

### Customizing index.html

**1. Change Title and Description:**

```html
<title>My Awesome Dashboard</title>
<meta name="description" content="Professional admin dashboard built with Flutter">
```

**2. Add Custom Loading Screen:**

```html
<div id="loading">
  <style>
    #loading {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .spinner {
      border: 4px solid rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      border-top: 4px solid white;
      width: 40px;
      height: 40px;
      animation: spin 1s linear infinite;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    h2 {
      color: white;
      font-family: sans-serif;
      margin-top: 20px;
    }
  </style>
  <div class="spinner"></div>
  <h2>Loading Dashboard...</h2>
</div>
```

**3. Add Google Fonts:**

```html
<head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
```

---

## manifest.json - PWA Configuration

**manifest.json** makes your site installable as a Progressive Web App.

```json
{
  "name": "My Flutter Dashboard",
  "short_name": "Dashboard",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#667eea",
  "description": "Professional admin dashboard",
  "orientation": "any",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

**Key fields:**

- **name:** Full app name (shown on install)
- **short_name:** Short name (shown under icon)
- **display:** `standalone` = Looks like native app (no browser UI)
- **theme_color:** Browser toolbar color
- **background_color:** Splash screen color
- **icons:** App icons (different sizes)

---

## Your First Flutter Web App

### Basic Web App

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyWebApp());
}

class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Flutter Web!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This is running in your browser',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('Button clicked on web!');
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text(
                  'Click Me',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Run it:**
```bash
flutter run -d chrome
```

---

## Web vs Mobile - Key Differences

### 1. No Platform Channels on Web

```dart
// This WON'T work on web (uses Android/iOS specific features)
import 'package:battery_plus/battery_plus.dart';

// Solution: Check platform first
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  print('Running on web - no battery API');
} else {
  // Mobile-specific code
  var battery = Battery();
}
```

### 2. Different Screen Sizes

```dart
// Mobile: Usually 360-414px wide
// Web: Can be 1920px+ wide!

double getMaxWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (kIsWeb) {
    // Limit width on large screens for better readability
    return width > 1200 ? 1200 : width;
  }

  return width;
}
```

### 3. Mouse Hover Effects

```dart
// Web has mouse hover, mobile doesn't
InkWell(
  onTap: () {},
  hoverColor: Colors.blue.withOpacity(0.1),  // Works on web!
  child: Text('Hover me'),
)

// Or use MouseRegion
MouseRegion(
  onEnter: (_) => print('Mouse entered'),
  onExit: (_) => print('Mouse exited'),
  cursor: SystemMouseCursors.click,  // Change cursor
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Hover for effect'),
  ),
)
```

### 4. Right-Click Context Menu

```dart
// Disable default right-click menu
GestureDetector(
  onSecondaryTap: () {
    // Handle right-click
    print('Right-clicked!');
  },
  child: Text('Right-click me'),
)
```

### 5. URL Routing

```dart
// Web uses URL routing
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => HomeScreen(),
    '/about': (context) => AboutScreen(),
    '/dashboard': (context) => DashboardScreen(),
  },
)

// Navigate to route
Navigator.pushNamed(context, '/dashboard');

// URL in browser changes to: yoursite.com/dashboard
```

---

## Running and Testing

### Development Mode

```bash
# Run in Chrome
flutter run -d chrome

# Run in Edge
flutter run -d edge

# Run on specific port
flutter run -d chrome --web-port=8080

# Hot reload works!
# Press 'r' in terminal to reload
```

### Debug in Browser

1. Open Chrome DevTools (`F12`)
2. See console logs
3. Inspect elements
4. Check network requests
5. Test responsive design

---

## Building for Production

### Build Web App

```bash
flutter build web
```

Output goes to `build/web/`:
```
build/web/
├── index.html
├── main.dart.js
├── flutter.js
├── assets/
└── icons/
```

### Build Options

**1. Choose Renderer:**

```bash
# CanvasKit (default - best for dashboards)
flutter build web --web-renderer canvaskit

# HTML renderer (smaller, better for text-heavy sites)
flutter build web --web-renderer html

# Auto (Flutter chooses based on device)
flutter build web --web-renderer auto
```

**2. Optimize Build:**

```bash
# Production build with optimizations
flutter build web --release

# With specific base URL
flutter build web --base-href /myapp/
```

---

## Checking Platform

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  print('Running on web!');
} else {
  print('Running on mobile/desktop');
}

// Use in widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Different padding for web vs mobile
      padding: EdgeInsets.all(kIsWeb ? 32 : 16),
      child: Text('Hello'),
    );
  }
}
```

---

## Web-Specific Optimizations

### 1. Limit Max Width for Readability

```dart
class WebContainer extends StatelessWidget {
  final Widget child;

  const WebContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: kIsWeb ? 1200 : double.infinity,
        ),
        child: child,
      ),
    );
  }
}

// Usage
WebContainer(
  child: YourContent(),
)
```

### 2. Add Hover Effects

```dart
class HoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const HoverButton({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}
```

### 3. Lazy Loading for Performance

```dart
// Only load data when widget is visible
class LazyLoadedList extends StatefulWidget {
  @override
  _LazyLoadedListState createState() => _LazyLoadedListState();
}

class _LazyLoadedListState extends State<LazyLoadedList> {
  List<Item> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
  }

  Future<void> _loadMoreItems() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    // Load next 20 items
    final newItems = await fetchItems(skip: items.length, limit: 20);

    setState(() {
      items.addAll(newItems);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          // Load more when reaching end
          _loadMoreItems();
          return CircularProgressIndicator();
        }

        return ItemCard(item: items[index]);
      },
    );
  }
}
```

---

## Common Issues and Solutions

### Issue 1: CORS Errors

**Problem:** Can't fetch data from API

**Solution:** API must allow CORS, or use proxy

```dart
// Development: Use proxy
// Production: Configure API to allow your domain
```

### Issue 2: Large Initial Load

**Problem:** 2MB+ download on first load

**Solution:**
- Use HTML renderer for text-heavy sites
- Enable caching
- Use lazy loading
- Split code with deferred loading

### Issue 3: Text Selection Doesn't Work

**Problem:** Can't select text with CanvasKit

**Solution:** Use SelectableText

```dart
SelectableText('This text can be selected')
```

### Issue 4: Slow Performance on Mobile Web

**Problem:** Flutter web runs slow on phones

**Solution:**
- Build native mobile apps instead
- Or use HTML renderer
- Optimize images and assets

---

## Key Takeaways

1. **Flutter Web** = Build websites with Flutter
2. **Two renderers** = CanvasKit (dashboards) vs HTML (text sites)
3. **Same code** = Mobile and web use same Dart code
4. **`kIsWeb`** = Check if running on web
5. **index.html** = Customize loading screen and metadata
6. **manifest.json** = Make app installable (PWA)
7. **Hover effects** = Use MouseRegion for web
8. **Build** = `flutter build web`

---

## What's Next?

Tomorrow: **Web-Specific Responsive Layouts**
- Building responsive layouts WITHOUT packages
- Breakpoint systems for web
- Adaptive navigation (sidebar vs mobile menu)
- Grid systems from scratch
- Advanced responsive techniques

You've set up Flutter Web! Ready to build amazing websites! 🌐✨
