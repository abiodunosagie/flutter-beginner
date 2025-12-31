# Level 12 Exercises: Platform Features

Welcome! These exercises teach you how to access device features like camera, location, and notifications. Each part builds your skills step-by-step!

**How these exercises work:**
- Each PART focuses on ONE platform feature
- Within each part, exercises build on each other step-by-step
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll create apps that feel truly native!

---

## PART 1: Image Picker & Camera

Learn to access device camera and photo gallery.

### Exercise 1.1: Pick Image from Gallery

**Goal:** Let users select an image from their photo gallery.

**Your Task:** Implement image picking from gallery.

```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  final _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    // TODO: Use _picker.pickImage with source: ImageSource.gallery
    // TODO: If pickedFile is not null, return File(pickedFile.path)
    // TODO: Return null if no image was picked
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<File?> pickImageFromGallery() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
```
</details>

---

### Exercise 1.2: Take Photo with Camera

**Goal:** Let users take a photo with the device camera.

**Your Task:** Implement camera photo capture.

```dart
class ImagePickerService {
  final _picker = ImagePicker();

  Future<File?> takePhoto() async {
    // TODO: Use _picker.pickImage with source: ImageSource.camera
    // TODO: Return File or null
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<File?> takePhoto() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
```
</details>

---

### Exercise 1.3: Choose Source with Dialog

**Goal:** Let users choose between camera and gallery.

**Your Task:** Show a dialog to select image source.

```dart
Future<File?> pickImageWithChoice(BuildContext context) async {
  // TODO: Show dialog with "Camera" and "Gallery" options
  // TODO: Call takePhoto() if camera chosen
  // TODO: Call pickImageFromGallery() if gallery chosen
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<File?> pickImageWithChoice(BuildContext context) async {
  final source = await showDialog<ImageSource>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Choose Image Source'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ImageSource.camera),
          child: Text('Camera'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
          child: Text('Gallery'),
        ),
      ],
    ),
  );

  if (source == null) return null;

  final pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
```
</details>

---

### Exercise 1.4: Profile Picture Challenge

**Goal:** Build a complete profile picture feature - NO scaffolding!

**Requirements:**
1. Display circular profile picture
2. Show placeholder icon when no photo
3. Tap to choose camera or gallery
4. Save image path to SharedPreferences
5. Load saved image on app start

Try building this on your own!

<details>
<summary>✅ Solution</summary>

```dart
class ProfilePictureScreen extends StatefulWidget {
  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_picture');
    if (path != null && await File(path).exists()) {
      setState(() => _imageFile = File(path));
    }
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Gallery'),
          ),
        ],
      ),
    );

    if (source == null) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_picture', pickedFile.path);
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Picture')),
      body: Center(
        child: GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? Icon(Icons.person, size: 80)
                : null,
          ),
        ),
      ),
    );
  }
}
```
</details>

---

## PART 2: Location Services

Learn to access device location.

### Exercise 2.1: Get Current Location

**Goal:** Get the device's current GPS coordinates.

**Your Task:** Implement location fetching.

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    // TODO: Check if location services are enabled
    // TODO: If not, return null
    // TODO: Request permission if needed
    // TODO: Return Geolocator.getCurrentPosition()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<Position?> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  return await Geolocator.getCurrentPosition();
}
```
</details>

---

### Exercise 2.2: Display Location on Screen

**Goal:** Show latitude and longitude to the user.

**Your Task:** Create a screen that displays current location.

```dart
class LocationScreen extends StatefulWidget {
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _position;
  bool _isLoading = false;

