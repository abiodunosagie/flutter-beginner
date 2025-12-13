/// Exercise 5 Solution: Offline-First Architecture - Product Catalog

import 'dart:convert';
import 'package:hive/hive.dart';

class Product {
  String id;
  String name;
  double price;
  String description;
  DateTime? lastSynced;
  bool needsSync;

  Product({required this.id, required this.name, required this.price, required this.description, this.lastSynced, this.needsSync = false});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price, 'description': description, 'lastSynced': lastSynced?.toIso8601String(), 'needsSync': needsSync};
  factory Product.fromJson(Map<String, dynamic> json) => Product(id: json['id'], name: json['name'], price: json['price'], description: json['description'], lastSynced: json['lastSynced'] != null ? DateTime.parse(json['lastSynced']) : null, needsSync: json['needsSync'] ?? false);
}

class ProductRepository {
  late Box<String> _productsBox;

  Future<void> init() async {
    _productsBox = await Hive.openBox<String>('products');
  }

  Future<List<Product>> getProducts() async {
    return _productsBox.values.map((json) => Product.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addProduct(Product product) async {
    product.needsSync = true;
    await _productsBox.put(product.id, jsonEncode(product.toJson()));
  }

  Future<void> syncWithServer() async {
    final products = await getProducts();
    final toSync = products.where((p) => p.needsSync).toList();

    for (final product in toSync) {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 100));
      product.lastSynced = DateTime.now();
      product.needsSync = false;
      await _productsBox.put(product.id, jsonEncode(product.toJson()));
    }
  }

  bool get hasPendingChanges {
    final products = _productsBox.values.map((json) => Product.fromJson(jsonDecode(json))).toList();
    return products.any((p) => p.needsSync);
  }
}
