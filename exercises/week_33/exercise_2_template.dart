/// Week 33, Exercise 2: API Configuration per Flavor
///
/// BEGINNER-INTERMEDIATE LEVEL
///
/// Create an app with flavor-specific API configurations:
/// 1. Different API endpoints for dev/staging/prod
/// 2. Config class that provides the correct endpoint
/// 3. Simple HTTP service that uses flavor-specific endpoints
/// 4. UI to test API calls with different flavors
/// 5. Show how to handle different API keys per flavor
///
/// Learning objectives:
/// - Environment-specific API configuration
/// - Secure handling of API endpoints
/// - Testing with different backend environments
/// - HTTP client integration with flavors
///
/// Required packages:
/// - http: ^1.1.0
///
/// To run:
/// - flutter run --dart-define=FLAVOR=dev --dart-define=API_KEY=dev_key_123
/// - flutter run --dart-define=FLAVOR=staging --dart-define=API_KEY=staging_key_456
/// - flutter run --dart-define=FLAVOR=prod --dart-define=API_KEY=prod_key_789

import 'package:flutter/material.dart';
// TODO: import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO: Create AppFlavor enum (dev, staging, prod)

// TODO: Create ApiConfig class
// class ApiConfig {
//   final String baseUrl;
//   final String apiKey;
//   final Duration timeout;
//   final bool enableLogging;
//
//   ApiConfig({
//     required this.baseUrl,
//     required this.apiKey,
//     required this.timeout,
//     required this.enableLogging,
//   });
//
//   // TODO: Add factory constructor for each flavor
//   // factory ApiConfig.forFlavor(AppFlavor flavor, String apiKey) {
//   //   switch (flavor) {
//   //     case AppFlavor.dev:
//   //       return ApiConfig(
//   //         baseUrl: 'https://dev-api.example.com',
//   //         apiKey: apiKey,
//   //         timeout: Duration(seconds: 30),
//   //         enableLogging: true,
//   //       );
//   //     // Add other flavors...
//   //   }
//   // }
// }

// TODO: Create AppConfig class to manage flavor and API configuration
// class AppConfig {
//   final AppFlavor flavor;
//   final ApiConfig apiConfig;
//
//   AppConfig({
//     required this.flavor,
//     required this.apiConfig,
//   });
//
//   static AppConfig? _instance;
//   static AppConfig get instance => _instance!;
//
//   static void initialize({required AppConfig config}) {
//     _instance = config;
//   }
// }

// TODO: Create ApiService class
// class ApiService {
//   final ApiConfig config;
//
//   ApiService(this.config);
//
//   // TODO: Implement method to fetch users
//   // Future<List<dynamic>> fetchUsers() async {
//   //   final url = '${config.baseUrl}/users';
//   //   // Make HTTP request
//   //   // Parse response
//   //   // Return data
//   // }
//
//   // TODO: Implement method to get environment info
//   // Future<Map<String, dynamic>> getEnvironmentInfo() async {
//   //   // Return mock data showing which environment we're hitting
//   // }
// }

void main() {
  // TODO: Read flavor and API key from environment
  // const flavorString = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  // const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

  // TODO: Initialize AppConfig

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Config Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  // TODO: Create ApiService instance
  // late final ApiService _apiService;

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize ApiService
    // _apiService = ApiService(AppConfig.instance.apiConfig);
  }

  // TODO: Implement method to test API connection
  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _data = null;
    });

    try {
      // TODO: Call API service to get environment info
      // final data = await _apiService.getEnvironmentInfo();
      // setState(() {
      //   _data = data;
      //   _isLoading = false;
      // });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Get current config
    // final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('API Configuration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Display current flavor
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Configuration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    // TODO: Show flavor name
                    Text('Flavor: ???'),
                    // TODO: Show API base URL
                    Text('API URL: ???'),
                    // TODO: Show if logging is enabled
                    Text('Logging: ???'),
                    // TODO: Show timeout duration
                    Text('Timeout: ???'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Test connection button
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: Text('Test API Connection'),
            ),
            SizedBox(height: 20),

            // Results
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(_error!),
                    ],
                  ),
                ),
              )
            else if (_data != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Response',
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // TODO: Display response data
                      Text('Data: ${_data.toString()}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/*
BEST PRACTICES FOR API CONFIGURATION:

1. NEVER commit API keys to version control
2. Use --dart-define for runtime configuration
3. Use .env files with flutter_dotenv for local development
4. Store production secrets in CI/CD environment variables
5. Different base URLs per flavor
6. Enable detailed logging in dev, minimal in prod
7. Longer timeouts in dev for debugging
8. Use different authentication mechanisms per flavor

SECURITY NOTES:
- API keys passed via --dart-define are compiled into the app
- For production, consider using secure storage or backend proxy
- Never log sensitive data in production
- Use certificate pinning for production APIs

EXAMPLE .env FILES:
.env.dev:
API_KEY=dev_api_key_12345
API_URL=https://dev-api.example.com

.env.staging:
API_KEY=staging_api_key_67890
API_URL=https://staging-api.example.com

.env.prod:
API_KEY=prod_api_key_xxxxx
API_URL=https://api.example.com
*/
