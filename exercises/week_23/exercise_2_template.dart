/// Exercise 2: Working with Streams - Real-time Data Stream
///
/// Level: Beginner-Intermediate
///
/// Task:
/// Create a MessageStream class that generates streams of data,
/// simulating real-time messaging, stock prices, or sensor data.
///
/// Requirements:
/// 1. Create MessageStream class with methods:
///    - Stream<String> generateMessages(int count)
///    - Stream<int> generateNumbers(int max)
///    - Stream<double> generateStockPrices(String symbol, Duration interval)
///
/// 2. Practice Stream operations:
///    - listen() to consume stream data
///    - map() to transform stream data
///    - where() to filter stream data
///    - take() to limit stream items
///
/// 3. Handle stream errors
/// 4. Implement stream cancellation
/// 5. Use async* for generating streams

class MessageStream {
  // TODO: Implement generateMessages
  // Generates count messages with 1 second intervals
  Stream<String> generateMessages(int count) async* {
    throw UnimplementedError();
  }

  // TODO: Implement generateNumbers
  // Generates numbers 0 to max with delays
  Stream<int> generateNumbers(int max) async* {
    throw UnimplementedError();
  }

  // TODO: Implement generateStockPrices
  // Generates random stock prices at specified intervals
  Stream<double> generateStockPrices(String symbol, Duration interval) async* {
    throw UnimplementedError();
  }
}

// Example usage:
void main() async {
  final messageStream = MessageStream();

  print('Listening to messages...');
  await for (final message in messageStream.generateMessages(5)) {
    print('Received: $message');
  }

  print('\nListening to numbers...');
  messageStream.generateNumbers(10)
      .where((num) => num % 2 == 0)  // Filter even numbers
      .listen((num) {
        print('Even number: $num');
      });

  await Future.delayed(Duration(seconds: 6));
}
