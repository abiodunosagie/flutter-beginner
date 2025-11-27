# Complex Async Patterns: Advanced Real-World Techniques

## 5-Year-Old Explanation

Imagine you're trying to download a big video game, but your internet is wonky:

**Without smart patterns:**
- Download starts... internet cuts out... GAME OVER, start from scratch
- You have to babysit the download the whole time

**With smart patterns:**
- Download starts... internet cuts out... automatically tries again!
- Takes too long? Cancel and try a different server
- Multiple files? Download 3 at a time (not all 100 at once!)
- Show a progress bar so you know what's happening

Complex async patterns are like having a SUPER SMART download manager that handles all the tricky situations automatically. Instead of you having to watch and fix problems, the code is smart enough to:
- Try again if something fails
- Wait a bit longer each time before retrying
- Cancel if it takes forever
- Handle multiple things at once without breaking
- Keep things organized even when chaos happens!

These patterns make your app feel professional and reliable - like apps made by big companies!

---

## What You'll Learn

In this advanced lesson, you'll master:
- Retry logic with exponential backoff
- Race conditions and how to prevent them
- Combining multiple Futures and Streams
- Cancellable operations
- Polling and long-polling patterns
- Debouncing and throttling
- Request queuing and rate limiting
- Circuit breaker pattern
- Timeout strategies
- Building a complete download manager

By the end, you'll handle any complex async scenario like a pro!

## Understanding Complex Async Patterns

### What Are Complex Patterns?

Simple async is like ordering food:
- You order 🍔
- You wait
- You get food ✅

Complex patterns are like:
- Ordering from 3 restaurants at once (whichever delivers first wins)
- Reordering automatically if delivery fails
- Canceling order if it takes too long
- Limiting to 5 orders maximum at a time

Let's learn ALL these patterns!

## Pattern 1: Retry with Exponential Backoff

### The Problem

```dart
// ❌ Network call fails sometimes
Future<Data> fetchData() async {
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed');  // Just gives up!
  }

  return Data.fromJson(jsonDecode(response.body));
}
```

### The Solution: Retry

```dart
Future<Data> fetchDataWithRetry({int maxAttempts = 3}) async {
  int attempt = 0;

  while (attempt < maxAttempts) {
    attempt++;

    try {
      print('Attempt $attempt of $maxAttempts');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Data.fromJson(jsonDecode(response.body));
      }

      throw HttpException('Status: ${response.statusCode}');

    } catch (e) {
      print('Attempt $attempt failed: $e');

      if (attempt >= maxAttempts) {
        print('All attempts failed');
        rethrow;  // Give up after max attempts
      }

      // Wait before retrying (exponential backoff)
      final delay = Duration(seconds: pow(2, attempt - 1).toInt());
      print('Waiting ${delay.inSeconds}s before retry...');

      await Future.delayed(delay);
    }
  }

  throw Exception('Should never reach here');
}

// Retry delays:
// Attempt 1 fails → wait 1 second
// Attempt 2 fails → wait 2 seconds
// Attempt 3 fails → wait 4 seconds
```

### Generic Retry Function

```dart
Future<T> retry<T>(
  Future<T> Function() fn, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(seconds: 1),
  double multiplier = 2.0,
}) async {
  int attempt = 0;
  Duration delay = initialDelay;

  while (attempt < maxAttempts) {
    attempt++;

    try {
      return await fn();
    } catch (e) {
      if (attempt >= maxAttempts) {
        rethrow;
      }

      print('Retry attempt $attempt failed. Waiting ${delay.inSeconds}s...');
      await Future.delayed(delay);

      delay *= multiplier;  // Exponential backoff
    }
  }

  throw Exception('Unreachable');
}

// Usage
final data = await retry(
  () => fetchData(),
  maxAttempts: 5,
  initialDelay: Duration(seconds: 2),
  multiplier: 2.0,
);
```

## Pattern 2: Race Conditions Prevention

### The Problem: Race Condition

```dart
class SearchService {
  Future<List<String>> search(String query) async {
    await Future.delayed(Duration(seconds: 2));
    return ['Result for $query'];
  }
}

// ❌ RACE CONDITION!
class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _service = SearchService();
  List<String> _results = [];

  void _search(String query) async {
    // User types "fl" → search starts (2s)
    // User types "flutter" → another search starts (2s)
    // Second search finishes first!
    // First search finishes and overwrites results!
    // Shows results for "fl" instead of "flutter" ❌

    final results = await _service.search(query);
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _search,
      // ...
    );
  }
}
```

### Solution 1: Cancel Previous Request

