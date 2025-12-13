/// Exercise 1 Solution: Working with Futures - Async Data Fetcher
///
/// This solution demonstrates:
/// - Proper async/await usage
/// - Error handling with try-catch
/// - Future combinators (Future.wait)
/// - Timeout handling
/// - Simulating real-world async operations

class DataFetcher {
  Future<String> fetchUserData(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (userId == 'error') {
      throw Exception('Failed to fetch user data');
    }

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    return 'User data for $userId: John Doe, Premium Member';
  }

  Future<List<String>> fetchUserPosts(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (userId == 'error') {
      throw Exception('Failed to fetch user posts');
    }

    // Simulate network delay
    await Future.delayed(Duration(seconds: 3));

    return [
      'My First Flutter App',
      'Understanding Async/Await',
      'Building Beautiful UIs',
      'State Management Best Practices',
    ];
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    if (userId == 'error') {
      throw Exception('Failed to fetch user profile');
    }

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    return {
      'id': userId,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'age': 30,
      'country': 'USA',
      'premium': true,
    };
  }

  Future<void> saveData(String data) async {
    if (data.isEmpty) {
      throw ArgumentError('Data cannot be empty');
    }

    // Simulate save delay
    await Future.delayed(Duration(seconds: 1));

    print('Data saved successfully: ${data.substring(0, data.length > 50 ? 50 : data.length)}...');
  }

  /// Fetches all user data in parallel using Future.wait
  Future<Map<String, dynamic>> fetchAllUserData(String userId) async {
    final stopwatch = Stopwatch()..start();

    // Fetch all data in parallel
    final results = await Future.wait([
      fetchUserData(userId),
      fetchUserPosts(userId),
      fetchUserProfile(userId),
    ]);

    stopwatch.stop();

    return {
      'userData': results[0],
      'posts': results[1],
      'profile': results[2],
      'fetchTime': '${stopwatch.elapsed.inSeconds} seconds',
    };
  }

  /// Fetches data with timeout
  Future<String> fetchWithTimeout(String userId, {Duration timeout = const Duration(seconds: 5)}) async {
    try {
      return await fetchUserData(userId).timeout(
        timeout,
        onTimeout: () => throw TimeoutException('Request timed out after ${timeout.inSeconds} seconds'),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Retries failed requests
  Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          rethrow;
        }
        print('Attempt $attempts failed, retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      }
    }

    throw Exception('All retry attempts failed');
  }
}

// Example usage:
void main() async {
  final fetcher = DataFetcher();

  print('=== Example 1: Fetch User Data ===');
  try {
    final userData = await fetcher.fetchUserData('user123');
    print('Success: $userData\n');
  } catch (e) {
    print('Error: $e\n');
  }

  print('=== Example 2: Fetch All Data in Parallel ===');
  try {
    final stopwatch = Stopwatch()..start();
    final allData = await fetcher.fetchAllUserData('user456');
    stopwatch.stop();

    print('Profile: ${allData['profile']}');
    print('Posts: ${allData['posts']}');
    print('Fetch time: ${allData['fetchTime']}');
    print('Total time: ${stopwatch.elapsed.inSeconds} seconds\n');
  } catch (e) {
    print('Error: $e\n');
  }

  print('=== Example 3: Error Handling ===');
  try {
    await fetcher.fetchUserData('error');
  } catch (e) {
    print('Caught error: $e\n');
  }

  print('=== Example 4: Timeout ===');
  try {
    await fetcher.fetchWithTimeout('user789', timeout: Duration(seconds: 1));
  } catch (e) {
    print('Caught timeout: $e\n');
  }

  print('=== Example 5: Retry Logic ===');
  int attemptCount = 0;
  try {
    await fetcher.retryOperation(() async {
      attemptCount++;
      if (attemptCount < 3) {
        throw Exception('Simulated failure');
      }
      return fetchuserData('user999');
    });
  } catch (e) {
    print('All retries failed: $e\n');
  }
}

import 'dart:async';

// Helper method reference
Future<String> fetchuserData(String userId) async {
  await Future.delayed(Duration(milliseconds: 500));
  return 'Data for $userId';
}
