# Firebase Setup: Getting Started

## The Big Idea In One Sentence

> Firebase is a ready-made backend from Google (login, database, file storage), and setup means connecting your Flutter app to a Firebase project so it can use those services.

## The Simple Explanation

Setting up Firebase is like getting a library card:
1. Sign up for a library account (Firebase Console)
2. Get your library card (configuration files)
3. Use it to borrow books (Firebase services)

```
┌─────────────────────────────────────────────────────────┐
│                   FIREBASE SETUP                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Step 1: Create Firebase Project (on website)           │
│              ↓                                           │
│  Step 2: Add Flutter App to Project                     │
│              ↓                                           │
│  Step 3: Download Config Files                          │
│              ↓                                           │
│  Step 4: Add Firebase Packages                          │
│              ↓                                           │
│  Step 5: Initialize in Your App                         │
│              ↓                                           │
│         🎉 Ready to Use!                                │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Step 1: Create a Firebase Project

### 1.1 Go to Firebase Console

1. Visit [console.firebase.google.com](https://console.firebase.google.com)
2. Sign in with your Google account
3. Click **"Create a project"**

```
┌─────────────────────────────────────┐
│        Firebase Console             │
├─────────────────────────────────────┤
│                                     │
│    ┌───────────────────────┐       │
│    │                       │       │
│    │   + Create a project  │ ← Click here
│    │                       │       │
│    └───────────────────────┘       │
│                                     │
└─────────────────────────────────────┘
```

### 1.2 Name Your Project

```
Project name: my-flutter-app
                    ↓
         (Auto-generates ID)
Project ID: my-flutter-app-12345

[Continue]
```

### 1.3 Configure Google Analytics (Optional)

```
Enable Google Analytics for this project?

○ Enable (recommended)  ← Select this
○ Disable

[Create project]
```

Wait for setup to complete (~30 seconds)

---

## Step 2: Add Flutter to Your Project

### 2.1 Select Platform

After project creation, you'll see the project dashboard:

```
┌─────────────────────────────────────┐
│      Get started by adding          │
│      Firebase to your app           │
├─────────────────────────────────────┤
│                                     │
│   [iOS]  [Android]  [Web]  [...]   │
│                                     │
│   For Flutter, we need BOTH         │
│   iOS and Android!                  │
│                                     │
└─────────────────────────────────────┘
```

### 2.2 The Easy Way: FlutterFire CLI

The FlutterFire CLI automatically configures everything!

```bash
# 1. Install the FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Make sure you're logged in to Firebase
firebase login

# 3. Run configure in your Flutter project folder
flutterfire configure
```

The CLI will:
- Show you your Firebase projects
- Create apps for iOS and Android
- Download configuration files
- Generate a Firebase options file

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  ? Select a Firebase project:                           │
│    ❯ my-flutter-app (my-flutter-app-12345)             │
│      another-project                                    │
│      <create a new project>                             │
│                                                          │
│  ? Which platforms should your configuration support?   │
│    ✓ android                                            │
│    ✓ ios                                                │
│    ○ macos                                              │
│    ○ web                                                │
│                                                          │
│  ✓ Generated firebase_options.dart                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Step 3: Add Firebase Packages

### 3.1 Add to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase Core (REQUIRED)
  firebase_core: ^2.24.0

  # Add the services you need:
  firebase_auth: ^4.16.0        # Authentication
  cloud_firestore: ^4.14.0      # Database
  firebase_storage: ^11.6.0     # File storage
```

### 3.2 Install Packages

```bash
flutter pub get
```

---

## Step 4: Initialize Firebase

### 4.1 Update main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generated by FlutterFire CLI

void main() async {
  // This is required for Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      home: const HomeScreen(),
    );
  }
}
```

### 4.2 What Each Line Does

```dart
// Required before using any Flutter plugins
WidgetsFlutterBinding.ensureInitialized();

