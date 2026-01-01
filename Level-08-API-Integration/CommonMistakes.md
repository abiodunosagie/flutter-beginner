# Level 08: Common Mistakes

Learn from these common API integration errors!

---

## Mistake #1: Not Handling Async Properly

```dart
// ❌ WRONG - Blocks UI
@override
void initState() {
  super.initState();
  final products = api.getProducts();  // Missing await!
  setState(() => this.products = products);  // products is a Future, not List!
}

// ✅ RIGHT
@override
void initState() {
  super.initState();
  loadProducts();
}

Future<void> loadProducts() async {
  final products = await api.getProducts();
  setState(() => this.products = products);
}
```

---

## Mistake #2: Forgetting Loading State

```dart
// ❌ WRONG - User sees empty screen
@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: products.length,  // Empty on first build!
    itemBuilder: ...
  );
}

// ✅ RIGHT - Show loading indicator
@override
Widget build(BuildContext context) {
  if (isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return ListView.builder(...);
}
```

---

## Mistake #3: Not Handling Errors

```dart
// ❌ WRONG - App crashes on error
Future<void> loadProducts() async {
  final products = await api.getProducts();  // What if this fails?
  setState(() => this.products = products);
}

// ✅ RIGHT
Future<void> loadProducts() async {
  try {
    setState(() => isLoading = true);
    final products = await api.getProducts();
    setState(() {
      this.products = products;
      error = null;
    });
  } catch (e) {
    setState(() => error = e.toString());
  } finally {
    setState(() => isLoading = false);
  }
}
```

---

## Mistake #4: Wrong JSON Key Access

```dart
// ❌ WRONG - Typo in key name
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    name: json['titel'],  // Typo! Should be 'title'
  );
}

// ✅ RIGHT - Match API exactly
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    name: json['title'],
  );
}
```

**Tip:** Print or log the JSON to see exact key names.

---

## Mistake #5: Type Casting Errors

```dart
// ❌ WRONG - API returns num, not double
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    price: json['price'],  // Might be int or double!
  );
}

// ✅ RIGHT - Handle both int and double
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    price: (json['price'] as num).toDouble(),
  );
}
```

---

## Mistake #6: Hardcoded URLs

```dart
// ❌ WRONG - Hardcoded in every request
final response = await dio.get('https://api.example.com/products');
final response2 = await dio.get('https://api.example.com/users');

// ✅ RIGHT - Use baseUrl
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
));

final response = await dio.get('/products');
final response2 = await dio.get('/users');
```

---

## Mistake #7: Not Checking Response Status

```dart
// ❌ WRONG - Assuming success
final response = await dio.get('/products');
final products = response.data;  // What if error response?

// ✅ RIGHT - Dio throws on error status by default
// But for custom handling:
final response = await dio.get('/products');
if (response.statusCode == 200) {
  final products = response.data;
} else {
  throw ApiException('Failed to load products');
}
```

---

## Mistake #8: Memory Leaks with Async

```dart
// ❌ WRONG - setState after dispose
Future<void> loadProducts() async {
  final products = await api.getProducts();
  setState(() => this.products = products);  // Widget might be gone!
}

// ✅ RIGHT - Check mounted
Future<void> loadProducts() async {
  final products = await api.getProducts();
  if (mounted) {
    setState(() => this.products = products);
  }
}
```

---

## Mistake #9: Parsing List Wrong

```dart
// ❌ WRONG
factory Product.fromJsonList(dynamic json) {
  return json.map((item) => Product.fromJson(item)).toList();
  // Returns Iterable, not List<Product>!
}

// ✅ RIGHT
static List<Product> fromJsonList(List<dynamic> json) {
  return json.map((item) => Product.fromJson(item)).toList();
}

// Or more explicitly
static List<Product> fromJsonList(List<dynamic> json) {
  return json
      .map<Product>((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
}
```

---

## Mistake #10: No Timeout Configuration

```dart
// ❌ WRONG - Default timeout might be too long
final dio = Dio();
final response = await dio.get('/products');  // Could hang forever

// ✅ RIGHT - Set reasonable timeouts
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  sendTimeout: Duration(seconds: 10),
));
```

---

## Quick Reference: HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | OK | Process response |
| 201 | Created | Item created successfully |
| 400 | Bad Request | Check your request data |
| 401 | Unauthorized | Login required |
| 403 | Forbidden | No permission |
| 404 | Not Found | Resource doesn't exist |
| 500 | Server Error | Try again later |

---

**Still stuck? Re-read the Theory files or ask for help!**
