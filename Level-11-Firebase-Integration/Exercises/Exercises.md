# Level 11 Exercises: Firebase Integration

Welcome! These exercises break down Firebase into small, easy-to-learn steps. Complete each part bit-by-bit, and by the end, you'll be building real-time cloud-powered apps!

**How these exercises work:**
- Each PART focuses on ONE major Firebase skill
- Within each part, exercises build on each other step-by-step
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll have mastered Firebase!

---

## PART 1: Firebase Authentication Basics

Learn to sign up and log in users.

### Exercise 1.1: Sign Up with Email/Password

**Goal:** Create a new user account.

**Your Task:** Implement user registration.

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      // TODO: Use _auth.createUserWithEmailAndPassword
      // TODO: Return the user from userCredential.user
    } catch (e) {
      // TODO: Print error and return null
    }
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<User?> signUp(String email, String password) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Sign up error: $e');
    return null;
  }
}
```

**What it does:**
- Creates a new user with email and password
- Returns the User object if successful
- Returns null if there's an error
</details>

---

### Exercise 1.2: Sign In Existing User

**Goal:** Log in a user with their credentials.

**Your Task:** Implement user login.

```dart
class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      // TODO: Use _auth.signInWithEmailAndPassword
      // TODO: Return the user
    } catch (e) {
      // TODO: Handle error
    }
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<User?> signIn(String email, String password) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Sign in error: $e');
    return null;
  }
}
```
</details>

---

### Exercise 1.3: Get Current User

**Goal:** Check who is currently logged in.

**Your Task:** Get the current user.

```dart
class AuthService {
  final _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    // TODO: Return _auth.currentUser
  }

  bool isLoggedIn() {
    // TODO: Return true if currentUser is not null
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
User? getCurrentUser() {
  return _auth.currentUser;
}

bool isLoggedIn() {
  return _auth.currentUser != null;
}
```
</details>

---

### Exercise 1.4: Sign Out

**Goal:** Log out the current user.

**Your Task:** Implement sign out.

```dart
class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    // TODO: Call _auth.signOut()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> signOut() async {
  await _auth.signOut();
}
```
</details>

---

### Exercise 1.5: Auth State Stream

**Goal:** Listen to authentication state changes.

**Your Task:** Create a stream that notifies when user logs in/out.

```dart
class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    // TODO: Return _auth.authStateChanges()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Stream<User?> authStateChanges() {
  return _auth.authStateChanges();
}
```

**What it does:**
- Returns a stream that emits the current user
- Emits null when user signs out
- Emits User when user signs in
- Perfect for StreamBuilder navigation
</details>

---

### Exercise 1.6: Authentication Challenge

**Goal:** Build a complete auth system - NO scaffolding!

**Your Task:** Create sign up, sign in, and sign out screens.

**Requirements:**
1. Sign up screen with email/password fields
2. Sign in screen with email/password fields
3. Home screen showing user email with sign out button
4. Use StreamBuilder to automatically navigate based on auth state
5. Show error messages for invalid credentials
6. Validate email and password before submitting

Try building this completely on your own!

<details>
<summary>✅ Solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth Service
class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// Main App with StreamBuilder
class MyApp extends StatelessWidget {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return SignInScreen();
        },
      ),
    );
  }
}

// Sign In Screen
class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);

    final error = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sign Up Screen (similar structure)
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() => _isLoading = true);

    final error = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome!'),
            Text('Email: ${user?.email}'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _authService.signOut(),
              child: Text('Sign Out'),
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

## PART 2: Cloud Firestore Basics

Learn to store and retrieve data in the cloud.

### Exercise 2.1: Add a Document

**Goal:** Save data to Firestore.

**Your Task:** Add a note to the database.

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addNote(String title, String content) async {
    // TODO: Use _db.collection('notes').add()
    // TODO: Pass a map with title, content, and createdAt
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> addNote(String title, String content) async {
  await _db.collection('notes').add({
    'title': title,
    'content': content,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

**What it does:**
- Adds a new document to 'notes' collection
- Auto-generates a unique document ID
- Uses server timestamp for consistency
</details>

---

### Exercise 2.2: Get All Documents

**Goal:** Retrieve all notes from Firestore.

**Your Task:** Fetch all notes as a list.

```dart
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    // TODO: Get the 'notes' collection
    // TODO: Call .get() to fetch documents
    // TODO: Return list of document data maps
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<List<Map<String, dynamic>>> getAllNotes() async {
  final snapshot = await _db.collection('notes').get();
  return snapshot.docs.map((doc) => {
    'id': doc.id,
    ...doc.data(),
  }).toList();
}
```

**What it does:**
- Fetches all documents from 'notes' collection
- Converts each document to a map
- Includes the document ID
</details>

---

### Exercise 2.3: Real-time Stream

**Goal:** Listen to notes in real-time.

**Your Task:** Create a stream that updates when notes change.

```dart
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getNotesStream() {
    // TODO: Return _db.collection('notes').snapshots()
    // TODO: Map the snapshots to list of maps
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Stream<List<Map<String, dynamic>>> getNotesStream() {
  return _db.collection('notes').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  });
}
```

**What it does:**
- Returns a stream that emits whenever data changes
- Perfect for StreamBuilder
- Updates UI automatically
</details>

---

### Exercise 2.4: Update a Document

**Goal:** Modify an existing note.

**Your Task:** Update a note's title and content.

```dart
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> updateNote(String id, String title, String content) async {
    // TODO: Use _db.collection('notes').doc(id).update()
    // TODO: Pass map with title and content
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> updateNote(String id, String title, String content) async {
  await _db.collection('notes').doc(id).update({
    'title': title,
    'content': content,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
```
</details>

---

### Exercise 2.5: Delete a Document

**Goal:** Remove a note from Firestore.

**Your Task:** Delete a note by ID.

```dart
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> deleteNote(String id) async {
    // TODO: Use _db.collection('notes').doc(id).delete()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> deleteNote(String id) async {
  await _db.collection('notes').doc(id).delete();
}
```
</details>

---

### Exercise 2.6: Query with Filters

**Goal:** Get only specific documents.

**Your Task:** Get notes for a specific user.

```dart
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUserNotes(String userId) {
    // TODO: Use _db.collection('notes')
    // TODO: Add .where('userId', isEqualTo: userId)
    // TODO: Add .snapshots() and map to list
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Stream<List<Map<String, dynamic>>> getUserNotes(String userId) {
  return _db
      .collection('notes')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  });
}
```
</details>

---

### Exercise 2.7: Firestore CRUD Challenge

**Goal:** Build a complete notes app with Firestore - NO scaffolding!

**Your Task:** Create a real-time notes app with auth.

**Requirements:**
1. Users can only see their own notes
2. Add new note (title + content)
3. Edit existing note
4. Delete note
5. Notes update in real-time
6. Use StreamBuilder for the list
7. Store userId with each note

Try building this completely on your own!

<details>
<summary>✅ Solution - Key Components</summary>

```dart
// Firestore Service with User-specific queries
class NotesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getMyNotes() {
    return _db
        .collection('notes')
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    });
  }

  Future<void> addNote(String title, String content) async {
    await _db.collection('notes').add({
      'userId': _userId,
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _db.collection('notes').doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }
}

// Notes List Screen with StreamBuilder
class NotesListScreen extends StatelessWidget {
  final _notesService = NotesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesService.getMyNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return Center(child: Text('No notes yet. Add one!'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['content']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _notesService.deleteNote(note['id']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNoteScreen(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
      ),
    );
  }
}
```

**Key Features:**
- Real-time updates with StreamBuilder
- User-specific notes with where clause
- CRUD operations (Create, Read, Update, Delete)
- Clean separation of concerns
</details>

---

## PART 3: Firebase Storage

Learn to upload and download files.

### Exercise 3.1: Upload a File

**Goal:** Upload an image to Firebase Storage.

**Your Task:** Upload a file and get its URL.

```dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    // TODO: Create a reference: _storage.ref(path)
    // TODO: Upload the file: ref.putFile(file)
    // TODO: Get download URL: await ref.getDownloadURL()
    // TODO: Return the URL
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<String> uploadFile(File file, String path) async {
  final ref = _storage.ref(path);
  await ref.putFile(file);
  final url = await ref.getDownloadURL();
  return url;
}
```
</details>

---

### Exercise 3.2: Upload with Progress

**Goal:** Show upload progress to the user.

**Your Task:** Track upload progress percentage.

```dart
class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFileWithProgress(
    File file,
    String path,
    Function(double) onProgress,
  ) async {
    final ref = _storage.ref(path);
    final uploadTask = ref.putFile(file);

    // TODO: Listen to uploadTask.snapshotEvents
    // TODO: Calculate progress: bytesTransferred / totalBytes
    // TODO: Call onProgress with the percentage
    // TODO: Wait for task to complete
    // TODO: Return download URL
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<String> uploadFileWithProgress(
  File file,
  String path,
  Function(double) onProgress,
) async {
  final ref = _storage.ref(path);
  final uploadTask = ref.putFile(file);

  uploadTask.snapshotEvents.listen((snapshot) {
    final progress = snapshot.bytesTransferred / snapshot.totalBytes;
    onProgress(progress);
  });

  await uploadTask;
  final url = await ref.getDownloadURL();
  return url;
}
```
</details>

---

### Exercise 3.3: Delete a File

**Goal:** Remove a file from Storage.

**Your Task:** Delete a file by its path.

```dart
class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<void> deleteFile(String path) async {
    // TODO: Get reference and call delete()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> deleteFile(String path) async {
  final ref = _storage.ref(path);
  await ref.delete();
}
```
</details>

---

### Exercise 3.4: Storage Challenge - Profile Picture

**Goal:** Add profile picture upload - NO scaffolding!

**Your Task:** Let users upload and update their profile picture.

**Requirements:**
1. Pick image from gallery (use image_picker package)
2. Show upload progress
3. Upload to 'profile_pictures/{userId}.jpg'
4. Save URL to Firestore user document
5. Display the profile picture
6. Allow changing the picture

Try building this completely on your own!

<details>
<summary>✅ Solution - Key Components</summary>

```dart
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfileService {
  final _storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String?> uploadProfilePicture(File image) async {
    try {
      final userId = _auth.currentUser!.uid;
      final path = 'profile_pictures/$userId.jpg';
      final ref = _storage.ref(path);

      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      // Save URL to Firestore
      await _db.collection('users').doc(userId).update({
        'photoURL': url,
      });

      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = ProfileService();
  final _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    final url = await _profileService.uploadProfilePicture(
      File(pickedFile.path),
    );

    setState(() => _isUploading = false);

    if (url != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final photoURL = data?['photoURL'] as String?;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: photoURL != null
                      ? NetworkImage(photoURL)
                      : null,
                  child: photoURL == null ? Icon(Icons.person, size: 60) : null,
                ),
                SizedBox(height: 24),
                _isUploading
                    ? CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: Icon(Icons.camera_alt),
                        label: Text('Change Picture'),
                        onPressed: _pickAndUploadImage,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```
</details>

---

## FINAL PROJECT: Social Feed App

**Goal:** Combine ALL Firebase skills - Auth + Firestore + Storage!

**Your Task:** Build a complete social feed app with NO help!

### Requirements:

**Authentication:**
- Sign up / Sign in / Sign out
- User profiles with display name and photo

**Posts:**
- Create posts with text and optional image
- View feed of all posts (newest first)
- Like posts (toggle like/unlike)
- Delete own posts
- Show author name and photo with each post

**Data Structure:**
```
users/{userId}
├── name: "John Doe"
├── email: "john@example.com"
├── photoURL: "https://..."
└── createdAt: Timestamp

posts/{postId}
├── userId: "user123"
├── userName: "John Doe"
├── userPhoto: "https://..."
├── text: "My first post!"
├── imageUrl: "https://..." (optional)
├── likes: ["user1", "user2"]  // Array of user IDs
└── createdAt: Timestamp

Storage:
├── profile_pictures/{userId}.jpg
└── post_images/{postId}_{timestamp}.jpg
```

**Features:**
1. User registration with name and email
2. Optional profile picture upload
3. Create text post
4. Create post with image
5. Feed showing all posts in real-time
6. Like/unlike posts
7. Delete own posts (with confirmation)
8. Show like count
9. Display post images
10. Show timestamps (e.g., "2 hours ago")

**Bonus Features:**
- Pull-to-refresh
- Image compression before upload
- Paginated feed (load 20 posts at a time)
- User profile page showing their posts
- Edit post text
- Comments on posts

### Build this completely on your own using everything you learned!

---

## Submission Checklist

Before moving to the next level:

- [ ] Completed all PART 1 exercises (Firebase Auth)
- [ ] Completed all PART 2 exercises (Cloud Firestore)
- [ ] Completed all PART 3 exercises (Firebase Storage)
- [ ] Completed the Final Project
- [ ] Auth works properly (sign up, sign in, sign out)
- [ ] Real-time updates work in Firestore
- [ ] File uploads complete successfully
- [ ] Security rules protect user data
- [ ] Error handling is implemented
- [ ] Loading states are shown

---

## Need Help?

Review the theory files:
- [01-FirebaseSetup.md](../Theory/01-FirebaseSetup.md)
- [02-Authentication.md](../Theory/02-Authentication.md)
- [03-CloudFirestore.md](../Theory/03-CloudFirestore.md)
- [04-FirebaseStorage.md](../Theory/04-FirebaseStorage.md)

Study the examples in the Examples folder!

---

**You're building real cloud-powered apps now! Keep going!** 🔥
