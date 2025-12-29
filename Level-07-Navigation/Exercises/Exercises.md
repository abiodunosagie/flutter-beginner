# Level 07: Navigation Exercises

## How These Exercises Work

Each skill is broken into **small steps**. Complete each step before moving to the next. By the end, you'll combine everything!

```
THE PROGRESSIVE LEARNING PATH:

Step 1: Learn one tiny piece ──────────────► Practice it
Step 2: Learn next tiny piece ─────────────► Practice it
Step 3: Learn next tiny piece ─────────────► Practice it
...
Final: Combine ALL pieces ─────────────────► Build complete app!
```

---

# PART 1: BASIC NAVIGATION

## Exercise 1.1: Create Two Screens

**Goal:** Create separate screens to navigate between.

**Your Task:** Create a HomeScreen and a DetailScreen.

```dart
import 'package:flutter/material.dart';

// TODO: Create HomeScreen with:
// - AppBar with title "Home"
// - Center text saying "This is the Home Screen"

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your code here...
  }
}

// TODO: Create DetailScreen with:
// - AppBar with title "Detail"
// - Center text saying "This is the Detail Screen"

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your code here...
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text('This is the Home Screen'),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Text('This is the Detail Screen'),
      ),
    );
  }
}
```

</details>

---

## Exercise 1.2: Navigate to a New Screen

**Goal:** Use Navigator.push to go to another screen.

**Your Task:** Add a button that navigates to DetailScreen.

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Use Navigator.push to go to DetailScreen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ??? ),
            // );
          },
          child: Text('Go to Detail'),
        ),
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen()),
    );
  },
  child: Text('Go to Detail'),
)
```

</details>

---

## Exercise 1.3: Go Back to Previous Screen

**Goal:** Use Navigator.pop to return.

**Your Task:** Add a "Go Back" button on the DetailScreen.

```dart
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Detail Screen'),
            SizedBox(height: 20),
            // TODO: Add ElevatedButton that calls Navigator.pop(context)
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
ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: Text('Go Back'),
)
```

</details>

---

## Exercise 1.4: Pass Data to Next Screen

**Goal:** Send data when navigating.

**Your Task:** Pass a message to the DetailScreen.

```dart
// Update DetailScreen to accept a message
class DetailScreen extends StatelessWidget {
  // TODO: Add final String message; property
  // TODO: Add required parameter in constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        // TODO: Display the message instead of static text
        child: Text('Display the message here'),
      ),
    );
  }
}

// In HomeScreen:
// Pass message: 'Hello from Home!' when navigating
```

<details>
<summary>✅ Solution</summary>

```dart
class DetailScreen extends StatelessWidget {
  final String message;

  const DetailScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

// In HomeScreen:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(message: 'Hello from Home!'),
  ),
);
```

</details>

---

## Exercise 1.5: Return Data from a Screen

**Goal:** Get data back when popping.

**Your Task:** Return a value when going back.

```dart
// In DetailScreen:
ElevatedButton(
  onPressed: () {
    // TODO: Return 'Data from Detail' when popping
    // Navigator.pop(context, ???);
  },
  child: Text('Return with Data'),
)

// In HomeScreen:
ElevatedButton(
  onPressed: () async {
    // TODO: Capture the returned value
    // final result = await Navigator.push(...);
    // print('Received: $result');
  },
  child: Text('Go to Detail'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
// In DetailScreen:
ElevatedButton(
  onPressed: () {
    Navigator.pop(context, 'Data from Detail');
  },
  child: Text('Return with Data'),
)

// In HomeScreen:
ElevatedButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen()),
    );
    print('Received: $result');
  },
  child: Text('Go to Detail'),
)
```

</details>

---

## Exercise 1.6: Basic Navigation Challenge

**Goal:** Build a simple profile viewer WITHOUT looking at solutions.

**Requirements:**
- HomeScreen with a list of 3 names
- Tap name to go to ProfileScreen
- ProfileScreen shows the name passed to it
- Back button returns to HomeScreen

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  final names = ['Alice', 'Bob', 'Charlie'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(name: names[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String name;

  const ProfileScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100),
            SizedBox(height: 20),
            Text(name, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
```

</details>

---

# PART 2: NAMED ROUTES

## Exercise 2.1: Define Routes

