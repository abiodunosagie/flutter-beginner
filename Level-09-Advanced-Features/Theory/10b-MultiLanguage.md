# Multi-Language Support in Flutter

## Think of It Like This (5-Year-Old Explanation)

Imagine you have a magic storybook that changes the words based on who's reading it:

```
┌─────────────────────────────────────┐
│   THE MAGIC MULTI-LANGUAGE BOOK     │
├─────────────────────────────────────┤
│                                     │
│  English Reader:                    │
│  ┌──────────────────┐              │
│  │ "Hello, Friend!" │              │
│  └──────────────────┘              │
│                                     │
│  Spanish Reader:                    │
│  ┌──────────────────┐              │
│  │ "¡Hola, Amigo!"  │              │
│  └──────────────────┘              │
│                                     │
│  French Reader:                     │
│  ┌──────────────────┐              │
│  │ "Bonjour, Ami!"  │              │
│  └──────────────────┘              │
│                                     │
│  Same book, different words!        │
└─────────────────────────────────────┘
```

Your Flutter app works the same way. You have ONE app, but it shows different words depending on what language the user speaks. The app looks at their phone's language and says, "Oh, you speak Spanish? Let me show you Spanish words!"

## What is Multi-Language Support?

Multi-language support (also called localization or l10n) means your app can show text in different languages. Instead of hardcoding text like "Hello" in your app, you create a translation file for each language.

### How It Works

```
┌──────────────────────────────────────────────────────┐
│                   YOUR FLUTTER APP                    │
├──────────────────────────────────────────────────────┤
│                                                       │
│  User's Phone Language: Spanish                      │
│  App Checks Translation Files...                     │
│                                                       │
│  ┌────────────────┐  ┌────────────────┐            │
│  │  English File  │  │  Spanish File  │  ← Picks   │
│  │  "Welcome"     │  │  "Bienvenido"  │    This!   │
│  └────────────────┘  └────────────────┘            │
│                                                       │
│  Shows: "Bienvenido" on Screen                       │
└──────────────────────────────────────────────────────┘
```

## Setting Up ARB Files

ARB (Application Resource Bundle) files are JSON files that contain your translations.

### Step 1: Create the l10n Directory

First, create a folder structure:

```
your_app/
├── lib/
│   └── main.dart
├── l10n/                    ← Create this folder
│   ├── app_en.arb          ← English translations
│   ├── app_es.arb          ← Spanish translations
│   ├── app_fr.arb          ← French translations
│   └── app_de.arb          ← German translations
└── pubspec.yaml
```

### Step 2: Configure pubspec.yaml

Update your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

# Add this section at the root level (not under dependencies)
flutter:
  generate: true  # This tells Flutter to generate localization code

  uses-material-design: true
```

### Step 3: Create l10n.yaml Configuration File

Create a file called `l10n.yaml` in your project root:

```yaml
# l10n.yaml
arb-dir: l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

This tells Flutter:
- Where to find ARB files (`l10n` folder)
- Which file is the template (English is usually the default)
- What to name the generated Dart file

### Visual Overview

