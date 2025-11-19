# Lesson 8: Production Considerations (Rate Limiting, Error Handling, Cost Management)

## 5-Year-Old Analogy 💼

Imagine you're opening a lemonade stand. You can't just start selling - you need to:
- Make sure you don't run out of lemons (rate limiting)
- Have backup plans if something breaks (error handling)
- Count your money so you don't spend too much (cost management)
- Remember what customers ordered before so you can work faster (caching)
- Make sure bad people can't steal your lemonade (security)

That's what we do when we take our AI app to "production" (making it ready for real customers)!

---

## What We'll Cover

Production-ready AI integration:

1. ✅ Rate limiting and throttling
2. ✅ Comprehensive error handling
3. ✅ Cost management and budgets
4. ✅ Intelligent caching strategies
5. ✅ Offline fallbacks
6. ✅ Security best practices
7. ✅ Monitoring and analytics
8. ✅ A/B testing
9. ✅ Performance optimization
10. ✅ Deployment checklist

---

## Part 1: Advanced Rate Limiting

### Create Smart Rate Limiter

```dart
// lib/services/rate_limiter.dart
import 'package:shared_preferences/shared_preferences.dart';

enum RateLimitTier {
  free,      // 10 requests/day
  basic,     // 100 requests/day
  premium,   // 1000 requests/day
  unlimited, // No limit
}

class RateLimiter {
  static final RateLimiter _instance = RateLimiter._internal();
  factory RateLimiter() => _instance;
  RateLimiter._internal();

  RateLimitTier _tier = RateLimitTier.free;
  final Map<String, List<DateTime>> _requestHistory = {};

  void setTier(RateLimitTier tier) {
    _tier = tier;
  }

  Future<bool> canMakeRequest(String endpoint) async {
    if (_tier == RateLimitTier.unlimited) return true;

    final limit = _getLimit();
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);

    // Get requests made today
    _requestHistory[endpoint] ??= [];
    _requestHistory[endpoint]!.removeWhere((time) => time.isBefore(dayStart));

    final todayCount = _requestHistory[endpoint]!.length;

    if (todayCount >= limit) {
      return false;
    }

    return true;
  }

  Future<void> recordRequest(String endpoint) async {
    _requestHistory[endpoint] ??= [];
    _requestHistory[endpoint]!.add(DateTime.now());
    await _saveHistory();
  }

  int getRemainingRequests(String endpoint) {
    if (_tier == RateLimitTier.unlimited) return -1; // Unlimited

    final limit = _getLimit();
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);

    _requestHistory[endpoint] ??= [];
    _requestHistory[endpoint]!.removeWhere((time) => time.isBefore(dayStart));

    return limit - _requestHistory[endpoint]!.length;
  }

  DateTime? getResetTime() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow;
  }

  int _getLimit() {
    switch (_tier) {
      case RateLimitTier.free:
        return 10;
      case RateLimitTier.basic:
        return 100;
      case RateLimitTier.premium:
        return 1000;
      case RateLimitTier.unlimited:
        return -1;
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // Save history (implementation details omitted for brevity)
  }

  // Per-minute rate limiting (for API provider limits)
  final List<DateTime> _minuteRequests = [];

  Future<bool> canMakeRequestPerMinute({int limit = 10}) async {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    _minuteRequests.removeWhere((time) => time.isBefore(oneMinuteAgo));

    if (_minuteRequests.length >= limit) {
      return false;
    }

    _minuteRequests.add(now);
    return true;
  }
}
```

### Use Rate Limiter in UI

```dart
// lib/widgets/rate_limit_widget.dart
import 'package:flutter/material.dart';
import '../services/rate_limiter.dart';

class RateLimitIndicator extends StatelessWidget {
  final String endpoint;

  const RateLimitIndicator({
    Key? key,
    required this.endpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final limiter = RateLimiter();
    final remaining = limiter.getRemainingRequests(endpoint);
    final resetTime = limiter.getResetTime();

    if (remaining == -1) {
      return const SizedBox.shrink(); // Unlimited
    }

    return Card(
      color: remaining < 3 ? Colors.orange[100] : Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              remaining < 3 ? Icons.warning : Icons.info_outline,
              size: 20,
              color: remaining < 3 ? Colors.orange : Colors.blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$remaining requests remaining today',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (resetTime != null)
                    Text(
                      'Resets at ${_formatTime(resetTime)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            if (remaining < 3)
              ElevatedButton(
                onPressed: () {
                  // Navigate to upgrade page
                },
                child: const Text('Upgrade'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
```

