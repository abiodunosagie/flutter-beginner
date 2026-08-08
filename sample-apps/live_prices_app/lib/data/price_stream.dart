import 'dart:async';
import 'dart:math';

class PriceTick {
  final String symbol;
  final double price;
  final DateTime at;
  const PriceTick(this.symbol, this.price, this.at);
}

/// Mock “exchange” stream. Swap for WebSocket later (App 17 tutorial).
class MockPriceFeed {
  MockPriceFeed({this.symbols = const ['BTC', 'ETH', 'SOL']});

  final List<String> symbols;
  final _random = Random();
  final _prices = <String, double>{};
  final _controller = StreamController<List<PriceTick>>.broadcast();
  Timer? _timer;
  var _connected = false;

  bool get isConnected => _connected;

  Stream<List<PriceTick>> get stream async* {
    yield _snapshot();
    yield* _controller.stream;
  }

  void connect() {
    if (_connected) return;
    _connected = true;
    for (final s in symbols) {
      _prices.putIfAbsent(s, () => 100 + _random.nextDouble() * 50);
    }
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      for (final s in symbols) {
        final delta = (_random.nextDouble() - 0.5) * 2;
        _prices[s] = (_prices[s]! + delta).clamp(1, 100000);
      }
      if (!_controller.isClosed) {
        _controller.add(_snapshot());
      }
    });
  }

  void disconnect() {
    _timer?.cancel();
    _timer = null;
    _connected = false;
  }

  List<PriceTick> _snapshot() {
    final now = DateTime.now();
    return symbols
        .map((s) => PriceTick(s, _prices[s] ?? 0, now))
        .toList(growable: false);
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
