/// Week 33, Exercise 4: Complete E-Commerce App with Flavors - SOLUTION
///
/// INTERMEDIATE-ADVANCED LEVEL
///
/// This solution demonstrates:
/// 1. Complete multi-flavor e-commerce app
/// 2. Firebase configuration per flavor (mocked)
/// 3. Payment processing with test/live modes
/// 4. Custom themes per flavor
/// 5. Feature flags and analytics integration
/// 6. Production-ready architecture
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev --dart-define=STRIPE_KEY=pk_test_dev
/// - flutter run --dart-define=FLAVOR=staging --dart-define=STRIPE_KEY=pk_test_staging
/// - flutter run --dart-define=FLAVOR=prod --dart-define=STRIPE_KEY=pk_live_prod

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

// ============================================================================
// CONFIGURATION CLASSES
// ============================================================================

enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromString(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }
}

// Firebase Configuration
class FirebaseConfig {
  final String apiKey;
  final String appId;
  final String projectId;
  final String messagingSenderId;

  FirebaseConfig({
    required this.apiKey,
    required this.appId,
    required this.projectId,
    required this.messagingSenderId,
  });

  factory FirebaseConfig.forFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return FirebaseConfig(
          apiKey: 'AIzaSy-DEV-FIREBASE-KEY',
          appId: '1:123456789:android:dev-app-id',
          projectId: 'ecommerce-app-dev',
          messagingSenderId: '123456789',
        );
      case AppFlavor.staging:
        return FirebaseConfig(
          apiKey: 'AIzaSy-STAGING-FIREBASE-KEY',
          appId: '1:987654321:android:staging-app-id',
          projectId: 'ecommerce-app-staging',
          messagingSenderId: '987654321',
        );
      case AppFlavor.prod:
        return FirebaseConfig(
          apiKey: 'AIzaSy-PROD-FIREBASE-KEY',
          appId: '1:555666777:android:prod-app-id',
          projectId: 'ecommerce-app',
          messagingSenderId: '555666777',
        );
    }
  }
}

// Payment Configuration
class PaymentConfig {
  final String stripePublishableKey;
  final String merchantId;
  final bool isTestMode;
  final String currency;
  final List<String> supportedPaymentMethods;

  PaymentConfig({
    required this.stripePublishableKey,
    required this.merchantId,
    required this.isTestMode,
    required this.currency,
    required this.supportedPaymentMethods,
  });

  factory PaymentConfig.forFlavor(AppFlavor flavor, String stripeKey) {
    switch (flavor) {
      case AppFlavor.dev:
        return PaymentConfig(
          stripePublishableKey: stripeKey.isEmpty ? 'pk_test_dev_default' : stripeKey,
          merchantId: 'merchant.dev.ecommerce',
          isTestMode: true,
          currency: 'USD',
          supportedPaymentMethods: ['card', 'paypal'],
        );
      case AppFlavor.staging:
        return PaymentConfig(
          stripePublishableKey: stripeKey.isEmpty ? 'pk_test_staging_default' : stripeKey,
          merchantId: 'merchant.staging.ecommerce',
          isTestMode: true,
          currency: 'USD',
          supportedPaymentMethods: ['card', 'paypal', 'apple_pay', 'google_pay'],
        );
      case AppFlavor.prod:
        return PaymentConfig(
          stripePublishableKey: stripeKey, // Must be provided for production
          merchantId: 'merchant.ecommerce',
          isTestMode: false,
          currency: 'USD',
          supportedPaymentMethods: ['card', 'paypal', 'apple_pay', 'google_pay'],
        );
    }
  }

  String get displayMode => isTestMode ? 'TEST MODE' : 'LIVE MODE';
}

// Theme Configuration
class AppThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String logoAsset;
  final bool showWatermark;
  final String watermarkText;

  AppThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.logoAsset,
    required this.showWatermark,
    required this.watermarkText,
  });

  factory AppThemeConfig.forFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return AppThemeConfig(
          primaryColor: Colors.red,
          secondaryColor: Colors.redAccent,
          accentColor: Colors.deepOrange,
          logoAsset: 'assets/logo_dev.png',
          showWatermark: true,
          watermarkText: 'DEV',
        );
      case AppFlavor.staging:
        return AppThemeConfig(
          primaryColor: Colors.orange,
          secondaryColor: Colors.orangeAccent,
          accentColor: Colors.deepOrange,
          logoAsset: 'assets/logo_staging.png',
          showWatermark: true,
          watermarkText: 'STAGING',
        );
      case AppFlavor.prod:
        return AppThemeConfig(
          primaryColor: Colors.blue,
          secondaryColor: Colors.blueAccent,
          accentColor: Colors.indigo,
          logoAsset: 'assets/logo.png',
          showWatermark: false,
          watermarkText: '',
        );
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Main App Configuration
class AppConfig {
  final AppFlavor flavor;
  final FirebaseConfig firebase;
  final PaymentConfig payment;
  final AppThemeConfig theme;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enableDetailedLogging;
  final String apiBaseUrl;