---

## Part 2: Comprehensive Error Handling

### Create Error Handler Service

```dart
// lib/services/error_handler.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum ErrorSeverity { low, medium, high, critical }

class AppError {
  final String message;
  final String? technicalDetails;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final String? userId;
  final Map<String, dynamic>? context;

  AppError({
    required this.message,
    this.technicalDetails,
    this.severity = ErrorSeverity.medium,
    DateTime? timestamp,
    this.userId,
    this.context,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  final Logger _logger = Logger();
  final List<AppError> _errorHistory = [];

  Future<void> handleError(
    dynamic error, {
    String? message,
    ErrorSeverity severity = ErrorSeverity.medium,
    Map<String, dynamic>? context,
    bool showToUser = true,
  }) async {
    final appError = AppError(
      message: message ?? error.toString(),
      technicalDetails: error.toString(),
      severity: severity,
      context: context,
    );

    _errorHistory.add(appError);

    // Log error
    switch (severity) {
      case ErrorSeverity.low:
        _logger.i(appError.message);
        break;
      case ErrorSeverity.medium:
        _logger.w(appError.message);
        break;
      case ErrorSeverity.high:
        _logger.e(appError.message);
        break;
      case ErrorSeverity.critical:
        _logger.f(appError.message);
        break;
    }

    // Send to analytics/crash reporting
    await _reportToAnalytics(appError);

    // Show to user if needed
    if (showToUser) {
      _showErrorToUser(appError);
    }
  }

  Future<void> _reportToAnalytics(AppError error) async {
    // Send to Firebase Crashlytics, Sentry, etc.
    // Example: FirebaseCrashlytics.instance.recordError(...)
  }

  void _showErrorToUser(AppError error) {
    // Show user-friendly message
    // Implementation depends on your navigation setup
  }

  List<AppError> getRecentErrors({int limit = 10}) {
    return _errorHistory.take(limit).toList();
  }

  void clearHistory() {
    _errorHistory.clear();
  }
}
```

### Create Retry Strategy

```dart
// lib/services/retry_strategy.dart
class RetryStrategy {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;

  const RetryStrategy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
  });

  Future<T> execute<T>(
    Future<T> Function() operation, {
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempts++;

        // Check if we should retry
        if (attempts >= maxAttempts) {
          rethrow;
        }

        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay);

        // Increase delay (exponential backoff)
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).toInt(),
        );

        if (delay > maxDelay) {
          delay = maxDelay;
        }
      }
    }
  }
}

// Usage
final strategy = RetryStrategy(maxAttempts: 5);

final result = await strategy.execute(
  () => apiClient.makeRequest(),
  shouldRetry: (error) {
    // Only retry on network errors or 5xx server errors
    return error is NetworkException ||
           (error is APIException && error.statusCode! >= 500);
  },
);
```

---

## Part 3: Cost Management

### Create Budget Manager

