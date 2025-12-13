# Week 12, Day 3-5: State Persistence - Saving App State

## The Problem: Lost State

**Scenario:** User adds items to cart, closes app → Cart is empty when they return!

**Why?** State lives in memory only. When app closes, state is lost.

**Solution:** **State Persistence** - Save state to disk, restore on app start.

---

## What is State Persistence?

**State Persistence** = Saving state so it survives app restarts.

**Real-world analogy:**
- **Without persistence** = Writing notes on a whiteboard (erased when you leave)
- **With persistence** = Writing in a notebook (stays when you return)

**When to persist:**
- ✓ User preferences (theme, language)
- ✓ Shopping cart
- ✓ User login status
- ✓ App settings
- ✓ Favorites/bookmarks

**When NOT to persist:**
- ✗ Temporary UI state (loading spinners)
- ✗ Animation states
- ✗ Search queries (usually)

---

## Storage Options

### 1. SharedPreferences - Simple Key-Value

**Best for:**
- Settings
- Preferences
- Simple data
- Non-sensitive info

**Limitations:**
- Only primitives (String, int, bool, double, List<String>)
- Not for large data
- Not encrypted

### 2. Hive - Fast Local Database

**Best for:**
- Complex objects
- Large datasets
- Fast read/write
- Offline-first apps

**Benefits:**
- No native dependencies
- Very fast
- Type-safe
- Easy to use

### 3. SQLite - Relational Database

**Best for:**
- Complex queries
- Relational data
- Large structured data

### 4. Secure Storage - Encrypted

**Best for:**
- Passwords
- API tokens
- Sensitive data

We'll focus on **SharedPreferences** (most common) and **Hive** (modern choice).

---

## SharedPreferences Setup

### 1. Add Dependency

**pubspec.yaml:**
```yaml
dependencies:
  shared_preferences: ^2.2.0
```

Run:
```bash
flutter pub get
```

### 2. Basic Usage

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Save data
Future<void> saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', name);
}

// Read data
Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userName');
}

// Delete data
Future<void> deleteUserName() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userName');
}

// Clear all data
Future<void> clearAll() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
```

### 3. Supported Types

```dart
final prefs = await SharedPreferences.getInstance();

// String
await prefs.setString('name', 'Alice');
String? name = prefs.getString('name');

// int
await prefs.setInt('age', 25);
int? age = prefs.getInt('age');

// bool
await prefs.setBool('isDarkMode', true);
bool? isDarkMode = prefs.getBool('isDarkMode');

// double
await prefs.setDouble('price', 99.99);
double? price = prefs.getDouble('price');

// List<String>
await prefs.setStringList('tags', ['flutter', 'dart']);
List<String>? tags = prefs.getStringList('tags');
```

---

## SharedPreferences with Riverpod

### Example: Theme Persistence

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StateNotifier for theme
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  // Load theme from storage
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle and save
  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;

    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', !isDark);
  }
}

// Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// App
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Theme Persistence')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              child: Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Result:** Theme survives app restart! 🎉

---

## SharedPreferences with Bloc

### Example: User Settings

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State
class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final String language;

  const SettingsState({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.language = 'en',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
    );
  }

  @override
  List<Object> get props => [notificationsEnabled, soundEnabled, language];

  // Serialize to Map
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'language': language,
    };
  }

  // Deserialize from Map
  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      language: json['language'] ?? 'en',
    );
  }
}

// Events
abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ToggleNotifications extends SettingsEvent {}

class ToggleSound extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final String language;
  ChangeLanguage(this.language);
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleNotifications>(_onToggleNotifications);
    on<ToggleSound>(_onToggleSound);
    on<ChangeLanguage>(_onChangeLanguage);

    // Load settings on creation
    add(LoadSettings());
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final notif = prefs.getBool('notifications') ?? true;
    final sound = prefs.getBool('sound') ?? true;
    final lang = prefs.getString('language') ?? 'en';

    emit(SettingsState(
      notificationsEnabled: notif,
      soundEnabled: sound,
      language: lang,
    ));
  }

  Future<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.notificationsEnabled;
    emit(state.copyWith(notificationsEnabled: newValue));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', newValue);
  }

  Future<void> _onToggleSound(
    ToggleSound event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.soundEnabled;
    emit(state.copyWith(soundEnabled: newValue));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', newValue);
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(language: event.language));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.language);
  }
}
```

---

## Hive Setup - Modern Alternative

### 1. Add Dependencies

**pubspec.yaml:**
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

### 2. Initialize Hive

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters (for custom objects)
  // Hive.registerAdapter(UserAdapter());

  // Open boxes
  await Hive.openBox('settings');

  runApp(MyApp());
}
```

### 3. Basic Usage

```dart
// Get box
var box = Hive.box('settings');

// Save data
await box.put('userName', 'Alice');
await box.put('age', 25);
await box.put('isDarkMode', true);

// Read data
String? userName = box.get('userName');
int? age = box.get('age');
bool? isDarkMode = box.get('isDarkMode', defaultValue: false);

// Delete data
await box.delete('userName');

// Clear all
await box.clear();

// Close box
await box.close();
```

---

## Hive with Custom Objects

### 1. Create Model with Annotations

```dart
import 'package:hive/hive.dart';

