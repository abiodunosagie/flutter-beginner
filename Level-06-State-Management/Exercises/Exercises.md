# Level 06: State Management Exercises

Master Provider, Riverpod, and BLoC through hands-on practice!

---

## Exercise 1: Provider - Theme Switcher (Beginner)

### The Goal
Build an app that lets users switch between light and dark themes.

### Think of it Like This
Imagine your room has a light switch. When you flip it:
- Lights ON = Bright room (light theme)
- Lights OFF = Dark room (dark theme)

The switch remembers its position, and EVERY part of your room changes together!

### What You'll Build

```
┌─────────────────────────────────┐
│  🌞 Theme Switcher              │
├─────────────────────────────────┤
│                                 │
│    Current Theme: Light         │
│                                 │
│    ┌─────────────────────┐      │
│    │   🌙  Dark Mode     │      │
│    │      [Toggle]       │      │
│    └─────────────────────┘      │
│                                 │
│    Sample Card                  │
│    ┌─────────────────────┐      │
│    │ This card changes   │      │
│    │ with the theme!     │      │
│    └─────────────────────┘      │
│                                 │
└─────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create ThemeProvider
// ═══════════════════════════════════════════════════════════════
//
// Your ThemeProvider should:
// - Store whether dark mode is ON or OFF (boolean)
// - Have a method to toggle between modes
// - Have a getter that returns the current ThemeData
//
// HINT: Start with this structure:
//
// class ThemeProvider extends ChangeNotifier {
//   bool _isDarkMode = false;
//
//   bool get isDarkMode => ???
//
//   ThemeData get currentTheme => ???
//
//   void toggleTheme() {
//     ???
//   }
// }

// YOUR CODE HERE:




// ═══════════════════════════════════════════════════════════════
// APP SETUP (Don't modify this)
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Make the app use the theme from Provider
// ═══════════════════════════════════════════════════════════════

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Use context.watch to get the theme
    // HINT: final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Theme Switcher',
      // TODO: Set theme from provider
      // theme: ???
      home: const ThemePage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create the UI
// ═══════════════════════════════════════════════════════════════

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Watch the ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Show current theme name
            // Text('Current Theme: ${isDarkMode ? "Dark" : "Light"}')

            const SizedBox(height: 20),

            // TODO: Add a Switch to toggle theme
            // Switch(
            //   value: ???,
            //   onChanged: (value) {
            //     context.read<ThemeProvider>().toggleTheme();
            //   },
            // ),

            const SizedBox(height: 40),

            // Sample card to show theme effect
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'This card follows the theme!',
                  style: Theme.of(context).textTheme.titleMedium,
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

### Success Checklist
- [ ] ThemeProvider stores dark mode state
- [ ] Toggle switch changes the theme
- [ ] Entire app updates when theme changes
- [ ] Card and AppBar reflect the theme

---

## Exercise 2: Provider - Shopping Cart (Intermediate)

### The Goal
Build a shopping cart that tracks items, quantities, and total price.

### Think of it Like This
Imagine you're at a store with a shopping cart:
- You can ADD items to the cart
- You can REMOVE items
- You can see HOW MANY items you have
- You can see the TOTAL PRICE

The cart "remembers" everything, and all screens show the same cart!

### What You'll Build

```
┌─────────────────────────────────┐
│  🛒 My Shop           Cart (3)  │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐    │
│  │ 🍎 Apple        $1.00   │    │
│  │            [Add to Cart]│    │
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │ 🍌 Banana       $0.50   │    │
│  │            [Add to Cart]│    │
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │ 🍊 Orange       $0.75   │    │
│  │            [Add to Cart]│    │
│  └─────────────────────────┘    │
│                                 │
├─────────────────────────────────┤
│  Total: $2.25    [View Cart]    │
└─────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS (Don't modify)
// ═══════════════════════════════════════════════════════════════

class Product {
  final String id;
  final String name;
  final String emoji;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

// Sample products
final products = [
  const Product(id: '1', name: 'Apple', emoji: '🍎', price: 1.00),
  const Product(id: '2', name: 'Banana', emoji: '🍌', price: 0.50),
  const Product(id: '3', name: 'Orange', emoji: '🍊', price: 0.75),
  const Product(id: '4', name: 'Grape', emoji: '🍇', price: 2.00),
  const Product(id: '5', name: 'Mango', emoji: '🥭', price: 1.50),
];

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create CartProvider
// ═══════════════════════════════════════════════════════════════

class CartProvider extends ChangeNotifier {
  // Store cart items as a Map: productId -> CartItem
  final Map<String, CartItem> _items = {};

  // TODO: Implement these getters

  /// Get all items in cart
  List<CartItem> get items => ???

  /// Get total number of items (sum of all quantities)
  int get itemCount => ???

  /// Get total price of all items
  double get totalPrice => ???

  /// Check if cart is empty
  bool get isEmpty => ???

  // TODO: Implement these methods

  /// Add a product to cart (or increase quantity if exists)
  void addItem(Product product) {
    // HINT: Check if product already in cart
    // If yes: increase quantity
    // If no: add new CartItem
    // Don't forget notifyListeners()!
  }

  /// Remove one quantity of a product
  void removeItem(String productId) {
    // HINT: Decrease quantity
    // If quantity becomes 0, remove from cart entirely
  }

  /// Remove product completely from cart
  void deleteItem(String productId) {
    ???
  }

  /// Clear the entire cart
  void clearCart() {
    ???
  }

  /// Get quantity of specific product in cart
  int getQuantity(String productId) {
    ???
  }
}

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ShopPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create the Shop Page
// ═══════════════════════════════════════════════════════════════

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          // TODO: Show cart icon with item count badge
          // HINT: Use Stack with Positioned for the badge
          // Watch CartProvider to get itemCount
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
      // TODO: Add bottom bar showing total and "View Cart" button
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Product Card
// ═══════════════════════════════════════════════════════════════

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: Watch cart to show quantity in cart

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Text(product.emoji, style: const TextStyle(fontSize: 40)),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Show quantity if in cart
            // TODO: Add/Remove buttons
            ElevatedButton(
              onPressed: () {
                // TODO: Add to cart
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 4: Create Cart Page
// ═══════════════════════════════════════════════════════════════

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement cart page
    // Show list of cart items with quantities
    // Show total at bottom
    // Add "Clear Cart" and "Checkout" buttons

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: const Center(
        child: Text('Implement cart page here'),
      ),
    );
  }
}
```

### Success Checklist
- [ ] Can add items to cart
- [ ] Can remove items from cart
- [ ] Cart badge shows total item count
- [ ] Total price updates correctly
- [ ] Cart page shows all items with quantities
- [ ] Can clear the entire cart

---

## Exercise 3: Riverpod - Notes App (Intermediate)

### The Goal
Build a notes app using Riverpod with filtering and search.

### Think of it Like This
Imagine a notebook where:
- You can write notes on different colored pages
- You can search through all your notes
- You can filter to see only certain colors
- The notebook remembers everything!

### What You'll Build

```
┌─────────────────────────────────┐
│  📝 My Notes              [+]   │
├─────────────────────────────────┤
│  🔍 Search notes...             │
├─────────────────────────────────┤
│  [All] [Work] [Personal] [Ideas]│
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐    │
│  │ 📌 Meeting Notes        │    │
│  │ Discuss project timeline│    │
│  │ 🏷️ Work                 │    │
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │ 💡 App Idea             │    │
│  │ Build a recipe tracker  │    │
│  │ 🏷️ Ideas                │    │
│  └─────────────────────────┘    │
│                                 │
└─────────────────────────────────┘
```

### Starter Code

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ═══════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════

enum NoteCategory { all, work, personal, ideas }

class Note {
  final String id;
  final String title;
  final String content;
  final NoteCategory category;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  Note copyWith({
    String? title,
    String? content,
    NoteCategory? category,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 1: Create Providers
// ═══════════════════════════════════════════════════════════════

// Notes list provider using StateNotifier
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(String title, String content, NoteCategory category) {
    // TODO: Create new note and add to state
    // HINT: state = [...state, newNote];
  }

  void deleteNote(String id) {
    // TODO: Remove note from state
  }

  void updateNote(String id, String title, String content, NoteCategory category) {
    // TODO: Update existing note
  }
}

// TODO: Create the StateNotifierProvider for notes
// final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
//   return NotesNotifier();
// });

// TODO: Create a StateProvider for current filter
// final filterProvider = StateProvider<NoteCategory>((ref) => NoteCategory.all);

// TODO: Create a StateProvider for search query
// final searchQueryProvider = StateProvider<String>((ref) => '');

// TODO: Create a computed provider for filtered notes
// This should:
// 1. Watch the notes list
// 2. Watch the current filter
// 3. Watch the search query
// 4. Return filtered list based on category and search
//
// final filteredNotesProvider = Provider<List<Note>>((ref) {
//   final notes = ref.watch(notesProvider);
//   final filter = ref.watch(filterProvider);
//   final query = ref.watch(searchQueryProvider);
//
//   return notes.where((note) {
//     // Filter by category (unless "all")
//     // Filter by search query (title or content contains)
//   }).toList();
// });

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 2: Create Notes Page
// ═══════════════════════════════════════════════════════════════

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch filteredNotesProvider
    // TODO: Watch filterProvider for current filter

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddNoteDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // TODO: Search bar
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: TextField(
          //     decoration: InputDecoration(...),
          //     onChanged: (value) {
          //       ref.read(searchQueryProvider.notifier).state = value;
          //     },
          //   ),
          // ),

          // TODO: Filter chips
          // Row of FilterChip for each category

          // TODO: Notes list
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: filteredNotes.length,
          //     itemBuilder: (context, index) {
          //       return NoteCard(note: filteredNotes[index]);
          //     },
          //   ),
          // ),

          const Center(child: Text('Implement notes page')),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    // TODO: Show dialog to add new note
    // Include title, content, and category selection
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Note Card
// ═══════════════════════════════════════════════════════════════

class NoteCard extends ConsumerWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Display note with:
    // - Title
    // - Content preview
    // - Category chip
    // - Delete button
    // - Tap to edit

    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
      ),
    );
  }
}
```

### Success Checklist
- [ ] Can add new notes with title, content, and category
- [ ] Can delete notes
- [ ] Can filter by category
- [ ] Search filters by title or content
- [ ] List updates when filters change
- [ ] Empty state shown when no matches

---

## Exercise 4: BLoC - Timer App (Intermediate)

### The Goal
Build a countdown timer using BLoC pattern.

### Think of it Like This
Imagine a kitchen timer:
- You SET how many minutes
- You press START and it counts down
- You can PAUSE it
- You can RESET it
- It BEEPS when done!

The timer is the "brain" (BLoC) that handles all the logic.

### What You'll Build

```
┌─────────────────────────────────┐
│          ⏱️ Timer               │
├─────────────────────────────────┤
│                                 │
│                                 │
│            05:00                │
│                                 │
│     ━━━━━━━━━━━━━━━━━━━━       │
│                                 │
│   [1m] [5m] [10m] [15m]         │
│                                 │
│   ┌─────┐  ┌─────┐  ┌─────┐    │
│   │ ▶️  │  │ ⏸️  │  │ 🔄  │    │
│   │Start│  │Pause│  │Reset│    │
│   └─────┘  └─────┘  └─────┘    │
│                                 │
└─────────────────────────────────┘
```

### Starter Code

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ═══════════════════════════════════════════════════════════════
// TODO 1: Define Timer Events
// ═══════════════════════════════════════════════════════════════

// Events are things that can happen to the timer
abstract class TimerEvent {}

// TODO: Create these events:
// - TimerStarted: Start the timer (needs duration in seconds)
// - TimerPaused: Pause the timer
// - TimerResumed: Resume paused timer
// - TimerReset: Reset to initial state
// - TimerTicked: Called every second (internal event)

class TimerStarted extends TimerEvent {
  final int duration;
  TimerStarted(this.duration);
}

// Add more events here...

// ═══════════════════════════════════════════════════════════════
// TODO 2: Define Timer States
// ═══════════════════════════════════════════════════════════════

// States represent what the timer looks like right now
abstract class TimerState {
  final int duration; // Remaining seconds
  const TimerState(this.duration);
}

// TODO: Create these states:
// - TimerInitial: Not started yet (shows "Set timer")
// - TimerRunning: Counting down
// - TimerPaused: Paused mid-count
// - TimerComplete: Reached zero!

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);
}