**Goal:** Set up named routes in MaterialApp.

**Your Task:** Define routes for home and detail screens.

```dart
void main() {
  runApp(
    MaterialApp(
      // TODO: Add routes map
      // routes: {
      //   '/': (context) => ???,
      //   '/detail': (context) => ???,
      // },
    ),
  );
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => HomeScreen(),
        '/detail': (context) => DetailScreen(),
      },
    ),
  );
}
```

</details>

---

## Exercise 2.2: Navigate Using Route Names

**Goal:** Use pushNamed instead of push.

**Your Task:** Navigate using the route name.

```dart
ElevatedButton(
  onPressed: () {
    // TODO: Use Navigator.pushNamed to go to '/detail'
  },
  child: Text('Go to Detail'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/detail');
  },
  child: Text('Go to Detail'),
)
```

</details>

---

## Exercise 2.3: Pass Arguments with Named Routes

**Goal:** Send data using arguments parameter.

**Your Task:** Pass data to a named route.

```dart
// Navigate with arguments:
ElevatedButton(
  onPressed: () {
    // TODO: Use Navigator.pushNamed with arguments
    // Navigator.pushNamed(
    //   context,
    //   '/detail',
    //   arguments: 'Hello!',
    // );
  },
  child: Text('Go to Detail'),
)

// In DetailScreen, receive the argument:
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get arguments using ModalRoute
    // final message = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
        child: Text('???'),  // Show the message
      ),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
// Navigate:
Navigator.pushNamed(
  context,
  '/detail',
  arguments: 'Hello!',
);

// Receive:
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
```

</details>

---

## Exercise 2.4: Use Route Constants

**Goal:** Organize routes with constants.

**Your Task:** Create a class for route names.

```dart
// TODO: Create AppRoutes class with static constants
// class AppRoutes {
//   static const home = '/';
//   static const detail = '/detail';
//   static const settings = '/settings';
// }

// Use like this:
// Navigator.pushNamed(context, AppRoutes.detail);
```

<details>
<summary>✅ Solution</summary>

```dart
class AppRoutes {
  static const home = '/';
  static const detail = '/detail';
  static const settings = '/settings';

  // Private constructor to prevent instantiation
  AppRoutes._();
}

// In MaterialApp:
MaterialApp(
  routes: {
    AppRoutes.home: (context) => HomeScreen(),
    AppRoutes.detail: (context) => DetailScreen(),
    AppRoutes.settings: (context) => SettingsScreen(),
  },
)

// Navigate:
Navigator.pushNamed(context, AppRoutes.detail);
```

</details>

---

## Exercise 2.5: Named Routes Challenge

**Goal:** Build a 3-screen app WITHOUT looking at solutions.

**Requirements:**
- Define routes: '/', '/profile', '/settings'
- HomeScreen with buttons to go to Profile and Settings
- ProfileScreen shows "Profile Page"
- SettingsScreen shows "Settings Page"
- Use route constants
- Each screen can go back

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';
  AppRoutes._();
}

void main() {
  runApp(
    MaterialApp(
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.profile: (context) => ProfileScreen(),
        AppRoutes.settings: (context) => SettingsScreen(),
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Text('Go to Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              child: Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Page')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Page')),
    );
  }
}
```

</details>

---

# PART 3: NAVIGATION STACK MANIPULATION

## Exercise 3.1: Push and Replace

**Goal:** Replace current screen instead of stacking.

**Your Task:** Use pushReplacementNamed.

```dart
// After login success, replace login screen with home
// (So user can't go "back" to login)

ElevatedButton(
  onPressed: () {
    // TODO: Use pushReplacementNamed instead of pushNamed
    // This removes current screen from stack
  },
  child: Text('Login'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, '/home');
  },
  child: Text('Login'),
)
```

</details>

---

## Exercise 3.2: Clear Stack and Navigate

**Goal:** Remove all screens and start fresh.

**Your Task:** Use pushNamedAndRemoveUntil.

```dart
// After checkout success, clear all shopping screens
// and go back to home

ElevatedButton(
  onPressed: () {
    // TODO: Clear entire stack and push home
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   ???,
    //   (route) => ???,
    // );
  },
  child: Text('Finish Order'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,  // Remove ALL routes
    );
  },
  child: Text('Finish Order'),
)
```

</details>

---

## Exercise 3.3: Pop Until Specific Route

**Goal:** Go back multiple screens at once.

**Your Task:** Pop until reaching home screen.

```dart
// On a deeply nested screen, go all the way back to home

