# Level 12 Capstone: Platform Features

## What You're Building

In this level, you'll add **native platform features** to ShopEase - camera for reviews, notifications, and payments!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 12 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Native Platform Features                                   │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                     │   │
│   │   ┌─────────────┐    ┌─────────────┐               │   │
│   │   │   📷        │    │   🔔        │               │   │
│   │   │   Camera    │    │   Push      │               │   │
│   │   │             │    │   Notifs    │               │   │
│   │   │ Photo       │    │             │               │   │
│   │   │ Reviews     │    │ Order       │               │   │
│   │   │             │    │ Updates     │               │   │
│   │   └─────────────┘    └─────────────┘               │   │
│   │                                                     │   │
│   │   ┌─────────────┐    ┌─────────────┐               │   │
│   │   │   💳        │    │   📍        │               │   │
│   │   │   Payments  │    │   Location  │               │   │
│   │   │             │    │             │               │   │
│   │   │ Stripe      │    │ Store       │               │   │
│   │   │ Apple Pay   │    │ Finder      │               │   │
│   │   │             │    │             │               │   │
│   │   └─────────────┘    └─────────────┘               │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Camera for Product Reviews

```dart
// lib/services/camera_service.dart

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Pick image from camera
  Future<XFile?> takePhoto() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
  }

  // Pick image from gallery
  Future<XFile?> pickFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
  }

  // Pick multiple images
  Future<List<XFile>> pickMultiple() async {
    return await _picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
  }

  // Upload to Firebase Storage
  Future<String> uploadReviewImage({
    required XFile image,
    required String productId,
    required String userId,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('reviews/$productId/$userId/$fileName');

    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }
}

// lib/screens/reviews/add_review_screen.dart

class AddReviewScreen extends StatefulWidget {
  final Product product;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _cameraService = CameraService();
  final List<XFile> _images = [];
  double _rating = 5.0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return;

    final image = source == ImageSource.camera
        ? await _cameraService.takePhoto()
        : await _cameraService.pickFromGallery();

    if (image != null) {
      setState(() => _images.add(image));
    }
  }

  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);

    try {
      // Upload images
      final imageUrls = <String>[];
      for (final image in _images) {
        final url = await _cameraService.uploadReviewImage(
          image: image,
          productId: widget.product.id.toString(),
          userId: context.read<UserProvider>().user!.uid,
        );
        imageUrls.add(url);
      }

      // Save review to Firestore
      await FirebaseFirestore.instance.collection('reviews').add({
        'productId': widget.product.id,
        'userId': context.read<UserProvider>().user!.uid,
        'rating': _rating,
        'text': _reviewController.text,
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info
            Text(widget.product.name, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 24),

            // Rating
            const Text('Your Rating'),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (value) => setState(() => _rating = value),
            ),

            const SizedBox(height: 16),

            // Review text
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                hintText: 'Tell others what you think...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Photos
            const Text('Add Photos'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.map((image) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => _images.remove(image)),
                      ),
                    ),
                  ],
                )),
                if (_images.length < 5)
                  InkWell(
                    onTap: _addPhoto,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Task 2: Push Notifications

```dart
// lib/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Get FCM token for this device
    final token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification when app is open
    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'shopease_channel',
          'ShopEase Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate to relevant screen based on message data
    final orderId = message.data['orderId'];
    if (orderId != null) {
      // Navigate to order detail
    }
  }

  // Subscribe to order updates
  Future<void> subscribeToOrderUpdates(String orderId) async {
    await _messaging.subscribeToTopic('order_$orderId');
  }

  // Unsubscribe from order updates
  Future<void> unsubscribeFromOrderUpdates(String orderId) async {
    await _messaging.unsubscribeFromTopic('order_$orderId');
  }
}
```

### Task 3: Payment Integration

```dart
// lib/services/payment_service.dart

import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  Future<void> initialize() async {
    Stripe.publishableKey = 'pk_test_your_key_here';
    await Stripe.instance.applySettings();
  }

  Future<bool> processPayment({
    required double amount,
    required String currency,
  }) async {
    try {
      // 1. Create payment intent on your backend
      final paymentIntent = await _createPaymentIntent(
        amount: (amount * 100).toInt(), // Convert to cents
        currency: currency,
      );

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['clientSecret'],
          merchantDisplayName: 'ShopEase',
          style: ThemeMode.system,
        ),
      );

      // 3. Show payment sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      print('Payment failed: ${e.error.localizedMessage}');
      return false;
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    // Call your backend to create payment intent
    final response = await http.post(
      Uri.parse('https://your-backend.com/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
      }),
    );

    return jsonDecode(response.body);
  }
}

// Usage in checkout
class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _paymentService = PaymentService();
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    final cart = context.read<CartProvider>();
    final success = await _paymentService.processPayment(
      amount: cart.total,
      currency: 'usd',
    );

    if (success) {
      // Create order
      await _createOrder();
      // Navigate to success
      context.go('/cart/success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }

    setState(() => _isProcessing = false);
  }
}
```

### Task 4: Location for Store Finder

```dart
// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    // Check permission
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

    // Get location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // km
  }
}

// lib/screens/stores/store_finder_screen.dart

class StoreFinderScreen extends StatefulWidget {
  @override
  State<StoreFinderScreen> createState() => _StoreFinderScreenState();
}

class _StoreFinderScreenState extends State<StoreFinderScreen> {
  final _locationService = LocationService();
  Position? _currentPosition;
  List<Store> _nearbyStores = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyStores();
  }

  Future<void> _loadNearbyStores() async {
    final position = await _locationService.getCurrentLocation();
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required')),
      );
      return;
    }

    setState(() => _currentPosition = position);

    // Load stores and calculate distances
    final stores = await _loadStores();
    for (final store in stores) {
      store.distance = _locationService.calculateDistance(
        position.latitude,
        position.longitude,
        store.latitude,
        store.longitude,
      );
    }

    stores.sort((a, b) => a.distance.compareTo(b.distance));
    setState(() => _nearbyStores = stores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Store')),
      body: ListView.builder(
        itemCount: _nearbyStores.length,
        itemBuilder: (context, index) {
          final store = _nearbyStores[index];
          return ListTile(
            leading: const Icon(Icons.store),
            title: Text(store.name),
            subtitle: Text(store.address),
            trailing: Text('${store.distance.toStringAsFixed(1)} km'),
            onTap: () => _openMaps(store),
          );
        },
      ),
    );
  }
}
```

---

## Permissions Required

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to let you add photos to reviews</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to let you add photos to reviews</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to find nearby stores</string>
```

---

## Success Criteria

- [ ] Camera captures photos for reviews
- [ ] Photos upload to Firebase Storage
- [ ] Push notifications received when app closed
- [ ] Push notifications show when app open
- [ ] Payment sheet shows correctly
- [ ] Payment processes successfully
- [ ] Location permission requested
- [ ] Nearby stores sorted by distance
- [ ] All permissions handled gracefully

---

## Files to Create

```
shopease/
└── lib/
    └── services/
        ├── camera_service.dart       ◄── Create
        ├── notification_service.dart ◄── Create
        ├── payment_service.dart      ◄── Create
        └── location_service.dart     ◄── Create
```

---

**Your ShopEase app now uses native device features!**
