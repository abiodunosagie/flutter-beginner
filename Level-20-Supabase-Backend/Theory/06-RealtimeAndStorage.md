# Realtime & Storage

## Realtime (postgres changes)

```dart
final channel = supabase.channel('todos');
channel.onPostgresChanges(
  event: PostgresChangeEvent.insert,
  schema: 'public',
  table: 'todos',
  callback: (payload) {
    // update local list
  },
).subscribe();
```

Unsubscribe when leaving the screen.

## Storage

1. Create bucket `avatars`  
2. Policies on `storage.objects`  
3. Upload bytes; save public URL or path on profile row  

```dart
await supabase.storage.from('avatars').uploadBinary(path, bytes);
```
