# Theming and Styling: Making Your App Beautiful

## The Simple Explanation

Imagine you're decorating your room. You could:
- **Option A:** Choose colors randomly for each wall
- **Option B:** Pick a color theme and use matching colors everywhere

```
OPTION A (No Theme - Messy!):
┌────────────────────────────────────┐
│  🟥 Red wall                       │
│  🟩 Green carpet                   │
│  🟦 Blue curtains                  │
│  🟨 Yellow door                    │
│  🟪 Purple lamp                    │
│                                    │
│  Nothing matches! 😵               │
└────────────────────────────────────┘

OPTION B (With Theme - Beautiful!):
┌────────────────────────────────────┐
│  🟦 Light blue walls               │
│  🔵 Dark blue carpet               │
│  💙 Medium blue curtains           │
│  🤍 White door                     │
│  🔵 Blue lamp                      │
│                                    │
│  Everything matches! 😍            │
└────────────────────────────────────┘
```

**Theming = Choosing ONE set of colors, fonts, and styles for your WHOLE app!**

---

## Why Use Themes?

### Without a Theme (The Hard Way)

```dart
// Screen 1
Text(
  'Hello',
  style: TextStyle(
    color: Colors.blue,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// Screen 2 (copy-paste, hope it matches!)
Text(
  'Welcome',
  style: TextStyle(
    color: Colors.blue,  // Hope I remember the exact color!
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// Screen 3 (oops, used different blue!)
Text(
  'Goodbye',
  style: TextStyle(
    color: Colors.lightBlue,  // Different blue! 😬
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

### With a Theme (The Smart Way)

```dart
// Define ONCE in your theme:
theme: ThemeData(
  primaryColor: Colors.blue,
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: Colors.blue,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
)

// Use everywhere:
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
)

Text(
  'Welcome',
  style: Theme.of(context).textTheme.headlineMedium,
)

Text(
  'Goodbye',
  style: Theme.of(context).textTheme.headlineMedium,
)

// ALL guaranteed to match! 🎉
```

---

## Setting Up a Theme

### Basic Theme Setup

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',

      // ← YOUR THEME GOES HERE!
      theme: ThemeData(
        // Main colors
        primarySwatch: Colors.blue,

        // Use Material 3 design
        useMaterial3: true,

        // App bar style
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        // Button style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      home: const HomePage(),
    );
  }
}
```

---

## Color Schemes: The Easy Way

Flutter provides `ColorScheme` to set up all your colors at once:

```dart
theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,  // Pick ONE color, Flutter creates the rest!
  ),
)
```

### What Colors Does It Create?

```
You provide: seedColor = Blue

Flutter creates:
┌──────────────────────────────────────────────┐
│  primary        → Main blue                  │
│  onPrimary      → White (text on blue)       │
│  secondary      → Complementary color        │
│  onSecondary    → Text on secondary          │
│  surface        → Card/dialog backgrounds    │
│  onSurface      → Text on surfaces           │
│  error          → Red for errors             │
│  onError        → Text on error              │
│  background     → Screen background          │
│  onBackground   → Text on background         │
└──────────────────────────────────────────────┘
```

### Using Color Scheme Colors

```dart
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)
```

---

## Light and Dark Themes

Most apps today have both light and dark modes:

```dart
MaterialApp(
  title: 'My App',

  // Light theme
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  ),

  // Dark theme
  darkTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),

  // Which theme to use
  themeMode: ThemeMode.system,  // Follow phone settings

  home: const HomePage(),
)
```

### Theme Mode Options

```
ThemeMode.system  → Follow phone's dark/light setting
ThemeMode.light   → Always light theme
ThemeMode.dark    → Always dark theme
```

---

## Switching Themes: User Choice

Let users pick their theme:

