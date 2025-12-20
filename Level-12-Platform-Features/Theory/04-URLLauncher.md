# URL Launcher

## The Simple Explanation

URL Launcher is like having shortcuts to other apps on your phone. It lets your app open websites, make phone calls, send emails, and launch other apps!

```
┌─────────────────────────────────────────────────────────┐
│                    URL LAUNCHER                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Your App can open:                                      │
│                                                          │
│  🌐 Websites     →  https://flutter.dev                 │
│  📞 Phone        →  tel:+1234567890                     │
│  📧 Email        →  mailto:hello@example.com            │
│  💬 SMS          →  sms:+1234567890                     │
│  🗺️ Maps         →  Google Maps / Apple Maps            │
│  📱 Other Apps   →  WhatsApp, Instagram, etc.           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Setup

### 1. Add Package

```yaml
dependencies:
  url_launcher: ^6.2.1
```

### 2. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
  <string>tel</string>
  <string>mailto</string>
  <string>sms</string>
  <string>whatsapp</string>
  <string>instagram</string>
</array>
```

### 3. Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.intent.action.DIAL" />
    <data android:scheme="tel" />
  </intent>
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="mailto" />
  </intent>
  <intent>
    <action android:name="android.intent.action.SENDTO" />
    <data android:scheme="sms" />
  </intent>
</queries>
```

---

## Basic Usage

### Open Website

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openWebsite(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not open $url';
  }
}

// Usage
await openWebsite('https://flutter.dev');
```

### Open in External Browser vs In-App

```dart
// Open in external browser (default)
await launchUrl(
  Uri.parse('https://flutter.dev'),
  mode: LaunchMode.externalApplication,
);

// Open in in-app browser (WebView)
await launchUrl(
  Uri.parse('https://flutter.dev'),
  mode: LaunchMode.inAppWebView,
);

// Let system decide
await launchUrl(
  Uri.parse('https://flutter.dev'),
  mode: LaunchMode.platformDefault,
);
```

---

## Make Phone Call

```dart
Future<void> makePhoneCall(String phoneNumber) async {
  final uri = Uri.parse('tel:$phoneNumber');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not call $phoneNumber';
  }
}

// Usage
await makePhoneCall('+1234567890');
```

---

## Send Email

```dart
Future<void> sendEmail({
  required String to,
  String subject = '',
  String body = '',
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: to,
    query: _encodeQueryParameters({
      'subject': subject,
      'body': body,
    }),
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not send email to $to';
  }
}

String _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

// Usage
await sendEmail(
  to: 'support@example.com',
  subject: 'Help Request',
  body: 'I need help with...',
);
```

---

## Send SMS

```dart
Future<void> sendSMS(String phoneNumber, {String message = ''}) async {
  final uri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: message.isNotEmpty ? {'body': message} : null,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not send SMS to $phoneNumber';
  }
}

// Usage
await sendSMS('+1234567890', message: 'Hello!');
```

---

## Open Maps

```dart
Future<void> openMaps({
  double? latitude,
  double? longitude,
  String? address,
}) async {
  String url;

  if (latitude != null && longitude != null) {
    // Open specific coordinates
    url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  } else if (address != null) {
    // Search for address
    url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
  } else {
    throw 'Provide coordinates or address';
  }

  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open maps';
  }
}

// Usage
await openMaps(latitude: 40.7128, longitude: -74.0060);
await openMaps(address: 'Times Square, New York');
```

---

## Open Social Media Apps

```dart
class SocialLauncher {
  // Open WhatsApp
  static Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    final url = 'whatsapp://send?phone=$phoneNumber${message != null ? '&text=${Uri.encodeComponent(message)}' : ''}';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback to web
      await launchUrl(Uri.parse('https://wa.me/$phoneNumber'));
    }
  }

  // Open Instagram profile
  static Future<void> openInstagram(String username) async {
    final appUrl = Uri.parse('instagram://user?username=$username');
    final webUrl = Uri.parse('https://instagram.com/$username');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      await launchUrl(webUrl);
    }
  }

  // Open Twitter/X profile
  static Future<void> openTwitter(String username) async {
    final appUrl = Uri.parse('twitter://user?screen_name=$username');
    final webUrl = Uri.parse('https://twitter.com/$username');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      await launchUrl(webUrl);
    }
  }

  // Open YouTube video
  static Future<void> openYouTube(String videoId) async {
    final appUrl = Uri.parse('youtube://www.youtube.com/watch?v=$videoId');
    final webUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      await launchUrl(webUrl);
    }
  }
}
```

