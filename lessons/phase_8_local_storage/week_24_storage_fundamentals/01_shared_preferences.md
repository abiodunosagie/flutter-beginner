# SharedPreferences: Simple Local Storage

## What You'll Learn

In this ultra-detailed lesson, you'll master:
- What SharedPreferences is and when to use it
- Storing simple data types (strings, numbers, booleans)
- Storing complex data with JSON
- Best practices for key naming
- Async operations with SharedPreferences
- Building a settings screen
- Building a favorites system
- Dark mode persistence
- Onboarding flow with "don't show again"
- Data migration strategies

By the end, you'll handle simple local storage like a pro!

## Understanding SharedPreferences (Like Teaching a 5-Year-Old)

### What is SharedPreferences?

Imagine you have a small notebook 📓:
- You can write notes: "Favorite color = Blue"
- You can read notes later: "What's my favorite color? ...Blue!"
- Notes stay there even if you close the notebook
- Simple notes only (not entire essays!)

**SharedPreferences is like that notebook:**
- Save simple data: name, settings, preferences
- Read it back anytime
- Data survives app restart
- NOT for complex or large data

### Real-Life Examples

```dart
// ❌ DON'T use SharedPreferences for:
- Storing 10,000 products (too much!)
- Storing images (too big!)
- Complex relational data (use database!)
- Sensitive data like passwords (use secure storage!)

// ✅ DO use SharedPreferences for:
- User settings (dark mode, language)
- Simple preferences (favorite team, color)
- "Don't show again" flags
- Last viewed screen
- Simple counters
```

## Step 1: Setup

### Add Dependency

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
```

Run:

```bash
flutter pub get
```

### Import

```dart
import 'package:shared_preferences/shared_preferences.dart';
```

## Step 2: Basic Operations

### Saving Data

```dart
// Get SharedPreferences instance
final prefs = await SharedPreferences.getInstance();

// Save different types
await prefs.setString('username', 'JohnDoe');
await prefs.setInt('age', 25);
await prefs.setDouble('height', 5.9);
await prefs.setBool('isDarkMode', true);

// Save list of strings
await prefs.setStringList('favorites', ['Apple', 'Banana', 'Cherry']);
```

### Reading Data

```dart
final prefs = await SharedPreferences.getInstance();

// Read with default values if not found
final username = prefs.getString('username') ?? 'Guest';
final age = prefs.getInt('age') ?? 0;
final height = prefs.getDouble('height') ?? 0.0;
final isDarkMode = prefs.getBool('isDarkMode') ?? false;
final favorites = prefs.getStringList('favorites') ?? [];

print('Username: $username');
print('Age: $age');
print('Dark mode: $isDarkMode');
```

### Checking if Key Exists

```dart
final prefs = await SharedPreferences.getInstance();

if (prefs.containsKey('username')) {
  print('Username exists!');
} else {
  print('No username saved');
}
```

### Removing Data

```dart
final prefs = await SharedPreferences.getInstance();

// Remove specific key
await prefs.remove('username');

// Remove all data (be careful!)
await prefs.clear();
```

### Getting All Keys

```dart
final prefs = await SharedPreferences.getInstance();

final allKeys = prefs.getKeys();
print('All keys: $allKeys');
```

## Step 3: Storing Complex Data with JSON

SharedPreferences only stores simple types. For objects, use JSON:

### Saving an Object

```dart
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
    );
  }
}

// Save user
Future<void> saveUser(User user) async {
  final prefs = await SharedPreferences.getInstance();

  // Convert user to JSON string
  final jsonString = jsonEncode(user.toJson());

  // Save string
  await prefs.setString('current_user', jsonString);
}

// Load user
Future<User?> loadUser() async {
  final prefs = await SharedPreferences.getInstance();

  // Get JSON string
  final jsonString = prefs.getString('current_user');

  if (jsonString == null) return null;

  // Convert back to User
  final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
  return User.fromJson(jsonMap);
}
```

### Saving a List of Objects

```dart
// Save list of users
Future<void> saveUsers(List<User> users) async {
  final prefs = await SharedPreferences.getInstance();

  // Convert each user to JSON
  final jsonList = users.map((user) => user.toJson()).toList();

  // Convert list to JSON string
  final jsonString = jsonEncode(jsonList);

  // Save
  await prefs.setString('users', jsonString);
}

// Load list of users
Future<List<User>> loadUsers() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonString = prefs.getString('users');

  if (jsonString == null) return [];

  // Decode JSON string
  final List<dynamic> jsonList = jsonDecode(jsonString);

  // Convert each JSON to User
  return jsonList
      .map((json) => User.fromJson(json as Map<String, dynamic>))
      .toList();
}
```

## Step 4: Creating a Settings Service

Let's build a complete settings service:

```dart
class SettingsService {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLanguage = 'language';
  static const String _keyNotifications = 'notifications';
  static const String _keyFontSize = 'font_size';