```dart
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: SettingsPage(
        currentMode: _themeMode,
        onThemeChanged: _setThemeMode,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('System'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) => onThemeChanged(value!),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Light'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) => onThemeChanged(value!),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) => onThemeChanged(value!),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Text Themes: Typography

Text themes define how different text looks:

```dart
theme: ThemeData(
  textTheme: const TextTheme(
    // Very big titles
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),

    // Page titles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),

    // Section titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),

    // Body text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),

    // Small text
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

### Using Text Styles

```dart
Text(
  'Big Title',
  style: Theme.of(context).textTheme.displayLarge,
)

Text(
  'Page Title',
  style: Theme.of(context).textTheme.headlineLarge,
)

Text(
  'Regular text paragraph goes here...',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

### Visual Comparison

```
displayLarge:   Big Title           (57px)
headlineLarge:  Page Title          (32px)
titleLarge:     Section Title       (22px)
bodyLarge:      Normal paragraph    (16px)
labelSmall:     tiny caption        (11px)
```

---

## Custom Fonts

### Step 1: Add Font Files

Put your font files in `assets/fonts/`:
```
your_app/
├── assets/
│   └── fonts/
│       ├── Poppins-Regular.ttf
│       ├── Poppins-Bold.ttf
│       └── Poppins-Light.ttf
├── lib/
└── pubspec.yaml
```

### Step 2: Register in pubspec.yaml

```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-Light.ttf
          weight: 300
```

### Step 3: Use in Theme

```dart
theme: ThemeData(
  fontFamily: 'Poppins',  // Default font for whole app
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,  // Uses Poppins-Bold.ttf
    ),
  ),
)
```

---

## Button Themes

Make all buttons look the same:

```dart
theme: ThemeData(
  // Elevated buttons (raised)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // Outlined buttons (with border)
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
    ),
  ),

  // Text buttons (no background)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
)
```

---

## Input Decoration Theme

Make all text fields look consistent:

```dart
theme: ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    // Border style
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),

    // Fill color
    filled: true,
    fillColor: Colors.grey[100],

    // Label style
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),

    // Focused state
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),

    // Error state
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),

    // Padding inside
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  ),
)
```

---

## Complete Theme Example

Here's a full theme setup:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    // App bar
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    // Cards
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),

    // Same other settings...
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

// Usage in main.dart:
void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    ),
  );
}
```

---

## Accessing Theme Values

```dart
// Get the current theme
final theme = Theme.of(context);

// Colors
Color primary = theme.colorScheme.primary;
Color background = theme.colorScheme.background;

// Text styles
TextStyle? headline = theme.textTheme.headlineLarge;
TextStyle? body = theme.textTheme.bodyLarge;

// Check if dark mode
bool isDark = theme.brightness == Brightness.dark;

// Example usage:
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              THEMING & STYLING SUMMARY                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: One place for all colors, fonts, and styles       │
│                                                          │
│  WHY:                                                    │
│  • Consistent look across the app                        │
│  • Easy to change colors (change once, updates all)      │
│  • Support dark mode easily                              │
│  • Professional appearance                               │
│                                                          │
│  KEY COMPONENTS:                                         │
│  • ThemeData - Container for all theme settings          │
│  • ColorScheme - All your colors                         │
│  • TextTheme - All your text styles                      │
│  • Theme.of(context) - Access theme anywhere             │
│                                                          │
│  QUICK SETUP:                                            │
│  ColorScheme.fromSeed(seedColor: Colors.blue)            │
│  → Flutter creates all matching colors for you!          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** Why is using themes better than setting colors individually?

<details>
<summary>Answer</summary>

1. **Consistency**: All screens use the same colors automatically
2. **Easy changes**: Change one place, updates everywhere
3. **Dark mode**: Easy to add light/dark themes
4. **Less code**: Define once, use everywhere

</details>

**Q2:** How do you access the current theme's primary color?

<details>
<summary>Answer</summary>

```dart
Theme.of(context).colorScheme.primary
```

</details>

**Q3:** What does `ColorScheme.fromSeed()` do?

<details>
<summary>Answer</summary>

It takes ONE color (the seed color) and automatically generates a complete color palette with:
- Primary and secondary colors
- Background colors
- Surface colors
- Error colors
- And matching "on" colors for text

So you only pick one color, and Flutter creates all the matching colors!

</details>

---

**Next:** Let's dive deep into Futures!

---

**Continue to:** `06-FuturesDeepDive.md`
