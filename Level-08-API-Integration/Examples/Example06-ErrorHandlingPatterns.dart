/// Example 06: Error Handling Patterns
///
/// This example demonstrates proper error handling for API calls:
/// - Custom exception classes
/// - Error handling service
/// - User-friendly error messages
/// - Retry logic
///
/// To run: flutter run -t lib/main.dart (after copying to a Flutter project)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Custom exception classes for different error types
// 2. Centralized error handling in API service
// 3. Displaying user-friendly error messages
// 4. Retry functionality for recoverable errors
// 5. Different UI for different error types
//
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error Handling Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const ErrorHandlingDemo(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CUSTOM EXCEPTIONS
// ═══════════════════════════════════════════════════════════════════════════
//
// Exception Hierarchy:
// ┌─────────────────────────────────────────────────────────────┐
// │  ApiException (base)                                        │
// │    ├── NetworkException     (no internet, timeout)          │
// │    ├── ServerException      (5xx errors)                    │
// │    ├── ClientException      (4xx errors)                    │
// │    │     ├── UnauthorizedException (401)                    │
// │    │     ├── ForbiddenException    (403)                    │
// │    │     ├── NotFoundException     (404)                    │
// │    │     └── ValidationException   (422)                    │
// │    └── ParseException       (invalid JSON)                  │
// └─────────────────────────────────────────────────────────────┘

/// Base exception for all API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => message;

  /// User-friendly message
  String get userMessage => message;

  /// Icon to display for this error
  IconData get icon => Icons.error_outline;

  /// Color for error display
  Color get color => Colors.red;

  /// Whether this error is recoverable (can retry)
  bool get isRecoverable => false;
}

/// Network-related errors (no internet, timeout)
class NetworkException extends ApiException {
  NetworkException([String message = 'Network error. Check your connection.'])
      : super(message);

  @override
  IconData get icon => Icons.wifi_off;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => true;
}

/// Server errors (5xx)
class ServerException extends ApiException {
  ServerException([String message = 'Server error. Please try again later.'])
      : super(message, statusCode: 500);

  @override
  IconData get icon => Icons.cloud_off;

  @override
  Color get color => Colors.red;

  @override
  bool get isRecoverable => true;
}

/// Unauthorized error (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Please log in to continue.'])
      : super(message, statusCode: 401);

  @override
  IconData get icon => Icons.lock_outline;

  @override
  Color get color => Colors.amber;

  @override
  bool get isRecoverable => false;
}

/// Not found error (404)
class NotFoundException extends ApiException {
  NotFoundException([String message = 'The requested item was not found.'])
      : super(message, statusCode: 404);

  @override
  IconData get icon => Icons.search_off;

  @override
  Color get color => Colors.grey;

  @override
  bool get isRecoverable => false;
}

/// Validation error (422)
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  ValidationException({
    String message = 'Please check your input.',
    this.errors,
  }) : super(message, statusCode: 422);

  @override
  IconData get icon => Icons.warning_amber;

  @override
  Color get color => Colors.orange;

  @override
  bool get isRecoverable => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// API SERVICE WITH ERROR HANDLING
// ═══════════════════════════════════════════════════════════════════════════

class ApiService {
  final String baseUrl;
  final Duration timeout;

  ApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 10),
  });

  /// Makes a GET request with error handling
  Future<T> get<T>(
    String path, {
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$path'))
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TimeoutException {
      throw NetworkException('Request timed out. Try again.');
    } on FormatException catch (e) {
      throw ApiException('Invalid response format.', originalError: e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong.', originalError: e);
    }
  }

  /// Makes a POST request with error handling
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response, parser);
    } on SocketException {
      throw NetworkException('No internet connection.');
    } on TimeoutException {
      throw NetworkException('Request timed out. Try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Something went wrong.', originalError: e);
    }
  }

  /// Handles response and throws appropriate exceptions
  T _handleResponse<T>(http.Response response, T Function(dynamic)? parser) {
    final body = response.body.isNotEmpty ? json.decode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
        if (parser != null) {
          return parser(body);
        }
        return body as T;

      case 204:
        return null as T;

      case 400:
        throw ApiException(
          _extractMessage(body) ?? 'Bad request.',
          statusCode: 400,
        );

      case 401:
        throw UnauthorizedException(_extractMessage(body));

      case 403:
        throw ApiException(
          _extractMessage(body) ?? 'Access denied.',
          statusCode: 403,
        );

      case 404:
        throw NotFoundException(_extractMessage(body));

      case 422:
        throw ValidationException(
          message: _extractMessage(body) ?? 'Validation failed.',
          errors: _extractValidationErrors(body),
        );

      case 500:
      case 502:
      case 503:
        throw ServerException();

      default:
        throw ApiException(
          'Request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
    }
  }

  /// Extracts error message from response body
  String? _extractMessage(dynamic body) {
    if (body == null) return null;
    if (body is Map) {
      return body['message'] ?? body['error'];
    }
    return null;
  }

  /// Extracts validation errors from response body
  Map<String, List<String>>? _extractValidationErrors(dynamic body) {
    if (body == null || body is! Map) return null;
    final errors = body['errors'];
    if (errors == null || errors is! Map) return null;

    return errors.map((key, value) {
      final list = value is List ? value.cast<String>() : [value.toString()];
      return MapEntry(key.toString(), list);
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DEMO SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class ErrorHandlingDemo extends StatefulWidget {
  const ErrorHandlingDemo({super.key});

  @override
  State<ErrorHandlingDemo> createState() => _ErrorHandlingDemoState();
}

class _ErrorHandlingDemoState extends State<ErrorHandlingDemo> {
  final _api = ApiService(baseUrl: 'https://jsonplaceholder.typicode.com');

  bool _isLoading = false;
  String? _result;
  ApiException? _error;

  /// Simulates different API scenarios
  Future<void> _fetchData(String scenario) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      switch (scenario) {
        case 'success':
          final users = await _api.get<List<dynamic>>('/users?_limit=3');
          _result = 'Loaded ${users.length} users successfully!';
          break;

        case 'not_found':
          await _api.get('/users/9999');
          break;

        case 'server_error':
          // This will work but we'll simulate error
          throw ServerException();

        case 'network_error':
          throw NetworkException();

        case 'unauthorized':
          throw UnauthorizedException();

        case 'validation':
          throw ValidationException(
            errors: {
              'email': ['Email is required', 'Must be a valid email'],
              'name': ['Name is too short'],
            },
          );
      }
    } on ApiException catch (e) {
      _error = e;
    } catch (e) {
      _error = ApiException('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Retry the last failed request
  void _retry() {
    if (_error?.isRecoverable == true) {
      _fetchData('success');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text(
                          'Error Handling Patterns',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the buttons below to simulate different API '
                      'responses and see how errors are handled.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Scenario Buttons
            const Text(
              'Simulate Scenarios:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildScenarioButton('Success', 'success', Colors.green),
                _buildScenarioButton('Not Found', 'not_found', Colors.grey),
                _buildScenarioButton('Server Error', 'server_error', Colors.red),
                _buildScenarioButton('Network Error', 'network_error', Colors.orange),
                _buildScenarioButton('Unauthorized', 'unauthorized', Colors.amber),
                _buildScenarioButton('Validation', 'validation', Colors.purple),
              ],
            ),

            const SizedBox(height: 24),

            // Result/Error Display
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              _buildErrorCard(_error!)
            else if (_result != null)
              _buildSuccessCard(_result!),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioButton(String label, String scenario, Color color) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _fetchData(scenario),
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildErrorCard(ApiException error) {
    return Card(
      color: error.color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(error.icon, size: 48, color: error.color),
            const SizedBox(height: 16),
            Text(
              error.userMessage,
              style: TextStyle(
                color: error.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),

            // Show validation errors if any
            if (error is ValidationException && error.errors != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...error.errors!.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...entry.value.map((msg) => Text('  • $msg')),
                      ],
                    ),
                  )),
            ],

            // Retry button for recoverable errors
            if (error.isRecoverable) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard(String message) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. CUSTOM EXCEPTIONS:
//    - Create a base ApiException class
//    - Extend for specific error types (Network, Server, etc.)
//    - Include user-friendly messages
//
// 2. ERROR HANDLING SERVICE:
//    - Catch all possible exceptions (Socket, Timeout, etc.)
//    - Map HTTP status codes to appropriate exceptions
//    - Extract error details from response body
//
// 3. USER EXPERIENCE:
//    - Show appropriate icons and colors for error types
//    - Provide clear, actionable messages
//    - Only offer retry for recoverable errors
//
// 4. VALIDATION ERRORS:
//    - Parse field-specific errors
//    - Display next to relevant form fields
//
// 5. RECOVERY:
//    - Mark errors as recoverable/non-recoverable
//    - Provide retry button for network/server errors
//    - Redirect to login for auth errors
//
// ═══════════════════════════════════════════════════════════════════════════
