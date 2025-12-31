# Advanced Localization in Flutter

## Think of It Like This (5-Year-Old Explanation)

Imagine you're learning to write from different friends around the world:

```
┌─────────────────────────────────────────────────┐
│       DIFFERENT WAYS TO WRITE                    │
├─────────────────────────────────────────────────┤
│                                                  │
│  English Friend (Left to Right):                │
│  ┌────────────────────┐                         │
│  │ Hello → → →        │                         │
│  └────────────────────┘                         │
│                                                  │
│  Arabic Friend (Right to Left):                 │
│  ┌────────────────────┐                         │
│  │        ← ← ← مرحبا │                         │
│  └────────────────────┘                         │
│                                                  │
│  Different directions, same meaning!            │
│                                                  │
│  Also:                                           │
│  - Numbers look different: 123 vs ١٢٣           │
│  - Dates written differently: 12/31 vs 31/12    │
│  - "1 apple" vs "2 apples" (plurals!)           │
│                                                  │
└─────────────────────────────────────────────────┘
```

Advanced localization handles these special cases where different languages work in fundamentally different ways.

## Right-to-Left (RTL) Language Support

Some languages like Arabic, Hebrew, Persian, and Urdu are written from right to left. Flutter needs to flip the entire UI for these languages.

### How RTL Works

```
┌────────────────────────────────────────────────────┐
│          LTR (Left-to-Right) vs RTL                │
├────────────────────────────────────────────────────┤
│                                                     │
│  LTR (English):                                    │
│  ┌──────────────────────────────────┐             │
│  │ ☰  My App          🔔  ⚙️        │             │
│  │                                   │             │
│  │  Welcome to our app!              │             │
│  │                                   │             │
│  │  [Button] →                       │             │
│  └──────────────────────────────────┘             │
│                                                     │
│  RTL (Arabic):                                     │
│  ┌──────────────────────────────────┐             │
│  │        ⚙️  🔔          تطبيقي  ☰ │             │
│  │                                   │             │
│  │              !مرحبا بك في تطبيقنا │             │
│  │                                   │             │
│  │                       ← [زر]      │             │
│  └──────────────────────────────────┘             │
│                                                     │
│  Everything mirrors!                               │
└────────────────────────────────────────────────────┘
```

### Setting Up RTL Support

#### Step 1: Add RTL Locale to ARB Files

```json
// app_ar.arb (Arabic)
{
  "@@locale": "ar",

  "appTitle": "تطبيقي الرائع",
  "welcomeMessage": "مرحبا بك في تطبيقنا!",
  "loginButton": "تسجيل الدخول",
  "username": "اسم المستخدم",
  "password": "كلمة المرور",
  "forgotPassword": "نسيت كلمة المرور؟",
  "submitButton": "إرسال",
  "cancelButton": "إلغاء",
  "saveButton": "حفظ"
}

// app_he.arb (Hebrew)
{
  "@@locale": "he",

  "appTitle": "האפליקציה שלי",
  "welcomeMessage": "ברוכים הבאים לאפליקציה שלנו!",
  "loginButton": "התחברות",
  "username": "שם משתמש",
  "password": "סיסמה",
  "forgotPassword": "שכחת סיסמה?",
  "submitButton": "שלח",
  "cancelButton": "ביטול",
  "saveButton": "שמור"
}
```

#### Step 2: Update MaterialApp with RTL Locales

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,

          // Add RTL support
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Include RTL locales
          supportedLocales: const [
            Locale('en'),       // English (LTR)
            Locale('es'),       // Spanish (LTR)
            Locale('fr'),       // French (LTR)
            Locale('ar'),       // Arabic (RTL)
            Locale('he'),       // Hebrew (RTL)
          ],

          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}
```

### Flutter Automatically Handles RTL

When you set an RTL locale, Flutter automatically:
- Flips the layout direction
- Mirrors Row and Column alignment
- Reverses navigation drawer position
- Flips icons and images (if appropriate)
- Adjusts text alignment

```
┌────────────────────────────────────────────────────┐
│        WHAT FLUTTER FLIPS AUTOMATICALLY            │
├────────────────────────────────────────────────────┤
│                                                     │
│  ✓ Row children order                              │
│  ✓ MainAxisAlignment (start/end)                   │
│  ✓ CrossAxisAlignment (start/end)                  │
│  ✓ EdgeInsets (only EdgeInsets.start/end)          │
│  ✓ Padding direction                               │
│  ✓ Drawer position (left ↔ right)                  │
│  ✓ AppBar actions position                         │
│  ✓ ListTile leading/trailing                       │
│  ✓ Card expansion direction                        │
│  ✓ Tab bar scrolling direction                     │
│  ✓ Stepper direction                               │
│                                                     │
│  ✗ Does NOT flip:                                  │
│  - Explicit Alignment.centerLeft                   │
│  - Hardcoded TextAlign.left                        │
│  - EdgeInsets.only(left: 10)                       │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Writing RTL-Safe Code