// Add more states here...

// ═══════════════════════════════════════════════════════════════
// TODO 3: Create Timer BLoC
// ═══════════════════════════════════════════════════════════════

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  static const int _defaultDuration = 60; // 1 minute default

  TimerBloc() : super(const TimerInitial(_defaultDuration)) {
    // TODO: Register event handlers
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    // Add more handlers...
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    // TODO: Cancel any existing timer
    // Start new timer that ticks every second
    // Emit TimerRunning state

    // HINT:
    // _timer?.cancel();
    // emit(TimerRunning(event.duration));
    // _timer = Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     // Add TimerTicked event
    //   },
    // );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    // TODO: If running, cancel timer and emit paused state
  }

  // Add more handlers...

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// ═══════════════════════════════════════════════════════════════
// APP SETUP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(
    BlocProvider(
      create: (_) => TimerBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TimerPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 4: Create Timer Page
// ═══════════════════════════════════════════════════════════════

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Timer display using BlocBuilder
            // Show minutes:seconds format
            // BlocBuilder<TimerBloc, TimerState>(
            //   builder: (context, state) {
            //     final minutes = (state.duration ~/ 60).toString().padLeft(2, '0');
            //     final seconds = (state.duration % 60).toString().padLeft(2, '0');
            //     return Text('$minutes:$seconds', style: ...);
            //   },
            // ),

            const Text('05:00', style: TextStyle(fontSize: 72)),

            const SizedBox(height: 20),

            // TODO: Progress indicator

            const SizedBox(height: 20),

            // TODO: Preset duration buttons
            // [1 min] [5 min] [10 min] [15 min]

            const SizedBox(height: 40),

            // TODO: Control buttons that change based on state
            // - Initial: Show Start
            // - Running: Show Pause, Reset
            // - Paused: Show Resume, Reset
            // - Complete: Show Reset
            //
            // Use BlocBuilder to show different buttons based on state

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Control buttons here'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TODO 5: Add BlocListener for completion
// ═══════════════════════════════════════════════════════════════
//
// When timer completes:
// - Show a snackbar or dialog
// - Optionally play a sound
//
// BlocListener<TimerBloc, TimerState>(
//   listenWhen: (previous, current) => current is TimerComplete,
//   listener: (context, state) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Timer Complete!')),
//     );
//   },
//   child: ...
// )
```

### Success Checklist
- [ ] Timer displays minutes:seconds
- [ ] Can start timer with preset durations
- [ ] Can pause running timer
- [ ] Can resume paused timer
- [ ] Can reset timer at any time
- [ ] Shows completion notification
- [ ] Buttons change based on current state

---

## Exercise 5: Multi-Solution Challenge - Weather Dashboard (Advanced)

### The Goal
Build the SAME weather dashboard using ALL THREE state management solutions!

This exercise helps you truly understand the differences between Provider, Riverpod, and BLoC.

### Think of it Like This
Imagine telling THREE different people to organize your bookshelf:
- Person 1 (Provider) uses one method
- Person 2 (Riverpod) uses another method
- Person 3 (BLoC) uses yet another method

The bookshelf looks the same at the end, but they each organize differently!

### What You'll Build (Same UI, Three Implementations)

```
┌─────────────────────────────────┐
│  🌤️ Weather Dashboard          │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐    │
│  │ 🔍 Enter city...    [🔎]│    │
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │      New York City      │    │
│  │          ☀️             │    │
│  │         72°F            │    │
│  │      Sunny, Clear       │    │
│  │                         │    │
│  │  💨 Wind: 5 mph         │    │
│  │  💧 Humidity: 45%       │    │
│  │  🌡️ Feels like: 70°F   │    │
│  └─────────────────────────┘    │
│                                 │
│  Recent: [NYC] [LA] [Chicago]   │
│                                 │
└─────────────────────────────────┘
```

### Data Model (Use in All Three)

```dart
// weather_model.dart

class Weather {
  final String city;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;

  const Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
  });
}