```
┌────────────────────────────────────────────────────┐
│            LOCALIZATION SETUP FLOW                  │
├────────────────────────────────────────────────────┤
│                                                     │
│  1. Create l10n/ folder                            │
│     ↓                                               │
│  2. Add ARB files (app_en.arb, app_es.arb, etc.)  │
│     ↓                                               │
│  3. Configure pubspec.yaml (flutter: generate)     │
│     ↓                                               │
│  4. Create l10n.yaml config                        │
│     ↓                                               │
│  5. Run: flutter gen-l10n                          │
│     ↓                                               │
│  6. Flutter generates code automatically!           │
│     Creates: .dart_tool/flutter_gen/gen_l10n/      │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Creating ARB Files

### app_en.arb (English - Template)

```json
{
  "@@locale": "en",

  "appTitle": "My Awesome App",
  "@appTitle": {
    "description": "The title of the application"
  },

  "welcomeMessage": "Welcome to our app!",
  "@welcomeMessage": {
    "description": "Welcome message shown on home screen"
  },

  "loginButton": "Login",
  "@loginButton": {
    "description": "Text for the login button"
  },

  "username": "Username",
  "@username": {
    "description": "Label for username field"
  },

  "password": "Password",
  "@password": {
    "description": "Label for password field"
  },

  "forgotPassword": "Forgot Password?",
  "@forgotPassword": {
    "description": "Link text for password recovery"
  },

  "emailLabel": "Email Address",
  "@emailLabel": {
    "description": "Label for email input field"
  },

  "submitButton": "Submit",
  "@submitButton": {
    "description": "Generic submit button text"
  },

  "cancelButton": "Cancel",
  "@cancelButton": {
    "description": "Generic cancel button text"
  },

  "saveButton": "Save",
  "@saveButton": {
    "description": "Generic save button text"
  }
}
```

### Understanding ARB Format

```
┌──────────────────────────────────────────────────┐
│           ARB FILE STRUCTURE                      │
├──────────────────────────────────────────────────┤
│                                                   │
│  "key": "Translation text"    ← Actual text      │
│  "@key": {                    ← Metadata         │
│    "description": "What this text is for"        │
│  }                                                │
│                                                   │
│  Why use @key metadata?                          │
│  - Helps translators understand context          │
│  - Documents what each string is used for        │
│  - Makes translation easier and more accurate    │
│                                                   │
└──────────────────────────────────────────────────┘
```

### app_es.arb (Spanish)

```json
{
  "@@locale": "es",

  "appTitle": "Mi Aplicación Increíble",
  "welcomeMessage": "¡Bienvenido a nuestra aplicación!",
  "loginButton": "Iniciar Sesión",
  "username": "Nombre de Usuario",
  "password": "Contraseña",
  "forgotPassword": "¿Olvidaste tu Contraseña?",
  "emailLabel": "Correo Electrónico",
  "submitButton": "Enviar",
  "cancelButton": "Cancelar",
  "saveButton": "Guardar"
}
```

### app_fr.arb (French)

```json
{
  "@@locale": "fr",

  "appTitle": "Mon Application Géniale",
  "welcomeMessage": "Bienvenue dans notre application!",
  "loginButton": "Connexion",
  "username": "Nom d'utilisateur",
  "password": "Mot de passe",
  "forgotPassword": "Mot de passe oublié?",
  "emailLabel": "Adresse Email",
  "submitButton": "Soumettre",
  "cancelButton": "Annuler",
  "saveButton": "Enregistrer"
}
```

### app_de.arb (German)

```json
{
  "@@locale": "de",

  "appTitle": "Meine Tolle App",
  "welcomeMessage": "Willkommen in unserer App!",
  "loginButton": "Anmelden",
  "username": "Benutzername",
  "password": "Passwort",
  "forgotPassword": "Passwort vergessen?",
  "emailLabel": "E-Mail-Adresse",
  "submitButton": "Einreichen",
  "cancelButton": "Abbrechen",
  "saveButton": "Speichern"
}
```

## Generating Localization Code

After creating ARB files, run:

```bash
flutter gen-l10n
```

This command generates Dart code from your ARB files. Flutter creates:
- `AppLocalizations` class with all your translations
- Delegate classes for MaterialApp
- Type-safe access to your strings

```
┌────────────────────────────────────────────────────┐
│         WHAT HAPPENS WHEN YOU RUN gen-l10n         │
├────────────────────────────────────────────────────┤
│                                                     │
│  Input: ARB Files                                  │
│  ┌──────────────┐                                  │
│  │ app_en.arb   │                                  │
│  │ app_es.arb   │                                  │
│  │ app_fr.arb   │                                  │
│  └──────────────┘                                  │
│         ↓                                           │
│  Flutter Generator                                  │
│  ┌──────────────────────────────┐                 │
│  │ Reads all ARB files          │                 │
│  │ Creates Dart classes         │                 │
│  │ Generates type-safe code     │                 │
│  └──────────────────────────────┘                 │
│         ↓                                           │
│  Output: Generated Code                            │
│  .dart_tool/flutter_gen/gen_l10n/                  │
│  ┌──────────────────────────────┐                 │
│  │ app_localizations.dart       │                 │
│  │ app_localizations_en.dart    │                 │
│  │ app_localizations_es.dart    │                 │
│  │ app_localizations_fr.dart    │                 │
│  └──────────────────────────────┘                 │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Using Localizations in Your App