#### Use Directional Widgets

```dart
// ❌ WRONG: Hard-coded directions
Container(
  padding: EdgeInsets.only(left: 16),  // Won't flip for RTL!
  alignment: Alignment.centerLeft,     // Won't flip for RTL!
  child: Text(
    'Hello',
    textAlign: TextAlign.left,         // Won't flip for RTL!
  ),
)

// ✓ CORRECT: Directional properties
Container(
  padding: EdgeInsetsDirectional.only(start: 16),  // Flips automatically!
  alignment: AlignmentDirectional.centerStart,     // Flips automatically!
  child: Text(
    'Hello',
    textAlign: TextAlign.start,                    // Flips automatically!
  ),
)
```

#### Visual Comparison

```
┌────────────────────────────────────────────────────┐
│          EdgeInsets vs EdgeInsetsDirectional       │
├────────────────────────────────────────────────────┤
│                                                     │
│  EdgeInsets.only(left: 16, right: 8)              │
│  LTR: [16px]Text[8px]                             │
│  RTL: [16px]Text[8px]  ← Same! Not flipped!       │
│                                                     │
│  EdgeInsetsDirectional.only(start: 16, end: 8)    │
│  LTR: [16px]Text[8px]                             │
│  RTL: [8px]Text[16px]  ← Flipped! ✓               │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Complete RTL Example

```dart
class RTLDemoScreen extends StatelessWidget {
  const RTLDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        // Actions automatically flip to the start in RTL
        actions: const [
          LanguageSelector(),
        ],
      ),

      // Drawer automatically appears on the right in RTL
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                localizations.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(localizations.homeTab),
              onTap: () {},
            ),
            // Leading/trailing automatically flip in RTL
          ],
        ),
      ),

      body: Padding(
        // Use EdgeInsetsDirectional for RTL support
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          // Use CrossAxisAlignment.start instead of .left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.welcomeMessage,
              // Use TextAlign.start instead of .left
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 32),

            // Row children automatically reverse in RTL
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: localizations.username,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.lock),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: localizations.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Align to end (right in LTR, left in RTL)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {},
                child: Text(localizations.forgotPassword),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(localizations.loginButton),
              ),
            ),

            const SizedBox(height: 32),

            // Card with directional padding
            Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  16,  // start
                  12,  // top
                  16,  // end
                  12,  // bottom
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This card content adapts to text direction',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Testing RTL Layout

```dart
// Force RTL for testing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Force RTL direction for testing
      locale: const Locale('ar'),

      // OR use this to force RTL without locale
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: const HomeScreen(),
    );
  }
}
```

## Date and Time Formatting

Different countries format dates and times differently.

### Common Date/Time Formats

```
┌────────────────────────────────────────────────────┐
│          DATE FORMATS AROUND THE WORLD             │
├────────────────────────────────────────────────────┤
│                                                     │
│  USA:        12/31/2024  (MM/DD/YYYY)              │
│  UK:         31/12/2024  (DD/MM/YYYY)              │
│  Japan:      2024/12/31  (YYYY/MM/DD)              │
│  Germany:    31.12.2024  (DD.MM.YYYY)              │
│                                                     │
│  Time:                                             │
│  USA:        3:30 PM     (12-hour)                 │
│  Europe:     15:30       (24-hour)                 │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Using intl Package for Date/Time

```dart
import 'package:intl/intl.dart';

class DateTimeFormattingExample extends StatelessWidget {
  const DateTimeFormattingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Date/Time Formatting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Locale: $locale',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            // Short date format
            _buildFormatExample(
              context,
              'Short Date',
              DateFormat.yMd(locale).format(now),
            ),

            // Long date format
            _buildFormatExample(
              context,
              'Long Date',
              DateFormat.yMMMMd(locale).format(now),
            ),

            // Date with weekday
            _buildFormatExample(
              context,
              'Date with Weekday',
              DateFormat.yMMMMEEEEd(locale).format(now),
            ),

            // Time only
            _buildFormatExample(
              context,
              'Time',
              DateFormat.jm(locale).format(now),
            ),