// Fake API (simulates network delay)
class WeatherApi {
  static final Map<String, Weather> _fakeData = {
    'new york': const Weather(
      city: 'New York',
      temperature: 72,
      condition: 'Sunny',
      icon: '☀️',
      humidity: 45,
      windSpeed: 5,
      feelsLike: 70,
    ),
    'los angeles': const Weather(
      city: 'Los Angeles',
      temperature: 85,
      condition: 'Clear',
      icon: '🌞',
      humidity: 30,
      windSpeed: 8,
      feelsLike: 88,
    ),
    'chicago': const Weather(
      city: 'Chicago',
      temperature: 65,
      condition: 'Cloudy',
      icon: '☁️',
      humidity: 60,
      windSpeed: 12,
      feelsLike: 62,
    ),
    'miami': const Weather(
      city: 'Miami',
      temperature: 88,
      condition: 'Humid',
      icon: '🌴',
      humidity: 80,
      windSpeed: 6,
      feelsLike: 95,
    ),
  };

  static Future<Weather> getWeather(String city) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final weather = _fakeData[city.toLowerCase()];
    if (weather == null) {
      throw Exception('City not found');
    }
    return weather;
  }
}
```

### Part A: Provider Implementation

```dart
// weather_provider.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Create WeatherProvider
// Should handle:
// - Current weather (Weather?)
// - Loading state (bool)
// - Error message (String?)
// - Recent searches (List<String>)
//
// Methods:
// - fetchWeather(String city)
// - clearError()

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  final List<String> _recentSearches = [];

  // Getters
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  Future<void> fetchWeather(String city) async {
    // TODO: Implement
    // 1. Set loading true
    // 2. Clear error
    // 3. Call API
    // 4. Update weather or error
    // 5. Add to recent searches
    // 6. Set loading false
    // Don't forget notifyListeners()!
  }
}