ElevatedButton(
  onPressed: () {
    // TODO: Pop until home route
    // Navigator.popUntil(context, ???);
  },
  child: Text('Back to Home'),
)
```

<details>
<summary>✅ Solution</summary>

```dart
ElevatedButton(
  onPressed: () {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  },
  child: Text('Back to Home'),
)
```

</details>

---

## Exercise 3.4: Stack Manipulation Challenge

**Goal:** Build a login flow WITHOUT looking at solutions.

**Requirements:**
- SplashScreen → checks if logged in
- If not logged in → LoginScreen (replaces splash)
- After login → HomeScreen (replaces login)
- Logout from home → LoginScreen (clears stack)

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';

bool isLoggedIn = false;

void main() => runApp(MaterialApp(
  routes: {
    '/': (context) => SplashScreen(),
    '/login': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
  },
));

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(Duration(seconds: 1));  // Simulate check

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            isLoggedIn = true;
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            isLoggedIn = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
```

</details>

---

# PART 4: BOTTOM NAVIGATION

## Exercise 4.1: Create BottomNavigationBar

**Goal:** Add bottom navigation to an app.

**Your Task:** Create a scaffold with bottom navigation.

```dart
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Tab $_currentIndex'),
      ),
      // TODO: Add BottomNavigationBar with 3 items
      // - Home icon, label "Home"
      // - Search icon, label "Search"
      // - Profile icon, label "Profile"
      // currentIndex: _currentIndex
      // onTap: update _currentIndex
      bottomNavigationBar: ???,
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Tab $_currentIndex'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

</details>

---

## Exercise 4.2: Switch Between Screens

**Goal:** Show different content for each tab.

**Your Task:** Display a different widget for each tab.

```dart
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // TODO: Create list of screens
  final _screens = [
    // HomeTab(),
    // SearchTab(),
    // ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Display the current screen based on _currentIndex
      body: ???,
      bottomNavigationBar: BottomNavigationBar(...),
    );
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    HomeTab(),
    SearchTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home'));
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search'));
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile'));
  }
}
```

</details>

---

## Exercise 4.3: Preserve Tab State

**Goal:** Keep tab state when switching.

**Your Task:** Use IndexedStack to preserve state.

```dart
// Problem: When switching tabs, the previous tab rebuilds
// and loses its state (scroll position, form data, etc.)

// TODO: Replace this:
body: _screens[_currentIndex],

// With IndexedStack to preserve state:
body: IndexedStack(
  index: ???,
  children: ???,
),
```

<details>
<summary>✅ Solution</summary>

```dart
body: IndexedStack(
  index: _currentIndex,
  children: _screens,
),
```

</details>

---

## Exercise 4.4: Bottom Navigation Challenge

**Goal:** Build a social app WITHOUT looking at solutions.

**Requirements:**
- 4 tabs: Feed, Messages, Notifications, Profile
- Use IndexedStack to preserve state
- Each tab shows its name
- Feed tab has a counter that persists when switching tabs

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MainScreen()));

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    FeedTab(),
    MessagesTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Feed with counter that persists
class FeedTab extends StatefulWidget {
  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $_count', style: TextStyle(fontSize: 32)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Center(child: Text('Messages')),
    );
  }
}

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(child: Text('Notifications')),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile')),
    );
  }
}
```

</details>

---

# PART 5: FINAL PROJECT

## Build a Photo Gallery App

**Goal:** Combine EVERYTHING you learned!

**Requirements:**
1. HomeScreen with grid of photo thumbnails (emojis)
2. Tap photo to go to PhotoDetailScreen
3. Pass photo data (title, description, emoji)
4. PhotoDetailScreen shows full photo info
5. "Related Photos" section in detail that navigates to other photos
6. Use named routes with AppRoutes class
7. Add bottom navigation with 2 tabs:
   - Gallery tab (the photo grid)
   - Favorites tab (static "No favorites yet" text)

**Build it step by step:**

### Step 1: Create AppRoutes class
### Step 2: Create Photo model
### Step 3: Create GalleryScreen with grid
### Step 4: Create PhotoDetailScreen
### Step 5: Add bottom navigation
### Step 6: Wire everything together

