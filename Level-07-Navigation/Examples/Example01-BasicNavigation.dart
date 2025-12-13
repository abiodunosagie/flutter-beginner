// Example 01: Basic Navigation
// Learn Navigator.push, pop, and the navigation stack

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 1: HOME
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🏠',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Home!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'This is the first screen in the navigation stack.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Navigate to Details
              _NavButton(
                label: 'Go to Details',
                icon: Icons.arrow_forward,
                color: Colors.blue,
                onPressed: () {
                  // ─────────────────────────────────────────
                  // PUSH: Add new screen to stack
                  // ─────────────────────────────────────────
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Navigate to Profile
              _NavButton(
                label: 'View Profile',
                icon: Icons.person,
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Navigate to Settings
              _NavButton(
                label: 'Settings',
                icon: Icons.settings,
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 2: DETAILS
// ═══════════════════════════════════════════════════════════════

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        // Back button is automatic!
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '📋',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              const Text(
                'Details Screen',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'You pushed this screen onto the stack.\n'
                'The Home screen is still behind this one.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Go back
              _NavButton(
                label: 'Go Back',
                icon: Icons.arrow_back,
                color: Colors.purple,
                onPressed: () {
                  // ─────────────────────────────────────────
                  // POP: Remove this screen from stack
                  // ─────────────────────────────────────────
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 16),

              // Go deeper
              _NavButton(
                label: 'Go Deeper',
                icon: Icons.arrow_downward,
                color: Colors.indigo,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeepScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 3: DEEP SCREEN
// ═══════════════════════════════════════════════════════════════

class DeepScreen extends StatelessWidget {
  const DeepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Screen'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🕳️',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              const Text(
                'Deep in the Stack!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Stack: Home → Details → Deep\n'
                'You are 3 screens deep!',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Go back one screen
              _NavButton(
                label: 'Go Back One',
                icon: Icons.arrow_back,
                color: Colors.indigo,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 16),

              // Go back to Home (clear stack)
              _NavButton(
                label: 'Go Home (Clear Stack)',
                icon: Icons.home,
                color: Colors.red,
                onPressed: () {
                  // ─────────────────────────────────────────
                  // PUSH AND REMOVE UNTIL: Clear entire stack
                  // ─────────────────────────────────────────
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false, // Remove all routes
                  );
                },
              ),

              const SizedBox(height: 16),

              // Pop until home
              _NavButton(
                label: 'Pop Until Home',
                icon: Icons.first_page,
                color: Colors.teal,
                onPressed: () {
                  // ─────────────────────────────────────────
                  // POP UNTIL: Pop screens until condition
                  // ─────────────────────────────────────────
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 4: PROFILE
// ═══════════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Text('JD', style: TextStyle(fontSize: 40, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            _NavButton(
              label: 'Edit Profile',
              icon: Icons.edit,
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 5: EDIT PROFILE (with replacement demo)
// ═══════════════════════════════════════════════════════════════

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✏️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _NavButton(
              label: 'Save & Replace',
              icon: Icons.save,
              color: Colors.teal,
              onPressed: () {
                // ─────────────────────────────────────────
                // PUSH REPLACEMENT: Replace current screen
                // User can't go back to edit screen
                // ─────────────────────────────────────────
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _NavButton(
              label: 'Cancel',
              icon: Icons.cancel,
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 6: SETTINGS
// ═══════════════════════════════════════════════════════════════

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Navigation Demo',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGET: Navigation Button
// ═══════════════════════════════════════════════════════════════

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
 * 1. Navigator.push()
 *    - Adds a new screen on top of the stack
 *    - Previous screen remains underneath
 *
 * 2. Navigator.pop()
 *    - Removes the current screen
 *    - Returns to previous screen
 *
 * 3. Navigator.pushReplacement()
 *    - Replaces current screen with new one
 *    - User can't go back to replaced screen
 *
 * 4. Navigator.pushAndRemoveUntil()
 *    - Navigates to new screen
 *    - Removes all screens until condition
 *
 * 5. Navigator.popUntil()
 *    - Pops screens until condition is met
 *    - Useful for "go home" functionality
 *
 * ═══════════════════════════════════════════════════════════════
 * NAVIGATION STACK VISUALIZATION:
 * ═══════════════════════════════════════════════════════════════
 *
 *   Initial:          After push:        After push again:
 *   ┌───────┐        ┌───────┐          ┌───────┐
 *   │ Home  │        │Details│          │ Deep  │
 *   └───────┘        ├───────┤          ├───────┤
 *                    │ Home  │          │Details│
 *                    └───────┘          ├───────┤
 *                                       │ Home  │
 *                                       └───────┘
 *
 *   After pop:        After popUntil(first):
 *   ┌───────┐        ┌───────┐
 *   │Details│        │ Home  │
 *   ├───────┤        └───────┘
 *   │ Home  │
 *   └───────┘
 *
 */
