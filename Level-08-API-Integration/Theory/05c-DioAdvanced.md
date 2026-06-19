# Dio Advanced Features

## The Big Idea In One Sentence

> Dio's pro tools let you tell EXACTLY what went wrong (`DioException` types), stop a request you no longer need (`CancelToken`), and show upload/download progress bars.

Master advanced Dio features: cancellation, progress tracking, and file operations!

---

## Error Handling with Dio

### DioException Types

```dart
Future<void> fetchDataWithErrorHandling() async {
  try {
    final response = await dio.get('/users/999');
    print(response.data);
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('⏱️ Connection timeout - server took too long to connect');
        break;

      case DioExceptionType.sendTimeout:
        print('⏱️ Send timeout - took too long to send request');
        break;

      case DioExceptionType.receiveTimeout:
        print('⏱️ Receive timeout - server took too long to respond');
        break;

      case DioExceptionType.badResponse:
        // Server responded with error status (4xx, 5xx)
        print('❌ Server error: ${e.response?.statusCode}');
        print('Message: ${e.response?.data}');
        break;

      case DioExceptionType.cancel:
        print('🚫 Request was cancelled');
        break;

      case DioExceptionType.connectionError:
        print('📡 No internet connection');
        break;

      case DioExceptionType.badCertificate:
        print('🔒 SSL certificate error');
        break;

      default:
        print('❓ Unknown error: ${e.message}');
    }
  }
}
```

### Visual: Dio Error Types

```
┌─────────────────────────────────────────────────────────────┐
│                    DIO ERROR TYPES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ERROR TYPE           │ WHEN IT HAPPENS                     │
│  ────────────────────────────────────────────────────────── │
│  connectionTimeout    │ Can't connect to server             │
│                       │ (Server unreachable)                │
│                                                             │
│  sendTimeout          │ Couldn't send request in time       │
│                       │ (Slow upload)                       │
│                                                             │
│  receiveTimeout       │ Server not responding               │
│                       │ (Server processing too long)        │
│                                                             │
│  badResponse          │ Server returned 4xx or 5xx          │
│                       │ (400, 401, 404, 500, etc.)          │
│                                                             │
│  cancel               │ You cancelled the request           │
│                       │ (User backed out)                   │
│                                                             │
│  connectionError      │ Network issues / no internet        │
│                       │ (Phone in airplane mode)            │
│                                                             │
│  badCertificate       │ SSL certificate problem             │
│                       │ (Security issue)                    │
│                                                             │
│  unknown              │ Something else went wrong           │
│                       │ (Unexpected error)                  │
│                                                             │
│  FOR badResponse, CHECK:                                    │
│  e.response?.statusCode  →  400, 401, 404, 500, etc.        │
│  e.response?.data        →  Error message from server       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Simple Analogy:**
Think of sending a package:
- `connectionTimeout`: Can't reach the post office
- `sendTimeout`: Taking too long to hand over package
- `receiveTimeout`: Waiting too long for delivery confirmation
- `badResponse`: Package was rejected (wrong address)
- `cancel`: You decided not to send it
- `connectionError`: Road is closed (no internet)

---

## Request Cancellation

### Why Cancel Requests?

Imagine you're downloading a large file, then navigate to a different screen. The download is still happening in the background, wasting data and battery!

```dart
import 'package:dio/dio.dart';

class DataService {
  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  Future<void> fetchLargeData() async {
    // Create a new cancel token for this request
    _cancelToken = CancelToken();

    try {
      final response = await _dio.get(
        '/large-data',
        cancelToken: _cancelToken,
      );

      print('Data loaded: ${response.data}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print('✓ Request cancelled successfully');
      } else {
        print('Error: ${e.message}');
      }
    }
  }

  void cancelRequest() {
    _cancelToken?.cancel('User cancelled the request');
  }
}

// Usage in a Widget
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _dataService.fetchLargeData();
  }

  @override
  void dispose() {
    // Cancel request when user leaves screen!
    _dataService.cancelRequest();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loading Data')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

### Visual: Request Cancellation

```
┌─────────────────────────────────────────────────────────────┐
│                REQUEST CANCELLATION                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SCENARIO: User starts download, then backs out            │
│                                                             │
│  TIME: 0s                                                   │
│  ┌─────────┐                           ┌─────────┐         │
│  │  App    │ ──── GET /big-file ─────→ │ Server  │         │
│  │         │                           │         │         │
│  │ Loading │                           │ Sending │         │
│  │   ...   │                           │ data... │         │
│  └─────────┘                           └─────────┘         │
│                                                             │
│  TIME: 2s (User presses back button)                       │
│  ┌─────────┐                           ┌─────────┐         │
│  │  App    │                           │ Server  │         │
│  │ dispose │ ──── CANCEL TOKEN ──────X │ Sending │         │
│  │ called  │                           │ stopped │         │
│  └─────────┘                           └─────────┘         │
│                                                             │
│  ✓ Request stopped immediately                             │
│  ✓ No data wasted                                          │
│  ✓ Server resources freed                                  │
│                                                             │
│  WITHOUT CANCELLATION:                                      │
│  ✗ Download continues in background                        │
│  ✗ Wastes data and battery                                 │
│  ✗ Server keeps working for nothing                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Upload/Download Progress

### File Upload with Progress

```dart
import 'package:dio/dio.dart';

Future<void> uploadFile(String filePath) async {
  final dio = Dio();

  // Prepare file for upload
  FormData formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      filePath,
      filename: 'photo.jpg',
    ),
    'description': 'My profile photo',
  });

  try {
    await dio.post(
      'https://api.example.com/upload',
      data: formData,
      onSendProgress: (sent, total) {
        double progress = (sent / total) * 100;
        print('Upload progress: ${progress.toStringAsFixed(1)}%');

        // Update UI with progress
        // progressNotifier.value = progress;
      },
    );

    print('✓ Upload complete!');
  } catch (e) {
    print('✗ Upload failed: $e');
  }
}

