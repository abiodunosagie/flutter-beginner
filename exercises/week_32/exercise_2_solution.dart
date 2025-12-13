/// Week 32, Exercise 2: AsyncNotifier Pattern
///
/// BEGINNER-INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const AsyncApp());
}

class AsyncApp extends StatelessWidget {
  const AsyncApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const DataScreen(),
    );
  }
}

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  bool _isLoading = false;
  String? _error;
  List<String> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _data = List.generate(10, (i) => 'Item ${i + 1}');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Data Pattern'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading data...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(_data[index]),
        );
      },
    );
  }
}

/*
Real Riverpod AsyncNotifier:

class DataNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    return await _fetchData();
  }

  Future<List<String>> _fetchData() async {
    // API call
    await Future.delayed(Duration(seconds: 2));
    return List.generate(10, (i) => 'Item $i');
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final dataProvider = AsyncNotifierProvider<DataNotifier, List<String>>(() {
  return DataNotifier();
});

// Usage
class DataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dataProvider);

    return asyncData.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(title: Text(data[index])),
      ),
    );
  }
}
*/
