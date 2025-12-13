/// Week 33, Exercise 2: API Configuration per Flavor - SOLUTION
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// This solution demonstrates:
/// 1. Complete API configuration management per flavor
/// 2. HTTP service with flavor-specific endpoints
/// 3. Secure API key handling
/// 4. Error handling and logging based on flavor
/// 5. Testing different environments
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev --dart-define=API_KEY=dev_key_123
/// - flutter run --dart-define=FLAVOR=staging --dart-define=API_KEY=staging_key_456
/// - flutter run --dart-define=FLAVOR=prod --dart-define=API_KEY=prod_key_789

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

// Mock HTTP client for demonstration (replace with real http package)
class MockHttpClient {
  final Duration timeout;

  MockHttpClient({required this.timeout});

  Future<Map<String, dynamic>> get(String url, Map<String, String> headers) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // Simulate successful response
    return {
      'status': 'success',
      'endpoint': url,
      'timestamp': DateTime.now().toIso8601String(),
      'headers': headers,
    };
  }
}

// Enum for app flavors
enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromString(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }
}

// API Configuration class
class ApiConfig {
  final String baseUrl;
  final String apiKey;
  final Duration timeout;
  final bool enableLogging;
  final bool useSSL;
  final int maxRetries;

  ApiConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.timeout,
    required this.enableLogging,
    this.useSSL = true,
    this.maxRetries = 3,
  });

  // Factory constructor for creating config based on flavor
  factory ApiConfig.forFlavor(AppFlavor flavor, String apiKey) {
    switch (flavor) {
      case AppFlavor.dev:
        return ApiConfig(
          baseUrl: 'https://dev-api.example.com',
          apiKey: apiKey.isEmpty ? 'dev_default_key' : apiKey,
          timeout: Duration(seconds: 30), // Longer timeout for debugging
          enableLogging: true,
          useSSL: false, // May use HTTP in dev for local testing
          maxRetries: 1, // Fewer retries in dev to fail fast
        );

      case AppFlavor.staging:
        return ApiConfig(
          baseUrl: 'https://staging-api.example.com',
          apiKey: apiKey.isEmpty ? 'staging_default_key' : apiKey,
          timeout: Duration(seconds: 20),
          enableLogging: true,
          useSSL: true,
          maxRetries: 2,
        );

      case AppFlavor.prod:
        return ApiConfig(
          baseUrl: 'https://api.example.com',
          apiKey: apiKey, // No default in production - must be provided
          timeout: Duration(seconds: 10), // Shorter timeout in production
          enableLogging: false, // Disable verbose logging in production
          useSSL: true,
          maxRetries: 3,
        );
    }
  }

  // Validation method
  bool isValid() {
    if (apiKey.isEmpty) return false;
    if (baseUrl.isEmpty) return false;
    return true;
  }

  // Get full URL for an endpoint
  String getUrl(String endpoint) {
    // Remove leading slash if present
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$baseUrl/$cleanEndpoint';
  }

  // Get authorization header
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      'X-API-Version': '1.0',
    };
  }
}

// Main app configuration
class AppConfig {
  final AppFlavor flavor;
  final ApiConfig apiConfig;
  final String appName;
  final Color themeColor;

  AppConfig({
    required this.flavor,
    required this.apiConfig,
    required this.appName,
    required this.themeColor,
  });

  static AppConfig? _instance;

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized');
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static void initialize({required AppConfig config}) {
    _instance = config;
    _logInitialization(config);
  }

  static void _logInitialization(AppConfig config) {
    if (config.apiConfig.enableLogging) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🚀 App Configuration Initialized');
      debugPrint('═══════════════════════════════════════');
      debugPrint('Flavor: ${config.flavor.name}');
      debugPrint('App Name: ${config.appName}');
      debugPrint('API Base URL: ${config.apiConfig.baseUrl}');
      debugPrint('API Key: ${config.apiConfig.apiKey.substring(0, 5)}...');
      debugPrint('Logging Enabled: ${config.apiConfig.enableLogging}');
      debugPrint('SSL: ${config.apiConfig.useSSL}');
      debugPrint('Timeout: ${config.apiConfig.timeout.inSeconds}s');
      debugPrint('═══════════════════════════════════════');
    }
  }

  bool get isProduction => flavor == AppFlavor.prod;
  bool get isDevelopment => flavor == AppFlavor.dev;
}

// API Service
class ApiService {
  final ApiConfig config;
  late final MockHttpClient _client;

  ApiService(this.config) {
    _client = MockHttpClient(timeout: config.timeout);
    _log('ApiService initialized for ${config.baseUrl}');
  }

  // Fetch users from API
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    _log('Fetching users...');

