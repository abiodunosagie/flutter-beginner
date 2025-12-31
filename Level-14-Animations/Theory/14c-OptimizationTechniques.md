# 14c. Optimization Techniques - Making Apps Faster and Smaller

## What You'll Learn
Advanced optimization techniques to reduce build time, shrink app size, improve startup time, and make your Flutter app blazing fast.

---

## The Big Picture

Think of optimization like tuning a race car:
- **App Size** = Car weight (lighter = faster download)
- **Build Time** = Pit stop speed (faster = better developer experience)
- **Startup Time** = 0-60 mph time (faster = happy users)
- **Runtime Performance** = Top speed (smooth = great UX)

```
OPTIMIZATION JOURNEY
====================

Before                          After
┌──────────────────┐           ┌──────────────────┐
│ App Size: 50MB   │           │ App Size: 15MB   │
│ Build: 5 min     │  ──────>  │ Build: 30 sec    │
│ Startup: 3 sec   │           │ Startup: 0.5 sec │
│ FPS: 30          │           │ FPS: 60          │
└──────────────────┘           └──────────────────┘
```

---

## 1. App Size Optimization

### Understanding App Size Components

```
TYPICAL FLUTTER APP (30MB)
==========================

┌─────────────────────────────────────────┐
│ Flutter Engine:    8MB    27%  ██████   │
│ Your Code:         4MB    13%  ███      │
│ Assets (Images):  12MB    40%  ██████████│
│ Dependencies:      4MB    13%  ███      │
│ Native Code:       2MB     7%  ██       │
└─────────────────────────────────────────┘

Optimization targets:
1. Compress images        → Save 8MB
2. Remove unused packages → Save 2MB
3. Tree-shake code       → Save 1MB
Total savings: 11MB (37% smaller!)
```

### Technique 1: Image Optimization

```dart
// ❌ BAD: Using large PNG images
// File structure:
// assets/
//   background.png (5MB, 4000x3000)
//   logo.png (2MB, 2000x2000)
//   icon.png (1MB, 1000x1000)

class ImagesBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/background.png', width: 400),  // Shows at 400px, loads 4000px!
        Image.asset('assets/logo.png', width: 200),
        Image.asset('assets/icon.png', width: 100),
      ],
    );
  }
}

// Total impact: 8MB in app bundle

// ✅ GOOD: Optimized images
// File structure:
// assets/
//   background.webp (400KB, 800x600)      ← Converted to WebP, resized
//   logo.webp (150KB, 400x400)
//   icon.webp (20KB, 200x200)
//   background@2x.webp (800KB, 1600x1200) ← For high-DPI screens
//   logo@2x.webp (300KB, 800x800)
//   icon@2x.webp (40KB, 400x400)

class ImagesGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Automatically picks right resolution based on device
        Image.asset('assets/background.webp', width: 400),
        Image.asset('assets/logo.webp', width: 200),
        Image.asset('assets/icon.webp', width: 100),
      ],
    );
  }
}

// Total impact: 1.7MB in app bundle (80% reduction!)

// Update pubspec.yaml:
// flutter:
//   assets:
//     - assets/background.webp
//     - assets/background@2x.webp
//     - assets/logo.webp
//     - assets/logo@2x.webp
//     - assets/icon.webp
//     - assets/icon@2x.webp
```

Image Optimization Tools:

```bash
# Convert PNG to WebP (lossless)
cwebp background.png -o background.webp

# Convert with quality setting (lossy, smaller)
cwebp -q 80 background.png -o background.webp

# Resize images
sips -Z 800 background.png --out background_800.png  # macOS
convert background.png -resize 800x600 background_800.png  # ImageMagick

# Batch optimize all PNGs
find assets -name "*.png" -exec pngquant --quality=80 {} \;
```

### Technique 2: Remove Unused Assets