```dart
class _SearchWidgetState extends State<SearchWidget> {
  final _service = SearchService();
  List<String> _results = [];
  int _requestId = 0;  // ✅ Track requests

  void _search(String query) async {
    final currentRequestId = ++_requestId;  // New request ID

    final results = await _service.search(query);

    // Only update if this is still the latest request
    if (currentRequestId == _requestId) {
      setState(() {
        _results = results;
      });
    } else {
      print('Ignoring old request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(onChanged: _search);
  }
}
```

### Solution 2: Use StreamController

```dart
class SearchBloc {
  final _queryController = StreamController<String>();
  final _resultsController = StreamController<List<String>>();

  Stream<List<String>> get results => _resultsController.stream;

  SearchBloc() {
    _queryController.stream
        .debounceTime(Duration(milliseconds: 500))  // Wait for pause
        .distinct()  // Ignore duplicates
        .asyncMap((query) => _performSearch(query))  // Search
        .listen(_resultsController.add);
  }

  void search(String query) {
    _queryController.add(query);
  }

  Future<List<String>> _performSearch(String query) async {
    await Future.delayed(Duration(seconds: 2));
    return ['Result for $query'];
  }

  void dispose() {
    _queryController.close();
    _resultsController.close();
  }
}
```

## Pattern 3: Combining Multiple Futures

### Parallel Execution - All Must Succeed

```dart
Future<DashboardData> loadDashboard() async {
  try {
    // ✅ All run in parallel!
    final results = await Future.wait([
      fetchUser(),      // 2s
      fetchProducts(),  // 3s
      fetchOrders(),    // 1s
    ]);

    // Total time: 3s (not 6s!)

    return DashboardData(
      user: results[0] as User,
      products: results[1] as List<Product>,
      orders: results[2] as List<Order>,
    );
  } catch (e) {
    // If ANY fails, all fail
    print('Dashboard load failed: $e');
    rethrow;
  }
}
```

### Parallel Execution - Some Can Fail

```dart
Future<DashboardData> loadDashboardResilient() async {
  final results = await Future.wait(
    [
      fetchUser(),
      fetchProducts(),
      fetchOrders(),
    ],
    eagerError: false,  // ✅ Don't fail on first error
  );

  return DashboardData(
    user: results[0] as User?,  // Might be null
    products: results[1] as List<Product>? ?? [],
    orders: results[2] as List<Order>? ?? [],
  );
}
```

### Race - First to Complete Wins

```dart
Future<Data> fetchFastest() async {
  // Try 3 servers, use whichever responds first!
  final data = await Future.any([
    fetchFromServer1(),
    fetchFromServer2(),
    fetchFromServer3(),
  ]);

  return data;
}
```

## Pattern 4: Cancellable Operations

### Using CancelableOperation

```dart
import 'package:async/async.dart';

class DownloadService {
  CancelableOperation<String>? _currentDownload;

  Future<String> downloadFile(String url) async {
    // Cancel previous download if exists
    _currentDownload?.cancel();

    // Create cancellable operation
    _currentDownload = CancelableOperation.fromFuture(
      _performDownload(url),
    );

    try {
      return await _currentDownload!.value;
    } catch (e) {
      if (_currentDownload!.isCanceled) {
        print('Download was canceled');
      }
      rethrow;
    }
  }

  void cancelDownload() {
    _currentDownload?.cancel();
  }

  Future<String> _performDownload(String url) async {
    print('Downloading $url...');
    await Future.delayed(Duration(seconds: 5));
    return 'File content';
  }
}

// Usage
void main() async {
  final service = DownloadService();

  // Start download
  final download = service.downloadFile('https://example.com/large-file');

  // Cancel after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    service.cancelDownload();
  });

  try {
    final content = await download;
    print('Downloaded: $content');
  } catch (e) {
    print('Download failed or canceled');
  }
}
```

## Pattern 5: Polling

### Simple Polling

```dart
Future<void> pollForUpdates() async {
  while (true) {
    try {
      final updates = await checkForUpdates();

      if (updates.isNotEmpty) {
        print('Found ${updates.length} updates');
        processUpdates(updates);
      }

      // Wait before next poll
      await Future.delayed(Duration(seconds: 30));

    } catch (e) {
      print('Poll failed: $e');
      // Continue polling even on error
      await Future.delayed(Duration(seconds: 30));
    }
  }
}
```

### Polling with Stop Condition