// TODO: Build the UI using Consumer and context.read
```

### Part B: Riverpod Implementation

```dart
// weather_riverpod.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Create providers

// State class for weather
class WeatherState {
  final Weather? weather;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.weather,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// StateNotifier for weather
class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(const WeatherState());

  Future<void> fetchWeather(String city) async {
    // TODO: Implement similar to Provider version
  }
}

// TODO: Create these providers:
// final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>
// final recentSearchesProvider = StateProvider<List<String>>

// TODO: Build UI using ConsumerWidget and ref.watch/ref.read
```

### Part C: BLoC Implementation

```dart
// weather_bloc.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String city;
  FetchWeather(this.city);
}

class ClearWeather extends WeatherEvent {}

// States
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

// BLoC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final List<String> recentSearches = [];

  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<ClearWeather>(_onClearWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    // TODO: Implement
    // 1. Emit loading
    // 2. Try to fetch
    // 3. Emit loaded or error
    // 4. Update recent searches
  }

  void _onClearWeather(ClearWeather event, Emitter<WeatherState> emit) {
    emit(WeatherInitial());
  }
}

// TODO: Build UI using BlocBuilder and BlocListener
```

### Comparison Questions

After implementing all three, answer these questions:

1. **Code Length**: Which implementation had the most code? The least?

2. **Boilerplate**: Which required the most setup/boilerplate?

3. **Readability**: Which is easiest to understand at a glance?

4. **Testing**: Which would be easiest to write tests for?

5. **Scalability**: Which would scale best for a larger app?

6. **Learning Curve**: Which was easiest/hardest to implement?

### Success Checklist (Same for All Three)
- [ ] Can search for a city
- [ ] Shows loading indicator while fetching
- [ ] Displays weather data when loaded
- [ ] Shows error message for unknown cities
- [ ] Tracks recent searches
- [ ] Can tap recent search to re-fetch

---

## Bonus Challenge: State Management Selector

Create a single app that can SWITCH between all three state management solutions at runtime!

```dart
// This is an advanced challenge
// Create an app with a settings page where users can choose:
// - Provider
// - Riverpod
// - BLoC
//
// The app should work the same regardless of selection,
// but use the chosen state management under the hood.
//
// HINT: Use abstract classes/interfaces and dependency injection
```

---

## Tips for Success

### Provider Tips
```dart
// Use context.watch IN build methods
Widget build(BuildContext context) {
  final state = context.watch<MyProvider>();  // ✅ Rebuilds on change
}

// Use context.read IN callbacks
onPressed: () {
  context.read<MyProvider>().doSomething();  // ✅ One-time access
}
```

### Riverpod Tips
```dart
// Use ref.watch IN build methods
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(myProvider);  // ✅ Rebuilds on change
}

// Use ref.read IN callbacks
onPressed: () {
  ref.read(myProvider.notifier).doSomething();  // ✅ One-time access
}
```

### BLoC Tips
```dart
// Use BlocBuilder for UI
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    // Rebuild when state changes
  },
)

// Use BlocListener for side effects (navigation, snackbars)
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    // React to state changes
  },
)

// Add events to trigger changes
context.read<MyBloc>().add(MyEvent());
```

---

## What's Next?

After completing these exercises, you should be able to:
- Choose the right state management for your project
- Implement features with any of the three solutions
- Understand the trade-offs between approaches

Move on to **Level 07** to learn about Navigation and Routing!

---

[← Back to Level 06 README](../README.md) | [Level 07: Navigation →](../../Level-07-Navigation/README.md)
