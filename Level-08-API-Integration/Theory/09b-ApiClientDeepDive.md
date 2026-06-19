# API Client Deep Dive: The Network Layer

The API Client is the lowest layer in your architecture. It handles raw HTTP communication with servers. This doc explains what goes in the services/ folder and how to build a proper API client.

---

## What is an API Client?

An **API Client** is a class that makes HTTP requests. It:
- Sends requests to URLs
- Adds headers (auth tokens, content type)
- Returns raw response data
- Handles network errors

```
WHAT THE API CLIENT DOES:

Your App                    API Client                  Internet/Server
────────                    ──────────                  ───────────────
"Get users"     ────►     Makes HTTP GET           ────►     Server
                          /users
                          Headers: {...}

                          Returns JSON             ◄────     {"users": [...]}
────────        ◄────     or throws error


The API Client is a TRANSLATOR between your app and the internet.
```

---

## API Client vs Repository

These are often confused. Here's the difference:

```
API CLIENT (services/)           REPOSITORY (repositories/)
──────────────────────           ─────────────────────────
Makes HTTP requests              Uses API Client
Returns raw JSON                 Returns Dart objects
Knows about URLs, headers        Knows about your models
One per app (usually)            One per data type
Generic - works for any data     Specific - UserRepo, PostRepo


FLOW:

Server ──► API Client ──► Repository ──► Controller ──► Widget
           (HTTP)         (models)       (state)        (UI)


EXAMPLE:

// API Client returns raw JSON
apiClient.get('/users');
// Returns: [{"id": 1, "name": "John"}, ...]

// Repository converts to objects
userRepository.getUsers();
// Returns: [User(id: 1, name: "John"), ...]
```

---

## Basic API Client Implementation

```dart
// services/api_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Duration timeout;
  String? _authToken;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  /// Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear auth token (logout)
  void clearAuthToken() {
    _authToken = null;
  }

  /// Build headers for requests
  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Make a GET request
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .get(url, headers: _buildHeaders())
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Network error');
    }
  }

  /// Make a POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .post(
            url,
            headers: _buildHeaders(),
            body: json.encode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Network error');
    }
  }

  /// Make a PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .put(
            url,
            headers: _buildHeaders(),
            body: json.encode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Network error');
    }
  }

  /// Make a DELETE request
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .delete(url, headers: _buildHeaders())
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Network error');
    }
  }

  /// Handle response and errors
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return json.decode(response.body);
      case 204:
        return null; // No content
      case 400:
        throw BadRequestException(_parseError(response));
      case 401:
        throw UnauthorizedException('Session expired. Please login again.');
      case 403:
        throw ForbiddenException('Access denied');
      case 404:
        throw NotFoundException('Resource not found');
      case 500:
        throw ServerException('Server error. Try again later.');
      default:
        throw ApiException('Error: ${response.statusCode}', response.statusCode);
    }
  }

  String _parseError(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? body['error'] ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
```

---

## API Exception Classes

```dart
// services/api_exceptions.dart

/// Base exception for all API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Network connectivity issues
class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

/// 400 - Bad request
class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);
}

/// 401 - Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

/// 403 - Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

/// 404 - Not found
class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

/// 500 - Server error
class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);
}
```

---

## API Client with Dio

Dio is more powerful than http package. Here's how to build an API client with Dio:

```dart
// services/dio_api_client.dart

import 'package:dio/dio.dart';

class DioApiClient {
  late final Dio _dio;

  DioApiClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  /// Set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Convert Dio errors to our exceptions
  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timed out');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _parseErrorMessage(e.response);

        switch (statusCode) {
          case 400:
            return BadRequestException(message);
          case 401:
            return UnauthorizedException(message);
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 500:
            return ServerException(message);
          default:
            return ApiException(message, statusCode);
        }

      default:
        return ApiException('Something went wrong');
    }
  }

  String _parseErrorMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map) {
        return data['message'] ?? data['error'] ?? 'Unknown error';
      }
      return 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
```

