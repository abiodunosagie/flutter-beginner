# Week 7, Day 1-2: Flutter Fundamentals - Your First Visual App

## What is Flutter?

**Flutter** is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

**Translation:** Write code once, run it on:
- 📱 **iOS** (iPhone, iPad)
- 🤖 **Android** (Samsung, Pixel, etc.)
- 💻 **Web** (Chrome, Firefox, Safari)
- 🖥️ **Desktop** (Windows, macOS, Linux)

---

## Why Flutter?

### Fast Development
- **Hot Reload** - See changes instantly (< 1 second)
- Like magic - save file, see changes immediately

### Beautiful UIs
- **Material Design** (Google's design system)
- **Cupertino** (iOS-style widgets)
- **Custom** - Build anything you can imagine

### High Performance
- **Native compiled** - Fast as native apps
- **60fps** animations by default
- **120fps** on supported devices

### Single Codebase
```
One codebase → Multiple platforms
iOS + Android + Web + Desktop
```

---

## Flutter Architecture

```
Your Dart Code
      ↓
Flutter Framework (Widgets, Rendering)
      ↓
Flutter Engine (Skia graphics, Dart runtime)
      ↓
Platform (iOS, Android, Web, Desktop)
```

**You work with:** Widgets (Dart code)
**Flutter handles:** Everything else

---

## Setting Up Flutter

### Step 1: Install Flutter SDK

**Windows:**
1. Download from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`

**macOS:**
```bash
# Using Homebrew
brew install flutter
```

**Linux:**
```bash
sudo snap install flutter --classic
```

### Step 2: Verify Installation

```bash
flutter doctor
```

This checks:
- ✓ Flutter SDK installed
- ✓ Android Studio / Xcode (for mobile)
- ✓ VS Code / Android Studio (editors)
- ✓ Connected devices

### Step 3: Install VS Code Extension

1. Open VS Code
2. Extensions → Search "Flutter"
3. Install official Flutter extension
4. This also installs Dart extension

---

## Creating Your First Flutter App

### Via Command Line

```bash
flutter create my_first_app
cd my_first_app
flutter run
```

### Via VS Code

1. `Ctrl+Shift+P` / `Cmd+Shift+P`
2. Type "Flutter: New Project"
3. Select "Application"
4. Choose folder and name
5. Wait for project creation

---

## Flutter Project Structure

```
my_first_app/
├── android/           # Android-specific code
├── ios/               # iOS-specific code
├── lib/               # YOUR DART CODE HERE
│   └── main.dart      # Entry point
├── test/              # Tests
├── pubspec.yaml       # Dependencies and config
└── README.md
```

**Focus on:**
- `lib/main.dart` - Your app code
- `pubspec.yaml` - Project configuration

---

## Understanding main.dart

Let's break down the default app:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

**Let's understand each part:**

### 1. Import

```dart
import 'package:flutter/material.dart';
```

- Imports Flutter's Material Design library
- Contains widgets like AppBar, Scaffold, Text, etc.

### 2. main() Function

```dart
void main() {
  runApp(MyApp());
}
```

- Entry point of Flutter app
- `runApp()` takes a Widget and makes it the root

### 3. MyApp Widget

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

- **Root widget** of your app
- **MaterialApp** = Material Design app
- **theme** = App-wide styling
- **home** = First screen shown

---

## Your First Custom App

Let's build a simple "Hello World" app from scratch:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter'),
        ),
        body: Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
```

**Running it:**
1. Save the file
2. Press `F5` in VS Code (or run `flutter run`)
3. See your app!

---

## Hot Reload - The Magic

Flutter's **Hot Reload** lets you see changes instantly:

**Try this:**
1. Change `'Hello, World!'` to `'Hello, Flutter!'`
2. Save file (`Ctrl+S` / `Cmd+S`)
3. Watch app update instantly (< 1 second!)

**Hot Reload:**
- Preserves app state
- Fast (< 1 second)
- Makes development addictive

**Hot Restart:**
- Full restart
- Loses state
- Use when hot reload doesn't work

**Keyboard shortcuts:**
- `r` in terminal = Hot Reload
- `R` in terminal = Hot Restart
- `q` = Quit

---

## Understanding Widgets

In Flutter, **everything is a widget**.

**Widget** = A description of part of the UI.

**Types:**
1. **Visible widgets:** Text, Image, Button
2. **Layout widgets:** Row, Column, Stack
3. **Styling widgets:** Padding, Center, Container

**Widget tree:**
```
MaterialApp
  └─ Scaffold
      ├─ AppBar
      │   └─ Text
      └─ Center
          └─ Text
```

---

## Basic Widgets

### Text

```dart
Text('Hello')
Text('Styled', style: TextStyle(fontSize: 24, color: Colors.blue))
```

### Container

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(child: Text('Container')),
)
```

### Center

```dart
Center(
  child: Text('Centered'),
)
```

### Column (Vertical)

```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

