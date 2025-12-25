# Level 12 Exercises: Platform Features

## Exercise 1: Profile Photo App

**Objective:** Build a profile screen with photo upload functionality.

```
FEATURES:
□ Display circular profile picture
□ Tap to change (camera or gallery)
□ Crop/resize image before saving
□ Show placeholder when no photo
□ Save photo path locally
```

### Requirements
- Use `image_picker` package
- Compress images (max 512x512)
- Store image path in SharedPreferences
- Show loading indicator during selection

---

## Exercise 2: Location Check-In App

**Objective:** Build an app that records location check-ins.

```
FEATURES:
□ Get current location
□ Reverse geocode to address
□ Save check-in with timestamp
□ Display list of check-ins
□ Calculate distance from each check-in
```

### Data Structure

```dart
class CheckIn {
  final String id;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime timestamp;
}
```

### Requirements
- Request location permission properly
- Handle permission denial gracefully
- Store check-ins locally (SQLite or SharedPreferences)
- Show relative time (e.g., "2 hours ago")

---

## Exercise 3: Reminder App with Notifications

**Objective:** Build a reminder app with scheduled notifications.

```
FEATURES:
□ Add reminders with title and time
□ Schedule notification for each reminder
□ Edit and delete reminders
□ Cancel notification when reminder deleted
□ Show list of pending reminders
```

### Requirements
- Use `flutter_local_notifications`
- Handle timezone properly
- Request notification permission (Android 13+)
- Notifications should work when app is closed

---

## Exercise 4: Contact Actions App

**Objective:** Build a contact card with action buttons.

```
FEATURES:
□ Display contact info (name, phone, email)
□ Call button - make phone call
□ SMS button - send text message
□ Email button - compose email
□ Map button - open address in maps
□ Website button - open URL
```

### Requirements
- Use `url_launcher` for all actions
- Handle "cannot launch" errors
- Show confirmation before calling
- Pre-fill email subject and body

---

## Exercise 5: Connectivity-Aware App

**Objective:** Build an app that adapts to network status.

```
FEATURES:
□ Show current connection type (WiFi/Mobile/None)
□ Display banner when offline
□ Queue actions when offline
□ Sync when back online
□ Show appropriate UI for each state
```

### Requirements
- Use `connectivity_plus`
- Listen to connectivity changes
- Cache data for offline use
- Show sync status

---

## Exercise 6: Permission Manager App

**Objective:** Build an app that manages multiple permissions.

```
FEATURES:
□ Show list of permissions (camera, location, etc.)
□ Display status for each
□ Request button for denied permissions
□ Open settings for permanently denied
□ Check all permissions at once
```

### Permissions to Handle
- Camera
- Location
- Notifications
- Microphone
- Photo Library

---

## Exercise 7: Document Scanner

**Objective:** Build a simple document scanning app.

```
FEATURES:
□ Take photo with camera
□ Use high quality settings
□ Save to app directory
□ View saved documents
□ Share documents
```

### Requirements
- Use camera with max quality
- Save with meaningful filenames
- Display documents in grid
- Use share functionality

---

## Exercise 8: Complete Platform App

**Objective:** Build an app combining multiple platform features.

### App: Field Service App

A technician uses this app to:
1. Check in at job sites (location)
2. Take before/after photos (camera)
3. Get notifications for new jobs (notifications)
4. Call/email customers (url_launcher)
5. Work offline and sync later (connectivity)

```
SCREENS:
├── Home - Today's jobs list
├── Job Detail - Customer info + actions
├── Check-In - Location + photo
└── History - Past check-ins
```

### Data Structure

```dart
class Job {
  final String id;
  final String customerName;
  final String address;
  final String phone;
  final String email;
  final String status; // pending, in-progress, completed
}

class JobCheckIn {
  final String jobId;
  final Position location;
  final String? beforePhoto;
  final String? afterPhoto;
  final DateTime timestamp;
  final String notes;
}
```

### Grading Criteria

```
BASIC (60%):
□ List jobs
□ View job details
□ Call/email customer
□ Take photos

GOOD (80%):
□ All basic features
□ Location check-in
□ Offline support
□ Notifications

EXCELLENT (100%):
□ All features working
□ Before/after photos
□ Job history
□ Sync when online
□ Polished UI
```

---

## Tips for Platform Features

```
1. ALWAYS CHECK PERMISSIONS FIRST
   Don't assume you have access.

2. HANDLE ERRORS GRACEFULLY
   Camera not available? Permission denied?
   Show helpful messages.

3. TEST ON REAL DEVICES
   Simulators don't have real cameras/GPS.

4. RESPECT USER PRIVACY
   Only request permissions when needed.
   Explain why you need them.

5. TEST OFFLINE SCENARIOS
   Turn on airplane mode.
   Does your app still work?
```

---

## Resources

- [image_picker](https://pub.dev/packages/image_picker)
- [geolocator](https://pub.dev/packages/geolocator)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [connectivity_plus](https://pub.dev/packages/connectivity_plus)
- [permission_handler](https://pub.dev/packages/permission_handler)

Good luck! 📱