### Basic Setup in main.dart

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
      // Set up localization
      localizationsDelegates: const [
        AppLocalizations.delegate,           // Your app's translations
        GlobalMaterialLocalizations.delegate, // Material widgets translations
        GlobalWidgetsLocalizations.delegate,  // Widget translations
        GlobalCupertinoLocalizations.delegate, // iOS widgets translations
      ],

      // Supported languages
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
      ],

      // App title (will use device locale automatically)
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
```

### Using Translations in Widgets

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              localizations.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 32),

            // Login form
            TextField(
              decoration: InputDecoration(
                labelText: localizations.username,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations.password,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
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
          ],
        ),
      ),
    );
  }
}
```

### Visual Flow

```
┌──────────────────────────────────────────────────┐
│        HOW YOUR APP USES TRANSLATIONS            │
├──────────────────────────────────────────────────┤
│                                                   │
│  1. App Starts                                   │
│     ↓                                             │
│  2. MaterialApp checks device locale             │
│     "Device is set to Spanish"                   │
│     ↓                                             │
│  3. MaterialApp loads app_es.arb                 │
│     ↓                                             │
│  4. Widget needs text:                           │
│     AppLocalizations.of(context)!.loginButton    │
│     ↓                                             │
│  5. System returns: "Iniciar Sesión"            │
│     ↓                                             │
│  6. Text displays in Spanish!                    │
│                                                   │
└──────────────────────────────────────────────────┘
```

## Language Switching

Let's create a complete example where users can switch languages in the app.

### Step 1: Create a Locale Provider

```dart
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
  ];
}
```

### Step 2: Update main.dart with Provider

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
          // Use the locale from provider
          locale: localeProvider.locale,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: LocaleProvider.supportedLocales,

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

### Step 3: Create Language Selector Widget

First, add these to your ARB files:

```json
// app_en.arb
{
  "language": "Language",
  "@language": {
    "description": "Label for language selection"
  },

  "languageEnglish": "English",
  "languageSpanish": "Spanish",
  "languageFrench": "French",
  "languageGerman": "German"
}

// app_es.arb
{
  "language": "Idioma",
  "languageEnglish": "Inglés",
  "languageSpanish": "Español",
  "languageFrench": "Francés",
  "languageGerman": "Alemán"
}

// app_fr.arb
{
  "language": "Langue",
  "languageEnglish": "Anglais",
  "languageSpanish": "Espagnol",
  "languageFrench": "Français",
  "languageGerman": "Allemand"
}

// app_de.arb
{
  "language": "Sprache",
  "languageEnglish": "Englisch",
  "languageSpanish": "Spanisch",
  "languageFrench": "Französisch",
  "languageGerman": "Deutsch"
}
```

Now create the language selector:

```dart
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Map of language codes to display names
    final languages = {
      'en': localizations.languageEnglish,
      'es': localizations.languageSpanish,
      'fr': localizations.languageFrench,
      'de': localizations.languageGerman,
    };

    // Map of language codes to flag emojis
    final flags = {
      'en': '🇬🇧',
      'es': '🇪🇸',
      'fr': '🇫🇷',
      'de': '🇩🇪',
    };

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: localizations.language,
      onSelected: (String languageCode) {
        localeProvider.setLocale(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) {
        return languages.entries.map((entry) {
          final code = entry.key;
          final name = entry.value;
          final flag = flags[code] ?? '';

          return PopupMenuItem<String>(
            value: code,
            child: Row(
              children: [
                Text(
                  flag,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Text(name),
                const Spacer(),
                if (localeProvider.locale.languageCode == code)
                  const Icon(Icons.check, color: Colors.blue),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
```