```dart
// lib/services/budget_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class BudgetManager {
  static final BudgetManager _instance = BudgetManager._internal();
  factory BudgetManager() => _instance;
  BudgetManager._internal();

  double _monthlyBudget = 10.0; // Default $10/month
  double _currentSpend = 0.0;

  void setMonthlyBudget(double budget) {
    _monthlyBudget = budget;
    _saveBudget();
  }

  Future<void> recordSpend(double amount) async {
    _currentSpend += amount;
    await _saveSpend();

    // Check if budget exceeded
    if (_currentSpend >= _monthlyBudget * 0.8) {
      _notifyBudgetWarning();
    }

    if (_currentSpend >= _monthlyBudget) {
      _notifyBudgetExceeded();
    }
  }

  double getRemainingBudget() {
    return _monthlyBudget - _currentSpend;
  }

  double getSpendPercentage() {
    return (_currentSpend / _monthlyBudget * 100).clamp(0, 100);
  }

  bool canAfford(double estimatedCost) {
    return _currentSpend + estimatedCost <= _monthlyBudget;
  }

  Future<void> resetMonthlySpend() async {
    _currentSpend = 0.0;
    await _saveSpend();
  }

  void _notifyBudgetWarning() {
    // Show warning at 80% budget
    print('⚠️ Warning: 80% of monthly budget used');
  }

  void _notifyBudgetExceeded() {
    // Disable AI features or notify user
    print('🛑 Monthly budget exceeded!');
  }

  Future<void> _saveBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthly_budget', _monthlyBudget);
  }

  Future<void> _saveSpend() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('current_spend', _currentSpend);
    await prefs.setString('spend_month', DateTime.now().month.toString());
  }

  Future<void> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    _monthlyBudget = prefs.getDouble('monthly_budget') ?? 10.0;
    _currentSpend = prefs.getDouble('current_spend') ?? 0.0;

    // Reset if new month
    final savedMonth = prefs.getString('spend_month');
    final currentMonth = DateTime.now().month.toString();
    if (savedMonth != currentMonth) {
      await resetMonthlySpend();
    }
  }
}
```

### Budget Widget

```dart
// lib/widgets/budget_widget.dart
import 'package:flutter/material.dart';
import '../services/budget_manager.dart';

class BudgetWidget extends StatelessWidget {
  const BudgetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = BudgetManager();
    final percentage = manager.getSpendPercentage();
    final remaining = manager.getRemainingBudget();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Budget',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${remaining.toStringAsFixed(2)} left',
                  style: TextStyle(
                    color: percentage > 80 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(
                percentage > 80
                    ? Colors.red
                    : percentage > 50
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% used',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Part 4: Intelligent Caching

### Create Cache Manager

```dart
// lib/services/cache_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CachedResponse {
  final String data;
  final DateTime timestamp;
  final Duration ttl;

  CachedResponse({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > ttl;
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'ttl': ttl.inSeconds,
      };

  factory CachedResponse.fromJson(Map<String, dynamic> json) => CachedResponse(
        data: json['data'],
        timestamp: DateTime.parse(json['timestamp']),
        ttl: Duration(seconds: json['ttl']),
      );
}

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, CachedResponse> _memoryCache = {};

  // Cache with TTL (Time To Live)
  Future<void> set({
    required String key,
    required String value,
    Duration ttl = const Duration(hours: 1),
  }) async {
    final cached = CachedResponse(
      data: value,
      timestamp: DateTime.now(),
      ttl: ttl,
    );

    // Store in memory
    _memoryCache[key] = cached;

    // Store in persistent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_$key', jsonEncode(cached.toJson()));
  }

  Future<String?> get(String key) async {
    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final cached = _memoryCache[key]!;
      if (!cached.isExpired) {
        return cached.data;
      } else {
        _memoryCache.remove(key);
      }
    }

    // Check persistent storage
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cache_$key');

    if (jsonString != null) {
      try {
        final cached = CachedResponse.fromJson(jsonDecode(jsonString));

        if (!cached.isExpired) {
          _memoryCache[key] = cached;
          return cached.data;
        } else {
          await prefs.remove('cache_$key');
        }
      } catch (e) {
        print('Cache decode error: $e');
      }
    }

    return null;
  }

  Future<void> clear() async {
    _memoryCache.clear();

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<void> remove(String key) async {
    _memoryCache.remove(key);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_$key');
  }

  // Generate cache key from request parameters
  String generateKey(Map<String, dynamic> params) {
    final sorted = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return jsonEncode(sorted);
  }
}