```dart
Future<Status> pollUntilComplete({
  required Future<Status> Function() check,
  Duration interval = const Duration(seconds: 5),
  Duration timeout = const Duration(minutes: 10),
}) async {
  final deadline = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(deadline)) {
    final status = await check();

    if (status.isComplete) {
      return status;  // Done!
    }

    print('Not ready yet, waiting ${interval.inSeconds}s...');
    await Future.delayed(interval);
  }

  throw TimeoutException('Polling timed out after ${timeout.inMinutes} minutes');
}

// Usage
final status = await pollUntilComplete(
  check: () => checkJobStatus(jobId),
  interval: Duration(seconds: 10),
  timeout: Duration(minutes: 30),
);
```

## Pattern 6: Request Queue with Rate Limiting

```dart
class RequestQueue {
  final int maxConcurrent;
  final Duration minDelay;

  int _activeRequests = 0;
  DateTime? _lastRequestTime;
  final List<_QueuedRequest> _queue = [];

  RequestQueue({
    this.maxConcurrent = 3,
    this.minDelay = const Duration(milliseconds: 100),
  });

  Future<T> add<T>(Future<T> Function() request) async {
    final completer = Completer<T>();

    _queue.add(_QueuedRequest(
      request: request,
      completer: completer,
    ));

    _processQueue();

    return completer.future;
  }

  void _processQueue() async {
    while (_queue.isNotEmpty && _activeRequests < maxConcurrent) {
      // Enforce minimum delay between requests
      if (_lastRequestTime != null) {
        final elapsed = DateTime.now().difference(_lastRequestTime!);
        if (elapsed < minDelay) {
          await Future.delayed(minDelay - elapsed);
        }
      }

      final queued = _queue.removeAt(0);
      _activeRequests++;
      _lastRequestTime = DateTime.now();

      try {
        final result = await queued.request();
        queued.completer.complete(result);
      } catch (e) {
        queued.completer.completeError(e);
      } finally {
        _activeRequests--;
        _processQueue();  // Process next
      }
    }
  }
}

class _QueuedRequest<T> {
  final Future<T> Function() request;
  final Completer<T> completer;

  _QueuedRequest({
    required this.request,
    required this.completer,
  });
}

// Usage
void main() async {
  final queue = RequestQueue(
    maxConcurrent: 2,  // Only 2 at a time
    minDelay: Duration(milliseconds: 500),  // 500ms between each
  );

  // Add 10 requests
  final futures = List.generate(10, (i) {
    return queue.add(() => fetchData(i));
  });

  // Wait for all to complete
  final results = await Future.wait(futures);
  print('All done: ${results.length} results');
}
```

## Pattern 7: Circuit Breaker

Prevent cascading failures when a service is down:

```dart
enum CircuitState { closed, open, halfOpen }

class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;

  CircuitState _state = CircuitState.closed;
  int _failureCount = 0;
  DateTime? _nextAttempt;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(minutes: 1),
  });

  Future<T> execute<T>(Future<T> Function() fn) async {
    // Check circuit state
    if (_state == CircuitState.open) {
      if (DateTime.now().isAfter(_nextAttempt!)) {
        _state = CircuitState.halfOpen;
        print('Circuit half-open, trying...');
      } else {
        throw Exception('Circuit is open, not attempting');
      }
    }

    try {
      final result = await fn();

      // Success!
      if (_state == CircuitState.halfOpen) {
        _state = CircuitState.closed;
        _failureCount = 0;
        print('Circuit closed after successful attempt');
      }

      return result;

    } catch (e) {
      _failureCount++;

      if (_failureCount >= failureThreshold) {
        _state = CircuitState.open;
        _nextAttempt = DateTime.now().add(timeout);
        print('Circuit opened after $failureThreshold failures');
      }

      rethrow;
    }
  }
}

// Usage
void main() async {
  final circuit = CircuitBreaker(
    failureThreshold: 3,
    timeout: Duration(seconds: 30),
  );

  for (int i = 0; i < 10; i++) {
    try {
      final data = await circuit.execute(() => unreliableService());
      print('Success: $data');
    } catch (e) {
      print('Failed: $e');
    }

    await Future.delayed(Duration(seconds: 2));
  }
}
```

## Pattern 8: Complete Download Manager

Let's combine everything into a real download manager!

