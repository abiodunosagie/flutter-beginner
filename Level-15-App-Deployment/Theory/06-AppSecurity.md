# App Security: Protecting Your App Like a Castle

## The Simple Explanation

Imagine your app is a castle with treasure inside. Hackers are like thieves trying to break in. Security is building walls, locks, guards, and secret passages to keep the treasure safe!

```
WITHOUT SECURITY:
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│  Your App (Open House)                                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                                                         │ │
│  │   api_key = "sk-123456789"  ← Everyone can see!        │ │
│  │   password = "admin123"     ← Written on the door!     │ │
│  │   user_data = {...}         ← Not locked!              │ │
│  │                                                         │ │
│  │      🚪 (open)    🪟 (open)    🔓 (unlocked)            │ │
│  │                                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  Hackers: "Thanks for the easy access!" 😈                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘

WITH SECURITY:
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│  Your App (Protected Castle)                                 │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                                                         │ │
│  │   api_key = 🔒 (hidden safely)                         │ │
│  │   password = 🔐 (encrypted)                            │ │
│  │   user_data = 🛡️ (protected)                           │ │
│  │                                                         │ │
│  │      🚪🔒     🪟🔒     🔐                                │ │
│  │        │         │       │                              │ │
│  │    [Guard]  [Alarm]  [Vault]                           │ │
│  │                                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  Hackers: "Too hard, moving on..." 😤                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## The 7 Security Rules Every Developer Must Know

```
┌─────────────────────────────────────────────────────────────┐
│              THE 7 COMMANDMENTS OF APP SECURITY              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. NEVER hardcode secrets in your code                     │
│  2. NEVER trust user input                                  │
│  3. ALWAYS use HTTPS                                        │
│  4. ALWAYS encrypt sensitive data                           │
│  5. ALWAYS validate on the server (not just client)         │
│  6. ALWAYS keep dependencies updated                        │
│  7. ALWAYS log security events                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 1: Protecting API Keys

### The Problem: Exposed Keys

```dart
// ❌ TERRIBLE - API key is visible in your code!
class MyApiService {
  final String apiKey = 'sk-1234567890abcdef';  // 💀 EXPOSED!

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://api.example.com/data'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
  }
}

// Why this is bad:
// 1. Anyone who decompiles your app sees the key
// 2. Key gets committed to git → Everyone on GitHub sees it
// 3. Key can be extracted from the APK/IPA file
// 4. Once exposed, hackers can use YOUR API quota
// 5. You might get charged thousands of dollars!
```

### Solution 1: Environment Variables with --dart-define

The SAFEST way to handle API keys in Flutter!

```bash
# Run your app with the key passed at compile time
flutter run --dart-define=API_KEY=sk-1234567890abcdef

# For release builds
flutter build apk --dart-define=API_KEY=sk-1234567890abcdef
```

```dart
// Access the key in your code
class Config {
  // Key is injected at compile time - NOT in source code!
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '', // Empty in source code!
  );
}

// Usage
class MyApiService {
  Future<void> fetchData() async {
    if (Config.apiKey.isEmpty) {
      throw Exception('API key not configured!');
    }

    final response = await http.get(
      Uri.parse('https://api.example.com/data'),
      headers: {'Authorization': 'Bearer ${Config.apiKey}'},
    );
  }
}
```

### Solution 2: Using .env Files (Development)

```
YOUR PROJECT STRUCTURE:

my_app/
├── .env.development     ← Development keys (can commit)
├── .env.production      ← Production keys (NEVER commit!)
├── .env.example         ← Template showing required keys
├── .gitignore           ← Ignores .env.production
└── lib/
    └── ...
```

**.env.example** (Commit this - shows what's needed)
```
API_KEY=your_api_key_here
STRIPE_KEY=your_stripe_key_here
GOOGLE_MAPS_KEY=your_maps_key_here
```

**.env.development** (Safe to commit - uses test keys)
```
API_KEY=test_key_12345
STRIPE_KEY=pk_test_xxxxx
GOOGLE_MAPS_KEY=dev_maps_key
```

**.env.production** (NEVER commit this!)
```
API_KEY=sk-REAL_PRODUCTION_KEY
STRIPE_KEY=pk_live_xxxxx
GOOGLE_MAPS_KEY=REAL_maps_key
```

**.gitignore**
```
# Environment files with real secrets
.env.production
.env.local
*.env.local

# Keep these for reference
!.env.example
!.env.development
```

### Using flutter_dotenv Package

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load environment based on build mode
  await dotenv.load(
    fileName: kDebugMode ? '.env.development' : '.env.production',
  );

  runApp(MyApp());
}