---

## Complete URL Launcher Service

```dart
import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  // Open URL
  static Future<bool> openUrl(String url, {bool inApp = false}) async {
    final uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return await launchUrl(
      uri,
      mode: inApp ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
    );
  }

  // Make phone call
  static Future<bool> call(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  // Send email
  static Future<bool> email({
    required String to,
    String? subject,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    final params = <String, String>{};
    if (subject != null) params['subject'] = subject;
    if (body != null) params['body'] = body;
    if (cc != null) params['cc'] = cc.join(',');
    if (bcc != null) params['bcc'] = bcc.join(',');

    final uri = Uri(
      scheme: 'mailto',
      path: to,
      query: params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&'),
    );

    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  // Send SMS
  static Future<bool> sms(String phoneNumber, {String? message}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  // Open maps with coordinates
  static Future<bool> openMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    return await openUrl(url);
  }

  // Search address on maps
  static Future<bool> searchMap(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    return await openUrl(url);
  }

  // Open app store page
  static Future<bool> openAppStore(String appId, {bool isIos = true}) async {
    final url = isIos
        ? 'https://apps.apple.com/app/id$appId'
        : 'https://play.google.com/store/apps/details?id=$appId';
    return await openUrl(url);
  }
}
```

---

## Contact Actions Widget

```dart
class ContactActions extends StatelessWidget {
  final String? phone;
  final String? email;
  final String? website;
  final String? address;

  const ContactActions({
    super.key,
    this.phone,
    this.email,
    this.website,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (phone != null)
          ActionChip(
            avatar: const Icon(Icons.phone, size: 18),
            label: const Text('Call'),
            onPressed: () => LauncherService.call(phone!),
          ),

        if (phone != null)
          ActionChip(
            avatar: const Icon(Icons.message, size: 18),
            label: const Text('SMS'),
            onPressed: () => LauncherService.sms(phone!),
          ),

        if (email != null)
          ActionChip(
            avatar: const Icon(Icons.email, size: 18),
            label: const Text('Email'),
            onPressed: () => LauncherService.email(to: email!),
          ),

        if (website != null)
          ActionChip(
            avatar: const Icon(Icons.language, size: 18),
            label: const Text('Website'),
            onPressed: () => LauncherService.openUrl(website!),
          ),

        if (address != null)
          ActionChip(
            avatar: const Icon(Icons.map, size: 18),
            label: const Text('Directions'),
            onPressed: () => LauncherService.searchMap(address!),
          ),
      ],
    );
  }
}

// Usage
ContactActions(
  phone: '+1234567890',
  email: 'contact@example.com',
  website: 'https://example.com',
  address: '123 Main St, New York',
)
```

---

## Error Handling

```dart
Future<void> launchUrlSafely(String url) async {
  try {
    final uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      // Show error to user
      _showError('Cannot open this link');
      return;
    }

    final success = await launchUrl(uri);

    if (!success) {
      _showError('Failed to open link');
    }
  } catch (e) {
    _showError('Error: $e');
  }
}

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              URL LAUNCHER SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  PACKAGE: url_launcher                                   │
│                                                          │
│  OPEN URL:                                               │
│  launchUrl(Uri.parse('https://...'))                    │
│                                                          │
│  URL SCHEMES:                                            │
│  ├── https:// or http://  - Websites                    │
│  ├── tel:                 - Phone calls                 │
│  ├── mailto:              - Email                       │
│  ├── sms:                 - Text messages               │
│  └── Custom schemes       - Other apps                  │
│                                                          │
│  CHECK FIRST:                                            │
│  if (await canLaunchUrl(uri)) { ... }                   │
│                                                          │
│  MODES:                                                  │
│  ├── externalApplication - Open in browser/app          │
│  ├── inAppWebView        - Open in app                  │
│  └── platformDefault     - Let system decide            │
│                                                          │
│  REMEMBER:                                               │
│  ├── Configure iOS Info.plist (LSApplicationQueries)   │
│  └── Configure Android queries in manifest              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Next:** `05-ConnectivityPermissions.md` - Network status and permissions
