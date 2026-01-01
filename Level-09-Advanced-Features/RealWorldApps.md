# Level 9: Real-World Apps Using These Concepts

See how advanced features power production-ready applications!

---

## Local Storage (SharedPreferences)

### Remembering User Preferences!

**Any App with Settings**
```dart
class SettingsService {
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
  }

  Future<void> saveLanguage(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale);
  }

  Future<void> saveNotificationPreferences(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
  }
}
```

**Onboarding Flow**
```dart
class OnboardingService {
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_onboarding') ?? false;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
  }
}

// In app startup
if (!await onboardingService.hasSeenOnboarding()) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
}
```

---

## SQLite Database

### Storing Complex Data Offline!

**Notes App (Evernote-style)**
```dart
class NotesDatabase {
  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'updated_at DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
```

**Offline-First Chat App**
```dart
class MessageDatabase {
  Future<void> saveMessage(Message message) async {
    await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getConversation(String contactId) async {
    return await db.query(
      'messages',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> markAsRead(String conversationId) async {
    await db.update(
      'messages',
      {'is_read': 1},
      where: 'contact_id = ? AND is_read = 0',
      whereArgs: [conversationId],
    );
  }
}
```

---

## Secure Storage

### Protecting Sensitive Data!

**Banking/Finance Apps**
```dart
class SecureStorageService {
  final _storage = FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> saveBiometricKey(String key) async {
    await _storage.write(key: 'biometric_key', value: key);
  }

  Future<void> savePin(String pin) async {
    final hashedPin = hashPin(pin);  // Never store plain text!
    await _storage.write(key: 'user_pin', value: hashedPin);
  }

  Future<bool> verifyPin(String enteredPin) async {
    final storedHash = await _storage.read(key: 'user_pin');
    return hashPin(enteredPin) == storedHash;
  }
}
```

---

## Streams

### Real-Time Data!

**Chat App (WhatsApp-style)**
```dart
class ChatService {
  final _messagesController = StreamController<List<Message>>.broadcast();

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  void listenToMessages(String conversationId) {
    firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList();
      _messagesController.add(messages);
    });
  }
}

// In UI
StreamBuilder<List<Message>>(
  stream: chatService.messagesStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return LoadingIndicator();
    return MessageList(messages: snapshot.data!);
  },
)
```

**Stock Price Ticker**
```dart
class StockService {
  Stream<StockPrice> watchStock(String symbol) async* {
    while (true) {
      final price = await fetchCurrentPrice(symbol);
      yield price;
      await Future.delayed(Duration(seconds: 5));
    }
  }
}
```

---

## Background Tasks

### Working When App is Closed!

**Download Manager**
```dart
class DownloadService {
  Future<void> downloadFile(String url, String filename) async {
    await Workmanager().registerOneOffTask(
      'download_$filename',
      'downloadTask',
      inputData: {'url': url, 'filename': filename},
    );
  }
}

// In background handler
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final url = inputData!['url'];
    final filename = inputData['filename'];
    await downloadFile(url, filename);
    showNotification('Download complete: $filename');
    return true;
  });
}
```

**Data Sync**
```dart
// Sync data every 15 minutes
Workmanager().registerPeriodicTask(
  'sync_data',
  'syncTask',
  frequency: Duration(minutes: 15),
);
```

---

## Local Notifications

### Alerting Users!

**Reminder Apps**
```dart
class NotificationService {
  Future<void> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showInstantNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
```

---

## Permissions

### Asking Users for Access!

**Camera App**
```dart
class PermissionService {
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isPermanentlyDenied) {
      // Show dialog to open settings
      await openAppSettings();
    }
    return status.isGranted;
  }

  Future<bool> requestMultiplePermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
}
```

---

## Real Apps Using These Features

| Feature | Apps Using It |
|---------|--------------|
| **SharedPreferences** | Settings in every app |
| **SQLite** | Notes apps, offline-first apps |
| **Secure Storage** | Banking, password managers |
| **Streams** | Chat apps, live sports, stocks |
| **Background Tasks** | Music players, downloads |
| **Notifications** | All messaging apps, reminders |

---

## Connectivity Handling

### Dealing with Network Changes!

**Offline-Aware App**
```dart
class ConnectivityService {
  Stream<bool> get connectivityStream =>
      Connectivity().onConnectivityChanged.map(
        (result) => result != ConnectivityResult.none,
      );

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

// In app
StreamBuilder<bool>(
  stream: connectivityService.connectivityStream,
  builder: (context, snapshot) {
    if (snapshot.data == false) {
      return OfflineBanner();
    }
    return SizedBox.shrink();
  },
)
```

---

## Build It Yourself!

After this level, you could build:

1. **Notes App** - SQLite for local storage
2. **Settings Screen** - SharedPreferences for options
3. **Password Manager** - Secure storage
4. **Real-time Chat** - Streams for messages
5. **Reminder App** - Local notifications

---

**Advanced features make your app production-ready - users expect them!**