// Access values
class Config {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get stripeKey => dotenv.env['STRIPE_KEY'] ?? '';
}
```

### Solution 3: Backend Proxy (Most Secure!)

```
THE SAFEST APPROACH:
Your app NEVER sees the real API key!

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│   Your App          Your Server         Third-Party API      │
│                                                              │
│   ┌──────┐         ┌──────────┐         ┌──────────────┐    │
│   │      │         │          │         │              │    │
│   │ App  │───────▶│  Server  │────────▶│  OpenAI API  │    │
│   │      │         │          │         │              │    │
│   │      │  No key │  Has the │  Uses   │              │    │
│   │      │  needed │  API key │  key    │              │    │
│   └──────┘         └──────────┘         └──────────────┘    │
│                                                              │
│   The API key lives ONLY on your server!                    │
│   Even if someone hacks the app, they can't get the key!   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

```dart
// Your app calls YOUR server (no API key needed)
class SecureApiService {
  final String baseUrl = 'https://your-server.com/api';

  Future<Map<String, dynamic>> generateText(String prompt) async {
    // Call YOUR server - no API key in the app!
    final response = await http.post(
      Uri.parse('$baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    return jsonDecode(response.body);
  }
}

// Your server (Node.js example) has the real key
/*
const express = require('express');
const app = express();

app.post('/api/generate', async (req, res) => {
  const response = await fetch('https://api.openai.com/v1/...', {
    headers: {
      'Authorization': `Bearer ${process.env.OPENAI_API_KEY}` // Key on server!
    },
    body: JSON.stringify(req.body)
  });

  res.json(await response.json());
});
*/
```

---

## Part 2: Securing Stored Data

### Storing Sensitive Data Safely

```dart
// ❌ BAD - Storing password in SharedPreferences (not encrypted!)
final prefs = await SharedPreferences.getInstance();
prefs.setString('password', 'user_password_123');  // 💀 Not secure!

// ✅ GOOD - Use flutter_secure_storage for sensitive data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  // Store securely (encrypted)
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Read securely
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Delete securely
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### What to Store Where

```
┌─────────────────────────────────────────────────────────────┐
│              WHERE TO STORE DIFFERENT DATA                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SharedPreferences (NOT encrypted):                         │
│  ✅ User preferences (dark mode, language)                  │
│  ✅ App settings (notifications on/off)                     │
│  ✅ Non-sensitive cached data                               │
│  ❌ NEVER passwords or tokens!                              │
│                                                              │
│  flutter_secure_storage (Encrypted):                        │
│  ✅ Authentication tokens                                   │
│  ✅ Refresh tokens                                          │
│  ✅ Session keys                                            │
│  ✅ Any credential                                          │
│                                                              │
│  Don't store at all:                                        │
│  ❌ Passwords (use tokens instead)                          │
│  ❌ Credit card numbers (use payment providers)             │
│  ❌ Social Security numbers                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 3: Network Security

### Always Use HTTPS

```dart
// ❌ BAD - HTTP is not encrypted!
final response = await http.get(
  Uri.parse('http://api.example.com/data'),  // 💀 NOT SECURE!
);

// ✅ GOOD - HTTPS encrypts data in transit
final response = await http.get(
  Uri.parse('https://api.example.com/data'),  // ✅ Encrypted!
);
```

### Certificate Pinning (Advanced)

Prevents man-in-the-middle attacks by only trusting specific certificates.

```dart
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

class SecureHttpClient {
  late Dio _dio;

  SecureHttpClient() {
    _dio = Dio();

    // Certificate pinning
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();

      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Only allow your specific certificate
        final expectedFingerprint = 'YOUR_CERTIFICATE_FINGERPRINT';
        final certFingerprint = cert.sha256.toString();

        return certFingerprint == expectedFingerprint;
      };

      return client;
    };
  }

  Future<Response> get(String path) => _dio.get(path);
}
```

---

## Part 4: Input Validation & Sanitization

### Never Trust User Input!

```dart
// ❌ BAD - Directly using user input (SQL Injection risk)
Future<User> getUser(String userId) async {
  // If userId = "1; DROP TABLE users;" → Database destroyed!
  final query = "SELECT * FROM users WHERE id = $userId";
  // ...
}

// ✅ GOOD - Always validate and sanitize
Future<User> getUser(String userId) async {
  // Validate: Is it actually a number?
  if (!RegExp(r'^\d+$').hasMatch(userId)) {
    throw InvalidInputException('Invalid user ID');
  }

  // Use parameterized queries (the database driver escapes it)
  final result = await db.query(
    'SELECT * FROM users WHERE id = ?',
    [userId],  // Properly escaped
  );

  return User.fromMap(result.first);
}
```

### Validation Helpers

