/// Exercise 4 Solution: Isolates - Parallel Processing
///
/// This solution demonstrates:
/// - Using compute() for simple isolate tasks
/// - Using Isolate.spawn() for more control
/// - Performance comparison with/without isolates
/// - Parallel processing with multiple isolates
/// - Proper error handling in isolates

import 'dart:isolate';
import 'dart:async';
import 'package:flutter/foundation.dart';

class IsolateProcessor {
  // Heavy computation: Fibonacci (intentionally inefficient for demo)
  static int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }

  // Find all prime numbers up to max
  static List<int> primeNumbers(int max) {
    final primes = <int>[];

    for (int i = 2; i <= max; i++) {
      bool isPrime = true;

      for (int j = 2; j <= i ~/ 2; j++) {
        if (i % j == 0) {
          isPrime = false;
          break;
        }
      }

      if (isPrime) {
        primes.add(i);
      }
    }

    return primes;
  }

  // Simple Caesar cipher encryption
  static String encryptText(String text) {
    const shift = 3;
    return text.split('').map((char) {
      final code = char.codeUnitAt(0);

      if (code >= 65 && code <= 90) {
        // Uppercase
        return String.fromCharCode(((code - 65 + shift) % 26) + 65);
      } else if (code >= 97 && code <= 122) {
        // Lowercase
        return String.fromCharCode(((code - 97 + shift) % 26) + 97);
      }

      return char;
    }).join('');
  }

  // Run fibonacci in isolate using compute()
  Future<int> fibonacciInIsolate(int n) async {
    return await compute(fibonacci, n);
  }

  // Run prime finder in isolate
  Future<List<int>> primesInIsolate(int max) async {
    return await compute(primeNumbers, max);
  }

  // Run encryption in isolate
  Future<String> encryptInIsolate(String text) async {
    return await compute(encryptText, text);
  }

  // Process list in parallel - square each number
  Future<List<int>> processListInParallel(List<int> numbers) async {
    // Split into chunks for parallel processing
    final chunkSize = numbers.length ~/ 4;
    final chunks = <List<int>>[];

    for (int i = 0; i < numbers.length; i += chunkSize) {
      final end = (i + chunkSize < numbers.length) ? i + chunkSize : numbers.length;
      chunks.add(numbers.sublist(i, end));
    }

    // Process each chunk in parallel
    final futures = chunks.map((chunk) => compute(_processChunk, chunk));
    final results = await Future.wait(futures);

    // Combine results
    return results.expand((list) => list).toList();
  }

  static List<int> _processChunk(List<int> chunk) {
    return chunk.map((n) => n * n).toList();
  }

  // Advanced: Custom isolate with two-way communication
  Future<String> processWithCustomIsolate(String data) async {
    final receivePort = ReceivePort();
    final completer = Completer<String>();

    await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SendPort) {
        // Isolate sent its SendPort, now send data
        message.send(data);
      } else if (message is String) {
        // Received result
        completer.complete(message);
        receivePort.close();
      } else if (message is Exception) {
        completer.completeError(message);
        receivePort.close();
      }
    });

    return completer.future;
  }

  static void _isolateEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();

    // Send our SendPort back to main
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is String) {
        // Process the data
        final result = encryptText(message);
        mainSendPort.send(result);
        receivePort.close();
      }
    });
  }

  // Performance comparison
  Future<void> comparePerformance(int n) async {
    print('=== Performance Comparison ===');

    // Without isolate
    print('\nWithout isolate (blocks main thread):');
    final start1 = DateTime.now();
    final result1 = fibonacci(n);
    final end1 = DateTime.now();
    print('Result: $result1');
    print('Time: ${end1.difference(start1).inMilliseconds}ms');

    // With isolate
    print('\nWith isolate (doesn\'t block main thread):');
    final start2 = DateTime.now();
    final result2 = await fibonacciInIsolate(n);
    final end2 = DateTime.now();
    print('Result: $result2');
    print('Time: ${end2.difference(start2).inMilliseconds}ms');
  }
}

// Example usage:
void main() async {
  final processor = IsolateProcessor();

  print('=== Example 1: Fibonacci in Isolate ===');
  final fibStart = DateTime.now();
  final fib = await processor.fibonacciInIsolate(35);
  final fibEnd = DateTime.now();
  print('Fibonacci(35) = $fib');
  print('Time: ${fibEnd.difference(fibStart).inMilliseconds}ms\n');

  print('=== Example 2: Prime Numbers in Isolate ===');
  final primeStart = DateTime.now();
  final primes = await processor.primesInIsolate(10000);
  final primeEnd = DateTime.now();
  print('Found ${primes.length} prime numbers up to 10,000');
  print('First 10 primes: ${primes.take(10).toList()}');
  print('Time: ${primeEnd.difference(primeStart).inMilliseconds}ms\n');

  print('=== Example 3: Text Encryption in Isolate ===');
  final text = 'Hello Flutter Developers!';
  final encrypted = await processor.encryptInIsolate(text);
  print('Original: $text');
  print('Encrypted: $encrypted\n');

  print('=== Example 4: Parallel List Processing ===');
  final numbers = List.generate(10000, (i) => i);
  final parallelStart = DateTime.now();
  final squared = await processor.processListInParallel(numbers);
  final parallelEnd = DateTime.now();
  print('Processed ${squared.length} numbers in parallel');
  print('First 10 results: ${squared.take(10).toList()}');
  print('Time: ${parallelEnd.difference(parallelStart).inMilliseconds}ms\n');

  print('=== Example 5: Custom Isolate Communication ===');
  final customResult = await processor.processWithCustomIsolate('Secret Message');
  print('Custom isolate result: $customResult\n');

  print('=== Example 6: Performance Comparison ===');
  await processor.comparePerformance(35);
}
