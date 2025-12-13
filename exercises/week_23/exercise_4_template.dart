/// Exercise 4: Isolates - Parallel Processing
///
/// Level: Intermediate-Advanced
///
/// Task:
/// Create an ImageProcessor class that uses Isolates to perform
/// heavy computations without blocking the main thread.
///
/// Requirements:
/// 1. Create functions that can run in isolates:
///    - int fibonacci(int n) // Calculate fibonacci number
///    - List<int> primeNumbers(int max) // Find all primes up to max
///    - String encryptText(String text) // Simple encryption
///
/// 2. Use compute() function for simple isolate tasks
/// 3. Use Isolate.spawn() for more control
/// 4. Compare performance: with/without isolates
/// 5. Handle large data processing (lists of 10000+ items)

import 'dart:isolate';

class IsolateProcessor {
  // TODO: Implement fibonacci calculation
  static int fibonacci(int n) {
    throw UnimplementedError();
  }

  // TODO: Implement prime number finder
  static List<int> primeNumbers(int max) {
    throw UnimplementedError();
  }

  // TODO: Run fibonacci in isolate using compute()
  Future<int> fibonacciInIsolate(int n) async {
    throw UnimplementedError();
  }

  // TODO: Run prime finder in isolate
  Future<List<int>> primesInIsolate(int max) async {
    throw UnimplementedError();
  }

  // TODO: Process list in parallel using multiple isolates
  Future<List<int>> processListInParallel(List<int> numbers) async {
    throw UnimplementedError();
  }
}

// Example usage:
void main() async {
  final processor = IsolateProcessor();

  print('Calculating fibonacci(40)...');
  final start = DateTime.now();

  final result = await processor.fibonacciInIsolate(40);

  final end = DateTime.now();
  print('Result: $result');
  print('Time: ${end.difference(start).inMilliseconds}ms');
}