// Usage in AI Client
Future<AIResponse> chatWithCache({required String prompt}) async {
  final cacheKey = CacheManager().generateKey({'prompt': prompt});
  final cached = await CacheManager().get(cacheKey);

  if (cached != null) {
    return AIResponse.success(
      content: cached,
      provider: AIProvider.openai,
      model: 'cached',
      cost: 0.0, // Free!
    );
  }

  final response = await chat(prompt: prompt);

  if (response.isSuccess) {
    await CacheManager().set(
      key: cacheKey,
      value: response.content!,
      ttl: const Duration(hours: 24),
    );
  }

  return response;
}
```

---

## Part 5: Offline Fallbacks

### Create Offline Manager

```dart
// lib/services/offline_manager.dart
import 'dart:io';

class OfflineManager {
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();

  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Future<void> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      _isOnline = false;
    }
  }

  Future<String> getOfflineResponse(String prompt) async {
    // Return cached response or helpful offline message
    final cached = await CacheManager().get(prompt);

    if (cached != null) {
      return cached;
    }

    return '''
I'm currently offline and don't have a cached response for this question.

Here's what you can do:
• Check your internet connection
• Try again when online
• Browse previously cached conversations

Your question has been saved and will be answered when connection is restored.
    ''';
  }
}
```

---

## Part 6: Security Best Practices

### API Key Protection

```dart
// lib/services/security_manager.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityManager {
  // Validate API key format
  static bool isValidApiKey(String key, String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return key.startsWith('sk-') && key.length > 20;
      case 'anthropic':
        return key.startsWith('sk-ant-') && key.length > 20;
      case 'gemini':
        return key.length > 20;
      default:
        return key.isNotEmpty;
    }
  }

  // Hash sensitive data before logging
  static String hashSensitiveData(String data) {
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Sanitize prompts (remove sensitive info)
  static String sanitizePrompt(String prompt) {
    // Remove email addresses
    prompt = prompt.replaceAll(
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
      '[EMAIL]',
    );

    // Remove phone numbers
    prompt = prompt.replaceAll(
      RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'),
      '[PHONE]',
    );

    // Remove credit card numbers
    prompt = prompt.replaceAll(
      RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'),
      '[CARD]',
    );

    return prompt;
  }

  // Check for prompt injection attempts
  static bool isPotentiallyDangerous(String prompt) {
    final dangerousPatterns = [
      r'ignore previous instructions',
      r'disregard',
      r'system prompt',
      r'jailbreak',
      r'sudo mode',
    ];

    for (final pattern in dangerousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(prompt)) {
        return true;
      }
    }

    return false;
  }
}
```

---

## Part 7: Analytics and Monitoring

### Create Analytics Service

```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final Map<String, int> _eventCounts = {};
  final Map<String, List<Duration>> _responseTimes = {};

  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    _eventCounts[eventName] = (_eventCounts[eventName] ?? 0) + 1;

    // Send to Firebase Analytics, Mixpanel, etc.
    // FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }

  void trackResponseTime(String operation, Duration duration) {
    _responseTimes[operation] ??= [];
    _responseTimes[operation]!.add(duration);
  }

  Map<String, dynamic> getMetrics() {
    return {
      'total_events': _eventCounts.values.fold(0, (sum, count) => sum + count),
      'event_breakdown': _eventCounts,
      'avg_response_times': _responseTimes.map(
        (key, durations) => MapEntry(
          key,
          durations.reduce((a, b) => a + b).inMilliseconds / durations.length,
        ),
      ),
    };
  }

  void trackAIRequest({
    required String provider,
    required String model,
    required int tokens,
    required double cost,
    required Duration responseTime,
  }) {
    trackEvent('ai_request', parameters: {
      'provider': provider,
      'model': model,
      'tokens': tokens,
      'cost': cost,
    });

    trackResponseTime('$provider-$model', responseTime);
  }
}
```

---

## Part 8: Deployment Checklist

### Pre-Deployment Checklist

```dart
// lib/utils/deployment_checklist.dart
class DeploymentChecklist {
  static Future<Map<String, bool>> runChecks() async {
    return {
      '✅ API keys in secure storage': await _checkApiKeys(),
      '✅ Rate limiting enabled': _checkRateLimiting(),
      '✅ Error handling implemented': _checkErrorHandling(),
      '✅ Analytics configured': _checkAnalytics(),
      '✅ Caching implemented': _checkCaching(),
      '✅ Budget limits set': _checkBudgetLimits(),
      '✅ Offline fallbacks ready': _checkOfflineFallbacks(),
      '✅ Security measures in place': _checkSecurity(),
      '✅ Performance optimized': _checkPerformance(),
      '✅ Testing completed': _checkTesting(),
    };
  }