            // Date and time
            _buildFormatExample(
              context,
              'Date & Time',
              DateFormat.yMd(locale).add_jm().format(now),
            ),

            // Month and year
            _buildFormatExample(
              context,
              'Month & Year',
              DateFormat.yMMMM(locale).format(now),
            ),

            // Relative time (requires intl package methods)
            const SizedBox(height: 16),
            _buildFormatExample(
              context,
              'Relative',
              _getRelativeTime(now.subtract(const Duration(hours: 2)), locale),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatExample(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getRelativeTime(DateTime dateTime, String locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
```

### Output Examples

```
┌────────────────────────────────────────────────────┐
│        DATE FORMATTING OUTPUT BY LOCALE            │
├────────────────────────────────────────────────────┤
│                                                     │
│  English (en_US):                                  │
│  Short Date:         12/31/2024                    │
│  Long Date:          December 31, 2024             │
│  Date with Weekday:  Tuesday, December 31, 2024    │
│  Time:               3:30 PM                       │
│  Date & Time:        12/31/2024, 3:30 PM           │
│  Month & Year:       December 2024                 │
│                                                     │
│  Spanish (es_ES):                                  │
│  Short Date:         31/12/2024                    │
│  Long Date:          31 de diciembre de 2024       │
│  Date with Weekday:  martes, 31 de diciembre...    │
│  Time:               15:30                         │
│  Date & Time:        31/12/2024 15:30              │
│  Month & Year:       diciembre de 2024             │
│                                                     │
│  German (de_DE):                                   │
│  Short Date:         31.12.2024                    │
│  Long Date:          31. Dezember 2024             │
│  Date with Weekday:  Dienstag, 31. Dezember 2024   │
│  Time:               15:30                         │
│  Date & Time:        31.12.2024, 15:30             │
│  Month & Year:       Dezember 2024                 │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Number Formatting

Different locales format numbers differently (decimal separators, thousands separators, currency symbols).

### Number Format Differences

```
┌────────────────────────────────────────────────────┐
│        NUMBER FORMATS AROUND THE WORLD             │
├────────────────────────────────────────────────────┤
│                                                     │
│  USA (en_US):                                      │
│  Number:    1,234,567.89                           │
│  Currency:  $1,234.56                              │
│  Percent:   45.67%                                 │
│                                                     │
│  Germany (de_DE):                                  │
│  Number:    1.234.567,89                           │
│  Currency:  1.234,56 €                             │
│  Percent:   45,67 %                                │
│                                                     │
│  France (fr_FR):                                   │
│  Number:    1 234 567,89                           │
│  Currency:  1 234,56 €                             │
│  Percent:   45,67 %                                │
│                                                     │
│  Note the differences:                             │
│  - Decimal separator: . or ,                       │
│  - Thousands separator: , or . or space            │
│  - Currency symbol position                        │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Using intl for Number Formatting

```dart
import 'package:intl/intl.dart';

class NumberFormattingExample extends StatelessWidget {
  const NumberFormattingExample({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final number = 1234567.89;
    final currency = 1234.56;
    final percent = 0.4567;

    return Scaffold(
      appBar: AppBar(title: const Text('Number Formatting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Locale: $locale',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            // Decimal number
            _buildFormatExample(
              context,
              'Decimal',
              NumberFormat.decimalPattern(locale).format(number),
            ),

            // Currency - US Dollar
            _buildFormatExample(
              context,
              'Currency (USD)',
              NumberFormat.currency(locale: locale, symbol: '\$').format(currency),
            ),

            // Currency - Euro
            _buildFormatExample(
              context,
              'Currency (EUR)',
              NumberFormat.currency(locale: locale, symbol: '€').format(currency),
            ),

            // Currency with name
            _buildFormatExample(
              context,
              'Currency (Name)',
              NumberFormat.simpleCurrency(locale: locale).format(currency),
            ),

            // Percentage
            _buildFormatExample(
              context,
              'Percentage',
              NumberFormat.percentPattern(locale).format(percent),
            ),

            // Compact format (1.2M, 1.2K, etc.)
            _buildFormatExample(
              context,
              'Compact',
              NumberFormat.compact(locale: locale).format(number),
            ),

            // Compact long format
            _buildFormatExample(
              context,
              'Compact Long',
              NumberFormat.compactLong(locale: locale).format(number),
            ),

            // Custom pattern
            _buildFormatExample(
              context,
              'Custom',
              NumberFormat('#,##0.00', locale).format(number),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatExample(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
```

### Output Examples

```
┌────────────────────────────────────────────────────┐
│       NUMBER FORMATTING OUTPUT BY LOCALE           │
├────────────────────────────────────────────────────┤
│                                                     │
│  English (en_US):                                  │
│  Decimal:        1,234,567.89                      │
│  Currency (USD): $1,234.56                         │
│  Currency (EUR): €1,234.56                         │
│  Percentage:     46%                               │
│  Compact:        1.2M                              │
│  Compact Long:   1.2 million                       │
│                                                     │
│  Spanish (es_ES):                                  │
│  Decimal:        1.234.567,89                      │
│  Currency (USD): 1.234,56 $                        │
│  Currency (EUR): 1.234,56 €                        │
│  Percentage:     46 %                              │
│  Compact:        1,2 M                             │
│  Compact Long:   1,2 millones                      │
│                                                     │
│  German (de_DE):                                   │
│  Decimal:        1.234.567,89                      │
│  Currency (USD): 1.234,56 $                        │
│  Currency (EUR): 1.234,56 €                        │
│  Percentage:     46 %                              │
│  Compact:        1,2 Mio.                          │
│  Compact Long:   1,2 Millionen                     │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Plurals and Gender

Different languages have different plural rules. English has simple singular/plural, but other languages can have multiple plural forms.

### Plural Rules by Language

```
┌────────────────────────────────────────────────────┐
│            PLURAL FORMS BY LANGUAGE                │
├────────────────────────────────────────────────────┤
│                                                     │
│  English: 2 forms                                  │
│  - one:   1 item                                   │
│  - other: 0 items, 2 items, 100 items              │
│                                                     │
│  Russian: 3 forms                                  │
│  - one:   1 предмет, 21 предмет                    │
│  - few:   2 предмета, 3 предмета, 4 предмета       │
│  - other: 5 предметов, 10 предметов                │
│                                                     │
│  Arabic: 6 forms                                   │
│  - zero:  لا عناصر                                 │
│  - one:   عنصر واحد                                │
│  - two:   عنصران                                  │
│  - few:   بضعة عناصر                               │
│  - many:  عناصر كثيرة                              │
│  - other: عناصر                                    │
│                                                     │
└────────────────────────────────────────────────────┘
```

### Adding Plurals to ARB Files

```json
// app_en.arb
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },

  "minutesAgo": "{count, plural, =0{Just now} =1{1 minute ago} other{{count} minutes ago}}",
  "@minutesAgo": {
    "description": "Time elapsed in minutes",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },

  "cartSummary": "{itemCount, plural, =0{Your cart is empty} =1{You have 1 item in your cart} other{You have {itemCount} items in your cart}}",
  "@cartSummary": {
    "description": "Shopping cart summary",
    "placeholders": {
      "itemCount": {
        "type": "int"
      }
    }
  }
}

// app_es.arb
{
  "itemCount": "{count, plural, =0{Sin artículos} =1{Un artículo} other{{count} artículos}}",
  "minutesAgo": "{count, plural, =0{Justo ahora} =1{Hace 1 minuto} other{Hace {count} minutos}}",
  "cartSummary": "{itemCount, plural, =0{Tu carrito está vacío} =1{Tienes 1 artículo en tu carrito} other{Tienes {itemCount} artículos en tu carrito}}"
}

// app_ru.arb (Russian - 3 plural forms)
{
  "itemCount": "{count, plural, =0{Нет элементов} =1{Один элемент} few{{count} элемента} other{{count} элементов}}",
  "minutesAgo": "{count, plural, =0{Только что} =1{1 минуту назад} few{{count} минуты назад} other{{count} минут назад}}",
  "cartSummary": "{itemCount, plural, =0{Ваша корзина пуста} =1{В корзине 1 товар} few{В корзине {itemCount} товара} other{В корзине {itemCount} товаров}}"
}
```

### Using Plurals in Code

```dart
class PluralExample extends StatelessWidget {
  const PluralExample({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Plural Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Display different counts
          for (int count in [0, 1, 2, 5, 21, 100])
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(localizations.itemCount(count)),
                subtitle: Text('Count: $count'),
              ),
            ),

          const Divider(height: 32),

          // Minutes ago examples
          for (int minutes in [0, 1, 5, 15, 30, 60])
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(localizations.minutesAgo(minutes)),
                subtitle: Text('$minutes minutes'),
              ),
            ),

          const Divider(height: 32),

          // Cart summary examples
          for (int items in [0, 1, 3, 10])
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(localizations.cartSummary(items)),
              ),
            ),
        ],
      ),
    );
  }
}
```

### Plurals with Parameters

You can combine plurals with other parameters:

```json
// app_en.arb
{
  "itemsInCategory": "{count, plural, =0{No {category} items} =1{One {category} item} other{{count} {category} items}}",
  "@itemsInCategory": {
    "description": "Number of items in a category",
    "placeholders": {
      "count": {
        "type": "int"
      },
      "category": {
        "type": "String"
      }
    }
  },

  "userLikes": "{userName} {likeCount, plural, =0{hasn't liked any posts} =1{liked 1 post} other{liked {likeCount} posts}}",
  "@userLikes": {
    "description": "User's like count",
    "placeholders": {
      "userName": {
        "type": "String"
      },
      "likeCount": {
        "type": "int"
      }
    }
  }
}
```

Usage:

```dart
// Using plurals with multiple parameters
Text(localizations.itemsInCategory(5, 'electronics'))
// Output: "5 electronics items"

Text(localizations.userLikes('John', 3))
// Output: "John liked 3 posts"
```

## Gender-Specific Translations

Some languages require different translations based on gender.

```json
// app_en.arb
{
  "greeting": "{gender, select, male{Welcome, Mr. {name}} female{Welcome, Ms. {name}} other{Welcome, {name}}}",
  "@greeting": {
    "description": "Greeting message with gender",
    "placeholders": {
      "gender": {
        "type": "String"
      },
      "name": {
        "type": "String"
      }
    }
  },

  "taskAssigned": "{gender, select, male{He was assigned to {task}} female{She was assigned to {task}} other{They were assigned to {task}}}",
  "@taskAssigned": {
    "description": "Task assignment with gender",
    "placeholders": {
      "gender": {
        "type": "String"
      },
      "task": {
        "type": "String"
      }
    }
  }
}

// app_es.arb (Spanish has gendered nouns)
{
  "greeting": "{gender, select, male{Bienvenido, Sr. {name}} female{Bienvenida, Sra. {name}} other{Bienvenido/a, {name}}}",
  "taskAssigned": "{gender, select, male{Él fue asignado a {task}} female{Ella fue asignada a {task}} other{Fueron asignados/as a {task}}}"
}
```

Usage:

```dart
Text(localizations.greeting('male', 'John'))
// English: "Welcome, Mr. John"
// Spanish: "Bienvenido, Sr. John"

Text(localizations.greeting('female', 'Jane'))
// English: "Welcome, Ms. Jane"
// Spanish: "Bienvenida, Sra. Jane"
```

## Complete Advanced Localization Example

Let's build a complete social media post list with all advanced features:

```json
// app_en.arb
{
  "@@locale": "en",

  "postsTitle": "Social Posts",
  "newPost": "New Post",

  "postLikes": "{count, plural, =0{No likes} =1{1 like} other{{count} likes}}",
  "@postLikes": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },

  "postComments": "{count, plural, =0{No comments} =1{1 comment} other{{count} comments}}",
  "@postComments": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },

  "postTime": "Posted {time}",
  "@postTime": {
    "placeholders": {
      "time": {"type": "String"}
    }
  },

  "userAction": "{userName} {gender, select, male{liked his own post} female{liked her own post} other{liked their own post}}",
  "@userAction": {
    "placeholders": {
      "userName": {"type": "String"},
      "gender": {"type": "String"}
    }
  },

  "price": "Price: {amount}",
  "@price": {
    "placeholders": {
      "amount": {"type": "String"}
    }
  }
}

// app_es.arb
{
  "@@locale": "es",

  "postsTitle": "Publicaciones Sociales",
  "newPost": "Nueva Publicación",

  "postLikes": "{count, plural, =0{Sin me gusta} =1{1 me gusta} other{{count} me gusta}}",
  "postComments": "{count, plural, =0{Sin comentarios} =1{1 comentario} other{{count} comentarios}}",
  "postTime": "Publicado {time}",
  "userAction": "{userName} {gender, select, male{le gustó su propia publicación} female{le gustó su propia publicación} other{le gustó su propia publicación}}",
  "price": "Precio: {amount}"
}

// app_ar.arb (Arabic - RTL)
{
  "@@locale": "ar",

  "postsTitle": "المنشورات الاجتماعية",
  "newPost": "منشور جديد",

  "postLikes": "{count, plural, =0{لا إعجابات} =1{إعجاب واحد} =2{إعجابان} few{{count} إعجابات} other{{count} إعجاب}}",
  "postComments": "{count, plural, =0{لا تعليقات} =1{تعليق واحد} =2{تعليقان} few{{count} تعليقات} other{{count} تعليق}}",
  "postTime": "نُشر {time}",
  "userAction": "{userName} أعجب بمنشوره الخاص",
  "price": "السعر: {amount}"
}
```

Now the complete app:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Post model
class Post {
  final String id;
  final String userName;
  final String gender;
  final String content;
  final int likes;
  final int comments;
  final DateTime timestamp;
  final double? price;

  const Post({
    required this.id,
    required this.userName,
    required this.gender,
    required this.content,
    required this.likes,
    required this.comments,
    required this.timestamp,
    this.price,
  });
}

// Sample data
final samplePosts = [
  Post(
    id: '1',
    userName: 'Sarah',
    gender: 'female',
    content: 'Just finished my morning run! Feeling great!',
    likes: 0,
    comments: 0,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Post(
    id: '2',
    userName: 'Mike',
    gender: 'male',
    content: 'Check out this amazing sunset!',
    likes: 1,
    comments: 1,
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    price: 99.99,
  ),
  Post(
    id: '3',
    userName: 'Alex',
    gender: 'other',
    content: 'Coffee time ☕',
    likes: 15,
    comments: 3,
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Post(
    id: '4',
    userName: 'Emma',
    gender: 'female',
    content: 'New blog post is live!',
    likes: 42,
    comments: 12,
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    price: 29.99,
  ),
  Post(
    id: '5',
    userName: 'David',
    gender: 'male',
    content: 'Working on an exciting new project',
    likes: 128,
    comments: 45,
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

// Main app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('ar'),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const SocialPostsPage(),
        );
      },
    );
  }
}

class SocialPostsPage extends StatelessWidget {
  const SocialPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.postsTitle),
        actions: const [
          LanguageSelector(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsetsDirectional.all(16),
        itemCount: samplePosts.length,
        itemBuilder: (context, index) {
          return PostCard(post: samplePosts[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: Text(localizations.newPost),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  String _getRelativeTime(BuildContext context, DateTime timestamp) {
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMd(locale).add_jm().format(timestamp);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.userName[0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        localizations.postTime(_getRelativeTime(context, post.timestamp)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Post content
            Text(
              post.content,
              style: const TextStyle(fontSize: 16),
            ),

            // Price if available
            if (post.price != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  localizations.price(
                    NumberFormat.currency(
                      locale: locale,
                      symbol: locale.startsWith('en') ? '\$' : '€',
                    ).format(post.price),
                  ),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Likes and comments
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 20),
                const SizedBox(width: 4),
                Text(localizations.postLikes(post.likes)),

                const SizedBox(width: 24),

                const Icon(Icons.comment_outlined, size: 20),
                const SizedBox(width: 4),
                Text(localizations.postComments(post.comments)),
              ],
            ),

            // User action example
            if (post.likes > 0) ...[
              const SizedBox(height: 8),
              Text(
                localizations.userAction(post.userName, post.gender),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Language selector (reuse from previous examples)
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    final languages = {
      'en': '🇬🇧 English',
      'es': '🇪🇸 Español',
      'ar': '🇸🇦 العربية',
    };

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        localeProvider.setLocale(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) {
        return languages.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(entry.value),
                const Spacer(),
                if (localeProvider.locale.languageCode == entry.key)
                  const Icon(Icons.check, color: Colors.blue),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

// LocaleProvider (reuse from previous examples)
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
```

## Summary

Advanced localization handles complex scenarios:

1. **RTL Support**: Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`
2. **Date/Time Formatting**: Use `intl` package's `DateFormat` with locale
3. **Number Formatting**: Use `NumberFormat` for decimals, currency, percentages
4. **Plurals**: Handle different plural rules for different languages in ARB files
5. **Gender**: Use select syntax for gender-specific translations
6. **Testing**: Test with different locales and RTL layouts

Your app can now handle any language in the world, with proper formatting and layout!

## What's Next?

You've mastered internationalization! Next, we'll explore testing with Mockito to write better tests for your app.

---

**Previous:** [10b-MultiLanguage.md](./10b-MultiLanguage.md)
**Next:** [13a-MockitoBasics.md](../../Level-13-Testing/Theory/13a-MockitoBasics.md)
**Related:** [09a-AccessibilityBasics.md](./09a-AccessibilityBasics.md)