```yaml
# ❌ BAD: Including everything
flutter:
  assets:
    - assets/  # Includes ALL files, even unused ones!

# ✅ GOOD: Only include what you use
flutter:
  assets:
    - assets/logo.webp
    - assets/icon.webp
    - assets/background.webp
    # Don't include:
    # - old_logo.png (not used)
    # - test_image.jpg (only for testing)
    # - unused_icon.png
```

Find unused assets:

```bash
# Find all assets
find assets -type f > all_assets.txt

# Search code for each asset
while read asset; do
  filename=$(basename "$asset")
  if ! grep -r "$filename" lib/; then
    echo "Unused: $asset"
  fi
done < all_assets.txt
```

### Technique 3: Tree Shaking and Code Splitting

```dart
// ❌ BAD: Importing entire libraries
import 'package:flutter/material.dart';  // Imports everything
import 'package:intl/intl.dart';         // Imports all formatters

// ✅ GOOD: Import only what you need
import 'package:flutter/material.dart' show MaterialApp, Scaffold, Text;
import 'package:intl/intl.dart' show DateFormat;

// ❌ BAD: Unused dependencies in pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  dio: ^5.0.0              # ← Both http AND dio? Pick one!
  provider: ^6.0.0
  riverpod: ^2.0.0         # ← Both provider AND riverpod? Pick one!
  shared_preferences: ^2.0.0
  hive: ^2.0.0             # ← Both? Pick one!

# ✅ GOOD: Only necessary dependencies
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.0.0
  riverpod: ^2.0.0
  hive: ^2.0.0
```

Analyze dependencies:

```bash
# Find unused dependencies
flutter pub deps
flutter pub outdated

# Remove unused packages
flutter pub remove package_name

# Analyze what's taking space
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

### Technique 4: Font Optimization

```yaml
# ❌ BAD: Including full font families
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Thin.ttf
          weight: 100
        - asset: fonts/Roboto-Light.ttf
          weight: 300
        - asset: fonts/Roboto-Regular.ttf
          weight: 400
        - asset: fonts/Roboto-Medium.ttf
          weight: 500
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
        - asset: fonts/Roboto-Black.ttf
          weight: 900
        # Each font: ~150KB → Total: ~900KB

# ✅ GOOD: Only include weights you use
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
          weight: 400
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
        # Total: ~300KB (67% reduction!)
```

---

## 2. Build Time Optimization

### Technique 5: Incremental Builds

```dart
// ❌ BAD: Large single file
// lib/main.dart (5000 lines)
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // ... 100 widgets in one file
}

class Widget1 extends StatelessWidget { /* ... */ }
class Widget2 extends StatelessWidget { /* ... */ }
// ... 98 more widgets
class Widget100 extends StatelessWidget { /* ... */ }

// Every change = rebuild everything (slow!)

// ✅ GOOD: Split into modules
// lib/main.dart
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

// lib/screens/home_screen.dart
import '../widgets/product_card.dart';
import '../widgets/category_list.dart';

class HomeScreen extends StatelessWidget {
  // Only this file rebuilds when changed
}

// lib/widgets/product_card.dart
class ProductCard extends StatelessWidget {
  // Independent widget
}

// Now changing product_card.dart only rebuilds that file!
```

Project Structure for Fast Builds:

```
lib/
├── main.dart                  ← Entry point only
├── app/
│   ├── app.dart              ← App configuration
│   └── routes.dart           ← Route definitions
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── widgets/
│   │   │   └── login_form.dart
│   │   └── services/
│   │       └── auth_service.dart
│   ├── products/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   └── cart/
│       ├── screens/
│       ├── widgets/
│       └── services/
├── shared/
│   ├── widgets/              ← Reusable widgets
│   ├── models/               ← Data models
│   └── utils/                ← Utilities
└── services/
    ├── api_service.dart
    └── storage_service.dart

