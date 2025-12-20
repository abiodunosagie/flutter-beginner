// Example 04: Theme Switcher
// Complete app with light/dark mode toggle

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

// ═══════════════════════════════════════════════════════════════
// APP WITH THEME SWITCHING
// ═══════════════════════════════════════════════════════════════

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Start with light mode
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Save and toggle theme
  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await prefs.setBool('is_dark_mode', newMode == ThemeMode.dark);

    setState(() {
      _themeMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Switcher Demo',
      debugShowCheckedModeBanner: false,

      // ─────────────────────────────────────────────────────────
      // LIGHT THEME - Like a sunny day!
      // ─────────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // Main color - like the "personality" of your app
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),

        // AppBar styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),

        // Card styling
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Button styling
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

        // Text styling
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),

      // ─────────────────────────────────────────────────────────
      // DARK THEME - Like nighttime!
      // ─────────────────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Main color for dark mode
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),

        // AppBar styling for dark
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Card styling for dark
        cardTheme: CardTheme(
          elevation: 4,
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Button styling for dark
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

        // Text styling for dark
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ),

      // Which theme to use
      themeMode: _themeMode,

      // Pass the toggle function to the home page
      home: ThemeDemoPage(onToggleTheme: _toggleTheme),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEMO PAGE
// ═══════════════════════════════════════════════════════════════

class ThemeDemoPage extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const ThemeDemoPage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher'),
        actions: [
          // Theme toggle button in AppBar
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────
            // CURRENT MODE INDICATOR
            // ─────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 48,
                      color: isDark ? Colors.yellow : Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDark ? 'Dark Mode' : 'Light Mode',
                            style: theme.textTheme.headlineLarge,
                          ),
                          Text(
                            isDark
                                ? 'Easy on the eyes at night!'
                                : 'Bright and cheerful!',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // THEME COLORS SHOWCASE
            // ─────────────────────────────────────────────────
            Text(
              'Theme Colors',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            // Color grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorBox(
                  color: theme.colorScheme.primary,
                  label: 'Primary',
                ),
                _ColorBox(
                  color: theme.colorScheme.secondary,
                  label: 'Secondary',
                ),
                _ColorBox(
                  color: theme.colorScheme.tertiary,
                  label: 'Tertiary',
                ),
                _ColorBox(
                  color: theme.colorScheme.surface,
                  label: 'Surface',
                  textColor: theme.colorScheme.onSurface,
                ),
                _ColorBox(
                  color: theme.colorScheme.error,
                  label: 'Error',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // BUTTONS SHOWCASE
            // ─────────────────────────────────────────────────
            Text(
              'Buttons',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // CARDS SHOWCASE
            // ─────────────────────────────────────────────────
            Text(
              'Cards',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('John Doe'),
                subtitle: const Text('john@example.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Title',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is a sample card with an image area and text content.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // TEXT STYLES SHOWCASE
            // ─────────────────────────────────────────────────
            Text(
              'Text Styles',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Display Large',
                        style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 24)), // Scaled down for display
                    Text('Headline Large',
                        style: theme.textTheme.headlineLarge),
                    Text('Title Large', style: theme.textTheme.titleLarge),
                    Text('Body Large', style: theme.textTheme.bodyLarge),
                    Text('Label Large', style: theme.textTheme.labelLarge),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // INPUT SHOWCASE
            // ─────────────────────────────────────────────────
            Text(
              'Input Fields',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────────────
            // BIG TOGGLE BUTTON
            // ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onToggleTheme,
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                label: Text(
                  isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COLOR BOX WIDGET
// ═══════════════════════════════════════════════════════════════

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;
  final Color? textColor;

  const _ColorBox({
    required this.color,
    required this.label,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. ThemeData
 *    - Defines all colors, fonts, and styles
 *    - Two themes: light and dark
 *    - Applied via MaterialApp
 *
 * 2. ThemeMode
 *    - ThemeMode.light: Use light theme
 *    - ThemeMode.dark: Use dark theme
 *    - ThemeMode.system: Follow device setting
 *
 * 3. ColorScheme.fromSeed()
 *    - Generates a complete color palette from one color
 *    - Material 3 feature
 *    - Ensures colors work well together
 *
 * 4. Theme.of(context)
 *    - Access current theme anywhere
 *    - Get colors: theme.colorScheme.primary
 *    - Get text styles: theme.textTheme.headlineLarge
 *
 * 5. Persisting Theme Choice
 *    - Save to SharedPreferences
 *    - Load when app starts
 *    - Remember user's preference
 *
 * ═══════════════════════════════════════════════════════════════
 * THEME PROPERTIES YOU CAN CUSTOMIZE:
 * ═══════════════════════════════════════════════════════════════
 *
 * colorScheme:       All colors in your app
 * textTheme:         All text styles
 * appBarTheme:       AppBar appearance
 * cardTheme:         Card appearance
 * elevatedButtonTheme: Elevated button style
 * inputDecorationTheme: Text field style
 * iconTheme:         Icon colors and sizes
 * floatingActionButtonTheme: FAB style
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a third theme (e.g., "nature" with green colors)
 * 2. Add system theme option (follow device setting)
 * 3. Create custom fonts for the theme
 * 4. Add theme animation when switching
 * 5. Save theme choice to SharedPreferences
 *
 */
