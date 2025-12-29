# Level 9 Exercises: Advanced Flutter Features

Welcome! These exercises break down advanced features into small, easy-to-learn steps. Complete each part bit-by-bit, and by the end, you'll be building professional apps!

**How these exercises work:**
- Each PART focuses on ONE major skill
- Within each part, exercises build on each other step-by-step
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll have mastered advanced Flutter features!

---

## PART 1: SharedPreferences Basics

Learn to save simple data that survives app restarts.

### Exercise 1.1: Save Your First Value

**Goal:** Save a single value to local storage.

**Your Task:** Save a user's name when they click the button.

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveNameScreen extends StatefulWidget {
  @override
  State<SaveNameScreen> createState() => _SaveNameScreenState();
}

class _SaveNameScreenState extends State<SaveNameScreen> {
  final _nameController = TextEditingController();

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Save the name from _nameController.text with key 'user_name'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save Name')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              child: Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _saveName() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_name', _nameController.text);
}
```

**What it does:**
- Gets SharedPreferences instance
- Saves the name as a String with key 'user_name'
</details>

---

### Exercise 1.2: Load the Saved Value

**Goal:** Load and display the saved name when the screen starts.

**Your Task:** Load the saved name in `initState` and display it.

```dart
class _LoadNameScreenState extends State<LoadNameScreen> {
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Load the name with key 'user_name', use empty string as default
    // TODO: Update _savedName and call setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Load Name')),
      body: Center(
        child: Text(
          _savedName.isEmpty ? 'No name saved' : 'Hello, $_savedName!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _loadName() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('user_name') ?? '';
  setState(() {
    _savedName = name;
  });
}
```

**What it does:**
- Loads the saved name (or empty string if not found)
- Updates the UI with setState
</details>

---

### Exercise 1.3: Save a Boolean (Toggle)

**Goal:** Save a boolean value for dark mode preference.

**Your Task:** Save the dark mode toggle state.

```dart
class _DarkModeToggleState extends State<DarkModeToggle> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    // TODO: Load 'dark_mode' boolean, default to false
  }

  Future<void> _saveDarkMode(bool value) async {
    // TODO: Save 'dark_mode' boolean
    // TODO: Update _isDarkMode and call setState
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Dark Mode'),
      value: _isDarkMode,
      onChanged: _saveDarkMode,
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _loadDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;
  setState(() {
    _isDarkMode = isDark;
  });
}

Future<void> _saveDarkMode(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark_mode', value);
  setState(() {
    _isDarkMode = value;
  });
}
```
</details>

---

### Exercise 1.4: Save a Number (Slider)

**Goal:** Save a numeric value for font size.

**Your Task:** Save the font size from a slider.

```dart
class _FontSizeSliderState extends State<FontSizeSlider> {
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    // TODO: Load 'font_size' as double, default to 16.0
  }

  Future<void> _saveFontSize(double value) async {
    // TODO: Save 'font_size' as double
    // TODO: Update _fontSize and call setState
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sample Text', style: TextStyle(fontSize: _fontSize)),
        Slider(
          value: _fontSize,
          min: 12,
          max: 32,
          onChanged: _saveFontSize,
        ),
        Text('Font Size: ${_fontSize.toInt()}'),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _loadFontSize() async {
  final prefs = await SharedPreferences.getInstance();
  final size = prefs.getDouble('font_size') ?? 16.0;
  setState(() {
    _fontSize = size;
  });
}

Future<void> _saveFontSize(double value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('font_size', value);
  setState(() {
    _fontSize = value;
  });
}
```
</details>

---

### Exercise 1.5: Save a List of Strings

**Goal:** Save a list of favorite items.

**Your Task:** Save and load a list of favorite colors.

```dart
class _FavoriteColorsState extends State<FavoriteColors> {
  List<String> _favorites = [];
  final _colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // TODO: Load 'favorite_colors' as List<String>, default to empty list
  }

  Future<void> _addColor() async {
    // TODO: Add color from _colorController to _favorites list
    // TODO: Save the updated list to SharedPreferences
    // TODO: Clear the text field and update UI
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _colorController,
          decoration: InputDecoration(labelText: 'Enter a color'),
        ),
        ElevatedButton(
          onPressed: _addColor,
          child: Text('Add Color'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(_favorites[index]));
            },
          ),
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _loadFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  final colors = prefs.getStringList('favorite_colors') ?? [];
  setState(() {
    _favorites = colors;
  });
}

