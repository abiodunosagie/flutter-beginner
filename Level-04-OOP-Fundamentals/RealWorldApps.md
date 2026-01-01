# Level 4: Real-World Apps Using These Concepts

See how Object-Oriented Programming structures real applications!

---

## Classes & Objects

### Everything is an Object!

**Instagram Post**
```dart
class Post {
  final String imageUrl;
  final String caption;
  final User author;
  final DateTime timestamp;
  int likeCount;
  List<Comment> comments;

  void like() {
    likeCount++;
    notifyAuthor();
  }
}
```

**Uber Ride**
```dart
class Ride {
  final User passenger;
  final Driver driver;
  final Location pickup;
  final Location destination;
  double fare;
  RideStatus status;

  void startRide() {
    status = RideStatus.inProgress;
    notifyPassenger();
  }
}
```

**Spotify Song**
```dart
class Song {
  final String title;
  final Artist artist;
  final Album album;
  final Duration length;
  int playCount;

  void play() {
    playCount++;
    updateRecommendations();
  }
}
```

---

## Encapsulation

### Protecting Data!

**Banking App**
```dart
class BankAccount {
  final String accountNumber;
  double _balance;  // Private!

  double get balance => _balance;  // Can read

  // Can't set directly - must use methods
  bool withdraw(double amount) {
    if (amount > _balance) return false;
    _balance -= amount;
    logTransaction();
    return true;
  }

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      logTransaction();
    }
  }
}
```

**User Session**
```dart
class UserSession {
  String _authToken;  // Never expose directly!
  DateTime _expiresAt;

  bool get isValid => DateTime.now().isBefore(_expiresAt);

  String get token {
    if (!isValid) throw SessionExpiredException();
    return _authToken;
  }
}
```

---

## Inheritance

### Building on Existing Code!

**Social Media Posts**
```dart
abstract class Post {
  final User author;
  final DateTime createdAt;
  int likeCount;

  void like();
  void share();
}

class PhotoPost extends Post {
  final String imageUrl;
  final List<String> filters;

  void applyFilter(String filter) { ... }
}

class VideoPost extends Post {
  final String videoUrl;
  final Duration length;

  void play() { ... }
  void pause() { ... }
}

class StoryPost extends Post {
  final DateTime expiresAt;
  final List<Sticker> stickers;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
```

**Notification System**
```dart
abstract class Notification {
  final String title;
  final DateTime timestamp;

  void show();
}

class PushNotification extends Notification {
  void show() => displayOnDevice();
}

class EmailNotification extends Notification {
  void show() => sendEmail();
}

class InAppNotification extends Notification {
  void show() => displayBanner();
}
```

---

## Polymorphism

### Same Interface, Different Behaviors!

**Payment Processing**
```dart
abstract class PaymentMethod {
  Future<bool> processPayment(double amount);
}

class CreditCard implements PaymentMethod {
  Future<bool> processPayment(double amount) async {
    return await chargeCard(amount);
  }
}

class PayPal implements PaymentMethod {
  Future<bool> processPayment(double amount) async {
    return await processPayPalPayment(amount);
  }
}

class ApplePay implements PaymentMethod {
  Future<bool> processPayment(double amount) async {
    return await processApplePay(amount);
  }
}

// Works with ANY payment method!
void checkout(PaymentMethod method, double total) {
  method.processPayment(total);
}
```

---

## Abstract Classes & Interfaces

### Defining Contracts!

**Data Storage**
```dart
abstract class Storage {
  Future<void> save(String key, dynamic value);
  Future<dynamic> load(String key);
  Future<void> delete(String key);
}

class LocalStorage implements Storage { ... }
class CloudStorage implements Storage { ... }
class SecureStorage implements Storage { ... }

// App can swap storage without changing code!
```

**Authentication**
```dart
abstract class AuthProvider {
  Future<User?> signIn();
  Future<void> signOut();
  bool get isSignedIn;
}

class GoogleAuth implements AuthProvider { ... }
class FacebookAuth implements AuthProvider { ... }
class AppleAuth implements AuthProvider { ... }
class EmailAuth implements AuthProvider { ... }
```

---

## Mixins

### Adding Capabilities!

**Flutter Widgets**
```dart
mixin Scrollable {
  void scroll(double offset) { ... }
}

mixin Zoomable {
  void zoom(double scale) { ... }
}

mixin Draggable {
  void drag(Offset offset) { ... }
}

class PhotoViewer extends StatefulWidget with Scrollable, Zoomable { ... }
class MapView extends StatefulWidget with Scrollable, Zoomable, Draggable { ... }
```

---

## Real Apps Using These Patterns

| Pattern | Used In |
|---------|---------|
| **Classes** | Every app - users, products, messages |
| **Encapsulation** | Banking, health apps, security |
| **Inheritance** | Social media posts, notifications |
| **Polymorphism** | Payment systems, auth providers |
| **Mixins** | Flutter UI components |

---

## Factory Pattern in Real Apps

**Logging System**
```dart
class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;  // Always same instance
  Logger._internal();

  void log(String message) { ... }
}

// Used everywhere in the app
Logger().log('User signed in');
Logger().log('Purchase completed');
```

---

## Build It Yourself!

After this level, you could build:

1. **User Management System** - Classes for different user types
2. **Media Player** - Inheritance for different media types
3. **Payment Processor** - Polymorphic payment methods
4. **Logger Service** - Singleton pattern
5. **Shape Calculator** - Abstract classes for shapes

---

**OOP is how professional apps organize their code - learn it well!**
