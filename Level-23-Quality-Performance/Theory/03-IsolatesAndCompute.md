# Isolates & `compute`

Heavy JSON parse or image work on the UI isolate causes jank.

```dart
final result = await compute(parseBigJson, rawString);

List<Movie> parseBigJson(String raw) {
  // pure function top-level or static
  return ...;
}
```

## Rules

- Message must be sendable (no BuildContext)  
- Prefer `compute` for one-shot work  
- Long-running workers: full Isolate + ports  

## Lab

Parse a large mock JSON list of 5k items with and without compute; feel the frame drop.