part 'user.g.dart';  // Generated file

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
}
```

### 2. Generate Adapter

Run:
```bash
flutter pub run build_runner build
```

This creates `user.g.dart` with the adapter.

### 3. Register and Use

```dart
void main() async {
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(UserAdapter());

  // Open box
  await Hive.openBox<User>('users');

  runApp(MyApp());
}

// Save user
var usersBox = Hive.box<User>('users');
var user = User(
  id: '1',
  name: 'Alice',
  email: 'alice@example.com',
  age: 25,
);
await usersBox.put(user.id, user);

// Read user
User? alice = usersBox.get('1');

// Get all users
List<User> allUsers = usersBox.values.toList();

// Delete user
await usersBox.delete('1');
```

---

## Complete Example: Shopping Cart Persistence

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models
part 'models.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  Product({required this.id, required this.name, required this.price});
}

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// State Notifier with Hive
class CartNotifier extends StateNotifier<List<CartItem>> {
  final Box<CartItem> _cartBox;

  CartNotifier(this._cartBox) : super(_cartBox.values.toList());

  void addProduct(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      state[existingIndex].quantity++;
      _cartBox.put(product.id, state[existingIndex]);
    } else {
      final newItem = CartItem(product: product);
      _cartBox.put(product.id, newItem);
    }

    state = _cartBox.values.toList();
  }

  void removeProduct(String productId) {
    _cartBox.delete(productId);
    state = _cartBox.values.toList();
  }

  void increaseQuantity(String productId) {
    final item = _cartBox.get(productId);
    if (item != null) {
      item.quantity++;
      _cartBox.put(productId, item);
      state = _cartBox.values.toList();
    }
  }

  void decreaseQuantity(String productId) {
    final item = _cartBox.get(productId);
    if (item != null && item.quantity > 1) {
      item.quantity--;
      _cartBox.put(productId, item);
      state = _cartBox.values.toList();
    }
  }

  void clear() {
    _cartBox.clear();
    state = [];
  }

  double get total {
    return state.fold(0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final box = Hive.box<CartItem>('cart');
  return CartNotifier(box);
});

// Main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cart');

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends ConsumerWidget {
  final products = [
    Product(id: '1', name: 'Laptop', price: 999.99),
    Product(id: '2', name: 'Mouse', price: 29.99),
    Product(id: '3', name: 'Keyboard', price: 79.99),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.length}'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).addProduct(product);
              },
              child: Text('Add'),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          if (cart.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              child: Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                          '\$${item.product.price} x ${item.quantity}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                ref.read(cartProvider.notifier)
                                    .decreaseQuantity(item.product.id);
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                ref.read(cartProvider.notifier)
                                    .increaseQuantity(item.product.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ref.read(cartProvider.notifier)
                                    .removeProduct(item.product.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
```

**Result:** Cart persists across app restarts! Items survive even if app is killed! 🎉

---

## Best Practices

### 1. Initialize Early

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage BEFORE runApp
  await Hive.initFlutter();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}
```

### 2. Handle Loading States

```dart
class ThemeNotifier extends StateNotifier<ThemeMode?> {
  ThemeNotifier() : super(null) {  // null = loading
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

// In UI
final themeMode = ref.watch(themeProvider);
if (themeMode == null) {
  return CircularProgressIndicator();  // Loading
}
```

### 3. Separate Storage Logic

```dart
// storage_service.dart
class StorageService {
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}

// Use in notifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await StorageService.getTheme();
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await StorageService.saveTheme(!isDark);
  }
}
```

### 4. Error Handling

```dart
Future<void> saveData(String key, String value) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  } catch (e) {
    print('Error saving data: $e');
    // Show error to user
  }
}
```

### 5. Migration Strategy

```dart
class StorageService {
  static const _version = 2;

  static Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt('version') ?? 1;

    if (currentVersion < 2) {
      // Migrate from v1 to v2
      final oldTheme = prefs.getString('theme');
      if (oldTheme != null) {
        await prefs.setBool('isDarkMode', oldTheme == 'dark');
        await prefs.remove('theme');
      }
    }

    await prefs.setInt('version', _version);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.migrate();
  runApp(MyApp());
}
```

---

## Secure Storage for Sensitive Data

For passwords, tokens, etc., use **flutter_secure_storage**:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save
await storage.write(key: 'authToken', value: 'secret_token_123');

// Read
String? token = await storage.read(key: 'authToken');

// Delete
await storage.delete(key: 'authToken');

// Delete all
await storage.deleteAll();
```

**Use for:**
- Authentication tokens
- API keys
- Passwords
- Credit card info (tokenized)

---

## Key Takeaways

1. **State persistence** = Save state to survive app restart
2. **SharedPreferences** = Simple key-value (settings, preferences)
3. **Hive** = Fast, type-safe (complex objects)
4. **Initialize early** = Before runApp()
5. **Separate concerns** = Storage service layer
6. **Handle loading** = Show loading state while restoring
7. **Secure storage** = For sensitive data
8. **Test thoroughly** = Save, restart, verify

---

## What's Next?

Tomorrow: **Advanced State Patterns**
- Optimistic updates
- Undo/redo functionality
- State synchronization
- Offline-first architecture

You've mastered state persistence! Your apps now remember! 💾✨