---

## Adding Interceptors (Dio)

Interceptors run code before/after every request.

```dart
// services/auth_interceptor.dart

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor(this.tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add token to every request
    final token = tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 - token expired
    if (err.response?.statusCode == 401) {
      tokenStorage.clearToken();
      // Could trigger logout or token refresh here
    }
    handler.next(err);
  }
}

// Usage
_dio.interceptors.add(AuthInterceptor(tokenStorage));
```

```dart
// services/retry_interceptor.dart

class RetryInterceptor extends Interceptor {
  final int maxRetries;

  RetryInterceptor({this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on network errors
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {

      final options = err.requestOptions;
      int retries = options.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        options.extra['retries'] = retries + 1;

        // Wait before retrying
        await Future.delayed(Duration(seconds: retries + 1));

        try {
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        } catch (e) {
          // Retry failed, continue with error
        }
      }
    }

    handler.next(err);
  }
}
```

---

## API Client Responsibilities

```
WHAT API CLIENT SHOULD DO:
──────────────────────────
1. Make HTTP requests (GET, POST, PUT, DELETE)
2. Set headers (Content-Type, Authorization)
3. Handle timeouts
4. Parse JSON responses
5. Convert HTTP errors to exceptions
6. Add interceptors (logging, auth, retry)

WHAT API CLIENT SHOULD NOT DO:
──────────────────────────────
1. NOT convert JSON to model objects (Repository does this)
2. NOT track loading state (Controller does this)
3. NOT know about specific endpoints (Repository knows these)
4. NOT contain business logic
5. NOT show errors to user (Widget does this)
```

---

## Using API Client in Repository

```dart
// repositories/user_repository.dart

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl({required this.apiClient});

  @override
  Future<List<User>> getUsers() async {
    // API Client makes the request
    final response = await apiClient.get('/users');

    // Repository converts JSON to objects
    return (response as List)
        .map((json) => User.fromJson(json))
        .toList();
  }

  @override
  Future<User> getUser(int id) async {
    final response = await apiClient.get('/users/$id');
    return User.fromJson(response);
  }

  @override
  Future<User> createUser(User user) async {
    final response = await apiClient.post('/users', user.toJson());
    return User.fromJson(response);
  }

  @override
  Future<void> deleteUser(int id) async {
    await apiClient.delete('/users/$id');
  }
}
```

---

## Multiple API Clients

Sometimes you need to talk to different servers.

```dart
// services/service_locator.dart

class ServiceLocator {
  // Main API
  ApiClient get mainApi => ApiClient(
    baseUrl: 'https://api.myapp.com',
  );

  // Auth API (different server)
  ApiClient get authApi => ApiClient(
    baseUrl: 'https://auth.myapp.com',
  );

  // Third-party API
  ApiClient get weatherApi => ApiClient(
    baseUrl: 'https://api.weather.com',
  );
}

// Repositories use appropriate client
class UserRepository {
  final ApiClient api;
  UserRepository() : api = sl.mainApi;
}

class AuthRepository {
  final ApiClient api;
  AuthRepository() : api = sl.authApi;
}

class WeatherRepository {
  final ApiClient api;
  WeatherRepository() : api = sl.weatherApi;
}
```

---

## Testing API Client