  // Singleton pattern
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  // Initialize (call once at app start)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Dark Mode
  bool get isDarkMode => _prefs?.getBool(_keyDarkMode) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_keyDarkMode, value);
  }

  // Language
  String get language => _prefs?.getString(_keyLanguage) ?? 'en';

  Future<void> setLanguage(String value) async {
    await _prefs?.setString(_keyLanguage, value);
  }

  // Notifications
  bool get notificationsEnabled =>
      _prefs?.getBool(_keyNotifications) ?? true;

  Future<void> setNotifications(bool value) async {
    await _prefs?.setBool(_keyNotifications, value);
  }

  // Font Size
  double get fontSize => _prefs?.getDouble(_keyFontSize) ?? 16.0;

  Future<void> setFontSize(double value) async {
    await _prefs?.setDouble(_keyFontSize, value);
  }

  // Reset all settings
  Future<void> resetToDefaults() async {
    await _prefs?.clear();
  }

  // Export settings
  Map<String, dynamic> exportSettings() {
    return {
      'darkMode': isDarkMode,
      'language': language,
      'notifications': notificationsEnabled,
      'fontSize': fontSize,
    };
  }

  // Import settings
  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('darkMode')) {
      await setDarkMode(settings['darkMode'] as bool);
    }
    if (settings.containsKey('language')) {
      await setLanguage(settings['language'] as String);
    }
    if (settings.containsKey('notifications')) {
      await setNotifications(settings['notifications'] as bool);
    }
    if (settings.containsKey('fontSize')) {
      await setFontSize(settings['fontSize'] as double);
    }
  }
}

// Initialize in main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SettingsService().init();

  runApp(MyApp());
}
```

## Step 5: Settings Screen Example

```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settings = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Dark Mode Toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: _settings.isDarkMode,
            onChanged: (value) async {
              await _settings.setDarkMode(value);
              setState(() {});
              // In real app, update theme here
            },
          ),

          const Divider(),

          // Language Selector
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_settings.language),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final language = await _showLanguageDialog();
              if (language != null) {
                await _settings.setLanguage(language);
                setState(() {});
              }
            },
          ),

          const Divider(),

          // Notifications Toggle
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: _settings.notificationsEnabled,
            onChanged: (value) async {
              await _settings.setNotifications(value);
              setState(() {});
            },
          ),

          const Divider(),

          // Font Size Slider
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: _settings.fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              label: _settings.fontSize.toStringAsFixed(0),
              onChanged: (value) async {
                await _settings.setFontSize(value);
                setState(() {});
              },
            ),
          ),

          const Divider(),

          // Reset Button
          ListTile(
            title: const Text('Reset to Defaults'),
            subtitle: const Text('Restore all default settings'),
            trailing: const Icon(Icons.restore),
            onTap: () async {
              final confirm = await _showResetDialog();
              if (confirm == true) {
                await _settings.resetToDefaults();
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String?> _showLanguageDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context, 'en'),
            ),
            ListTile(
              title: const Text('Spanish'),
              onTap: () => Navigator.pop(context, 'es'),
            ),
            ListTile(
              title: const Text('French'),
              onTap: () => Navigator.pop(context, 'fr'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showResetDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text('This will restore all default settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
```

## Step 6: Favorites System

```dart
class FavoritesService {
  static const String _keyFavorites = 'favorites';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get all favorites
  List<String> getFavorites() {
    return _prefs?.getStringList(_keyFavorites) ?? [];
  }

  // Add to favorites
  Future<void> addFavorite(String itemId) async {
    final favorites = getFavorites();

    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await _prefs?.setStringList(_keyFavorites, favorites);
    }
  }

  // Remove from favorites
  Future<void> removeFavorite(String itemId) async {
    final favorites = getFavorites();
    favorites.remove(itemId);
    await _prefs?.setStringList(_keyFavorites, favorites);
  }

  // Check if favorite
  bool isFavorite(String itemId) {
    return getFavorites().contains(itemId);
  }

  // Toggle favorite
  Future<void> toggleFavorite(String itemId) async {
    if (isFavorite(itemId)) {
      await removeFavorite(itemId);
    } else {
      await addFavorite(itemId);
    }
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    await _prefs?.remove(_keyFavorites);
  }
}

// Usage in widget
class ProductCard extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _favorites = FavoritesService();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = _favorites.isFavorite(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.productName),
        trailing: IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () async {
            await _favorites.toggleFavorite(widget.productId);
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
      ),
    );
  }
}
```

## Step 7: Onboarding Flow

```dart
class OnboardingService {
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyFirstLaunch = 'first_launch';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isFirstLaunch {
    return _prefs?.getBool(_keyFirstLaunch) ?? true;
  }

