# CRUD from Flutter

```dart
// Create
await supabase.from('todos').insert({
  'title': title,
  'user_id': supabase.auth.currentUser!.id,
});

// Read
final rows = await supabase
  .from('todos')
  .select()
  .order('inserted_at', ascending: false);

// Update
await supabase.from('todos').update({'is_complete': true}).eq('id', id);

// Delete
await supabase.from('todos').delete().eq('id', id);
```

Map JSON maps into typed models in a repository layer (same as Level 08).
