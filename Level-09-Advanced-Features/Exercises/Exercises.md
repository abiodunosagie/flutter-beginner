# Level 9 Exercises: Advanced Flutter Features

Practice what you've learned! Complete these exercises to master advanced Flutter features.

---

## Exercise 1: Settings App (SharedPreferences)

**Difficulty:** Easy

Build a settings screen that remembers user preferences.

### Requirements:
1. Toggle for dark mode (on/off)
2. Slider for font size (small, medium, large)
3. Switch for notifications (on/off)
4. Dropdown for language selection
5. All settings must persist when app restarts

### Hints:
```dart
// Save a boolean
await prefs.setBool('dark_mode', true);

// Save an int
await prefs.setInt('font_size', 16);

// Load with defaults
bool darkMode = prefs.getBool('dark_mode') ?? false;
```

### Expected Output:
```
┌─────────────────────────────────┐
│         ⚙️ Settings             │
├─────────────────────────────────┤
│                                 │
│  Dark Mode        [Toggle ON]   │
│                                 │
│  Font Size        ───●───       │
│                   S  M  L       │
│                                 │
│  Notifications    [Switch ON]   │
│                                 │
│  Language         [English ▼]   │
│                                 │
└─────────────────────────────────┘
```

---

## Exercise 2: Todo App with SQLite

**Difficulty:** Medium

Create a complete todo app with database storage.

### Requirements:
1. Add new todos with title and description
2. Mark todos as complete/incomplete
3. Delete todos (with swipe or button)
4. Filter todos (All, Active, Completed)
5. Search todos by title
6. Sort by date created

### Database Schema:
```sql
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  is_completed INTEGER DEFAULT 0,
  created_at TEXT NOT NULL
);
```

### Hints:
```dart
// Insert
await db.insert('todos', {
  'title': 'Buy groceries',
  'description': 'Milk, eggs, bread',
  'is_completed': 0,
  'created_at': DateTime.now().toIso8601String(),
});

// Update
await db.update(
  'todos',
  {'is_completed': 1},
  where: 'id = ?',
  whereArgs: [todoId],
);

// Query with filter
await db.query(
  'todos',
  where: 'is_completed = ?',
  whereArgs: [0], // Active only
);
```

---

## Exercise 3: Registration Form with Validation

**Difficulty:** Medium

Build a complete user registration form.

### Requirements:
1. **Username field:**
   - Required
   - 3-20 characters
   - Only letters, numbers, underscore

2. **Email field:**
   - Required
   - Valid email format

3. **Password field:**
   - Required
   - Minimum 8 characters
   - At least one uppercase letter
   - At least one number
   - Password visibility toggle

4. **Confirm Password:**
   - Must match password

5. **Phone number:**
   - Optional
   - Valid format if provided

6. **Terms checkbox:**
   - Must be checked to submit

### Validation Pattern:
```dart
// Username validator
String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  if (value.length < 3) {
    return 'Username must be at least 3 characters';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Only letters, numbers, and underscore allowed';
  }
  return null; // Valid!
}
```

---

## Exercise 4: Theme Customizer

**Difficulty:** Medium

Create an app that lets users customize the theme.

### Requirements:
1. Choose primary color (from a palette)
2. Choose accent color
3. Toggle dark/light mode
4. Choose font family (3 options)
5. Adjust corner roundness
6. Preview changes in real-time
7. Save and load theme preferences

### Color Palette:
```dart
final colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
];
```

### Expected Preview:
```
┌─────────────────────────────────┐
│     🎨 Theme Customizer         │
├─────────────────────────────────┤
│                                 │
│  Primary Color:                 │
│  [🔵][🔴][🟢][🟣][🟠][Others]  │
│                                 │
│  Mode: [☀️ Light] [🌙 Dark]     │
│                                 │
│  Font: [Roboto ▼]               │
│                                 │
│  Roundness: ────●───            │
│                                 │
│  ┌─────────────────────┐        │
│  │   Preview Card      │        │
│  │   Styled Text       │        │
│  │   [Preview Button]  │        │
│  └─────────────────────┘        │
│                                 │
└─────────────────────────────────┘
```

---

## Exercise 5: Live Search with Streams

**Difficulty:** Hard

Build a search feature that updates as user types.

### Requirements:
1. Search input with debounce (wait 300ms after typing stops)
2. Show loading indicator while searching
3. Display results as a list
4. Highlight matching text in results
5. Handle errors gracefully
6. Show "No results" when empty

### Debounce Pattern:
```dart
// Create a stream controller
final _searchController = StreamController<String>();

// Setup debounce
_searchController.stream
  .debounceTime(Duration(milliseconds: 300))
  .distinct()
  .listen((query) {
    _performSearch(query);
  });

// On text change
void onSearchChanged(String query) {
  _searchController.add(query);
}
```

