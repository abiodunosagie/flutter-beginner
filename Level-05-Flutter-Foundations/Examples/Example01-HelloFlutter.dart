// Example 1: Hello Flutter
// Your very first Flutter app!

import 'package:flutter/material.dart';

// The entry point of every Flutter app
void main() {
  runApp(const MyApp());
}

// The root widget of your app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title (shows in task switcher)
      title: 'Hello Flutter',

      // Theme configuration
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      // The home page
      home: const HomePage(),

      // Remove the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}

// The main page of our app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar
      appBar: AppBar(
        title: const Text('Hello Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // Main content
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A simple icon
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),

            // Hello message
            Text(
              'Hello, Flutter!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Subtitle
            Text(
              'Welcome to your first app',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * KEY CONCEPTS:
 *
 * 1. main() function
 *    - Entry point of the app
 *    - Calls runApp() with the root widget
 *
 * 2. MaterialApp
 *    - Wraps your entire app
 *    - Provides Material Design styling
 *    - Sets up navigation, themes, etc.
 *
 * 3. Scaffold
 *    - Basic page structure
 *    - Provides appBar, body, floatingActionButton, etc.
 *
 * 4. StatelessWidget
 *    - A widget that doesn't change
 *    - Perfect for static content
 *
 * 5. const keyword
 *    - Used for widgets that never change
 *    - Improves performance
 *
 * HOW TO RUN:
 * 1. Create a new Flutter project: flutter create my_app
 * 2. Replace lib/main.dart with this code
 * 3. Run: flutter run
 *
 * EXERCISES:
 * 1. Change the greeting text
 * 2. Try a different icon (Icons.star, Icons.favorite, etc.)
 * 3. Change the colors
 * 4. Add more Text widgets
 */
