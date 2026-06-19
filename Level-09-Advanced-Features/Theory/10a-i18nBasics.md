# Internationalization Basics: Speaking Many Languages

## The Big Idea In One Sentence

> Internationalization (i18n) means never hardcoding text in your widgets, instead you look each phrase up by a key, so the app can show the right language for each user.

## The Simple Explanation

Imagine you have a toy store, and children from different countries visit:

```
WITHOUT INTERNATIONALIZATION:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  English Kid:  "I want a teddy bear!" ✅                 │
│  (Reads sign: "Teddy Bears")                             │
│                                                          │
│  Spanish Kid:  "¿Qué es esto?" 😕                        │
│  (Can't read: "Teddy Bears")                             │
│                                                          │
│  Chinese Kid:  "我不懂..." 😢                            │
│  (Can't read: "Teddy Bears")                             │
│                                                          │
│  Result: Only English kids can shop!                     │
│                                                          │
└─────────────────────────────────────────────────────────┘

WITH INTERNATIONALIZATION:
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  English Kid:  "Teddy Bears!" 😊                         │
│  Spanish Kid:  "¡Osos de peluche!" 😊                    │
│  Chinese Kid:  "泰迪熊!" 😊                              │
│                                                          │
│  Result: Everyone can shop in their language!            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Internationalization (i18n) = Making your app work in different languages!**

(i18n = "i" + 18 letters + "n" = internationalization)
(l10n = "l" + 10 letters + "n" = localization)

---

## Why Internationalization Matters

```
┌─────────────────────────────────────────────────────────┐
│             WHY SUPPORT MULTIPLE LANGUAGES?              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  🌍 Global Reach                                         │
│     • 1.5 billion English speakers                       │
│     • 1.1 billion Mandarin speakers                      │
│     • 600 million Spanish speakers                       │
│     • And many more!                                     │
│                                                          │
│  💰 Business Benefits                                    │
│     • Reach more customers                               │
│     • Higher app store rankings                          │
│     • Competitive advantage                              │
│                                                          │
│  ❤️  Better User Experience                              │
│     • Users prefer their native language                 │
│     • Increases engagement                               │
│     • Shows you care about all users                     │
│                                                          │
│  📱 Platform Requirement                                 │
│     • Many countries require local language              │
│     • App stores favor localized apps                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## i18n vs l10n: What's the Difference?

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  INTERNATIONALIZATION (i18n)                             │
│  ──────────────────────────────────────────              │
│  Making your app ABLE to support multiple languages      │
│                                                          │
│  What you do:                                            │
│  • Design code to support multiple languages             │
│  • Extract text into translation files                   │
│  • Use locale-aware formatting                           │
│  • Handle different text directions (LTR/RTL)            │
│                                                          │
│  Think: Building a multi-language CAPABLE app            │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  LOCALIZATION (l10n)                                     │
│  ──────────────────────────────────────────              │
│  Adapting your app for a SPECIFIC language/region        │
│                                                          │
│  What you do:                                            │
│  • Translate all text                                    │
│  • Use correct date/time formats                         │
│  • Use correct number/currency formats                   │
│  • Adapt images and colors for culture                   │
│                                                          │
│  Think: Actually TRANSLATING the app                     │
│                                                          │
└─────────────────────────────────────────────────────────┘

Example:
• i18n: Your code can show dates in any format
• l10n: Actually showing "12/31/2025" (US) vs "31/12/2025" (UK)
```

---

## Step 1: Add Dependencies

First, add the required packages to your `pubspec.yaml`:

```yaml
name: my_app
description: A multilingual Flutter app

dependencies:
  flutter:
    sdk: flutter

  # Internationalization support
  flutter_localizations:
    sdk: flutter

  # Date/number formatting
  intl: ^0.18.0

flutter:
  generate: true  # Enable code generation