  AppConfig({
    required this.flavor,
    required this.firebase,
    required this.payment,
    required this.theme,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enableDetailedLogging,
    required this.apiBaseUrl,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized');
    }
    return _instance!;
  }

  static void initialize({required AppConfig config}) {
    _instance = config;
    _logConfiguration(config);
  }

  static void _logConfiguration(AppConfig config) {
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('🚀 E-Commerce App Configuration');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('Flavor: ${config.flavor.name.toUpperCase()}');
    debugPrint('API URL: ${config.apiBaseUrl}');
    debugPrint('Firebase Project: ${config.firebase.projectId}');
    debugPrint('Payment Mode: ${config.payment.displayMode}');
    debugPrint('Stripe Key: ${config.payment.stripePublishableKey.substring(0, 10)}...');
    debugPrint('Analytics: ${config.enableAnalytics ? "Enabled" : "Disabled"}');
    debugPrint('Crash Reporting: ${config.enableCrashReporting ? "Enabled" : "Disabled"}');
    debugPrint('Detailed Logging: ${config.enableDetailedLogging ? "Enabled" : "Disabled"}');
    debugPrint('═══════════════════════════════════════════════════');
  }

  bool get isProduction => flavor == AppFlavor.prod;
  bool get isDevelopment => flavor == AppFlavor.dev;
  bool get isStaging => flavor == AppFlavor.staging;
}

// ============================================================================
// MODELS
// ============================================================================

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

// ============================================================================
// SERVICES
// ============================================================================

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get itemCount => _items.length;

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
    debugPrint('🛒 Added ${product.name} to cart');
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    debugPrint('🛒 Removed item from cart');
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items[productId]!.quantity = quantity;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class PaymentService {
  final PaymentConfig config;

  PaymentService(this.config);

  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
  }) async {
    debugPrint('💳 Processing payment...');
    debugPrint('   Amount: $currency ${amount.toStringAsFixed(2)}');
    debugPrint('   Mode: ${config.displayMode}');

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    // In test mode, always succeed
    if (config.isTestMode) {
      debugPrint('✅ Test payment successful');
      return PaymentResult(
        success: true,
        transactionId: 'test_${DateTime.now().millisecondsSinceEpoch}',
        message: 'Test payment completed successfully',
      );
    }

    // In production, would call actual Stripe API
    debugPrint('✅ Payment successful');
    return PaymentResult(
      success: true,
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Payment completed successfully',
    );
  }
}

class PaymentResult {
  final bool success;
  final String transactionId;
  final String message;

  PaymentResult({
    required this.success,
    required this.transactionId,
    required this.message,
  });
}

// ============================================================================
// MAIN APP
// ============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read configuration from environment
  const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  const stripeKey = String.fromEnvironment('STRIPE_KEY', defaultValue: '');

  final flavor = AppFlavor.fromString(flavorString);

  // Initialize app configuration
  AppConfig.initialize(
    config: AppConfig(
      flavor: flavor,
      firebase: FirebaseConfig.forFlavor(flavor),
      payment: PaymentConfig.forFlavor(flavor, stripeKey),
      theme: AppThemeConfig.forFlavor(flavor),
      enableAnalytics: flavor != AppFlavor.dev,
      enableCrashReporting: flavor == AppFlavor.prod,
      enableDetailedLogging: flavor != AppFlavor.prod,
      apiBaseUrl: _getApiUrl(flavor),
    ),
  );

  // In a real app, initialize Firebase here:
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: AppConfig.instance.firebase.apiKey,
  //     appId: AppConfig.instance.firebase.appId,
  //     messagingSenderId: AppConfig.instance.firebase.messagingSenderId,
  //     projectId: AppConfig.instance.firebase.projectId,
  //   ),
  // );

  runApp(ECommerceApp());
}

