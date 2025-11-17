/// Exercise 2 Solution: Working with Streams - Real-time Data Stream
///
/// This solution demonstrates:
/// - Creating streams with async*
/// - Stream transformations (map, where, take)
/// - Stream subscription and cancellation
/// - Error handling in streams
/// - Practical stream use cases

import 'dart:async';
import 'dart:math';

class MessageStream {
  Stream<String> generateMessages(int count) async* {
    for (int i = 0; i < count; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield 'Message ${i + 1}: Hello from stream!';
    }
  }

  Stream<int> generateNumbers(int max) async* {
    for (int i = 0; i <= max; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      yield i;
    }
  }

  Stream<double> generateStockPrices(String symbol, Duration interval) async* {
    final random = Random();
    double basePrice = 100.0;

    while (true) {
      await Future.delayed(interval);

      // Simulate price fluctuation (-5% to +5%)
      final change = (random.nextDouble() - 0.5) * 10;
      basePrice += change;

      // Keep price positive
      if (basePrice < 50) basePrice = 50;
      if (basePrice > 200) basePrice = 200;

      yield double.parse(basePrice.toStringAsFixed(2));
    }
  }

  /// Generates sensor data with occasional errors
  Stream<Map<String, dynamic>> generateSensorData() async* {
    final random = Random();
    int count = 0;

    while (true) {
      await Future.delayed(Duration(seconds: 1));
      count++;

      // Simulate error every 5 readings
      if (count % 5 == 0) {
        throw Exception('Sensor error at reading $count');
      }

      yield {
        'temperature': 20 + random.nextDouble() * 10,
        'humidity': 40 + random.nextDouble() * 30,
        'timestamp': DateTime.now().toIso8601String(),
        'reading': count,
      };
    }
  }

  /// Generates countdown stream
  Stream<int> countdown(int from) async* {
    for (int i = from; i >= 0; i--) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  /// Merges multiple streams
  Stream<String> mergeStreams(List<Stream<String>> streams) async* {
    final controllers = streams.map((s) => StreamController<String>()).toList();

    for (int i = 0; i < streams.length; i++) {
      streams[i].listen(
        (data) => controllers[i].add(data),
        onError: (error) => controllers[i].addError(error),
        onDone: () => controllers[i].close(),
      );
    }

    for (final controller in controllers) {
      await for (final data in controller.stream) {
        yield data;
      }
    }
  }
}

// Example usage:
void main() async {
  final messageStream = MessageStream();

  print('=== Example 1: Basic Message Stream ===');
  await for (final message in messageStream.generateMessages(3)) {
    print(message);
  }

  print('\n=== Example 2: Number Stream with Filtering ===');
  final subscription = messageStream.generateNumbers(10)
      .where((num) => num % 2 == 0)
      .map((num) => num * 2)
      .listen(
        (num) => print('Transformed even number: $num'),
        onDone: () => print('Number stream completed'),
      );

  await Future.delayed(Duration(seconds: 6));
  await subscription.cancel();

  print('\n=== Example 3: Stock Price Stream ===');
  final stockSubscription = messageStream
      .generateStockPrices('AAPL', Duration(seconds: 1))
      .take(5)
      .listen(
        (price) => print('AAPL: \$$price'),
        onDone: () => print('Stock stream completed'),
      );

  await Future.delayed(Duration(seconds: 6));

  print('\n=== Example 4: Stream with Error Handling ===');
  final sensorSubscription = messageStream.generateSensorData().listen(
    (data) {
      print('Temperature: ${data['temperature'].toStringAsFixed(1)}°C, '
          'Humidity: ${data['humidity'].toStringAsFixed(1)}%, '
          'Reading: ${data['reading']}');
    },
    onError: (error) {
      print('ERROR: $error');
    },
    cancelOnError: false,
  );

  await Future.delayed(Duration(seconds: 7));
  await sensorSubscription.cancel();

  print('\n=== Example 5: Countdown Stream ===');
  await for (final second in messageStream.countdown(5)) {
    if (second == 0) {
      print('Blast off!');
    } else {
      print('T-minus $second...');
    }
  }

  print('\n=== Example 6: Stream Transformations ===');
  messageStream.generateNumbers(20)
      .where((n) => n > 5)
      .take(5)
      .map((n) => n * n)
      .listen(
        (squared) => print('Squared: $squared'),
        onDone: () => print('Transformation complete'),
      );

  await Future.delayed(Duration(seconds: 12));
}
