// Week 14, Exercise 5: Advanced Error Handling and Retry Logic
// Difficulty: Advanced
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => 'TimeoutException: $message';
}

class ServerException implements Exception {
  final int statusCode;
  final String message;
  ServerException(this.statusCode, this.message);
  @override
  String toString() => 'ServerException($statusCode): $message';
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
  @override
  String toString() => 'BadRequestException: $message';
}

// API Client with Error Handling and Retry Logic
class ApiClient {
  final http.Client _client;
  final Duration timeout;
  final int maxRetries;
  final bool enableLogging;

  ApiClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 5),
    this.maxRetries = 3,
    this.enableLogging = true,
  }) : _client = client ?? http.Client();

  // GET request with retry logic
  Future<Map<String, dynamic>> get(String url) async {
    return _executeWithRetry(() => _performGet(url));
  }

  // POST request with retry logic
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    return _executeWithRetry(() => _performPost(url, body));
  }

  // Execute request with retry logic and exponential backoff
  Future<Map<String, dynamic>> _executeWithRetry(
    Future<Map<String, dynamic>> Function() request,
  ) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        attempts++;
        _log('Attempt $attempts of $maxRetries');

        return await request();
      } on TimeoutException catch (e) {
        _log('Timeout on attempt $attempts: $e');

        if (attempts >= maxRetries) {
          rethrow;
        }

        // Exponential backoff: 1s, 2s, 4s
        final delay = Duration(seconds: 1 << (attempts - 1));
        _log('Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      } on NetworkException catch (e) {
        _log('Network error on attempt $attempts: $e');

        if (attempts >= maxRetries) {
          rethrow;
        }

        final delay = Duration(seconds: 1 << (attempts - 1));
        _log('Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      } catch (e) {
        _log('Unexpected error: $e');
        rethrow;
      }
    }

    throw NetworkException('Max retries exceeded');
  }

  // Perform GET request
  Future<Map<String, dynamic>> _performGet(String url) async {
    _log('GET $url');

    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out after ${timeout.inSeconds}s');
      });

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  // Perform POST request
  Future<Map<String, dynamic>> _performPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    _log('POST $url');
    _log('Body: ${jsonEncode(body)}');

    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout, onTimeout: () {
        throw TimeoutException('Request timed out after ${timeout.inSeconds}s');
      });

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is TimeoutException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    _log('Response: ${response.statusCode}');

    switch (response.statusCode) {
      case 200:
      case 201:
        _log('Success!');
        return jsonDecode(response.body);

      case 400:
        throw BadRequestException('Invalid request');

      case 401:
        throw ServerException(401, 'Unauthorized - Please login');

      case 403:
        throw ServerException(403, 'Forbidden - Access denied');

      case 404:
        throw ServerException(404, 'Resource not found');

      case 500:
      case 502:
      case 503:
        throw ServerException(
          response.statusCode,
          'Server error - Please try again later',
        );

      default:
        throw ServerException(
          response.statusCode,
          'Unexpected error: ${response.statusCode}',
        );
    }
  }

  // Log message
  void _log(String message) {
    if (enableLogging) {
      final timestamp = DateTime.now().toIso8601String();
      print('[$timestamp] $message');
    }
  }

  // Clean up
  void dispose() {
    _client.close();
  }
}

// Test the API Client
void main() async {
  final client = ApiClient(
    timeout: Duration(seconds: 5),
    maxRetries: 3,
    enableLogging: true,
  );

  print('Testing API Client with Error Handling and Retry Logic');
  print('=' * 70);

  // Test 1: Valid request
  print('\n1. Valid GET Request');
  print('-' * 70);
  try {
    final data = await client.get(
      'https://jsonplaceholder.typicode.com/users/1',
    );
    print('✓ Success! Received data:');
    print('  Name: ${data['name']}');
    print('  Email: ${data['email']}');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 2: Valid POST request
  print('\n2. Valid POST Request');
  print('-' * 70);
  try {
    final data = await client.post(
      'https://jsonplaceholder.typicode.com/posts',
      {
        'title': 'Test Post',
        'body': 'This is a test',
        'userId': 1,
      },
    );
    print('✓ Success! Created post with ID: ${data['id']}');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 3: 404 Error
  print('\n3. Testing 404 Error');
  print('-' * 70);
  try {
    await client.get(
      'https://jsonplaceholder.typicode.com/users/999999',
    );
    print('✓ Request succeeded (unexpected)');
  } catch (e) {
    print('✗ Failed as expected: $e');
  }

  // Test 4: Invalid URL (will retry)
  print('\n4. Testing Network Error with Retry');
  print('-' * 70);
  try {
    await client.get('https://invalid-url-that-does-not-exist-12345.com/api');
    print('✓ Request succeeded (unexpected)');
  } catch (e) {
    print('✗ Failed after retries: $e');
  }

  print('\n' + '=' * 70);
  print('All tests complete!');

  client.dispose();
}