  bool get hasSeenOnboarding {
    return _prefs?.getBool(_keyOnboardingComplete) ?? false;
  }

  Future<void> markFirstLaunchComplete() async {
    await _prefs?.setBool(_keyFirstLaunch, false);
  }

  Future<void> markOnboardingComplete() async {
    await _prefs?.setBool(_keyOnboardingComplete, true);
  }

  Future<void> resetOnboarding() async {
    await _prefs?.setBool(_keyOnboardingComplete, false);
  }
}

// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final onboarding = OnboardingService();
  await onboarding.init();

  runApp(MyApp(showOnboarding: !onboarding.hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showOnboarding ? OnboardingScreen() : HomeScreen(),
    );
  }
}
```

## Step 8: Best Practices

### 1. Use Meaningful Key Names

```dart
// ❌ BAD: Unclear keys
'k1', 'data', 'v'

// ✅ GOOD: Clear, descriptive keys
'user_name', 'dark_mode_enabled', 'last_sync_time'

// ✅ BETTER: Use constants
class PrefsKeys {
  static const String userName = 'user_name';
  static const String darkMode = 'dark_mode_enabled';
  static const String lastSync = 'last_sync_time';
}
```

### 2. Always Provide Default Values

```dart
// ❌ BAD: Might return null
final name = prefs.getString('name');

// ✅ GOOD: Always has a value
final name = prefs.getString('name') ?? 'Guest';
```

### 3. Cache SharedPreferences Instance

```dart
// ❌ BAD: Getting instance every time
Future<void> saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
}

Future<void> saveAge(int age) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('age', age);
}

// ✅ GOOD: Cache instance
class PrefsService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveName(String name) async {
    await _prefs?.setString('name', name);
  }

  Future<void> saveAge(int age) async {
    await _prefs?.setInt('age', age);
  }
}
```

### 4. Handle Async Properly

```dart
// ❌ BAD: Not awaiting
prefs.setString('name', 'John');  // Might not complete!

// ✅ GOOD: Await completion
await prefs.setString('name', 'John');
```

## Progressive Exercises

### Exercise 1: Theme Switcher (Beginner)
**Goal:** Implement persistent dark mode

Create an app that:
- Has a toggle for dark/light mode
- Saves preference to SharedPreferences
- Loads preference on app start
- Applies theme based on preference

### Exercise 2: Welcome Message (Beginner-Intermediate)
**Goal:** Show welcome on first launch only

Create an app that:
- Shows welcome dialog on first launch
- Saves "has seen welcome" flag
- Never shows again unless app data is cleared

### Exercise 3: User Profile (Intermediate)
**Goal:** Save and load complex object

Create a user profile editor:
- Save user object (name, email, age, bio) as JSON
- Load on app start
- Edit and update profile
- Show "unsaved changes" indicator

### Exercise 4: Shopping Cart Persistence (Intermediate)
**Goal:** Persist shopping cart

Create shopping cart that:
- Saves cart items to SharedPreferences
- Loads cart on app start
- Survives app restart
- Shows item count badge

### Exercise 5: Settings Migration (Advanced)
**Goal:** Handle settings version changes

Create a settings system with:
- Version number for settings schema
- Migration from old to new format
- Default values for new settings
- Export/import settings to JSON

**Hint:**
```dart
class SettingsV2 {
  static const int currentVersion = 2;

  Future<void> migrate() async {
    final version = prefs.getInt('settings_version') ?? 1;

    if (version < 2) {
      // Migrate from v1 to v2
      final oldTheme = prefs.getString('theme');
      await prefs.setBool('dark_mode', oldTheme == 'dark');
      await prefs.remove('theme');
    }

    await prefs.setInt('settings_version', currentVersion);
  }
}
```

## What You've Learned

✅ What SharedPreferences is and when to use it
✅ Saving and loading simple data types
✅ Storing complex objects with JSON
✅ Building a settings service
✅ Creating favorites system
✅ Implementing onboarding flow
✅ Best practices for key naming and caching
✅ Migration strategies

## Next Steps

In the next lesson, we'll cover:
- **SQLite** - Relational database for complex data
- Creating tables and schemas
- CRUD operations
- Queries and joins
- Migrations

You've mastered simple local storage! 🎉