// Usage
await uploadFile('/path/to/photo.jpg');

// Output:
// Upload progress: 10.0%
// Upload progress: 25.5%
// Upload progress: 50.2%
// Upload progress: 75.8%
// Upload progress: 100.0%
// ✓ Upload complete!
```

### File Download with Progress

```dart
Future<void> downloadFile(String url, String savePath) async {
  final dio = Dio();

  try {
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = (received / total) * 100;
          print('Download progress: ${progress.toStringAsFixed(1)}%');

          // Update UI
          // progressNotifier.value = progress;
        }
      },
    );

    print('✓ Download complete!');
    print('Saved to: $savePath');
  } catch (e) {
    print('✗ Download failed: $e');
  }
}

// Usage
await downloadFile(
  'https://example.com/large-file.zip',
  '/storage/downloads/file.zip',
);
```

### Complete Upload/Download Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final Dio _dio = Dio();
  double _progress = 0.0;
  bool _uploading = false;
  CancelToken? _cancelToken;

  Future<void> uploadFile(String filePath) async {
    setState(() {
      _uploading = true;
      _progress = 0.0;
    });

    _cancelToken = CancelToken();

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    try {
      await _dio.post(
        'https://api.example.com/upload',
        data: formData,
        cancelToken: _cancelToken,
        onSendProgress: (sent, total) {
          setState(() {
            _progress = sent / total;
          });
        },
      );

      setState(() {
        _uploading = false;
        _progress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload complete!')),
      );
    } on DioException catch (e) {
      setState(() {
        _uploading = false;
      });

      if (CancelToken.isCancel(e)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload cancelled')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.message}')),
        );
      }
    }
  }

  void cancelUpload() {
    _cancelToken?.cancel('User cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Upload')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_uploading) ...[
              CircularProgressIndicator(value: _progress),
              SizedBox(height: 20),
              Text('${(_progress * 100).toStringAsFixed(0)}%'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: cancelUpload,
                child: Text('Cancel'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () => uploadFile('/path/to/file'),
                child: Text('Upload File'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## Complete API Service Example

Here's a production-ready API service using all Dio features:

```dart
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  final AuthInterceptor _authInterceptor = AuthInterceptor();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      _authInterceptor,
      _ErrorInterceptor(),
    ]);
  }

  // Set auth token (call after login)
  void setAuthToken(String token) {
    _authInterceptor.setToken(token);
  }

  // Clear auth token (call after logout)
  void clearAuthToken() {
    _authInterceptor.clearToken();
  }

  // GET all users
  Future<List<dynamic>> getUsers() async {
    final response = await _dio.get('/users');
    return response.data;
  }

  // GET single user
  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await _dio.get('/users/$id');
    return response.data;
  }

  // POST create user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final response = await _dio.post('/users', data: data);
    return response.data;
  }

  // PUT update user
  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put('/users/$id', data: data);
    return response.data;
  }

  // DELETE user
  Future<void> deleteUser(int id) async {
    await _dio.delete('/users/$id');
  }

  // Upload file with progress
  Future<void> uploadFile(
    String filePath, {
    required Function(double) onProgress,
    CancelToken? cancelToken,
  }) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    await _dio.post(
      '/upload',
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: (sent, total) {
        onProgress(sent / total);
      },
    );
  }

  // Download file with progress
  Future<void> downloadFile(
    String url,
    String savePath, {
    required Function(double) onProgress,
    CancelToken? cancelToken,
  }) async {
    await _dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received / total);
        }
      },
    );
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(err.response?.statusCode);
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection.';
        break;
      default:
        message = 'Something went wrong.';
    }

    print('API Error: $message');
    handler.next(err);
  }

  String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Not found.';
      case 500:
        return 'Server error. Try again later.';
      default:
        return 'Error: $statusCode';
    }
  }
}

class AuthInterceptor extends Interceptor {
  String? _token;

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }
}