### Step 4: Add Language Selector to Your App

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: const [
          LanguageSelector(), // Add language selector to app bar
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 32),

            TextField(
              decoration: InputDecoration(
                labelText: localizations.username,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations.password,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
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
          ],
        ),
      ),
    );
  }
}
```

### Visual Flow of Language Switching

```
┌────────────────────────────────────────────────────┐
│          LANGUAGE SWITCHING FLOW                    │
├────────────────────────────────────────────────────┤
│                                                     │
│  1. User taps language selector                    │
│     ┌─────────────┐                                │
│     │ 🇬🇧 English  │                                │
│     │ 🇪🇸 Spanish  │ ← User selects Spanish         │
│     │ 🇫🇷 French   │                                │
│     │ 🇩🇪 German   │                                │
│     └─────────────┘                                │
│                                                     │
│  2. LocaleProvider.setLocale(Locale('es'))        │
│     ↓                                               │
│  3. notifyListeners() called                       │
│     ↓                                               │
│  4. Consumer rebuilds MaterialApp                  │
│     ↓                                               │
│  5. MaterialApp loads app_es.arb                   │
│     ↓                                               │
│  6. All widgets rebuild with Spanish text!         │
│                                                     │
│     "Login" → "Iniciar Sesión"                     │
│     "Username" → "Nombre de Usuario"               │
│     "Password" → "Contraseña"                      │
│                                                     │
└────────────────────────────────────────────────────┘
```

## Complete Multi-Language Shopping App Example

Let's build a complete shopping app with multi-language support.

### ARB Files for Shopping App

```json
// app_en.arb
{
  "@@locale": "en",

  "appTitle": "Shopping App",
  "homeTab": "Home",
  "cartTab": "Cart",
  "profileTab": "Profile",

  "featuredProducts": "Featured Products",
  "addToCart": "Add to Cart",
  "removeFromCart": "Remove from Cart",

  "myCart": "My Cart",
  "emptyCart": "Your cart is empty",
  "startShopping": "Start Shopping",
  "total": "Total",
  "checkout": "Checkout",

  "productLaptop": "Gaming Laptop",
  "productPhone": "Smartphone",
  "productHeadphones": "Wireless Headphones",
  "productWatch": "Smart Watch",

  "currency": "$",

  "itemsInCart": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemsInCart": {
    "description": "Number of items in cart",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}

// app_es.arb
{
  "@@locale": "es",

  "appTitle": "Aplicación de Compras",
  "homeTab": "Inicio",
  "cartTab": "Carrito",
  "profileTab": "Perfil",

  "featuredProducts": "Productos Destacados",
  "addToCart": "Añadir al Carrito",
  "removeFromCart": "Eliminar del Carrito",

  "myCart": "Mi Carrito",
  "emptyCart": "Tu carrito está vacío",
  "startShopping": "Comenzar a Comprar",
  "total": "Total",
  "checkout": "Pagar",

  "productLaptop": "Portátil para Juegos",
  "productPhone": "Teléfono Inteligente",
  "productHeadphones": "Auriculares Inalámbricos",
  "productWatch": "Reloj Inteligente",

  "currency": "€",

  "itemsInCart": "{count, plural, =0{Sin artículos} =1{1 artículo} other{{count} artículos}}"
}

// app_fr.arb
{
  "@@locale": "fr",

  "appTitle": "Application d'Achat",
  "homeTab": "Accueil",
  "cartTab": "Panier",
  "profileTab": "Profil",

  "featuredProducts": "Produits en Vedette",
  "addToCart": "Ajouter au Panier",
  "removeFromCart": "Retirer du Panier",

  "myCart": "Mon Panier",
  "emptyCart": "Votre panier est vide",
  "startShopping": "Commencer les Achats",
  "total": "Total",
  "checkout": "Commander",

  "productLaptop": "Ordinateur Portable de Jeu",
  "productPhone": "Smartphone",
  "productHeadphones": "Écouteurs Sans Fil",
  "productWatch": "Montre Intelligente",

  "currency": "€",

  "itemsInCart": "{count, plural, =0{Aucun article} =1{1 article} other{{count} articles}}"
}
```

### Product Model

```dart
class Product {
  final String id;
  final String nameKey; // Key for localized name
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.nameKey,
    required this.price,
    required this.imageUrl,
  });
}

// Sample products
final sampleProducts = [
  Product(
    id: '1',
    nameKey: 'productLaptop',
    price: 999.99,
    imageUrl: '💻',
  ),
  Product(
    id: '2',
    nameKey: 'productPhone',
    price: 699.99,
    imageUrl: '📱',
  ),
  Product(
    id: '3',
    nameKey: 'productHeadphones',
    price: 199.99,
    imageUrl: '🎧',
  ),
  Product(
    id: '4',
    nameKey: 'productWatch',
    price: 299.99,
    imageUrl: '⌚',
  ),
];
```

### Cart Provider

```dart
import 'package:flutter/foundation.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

### Main App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
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
          supportedLocales: LocaleProvider.supportedLocales,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const ShoppingHomePage(),
        );
      },
    );
  }
}
```

### Shopping Home Page

```dart
class ShoppingHomePage extends StatefulWidget {
  const ShoppingHomePage({super.key});

  @override
  State<ShoppingHomePage> createState() => _ShoppingHomePageState();
}