### Row (Horizontal)

```dart
Row(
  children: [
    Text('Left'),
    Text('Middle'),
    Text('Right'),
  ],
)
```

---

## Complete Example: Personal Card

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Card',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile picture placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20),

              // Name
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),

              SizedBox(height: 10),

              // Title
              Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),

              SizedBox(height: 20),

              // Divider
              Container(
                width: 200,
                height: 2,
                color: Colors.teal,
              ),

              SizedBox(height: 20),

              // Contact info
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.teal.shade50,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('john@example.com'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.teal),
                        SizedBox(width: 10),
                        Text('+1 234 567 8900'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## pubspec.yaml - Project Configuration

```yaml
name: my_first_app
description: A new Flutter project.

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

  # Add packages here
  # http: ^0.13.5

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true

  # Add assets here
  # assets:
  #   - images/
  #   - icons/
```

**Key sections:**
- **dependencies** - Packages your app needs
- **assets** - Images, fonts, files
- **uses-material-design** - Use Material icons

### Adding a Package

1. Find package on [pub.dev](https://pub.dev)
2. Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     http: ^0.13.5
   ```
3. Run `flutter pub get`
4. Import in code:
   ```dart
   import 'package:http/http.dart' as http;
   ```

---

## Running on Different Platforms

### Android Emulator

1. Open Android Studio
2. AVD Manager → Create Virtual Device
3. Run: `flutter run`

### iOS Simulator (macOS only)

1. Open Xcode
2. Run: `flutter run`

### Chrome (Web)

```bash
flutter run -d chrome
```

### Physical Device

1. Enable Developer Mode on phone
2. Connect via USB
3. Run: `flutter run`

---

## Debugging

### print() Statements

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
    print('Counter: $_counter');  // Debug output
  });
}
```

### Debug Console

In VS Code, see output in DEBUG CONSOLE panel.

### Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

**Features:**
- Widget Inspector
- Performance view
- Network profiling
- Memory analysis

---

## Common Issues

### Issue 1: Flutter Not Found

**Solution:**
- Add Flutter to PATH
- Restart terminal
- Run `flutter doctor`

### Issue 2: No Devices Available

**Solution:**
- Start emulator/simulator
- Connect physical device
- Try `flutter run -d chrome`

### Issue 3: Hot Reload Not Working

**Solution:**
- Use Hot Restart (`Shift+R`)
- Some changes require full restart

---

## Exercises

### Exercise 1: Modify Counter App
Change the default counter app:
- Change app title
- Change button color
- Change text size
- Add your name

### Exercise 2: Create Welcome Screen
Build a welcome screen with:
- AppBar with title
- Large "Welcome!" text
- Your name below it
- A description text

### Exercise 3: Info Card
Create an info card showing:
- An icon at top
- Title text
- Description text
- Nice colors

---

## Key Takeaways

1. **Flutter** = One code, multiple platforms
2. **Everything is a widget**
3. **Hot Reload** = Instant feedback
4. **MaterialApp** = Root of app
5. **Scaffold** = Basic page structure
6. **pubspec.yaml** = Configuration

---

## What's Next?

Tomorrow:
- **Widgets in depth** - Text, Container, Row, Column
- **Widget properties** - Colors, sizes, styling
- **Layout basics** - Building complex UIs

You've entered the Flutter world! Welcome! 📱✨
