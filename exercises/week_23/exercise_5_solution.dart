/// Exercise 5 Solution: Complex Async Patterns - Rate Limiter & Cache
///
/// This solution demonstrates:
/// - Production-ready rate limiting
/// - Async caching with expiration
/// - Retry logic with exponential backoff
/// - Debouncing for performance optimization
/// - Real-world async patterns

import 'dart:async';
import 'dart:collection';

/// Rate limiter to control API call frequency
class RateLimiter {
  final int maxCalls;
  final Duration period;

  final Queue<Completer> _queue = Queue();
  int _callsInPeriod = 0;
  Timer? _resetTimer;

  RateLimiter({
    required this.maxCalls,
    required this.period,
  });

  Future<T> execute<T>(Future<T> Function() operation) async {
    final completer = Completer<void>();
    _queue.add(completer);

    if (_callsInPeriod < maxCalls) {
      _processNext();
    }

    await completer.future;
    return await operation();
  }

  void _processNext() {
    if (_queue.isEmpty) return;

    if (_callsInPeriod < maxCalls) {
      final completer = _queue.removeFirst();
      _callsInPeriod++;

      _resetTimer ??= Timer(period, () {
        _callsInPeriod = 0;
        _resetTimer = null;
        _processNext();
      });

      completer.complete();
      _processNext();
    }
  }

  void dispose() {
    _resetTimer?.cancel();
    _queue.clear();
  }
}

/// Async cache with expiration
class AsyncCache<T> {
  final Duration expiration;
  final Map<String, _CacheEntry<T>> _cache = {};

  AsyncCache({this.expiration = const Duration(minutes: 5)});

  Future<T> getOrFetch(String key, Future<T> Function() fetcher) async {
    final entry = _cache[key];

    if (entry != null && !entry.isExpired) {
      return entry.value;
    }

    final value = await fetcher();
    _cache[key] = _CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(expiration),
    );

    return value;
  }

  void invalidate(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  int get size => _cache.length;

  bool contains(String key) {
    final entry = _cache[key];
    return entry != null && !entry.isExpired;
  }
}

class _CacheEntry<T> {
  final T value;
  final DateTime expiresAt;

  _CacheEntry({required this.value, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Retry manager with exponential backoff
class RetryManager {
  Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await operation();
      } catch (error) {
        attempt++;

        if (attempt >= maxAttempts) {
          rethrow;
        }

        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }

        print('Attempt $attempt failed: $error. Retrying in ${delay.inSeconds}s...');

        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * backoffMultiplier).round());
      }
    }
  }
}

/// Debouncer to delay rapid calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler - different from debouncer, executes immediately and blocks subsequent calls
class Throttler {
  final Duration duration;
  DateTime? _lastExecute;

  Throttler({required this.duration});

  void call(void Function() action) {
    final now = DateTime.now();

    if (_lastExecute == null || now.difference(_lastExecute!) >= duration) {
      _lastExecute = now;
      action();
    }
  }
}

// Example usage:
void main() async {
  print('=== Example 1: Rate Limiter ===');
  final rateLimiter = RateLimiter(maxCalls: 3, period: Duration(seconds: 2));

  final stopwatch = Stopwatch()..start();

  for (int i = 1; i <= 8; i++) {
    rateLimiter.execute(() async {
      print('[${stopwatch.elapsed.inSeconds}s] API call $i completed');
    });
  }

  await Future.delayed(Duration(seconds: 7));
  rateLimiter.dispose();

  print('\n=== Example 2: Async Cache ===');
  final cache = AsyncCache<String>(expiration: Duration(seconds: 3));

  // Simulated API call
  Future<String> fetchUser(String id) async {
    print('Fetching user $id from API...');
    await Future.delayed(Duration(seconds: 1));
    return 'User $id Data';
  }

  // First call - fetches from API
  final user1 = await cache.getOrFetch('user_1', () => fetchUser('1'));
  print('Got: $user1');

  // Second call - returns from cache (no API call)
  final user1Cached = await cache.getOrFetch('user_1', () => fetchUser('1'));
  print('Got from cache: $user1Cached');

  // Wait for cache to expire
  await Future.delayed(Duration(seconds: 4));

  // Third call - cache expired, fetches again
  final user1Refreshed = await cache.getOrFetch('user_1', () => fetchUser('1'));
  print('Cache expired, fetched again: $user1Refreshed');

  print('\n=== Example 3: Retry Manager ===');
  final retryManager = RetryManager();
  int attemptCount = 0;

  try {
    await retryManager.retry(
      () async {
        attemptCount++;
        print('Attempt $attemptCount...');

        if (attemptCount < 3) {
          throw Exception('Temporary failure');
        }

        return 'Success!';
      },
      maxAttempts: 5,
      initialDelay: Duration(milliseconds: 500),
    );
    print('Operation succeeded!');
  } catch (e) {
    print('Operation failed after all retries: $e');
  }

  print('\n=== Example 4: Debouncer ===');
  final debouncer = Debouncer(delay: Duration(milliseconds: 500));

  print('Rapidly calling debounced function...');
  for (int i = 1; i <= 5; i++) {
    debouncer(() {
      print('Debounced action executed at call $i');
    });
    await Future.delayed(Duration(milliseconds: 100));
  }

  await Future.delayed(Duration(seconds: 1));

  print('\n=== Example 5: Throttler ===');
  final throttler = Throttler(duration: Duration(seconds: 1));

  print('Rapidly calling throttled function...');
  for (int i = 1; i <= 10; i++) {
    throttler(() {
      print('Throttled action executed at call $i');
    });
    await Future.delayed(Duration(milliseconds: 200));
  }

  debouncer.dispose();
}
