/// Exercise 5: Offline-First Architecture - Product Catalog
/// Build an offline-first product catalog with sync capabilities

// TODO: Create Product model
// TODO: Implement local cache with Hive/SQLite
// TODO: Implement API sync manager
// TODO: Handle conflicts and offline operations
// TODO: Add sync status tracking

class Product {
  String id;
  String name;
  double price;
  String description;
  DateTime? lastSynced;

  Product({required this.id, required this.name, required this.price, required this.description, this.lastSynced});
}

class ProductRepository {
  Future<void> init() async => throw UnimplementedError();
  Future<List<Product>> getProducts() async => throw UnimplementedError();
  Future<void> addProduct(Product product) async => throw UnimplementedError();
  Future<void> syncWithServer() async => throw UnimplementedError();
  bool get hasPendingChanges => throw UnimplementedError();
}
