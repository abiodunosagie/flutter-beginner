import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/catalog_page.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const ShopCartApp());
}

class ShopCartApp extends StatelessWidget {
  const ShopCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'ShopCart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const CatalogPage(),
      ),
    );
  }
}