### Search Flow:
```
User types: "F"
  ↓ (waits 300ms...)
User types: "Fl"
  ↓ (waits 300ms...)
User types: "Flu"
  ↓ (waits 300ms... no more typing)
  ↓
Search for "Flu"
  ↓
Show results
```

---

## Exercise 6: Responsive Dashboard

**Difficulty:** Hard

Create a dashboard that adapts to different screen sizes.

### Requirements:
1. **Mobile (< 600px):**
   - Single column layout
   - Bottom navigation
   - Hamburger menu

2. **Tablet (600-900px):**
   - Two column layout
   - Navigation rail on left
   - Cards in grid (2 columns)

3. **Desktop (> 900px):**
   - Three column layout
   - Full sidebar navigation
   - Cards in grid (3-4 columns)

### Dashboard Widgets:
- Stats cards (4 cards showing numbers)
- Recent activity list
- Chart placeholder
- Quick actions buttons

### Breakpoint Helper:
```dart
class Responsive {
  static bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 900;

  static int gridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 4;
  }
}
```

---

## Exercise 7: Notes App with Hive

**Difficulty:** Medium

Build a notes app using Hive for storage.

### Requirements:
1. Create, read, update, delete notes
2. Each note has: title, content, color, created date
3. Pin important notes to top
4. Search notes by title or content
5. Change note color
6. Show last modified date

### Hive Model:
```dart
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isPinned;

  Note({
    required this.title,
    required this.content,
    this.colorValue = 0xFFFFFFFF,
    required this.createdAt,
    this.isPinned = false,
  });
}
```

---

## Exercise 8: Async Data Loading

**Difficulty:** Medium

Practice proper async patterns with loading states.

### Requirements:
1. Simulate API calls with delays
2. Show loading spinner while fetching
3. Display error state with retry button
4. Show success state with data
5. Pull-to-refresh functionality
6. Proper error handling

### States to Handle:
```dart
enum LoadingState {
  initial,    // Haven't started yet
  loading,    // Currently fetching
  success,    // Data loaded successfully
  error,      // Something went wrong
}
```

### Pattern:
```dart
class DataScreen extends StatefulWidget {
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  LoadingState _state = LoadingState.initial;
  List<Item>? _data;
  String? _error;

  Future<void> _loadData() async {
    setState(() => _state = LoadingState.loading);

    try {
      final data = await fetchData();
      setState(() {
        _data = data;
        _state = LoadingState.success;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _state = LoadingState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case LoadingState.initial:
        return ElevatedButton(
          onPressed: _loadData,
          child: Text('Load Data'),
        );
      case LoadingState.loading:
        return CircularProgressIndicator();
      case LoadingState.success:
        return ListView(...);
      case LoadingState.error:
        return Column(
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        );
    }
  }
}
```

---

## Bonus Challenge: Complete App

**Difficulty:** Expert

Combine everything you've learned!

### Build a "Personal Finance Tracker" with:

1. **Local Storage:**
   - SQLite for transactions
   - SharedPreferences for settings

2. **Forms:**
   - Add income/expense form with validation
   - Category selection

3. **Theming:**
   - Light/dark mode
   - Custom colors

4. **Responsive:**
   - Works on phone and tablet

5. **Streams:**
   - Real-time balance updates
   - Live filtering

6. **Features:**
   - Monthly summary
   - Category breakdown
   - Search transactions
   - Export data

---

## Submission Checklist

For each exercise, make sure:

- [ ] App runs without errors
- [ ] Data persists across app restarts
- [ ] UI is clean and intuitive
- [ ] Code is well-organized
- [ ] Edge cases are handled
- [ ] Loading states are shown
- [ ] Errors are handled gracefully

---

## Need Help?

Review these files:
- `Theory/01-LocalStorage.md`
- `Theory/02-SharedPreferences.md`
- `Theory/03-SQLiteDatabase.md`
- `Theory/04-FormsAndValidation.md`
- `Theory/05-ThemingAndStyling.md`
- `Theory/06-FuturesDeepDive.md`
- `Theory/07-StreamsExplained.md`
- `Theory/08-ResponsiveDesign.md`

And study the examples:
- `Examples/Example01-SharedPreferences.dart`
- `Examples/Example02-SQLiteTodoApp.dart`
- `Examples/Example03-FormValidation.dart`
- `Examples/Example04-ThemeSwitcher.dart`
- `Examples/Example05-StreamsExample.dart`
- `Examples/Example06-ResponsiveLayout.dart`

---

**Good luck! You've got this!** 🚀
