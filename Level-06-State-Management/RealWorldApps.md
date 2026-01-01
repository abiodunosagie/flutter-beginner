# Level 6: Real-World Apps Using These Concepts

See how state management powers complex applications!

---

## Provider / ChangeNotifier

### Sharing State Across Widgets!

**Shopping Cart (Amazon)**
```dart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(Product product) {
    final existing = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => null,
    );

    if (existing != null) {
      existing.quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();  // Update all cart UI!
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
}
```

**User Authentication**
```dart
class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await authService.signIn(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    _user = null;
    notifyListeners();
  }
}
```

---

## App-Wide State

### Global Data Everyone Needs!

**Theme (Dark Mode)**
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggleTheme() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    saveToPreferences();
    notifyListeners();
  }
}

// In MaterialApp
MaterialApp(
  themeMode: context.watch<ThemeProvider>().mode,
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
)
```

**Notification Badge Count**
```dart
class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;

  void updateCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  void markAllRead() {
    _unreadCount = 0;
    notifyListeners();
  }
}

// Shows badge on notification icon everywhere
Icon(
  Icons.notifications,
  badge: context.watch<NotificationProvider>().hasUnread,
)
```

---

## Complex State

### Multiple Pieces Working Together!

**Music Player (Spotify)**
```dart
class PlayerProvider extends ChangeNotifier {
  Song? _currentSong;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  List<Song> _queue = [];
  RepeatMode _repeatMode = RepeatMode.off;
  bool _shuffleEnabled = false;

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  double get progress => _position.inSeconds / (_currentSong?.duration.inSeconds ?? 1);

  void play(Song song) {
    _currentSong = song;
    _isPlaying = true;
    _position = Duration.zero;
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seek(Duration position) {
    _position = position;
    notifyListeners();
  }

  void next() {
    final currentIndex = _queue.indexOf(_currentSong!);
    if (currentIndex < _queue.length - 1) {
      play(_queue[currentIndex + 1]);
    }
  }
}
```

---

## Loading & Error States

### Handle Async Operations!

**Product Catalog**
```dart
class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await api.getProducts();
    } catch (e) {
      _error = 'Failed to load products';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// In UI
Widget build(BuildContext context) {
  final provider = context.watch<ProductsProvider>();

  if (provider.isLoading) {
    return CircularProgressIndicator();
  }

  if (provider.error != null) {
    return Text(provider.error!);
  }

  return ListView.builder(
    itemCount: provider.products.length,
    itemBuilder: (_, i) => ProductCard(provider.products[i]),
  );
}
```

---

## Real Apps Using State Management

| App | State Managed |
|-----|--------------|
| **Amazon** | Cart, user, products, orders |
| **Spotify** | Player, playlists, search results |
| **Instagram** | Posts, stories, user profile, likes |
| **Uber** | Ride status, driver location, user |
| **Netflix** | Playback, downloads, watch history |

---

## Why State Management Matters

### Without State Management
```dart
// Every screen has to pass data manually
HomeScreen() → ProductScreen(cart) → CheckoutScreen(cart, user)

// Hard to update!
// If cart changes, need to rebuild everything
```

### With State Management
```dart
// Any screen can access shared state
context.watch<CartProvider>().items
context.watch<UserProvider>().user

// One change updates everywhere automatically!
```

---

## Common Patterns

### Favorites/Wishlist
```dart
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}
```

### Filter/Sort
```dart
class ProductFilterProvider extends ChangeNotifier {
  String _category = 'All';
  double _maxPrice = 1000;
  SortOption _sortBy = SortOption.popular;

  List<Product> filter(List<Product> products) {
    return products
      .where((p) => _category == 'All' || p.category == _category)
      .where((p) => p.price <= _maxPrice)
      .toList()
      ..sort((a, b) => _compareBy(_sortBy, a, b));
  }
}
```

---

## Build It Yourself!

After this level, you could build:

1. **Shopping Cart** - Add/remove items, calculate total
2. **Theme Switcher** - Dark/light mode toggle
3. **Todo App** - Task list with filters
4. **Music Player UI** - Play/pause, progress bar
5. **Authentication Flow** - Login/logout state

---

**State management is the nervous system of your app - it connects everything!**