```

Run to install:
```bash
flutter pub get
```

---

## Step 2: Configure Localization

Create a file `l10n.yaml` in your project root:

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

```
Project structure:
my_app/
├── lib/
│   ├── l10n/                    ← Translation files go here
│   │   ├── app_en.arb          (English)
│   │   ├── app_es.arb          (Spanish)
│   │   └── app_zh.arb          (Chinese)
│   └── main.dart
├── l10n.yaml                    ← Configuration
└── pubspec.yaml
```

---

## Step 3: Create Translation Files (ARB)

ARB = Application Resource Bundle (JSON format)

### English (app_en.arb)

```json
{
  "@@locale": "en",

  "helloWorld": "Hello World!",
  "@helloWorld": {
    "description": "The conventional newbie greeting"
  },

  "welcome": "Welcome",
  "@welcome": {
    "description": "Welcome message on home screen"
  },

  "settings": "Settings",
  "profile": "Profile",
  "logout": "Log Out"
}
```

### Spanish (app_es.arb)

```json
{
  "@@locale": "es",

  "helloWorld": "¡Hola Mundo!",
  "welcome": "Bienvenido",
  "settings": "Configuración",
  "profile": "Perfil",
  "logout": "Cerrar Sesión"
}
```

### Chinese (app_zh.arb)

```json
{
  "@@locale": "zh",

  "helloWorld": "你好世界！",
  "welcome": "欢迎",
  "settings": "设置",
  "profile": "个人资料",
  "logout": "登出"
}
```

---

## Step 4: Set Up MaterialApp

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title
      title: 'i18n Demo',

      // ✅ STEP 1: Add localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,              // Your app's translations
        GlobalMaterialLocalizations.delegate,   // Material widgets
        GlobalWidgetsLocalizations.delegate,    // Text direction
        GlobalCupertinoLocalizations.delegate,  // Cupertino widgets
      ],

      // ✅ STEP 2: List supported languages
      supportedLocales: const [
        Locale('en'),  // English
        Locale('es'),  // Spanish
        Locale('zh'),  // Chinese
      ],

      // ✅ STEP 3: (Optional) Set fallback language
      locale: const Locale('en'),

      home: const HomePage(),
    );
  }
}
```

---

## Step 5: Use Translations in Your App

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get translations for current locale
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Use translated text
        title: Text(l10n.welcome),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display translated greeting
            Text(
              l10n.helloWorld,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Text('Current locale: ${Localizations.localeOf(context)}'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(l10n.welcome),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.profile),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.logout),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

### How It Works

```
┌─────────────────────────────────────────────────────────┐
│                  HOW TRANSLATION WORKS                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. User's phone is set to Spanish                       │
│                                                          │
│  2. Flutter checks device locale                         │
│     Device locale: "es" (Spanish)                        │
│                                                          │
│  3. AppLocalizations loads Spanish ARB file              │
│     Loads: app_es.arb                                    │
│                                                          │
│  4. Your code requests translation                       │
│     l10n.helloWorld                                      │
│                                                          │
│  5. Returns Spanish text                                 │
│     "¡Hola Mundo!"                                       │
│                                                          │
│  Display shows: "¡Hola Mundo!"                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Complete Example: Basic i18n App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyI18nApp());
}

class MyI18nApp extends StatelessWidget {
  const MyI18nApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internationalization Demo',

      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),  // English
        Locale('es'),  // Spanish
        Locale('zh'),  // Chinese
        Locale('fr'),  // French
        Locale('de'),  // German
      ],

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting
            Text(
              l10n.helloWorld,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Show current locale
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.language, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Current Language: ${currentLocale.languageCode.toUpperCase()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    _getLanguageName(currentLocale.languageCode),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(l10n.welcome),
                      subtitle: const Text('Automatically translated!'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(l10n.profile),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(l10n.settings),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Text(
              'To see different languages:\n'
              '1. Go to device Settings\n'
              '2. Change language\n'
              '3. Restart the app',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'zh':
        return '中文';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      default:
        return code;
    }
  }
}
```

---

## Understanding Locale

A locale defines:
- Language (required): 'en', 'es', 'zh'
- Country (optional): 'US', 'GB', 'MX'

```dart
// Language only
const Locale('en')        // English (any country)
const Locale('es')        // Spanish (any country)

// Language + Country
const Locale('en', 'US')  // English (United States)
const Locale('en', 'GB')  // English (Great Britain)
const Locale('es', 'MX')  // Spanish (Mexico)
const Locale('es', 'ES')  // Spanish (Spain)
const Locale('zh', 'CN')  // Chinese (Simplified - China)
const Locale('zh', 'TW')  // Chinese (Traditional - Taiwan)

// Language + Script + Country (for languages with multiple scripts)
const Locale.fromSubtags(
  languageCode: 'zh',     // Chinese
  scriptCode: 'Hans',     // Simplified script
  countryCode: 'CN',      // China
)

const Locale.fromSubtags(
  languageCode: 'zh',     // Chinese
  scriptCode: 'Hant',     // Traditional script
  countryCode: 'TW',      // Taiwan
)
```

---

## Getting Current Locale

```dart
class LocaleExample extends StatelessWidget {
  const LocaleExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current locale
    final currentLocale = Localizations.localeOf(context);

    // Get language code
    final languageCode = currentLocale.languageCode;  // 'en', 'es', etc.

    // Get country code (might be null)
    final countryCode = currentLocale.countryCode;    // 'US', 'MX', etc.

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Language: $languageCode'),
            Text('Country: ${countryCode ?? 'Not specified'}'),
            Text('Full locale: ${currentLocale.toString()}'),
          ],
        ),
      ),
    );
  }
}
```

---

## Fallback Behavior