Benefits:
✓ Change one feature → only that feature rebuilds
✓ Parallel builds (multiple files at once)
✓ Better code organization
✓ Easier to maintain
```

### Technique 6: Generated Code Optimization

```dart
// Use build_runner efficiently

// ❌ BAD: Running full build every time
flutter pub run build_runner build

// ✅ GOOD: Use watch mode during development
flutter pub run build_runner watch

// ✅ BETTER: Only rebuild changed files
flutter pub run build_runner build --delete-conflicting-outputs

// Clean build when needed
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Technique 7: Precompile Regex and Constants

```dart
// ❌ BAD: Creating regex on every use
class EmailValidatorBad {
  bool isValid(String email) {
    // This compiles regex EVERY time!
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// ✅ GOOD: Compile once
class EmailValidatorGood {
  // Compiled once at class creation
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool isValid(String email) {
    return _emailRegex.hasMatch(email);
  }
}

// ❌ BAD: Recreating lists
class CategoryFilterBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Creates new list every build!
    final categories = ['Electronics', 'Clothing', 'Food', 'Books'];

    return DropdownButton<String>(
      items: categories.map((cat) {
        return DropdownMenuItem(value: cat, child: Text(cat));
      }).toList(),
      onChanged: (value) {},
    );
  }
}

// ✅ GOOD: Use const
class CategoryFilterGood extends StatelessWidget {
  // Created once, reused
  static const categories = ['Electronics', 'Clothing', 'Food', 'Books'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: categories.map((cat) {
        return DropdownMenuItem(value: cat, child: Text(cat));
      }).toList(),
      onChanged: (value) {},
    );
  }
}
```

---

## 3. Startup Time Optimization

### Technique 8: Lazy Initialization

```dart
// ❌ BAD: Initialize everything at startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // All of these run before app shows (slow startup!)
  await Firebase.initializeApp();
  await setupDatabase();
  await loadUserPreferences();
  await initializeAnalytics();
  await loadRemoteConfig();
  await setupNotifications();
  // Startup time: 5 seconds 😞

  runApp(MyApp());
}

Future<void> setupDatabase() async {
  await Future.delayed(Duration(seconds: 1));
}

Future<void> loadUserPreferences() async {
  await Future.delayed(Duration(seconds: 1));
}

Future<void> initializeAnalytics() async {
  await Future.delayed(Duration(seconds: 1));
}

Future<void> loadRemoteConfig() async {
  await Future.delayed(Duration(seconds: 1));
}

Future<void> setupNotifications() async {
  await Future.delayed(Duration(seconds: 1));
}

// ✅ GOOD: Initialize only what's critical
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only critical initialization
  await Firebase.initializeApp();
  // Startup time: 0.5 seconds 😊

  runApp(MyApp());

  // Initialize rest in background
  _initializeInBackground();
}

void _initializeInBackground() async {
  // These can happen after app shows
  await setupDatabase();
  await loadUserPreferences();
  await initializeAnalytics();
  await loadRemoteConfig();
  await setupNotifications();
}

// ✅ EVEN BETTER: Lazy load on demand
class DatabaseService {
  static Database? _database;

  // Only initializes when first accessed
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // Initialize database
    await Future.delayed(Duration(seconds: 1));
    return Database();
  }
}

class Database {}

// Usage:
Future<void> loadData() async {
  final db = await DatabaseService.database;  // Initializes only if needed
  // Use db...
}
```

### Technique 9: Deferred Loading (Code Splitting)

```dart
// Large feature that's rarely used - load it only when needed

// ❌ BAD: Import everything upfront
import 'package:my_app/features/video_editor/video_editor.dart';  // 5MB of code!

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoEditorScreen()),
        );
      },
      child: Text('Open Video Editor'),
    );
  }
}

// App size: 30MB (includes video editor even if never used)

// ✅ GOOD: Deferred import
import 'package:my_app/features/video_editor/video_editor.dart' deferred as video_editor;

class HomePage extends StatelessWidget {
  Future<void> _openVideoEditor(BuildContext context) async {
    // Show loading
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // Load the code
    await video_editor.loadLibrary();

    // Hide loading
    Navigator.pop(context);

    // Now use it
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => video_editor.VideoEditorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openVideoEditor(context),
      child: Text('Open Video Editor'),
    );
  }
}

// Initial app size: 25MB (5MB saved!)
// Video editor downloads only when user opens it
```