Future<void> _addColor() async {
  if (_colorController.text.isEmpty) return;

  _favorites.add(_colorController.text);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('favorite_colors', _favorites);

  _colorController.clear();
  setState(() {});
}
```
</details>

---

### Exercise 1.6: SharedPreferences Challenge

**Goal:** Build a complete settings screen that saves all preferences.

**Your Task:** Create a settings screen with NO scaffolding - combine everything you learned!

**Requirements:**
1. Dark mode toggle (bool)
2. Font size slider (double) - range 12-32
3. Username text field (string)
4. Notifications toggle (bool)
5. All settings must persist across app restarts
6. Load all settings when screen opens

Try building this completely on your own before looking at the solution!

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;
  String _username = '';
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _fontSize = prefs.getDouble('font_size') ?? 16.0;
      _username = prefs.getString('username') ?? '';
      _usernameController.text = _username;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() => _isDarkMode = value);
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', value);
    setState(() => _fontSize = value);
  }

  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    setState(() => _username = _usernameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Username saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Use dark theme'),
            value: _isDarkMode,
            onChanged: _saveDarkMode,
          ),
          Divider(),
          SwitchListTile(
            title: Text('Notifications'),
            subtitle: Text('Enable push notifications'),
            value: _notificationsEnabled,
            onChanged: _saveNotifications,
          ),
          Divider(),
          ListTile(
            title: Text('Font Size'),
            subtitle: Text('Adjust text size: ${_fontSize.toInt()}'),
          ),
          Slider(
            value: _fontSize,
            min: 12,
            max: 32,
            divisions: 20,
            label: _fontSize.toInt().toString(),
            onChanged: _saveFontSize,
          ),
          Divider(),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saveUsername,
            child: Text('Save Username'),
          ),
        ],
      ),
    );
  }
}
```
</details>

---

## PART 2: SQLite Database Basics

Learn to work with a real database for complex data.

### Exercise 2.1: Create Your First Database

**Goal:** Initialize a SQLite database with one table.

