// Example 01: SharedPreferences - Remember User Settings
// A complete app that saves and loads user preferences

// pubspec.yaml dependencies:
// shared_preferences: ^2.2.2

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════
// MAIN APP
// ═══════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SettingsPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SETTINGS PAGE
// Demonstrates saving and loading different data types
// ═══════════════════════════════════════════════════════════════

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings values
  String _userName = 'Guest';
  bool _isDarkMode = false;
  double _volume = 50.0;
  int _fontSize = 16;
  bool _isLoading = true;

  // Text controller for name input
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // LOAD ALL SETTINGS
  // ─────────────────────────────────────────────────────────────
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load each setting with a default value
      _userName = prefs.getString('user_name') ?? 'Guest';
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _volume = prefs.getDouble('volume') ?? 50.0;
      _fontSize = prefs.getInt('font_size') ?? 16;

      _nameController.text = _userName;
      _isLoading = false;
    });

    print('Settings loaded!');
    print('Name: $_userName');
    print('Dark Mode: $_isDarkMode');
    print('Volume: $_volume');
    print('Font Size: $_fontSize');
  }

  // ─────────────────────────────────────────────────────────────
  // SAVE INDIVIDUAL SETTINGS
  // ─────────────────────────────────────────────────────────────

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() {
      _userName = name;
    });
    _showSavedMessage('Name saved!');
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() {
      _isDarkMode = value;
    });
    _showSavedMessage('Theme preference saved!');
  }

  Future<void> _saveVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
    setState(() {
      _volume = value;
    });
    // Don't show message for slider (too many updates)
  }

  Future<void> _saveFontSize(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('font_size', value);
    setState(() {
      _fontSize = value;
    });
    _showSavedMessage('Font size saved!');
  }

  // ─────────────────────────────────────────────────────────────
  // CLEAR ALL SETTINGS
  // ─────────────────────────────────────────────────────────────

  Future<void> _clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadSettings(); // Reload with defaults
    _showSavedMessage('All settings cleared!');
  }

  void _showSavedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD UI
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $_userName!'),
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Settings?'),
                  content: const Text('This will reset everything to defaults.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearAllSettings();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─────────────────────────────────────────────────────
          // STRING: User Name
          // ─────────────────────────────────────────────────────
          _buildSectionHeader('Your Name (String)'),
          Card(
            color: _isDarkMode ? Colors.grey[800] : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        _saveUserName(_nameController.text);
                      }
                    },
                    child: const Text('Save Name'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────────────────────────────
          // BOOL: Dark Mode
          // ─────────────────────────────────────────────────────
          _buildSectionHeader('Dark Mode (Boolean)'),
          Card(
            color: _isDarkMode ? Colors.grey[800] : null,
            child: SwitchListTile(
              title: Text(
                'Enable Dark Mode',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                _isDarkMode ? 'Dark theme active' : 'Light theme active',
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              value: _isDarkMode,
              onChanged: _saveDarkMode,
            ),
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────────────────────────────
          // DOUBLE: Volume
          // ─────────────────────────────────────────────────────
          _buildSectionHeader('Volume (Double)'),
          Card(
            color: _isDarkMode ? Colors.grey[800] : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Volume',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${_volume.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _volume,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: _saveVolume,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────────────────────────────
          // INT: Font Size
          // ─────────────────────────────────────────────────────
          _buildSectionHeader('Font Size (Integer)'),
          Card(
            color: _isDarkMode ? Colors.grey[800] : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Preview Text',
                    style: TextStyle(
                      fontSize: _fontSize.toDouble(),
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: _fontSize > 10
                            ? () => _saveFontSize(_fontSize - 2)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_fontSize',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: _fontSize < 32
                            ? () => _saveFontSize(_fontSize + 2)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─────────────────────────────────────────────────────
          // CURRENT VALUES DISPLAY
          // ─────────────────────────────────────────────────────
          _buildSectionHeader('Saved Values'),
          Card(
            color: _isDarkMode ? Colors.grey[800] : Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildValueRow('user_name', _userName),
                  _buildValueRow('dark_mode', _isDarkMode.toString()),
                  _buildValueRow('volume', _volume.toStringAsFixed(1)),
                  _buildValueRow('font_size', _fontSize.toString()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Info text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.blue[900] : Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: _isDarkMode ? Colors.blue[200] : Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Close and reopen the app - your settings will still be here!',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.blue[200] : Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$key: ',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. SharedPreferences Setup
 *    - Get instance with SharedPreferences.getInstance()
 *    - Instance is cached, but always await it
 *
 * 2. Saving Different Types
 *    - setString() for text
 *    - setBool() for true/false
 *    - setDouble() for decimals
 *    - setInt() for whole numbers
 *
 * 3. Loading with Defaults
 *    - getString() returns String?
 *    - Use ?? to provide default values
 *    - Always handle null case!
 *
 * 4. Clearing Data
 *    - remove('key') removes one item
 *    - clear() removes everything
 *
 * 5. Best Practices
 *    - Load settings in initState()
 *    - Save immediately when user changes setting
 *    - Show feedback when saving
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a "language" setting (String)
 * 2. Add notification preferences (multiple bools)
 * 3. Save and restore the last visited page
 * 4. Add "Remember me" for login
 * 5. Create a proper Settings service class
 *
 */