---

## 4. Runtime Performance Optimization

### Technique 10: RepaintBoundary

```dart
// ❌ BAD: Entire screen repaints on animation
class AnimationWithoutBoundary extends StatefulWidget {
  @override
  State<AnimationWithoutBoundary> createState() => _AnimationWithoutBoundaryState();
}

class _AnimationWithoutBoundaryState extends State<AnimationWithoutBoundary>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // This static content repaints on every frame!
        ExpensiveHeader(),
        ComplexImage(),

        // Animated part
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: Container(width: 100, height: 100, color: Colors.blue),
            );
          },
        ),

        ExpensiveFooter(),
      ],
    );
  }
}

class ExpensiveHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(400, 100),
      painter: ComplexPainter(),
    );
  }
}

class ComplexImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/complex_image.png');
  }
}

class ExpensiveFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 100, color: Colors.grey);
  }
}

class ComplexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Complex drawing
    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(i * 4.0, 50),
        10,
        Paint()..color = Colors.red,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Performance: 30 FPS (entire screen repainting)

// ✅ GOOD: Use RepaintBoundary
class AnimationWithBoundary extends StatefulWidget {
  @override
  State<AnimationWithBoundary> createState() => _AnimationWithBoundaryState();
}

class _AnimationWithBoundaryState extends State<AnimationWithBoundary>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wrap static content in RepaintBoundary
        RepaintBoundary(child: ExpensiveHeader()),
        RepaintBoundary(child: ComplexImage()),

        // Wrap animated part separately
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: child,
              );
            },
            child: Container(width: 100, height: 100, color: Colors.blue),
          ),
        ),

        RepaintBoundary(child: ExpensiveFooter()),
      ],
    );
  }
}

// Performance: 60 FPS (only animated box repaints!)
```

### Technique 11: Const Constructors Everywhere

```dart
// ❌ BAD: No const
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),  // Rebuilt every time
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
          ),
        ],
      ),
    );
  }
}

// Every setState rebuilds all widgets

// ✅ GOOD: Use const everywhere possible
class SettingsScreenGood extends StatelessWidget {
  const SettingsScreenGood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),  // const = never rebuilds
      ),
      body: Column(
        children: const [  // const = entire list never rebuilds
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
          ),
        ],
      ),
    );
  }
}

// Even with setState, these widgets never rebuild!
```

### Technique 12: Compute for Heavy Operations

```dart
import 'dart:isolate';
import 'package:flutter/foundation.dart';

// ❌ BAD: Heavy computation on main thread
class DataProcessingBad extends StatefulWidget {
  @override
  State<DataProcessingBad> createState() => _DataProcessingBadState();
}

class _DataProcessingBadState extends State<DataProcessingBad> {
  List<int> _data = [];
  bool _processing = false;

  Future<void> _processData() async {
    setState(() => _processing = true);

    // This runs on main thread - freezes UI!
    _data = _expensiveComputation(List.generate(1000000, (i) => i));

    setState(() => _processing = false);
  }

  List<int> _expensiveComputation(List<int> data) {
    // Heavy computation (takes 2 seconds)
    return data.map((n) {
      int result = n;
      for (int i = 0; i < 100; i++) {
        result = (result * 2) % 1000;
      }
      return result;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _processing
            ? CircularProgressIndicator()  // This freezes during computation!
            : ElevatedButton(
                onPressed: _processData,
                child: Text('Process Data'),
              ),
      ),
    );
  }
}

// ✅ GOOD: Use compute to run on background isolate
class DataProcessingGood extends StatefulWidget {
  @override
  State<DataProcessingGood> createState() => _DataProcessingGoodState();
}

class _DataProcessingGoodState extends State<DataProcessingGood> {
  List<int> _data = [];
  bool _processing = false;

  Future<void> _processData() async {
    setState(() => _processing = true);

    // Runs on separate isolate - UI stays responsive!
    _data = await compute(_expensiveComputation, List.generate(1000000, (i) => i));

    setState(() => _processing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _processing
            ? CircularProgressIndicator()  // This animates smoothly!
            : ElevatedButton(
                onPressed: _processData,
                child: Text('Process Data'),
              ),
      ),
    );
  }
}

// Top-level function (required for compute)
List<int> _expensiveComputation(List<int> data) {
  return data.map((n) {
    int result = n;
    for (int i = 0; i < 100; i++) {
      result = (result * 2) % 1000;
    }
    return result;
  }).toList();
}
```

