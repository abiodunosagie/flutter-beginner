# Level 11 Capstone: Firebase Backend

## What You're Building

In this level, you'll add **Firebase** to ShopEase for real authentication, database, and storage!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 11 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Before (FakeStore API):                                    │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Fake login (no real auth)                        │   │
│   │  • Static product data                              │   │
│   │  • Orders not saved                                 │   │
│   │  • No user data persistence                         │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   After (Firebase):                                          │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   ┌───────────────┐   ┌───────────────┐            │   │
│   │   │  Firebase     │   │   Firestore   │            │   │
│   │   │  Auth         │   │   Database    │            │   │
│   │   │  • Email/Pass │   │  • Users      │            │   │
│   │   │  • Google     │   │  • Orders     │            │   │
│   │   │  • Apple      │   │  • Products   │            │   │
│   │   └───────────────┘   └───────────────┘            │   │
│   │                                                     │   │
│   │   ┌───────────────┐   ┌───────────────┐            │   │
│   │   │  Cloud        │   │   Cloud       │            │   │
│   │   │  Storage      │   │   Functions   │            │   │
│   │   │  • Images     │   │  • Payments   │            │   │
│   │   │  • Receipts   │   │  • Emails     │            │   │
│   │   └───────────────┘   └───────────────┘            │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Firebase Setup

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure

# Add dependencies
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage
```

### Task 2: Firebase Auth Service

```dart
// lib/services/auth_service.dart

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(displayName);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw AuthException('Sign in cancelled');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException('This email is already registered');
      case 'invalid-email':
        return AuthException('Invalid email address');
      case 'weak-password':
        return AuthException('Password is too weak');
      case 'user-not-found':
        return AuthException('No account found with this email');
      case 'wrong-password':
        return AuthException('Incorrect password');
      default:
        return AuthException('Authentication failed');
    }
  }
}
```

### Task 3: Firestore Database Service

```dart
// lib/services/database_service.dart

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User profile
  Future<void> createUserProfile(User user) async {
    await _db.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'addresses': [],
      'wishlist': [],
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Orders
  Future<String> createOrder({
    required String userId,
    required List<CartItem> items,
    required Address shippingAddress,
    required String paymentMethod,
    required double total,
  }) async {
    final orderRef = await _db.collection('orders').add({
      'userId': userId,
      'items': items.map((i) => i.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'subtotal': items.fold(0.0, (sum, i) => sum + i.totalPrice),
      'tax': total * 0.08,
      'total': total,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return orderRef.id;
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Order.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  // Wishlist
  Future<void> addToWishlist(String userId, String productId) async {
    await _db.collection('users').doc(userId).update({
      'wishlist': FieldValue.arrayUnion([productId]),
    });
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _db.collection('users').doc(userId).update({
      'wishlist': FieldValue.arrayRemove([productId]),
    });
  }
}
```

### Task 4: Update UserProvider with Firebase

```dart
// lib/providers/user_provider.dart

class UserProvider extends ChangeNotifier {
  final AuthService _authService;
  final DatabaseService _databaseService;

  User? _user;
  Map<String, dynamic>? _profile;
  bool _isLoading = false;
  String? _error;

  UserProvider({
    AuthService? authService,
    DatabaseService? databaseService,
  })  : _authService = authService ?? AuthService(),
        _databaseService = databaseService ?? DatabaseService() {
    // Listen to auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get user => _user;
  Map<String, dynamic>? get profile => _profile;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      _profile = await _databaseService.getUserProfile(user.uid);
    } else {
      _profile = null;
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: name,
      );

      await _databaseService.createUserProfile(credential.user!);
    } on AuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();

      // Create profile if first time
      final profile = await _databaseService.getUserProfile(credential.user!.uid);
      if (profile == null) {
        await _databaseService.createUserProfile(credential.user!);
      }
    } on AuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
```

### Task 5: Firestore Security Rules

```javascript
// firestore.rules

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Users can only read/write their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null &&
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null &&
        request.resource.data.userId == request.auth.uid;
      allow update: if false; // Orders can't be edited
    }

    // Products are public read-only
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Admin only (via console)
    }
  }
}
```

---

## Firestore Data Structure

```
firestore/
├── users/
│   └── {userId}/
│       ├── email: "user@example.com"
│       ├── displayName: "John Doe"
│       ├── createdAt: Timestamp
│       ├── addresses: [...]
│       └── wishlist: ["prod_1", "prod_2"]
│
├── orders/
│   └── {orderId}/
│       ├── userId: "abc123"
│       ├── items: [...]
│       ├── shippingAddress: {...}
│       ├── paymentMethod: "card"
│       ├── subtotal: 99.99
│       ├── tax: 8.00
│       ├── total: 107.99
│       ├── status: "pending"
│       └── createdAt: Timestamp
│
└── products/
    └── {productId}/
        ├── name: "T-Shirt"
        ├── price: 29.99
        ├── description: "..."
        ├── imageUrl: "..."
        ├── category: "clothing"
        └── rating: {rate: 4.5, count: 120}
```

---

## Success Criteria

- [ ] Firebase project created and configured
- [ ] Email/password authentication works
- [ ] Google sign-in works
- [ ] User profile saved to Firestore
- [ ] Orders saved to Firestore
- [ ] Order history loads from Firestore
- [ ] Wishlist syncs across devices
- [ ] Security rules protect user data
- [ ] Sign out clears session

---

## Files to Create/Update

```
shopease/
└── lib/
    ├── services/
    │   ├── auth_service.dart      ◄── Create
    │   └── database_service.dart  ◄── Create
    │
    ├── providers/
    │   └── user_provider.dart     ◄── Update
    │
    └── firebase_options.dart      ◄── Generated
```

---

**Your ShopEase app now has a real backend!**