// Usage Example
void main() async {
  final api = ApiService();

  // Set auth token after login
  api.setAuthToken('user-jwt-token');

  // Get all users
  final users = await api.getUsers();
  print('Got ${users.length} users');

  // Create a user
  final newUser = await api.createUser({
    'name': 'John Doe',
    'email': 'john@example.com',
  });
  print('Created: ${newUser['id']}');

  // Upload file with progress
  await api.uploadFile(
    '/path/to/file.jpg',
    onProgress: (progress) {
      print('Upload: ${(progress * 100).toStringAsFixed(0)}%');
    },
  );

  // Logout
  api.clearAuthToken();
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    DIO COMPLETE CHEAT SHEET                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SETUP:                                                     │
│  ──────                                                     │
│  dependencies:                                              │
│    dio: ^5.4.0                                              │
│                                                             │
│  CREATE INSTANCE:                                           │
│  ────────────────                                           │
│  final dio = Dio(BaseOptions(                               │
│    baseUrl: 'https://api.com',                              │
│    connectTimeout: Duration(seconds: 5),                    │
│    receiveTimeout: Duration(seconds: 3),                    │
│  ));                                                        │
│                                                             │
│  BASIC REQUESTS:                                            │
│  ───────────────                                            │
│  dio.get('/path')                                           │
│  dio.post('/path', data: {...})                             │
│  dio.put('/path', data: {...})                              │
│  dio.patch('/path', data: {...})                            │
│  dio.delete('/path')                                        │
│                                                             │
│  QUERY PARAMS:                                              │
│  ─────────────                                              │
│  dio.get('/path', queryParameters: {'key': 'value'})        │
│                                                             │
│  INTERCEPTORS:                                              │
│  ─────────────                                              │
│  dio.interceptors.add(MyInterceptor());                     │
│  • Add auth tokens automatically                            │
│  • Log requests/responses                                   │
│  • Handle errors globally                                   │
│                                                             │
│  ERROR HANDLING:                                            │
│  ───────────────                                            │
│  on DioException catch (e) {                                │
│    e.type       // connectionTimeout, badResponse, etc.     │
│    e.response   // Server response (if any)                 │
│    e.message    // Error message                            │
│  }                                                          │
│                                                             │
│  CANCELLATION:                                              │
│  ─────────────                                              │
│  final token = CancelToken();                               │
│  dio.get('/path', cancelToken: token);                      │
│  token.cancel();  // Cancel the request                     │
│                                                             │
│  FILE UPLOAD:                                               │
│  ────────────                                               │
│  FormData formData = FormData.fromMap({                     │
│    'file': await MultipartFile.fromFile(path),              │
│  });                                                        │
│  dio.post('/upload', data: formData,                        │
│    onSendProgress: (sent, total) { },                       │
│  );                                                         │
│                                                             │
│  FILE DOWNLOAD:                                             │
│  ──────────────                                             │
│  dio.download(url, savePath,                                │
│    onReceiveProgress: (received, total) { },                │
│  );                                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### What We Learned

1. **Error Types**: 8 different DioException types for specific errors
2. **Request Cancellation**: Stop requests when user navigates away
3. **Upload Progress**: Track file upload with `onSendProgress`
4. **Download Progress**: Track file download with `onReceiveProgress`
5. **Complete Service**: Production-ready API service template
6. **Best Practices**: Combine all features for robust API handling

### Key Takeaways

- **Always use CancelToken** in screens that can be closed during requests
- **Show progress** for uploads/downloads to improve UX
- **Handle errors globally** with interceptors
- **Add auth tokens automatically** with AuthInterceptor
- **Log in development** with LogInterceptor

---

## Quick Quiz

**Q1.** What does `e.type == DioExceptionType.badResponse` tell you?

<details>
<summary>Answer</summary>
The server answered with an error status (4xx or 5xx). Check `e.response?.statusCode` for the exact one.
</details>

**Q2.** What is a `CancelToken` used for?

<details>
<summary>Answer</summary>
To stop a request that is still running, for example when the user leaves the screen, saving data and battery.
</details>

**Q3.** Which callback reports how much of a file has uploaded?

<details>
<summary>Answer</summary>
`onSendProgress: (sent, total) { ... }` (and `onReceiveProgress` for downloads).
</details>

---

## Assignment

### Problem 1: Cancel on exit

In a screen's `dispose`, what should you call so an in-flight request stops?

### Problem 2: Show a percentage

Inside `onSendProgress: (sent, total)`, write the line that computes the percent uploaded (0 to 100).

### Problem 3: Read the error

A request fails with `DioExceptionType.connectionError`. In plain words, what would you tell the user?

---

## Assignment Answers

### Problem 1: Cancel on exit

```dart
@override
void dispose() {
  _cancelToken?.cancel('User left the screen');
  super.dispose();
}
```

### Problem 2: Show a percentage

```dart
double percent = (sent / total) * 100;
```

### Problem 3: Read the error

Something like: "No internet connection. Please check your network and try again." (`connectionError` means the device could not reach the server.)

---

## Next Steps

You now know:
- ✓ Basic http package
- ✓ Dio package fundamentals
- ✓ Interceptors for advanced features
- ✓ Error handling, cancellation, progress tracking

Continue to: [06a-ErrorBasics.md](./06a-ErrorBasics.md) - Master error handling patterns for production apps!

---

[Back to Learning Path](./00-LearningPath.md)

---

## Navigation

⬅️ **Previous:** [Dio Features](05b-DioFeatures.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Error Basics](06a-ErrorBasics.md)