```dart
class DownloadManager {
  final int maxConcurrent;
  final RequestQueue _queue;
  final Map<String, DownloadTask> _downloads = {};

  DownloadManager({this.maxConcurrent = 3})
      : _queue = RequestQueue(maxConcurrent: maxConcurrent);

  Stream<DownloadProgress> download(String url, String savePath) {
    final controller = StreamController<DownloadProgress>();

    final task = DownloadTask(
      url: url,
      savePath: savePath,
      controller: controller,
    );

    _downloads[url] = task;

    _queue.add(() => _performDownload(task));

    return controller.stream;
  }

  Future<void> _performDownload(DownloadTask task) async {
    try {
      // Download with progress
      await retry(
        () => _downloadWithProgress(task),
        maxAttempts: 3,
      );

      task.controller.add(DownloadProgress(
        url: task.url,
        status: DownloadStatus.completed,
        progress: 1.0,
      ));

    } catch (e) {
      task.controller.add(DownloadProgress(
        url: task.url,
        status: DownloadStatus.failed,
        error: e.toString(),
      ));
    } finally {
      task.controller.close();
      _downloads.remove(task.url);
    }
  }

  Future<void> _downloadWithProgress(DownloadTask task) async {
    task.controller.add(DownloadProgress(
      url: task.url,
      status: DownloadStatus.downloading,
      progress: 0.0,
    ));

    // Simulate download with progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 500));

      task.controller.add(DownloadProgress(
        url: task.url,
        status: DownloadStatus.downloading,
        progress: i / 100,
      ));
    }

    // Save file
    await _saveFile(task.savePath, 'Downloaded content');
  }

  Future<void> _saveFile(String path, String content) async {
    // In real app, use dart:io to save file
    await Future.delayed(Duration(milliseconds: 500));
  }

  void cancelDownload(String url) {
    final task = _downloads[url];
    if (task != null) {
      task.controller.close();
      _downloads.remove(url);
    }
  }
}

class DownloadTask {
  final String url;
  final String savePath;
  final StreamController<DownloadProgress> controller;

  DownloadTask({
    required this.url,
    required this.savePath,
    required this.controller,
  });
}

class DownloadProgress {
  final String url;
  final DownloadStatus status;
  final double progress;
  final String? error;

  DownloadProgress({
    required this.url,
    required this.status,
    this.progress = 0.0,
    this.error,
  });
}

enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  canceled,
}

// Usage
void main() async {
  final manager = DownloadManager(maxConcurrent: 2);

  final urls = [
    'https://example.com/file1.zip',
    'https://example.com/file2.zip',
    'https://example.com/file3.zip',
  ];

  for (final url in urls) {
    manager.download(url, '/downloads/${url.split('/').last}').listen(
      (progress) {
        print('${progress.url}: ${(progress.progress * 100).toStringAsFixed(1)}%');
      },
      onDone: () {
        print('Download complete!');
      },
      onError: (e) {
        print('Download failed: $e');
      },
    );
  }
}
```

## Progressive Exercises

### Exercise 1: Simple Retry (Beginner)
**Goal:** Implement basic retry logic

Create a function that fetches user data with retry:
- Max 3 attempts
- 2 second delay between attempts
- Print attempt number
- Return user or throw error after all attempts fail

### Exercise 2: Exponential Backoff (Beginner-Intermediate)
**Goal:** Implement retry with increasing delays

Enhance Exercise 1 with:
- First retry after 1s
- Second retry after 2s
- Third retry after 4s
- Fourth retry after 8s

### Exercise 3: Search with Debounce (Intermediate)
**Goal:** Prevent race conditions in search

Create a search widget that:
- Debounces input (500ms)
- Cancels previous searches
- Shows loading state
- Displays results
- Handles errors

**Hint:** Use StreamController with debounce.

### Exercise 4: Parallel Data Loading (Intermediate)
**Goal:** Load multiple resources efficiently

Create a dashboard that loads:
- User profile (2s)
- Recent posts (3s)
- Notifications (1s)
- Settings (1s)

Load all in parallel and measure total time.

### Exercise 5: Download Queue with Progress (Advanced)
**Goal:** Build complete download system

Create a download manager with:
- Queue downloads (max 3 concurrent)
- Show progress for each download
- Retry failed downloads (max 3 attempts)
- Cancel individual downloads
- Pause/resume (bonus!)

## What You've Learned

✅ Retry logic with exponential backoff
✅ Preventing race conditions
✅ Combining multiple Futures and Streams
✅ Cancellable operations
✅ Polling patterns
✅ Request queuing and rate limiting
✅ Circuit breaker pattern
✅ Timeout strategies
✅ Building production-ready async systems

## Phase 7 Complete! 🎉

You've now mastered:
1. **Futures vs Streams** - When to use each
2. **StreamControllers** - Creating custom streams
3. **Isolates** - True parallel processing
4. **Complex Patterns** - Production-ready techniques

## Next Phase

In Phase 8, we'll dive into:
- **Local Data Storage**
- SharedPreferences for simple data
- SQLite for relational databases
- Hive for fast NoSQL storage
- Drift for type-safe SQL
- Building offline-first apps

You're now an async programming master! 🚀