---

## 5. Memory Optimization

### Technique 13: Proper Stream and Timer Disposal

```dart
// ❌ BAD: Memory leak - timer never canceled
class TimerLeakBad extends StatefulWidget {
  @override
  State<TimerLeakBad> createState() => _TimerLeakBadState();
}

class _TimerLeakBadState extends State<TimerLeakBad> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Timer runs forever, even after widget disposed!
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _counter++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}

// Memory keeps growing, timer never stops!

// ✅ GOOD: Cancel timer in dispose
class TimerLeakFixed extends StatefulWidget {
  @override
  State<TimerLeakFixed> createState() => _TimerLeakFixedState();
}

class _TimerLeakFixedState extends State<TimerLeakFixed> {
  int _counter = 0;
  Timer? _timer;  // Keep reference

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {  // Check if widget still in tree
        setState(() => _counter++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel timer!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}

// ❌ BAD: Stream subscription leak
class StreamLeakBad extends StatefulWidget {
  final Stream<int> dataStream;
  const StreamLeakBad({required this.dataStream});

  @override
  State<StreamLeakBad> createState() => _StreamLeakBadState();
}

class _StreamLeakBadState extends State<StreamLeakBad> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    // Never canceled!
    widget.dataStream.listen((value) {
      setState(() => _value = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Value: $_value');
  }
}

// ✅ GOOD: Cancel stream subscription
class StreamLeakFixed extends StatefulWidget {
  final Stream<int> dataStream;
  const StreamLeakFixed({required this.dataStream});

  @override
  State<StreamLeakFixed> createState() => _StreamLeakFixedState();
}

class _StreamLeakFixedState extends State<StreamLeakFixed> {
  int _value = 0;
  StreamSubscription<int>? _subscription;  // Keep reference

  @override
  void initState() {
    super.initState();
    _subscription = widget.dataStream.listen((value) {
      if (mounted) {
        setState(() => _value = value);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();  // Cancel subscription!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Value: $_value');
  }
}
```

### Technique 14: Image Cache Management

```dart
import 'package:flutter/painting.dart';

// ❌ BAD: Images stay in memory forever
class ImageCacheBad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return Image.network(
          'https://example.com/image_$index.jpg',
          // Stays in cache forever!
        );
      },
    );
  }
}

// Memory grows to 500MB+

// ✅ GOOD: Configure cache limits
void main() {
  // Set image cache limits
  PaintingBinding.instance.imageCache.maximumSize = 100;  // Max 100 images
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;  // Max 50MB

  runApp(MyApp());
}

class ImageCacheGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return Image.network(
          'https://example.com/image_$index.jpg',
          cacheWidth: 400,  // Resize in cache
          cacheHeight: 300,
        );
      },
    );
  }
}

// Clear cache manually when needed
void clearImageCache() {
  PaintingBinding.instance.imageCache.clear();
  PaintingBinding.instance.imageCache.clearLiveImages();
}
```

