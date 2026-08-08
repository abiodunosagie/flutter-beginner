import 'package:flutter/material.dart';

import 'data/price_stream.dart';

void main() {
  runApp(const LivePricesApp());
}

class LivePricesApp extends StatelessWidget {
  const LivePricesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Prices',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TickerPage(),
    );
  }
}

class TickerPage extends StatefulWidget {
  const TickerPage({super.key});

  @override
  State<TickerPage> createState() => _TickerPageState();
}

class _TickerPageState extends State<TickerPage> {
  late final MockPriceFeed _feed;
  final _history = <String, List<double>>{};

  @override
  void initState() {
    super.initState();
    _feed = MockPriceFeed();
    _feed.connect();
  }

  @override
  void dispose() {
    _feed.dispose();
    super.dispose();
  }

  void _record(List<PriceTick> ticks) {
    for (final t in ticks) {
      final list = _history.putIfAbsent(t.symbol, () => <double>[]);
      list.add(t.price);
      if (list.length > 40) list.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live prices'),
        actions: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(milliseconds: 300)),
            builder: (context, _) {
              final on = _feed.isConnected;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text(on ? 'Live' : 'Offline'),
                  avatar: Icon(Icons.circle, size: 12, color: on ? Colors.green : Colors.red),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PriceTick>>(
        stream: _feed.stream,
        builder: (context, snap) {
          final ticks = snap.data ?? [];
          if (ticks.isNotEmpty) _record(ticks);
          if (ticks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            itemCount: ticks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final t = ticks[index];
              final hist = _history[t.symbol] ?? const <double>[];
              final prev = hist.length > 1 ? hist[hist.length - 2] : t.price;
              final up = t.price >= prev;
              return ListTile(
                title: Text(t.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('ticks: ${hist.length}'),
                trailing: Text(
                  t.price.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: up ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _feed.disconnect());
                  },
                  child: const Text('Disconnect'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    setState(() => _feed.connect());
                  },
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