```dart
// test/services/api_client_test.dart

import 'package:test/test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;

    test('get returns data on success', () async {
      // Create mock HTTP client
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"id": 1, "name": "Test"}',
          200,
        );
      });

      // Test the API client
      apiClient = ApiClient(
        baseUrl: 'https://api.test.com',
        httpClient: mockClient,
      );

      final result = await apiClient.get('/test');

      expect(result['id'], 1);
      expect(result['name'], 'Test');
    });

    test('get throws NotFoundException on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message": "Not found"}', 404);
      });

      apiClient = ApiClient(
        baseUrl: 'https://api.test.com',
        httpClient: mockClient,
      );

      expect(
        () => apiClient.get('/notfound'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('get throws NetworkException on connection error', () async {
      final mockClient = MockClient((request) async {
        throw const SocketException('No internet');
      });

      apiClient = ApiClient(
        baseUrl: 'https://api.test.com',
        httpClient: mockClient,
      );

      expect(
        () => apiClient.get('/test'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

---

## Common Mistakes

```
MISTAKE 1: Parsing models in API Client
───────────────────────────────────────
BAD:
class ApiClient {
  Future<List<User>> getUsers() async {
    final response = await http.get('/users');
    return (jsonDecode(response.body) as List)
        .map((j) => User.fromJson(j))  // NO! Don't parse here
        .toList();
  }
}

GOOD:
class ApiClient {
  Future<dynamic> get(String endpoint) async {
    final response = await http.get('$baseUrl$endpoint');
    return jsonDecode(response.body);  // Return raw JSON
  }
}

// Repository parses
class UserRepository {
  Future<List<User>> getUsers() async {
    final json = await apiClient.get('/users');
    return (json as List).map(User.fromJson).toList();
  }
}


MISTAKE 2: Hardcoding URLs
──────────────────────────
BAD:
class ApiClient {
  Future<dynamic> getUsers() async {
    return http.get('https://api.example.com/users');  // Hardcoded!
  }
}

GOOD:
class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    return http.get(Uri.parse('$baseUrl$endpoint'));
  }
}


MISTAKE 3: Not handling errors
──────────────────────────────
BAD:
class ApiClient {
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return jsonDecode(response.body);  // What if 404? 500?
  }
}

GOOD:
class ApiClient {
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Not found');
    } else {
      throw ApiException('Error', response.statusCode);
    }
  }
}


MISTAKE 4: Exposing implementation details
──────────────────────────────────────────
BAD:
class ApiClient {
  final Dio dio;  // Exposing Dio publicly
  ApiClient(this.dio);
}

// Caller can mess with Dio directly
apiClient.dio.options.baseUrl = 'hacked';

GOOD:
class ApiClient {
  late final Dio _dio;  // Private

  ApiClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  // Only expose what's needed
  Future<dynamic> get(String endpoint) => ...
}
```

---

## Folder Structure

```
lib/
├── services/
│   ├── api_client.dart         # Main API client
│   ├── api_exceptions.dart     # Custom exceptions
│   ├── interceptors/
│   │   ├── auth_interceptor.dart
│   │   ├── logging_interceptor.dart
│   │   └── retry_interceptor.dart
│   └── api_config.dart         # URLs, timeouts, etc.
│
├── repositories/
│   └── ...                     # Uses API Client
│
└── ...
```

---

## Summary

```
API CLIENT SUMMARY:
───────────────────

WHAT IT IS:
The lowest layer - handles HTTP communication

RESPONSIBILITIES:
• Make HTTP requests (GET, POST, PUT, DELETE)
• Add headers (Content-Type, Authorization)
• Handle timeouts
• Parse JSON responses
• Convert HTTP errors to typed exceptions
• Support interceptors (auth, logging, retry)

NOT RESPONSIBLE FOR:
• Converting JSON to models (Repository)
• Tracking loading state (Controller)
• Business logic
• UI concerns

KEY COMPONENTS:
1. Base URL configuration
2. Timeout settings
3. Header management
4. Request methods (get, post, put, delete)
5. Response handling
6. Error mapping to exceptions
7. Interceptors (optional)

DATA FLOW:
Server → API Client → Repository → Controller → Widget
         (JSON)       (objects)    (state)     (UI)

TESTING:
• Mock HTTP client
• Test each status code
• Test error handling
• Test timeout behavior
```

---

## Navigation

Previous: [Repository Pattern](09a-RepositoryPattern.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Controllers Deep Dive](09f-ControllersDeepDive.md)