---

## 6. Complete Optimization Example

```dart
// Complete shopping app with all optimizations applied

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure image cache
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  // Only critical init
  await _initCritical();

  runApp(const MyApp());

  // Background init
  _initBackground();
}

Future<void> _initCritical() async {
  // Minimal critical initialization
  await Future.delayed(Duration(milliseconds: 100));
}

void _initBackground() async {
  // Non-critical initialization
  await Future.delayed(Duration(seconds: 1));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimized Shop',
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Lazy-loaded data
  late final List<Product> _products = _generateProducts();

  // Compile regex once
  static final _searchRegex = RegExp(r'\w+', caseSensitive: false);

  List<Product> _generateProducts() {
    return List.generate(1000, (i) => Product(
      id: i.toString(),
      name: 'Product $i',
      price: (i * 10).toDouble(),
      imageUrl: 'https://via.placeholder.com/150',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RepaintBoundary(
        child: ListView.builder(
          itemCount: _products.length,
          itemExtent: 200,  // Fixed height for better performance
          itemBuilder: (context, index) {
            return ProductCard(
              key: ValueKey(_products[index].id),
              product: _products[index],
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            cacheWidth: 50,  // Resize in cache
            cacheHeight: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
```

---

## 7. Optimization Checklist

```
BEFORE RELEASE CHECKLIST
========================

App Size:
☐ Images compressed (WebP format)
☐ Images properly sized (not loading 4K for thumbnails)
☐ Unused assets removed
☐ Unused dependencies removed
☐ Tree shaking enabled (default in release mode)
☐ Only necessary font weights included

Build Time:
☐ Code split into modules
☐ Generated code uses watch mode in dev
☐ Const constructors used everywhere possible

Startup Time:
☐ Only critical initialization in main()
☐ Non-critical init runs in background
☐ Heavy services loaded lazily
☐ Deferred imports for large features

Runtime Performance:
☐ RepaintBoundary used for complex static content
☐ Const widgets used where possible
☐ Heavy computations use compute()
☐ ListView.builder for long lists
☐ Keys on dynamic lists

Memory:
☐ Timers canceled in dispose
☐ Stream subscriptions canceled in dispose
☐ Image cache configured
☐ No memory leaks (tested with DevTools Memory tab)

Release Build:
☐ Test in profile mode first
☐ Run flutter build --analyze-size
☐ Verify app size is acceptable
☐ Test on low-end devices
☐ Check startup time < 2 seconds
☐ Verify smooth scrolling (60 FPS)
```

---

## Quick Reference

### Commands

```bash
# Analyze app size
flutter build apk --analyze-size
flutter build appbundle --analyze-size

# Profile mode
flutter run --profile

# Release build
flutter build apk --release
flutter build appbundle --release

# Clean build
flutter clean
flutter pub get
flutter build apk
```

### Size Targets

```
Excellent:  < 15MB
Good:       15-30MB
Acceptable: 30-50MB
Large:      > 50MB (consider optimization!)
```

### Performance Targets

```
Startup:  < 1 second
FPS:      60 (16.67ms per frame)
Memory:   < 100MB for simple apps
          < 200MB for complex apps
```

---

## What's Next?

You now know optimization techniques! Next:

- **14x. Flutter Animate** - Declarative animations
- **14y. Lottie Animations** - JSON-based animations
- **14z. Rive Animations** - Interactive animations

---

## Navigation

- Previous: [14b. Performance Profiling](14b-PerformanceProfiling.md)
- Next: [14x. Flutter Animate Package](14x-FlutterAnimate.md)
- [Learning Path](../LearningPath.md)

---

**Estimated reading time: 25 minutes**

**Remember**: Optimization is like tuning a race car - compress assets, lazy load features, use const constructors, and profile often. Small improvements add up to a dramatically faster app!