```dart
class InputValidator {
  // Validate email
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // Validate no script injection
  static String sanitizeText(String input) {
    // Remove potential HTML/script tags
    return input
      .replaceAll(RegExp(r'<[^>]*>'), '')  // Remove HTML tags
      .replaceAll(RegExp(r'[<>"\']'), ''); // Remove dangerous chars
  }

  // Validate file uploads
  static bool isAllowedFileType(String filename) {
    final allowed = ['jpg', 'jpeg', 'png', 'pdf'];
    final extension = filename.split('.').last.toLowerCase();
    return allowed.contains(extension);
  }

  // Limit input length
  static String limitLength(String input, int maxLength) {
    if (input.length > maxLength) {
      return input.substring(0, maxLength);
    }
    return input;
  }
}

// Usage
void handleUserInput(String userComment) {
  // Sanitize before using
  final safeComment = InputValidator.sanitizeText(userComment);
  final limitedComment = InputValidator.limitLength(safeComment, 500);

  // Now safe to save
  saveComment(limitedComment);
}
```

---

## Part 5: Authentication Security

### Secure Token Handling

```dart
class AuthService {
  final _secureStorage = FlutterSecureStorage();

  // Store tokens securely
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Get access token with auto-refresh
  Future<String?> getValidToken() async {
    final accessToken = await _secureStorage.read(key: 'access_token');

    if (accessToken == null) return null;

    // Check if token is expired
    if (_isTokenExpired(accessToken)) {
      return await _refreshTokens();
    }

    return accessToken;
  }

  // Check token expiration
  bool _isTokenExpired(String token) {
    try {
      // Decode JWT and check exp claim
      final parts = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return now >= exp;
    } catch (e) {
      return true; // Treat invalid tokens as expired
    }
  }

  // Clear tokens on logout
  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
```

### Biometric Authentication

```dart
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final _localAuth = LocalAuthentication();

  // Check if biometrics are available
  Future<bool> canUseBiometrics() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  // Authenticate with biometrics
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

// Usage
class SecureScreen extends StatelessWidget {
  final _biometricAuth = BiometricAuth();

  Future<void> _accessSensitiveData() async {
    // Require biometric auth for sensitive operations
    final authenticated = await _biometricAuth.authenticate();

    if (authenticated) {
      // Show sensitive data
    } else {
      // Access denied
    }
  }
}
```

---

## Part 6: Code Protection

### Enable Code Obfuscation

Code obfuscation makes it harder to reverse-engineer your app.

```bash
# Build with obfuscation (Android)
flutter build apk --obfuscate --split-debug-info=./debug-info

# Build with obfuscation (iOS)
flutter build ios --obfuscate --split-debug-info=./debug-info
```

```
WHAT OBFUSCATION DOES:

Before (readable):
┌────────────────────────────────────────┐
│  class UserService {                   │
│    String apiKey = "abc123";           │
│    void login(String password) {...}   │
│  }                                     │
└────────────────────────────────────────┘

After (obfuscated):
┌────────────────────────────────────────┐
│  class a1b2c {                         │
│    String x9y8 = "abc123";             │
│    void z7w6(String q5p4) {...}        │
│  }                                     │
└────────────────────────────────────────┘

Note: The LOGIC is the same, but names are scrambled!
This makes it HARDER to understand, not IMPOSSIBLE.
```

### ProGuard Rules (Android)

```proguard
# android/app/proguard-rules.pro

# Keep your model classes
-keep class com.yourapp.models.** { *; }

# Keep JSON serialization
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
```

---

## Part 7: Preventing Common Attacks

### 1. Rate Limiting (Prevent Brute Force)

```dart
class RateLimiter {
  final Map<String, List<DateTime>> _attempts = {};
  final int maxAttempts;
  final Duration window;

  RateLimiter({
    this.maxAttempts = 5,
    this.window = const Duration(minutes: 15),
  });

  bool isAllowed(String identifier) {
    final now = DateTime.now();
    final attempts = _attempts[identifier] ?? [];

    // Remove old attempts outside the window
    attempts.removeWhere((time) => now.difference(time) > window);
    _attempts[identifier] = attempts;

    // Check if under limit
    if (attempts.length >= maxAttempts) {
      return false;  // Too many attempts!
    }

    // Record this attempt
    attempts.add(now);
    return true;
  }

  Duration? getTimeUntilReset(String identifier) {
    final attempts = _attempts[identifier];
    if (attempts == null || attempts.isEmpty) return null;

    final oldestAttempt = attempts.first;
    final resetTime = oldestAttempt.add(window);
    final remaining = resetTime.difference(DateTime.now());

    return remaining.isNegative ? null : remaining;
  }
}

// Usage
class LoginService {
  final _rateLimiter = RateLimiter(maxAttempts: 5);

  Future<void> login(String email, String password) async {
    if (!_rateLimiter.isAllowed(email)) {
      final waitTime = _rateLimiter.getTimeUntilReset(email);
      throw TooManyAttemptsException(
        'Too many login attempts. Try again in ${waitTime?.inMinutes} minutes.',
      );
    }

    // Proceed with login...
  }
}
```