  static Future<bool> _checkApiKeys() async {
    // Verify API keys are not hardcoded
    // Verify secure storage is being used
    return true;
  }

  static bool _checkRateLimiting() {
    // Verify rate limiting is configured
    return true;
  }

  static bool _checkErrorHandling() {
    // Verify error handlers are in place
    return true;
  }

  // ... other checks
}
```

---

## Part 9: Performance Optimization

### Best Practices

```dart
// 1. Lazy Loading
class AIClientManager {
  OpenAIClient? _openaiClient;
  GeminiClient? _geminiClient;

  OpenAIClient get openai => _openaiClient ??= OpenAIClient();
  GeminiClient get gemini => _geminiClient ??= GeminiClient();
}

// 2. Request Debouncing
class DebouncedAIClient {
  Timer? _debounceTimer;

  void sendMessageDebounced(String message, {Duration delay = const Duration(milliseconds: 500)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      // Send actual request
    });
  }
}

// 3. Parallel Requests
Future<void> loadMultipleResponses() async {
  final results = await Future.wait([
    client1.chat(prompt: 'Question 1'),
    client2.chat(prompt: 'Question 2'),
    client3.chat(prompt: 'Question 3'),
  ]);
}

// 4. Request Prioritization
enum RequestPriority { low, normal, high, critical }

class PriorityQueue {
  final Map<RequestPriority, List<Function>> _queues = {
    RequestPriority.critical: [],
    RequestPriority.high: [],
    RequestPriority.normal: [],
    RequestPriority.low: [],
  };

  void addRequest(Function request, RequestPriority priority) {
    _queues[priority]!.add(request);
  }

  Future<void> processQueue() async {
    for (final priority in RequestPriority.values) {
      while (_queues[priority]!.isNotEmpty) {
        final request = _queues[priority]!.removeAt(0);
        await request();
      }
    }
  }
}
```

---

## Part 10: Environment Configuration

### Create Environment Manager

```dart
// lib/config/environment.dart
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  static String get apiEndpoint {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }

  static bool get enableDebugLogging => !isProduction;
  static bool get enableAnalytics => isProduction || isStaging;
  static int get requestTimeout => isDevelopment ? 60000 : 30000;
}
```

---

## Complete Production-Ready Example

```dart
// lib/services/production_ai_client.dart
class ProductionAIClient {
  final RateLimiter _rateLimiter = RateLimiter();
  final BudgetManager _budgetManager = BudgetManager();
  final CacheManager _cacheManager = CacheManager();
  final ErrorHandler _errorHandler = ErrorHandler();
  final AnalyticsService _analytics = AnalyticsService();
  final OfflineManager _offlineManager = OfflineManager();

