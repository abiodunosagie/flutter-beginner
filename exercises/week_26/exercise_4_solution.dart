/// Exercise 4 Solution: Deep Linking - Handle Web URLs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router, title: 'Deep Linking Demo');
  }

  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', name: 'home', builder: (context, state) => HomeScreen()),
      GoRoute(
        path: '/products/:id',
        name: 'product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final category = state.uri.queryParameters['category'];
          final sort = state.uri.queryParameters['sort'];
          return ProductScreen(id: id, category: category, sort: sort);
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          final filter = state.uri.queryParameters['filter'] ?? 'all';
          return SearchScreen(query: query, filter: filter);
        },
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deep Linking Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => context.push('/products/123?category=electronics&sort=price'), child: Text('Product with Query Params')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.push('/search?q=flutter&filter=new'), child: Text('Search with Query Params')),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final String id;
  final String? category;
  final String? sort;

  const ProductScreen({required this.id, this.category, this.sort});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product ID: $id', style: TextStyle(fontSize: 20)),
            if (category != null) Text('Category: $category'),
            if (sort != null) Text('Sort: $sort'),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final String query;
  final String filter;

  const SearchScreen({required this.query, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Query: "$query"', style: TextStyle(fontSize: 20)),
            Text('Filter: $filter'),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());
