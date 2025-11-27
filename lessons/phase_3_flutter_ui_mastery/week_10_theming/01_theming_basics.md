# Week 10, Day 1-3: Theming - Consistent App Styling

## 5-Year-Old Explanation

Imagine you're decorating your room. You could make each wall a different color:
- One wall is pink
- One wall is green
- One wall has stripes
- One wall has polka dots

But that would look messy and weird! Instead, you pick a THEME:
- "Ocean Theme" → Everything is blue, with fish and waves
- "Space Theme" → Everything is dark with stars and planets
- "Princess Theme" → Everything is pink with sparkles

Once you pick your theme, EVERYTHING matches! Your blanket, your curtains, your toys, your rug - they all look like they belong together.

**In Flutter apps, theming works the same way!**

Without theming: You make every button blue, every heading bold, every card rounded... 100 times! If you want to change the blue to red later, you have to change it in 100 places!

With theming: You say "My app's theme is blue and bold" ONCE. Now every button automatically becomes blue, every heading automatically becomes bold. Change the theme once, and the WHOLE APP changes!

**Real-world example:**
Think about McDonald's - everywhere you go, McDonald's looks the same. Red and yellow colors, same fonts, same style. That's because they have a theme! Your app should be the same - consistent style everywhere.

Theming makes your app look professional and saves you tons of work!

---

## What is Theming?

**Theming** = Centralized styling for your entire app.

**Think of it like:**
- Brand guidelines for a company
- Interior design theme for a house
- Uniform style across all pages

**Without theming:**
```dart
// Every button manually styled
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    textStyle: TextStyle(fontSize: 16),
  ),
  child: Text('Click'),
)
// Repeat 100 times...
```

**With theming:**
```dart
// Define once
ThemeData(primaryColor: Colors.blue)

// Use everywhere
ElevatedButton(child: Text('Click'))  // Automatically styled!
```

---

## ThemeData Basics

### Setting App Theme

```dart
MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  ),
  home: HomeScreen(),
)
```

### Common Theme Properties

```dart
ThemeData(
  // Primary color
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[700],

  // Accent color (for secondary actions)
  colorScheme: ColorScheme.light(
    secondary: Colors.orange,
  ),

  // Brightness (light or dark)
  brightness: Brightness.light,

  // App bar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 4,
  ),

  // Text theme
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),

  // Card theme
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

---

## Using Theme in Widgets

### Accessing Theme

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get theme
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: Text(
        'Hello',
        style: theme.textTheme.displayLarge,
      ),
    );
  }
}
```

### Common Theme Accessors

```dart
// Colors
Theme.of(context).primaryColor
Theme.of(context).colorScheme.secondary
Theme.of(context).scaffoldBackgroundColor
Theme.of(context).cardColor

// Text styles
Theme.of(context).textTheme.displayLarge
Theme.of(context).textTheme.displayMedium
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium

// Other
Theme.of(context).appBarTheme
Theme.of(context).elevatedButtonTheme
```

---