### 2. Jailbreak/Root Detection

```dart
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class SecurityCheck {
  static Future<bool> isDeviceSecure() async {
    final isJailbroken = await FlutterJailbreakDetection.jailbroken;
    final isDeveloperMode = await FlutterJailbreakDetection.developerMode;

    // For high-security apps (banking, etc.)
    if (isJailbroken) {
      return false;  // Don't allow on jailbroken devices
    }

    return true;
  }
}

// Usage in app startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isSecure = await SecurityCheck.isDeviceSecure();

  if (!isSecure) {
    runApp(SecurityWarningApp());  // Show warning
  } else {
    runApp(MyApp());
  }
}
```

### 3. Screenshot Prevention (Android)

```kotlin
// android/app/src/main/kotlin/.../MainActivity.kt
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Prevent screenshots
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }
}
```

---

## Part 8: Security Checklist

```
┌─────────────────────────────────────────────────────────────┐
│              PRE-LAUNCH SECURITY CHECKLIST                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  API KEYS & SECRETS:                                         │
│  ☐ No hardcoded API keys in source code                    │
│  ☐ Using --dart-define or .env files                       │
│  ☐ .env.production in .gitignore                           │
│  ☐ Consider backend proxy for sensitive APIs               │
│                                                              │
│  DATA STORAGE:                                               │
│  ☐ Tokens in flutter_secure_storage                        │
│  ☐ No sensitive data in SharedPreferences                  │
│  ☐ Proper logout clears all sensitive data                 │
│                                                              │
│  NETWORK:                                                    │
│  ☐ All API calls use HTTPS                                 │
│  ☐ Certificate pinning for high-security apps              │
│  ☐ Proper error handling (no stack traces to users)        │
│                                                              │
│  INPUT:                                                      │
│  ☐ All user input validated                                │
│  ☐ Text input sanitized                                    │
│  ☐ File uploads validated                                  │
│                                                              │
│  CODE:                                                       │
│  ☐ Obfuscation enabled for release builds                  │
│  ☐ Debug mode disabled in production                       │
│  ☐ ProGuard configured (Android)                           │
│                                                              │
│  DEPENDENCIES:                                               │
│  ☐ All packages up to date                                 │
│  ☐ Checked for known vulnerabilities                       │
│  ☐ Minimal permissions requested                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                   APP SECURITY SUMMARY                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  PROTECTING API KEYS:                                        │
│  1. Use --dart-define (best for production)                 │
│  2. Use .env files (good for development)                   │
│  3. Use backend proxy (most secure)                         │
│  4. NEVER hardcode in source code                           │
│                                                              │
│  STORING DATA SAFELY:                                        │
│  • flutter_secure_storage for tokens                        │
│  • SharedPreferences for non-sensitive only                 │
│  • Never store passwords locally                            │
│                                                              │
│  NETWORK SECURITY:                                           │
│  • Always use HTTPS                                         │
│  • Consider certificate pinning                             │
│  • Validate server responses                                │
│                                                              │
│  CODE PROTECTION:                                            │
│  • Enable obfuscation                                       │
│  • Use ProGuard                                             │
│  • Disable debug mode in production                         │
│                                                              │
│  REMEMBER:                                                   │
│  Security is like an onion - many layers!                   │
│  No single solution is perfect.                             │
│  Defense in depth is the key.                               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** Why shouldn't you hardcode API keys in your Dart files?

<details>
<summary>Answer</summary>

Anyone can decompile your app and extract the keys! They can then:
- Use your API quota (you pay!)
- Access your data
- Impersonate your app

Use `--dart-define` or a backend proxy instead.

</details>

**Q2:** What's the difference between SharedPreferences and flutter_secure_storage?

<details>
<summary>Answer</summary>

- **SharedPreferences**: Stores data as plain text. Anyone with device access can read it. Use for non-sensitive settings.
- **flutter_secure_storage**: Encrypts data using the device's secure enclave (iOS Keychain, Android Keystore). Use for tokens and credentials.

</details>

**Q3:** What is code obfuscation?

<details>
<summary>Answer</summary>

Obfuscation scrambles your code's variable and function names to make it harder to reverse-engineer. It turns `class UserService` into something like `class a1b2c`. The logic stays the same, but it's harder to understand what the code does.

</details>

---

**Congratulations!** You now know how to protect your app like a pro!

---

**Next:** Level 16 - Professional Patterns

---

[← Back to Level 15 README](../README.md)