class _ShoppingHomePageState extends State<ShoppingHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final pages = [
      const ProductListPage(),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: const [
          CartBadge(),
          SizedBox(width: 8),
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: localizations.cartTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.profileTab,
          ),
        ],
      ),
    );
  }
}
```

### Cart Badge

```dart
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to cart
              },
            ),
            if (cart.totalQuantity > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cart.totalQuantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
```

### Product List Page

```dart
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localizations.featuredProducts,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...sampleProducts.map((product) => ProductCard(product: product)),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  String _getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Use reflection-like approach to get localized name
    switch (product.nameKey) {
      case 'productLaptop':
        return localizations.productLaptop;
      case 'productPhone':
        return localizations.productPhone;
      case 'productHeadphones':
        return localizations.productHeadphones;
      case 'productWatch':
        return localizations.productWatch;
      default:
        return product.nameKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product image (emoji)
            Text(
              product.imageUrl,
              style: const TextStyle(fontSize: 48),
            ),

            const SizedBox(width: 16),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLocalizedName(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${localizations.currency}${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Add to cart button
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final isInCart = cartProvider.items.containsKey(product.id);

                return ElevatedButton.icon(
                  onPressed: () {
                    if (isInCart) {
                      cartProvider.removeItem(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.removeFromCart),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      cartProvider.addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.addToCart),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                  label: Text(isInCart ? localizations.removeFromCart : localizations.addToCart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

### Cart Page

```dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.itemCount == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.emptyCart,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to home
                  },
                  child: Text(localizations.startShopping),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: cart.items.values.map((item) {
                  return CartItemCard(item: item);
                }).toList(),
              ),
            ),

            // Total and checkout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.total,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${localizations.currency}${cart.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Checkout logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          localizations.checkout,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  String _getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (item.product.nameKey) {
      case 'productLaptop':
        return localizations.productLaptop;
      case 'productPhone':
        return localizations.productPhone;
      case 'productHeadphones':
        return localizations.productHeadphones;
      case 'productWatch':
        return localizations.productWatch;
      default:
        return item.product.nameKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              item.product.imageUrl,
              style: const TextStyle(fontSize: 48),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLocalizedName(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${localizations.currency}${item.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    cart.decreaseQuantity(item.product.id);
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.red,
                ),

                Text(
                  '${item.quantity}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                IconButton(
                  onPressed: () {
                    cart.addItem(item.product);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.green,
                ),
              ],
            ),

            // Item total
            Text(
              '${localizations.currency}${item.totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Profile Page (Placeholder)

```dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Text(
        localizations.profileTab,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
```

## Testing Your Multi-Language App

### Test on Different Locales

```dart
// In your tests
testWidgets('App displays correct language', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      home: const HomeScreen(),
    ),
  );

  await tester.pumpAndSettle();

  // Verify Spanish text appears
  expect(find.text('Bienvenido'), findsOneWidget);
});
```

## Common Mistakes and How to Avoid Them

### Mistake 1: Forgetting to Run gen-l10n

```
❌ WRONG: Making changes to ARB files but not regenerating code

✓ CORRECT: Always run after ARB changes
flutter gen-l10n
```

### Mistake 2: Hardcoding Text

```dart
❌ WRONG:
Text('Hello')

✓ CORRECT:
Text(AppLocalizations.of(context)!.greeting)
```

### Mistake 3: Not Handling Null Locale

```dart
❌ WRONG:
AppLocalizations.of(context).title  // Might be null

✓ CORRECT:
AppLocalizations.of(context)!.title  // Assert non-null
```

### Mistake 4: Missing Translations

```
❌ WRONG: Adding key to app_en.arb but forgetting app_es.arb

✓ CORRECT: Add the same key to ALL language files
```

## Summary

Multi-language support lets your app speak many languages:

1. Create ARB files for each language
2. Run `flutter gen-l10n` to generate code
3. Configure MaterialApp with localization delegates
4. Use `AppLocalizations.of(context)!.key` to get translations
5. Add language selector for users to switch languages
6. Test with different locales

Your app is now ready to reach users around the world in their own language!

## What's Next?

In the next guide, we'll explore advanced localization topics like RTL (Right-to-Left) support, date and number formatting, and handling plurals.

---

**Previous:** [10a-i18nBasics.md](./10a-i18nBasics.md)
**Next:** [10c-LocalizationAdvanced.md](./10c-LocalizationAdvanced.md)
**Related:** [09a-AccessibilityBasics.md](./09a-AccessibilityBasics.md)