## Complete Theme Example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: ThemeData(
        // Primary color
        primarySwatch: Colors.deepPurple,

        // Color scheme
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
          secondary: Colors.amber,
          surface: Colors.white,
          background: Colors.grey[100]!,
          error: Colors.red,
        ),

        // App bar
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Text theme
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),

        // Cards
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Themed App'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title using theme
            Text(
              'Welcome!',
              style: theme.textTheme.displayLarge,
            ),
            SizedBox(height: 8),
            Text(
              'This app uses consistent theming',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Card using theme
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Title',
                      style: theme.textTheme.displayMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This card automatically uses the theme\'s card styling.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Buttons using theme
            ElevatedButton(
              onPressed: () {},
              child: Text('Elevated Button'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: Text('Text Button'),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: Text('Outlined Button'),
            ),

            SizedBox(height: 24),

            // Input using theme
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## Dark Mode

### Basic Dark Theme

```dart
MaterialApp(
  theme: ThemeData.light(),      // Light theme
  darkTheme: ThemeData.dark(),   // Dark theme
  themeMode: ThemeMode.system,   // Follow system setting
  home: HomeScreen(),
)
```

**ThemeMode options:**
- `ThemeMode.light` - Always light
- `ThemeMode.dark` - Always dark
- `ThemeMode.system` - Follow device setting (recommended)

### Custom Dark Theme

```dart
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,

  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple[300]!,
    secondary: Colors.amber,
    surface: Colors.grey[900]!,
    background: Colors.black,
  ),

  scaffoldBackgroundColor: Colors.black,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
  ),

  cardTheme: CardTheme(
    color: Colors.grey[900],
    elevation: 4,
  ),

  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white70),
  ),
)
```

### Toggle Dark Mode

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomeScreen(onToggleTheme: toggleTheme),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Mode Demo'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDark ? Icons.nights_stay : Icons.wb_sunny,
              size: 100,
              color: theme.primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: theme.textTheme.displayLarge,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onToggleTheme,
              child: Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Custom Colors

### Color Palette

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6200EA);
  static const Color primaryLight = Color(0xFF9D46FF);
  static const Color primaryDark = Color(0xFF0A00B6);

  // Secondary colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);

  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
}

// Usage in theme
ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
  ),
)
```

---

## Text Styles

### Custom Text Theme

```dart
TextTheme buildTextTheme() {
  return TextTheme(
    // Display styles (large headings)
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}

// Usage
ThemeData(
  textTheme: buildTextTheme(),
)
```

### Using Text Styles

```dart
Text(
  'Heading',
  style: Theme.of(context).textTheme.displayLarge,
)

Text(
  'Subheading',
  style: Theme.of(context).textTheme.headlineMedium,
)

Text(
  'Body text',
  style: Theme.of(context).textTheme.bodyLarge,
)

Text(
  'Caption',
  style: Theme.of(context).textTheme.bodySmall,
)
```

---

## Custom Fonts

### 1. Add Fonts to Project

**pubspec.yaml:**
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

### 2. Use in Theme

```dart
ThemeData(
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    // ...
  ),
)
```

### 3. Use Google Fonts (Easy Way)

**pubspec.yaml:**
```yaml
dependencies:
  google_fonts: ^6.1.0
```

**Code:**
```dart
import 'package:google_fonts/google_fonts.dart';

ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
)

// Or specific text
Text(
  'Hello',
  style: GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## Component Themes

### Button Themes

```dart
ThemeData(
  // Elevated button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // Text button
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),

  // Outlined button
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: BorderSide(color: Colors.blue, width: 2),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
)
```

### Input Themes

```dart
ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],

    // Border
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),

    // Focused border
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),

    // Error border
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),

    // Label style
    labelStyle: TextStyle(color: Colors.grey[600]),
    floatingLabelStyle: TextStyle(color: Colors.blue),

    // Padding
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
)
```

---

## Complete Real-World Theme

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,

    colorScheme: ColorScheme.light(
      primary: Colors.indigo,
      secondary: Colors.orange,
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      error: Colors.red[700]!,
    ),

    scaffoldBackgroundColor: Color(0xFFF5F5F5),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.indigo, width: 2),
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,

    colorScheme: ColorScheme.dark(
      primary: Colors.indigo[300]!,
      secondary: Colors.orange,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Colors.red[300]!,
    ),

    scaffoldBackgroundColor: Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF1E1E1E),
    ),
  );
}

// Usage
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  home: HomeScreen(),
)
```

---

## Key Takeaways

1. **ThemeData** = Centralized styling
2. **theme** / **darkTheme** = Light and dark modes
3. **Theme.of(context)** = Access theme in widgets
4. **ColorScheme** = Consistent color palette
5. **TextTheme** = Typography system
6. **Component themes** = Button, input, card styling
7. **Custom fonts** = Brand identity
8. **Reuse themes** = Consistent design across app

---

## What's Next?

Tomorrow: **Responsive Design**
- MediaQuery
- LayoutBuilder
- Adaptive layouts
- Screen size breakpoints

You've mastered theming! Your apps look professional! 🎨✨