    try {
      final url = config.getUrl('users');
      final headers = config.getHeaders();

      final response = await _client.get(url, headers);

      _log('Users fetched successfully');

      // Mock user data
      return [
        {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
        {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
        {'id': 3, 'name': 'Bob Johnson', 'email': 'bob@example.com'},
      ];
    } catch (e) {
      _logError('Failed to fetch users', e);
      rethrow;
    }
  }

  // Get environment info (for testing)
  Future<Map<String, dynamic>> getEnvironmentInfo() async {
    _log('Fetching environment info...');

    try {
      final url = config.getUrl('environment');
      final headers = config.getHeaders();

      final response = await _client.get(url, headers);

      // Create detailed environment info
      final info = {
        'environment': config.baseUrl.contains('dev') ? 'Development' :
                      config.baseUrl.contains('staging') ? 'Staging' :
                      'Production',
        'baseUrl': config.baseUrl,
        'apiKeyPrefix': config.apiKey.substring(0, 5) + '...',
        'ssl': config.useSSL,
        'loggingEnabled': config.enableLogging,
        'timeout': config.timeout.inSeconds,
        'maxRetries': config.maxRetries,
        'timestamp': DateTime.now().toIso8601String(),
        'response': response,
      };

      _log('Environment info retrieved successfully');
      return info;
    } catch (e) {
      _logError('Failed to get environment info', e);
      rethrow;
    }
  }

  // Test API connection
  Future<bool> testConnection() async {
    _log('Testing API connection...');

    try {
      final url = config.getUrl('health');
      final headers = config.getHeaders();

      await _client.get(url, headers);

      _log('Connection test successful ✓');
      return true;
    } catch (e) {
      _logError('Connection test failed', e);
      return false;
    }
  }

  // Logging helpers
  void _log(String message) {
    if (config.enableLogging) {
      debugPrint('📡 [ApiService] $message');
    }
  }

  void _logError(String message, dynamic error) {
    if (config.enableLogging) {
      debugPrint('❌ [ApiService] $message: $error');
    }
  }
}

void main() {
  // Read configuration from compile-time constants
  const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

  final flavor = AppFlavor.fromString(flavorString);

  // Create API configuration
  final apiConfig = ApiConfig.forFlavor(flavor, apiKey);

  // Validate configuration
  if (!apiConfig.isValid()) {
    debugPrint('⚠️ Warning: Invalid API configuration');
    if (apiConfig.apiKey.isEmpty && flavor == AppFlavor.prod) {
      throw Exception('API key is required for production builds');
    }
  }

  // Initialize app configuration
  AppConfig.initialize(
    config: AppConfig(
      flavor: flavor,
      apiConfig: apiConfig,
      appName: _getAppName(flavor),
      themeColor: _getThemeColor(flavor),
    ),
  );

  runApp(MyApp());
}

String _getAppName(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return 'API Demo Dev';
    case AppFlavor.staging:
      return 'API Demo Staging';
    case AppFlavor.prod:
      return 'API Demo';
  }
}

Color _getThemeColor(AppFlavor flavor) {
  switch (flavor) {
    case AppFlavor.dev:
      return Colors.red;
    case AppFlavor.staging:
      return Colors.orange;
    case AppFlavor.prod:
      return Colors.blue;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: !config.isProduction,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: config.themeColor,
        appBarTheme: AppBarTheme(
          backgroundColor: config.themeColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: ApiDemoScreen(),
    );
  }
}

class ApiDemoScreen extends StatefulWidget {
  @override
  _ApiDemoScreenState createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  late final ApiService _apiService;

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _environmentData;
  List<Map<String, dynamic>>? _users;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(AppConfig.instance.apiConfig);
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _environmentData = null;
    });

    try {
      final data = await _apiService.getEnvironmentInfo();
      setState(() {
        _environmentData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Connection failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _users = null;
    });

    try {
      final users = await _apiService.fetchUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch users: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    final apiConfig = config.apiConfig;

    return Scaffold(
      appBar: AppBar(
        title: Text('API Configuration Demo'),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                config.flavor.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Configuration Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: config.themeColor),
                        SizedBox(width: 8),
                        Text(
                          'Current Configuration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    _buildConfigRow('Flavor', config.flavor.name.toUpperCase()),
                    _buildConfigRow('API URL', apiConfig.baseUrl),
                    _buildConfigRow('API Key', '${apiConfig.apiKey.substring(0, 5)}...'),
                    _buildConfigRow('Logging', apiConfig.enableLogging ? 'Enabled' : 'Disabled'),
                    _buildConfigRow('SSL', apiConfig.useSSL ? 'Enabled' : 'Disabled'),
                    _buildConfigRow('Timeout', '${apiConfig.timeout.inSeconds}s'),
                    _buildConfigRow('Max Retries', apiConfig.maxRetries.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testConnection,
                    icon: Icon(Icons.cloud),
                    label: Text('Test Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.themeColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchUsers,
                    icon: Icon(Icons.people),
                    label: Text('Fetch Users'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.themeColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Loading Indicator
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: config.themeColor),
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ],
                ),
              ),

            // Error Display
            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(_error!, style: TextStyle(color: Colors.red.shade900)),
                    ],
                  ),
                ),
              ),

            // Environment Data Display
            if (_environmentData != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Environment Info',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 16),
                      ..._environmentData!.entries.map((entry) {
                        if (entry.value is Map) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${entry.key}: ${jsonEncode(entry.value)}',
                              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(color: Colors.green.shade900),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            // Users Display
            if (_users != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Users (${_users!.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 16),
                      ..._users!.map((user) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(user['name'][0]),
                            backgroundColor: config.themeColor,
                            foregroundColor: Colors.white,
                          ),
                          title: Text(user['name']),
                          subtitle: Text(user['email']),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            // Usage Instructions
            SizedBox(height: 20),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'How to Run',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildCommandText(
                      'flutter run --dart-define=FLAVOR=dev --dart-define=API_KEY=dev_key',
                    ),
                    _buildCommandText(
                      'flutter run --dart-define=FLAVOR=staging --dart-define=API_KEY=staging_key',
                    ),
                    _buildCommandText(
                      'flutter run --dart-define=FLAVOR=prod --dart-define=API_KEY=prod_key',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandText(String command) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        command,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }
}