```dart
MaterialApp(
  // Supported languages
  supportedLocales: const [
    Locale('en'),  // English
    Locale('es'),  // Spanish
  ],

  // What happens for different device languages:
  //
  // Device = English   → App shows English ✅
  // Device = Spanish   → App shows Spanish ✅
  // Device = French    → App shows English (first in list) ⚠️
  // Device = Chinese   → App shows English (first in list) ⚠️

  home: const HomePage(),
)
```

---

## Checking for Translation Availability

```dart
class TranslationChecker extends StatelessWidget {
  const TranslationChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    // Check if translation is available
    final isSupported = AppLocalizations.delegate.isSupported(currentLocale);

    return Scaffold(
      body: Center(
        child: Text(
          isSupported
              ? 'Translation available for ${currentLocale.languageCode}'
              : 'Translation not available for ${currentLocale.languageCode}',
        ),
      ),
    );
  }
}
```

---

## Common Issues and Solutions

### Issue 1: Translations Don't Update

```dart
// ❌ PROBLEM: Forgot to run code generation
// After creating/updating ARB files, you must run:

flutter gen-l10n

// Or rebuild the app:
flutter run
```

### Issue 2: Can't Find AppLocalizations

```dart
// ❌ ERROR: "AppLocalizations not found"

// ✅ SOLUTION 1: Import generated file
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ✅ SOLUTION 2: Make sure l10n.yaml exists
// ✅ SOLUTION 3: Make sure pubspec.yaml has "generate: true"
// ✅ SOLUTION 4: Run "flutter gen-l10n"
```

### Issue 3: Null Error

```dart
// ❌ ERROR: "Null check operator used on a null value"
final l10n = AppLocalizations.of(context)!;  // Crashes!

// ✅ SOLUTION: Make sure you added localizationsDelegates to MaterialApp
MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,  // ← Don't forget this!
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│         INTERNATIONALIZATION BASICS SUMMARY              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  SETUP STEPS:                                            │
│  1. Add dependencies (flutter_localizations, intl)       │
│  2. Create l10n.yaml configuration                       │
│  3. Create ARB files for each language                   │
│  4. Configure MaterialApp with delegates                 │
│  5. Use AppLocalizations.of(context) in widgets          │
│                                                          │
│  KEY CONCEPTS:                                           │
│  • i18n = Making app capable of multiple languages       │
│  • l10n = Actually translating for specific language     │
│  • ARB = JSON files containing translations              │
│  • Locale = Language + optional country code             │
│                                                          │
│  USAGE:                                                  │
│  final l10n = AppLocalizations.of(context)!;             │
│  Text(l10n.helloWorld)  // Shows translated text         │
│                                                          │
│  FILES NEEDED:                                           │
│  • l10n.yaml - Configuration                             │
│  • lib/l10n/app_en.arb - English translations            │
│  • lib/l10n/app_es.arb - Spanish translations            │
│  • (Add more ARB files for more languages)               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What's Next?

Now you know the basics! Next, we'll learn:
- **Language Switching** - Let users change language in-app
- **ARB File Best Practices** - Organizing translations
- **Parameterized Translations** - Dynamic text with variables

---

## Quick Quiz

**Q1.** What does "i18n" stand for, and why the number 18?

<details>
<summary>Answer</summary>
Internationalization. There are 18 letters between the "i" and the "n", so people shorten it to i18n.
</details>

**Q2.** Why is hardcoding `Text('Hello')` a problem for a multi-language app?

<details>
<summary>Answer</summary>
It always shows English. To support other languages you must look the text up by a key so it can change per language.
</details>

**Q3.** Instead of writing the words directly, what do you reference in your widgets?

<details>
<summary>Answer</summary>
A key/label that maps to the translated string for the current language (e.g. `AppLocalizations.of(context).hello`).
</details>

---

## Assignment

### Problem 1: Spot the hardcoded text

Why will `Text('Welcome')` not adapt to a French user?

### Problem 2: The fix idea

In one line, what should replace the hardcoded string so it can be translated?

### Problem 3: What is a locale?

In simple words, what does a "locale" like `en` or `fr` tell the app?

---

## Assignment Answers

### Problem 1: Spot the hardcoded text

The word "Welcome" is baked into the widget, so it always shows that exact English text regardless of the user's language.

### Problem 2: The fix idea

A lookup by key, like `Text(AppLocalizations.of(context).welcome)`, which returns the right translation for the current language.

### Problem 3: What is a locale?

A locale tells the app which language (and region) to use, like `en` for English or `fr` for French, so it can pick the matching translations.

---

[⬅️ Previous: Accessibility Patterns](./09c-AccessibilityPatterns.md) | [⬆️ Learning Path](./00-LearningPath.md) | [➡️ Next: Multi-Language Support](./10b-MultiLanguage.md)