// Connects your app to Firebase
await Firebase.initializeApp(
  // Uses the correct config for iOS/Android/Web
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Step 5: Verify Setup

### Create a Test Screen

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Firebase Connected!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'App: ${Firebase.app().name}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

If you see "Firebase Connected!" without errors, you're ready!

---

## Manual Setup (Alternative)

If FlutterFire CLI doesn't work, here's manual setup:

### For Android

1. In Firebase Console, click "Add app" → Android
2. Enter package name (from `android/app/build.gradle`)
3. Download `google-services.json`
4. Place it in `android/app/`

```
android/
├── app/
│   ├── google-services.json  ← Put here
│   ├── build.gradle
│   └── src/
```

5. Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

6. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### For iOS

1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID (from Xcode or `ios/Runner.xcodeproj`)
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Drag the plist file into Runner folder

```
ios/
├── Runner/
│   ├── GoogleService-Info.plist  ← Put here
│   ├── Info.plist
│   └── AppDelegate.swift
```

---

## Project Structure After Setup

```
your_flutter_app/
├── lib/
│   ├── main.dart
│   └── firebase_options.dart  ← Generated by CLI
│
├── android/
│   └── app/
│       └── google-services.json  ← Android config
│
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist  ← iOS config
│
└── pubspec.yaml  ← Firebase dependencies
```

---

## Common Setup Errors

### Error 1: "No Firebase App"

```
FirebaseException: No Firebase App '[DEFAULT]' has been created
```

**Fix:** Make sure you call `Firebase.initializeApp()` before using any Firebase service.

### Error 2: "google-services.json not found"

```
File google-services.json is missing
```

**Fix:** Download the file from Firebase Console and place it in `android/app/`.

### Error 3: "Configuration not found"

```
Could not find firebase_options.dart
```

**Fix:** Run `flutterfire configure` again, or create the file manually.

### Error 4: "Minimum SDK version"

```
minSdkVersion 16 cannot be smaller than version 19
```

**Fix:** In `android/app/build.gradle`, update:
```gradle
defaultConfig {
    minSdkVersion 21  // Change to 21 or higher
}
```

---

## Firebase Console Overview

```
┌─────────────────────────────────────────────────────────┐
│                 FIREBASE CONSOLE                         │
├──────────────┬──────────────────────────────────────────┤
│              │                                          │
│  Project     │  SERVICES                                │
│  Overview    │  ├── Authentication                      │
│              │  ├── Firestore Database                  │
│  Build       │  ├── Storage                             │
│  ├── Auth    │  └── ...                                 │
│  ├── Database│                                          │
│  ├── Storage │  MONITORING                              │
│  └── ...     │  ├── Analytics                           │
│              │  ├── Crashlytics                         │
│  Release     │  └── Performance                         │
│              │                                          │
└──────────────┴──────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              FIREBASE SETUP CHECKLIST                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  □ Create Firebase project at console.firebase.google   │
│                                                          │
│  □ Install FlutterFire CLI:                             │
│    dart pub global activate flutterfire_cli             │
│                                                          │
│  □ Run flutterfire configure in your project            │
│                                                          │
│  □ Add firebase_core to pubspec.yaml                    │
│                                                          │
│  □ Initialize in main.dart:                             │
│    await Firebase.initializeApp(                        │
│      options: DefaultFirebaseOptions.currentPlatform,   │
│    );                                                   │
│                                                          │
│  □ Run your app and verify connection                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In one line, what is Firebase?

<details>
<summary>Answer</summary>
A ready-made backend service from Google that gives your app login, a cloud database, file storage, and more, without building your own server.
</details>

**Q2.** Why use Firebase instead of building your own backend?

<details>
<summary>Answer</summary>
It saves huge time: you get auth, database, and storage that already work and scale, so you focus on your app.
</details>

**Q3.** What does "connecting" your app to Firebase mean at setup?

<details>
<summary>Answer</summary>
Creating a Firebase project and adding its config to your Flutter app (e.g. via FlutterFire/`firebase_options`) so the app knows which project to talk to.
</details>

---

## Assignment

### Problem 1: Pick the service

Which Firebase service fits each need?
1. Let users sign up and log in.
2. Store a collection of posts in the cloud.
3. Store uploaded profile photos.

### Problem 2: Why a backend?

In one sentence, what problem does Firebase solve for a solo developer?

### Problem 3: First step

What is the first thing you create before connecting your app?

---

## Assignment Answers

### Problem 1: Pick the service

1. **Firebase Authentication**.
2. **Cloud Firestore** (database).
3. **Firebase Storage** (files).

### Problem 2: Why a backend?

It gives you a working, scalable backend (auth, data, files) without building and maintaining your own server.

### Problem 3: First step

A Firebase project (in the Firebase console), which your app then connects to.

---

**Next:** `02-Authentication.md` - Adding user login and signup