**Your Task:** Create a database with a "notes" table.

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // TODO: Create a table named 'notes' with columns:
        // - id (INTEGER PRIMARY KEY AUTOINCREMENT)
        // - title (TEXT NOT NULL)
        // - content (TEXT)
      },
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'notes.db');

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT
        )
      ''');
    },
  );
}
```

**What it does:**
- Creates a database file named 'notes.db'
- Creates a table with id, title, and content columns
- id auto-increments for each new note
</details>

---

### Exercise 2.2: Insert Data

**Goal:** Add a new note to the database.

**Your Task:** Implement the insert method.

```dart
class DatabaseHelper {
  // ... previous code ...

  Future<int> insertNote(String title, String content) async {
    final db = await database;
    // TODO: Insert a note with title and content
    // Return the id of the inserted note
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<int> insertNote(String title, String content) async {
  final db = await database;
  return await db.insert(
    'notes',
    {
      'title': title,
      'content': content,
    },
  );
}
```

**What it does:**
- Inserts a new row into the 'notes' table
- Returns the id of the newly created note
</details>

---

### Exercise 2.3: Query All Data

**Goal:** Retrieve all notes from the database.

**Your Task:** Implement a method to get all notes.

```dart
class DatabaseHelper {
  // ... previous code ...

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    // TODO: Query all notes from the 'notes' table
    // Return the list of notes
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<List<Map<String, dynamic>>> getAllNotes() async {
  final db = await database;
  return await db.query('notes');
}
```

**What it does:**
- Queries all rows from the 'notes' table
- Returns a list of maps (each map is one note)
</details>

---

### Exercise 2.4: Update Data

**Goal:** Update an existing note.

**Your Task:** Implement the update method.

```dart
class DatabaseHelper {
  // ... previous code ...

  Future<int> updateNote(int id, String title, String content) async {
    final db = await database;
    // TODO: Update the note with the given id
    // Return the number of rows affected
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<int> updateNote(int id, String title, String content) async {
  final db = await database;
  return await db.update(
    'notes',
    {
      'title': title,
      'content': content,
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}
```

**What it does:**
- Updates the note with matching id
- Returns the number of rows updated (should be 1)
</details>

---

### Exercise 2.5: Delete Data

**Goal:** Remove a note from the database.

**Your Task:** Implement the delete method.

```dart
class DatabaseHelper {
  // ... previous code ...

  Future<int> deleteNote(int id) async {
    final db = await database;
    // TODO: Delete the note with the given id
    // Return the number of rows affected
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<int> deleteNote(int id) async {
  final db = await database;
  return await db.delete(
    'notes',
    where: 'id = ?',
    whereArgs: [id],
  );
}
```
</details>

---

### Exercise 2.6: SQLite CRUD Challenge

**Goal:** Build a complete notes app with database storage.

**Your Task:** Create a notes app with create, read, update, delete - NO scaffolding!

**Requirements:**
1. Show list of all notes
2. Add new note (title + content)
3. Edit existing note
4. Delete note (with confirmation)
5. All data persists in SQLite

Try building this completely on your own!

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes:
- DatabaseHelper class with all CRUD methods
- NotesListScreen with list display and delete
- AddNoteScreen for creating new notes
- EditNoteScreen for updating notes
- Confirmation dialog before delete
- Navigation between screens
</details>

---

## PART 3: Form Validation

Learn to validate user input properly.

### Exercise 3.1: Required Field Validation

**Goal:** Validate that a field is not empty.

**Your Task:** Add validation to prevent empty username.

```dart
class _UsernameFormState extends State<UsernameForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  String? _validateUsername(String? value) {
    // TODO: Return error message if value is null or empty
    // TODO: Return null if valid
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid!
      print('Username: ${_usernameController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: _validateUsername,
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
String? _validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  return null;
}
```

**What it does:**
- Checks if the field is empty
- Returns error message if invalid
- Returns null if valid (no error)
</details>

---

### Exercise 3.2: Length Validation

**Goal:** Validate minimum and maximum length.

**Your Task:** Ensure username is between 3 and 20 characters.

```dart
String? _validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  // TODO: Check if length is less than 3
  // TODO: Check if length is greater than 20
  return null;
}
```

<details>
<summary>✅ Solution</summary>

```dart
String? _validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  if (value.length < 3) {
    return 'Username must be at least 3 characters';
  }
  if (value.length > 20) {
    return 'Username must not exceed 20 characters';
  }
  return null;
}
```
</details>

---

### Exercise 3.3: Email Validation

**Goal:** Validate email format using regex.

**Your Task:** Ensure the email is in valid format.

```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  // TODO: Create a regex pattern for email validation
  // Pattern should check for: text@text.text
  // TODO: Use RegExp.hasMatch() to validate
  // TODO: Return error if invalid, null if valid
}
```

<details>
<summary>✅ Solution</summary>

```dart
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }

  return null;
}
```

**Regex explanation:**
- `^` = start of string
- `[\w-\.]+` = username part (letters, numbers, dash, dot)
- `@` = @ symbol
- `([\w-]+\.)+` = domain parts with dots
- `[\w-]{2,4}$` = domain extension (2-4 characters)
</details>

---

### Exercise 3.4: Password Strength Validation

**Goal:** Validate password complexity.

**Your Task:** Ensure password meets strength requirements.

```dart
String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  // TODO: Check minimum length (8 characters)
  // TODO: Check for at least one uppercase letter
  // TODO: Check for at least one lowercase letter
  // TODO: Check for at least one number

  return null;
}
```

<details>
<summary>✅ Solution</summary>

```dart
String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }

  return null;
}
```
</details>

---

### Exercise 3.5: Matching Fields Validation

**Goal:** Validate that two fields match (e.g., confirm password).

**Your Task:** Ensure password and confirm password match.

```dart
class _PasswordFormState extends State<PasswordForm> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    // TODO: Check if empty
    // TODO: Check if matches _passwordController.text
    // TODO: Return error if doesn't match, null if matches
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: _validatePassword,
        ),
        TextFormField(
          controller: _confirmController,
          decoration: InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
String? _validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != _passwordController.text) {
    return 'Passwords do not match';
  }
  return null;
}
```
</details>

---

### Exercise 3.6: Complete Registration Form Challenge

**Goal:** Build a full registration form with all validations.

**Your Task:** Create a complete form - NO scaffolding!

**Requirements:**
1. Username (3-20 characters, alphanumeric only)
2. Email (valid format)
3. Password (8+ chars, uppercase, lowercase, number)
4. Confirm Password (must match)
5. Phone (optional, but if provided must be 10 digits)
6. Terms checkbox (must be checked to submit)
7. Show success message when valid

Try building this completely on your own!

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes:
- All validation functions
- Password visibility toggles
- Terms checkbox validation
- Success SnackBar
- Clean UI with icons
</details>

---

## PART 4: Theming and Dark Mode

Learn to create beautiful, consistent themes.

### Exercise 4.1: Define a Light Theme

**Goal:** Create a custom light theme.

**Your Task:** Define a ThemeData for light mode.

```dart
class MyApp extends StatelessWidget {
  ThemeData _buildLightTheme() {
    return ThemeData(
      // TODO: Set brightness to Brightness.light
      // TODO: Set primary color to Colors.blue
      // TODO: Set accent/secondary color to Colors.orange
      // TODO: Set appBarTheme with backgroundColor
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildLightTheme(),
      home: HomeScreen(),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
ThemeData _buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.orange,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
}
```
</details>

---

### Exercise 4.2: Define a Dark Theme

**Goal:** Create a dark theme that matches the light theme.

**Your Task:** Define a ThemeData for dark mode.

```dart
ThemeData _buildDarkTheme() {
  return ThemeData(
    // TODO: Set brightness to Brightness.dark
    // TODO: Set primary color to Colors.blue (darker shade)
    // TODO: Set background color to dark gray
    // TODO: Set appBarTheme for dark mode
  );
}
```

<details>
<summary>✅ Solution</summary>

```dart
ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[700]!,
      secondary: Colors.orange,
    ),
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
    ),
  );
}
```
</details>

---

### Exercise 4.3: Toggle Between Themes

**Goal:** Let users switch between light and dark mode.

**Your Task:** Implement theme switching with a toggle.

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    // TODO: Toggle _isDarkMode and rebuild
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Use _isDarkMode to choose between _buildDarkTheme() and _buildLightTheme()
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: HomeScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

// In HomeScreen
SwitchListTile(
  title: Text('Dark Mode'),
  value: widget.isDarkMode,
  onChanged: (value) => widget.onToggleTheme(),
)
```
</details>

---

### Exercise 4.4: Persist Theme Preference

**Goal:** Save the theme preference using SharedPreferences.

**Your Task:** Load and save theme preference.

```dart
class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    // TODO: Load 'dark_mode' from SharedPreferences
    // TODO: Update _isDarkMode and rebuild
  }

  Future<void> _toggleTheme() async {
    // TODO: Toggle _isDarkMode
    // TODO: Save to SharedPreferences
    // TODO: Rebuild
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: HomeScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _loadThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;
  setState(() {
    _isDarkMode = isDark;
  });
}

Future<void> _toggleTheme() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _isDarkMode = !_isDarkMode;
  });
  await prefs.setBool('dark_mode', _isDarkMode);
}
```
</details>

---

### Exercise 4.5: Access Theme Colors in Widgets

**Goal:** Use theme colors instead of hardcoding.

**Your Task:** Build a card that uses theme colors.

```dart
class ThemedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get the current theme using Theme.of(context)
    // TODO: Use theme.colorScheme.primary for card color
    // TODO: Use theme.textTheme.headline6 for text style

    return Card(
      // Use theme colors here
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Themed Card'),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class ThemedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Themed Card',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
```

**What it does:**
- Gets the current theme
- Uses primary color from theme
- Uses text style from theme
- Automatically adapts to light/dark mode
</details>

---

### Exercise 4.6: Complete Theme System Challenge

**Goal:** Build a complete theme customization system.

**Your Task:** Create a theme customizer - NO scaffolding!

**Requirements:**
1. Toggle dark/light mode
2. Choose primary color (from 6 options)
3. Choose accent color (from 6 options)
4. Save all preferences
5. Preview the theme on sample UI
6. Apply theme across the entire app

Try building this completely on your own!

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes:
- ThemeProvider with ChangeNotifier
- Color picker with visual selection
- Real-time theme preview
- Persistent storage
- Clean UI
</details>

---

## PART 5: Async States and Error Handling

Learn to handle loading states, errors, and async operations properly.

### Exercise 5.1: Simple Loading State

**Goal:** Show a loading indicator while fetching data.

**Your Task:** Display CircularProgressIndicator during data fetch.

```dart
class _DataScreenState extends State<DataScreen> {
  bool _isLoading = false;
  List<String> _data = [];

  Future<void> _fetchData() async {
    // TODO: Set _isLoading to true
    // TODO: Simulate API call with await Future.delayed(Duration(seconds: 2))
    // TODO: Set _data to some sample data
    // TODO: Set _isLoading to false
    // TODO: Call setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Screen')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_data[index]));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _fetchData() async {
  setState(() {
    _isLoading = true;
  });

  await Future.delayed(Duration(seconds: 2));

  setState(() {
    _data = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
    _isLoading = false;
  });
}
```
</details>

---

### Exercise 5.2: Error State

**Goal:** Handle and display errors properly.

**Your Task:** Catch errors and show error message.

```dart
class _DataScreenState extends State<DataScreen> {
  bool _isLoading = false;
  List<String> _data = [];
  String? _error;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Simulate API call
      // TODO: Simulate error by throwing Exception('Failed to load data')
    } catch (e) {
      // TODO: Set _error to e.toString()
    } finally {
      // TODO: Set _isLoading to false
      // TODO: Call setState
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) => ListTile(title: Text(_data[index])),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _fetchData() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    await Future.delayed(Duration(seconds: 1));
    throw Exception('Failed to load data');
  } catch (e) {
    setState(() {
      _error = e.toString();
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
```
</details>

---

### Exercise 5.3: State Enum Pattern

**Goal:** Use an enum to manage different states cleanly.

**Your Task:** Implement state management with enum.

```dart
enum DataState { initial, loading, success, error }

class _DataScreenState extends State<DataScreen> {
  DataState _state = DataState.initial;
  List<String> _data = [];
  String? _error;

  Future<void> _fetchData() async {
    // TODO: Set state to loading

    try {
      // TODO: Simulate API call
      // TODO: Set _data to sample data
      // TODO: Set state to success
    } catch (e) {
      // TODO: Set _error
      // TODO: Set state to error
    }

    // TODO: Call setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Screen')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case DataState.initial:
        return Center(child: Text('Press the button to load data'));
      case DataState.loading:
        // TODO: Return loading widget
      case DataState.success:
        // TODO: Return list view
      case DataState.error:
        // TODO: Return error widget with retry button
    }
  }
}
```

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes proper state management with enum and a clean switch statement.
</details>

---

### Exercise 5.4: Pull to Refresh

**Goal:** Add pull-to-refresh functionality.

**Your Task:** Implement RefreshIndicator.

```dart
class _DataScreenState extends State<DataScreen> {
  List<String> _data = [];

  Future<void> _refreshData() async {
    // TODO: Simulate API call with delay
    // TODO: Update _data with new data
    // TODO: Call setState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pull to Refresh')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_data[index]));
          },
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> _refreshData() async {
  await Future.delayed(Duration(seconds: 1));
  setState(() {
    _data = [
      'Refreshed Item ${DateTime.now().second}',
      'Another Item',
      'More Data',
    ];
  });
}
```

**What it does:**
- RefreshIndicator wraps the ListView
- User pulls down to trigger refresh
- onRefresh must return a Future
- Automatically shows loading indicator
</details>

---

### Exercise 5.5: FutureBuilder Widget

**Goal:** Use FutureBuilder to handle async data.

**Your Task:** Implement a screen using FutureBuilder.

```dart
class FutureBuilderScreen extends StatelessWidget {
  Future<List<String>> _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return ['Item 1', 'Item 2', 'Item 3'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FutureBuilder')),
      body: FutureBuilder<List<String>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          // TODO: Check if waiting (ConnectionState.waiting)
          // TODO: Check if has error (snapshot.hasError)
          // TODO: Check if has data (snapshot.hasData)
          // TODO: Return appropriate widget for each state
        },
      ),
    );
  }
}
```

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes proper handling of all ConnectionState values.
</details>

---

### Exercise 5.6: Complete Async Handling Challenge

**Goal:** Build a complete app with all async patterns.

**Your Task:** Create a data fetching app - NO scaffolding!

**Requirements:**
1. Use FutureBuilder to load initial data
2. Show loading spinner
3. Handle and display errors with retry button
4. Implement pull-to-refresh
5. Show "No data" state when list is empty
6. Simulate random failures (50% chance of error)

Try building this completely on your own!

<details>
<summary>✅ Solution - See full implementation in previous response</summary>

The solution includes all async patterns combined into one complete app.
</details>

---

## FINAL PROJECT: Personal Finance Tracker

**Goal:** Combine ALL the skills you've learned in Level 9!

**Your Task:** Build a complete personal finance app with NO help!

### Requirements:

**Local Storage:**
- Use SQLite for transactions (income/expense records)
- Use SharedPreferences for settings (currency, dark mode)

**Database Schema:**
```sql
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  type TEXT NOT NULL, -- 'income' or 'expense'
  category TEXT NOT NULL,
  date TEXT NOT NULL
);
```

**Forms with Validation:**
- Add transaction form:
  - Title (required, 3-50 chars)
  - Amount (required, must be positive number)
  - Type (income or expense)
  - Category (from predefined list)
  - Date picker

**Theming:**
- Light/dark mode toggle
- Save theme preference
- Use theme colors throughout

**Features:**
1. Add income/expense transactions
2. View all transactions in a list
3. Delete transactions (with confirmation)
4. Filter by type (all, income, expense)
5. Calculate and display total balance
6. Show income total, expense total, and net balance
7. Settings screen (dark mode, currency symbol)
8. Pull-to-refresh the transaction list
9. Handle all loading and error states

**Bonus Features:**
- Search transactions by title
- Sort by date or amount
- Monthly summary
- Export data as text

### Build this completely on your own using everything you learned!

---

## Submission Checklist

Before moving to the next level:

- [ ] Completed all PART 1 exercises (SharedPreferences)
- [ ] Completed all PART 2 exercises (SQLite)
- [ ] Completed all PART 3 exercises (Form Validation)
- [ ] Completed all PART 4 exercises (Theming)
- [ ] Completed all PART 5 exercises (Async States)
- [ ] Completed the Final Project
- [ ] All data persists across app restarts
- [ ] All forms have proper validation
- [ ] Theme changes work correctly
- [ ] Loading and error states are handled
- [ ] Code is clean and well-organized

---

## Need Help?

Review the theory files:
- [01-LocalStorage.md](../Theory/01-LocalStorage.md)
- [02-SharedPreferences.md](../Theory/02-SharedPreferences.md)
- [03-SQLiteDatabase.md](../Theory/03-SQLiteDatabase.md)
- [04-FormsAndValidation.md](../Theory/04-FormsAndValidation.md)
- [05-ThemingAndStyling.md](../Theory/05-ThemingAndStyling.md)
- [06-FuturesDeepDive.md](../Theory/06-FuturesDeepDive.md)

Study the examples in the Examples folder!

---

**You're doing amazing! Keep practicing step-by-step!** 🚀