String _getApiUrl(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return 'https://dev-api.ecommerce.com';
    case AppFlavor.staging:
      return 'https://staging-api.ecommerce.com';
    case AppFlavor.prod:
      return 'https://api.ecommerce.com';
  }
}

class ECommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MaterialApp(
      title: 'E-Commerce ${config.flavor.name.toUpperCase()}',
      debugShowCheckedModeBanner: !config.isProduction,
      theme: config.theme.toThemeData(),
      home: HomeScreen(),
    );
  }
}

// ============================================================================
// SCREENS
// ============================================================================

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CartService _cartService = CartService();

  // Mock products
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium noise-cancelling headphones',
      price: 299.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Electronics',
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Fitness tracker with heart rate monitor',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Electronics',
    ),
    Product(
      id: '3',
      name: 'Laptop Stand',
      description: 'Ergonomic aluminum laptop stand',
      price: 49.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Accessories',
    ),
    Product(
      id: '4',
      name: 'USB-C Cable',
      description: 'Fast charging USB-C cable 2m',
      price: 19.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Accessories',
    ),
    Product(
      id: '5',
      name: 'Bluetooth Speaker',
      description: 'Portable waterproof speaker',
      price: 89.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Electronics',
    ),
    Product(
      id: '6',
      name: 'Phone Case',
      description: 'Protective case with card holder',
      price: 24.99,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Accessories',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          // Flavor badge
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                config.flavor.name.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Cart icon
          AnimatedBuilder(
            animation: _cartService,
            builder: (context, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartService: _cartService,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_cartService.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_cartService.itemCount}',
                          style: TextStyle(
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
          ),
        ],
      ),
      body: Column(
        children: [
          // Test mode banner
          if (!config.isProduction)
            Container(
              width: double.infinity,
              color: config.theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '${config.payment.displayMode} - ${config.flavor.name.toUpperCase()} ENVIRONMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Products grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: _products[index],
                  onAddToCart: () => _cartService.addItem(_products[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: _products[index],
                          onAddToCart: () => _cartService.addItem(_products[index]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(Icons.shopping_bag, size: 48, color: Colors.grey[400]),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  child: Text('Add to Cart', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(Icons.shopping_bag, size: 100, color: Colors.grey[400]),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              onAddToCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to cart!')),
              );
            },
            child: Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final CartService cartService;

  const CartScreen({required this.cartService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: AnimatedBuilder(
        animation: cartService,
        builder: (context, child) {
          if (cartService.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartService.items.length,
                  itemBuilder: (context, index) {
                    final item = cartService.items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: Icon(Icons.shopping_bag, color: Colors.grey[400]),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$${item.product.price.toStringAsFixed(2)}',
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    cartService.updateQuantity(
                                      item.product.id,
                                      item.quantity - 1,
                                    );
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    cartService.updateQuantity(
                                      item.product.id,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
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
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${cartService.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  cartService: cartService,
                                ),
                              ),
                            );
                          },
                          child: Text('Proceed to Checkout'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final CartService cartService;

  const CheckoutScreen({required this.cartService});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;
  late PaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _paymentService = PaymentService(AppConfig.instance.payment);
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      final result = await _paymentService.processPayment(
        amount: widget.cartService.totalAmount,
        currency: AppConfig.instance.payment.currency,
      );

      if (result.success) {
        widget.cartService.clear();
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful! Transaction: ${result.transactionId}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${result.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    final paymentConfig = config.payment;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test mode warning
            if (paymentConfig.isTestMode)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TEST MODE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                            Text(
                              'No real charges will be made',
                              style: TextStyle(color: Colors.orange.shade900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16),

            // Order summary
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            AnimatedBuilder(
              animation: widget.cartService,
              builder: (context, child) {
                return Column(
                  children: [
                    ...widget.cartService.items.map((item) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('${item.product.name} x${item.quantity}'),
                            ),
                            Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }).toList(),
                    Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.cartService.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 32),

            // Payment info
            Text(
              'Payment Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Payment Mode', paymentConfig.displayMode),
                    _buildInfoRow('Currency', paymentConfig.currency),
                    _buildInfoRow('Provider', 'Stripe'),
                    _buildInfoRow(
                      'Key',
                      '${paymentConfig.stripePublishableKey.substring(0, 15)}...',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Payment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('Pay \$${widget.cartService.totalAmount.toStringAsFixed(2)}'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