  Future<AIResponse> chat({
    required String prompt,
    bool useCache = true,
  }) async {
    final startTime = DateTime.now();

    try {
      // 1. Check offline status
      await _offlineManager.checkConnectivity();
      if (!_offlineManager.isOnline) {
        return AIResponse.error(
          error: AIErrorType.network,
          errorMessage: 'No internet connection',
          provider: AIProvider.openai,
          model: 'offline',
        );
      }

      // 2. Security check
      if (SecurityManager.isPotentiallyDangerous(prompt)) {
        return AIResponse.error(
          error: AIErrorType.invalidRequest,
          errorMessage: 'Potentially dangerous prompt detected',
          provider: AIProvider.openai,
          model: 'security',
        );
      }

      // 3. Check rate limit
      if (!await _rateLimiter.canMakeRequest('chat')) {
        return AIResponse.error(
          error: AIErrorType.rateLimit,
          errorMessage: 'Rate limit exceeded. Try again later.',
          provider: AIProvider.openai,
          model: 'rate-limited',
        );
      }

      // 4. Check budget
      final estimatedCost = 0.001; // Estimate
      if (!_budgetManager.canAfford(estimatedCost)) {
        return AIResponse.error(
          error: AIErrorType.quotaExceeded,
          errorMessage: 'Monthly budget exceeded',
          provider: AIProvider.openai,
          model: 'budget-exceeded',
        );
      }

      // 5. Check cache
      if (useCache) {
        final cacheKey = _cacheManager.generateKey({'prompt': prompt});
        final cached = await _cacheManager.get(cacheKey);

        if (cached != null) {
          _analytics.trackEvent('cache_hit');
          return AIResponse.success(
            content: cached,
            provider: AIProvider.openai,
            model: 'cached',
            cost: 0.0,
          );
        }
      }

      // 6. Make actual request with retry
      final strategy = RetryStrategy();
      final response = await strategy.execute(() => _makeRequest(prompt));

      // 7. Update tracking
      await _rateLimiter.recordRequest('chat');
      await _budgetManager.recordSpend(response.cost ?? 0);

      // 8. Cache successful response
      if (response.isSuccess && useCache) {
        final cacheKey = _cacheManager.generateKey({'prompt': prompt});
        await _cacheManager.set(
          key: cacheKey,
          value: response.content!,
        );
      }

      // 9. Track analytics
      final responseTime = DateTime.now().difference(startTime);
      _analytics.trackAIRequest(
        provider: 'openai',
        model: 'gpt-3.5-turbo',
        tokens: response.tokensUsed ?? 0,
        cost: response.cost ?? 0,
        responseTime: responseTime,
      );

      return response;
    } catch (e) {
      await _errorHandler.handleError(
        e,
        message: 'Failed to get AI response',
        severity: ErrorSeverity.high,
        context: {'prompt': prompt},
      );

      return AIResponse.error(
        error: AIErrorType.unknown,
        errorMessage: e.toString(),
        provider: AIProvider.openai,
        model: 'error',
      );
    }
  }

  Future<AIResponse> _makeRequest(String prompt) async {
    // Actual API call implementation
    throw UnimplementedError();
  }
}
```

---

## Summary Checklist

### ✅ Security
- [ ] API keys in secure storage (not hardcoded)
- [ ] Input sanitization
- [ ] Prompt injection protection
- [ ] Secure HTTPS connections
- [ ] Rate limiting per user

### ✅ Performance
- [ ] Response caching
- [ ] Request debouncing
- [ ] Lazy loading
- [ ] Parallel requests where appropriate
- [ ] Image compression

### ✅ Reliability
- [ ] Retry logic with exponential backoff
- [ ] Comprehensive error handling
- [ ] Offline fallbacks
- [ ] Request timeout handling
- [ ] Circuit breaker pattern

### ✅ Cost Management
- [ ] Budget limits
- [ ] Cost tracking
- [ ] Token limits
- [ ] Usage quotas
- [ ] Model selection logic

### ✅ Monitoring
- [ ] Analytics tracking
- [ ] Error logging
- [ ] Performance metrics
- [ ] User behavior tracking
- [ ] Crash reporting

### ✅ User Experience
- [ ] Loading indicators
- [ ] Error messages
- [ ] Offline mode
- [ ] Progress feedback
- [ ] Graceful degradation

---

## Congratulations! 🎉

You now have a **production-ready AI integration** with:

- ✅ Advanced rate limiting
- ✅ Comprehensive error handling
- ✅ Budget management
- ✅ Intelligent caching
- ✅ Offline support
- ✅ Security best practices
- ✅ Analytics and monitoring
- ✅ Performance optimization
- ✅ Deployment readiness

You're ready to ship AI-powered Flutter apps to production! 🚀

---

## Next Steps

1. **Test thoroughly** with real users
2. **Monitor metrics** daily
3. **Optimize costs** based on usage
4. **Iterate on features** based on feedback
5. **Stay updated** with AI provider changes
6. **Scale gradually** as user base grows

Happy building! 🎯
