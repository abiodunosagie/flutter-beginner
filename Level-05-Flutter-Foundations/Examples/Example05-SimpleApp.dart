// Example 5: Simple Complete App
// Putting it all together - a profile card app

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ProfileApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main App Page
class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  int _selectedIndex = 0;

  // Different pages for bottom navigation
  static const List<Widget> _pages = [
    HomePage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Card App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search tapped')),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        // Header Card
        HeaderCard(),
        SizedBox(height: 16),

        // Stats Row
        StatsCard(),
        SizedBox(height: 16),

        // About Section
        AboutCard(),
        SizedBox(height: 16),

        // Skills Section
        SkillsCard(),
        SizedBox(height: 16),

        // Contact Section
        ContactCard(),
      ],
    );
  }
}

// Header Card with Profile Picture
class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Title
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'San Francisco, CA',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add),
                  label: const Text('Follow'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Message'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Stats Card
class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatItem(label: 'Projects', value: '24'),
            StatItem(label: 'Followers', value: '1.2K'),
            StatItem(label: 'Following', value: '386'),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// About Card
class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Passionate Flutter developer with 5+ years of experience building beautiful, '
              'performant mobile applications. Love creating intuitive user interfaces and '
              'solving complex problems.',
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Skills Card
class SkillsCard extends StatelessWidget {
  const SkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_objects, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Skills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                SkillChip(label: 'Flutter'),
                SkillChip(label: 'Dart'),
                SkillChip(label: 'Firebase'),
                SkillChip(label: 'REST APIs'),
                SkillChip(label: 'State Management'),
                SkillChip(label: 'UI/UX'),
                SkillChip(label: 'Git'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.teal[50],
      labelStyle: const TextStyle(color: Colors.teal),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

// Contact Card
class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.contact_mail, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const ContactItem(
              icon: Icons.email,
              label: 'john.doe@example.com',
            ),
            const SizedBox(height: 8),
            const ContactItem(
              icon: Icons.phone,
              label: '+1 (555) 123-4567',
            ),
            const SizedBox(height: 8),
            const ContactItem(
              icon: Icons.language,
              label: 'johndoe.dev',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}

// FAVORITES PAGE
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<String> _favorites = [
    'Flutter Documentation',
    'Dart Language Tour',
    'Material Design',
    'Firebase Guides',
  ];

  void _removeFavorite(int index) {
    setState(() {
      _favorites.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _favorites.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.bookmark),
                  ),
                  title: Text(_favorites[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(index),
                  ),
                ),
              );
            },
          );
  }
}

// SETTINGS PAGE
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Account Section
        const ListTile(
          leading: Icon(Icons.person),
          title: Text('Account'),
          subtitle: Text('john.doe@example.com'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(),

        // Notifications
        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Enable push notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),

        // Dark Mode
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch to dark theme'),
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        const Divider(),

        // Font Size
        ListTile(
          title: const Text('Font Size'),
          subtitle: Slider(
            value: _fontSize,
            min: 12,
            max: 24,
            divisions: 6,
            label: _fontSize.round().toString(),
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ),
        const Divider(),

        // Other Options
        const ListTile(
          leading: Icon(Icons.language),
          title: Text('Language'),
          subtitle: Text('English'),
          trailing: Icon(Icons.chevron_right),
        ),
        const ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('Privacy'),
          trailing: Icon(Icons.chevron_right),
        ),
        const ListTile(
          leading: Icon(Icons.help),
          title: Text('Help & Support'),
          trailing: Icon(Icons.chevron_right),
        ),
        const Divider(),

        // Logout
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out')),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/*
 * KEY CONCEPTS DEMONSTRATED:
 *
 * 1. App Structure
 *    - MaterialApp as root
 *    - Scaffold for page structure
 *    - AppBar, body, bottomNavigationBar
 *
 * 2. Navigation
 *    - BottomNavigationBar for tab navigation
 *    - Switching between pages
 *    - State management across tabs
 *
 * 3. Widgets Used
 *    - Card for grouping content
 *    - ListView for scrolling
 *    - Row/Column for layout
 *    - Stack for overlapping (badge)
 *    - Wrap for flowing chips
 *
 * 4. Stateful vs Stateless
 *    - StatefulWidget for interactive parts
 *    - StatelessWidget for static content
 *    - Proper state management
 *
 * 5. User Interaction
 *    - Buttons (ElevatedButton, OutlinedButton)
 *    - Switches and Sliders
 *    - ListTiles with tap handlers
 *    - Dialogs for confirmation
 *
 * 6. Styling
 *    - Theme colors
 *    - Custom text styles
 *    - Icons and colors
 *    - Cards and elevation
 *
 * 7. Lists and Collections
 *    - Dynamic list (favorites)
 *    - Add/remove items
 *    - ListView.builder
 *
 * 8. Feedback
 *    - SnackBar for messages
 *    - AlertDialog for confirmation
 *
 * WHAT YOU'VE LEARNED:
 * - Building complete app layouts
 * - Managing multiple pages
 * - Combining stateful and stateless widgets
 * - Creating reusable components
 * - Handling user interactions
 * - Displaying data in lists
 * - Styling and theming
 *
 * NEXT STEPS:
 * 1. Add more pages or features
 * 2. Implement actual data storage
 * 3. Add navigation to detail pages
 * 4. Customize the theme
 * 5. Add animations
 * 6. Integrate real data from APIs
 *
 * EXERCISES:
 * 1. Add a new tab for "Projects"
 * 2. Create a profile edit page
 * 3. Add ability to edit skills
 * 4. Implement a search feature
 * 5. Add profile picture upload (mock)
 * 6. Create a detail page for each stat
 */
