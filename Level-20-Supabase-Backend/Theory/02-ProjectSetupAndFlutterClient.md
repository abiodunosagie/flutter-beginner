# Project Setup & Flutter Client

## 1. Create project

1. [supabase.com](https://supabase.com) → New project  
2. Save DB password in a password manager (not in the app)  
3. Settings → API → copy **Project URL** and **anon public** key  

**Never** put `service_role` in Flutter.

## 2. Flutter package

```bash
flutter pub add supabase_flutter
```

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  runApp(const MyApp());
}
```

Run with:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

## 3. Client access

```dart
final supabase = Supabase.instance.client;
```
