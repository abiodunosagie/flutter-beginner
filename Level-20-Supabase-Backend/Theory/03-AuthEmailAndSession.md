# Auth: Email & Session

```dart
await supabase.auth.signUp(email: email, password: password);
await supabase.auth.signInWithPassword(email: email, password: password);
await supabase.auth.signOut();

final session = supabase.auth.currentSession;
final user = supabase.auth.currentUser;
```

## Listen to auth changes

```dart
supabase.auth.onAuthStateChange.listen((data) {
  final event = data.event;
  final session = data.session;
});
```

## Dashboard tip

Authentication → Providers → Email.  
For learning you may disable “Confirm email”.

## Restore on launch

`Supabase.initialize` restores session from secure storage automatically in recent versions. Still gate UI on `currentSession != null`.