---

**Try to build this WITHOUT looking at the solution!**

<details>
<summary>✅ Complete Solution</summary>

```dart
import 'package:flutter/material.dart';

// Route constants
class AppRoutes {
  static const home = '/';
  static const photoDetail = '/photo';
  AppRoutes._();
}

// Model
class Photo {
  final String id;
  final String emoji;
  final String title;
  final String description;

  const Photo({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
  });
}

// Sample data
final photos = [
  Photo(id: '1', emoji: '🌅', title: 'Sunset', description: 'Beautiful sunset at the beach'),
  Photo(id: '2', emoji: '🏔️', title: 'Mountains', description: 'Snow-capped mountains'),
  Photo(id: '3', emoji: '🌲', title: 'Forest', description: 'Dense green forest'),
  Photo(id: '4', emoji: '🌊', title: 'Ocean', description: 'Calm ocean waves'),
  Photo(id: '5', emoji: '🌆', title: 'City', description: 'City skyline at dusk'),
  Photo(id: '6', emoji: '🏜️', title: 'Desert', description: 'Golden sand dunes'),
];

void main() {
  runApp(
    MaterialApp(
      title: 'Photo Gallery',
      routes: {
        AppRoutes.home: (context) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.photoDetail) {
          final photo = settings.arguments as Photo;
          return MaterialPageRoute(
            builder: (context) => PhotoDetailScreen(photo: photo),
          );
        }
        return null;
      },
    ),
  );
}

// Main screen with bottom nav
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = [
    GalleryTab(),
    FavoritesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

// Gallery Tab
class GalleryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.photoDetail,
                arguments: photo,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(photo.emoji, style: TextStyle(fontSize: 40)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Favorites Tab
class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No favorites yet'),
          ],
        ),
      ),
    );
  }
}

// Photo Detail Screen
class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    // Get related photos (excluding current)
    final relatedPhotos = photos.where((p) => p.id != photo.id).take(3).toList();

    return Scaffold(
      appBar: AppBar(title: Text(photo.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large photo
            Container(
              height: 300,
              color: Colors.grey[200],
              child: Center(
                child: Text(photo.emoji, style: TextStyle(fontSize: 100)),
              ),
            ),

            // Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(photo.description),
                ],
              ),
            ),

            // Related photos
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Related Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: relatedPhotos.length,
                itemBuilder: (context, index) {
                  final related = relatedPhotos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.photoDetail,
                        arguments: related,
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(related.emoji, style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

</details>

---

## Congratulations!

You've completed all the Navigation exercises!

**What you learned:**
- ✅ Basic navigation with push and pop
- ✅ Passing data between screens
- ✅ Returning data from screens
- ✅ Named routes with route constants
- ✅ Passing arguments with named routes
- ✅ Stack manipulation (replace, clear, popUntil)
- ✅ Bottom navigation with IndexedStack
- ✅ Preserving tab state
- ✅ Building complete apps with navigation

**Next Steps:**
1. Try GoRouter for more advanced routing
2. Add deep linking to your app
3. Move on to Level 08: API Integration

---

## Navigation Cheat Sheet

```
┌─────────────────────────────────────────────────────────────┐
│              NAVIGATION PATTERN CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  BASIC NAVIGATION:                                          │
│  Navigator.push(context, MaterialPageRoute(...))            │
│  Navigator.pop(context)                                     │
│  Navigator.pop(context, data)  // Return data               │
│                                                             │
│  NAMED ROUTES:                                              │
│  Navigator.pushNamed(context, '/route')                     │
│  Navigator.pushNamed(context, '/route', arguments: data)    │
│                                                             │
│  GET ARGUMENTS:                                             │
│  ModalRoute.of(context)!.settings.arguments                 │
│                                                             │
│  STACK MANIPULATION:                                        │
│  pushReplacementNamed(context, '/route')                    │
│  pushNamedAndRemoveUntil(context, '/route', (r) => false)   │
│  popUntil(context, ModalRoute.withName('/'))                │
│                                                             │
│  BOTTOM NAV:                                                │
│  BottomNavigationBar + IndexedStack                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Back to Level 07 README](../README.md) | [Level 08: API Integration →](../../Level-08-API-Integration/README.md)