  Future<void> _getLocation() async {
    // TODO: Set _isLoading to true
    // TODO: Get location using LocationService
    // TODO: Update _position and set _isLoading to false
    // TODO: Call setState
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Show loading indicator when _isLoading is true
    // TODO: Show latitude and longitude when _position is not null
    // TODO: Show "Get Location" button
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
class _LocationScreenState extends State<LocationScreen> {
  Position? _position;
  bool _isLoading = false;
  final _locationService = LocationService();

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);
    final position = await _locationService.getCurrentLocation();
    setState(() {
      _position = position;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_position != null) ...[
                    Text('Latitude: ${_position!.latitude}'),
                    Text('Longitude: ${_position!.longitude}'),
                    SizedBox(height: 20),
                  ],
                  ElevatedButton(
                    onPressed: _getLocation,
                    child: Text('Get Location'),
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

### Exercise 2.3: Location Check-In Challenge

**Goal:** Build a location check-in app - NO scaffolding!

**Requirements:**
1. Get current location on button press
2. Save check-in with timestamp to SQLite
3. Display list of past check-ins
4. Show latitude, longitude, and time for each
5. Handle permission denial gracefully

Try building this on your own!

---

## PART 3: Local Notifications

Learn to schedule notifications.

### Exercise 3.1: Show Simple Notification

**Goal:** Display a basic notification.

**Your Task:** Show a notification immediately.

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    // TODO: Create AndroidNotificationDetails
    // TODO: Create DarwinNotificationDetails
    // TODO: Create NotificationDetails with both
    // TODO: Call _notifications.show()
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> showNotification(String title, String body) async {
  const android = AndroidNotificationDetails(
    'default_channel',
    'Default',
    importance: Importance.high,
    priority: Priority.high,
  );
  const ios = DarwinNotificationDetails();
  const details = NotificationDetails(android: android, iOS: ios);

  await _notifications.show(
    0, // notification id
    title,
    body,
    details,
  );
}
```
</details>

---

### Exercise 3.2: Schedule Notification

**Goal:** Schedule a notification for a future time.

**Your Task:** Schedule a notification.

```dart
Future<void> scheduleNotification(
  int id,
  String title,
  String body,
  DateTime scheduledTime,
) async {
  // TODO: Use _notifications.zonedSchedule()
  // TODO: Convert DateTime to TZDateTime
}
```

<details>
<summary>✅ Solution</summary>

```dart
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification(
  int id,
  String title,
  String body,
  DateTime scheduledTime,
) async {
  const android = AndroidNotificationDetails(
    'reminders',
    'Reminders',
    importance: Importance.high,
  );
  const ios = DarwinNotificationDetails();
  const details = NotificationDetails(android: android, iOS: ios);

  await _notifications.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```
</details>

---

### Exercise 3.3: Reminder App Challenge

**Goal:** Build a complete reminder app - NO scaffolding!

**Requirements:**
1. Add reminders with title and time
2. Schedule notification for each reminder
3. List all pending reminders
4. Delete reminder (and cancel notification)
5. Show notification at scheduled time

Try building this on your own!

---

## PART 4: URL Launcher

Learn to open external apps and URLs.

### Exercise 4.1: Make Phone Call

**Goal:** Open phone dialer with number.

**Your Task:** Launch phone call.

```dart
import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  Future<void> makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    // TODO: Check if can launch using canLaunchUrl()
    // TODO: If yes, call launchUrl()
    // TODO: If no, throw error
  }
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> makePhoneCall(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch phone call';
  }
}
```
</details>

---

### Exercise 4.2: Send Email

**Goal:** Open email app with pre-filled content.

**Your Task:** Launch email composer.

```dart
Future<void> sendEmail(String email, String subject, String body) async {
  // TODO: Create mailto URI with email, subject, and body
  // TODO: Launch it
}
```

<details>
<summary>✅ Solution</summary>

```dart
Future<void> sendEmail(String email, String subject, String body) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=$subject&body=$body',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch email';
  }
}
```
</details>

---

### Exercise 4.3: Contact Card Challenge

**Goal:** Build a contact card with action buttons - NO scaffolding!

**Requirements:**
1. Display contact name, phone, email
2. Call button (opens phone dialer)
3. SMS button (opens messages)
4. Email button (opens email app)
5. Handle errors gracefully

Try building this on your own!

---

## FINAL PROJECT: Field Service App

**Goal:** Combine ALL platform features!

**Your Task:** Build a field technician app with NO help!

### Requirements:

**Features:**
1. Job list screen showing today's jobs
2. Job detail with customer contact info
3. Call/email customer buttons
4. Check-in button (gets location + takes photo)
5. Before/after photos for each job
6. Notification when new job assigned
7. Offline support (queue actions)

**Data Structure:**
```dart
class Job {
  final String id;
  final String customerName;
  final String phone;
  final String email;
  final String address;
  final String status; // pending, in-progress, completed
}

class CheckIn {
  final String jobId;
  final double latitude;
  final double longitude;
  final String? beforePhoto;
  final String? afterPhoto;
  final DateTime timestamp;
}
```

**Platform Features to Use:**
- Image Picker (before/after photos)
- Location (check-in location)
- Notifications (new job alerts)
- URL Launcher (call/email customer)
- Local Storage (SQLite for jobs and check-ins)

### Build this completely on your own using everything you learned!

---

## Submission Checklist

Before moving to the next level:

- [ ] Completed all PART 1 exercises (Image Picker)
- [ ] Completed all PART 2 exercises (Location)
- [ ] Completed all PART 3 exercises (Notifications)
- [ ] Completed all PART 4 exercises (URL Launcher)
- [ ] Completed the Final Project
- [ ] Permissions are requested properly
- [ ] Errors are handled gracefully
- [ ] App works on real devices
- [ ] Features work when app is in background

---

## Need Help?

Review the theory files and examples in the theory/examples folders!

---

**You're building apps that feel truly native now!** 📱
